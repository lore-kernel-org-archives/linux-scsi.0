From: Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH v2 10/24] uas: zap_pending: data urbs should have completed at this time
Date: Sat, 13 Sep 2014 12:26:37 +0200
Message-ID: <1410604011-3828-11-git-send-email-hdegoede@redhat.com>
References: <1410604011-3828-1-git-send-email-hdegoede@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:17626 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752062AbaIMK1N (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 13 Sep 2014 06:27:13 -0400
In-Reply-To: <1410604011-3828-1-git-send-email-hdegoede@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>

The data urbs are all killed before calling zap_pending, and their completion
handler should have cleared their inflight flag.

Do not 0 the data inflight flags, and add a check for try_complete succeeding,
as it should always succeed when called from zap_pending.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/usb/storage/uas.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
index 08edb6b..85bbc1d 100644
--- a/drivers/usb/storage/uas.c
+++ b/drivers/usb/storage/uas.c
@@ -145,6 +145,7 @@ static void uas_zap_pending(struct uas_dev_info *devinfo, int result)
 	struct uas_cmd_info *cmdinfo;
 	struct uas_cmd_info *temp;
 	unsigned long flags;
+	int err;
 
 	spin_lock_irqsave(&devinfo->lock, flags);
 	list_for_each_entry_safe(cmdinfo, temp, &devinfo->dead_list, list) {
@@ -152,12 +153,11 @@ static void uas_zap_pending(struct uas_dev_info *devinfo, int result)
 		struct scsi_cmnd *cmnd = container_of(scp, struct scsi_cmnd,
 						      SCp);
 		uas_log_cmd_state(cmnd, __func__);
-		/* all urbs are killed, clear inflight bits */
-		cmdinfo->state &= ~(COMMAND_INFLIGHT |
-				    DATA_IN_URB_INFLIGHT |
-				    DATA_OUT_URB_INFLIGHT);
+		/* Sense urbs were killed, clear COMMAND_INFLIGHT manually */
+		cmdinfo->state &= ~COMMAND_INFLIGHT;
 		cmnd->result = result << 16;
-		uas_try_complete(cmnd, __func__);
+		err = uas_try_complete(cmnd, __func__);
+		WARN_ON(err != 0);
 	}
 	spin_unlock_irqrestore(&devinfo->lock, flags);
 }
-- 
2.1.0

