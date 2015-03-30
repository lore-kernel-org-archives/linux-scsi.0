From: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Subject: [PATCH 15/20] [SCSI] mpt3sas: Return host busy error status to SML when DMA mapping of scatter gather list fails for a SCSI command
Date: Mon, 30 Mar 2015 19:25:18 +0530
Message-ID: <1427723723-12676-16-git-send-email-Sreekanth.Reddy@avagotech.com>
References: <1427723723-12676-1-git-send-email-Sreekanth.Reddy@avagotech.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1427723723-12676-1-git-send-email-Sreekanth.Reddy@avagotech.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@kernel.org, hch@infradead.org
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, JBottomley@Parallels.com, Sathya.Prakash@avagotech.com, kashyap.desai@avagotech.com, linux-kernel@vger.kernel.org, thenzl@redhat.com, Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>
List-Id: linux-scsi@vger.kernel.org

scsi_dma_map API will return a negative value (i.e. -ENOMEM) if DMA mapping of sg lists fails and zero if the sg list in the SCSI cmd is NULL. But drivers doesn't handled sg list DMA mapping failure case properly.

So, Updated the code to return host busy error status to SCSI MID Layer (SML), when DMA mapping of scatter gather list fails for a SCSI command. So that SML will retry this SCSI cmd after some time.

Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 267e489..0b26c8d 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -1345,7 +1345,7 @@ _base_build_sg_scmd_ieee(struct MPT3SAS_ADAPTER *ioc,
 
 	sg_scmd = scsi_sglist(scmd);
 	sges_left = scsi_dma_map(scmd);
-	if (!sges_left) {
+	if (!sges_left < 0) {
 		sdev_printk(KERN_ERR, scmd->device,
 			"pci_map_sg failed: request for %d bytes!\n",
 			scsi_bufflen(scmd));
@@ -1414,7 +1414,7 @@ _base_build_sg_scmd_ieee(struct MPT3SAS_ADAPTER *ioc,
  fill_in_last_segment:
 
 	/* fill the last segment */
-	while (sges_left) {
+	while (sges_left > 0) {
 		if (sges_left == 1)
 			_base_add_sg_single_ieee(sg_local,
 			    simple_sgl_flags_last, 0, sg_dma_len(sg_scmd),
-- 
2.0.2
