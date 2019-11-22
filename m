Return-Path: <SRS0=RMqd=ZO=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBEA8C432C0
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Nov 2019 05:28:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B2A7820708
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Nov 2019 05:28:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1574400536;
	bh=qcEG6w2/GDNSrFO6+mPfxkBVtMr5NJCSsxklqfbSFtQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=I66QpSKjh9db0UXl5RdywSY5sC2vdJ1tHsQ2DZazIeqVct5syBEm5MPGbd1HR1Wv2
	 UrhNuA/42DYRbFZUn7EM+SSmzz+Y3so2P/esuUX0dnbN6FoTO4rDs+KMqYhOAeUeYL
	 AXiRdN274iKSp9OkUoUrkpjo2ljw5xVMisSab+SY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727072AbfKVF24 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 22 Nov 2019 00:28:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:46690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726952AbfKVF2m (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 22 Nov 2019 00:28:42 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5E18E2070B;
        Fri, 22 Nov 2019 05:28:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574400522;
        bh=qcEG6w2/GDNSrFO6+mPfxkBVtMr5NJCSsxklqfbSFtQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=foNtxn2pSe0Vym+GQ7crcPLd7gvClXcoCi0rL5ijNHfd4docOAhwksTPvpsaKGrzY
         tjGN8KBOKWI+br9CUTJkGB487MA+omIzm19/JRtLDySEpgadXJeslNsaJ/3V9SuZKz
         /J6ojXxfzf1K/rLfNXf2zty+6Lj3jio4jUOCNlRM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 003/219] scsi: lpfc: Fix dif and first burst use in write commands
Date:   Fri, 22 Nov 2019 00:25:01 -0500
Message-Id: <20191122052837.357-3-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191122052837.357-1-sashal@kernel.org>
References: <20191122052837.357-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: James Smart <jsmart2021@gmail.com>

[ Upstream commit 7c4042a4d0b7532cfbc90478fd3084b2dab5849e ]

When dif and first burst is used in a write command wqe, the driver was not
properly setting fields in the io command request. This resulted in no dif
bytes being sent and invalid xfer_rdy's, resulting in the io being aborted
by the hardware.

Correct the wqe initializaton when both dif and first burst are used.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_scsi.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index 666495f21c246..425b83618a2e5 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -2732,6 +2732,7 @@ lpfc_bg_scsi_prep_dma_buf_s3(struct lpfc_hba *phba,
 	int datasegcnt, protsegcnt, datadir = scsi_cmnd->sc_data_direction;
 	int prot_group_type = 0;
 	int fcpdl;
+	struct lpfc_vport *vport = phba->pport;
 
 	/*
 	 * Start the lpfc command prep by bumping the bpl beyond fcp_cmnd
@@ -2837,6 +2838,14 @@ lpfc_bg_scsi_prep_dma_buf_s3(struct lpfc_hba *phba,
 	 */
 	iocb_cmd->un.fcpi.fcpi_parm = fcpdl;
 
+	/*
+	 * For First burst, we may need to adjust the initial transfer
+	 * length for DIF
+	 */
+	if (iocb_cmd->un.fcpi.fcpi_XRdy &&
+	    (fcpdl < vport->cfg_first_burst_size))
+		iocb_cmd->un.fcpi.fcpi_XRdy = fcpdl;
+
 	return 0;
 err:
 	if (lpfc_cmd->seg_cnt)
@@ -3401,6 +3410,7 @@ lpfc_bg_scsi_prep_dma_buf_s4(struct lpfc_hba *phba,
 	int datasegcnt, protsegcnt, datadir = scsi_cmnd->sc_data_direction;
 	int prot_group_type = 0;
 	int fcpdl;
+	struct lpfc_vport *vport = phba->pport;
 
 	/*
 	 * Start the lpfc command prep by bumping the sgl beyond fcp_cmnd
@@ -3516,6 +3526,14 @@ lpfc_bg_scsi_prep_dma_buf_s4(struct lpfc_hba *phba,
 	 */
 	iocb_cmd->un.fcpi.fcpi_parm = fcpdl;
 
+	/*
+	 * For First burst, we may need to adjust the initial transfer
+	 * length for DIF
+	 */
+	if (iocb_cmd->un.fcpi.fcpi_XRdy &&
+	    (fcpdl < vport->cfg_first_burst_size))
+		iocb_cmd->un.fcpi.fcpi_XRdy = fcpdl;
+
 	/*
 	 * If the OAS driver feature is enabled and the lun is enabled for
 	 * OAS, set the oas iocb related flags.
-- 
2.20.1

