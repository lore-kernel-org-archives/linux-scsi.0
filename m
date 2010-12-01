From: Hillf Danton <dhillf@gmail.com>
Subject: [PATCH] add regulation of BLK_EH_RESET_TIMER for block request
Date: Wed, 1 Dec 2010 22:40:27 +0800
Message-ID: <AANLkTin_94J_eu5raDsPXTUJy7EbkUWuG_d8_xEn3Gzh@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, devel@open-fcoe.org
List-Id: linux-scsi@vger.kernel.org

When timer run, if BLK_EH_RESET_TIMER returned by LLD, the retries of
block request, though defined, is not checked in both scsi middle
later and block layer.

Regulation of BLK_EH_RESET_TIMER could help LLD fiddle timer in
reasonable manner.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
---

--- a/drivers/scsi/scsi_error.c	2010-11-01 19:54:12.000000000 +0800
+++ b/drivers/scsi/scsi_error.c	2010-12-01 22:26:36.000000000 +0800
@@ -138,8 +138,15 @@ enum blk_eh_timer_return scsi_times_out(
 	else if (scmd->device->host->hostt->eh_timed_out)
 		rtn = scmd->device->host->hostt->eh_timed_out(scmd);

+	if (rtn == BLK_EH_RESET_TIMER)
+		if (req->retries-- > 0)
+			return rtn;
+		else
+			goto handled;
+
 	if (unlikely(rtn == BLK_EH_NOT_HANDLED &&
 		     !scsi_eh_scmd_add(scmd, SCSI_EH_CANCEL_CMD))) {
+ handled:
 		scmd->result |= DID_TIME_OUT << 16;
 		rtn = BLK_EH_HANDLED;
 	}
