From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 02/10] scsi: add wrapper functions for sg buffer copy helper functions
Date: Sun,  9 Mar 2008 13:44:29 +0900
Message-ID: <1205037877-12843-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1205037877-12843-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1205037877-12843-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo10.iij4u.or.jp ([210.138.174.78]:47271 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751023AbYCIEqD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 8 Mar 2008 23:46:03 -0500
In-Reply-To: <1205037877-12843-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: tomof@acm.org, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, James Bottomley <James.Bottomley@HansenPartnership.com>

LLDs need to copies data between the SG table in struct scsi_cmnd and
liner buffer. So they use the helper functions like

sg_copy_from_buffer(scsi_sglist(sc), scsi_sg_count(sc), buf, buflen)
sg_copy_to_buffer(scsi_sglist(sc), scsi_sg_count(sc), buf, buflen)

This patch just adds wrapper functions:

scsi_sg_copy_from_buffer(sc, buf, buflen)
scsi_sg_copy_to_buffer(sc, buf, buflen)

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
---
 include/scsi/scsi_cmnd.h |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index de28aab..b260be6 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -175,4 +175,18 @@ static inline struct scsi_data_buffer *scsi_out(struct scsi_cmnd *cmd)
 	return &cmd->sdb;
 }
 
+static inline int scsi_sg_copy_from_buffer(struct scsi_cmnd *cmd,
+					   void *buf, int buflen)
+{
+	return sg_copy_from_buffer(scsi_sglist(cmd), scsi_sg_count(cmd),
+				   buf, buflen);
+}
+
+static inline int scsi_sg_copy_to_buffer(struct scsi_cmnd *cmd,
+					 void *buf, int buflen)
+{
+	return sg_copy_to_buffer(scsi_sglist(cmd), scsi_sg_count(cmd),
+				 buf, buflen);
+}
+
 #endif /* _SCSI_SCSI_CMND_H */
-- 
1.5.3.7

