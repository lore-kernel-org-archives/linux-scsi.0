From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] fix media change events for polled devices
Date: Wed, 19 Mar 2008 11:54:02 -0500
Message-ID: <1205945642.11527.23.camel@localhost.localdomain>
References: <1205928287.8810.18.camel@lov.site>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:52638 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753121AbYCSTYw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 Mar 2008 15:24:52 -0400
In-Reply-To: <1205928287.8810.18.camel@lov.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: scsi <linux-scsi@vger.kernel.org>, David Zeuthen <david@fubar.dk>, kristen accardi <kaccardi@gmail.com>, Jeff Garzik <jeff@garzik.org>

On Wed, 2008-03-19 at 13:04 +0100, Kay Sievers wrote:
> Hi James,
> we like to see this in 2.6.25, as "change" events for polled devices are
> broken at the moment.

I'm not happy just killing the code, since when the AN infrastructure
gets fixed, it will work.  How about this instead as a fix for 2.6.25?

Also, acks from Jeff and Kristin would be nice.

James

---
>From 4d1566ed2100d074ccc654e5cf2e44cdea3a01d0 Mon Sep 17 00:00:00 2001
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Wed, 19 Mar 2008 13:04:47 +0100
Subject: [SCSI] fix media change events for polled devices

Commit:
  a341cd0f (SCSI: add asynchronous event notification API)
breaks:
  285e9670 (sr,sd: send media state change modification events)
by introducing an event filter, which is removed here, to make
events, we are depending on, happen again.

Fix this by removing the event filter.  It's pretty much broken at the
moment, since a user can't set it (the attribute being read only).  A
proper fix will be to make the event discriminator distinguish between
AN and Polled media change events.

Cc: David Zeuthen <david@fubar.dk>
Cc: kristen accardi <kaccardi@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
---
 drivers/scsi/scsi_lib.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index ba21d97..f40898d 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2162,10 +2162,15 @@ void sdev_evt_send(struct scsi_device *sdev, struct scsi_event *evt)
 {
 	unsigned long flags;
 
+#if 0
+	/* FIXME: currently this check eliminates all media change events
+	 * for polled devices.  Need to update to discriminate between AN
+	 * and polled events */
 	if (!test_bit(evt->evt_type, sdev->supported_events)) {
 		kfree(evt);
 		return;
 	}
+#endif
 
 	spin_lock_irqsave(&sdev->list_lock, flags);
 	list_add_tail(&evt->node, &sdev->event_list);
-- 
1.5.4.1




