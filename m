From: "Hugh Daschbach" <hdasch@broadcom.com>
Subject: RE: System reboot hangs due to race against devices_kset->list
 triggered by SCSI FC workqueue
Date: Thu, 4 Mar 2010 14:32:52 -0800
Message-ID: <233671224A0FED4688218FFDBED26E1A5181BF12E4@IRVEXCHCCR01.corp.ad.broadcom.com>
References: <233671224A0FED4688218FFDBED26E1A5181BF12D1@IRVEXCHCCR01.corp.ad.broadcom.com>
 <Pine.LNX.4.44L0.1003041420510.1742-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4714 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754525Ab0CDWdF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Mar 2010 17:33:05 -0500
In-Reply-To: <Pine.LNX.4.44L0.1003041420510.1742-100000@iolanthe.rowland.org>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg KH <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>, Jan Blunck <jblunck@suse.de>, David Vrabel <david.vrabel@csr.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, james Bottomley <James.Bottomley@suse.de>, James Smart <james.smart@emulex.com>

Alan Stern [mailto:stern@rowland.harvard.edu] writes:

> On Thu, 4 Mar 2010, Hugh Daschbach wrote:
>
>> Is there some way I can detect that devn no longer points to a valid
>> device upon return from dev->*->shutdown(dev)?  Or, where else can I
>> look to better understand your suggestion?
>
> Did you read the patch in my previous message?  You didn't quote it.  
> It removes the devn variable, so the problem you're worried about
> cannot occur.
>
> Alan Stern

Mea culpa.  I looked but did not see.  I have tested your patch.  It
does solve my problem.  I've attached my version, with comments as you
suggested, below.

I have added get_device()/put_device() to ensure there's the device
hasn't fully disappeared before calling list_del_init().  Is this
needed?  If so, there's "might_sleep()" commented out in put_device().
Do I need to release the lock before calling put_device()?

Thanks for you patience.

Hugh

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 2820257..1133d7a 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -1731,10 +1731,20 @@ EXPORT_SYMBOL_GPL(device_move);
  */
 void device_shutdown(void)
 {
-	struct device *dev, *devn;
+	struct device *dev;
+
+	spin_lock(&devices_kset->list_lock);
+	/* 
+	 * Walk the devices list backward, shutting down each in turn.
+	 * Beware that device unplug events may also start pulling
+	 * devices offline, even as the system is shutting down.
+	 */
+	while (!list_empty(&devices_kset->list)) {
+		dev = list_entry(devices_kset->list.prev, struct device,
+				kobj.entry);
+		get_device(dev);
+		spin_unlock(&devices_kset->list_lock);
 
-	list_for_each_entry_safe_reverse(dev, devn, &devices_kset->list,
-				kobj.entry) {
 		if (dev->bus && dev->bus->shutdown) {
 			dev_dbg(dev, "shutdown\n");
 			dev->bus->shutdown(dev);
@@ -1742,6 +1752,15 @@ void device_shutdown(void)
 			dev_dbg(dev, "shutdown\n");
 			dev->driver->shutdown(dev);
 		}
+
+		/*
+		 * Make sure the device iss off the kset list, in the
+		 * event that dev->*->shutdown() didn't remove it.
+		 */
+		spin_lock(&devices_kset->list_lock);
+		list_del_init(&dev->kobj.entry);
+		put_device(dev);
 	}
+	spin_unlock(&devices_kset->list_lock);
 	async_synchronize_full();
 }

