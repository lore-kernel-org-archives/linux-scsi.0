From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 25/26] qla2xxx: Get FLT address in dword format.
Date: Tue, 24 Mar 2009 09:08:19 -0700
Message-ID: <1237910900-30817-26-git-send-email-andrew.vasquez@qlogic.com>
References: <1237910900-30817-1-git-send-email-andrew.vasquez@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:29874 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762373AbZCXQIq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Mar 2009 12:08:46 -0400
In-Reply-To: <1237910900-30817-1-git-send-email-andrew.vasquez@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, Harish Zunjarrao <harish.zunjarrao@qlogic.com>

From: Harish Zunjarrao <harish.zunjarrao@qlogic.com>

FLTDS provides FLT address in the byte address format,
convert it to dword address for further use.

Signed-off-by: Harish Zunjarrao <harish.zunjarrao@qlogic.com>
Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_sup.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_sup.c b/drivers/scsi/qla2xxx/qla_sup.c
index 0664667..152ecfc 100644
--- a/drivers/scsi/qla2xxx/qla_sup.c
+++ b/drivers/scsi/qla2xxx/qla_sup.c
@@ -612,8 +612,8 @@ qla2xxx_find_flt_start(scsi_qla_host_t *vha, uint32_t *start)
 
 	/* Good data.  Use specified location. */
 	loc = locations[1];
-	*start = le16_to_cpu(fltl->start_hi) << 16 |
-	    le16_to_cpu(fltl->start_lo);
+	*start = (le16_to_cpu(fltl->start_hi) << 16 |
+	    le16_to_cpu(fltl->start_lo)) >> 2;
 end:
 	DEBUG2(qla_printk(KERN_DEBUG, ha, "FLTL[%s] = 0x%x.\n", loc, *start));
 	return QLA_SUCCESS;
-- 
1.6.2.rc0.55.g30aa4f

