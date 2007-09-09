From: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH 12/22] advansys: Remove a check for an impossible condition
Date: Sun,  9 Sep 2007 08:56:37 -0600
Message-ID: <11893498072714-git-send-email-matthew@wil.cx>
References: <20070909145358.GG6809@parisc-linux.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.tor.primus.ca ([216.254.136.21]:45163 "EHLO
	mail-07.primus.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757250AbXIIO4s (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 9 Sep 2007 10:56:48 -0400
In-Reply-To: <20070909145358.GG6809@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Matthew Wilcox <matthew@wil.cx>

AscExeScsiQueue() has one caller, and it passes the address of a
variable; this cannot ever be NULL.  This is the only place that ever
sets ASCQ_ERR_SCSIQ_NULL_PTR, so delete that error code too, as well as
several other unused ASCQ_ERR codes.

Signed-off-by: Matthew Wilcox <matthew@wil.cx>
---
 drivers/scsi/advansys.c |   12 ------------
 1 files changed, 0 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index ef4f679..60a9188 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -520,14 +520,6 @@ typedef struct asc_risc_sg_list_q {
 #define ASCQ_ERR_ISR_RE_ENTRY         0x1A
 #define ASCQ_ERR_CRITICAL_RE_ENTRY    0x1B
 #define ASCQ_ERR_ISR_ON_CRITICAL      0x1C
-#define ASCQ_ERR_SG_LIST_ODD_ADDRESS  0x1D
-#define ASCQ_ERR_XFER_ADDRESS_TOO_BIG 0x1E
-#define ASCQ_ERR_SCSIQ_NULL_PTR       0x1F
-#define ASCQ_ERR_SCSIQ_BAD_NEXT_PTR   0x20
-#define ASCQ_ERR_GET_NUM_OF_FREE_Q    0x21
-#define ASCQ_ERR_SEND_SCSI_Q          0x22
-#define ASCQ_ERR_HOST_REQ_RISC_HALT   0x23
-#define ASCQ_ERR_RESET_SDTR           0x24
 
 /*
  * Warning code values are set in ASC_DVC_VAR  'warn_code'.
@@ -7578,10 +7570,6 @@ static int AscExeScsiQueue(ASC_DVC_VAR *asc_dvc, ASC_SCSI_Q *scsiq)
 	sg_head = scsiq->sg_head;
 	if (asc_dvc->err_code != 0)
 		return (ERR);
-	if (scsiq == (ASC_SCSI_Q *)0L) {
-		AscSetLibErrorCode(asc_dvc, ASCQ_ERR_SCSIQ_NULL_PTR);
-		return (ERR);
-	}
 	scsiq->q1.q_no = 0;
 	if ((scsiq->q2.tag_code & ASC_TAG_FLAG_EXTRA_BYTES) == 0) {
 		scsiq->q1.extra_bytes = 0;
-- 
1.5.2.4

