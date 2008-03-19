From: Kay Sievers <kay.sievers@vrfy.org>
Subject: [PATCH] fix media change events for polled devices
Date: Wed, 19 Mar 2008 13:04:47 +0100
Message-ID: <1205928287.8810.18.camel@lov.site>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:54836 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765293AbYCSVQL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 19 Mar 2008 17:16:11 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: scsi <linux-scsi@vger.kernel.org>, David Zeuthen <david@fubar.dk>, kristen accardi <kaccardi@gmail.com>, Jeff Garzik <jeff@garzik.org>

Hi James,
we like to see this in 2.6.25, as "change" events for polled devices are
broken at the moment.

Thanks,
Kay


From: Kay Sievers <kay.sievers@vrfy.org>
Subject: [SCSI] fix media change events for polled devices

Commit:
  a341cd0f (SCSI: add asynchronous event notification API)
breaks:
  285e9670 (sr,sd: send media state change modification events)
by introducing an event filter, which is removed here, to make
events, we are depending on, happen again.

Cc: David Zeuthen <david@fubar.dk>
Cc: kristen accardi <kaccardi@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
---

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index ba21d97..ad1dc03 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2162,11 +2162,6 @@ void sdev_evt_send(struct scsi_device *sdev, struct scsi_event *evt)
 {
 	unsigned long flags;
 
-	if (!test_bit(evt->evt_type, sdev->supported_events)) {
-		kfree(evt);
-		return;
-	}
-
 	spin_lock_irqsave(&sdev->list_lock, flags);
 	list_add_tail(&evt->node, &sdev->event_list);
 	schedule_work(&sdev->event_work);


