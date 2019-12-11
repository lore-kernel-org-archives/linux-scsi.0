Return-Path: <SRS0=S2y6=2B=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BA2BC43603
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Dec 2019 08:28:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E095521556
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Dec 2019 08:28:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="KO63e4tF";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="fhGoK6Rw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728105AbfLKI2n (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 11 Dec 2019 03:28:43 -0500
Received: from a27-11.smtp-out.us-west-2.amazonses.com ([54.240.27.11]:53666
        "EHLO a27-11.smtp-out.us-west-2.amazonses.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727888AbfLKI2n (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 11 Dec 2019 03:28:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=zsmsymrwgfyinv5wlfyidntwsjeeldzt; d=codeaurora.org; t=1576052922;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References;
        bh=UEwfi+RZS/vW/w3fh/SVyY2n5RGl+a32Uty8VCq8WgU=;
        b=KO63e4tFR2KJWyMTdvUSAvuXkdqrnRVvmSRbgpemmwiQrmA+t5AaOrBL/O6bRx24
        ryizzn8Pu+Fzp6E884VpZhhHEgDzke2Qz86le7M2kZLCsEW2nQNzdPHrKJM7jAmwePY
        NMydOF6qRr9xapg1zZcVEztLB5wk/ut/7z2FRpN8=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=gdwg2y3kokkkj5a55z2ilkup5wp5hhxx; d=amazonses.com; t=1576052922;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:Feedback-ID;
        bh=UEwfi+RZS/vW/w3fh/SVyY2n5RGl+a32Uty8VCq8WgU=;
        b=fhGoK6RwiuKyGBRk91DAk9AMFO2REwsSwkuxTezkCSUkUqs+isncA5VddmbAWAZW
        qI/PdNBgQAy+bTg20nviQvVcB6CbXzGlULmm1QPOxLJs/5DAGjuzKMt0JWE/Tbbvy4m
        LqjvEjZA9dsqzcWTTfL7kQXK1o5pSkOFB1DATJ5g=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 45306C43383
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=cang@codeaurora.org
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
        Venkat Gopalakrishnan <venkatg@codeaurora.org>,
        Tomas Winkler <tomas.winkler@intel.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v1 1/2] scsi: ufs: Put SCSI host after remove it
Date:   Wed, 11 Dec 2019 08:28:42 +0000
Message-ID: <0101016ef4131860-28bb1208-3cff-4c07-bbe2-af8636184113-000000@us-west-2.amazonses.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1576052892-13510-1-git-send-email-cang@codeaurora.org>
References: <1576052892-13510-1-git-send-email-cang@codeaurora.org>
X-SES-Outgoing: 2019.12.11-54.240.27.11
Feedback-ID: 1.us-west-2.CZuq2qbDmUIuT3qdvXlRHZZCpfZqZ4GtG9v3VKgRyF0=:AmazonSES
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In ufshcd_remove(), after SCSI host is removed, put it once so that its
resources can be released.

Signed-off-by: Can Guo <cang@codeaurora.org>
---
 drivers/scsi/ufs/ufshcd.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index b5966fa..a86b0fd 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -8251,6 +8251,7 @@ void ufshcd_remove(struct ufs_hba *hba)
 	ufs_bsg_remove(hba);
 	ufs_sysfs_remove_nodes(hba->dev);
 	scsi_remove_host(hba->host);
+	scsi_host_put(hba->host);
 	/* disable interrupts */
 	ufshcd_disable_intr(hba, hba->intr_mask);
 	ufshcd_hba_stop(hba, true);
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

