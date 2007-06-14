From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 1/3] Restrict scsi accessors access to read-only
Date: Thu, 14 Jun 2007 19:33:23 +0300
Message-ID: <46716DD3.1030501@panasas.com>
References: <466EDFAC.9020104@panasas.com>	<20070613085118P.fujita.tomonori@lab.ntt.co.jp>	<E472128B1EB43941B4E7FB268020C89B0250B912@riverside.int.panasas.com> <20070613194513H.fujita.tomonori@lab.ntt.co.jp> <46716C45.1090107@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-e.panasas.com ([65.194.124.178]:57207 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751074AbXFNQdg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Jun 2007 12:33:36 -0400
In-Reply-To: <46716C45.1090107@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Ed Lin <ed.lin@promise.com>, Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-scsi@vger.kernel.org

>From 33dff41f5aaa05efd4aca80e12be4aaf4692a113 Mon Sep 17 00:00:00 2001
From: Boaz Harrosh <bharrosh@bh-buildlin2.(none)>
Date: Thu, 14 Jun 2007 18:55:18 +0300
Subject: [PATCH] Restrict scsi accessors access to read-only

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
1.5.0.4.402.g8035


