Return-Path: <SRS0=HJ87=Y2=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8861CA9EC7
	for <linux-scsi@archiver.kernel.org>; Sat,  2 Nov 2019 05:01:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8BDC82084D
	for <linux-scsi@archiver.kernel.org>; Sat,  2 Nov 2019 05:01:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="JI6zpPe8";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="JkWz3ghU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727334AbfKBFBx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 2 Nov 2019 01:01:53 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:50080 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725842AbfKBFBx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 2 Nov 2019 01:01:53 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 2A9E961549; Sat,  2 Nov 2019 05:01:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1572670912;
        bh=GoX4bP45inNKafc1eN5nAFb+HzguBHGtpBwQTVNYdd8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JI6zpPe8F1OPurwCyEBWP9Stpw87PqdAtCo5DJZelp8e0+ksmicYaKlxuha48Ozcs
         mJebCBIvI5K/LWb5lcxEWL/1R6UPXaW4T8PPa+t58UwG54kJTcTzVjoXU2AlcuxADu
         KhCtMh6/H6D0HqjxdKd/N30Ogpv1qgWhJRx63BDc=
Received: from pacamara-linux.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: cang@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 306B1614F7;
        Sat,  2 Nov 2019 05:01:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1572670910;
        bh=GoX4bP45inNKafc1eN5nAFb+HzguBHGtpBwQTVNYdd8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JkWz3ghUFVOp98aE0tZm0Rlzh5Afguqp+0Zpp1fYjvwFkdsL6HE5dplWc0V4M1WGF
         A9hCJZbZAPpNcbv6EsP+ND0taFn9jwkHP5HsjRwOLSSGZfXp1e83D7bgjZV5Qw66px
         /+bAJAnTn/9Syy8h5sXYvgkTcfCU6dqr93tuXLOA=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 306B1614F7
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
        Subhash Jadavani <subhashj@codeaurora.org>,
        Tomas Winkler <tomas.winkler@intel.com>,
        Venkat Gopalakrishnan <venkatg@codeaurora.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v3 2/5] scsi: ufs: Set DBD setting in mode sense for caching mode page
Date:   Fri,  1 Nov 2019 22:01:35 -0700
Message-Id: <1572670898-750-3-git-send-email-cang@codeaurora.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1572670898-750-1-git-send-email-cang@codeaurora.org>
References: <1572670898-750-1-git-send-email-cang@codeaurora.org>
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
SYNCHRONIZE_CACHE commands to flush the device cache.
This can result in data corruption in case of sudden power down, when
there is data stored in the device cache.

This patch fixes the DBD field setting in case of caching mode page.

Signed-off-by: Can Guo <cang@codeaurora.org>
---
 drivers/scsi/ufs/ufshcd.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 0026199..0a6b8f9 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -8353,6 +8353,7 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 	host->max_channel = UFSHCD_MAX_CHANNEL;
 	host->unique_id = host->host_no;
 	host->max_cmd_len = UFS_CDB_SIZE;
+	host->set_dbd_for_caching = 1;
 
 	hba->max_pwr_info.is_valid = false;
 
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

