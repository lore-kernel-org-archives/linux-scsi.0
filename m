From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH v3 3/4] sd: Make synchronize cache upon shutdown
 asynchronous
Date: Tue, 18 Apr 2017 08:56:24 -0700
Message-ID: <1492530984.3306.25.camel@HansenPartnership.com>
References: <20170417173436.15555-1-bart.vanassche@sandisk.com>
         <20170417173436.15555-4-bart.vanassche@sandisk.com>
         <20170418144429.GA28949@bblock-ThinkPad-W530>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:54840 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752748AbdDRP42 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 18 Apr 2017 11:56:28 -0400
In-Reply-To: <20170418144429.GA28949@bblock-ThinkPad-W530>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Benjamin Block <bblock@linux.vnet.ibm.com>, Bart Van Assche <bart.vanassche@sandisk.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, Israel Rukshin <israelr@mellanox.com>, Max Gurtovoy <maxg@mellanox.com>, Hannes Reinecke <hare@suse.de>

On Tue, 2017-04-18 at 16:44 +0200, Benjamin Block wrote:
> Hej Bart,
> 
> sry for the late'ish reply, had a long weekend.
> 
> On Thu, Apr 13, 2017 at 12:28:54AM +0000, Bart Van Assche wrote:
> > On Wed, 2017-04-12 at 16:41 +0200, Benjamin Block wrote:
> > > On Mon, Apr 10, 2017 at 10:54:01AM -0700, Bart Van Assche wrote:
> > > > [ ... ]
> > > OK, so I take it the problem is when the queue is stopped, then 
> > > the completion in blk_execute_rq() will never be triggered and 
> > > then we wait for a timeout there, or potentially forever?
> > 
> > Hello Benjamin,
> > 
> > Thanks for the review.
> > 
> > If a request is queued after a queue has been stopped then that 
> > request will never be started and hence even the timeout timer 
> > won't be started. blk_cleanup_queue() hangs if invoked for a 
> > stopped queue and one or more requests have not yet been started.
> > 
> > > But then what is the point in trying to do it async here anyway? 
> > > Won't that just be doomed in the same way, just that we don't see 
> > > the effect?
> > 
> > Have you noticed that patch 4/4 in this series restarts the queue 
> > just before calling blk_cleanup_queue()?
> > 
> > Anyway, can you have a look at the patch below and see whether this 
> > new version addresses all the concerns you had reported in your
> > previous e-mail?
> > 
> 
> Yes, the code- and comment-changes in sd_shutdown() are good. 
> Apparently there is something new with the done-function now, but you 
> got that from Israel.
> 
> I still wonder why we try 'so hard' scheduling a command for a dead
> device, but as that seems to be the status quo, and only lacks in the
> case where the LLD is already half-way gone, its ok for me too. I 
> mean, the order is a bit screwed.. we apparently first remove the 
> driver and post-factum try to drain the queue.. that is strange.

Yes, I've said all along that adding asynchronicity is only going to
add more problems.

The priority has got to be the removal we've been ordered to do rather
than waiting around to see if the transport comes back so we can send a
final flush.

How about this approach.  It goes straight to DEL if the device is
blocked (skipping CANCEL).  This means that all the commands issued in 
->shutdown will error in the mid-layer, thus making the removal proceed
without being stopped.

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
index 82dfe07b1d47..788309e307e9 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -1282,8 +1282,14 @@ void __scsi_remove_device(struct scsi_device *sdev)
 		return;
 
 	if (sdev->is_visible) {
+		/*
+		 * If blocked, we go straight to DEL so any commands
+		 * issued during the driver shutdown (like sync cache)
+		 * are errored
+		 */
 		if (scsi_device_set_state(sdev, SDEV_CANCEL) != 0)
-			return;
+			if (scsi_device_set_state(sdev, SDEV_DEL) != 0)
+				return;
 
 		bsg_unregister_queue(sdev->request_queue);
 		device_unregister(&sdev->sdev_dev);
