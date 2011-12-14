From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 1/2] usb/uas: fix support on HS (device without command tagging)
Date: Wed, 14 Dec 2011 19:47:51 +0100
Message-ID: <1323888472-21035-2-git-send-email-bigeasy@linutronix.de>
References: <1323888472-21035-1-git-send-email-bigeasy@linutronix.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from www.linutronix.de ([62.245.132.108]:34278 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757839Ab1LNSrK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Dec 2011 13:47:10 -0500
In-Reply-To: <1323888472-21035-1-git-send-email-bigeasy@linutronix.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: Matthew Wilcox <willy@linux.intel.com>, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, Sebastian Andrzej Siewior <bigeasy@linutronix.de>

Right now UAS can not handle HS devices. This patch tries to fix this.
On SS and HS we take the command tag increment it by one and assign it
as the stream_id. This number is used to compare the tag number.
This tag number is later used to find the matching command struct. On SS
we could use urb->stream_id but this way the code flow is the same.
Untagged commands are stashed in ->current_cmd. Once such a command is
in process no other commands are allowed.
What I observed so far is that the first command (INQUIRY) checked if
command tagging is supporteed by the device or not. If so, all further
commands are tagged, if not none are. So the assumption here is if
->current_cmd is available then take it else go by tag the number.
Things will break apart if the initiator mixes tagged & untagged
commands.

With this patch things work for me on HS-UASP without command tagging.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/usb/storage/uas.c |   21 +++++++++++----------
 1 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
index 680bea9..97f969c 100644
--- a/drivers/usb/storage/uas.c
+++ b/drivers/usb/storage/uas.c
@@ -232,13 +232,16 @@ static void uas_stat_cmplt(struct urb *urb)
 		return;
 	}
 
-	tag = be16_to_cpup(&iu->tag) - 1;
-	if (sdev->current_cmnd)
-		cmnd = sdev->current_cmnd;
-	else
-		cmnd = scsi_find_tag(sdev, tag);
-	if (!cmnd)
+	cmnd = sdev->current_cmnd;
+	if (!cmnd) {
+		tag = be16_to_cpup(&iu->tag);
+		cmnd = scsi_find_tag(sdev, tag - 1);
+	}
+	if (!cmnd) {
+		dev_err(&urb->dev->dev, "Missing cmd for status URB\n");
+		usb_free_urb(urb);
 		return;
+	}
 
 	switch (iu->iu_id) {
 	case IU_ID_STATUS:
@@ -449,7 +452,7 @@ static int uas_queuecommand_lck(struct scsi_cmnd *cmnd,
 
 	BUILD_BUG_ON(sizeof(struct uas_cmd_info) > sizeof(struct scsi_pointer));
 
-	if (!cmdinfo->status_urb && sdev->current_cmnd)
+	if (sdev->current_cmnd)
 		return SCSI_MLQUEUE_DEVICE_BUSY;
 
 	if (blk_rq_tagged(cmnd->request)) {
@@ -476,10 +479,8 @@ static int uas_queuecommand_lck(struct scsi_cmnd *cmnd,
 		break;
 	}
 
-	if (!devinfo->use_streams) {
+	if (!devinfo->use_streams)
 		cmdinfo->state &= ~(SUBMIT_DATA_IN_URB | SUBMIT_DATA_OUT_URB);
-		cmdinfo->stream = 0;
-	}
 
 	err = uas_submit_urbs(cmnd, devinfo, GFP_ATOMIC);
 	if (err) {
-- 
1.7.7.3

