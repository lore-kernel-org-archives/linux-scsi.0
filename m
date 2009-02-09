From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 4/6] qla2xxx: Mask out 'reserved' bits while processing FLT regions.
Date: Sun,  8 Feb 2009 20:50:14 -0800
Message-ID: <1234155016-6215-5-git-send-email-andrew.vasquez@qlogic.com>
References: <1234155016-6215-1-git-send-email-andrew.vasquez@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:7132 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753907AbZBIEuV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 8 Feb 2009 23:50:21 -0500
In-Reply-To: <1234155016-6215-1-git-send-email-andrew.vasquez@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Linux SCSI Mailing List <linux-scsi@vger.kernel.org>

Bits 31-8 are marked as reserved and should be ignored while
interpreting a region's code.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_sup.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_sup.c b/drivers/scsi/qla2xxx/qla_sup.c
index 9c3b694..2848279 100644
--- a/drivers/scsi/qla2xxx/qla_sup.c
+++ b/drivers/scsi/qla2xxx/qla_sup.c
@@ -684,7 +684,7 @@ qla2xxx_get_flt_info(scsi_qla_host_t *vha, uint32_t flt_addr)
 		    "end=0x%x size=0x%x.\n", le32_to_cpu(region->code), start,
 		    le32_to_cpu(region->end) >> 2, le32_to_cpu(region->size)));
 
-		switch (le32_to_cpu(region->code)) {
+		switch (le32_to_cpu(region->code) & 0xff) {
 		case FLT_REG_FW:
 			ha->flt_region_fw = start;
 			break;
-- 
1.6.1.48.ge9b8

