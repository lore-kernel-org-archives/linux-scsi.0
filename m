From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] mpt2sas: fix the incorrect scsi_dma_map error checking
Date: Tue, 9 Mar 2010 11:09:50 +0900
Message-ID: <20100309110916T.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:46302 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756232Ab0CICKC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 8 Mar 2010 21:10:02 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kashyap.Desai@lsi.com
Cc: James.Bottomley@suse.de, linux-scsi@vger.kernel.org

scsi_dma_map() returns -1 if an error occurred (zero means that the
command has no data). So the following current code can't catch an
error:

sges_left = scsi_dma_map(scmd);
if (!sges_left) {
	sdev_printk(KERN_ERR, scmd->device, "pci_map_sg"
	" failed: request for %d bytes!\n", scsi_bufflen(scmd));
	return -ENOMEM;
}

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/scsi/mpt2sas/mpt2sas_scsih.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
index c7ec3f1..99d189d 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -987,7 +987,7 @@ _scsih_build_scatter_gather(struct MPT2SAS_ADAPTER *ioc,
 	u32 chain_offset;
 	u32 chain_length;
 	u32 chain_flags;
-	u32 sges_left;
+	int sges_left;
 	u32 sges_in_segment;
 	u32 sgl_flags;
 	u32 sgl_flags_last_element;
@@ -1008,7 +1008,7 @@ _scsih_build_scatter_gather(struct MPT2SAS_ADAPTER *ioc,
 
 	sg_scmd = scsi_sglist(scmd);
 	sges_left = scsi_dma_map(scmd);
-	if (!sges_left) {
+	if (sges_left < 0) {
 		sdev_printk(KERN_ERR, scmd->device, "pci_map_sg"
 		" failed: request for %d bytes!\n", scsi_bufflen(scmd));
 		return -ENOMEM;
-- 
1.6.5

