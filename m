Return-Path: <SRS0=wJ7M=YV=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9A2FCA9EA0
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Oct 2019 03:50:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 792AD20659
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Oct 2019 03:50:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Q13ynTwv";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="SzzhX6Mn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731228AbfJ1Dud (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 27 Oct 2019 23:50:33 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:44698 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729328AbfJ1Duc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 27 Oct 2019 23:50:32 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id E807060A64; Mon, 28 Oct 2019 03:50:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1572234631;
        bh=uEBoBrBG5ktqI6Dtolluu4zSzdP5Q/x7XfLs0sadKIE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q13ynTwvz9GayVSjY+MrLwlkN3rZac/Lc2i21n5oqTzXvfmq6dJhh5xI6ARHQG5St
         k483XE+BqGYTzGpG4Ujga8DcIqDjijxCQxLpBOp740Srj0RYyknxiVPlLEPezthrnS
         vRvFcIeXXSe1hZXaIEytX78CZfRQIbK1cHDGDcQA=
Received: from pacamara-linux.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: cang@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 316C060930;
        Mon, 28 Oct 2019 03:50:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1572234630;
        bh=uEBoBrBG5ktqI6Dtolluu4zSzdP5Q/x7XfLs0sadKIE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SzzhX6MnHtotIxzXcAYPx4Z8BoCwTQSo54CGIAv4xpL/4skiQST0TTV6cPFFgEjTe
         Vn9DSZPv1NsEecsFchQBS8IZXW6qcgyZFT1vTSrSWG6c5ws22pqNYeMMC1Pci5qSre
         10ihH70G1XzH0viveRiCDQ3n/3PONNrDIyh63GTY=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 316C060930
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=cang@codeaurora.org
From:   Can Guo <cang@codeaurora.org>
To:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        rnayak@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, saravanak@google.com, salyzyn@google.com,
        cang@codeaurora.org
Cc:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Pedro Sousa <pedrom.sousa@synopsys.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Tomas Winkler <tomas.winkler@intel.com>,
        Subhash Jadavani <subhashj@codeaurora.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v1 2/5] scsi: ufs: Set DBD setting in mode sense for caching mode page
Date:   Sun, 27 Oct 2019 20:50:04 -0700
Message-Id: <1572234608-32654-3-git-send-email-cang@codeaurora.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1572234608-32654-1-git-send-email-cang@codeaurora.org>
References: <1572234608-32654-1-git-send-email-cang@codeaurora.org>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Host sends MODE_SENSE_10 with caching mode page, to check if the device
supports the cache feature.
UFS standards requires DBD field to be set to 1.

Some card vendors are more strict and check the DBD field, hence
respond with CHECK_CONDITION (Sense key set to ILLEGAL_REQUEST and
ASC set to INVALID FIELD IN CDB).
As a result of the CHECK_CONDITION response, host assumes that the
device doesn't support the cache feature and doesn't send
SYNCHORONIZE_CACHE commands to flush the device cache.
This can result in data corruption in case of sudden power down, when
there is data stored in the device cache.

This patch fixes the DBD field setting in case of caching mode page.

Change-Id: Ifb674dfcc497a2c9dd9b49556f86979d9a3e4acf
Signed-off-by: Can Guo <cang@codeaurora.org>
---
 drivers/scsi/ufs/ufshcd.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index c28c144..101b4d0 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -8329,6 +8329,7 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 	host->max_channel = UFSHCD_MAX_CHANNEL;
 	host->unique_id = host->host_no;
 	host->max_cmd_len = UFS_CDB_SIZE;
+	host->set_dbd_for_caching = 1;
 
 	hba->max_pwr_info.is_valid = false;
 
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

