From: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Subject: [PATCH v2 15/20] [SCSI] mpt3sas: Return host busy error  status to SML when DMA mapping of scatter gather list fails for a SCSI  command
Date: Tue, 30 Jun 2015 12:25:01 +0530
Message-ID: <1435647306-36956-16-git-send-email-Sreekanth.Reddy@avagotech.com>
References: <1435647306-36956-1-git-send-email-Sreekanth.Reddy@avagotech.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f47.google.com ([209.85.220.47]:32859 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753201AbbF3G43 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Jun 2015 02:56:29 -0400
Received: by pacws9 with SMTP id ws9so726049pac.0
        for <linux-scsi@vger.kernel.org>; Mon, 29 Jun 2015 23:56:29 -0700 (PDT)
In-Reply-To: <1435647306-36956-1-git-send-email-Sreekanth.Reddy@avagotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@kernel.org, hch@infradead.org
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, JBottomley@Parallels.com, Sathya.Prakash@avagotech.com, linux-kernel@vger.kernel.org, jthumshirn@suse.de, Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>

scsi_dma_map API will return a negative value (i.e. -ENOMEM)
if DMA mapping of sg lists fails and zero if the sg list in the
SCSI cmd is NULL. But drivers doesn't handled sg list DMA mapping
failure case properly.

So, Updated the code to return host busy error status to SCSI MID Layer(SML),
when DMA mapping of scatter gather list fails for a SCSI command.
So that SML will retry this SCSI cmd after some time.

Changes in v2:
    Corrected the typo mistake from "(!sges_left < 0)" to "(sges_left < 0)".

Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 4f82687..6e44370 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -1360,7 +1360,7 @@ _base_build_sg_scmd_ieee(struct MPT3SAS_ADAPTER *ioc,
 
 	sg_scmd = scsi_sglist(scmd);
 	sges_left = scsi_dma_map(scmd);
-	if (!sges_left) {
+	if (sges_left < 0) {
 		sdev_printk(KERN_ERR, scmd->device,
 			"pci_map_sg failed: request for %d bytes!\n",
 			scsi_bufflen(scmd));
@@ -1429,7 +1429,7 @@ _base_build_sg_scmd_ieee(struct MPT3SAS_ADAPTER *ioc,
  fill_in_last_segment:
 
 	/* fill the last segment */
-	while (sges_left) {
+	while (sges_left > 0) {
 		if (sges_left == 1)
 			_base_add_sg_single_ieee(sg_local,
 			    simple_sgl_flags_last, 0, sg_dma_len(sg_scmd),
-- 
2.0.2

