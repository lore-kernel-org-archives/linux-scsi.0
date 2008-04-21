From: Adrian Bunk <bunk@kernel.org>
Subject: [2.6 patch] make qla2x00_issue_iocb_timeout() static
Date: Mon, 21 Apr 2008 11:49:46 +0300
Message-ID: <20080421084946.GW26897@cs181133002.pp.htv.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp5.pp.htv.fi ([213.243.153.39]:58418 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757136AbYDUIuO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Apr 2008 04:50:14 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Harihara Kadayam <harihara.kadayam@qlogic.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

This patch makes the needlessly global qla2x00_issue_iocb_timeout() 
static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
 drivers/scsi/qla2xxx/qla_gbl.h |    4 ----
 drivers/scsi/qla2xxx/qla_mbx.c |    2 +-
 2 files changed, 1 insertion(+), 5 deletions(-)

ab0e24892984c1327b66d640805c32cc8e93ef1f diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index a9571c2..baceaea 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -152,10 +152,6 @@ extern int
 qla2x00_issue_iocb(scsi_qla_host_t *, void *, dma_addr_t, size_t);
 
 extern int
-qla2x00_issue_iocb_timeout(scsi_qla_host_t *, void *, dma_addr_t, size_t,
-    uint32_t);
-
-extern int
 qla2x00_abort_command(scsi_qla_host_t *, srb_t *);
 
 extern int
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 7d0a8a4..61229e8 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -681,7 +681,7 @@ qla2x00_verify_checksum(scsi_qla_host_t *ha, uint32_t risc_addr)
  * Context:
  *	Kernel context.
  */
-int
+static int
 qla2x00_issue_iocb_timeout(scsi_qla_host_t *ha, void *buffer,
     dma_addr_t phys_addr, size_t size, uint32_t tov)
 {

