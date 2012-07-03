From: Tomas Henzl <thenzl@redhat.com>
Subject: [PATCH] bnx2i: fix the bit manipulation when setting the error mask
Date: Tue, 03 Jul 2012 10:08:41 +0200
Message-ID: <4FF2A889.30102@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:30802 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755999Ab2GCIIp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 3 Jul 2012 04:08:45 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>
Cc: eddie.wai@broadcom.com, "'James.Bottomley@HansenPartnership.com'" <James.Bottomley@HansenPartnership.com>, mchan@broadcom.com

The intention in bnx2i_send_fw_iscsi_init_msg was to zero out
only the lower 32bits, but instead the whole mask64 is zeroed.
This patch fixes it.

Signed-off-by: Tomas Henzl <thenzl@redhat.com>
---
diff --git a/drivers/scsi/bnx2i/bnx2i_hwi.c b/drivers/scsi/bnx2i/bnx2i_hwi.c
index ece47e5..1cbf402 100644
--- a/drivers/scsi/bnx2i/bnx2i_hwi.c
+++ b/drivers/scsi/bnx2i/bnx2i_hwi.c
@@ -1314,7 +1314,7 @@ int bnx2i_send_fw_iscsi_init_msg(struct bnx2i_hba *hba)
 		(1ULL << ISCSI_KCQE_COMPLETION_STATUS_PROTOCOL_ERR_LUN));
 	if (error_mask1) {
 		iscsi_init2.error_bit_map[0] = error_mask1;
-		mask64 &= (u32)(~mask64);
+		mask64 ^= (u32)(mask64);
 		mask64 |= error_mask1;
 	} else
 		iscsi_init2.error_bit_map[0] = (u32) mask64;


