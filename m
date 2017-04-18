From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH v3 3/4] sd: Make synchronize cache upon shutdown
 asynchronous
Date: Tue, 18 Apr 2017 16:56:12 -0700
Message-ID: <1492559772.3306.58.camel@HansenPartnership.com>
References: <20170417173436.15555-1-bart.vanassche@sandisk.com>
         <20170417173436.15555-4-bart.vanassche@sandisk.com>
         <20170418144429.GA28949@bblock-ThinkPad-W530>
         <1492530984.3306.25.camel@HansenPartnership.com>
         <1492559235.2689.27.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:59724 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753789AbdDRX4O (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 18 Apr 2017 19:56:14 -0400
In-Reply-To: <1492559235.2689.27.camel@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@sandisk.com>, "bblock@linux.vnet.ibm.com" <bblock@linux.vnet.ibm.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "maxg@mellanox.com" <maxg@mellanox.com>, "israelr@mellanox.com" <israelr@mellanox.com>, "hare@suse.de" <hare@suse.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>

On Tue, 2017-04-18 at 23:47 +0000, Bart Van Assche wrote:
> On Tue, 2017-04-18 at 08:56 -0700, James Bottomley wrote:
> > How about this approach.  It goes straight to DEL if the device is
> > blocked (skipping CANCEL).  This means that all the commands issued
> > in 
> > ->shutdown will error in the mid-layer, thus making the removal
> > proceed
> > without being stopped.
> 
> Hello James,
> 
> The three attached patches pass my tests. Please let me know how you 
> would like to proceed with patch 1/3. Would you like to submit it 
> yourself or is it OK for you if I mention you as author and add your
> Signed-off-by?

Actually, I think 3/3 is wrong.  You need to start the queue as soon as
we see it's blocked and the device has gone into DEL.  This is safe
because DEL ensures nothing ever gets from the generic request function
to queuecommand, so the device driver never sees anything.

This means the combined 1/3 3/3 patch looks like this:

James

---

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index e5a2d590a104..31171204cfd1 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2611,7 +2611,6 @@ scsi_device_set_state(struct scsi_device *sdev, enum scsi_device_state state)
 		case SDEV_QUIESCE:
 		case SDEV_OFFLINE:
 		case SDEV_TRANSPORT_OFFLINE:
-		case SDEV_BLOCK:
 			break;
 		default:
 			goto illegal;
@@ -2625,6 +2624,7 @@ scsi_device_set_state(struct scsi_device *sdev, enum scsi_device_state state)
 		case SDEV_OFFLINE:
 		case SDEV_TRANSPORT_OFFLINE:
 		case SDEV_CANCEL:
+		case SDEV_BLOCK:
 		case SDEV_CREATED_BLOCK:
 			break;
 		default:
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 82dfe07b1d47..e477f95bf169 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -1282,8 +1282,17 @@ void __scsi_remove_device(struct scsi_device *sdev)
 		return;
 
 	if (sdev->is_visible) {
-		if (scsi_device_set_state(sdev, SDEV_CANCEL) != 0)
-			return;
+		/*
+		 * If blocked, we go straight to DEL so any commands
+		 * issued during the driver shutdown (like sync cache)
+		 * are errored
+		 */
+		if (scsi_device_set_state(sdev, SDEV_CANCEL) != 0) {
+			if (scsi_device_set_state(sdev, SDEV_DEL) != 0)
+				return;
+			else
+				scsi_start_queue(sdev);
+		}
 
 		bsg_unregister_queue(sdev->request_queue);
 		device_unregister(&sdev->sdev_dev);
