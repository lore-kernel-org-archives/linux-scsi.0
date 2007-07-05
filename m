From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [RFC 2/8] Restrict scsi accessors access to read-only
Date: Thu, 05 Jul 2007 16:43:29 +0300
Message-ID: <468CF581.5050106@panasas.com>
References: <468CDB3C.4060500@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:27059 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757501AbXGENnt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Jul 2007 09:43:49 -0400
In-Reply-To: <468CDB3C.4060500@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Andrew Morton <akpm@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>


- Users of scsi_cmnd might not change sg_count bufflen or sglist.
  So reflect that in code.
---
 include/scsi/scsi_cmnd.h |   17 ++++++++++++++---
 1 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index 53e1705..aaf8282 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -138,9 +138,20 @@ extern void scsi_free_sgtable(struct scatterlist *, int);
 extern int scsi_dma_map(struct scsi_cmnd *cmd);
 extern void scsi_dma_unmap(struct scsi_cmnd *cmd);
 
-#define scsi_sg_count(cmd) ((cmd)->use_sg)
-#define scsi_sglist(cmd) ((struct scatterlist *)(cmd)->request_buffer)
-#define scsi_bufflen(cmd) ((cmd)->request_bufflen)
+static inline unsigned scsi_sg_count(struct scsi_cmnd *cmd)
+{
+	return cmd->use_sg;
+}
+
+static inline struct scatterlist *scsi_sglist(struct scsi_cmnd *cmd)
+{
+	return (struct scatterlist *)cmd->request_buffer;
+}
+
+static inline unsigned scsi_bufflen(struct scsi_cmnd *cmd)
+{
+	return cmd->request_bufflen;
+}
 
 static inline void scsi_set_resid(struct scsi_cmnd *cmd, int resid)
 {
-- 
1.5.2.2.249.g45fd


