From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Subject: [PATCH] scsi: mpt3sas: mpt3sas_transport.c:  Cleaning up uninitialized variables
Date: Sun,  1 Jun 2014 15:08:37 +0200
Message-ID: <1401628118-17506-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:51751 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751967AbaFANHp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 1 Jun 2014 09:07:45 -0400
Received: by mail-wi0-f176.google.com with SMTP id n15so3180131wiw.15
        for <linux-scsi@vger.kernel.org>; Sun, 01 Jun 2014 06:07:44 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Nagalakshmi Nandigama <Nagalakshmi.Nandigama@lsi.com>, Sreekanth Reddy <Sreekanth.Reddy@lsi.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>, support@lsi.com, "James E.J. Bottomley" <JBottomley@parallels.com>, DL-MPTFusionLinux@lsi.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

There is a risk that the variable will be used without being initialized.

This was largely found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/scsi/mpt3sas/mpt3sas_transport.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_transport.c b/drivers/scsi/mpt3sas/mpt3sas_transport.c
index 65170cb..f648dc4 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_transport.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_transport.c
@@ -305,8 +305,8 @@ _transport_expander_report_manufacture(struct MPT3SAS_ADAPTER *ioc,
 	void *data_out = NULL;
 	dma_addr_t data_out_dma;
 	dma_addr_t data_in_dma;
-	size_t data_in_sz;
-	size_t data_out_sz;
+	size_t data_in_sz = sizeof(struct rep_manu_reply);
+	size_t data_out_sz = sizeof(struct rep_manu_request);
 	u16 wait_state_count;
 
 	if (ioc->shost_recovery || ioc->pci_error_recovery) {
@@ -357,8 +357,6 @@ _transport_expander_report_manufacture(struct MPT3SAS_ADAPTER *ioc,
 	mpi_request = mpt3sas_base_get_msg_frame(ioc, smid);
 	ioc->transport_cmds.smid = smid;
 
-	data_out_sz = sizeof(struct rep_manu_request);
-	data_in_sz = sizeof(struct rep_manu_reply);
 	data_out = pci_alloc_consistent(ioc->pdev, data_out_sz + data_in_sz,
 	    &data_out_dma);
 
-- 
1.7.10.4

