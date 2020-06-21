Return-Path: <SRS0=/9Oe=AC=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FAF5C433E6
	for <linux-scsi@archiver.kernel.org>; Sun, 21 Jun 2020 17:41:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7021A22254
	for <linux-scsi@archiver.kernel.org>; Sun, 21 Jun 2020 17:41:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1592761262;
	bh=2pN1FI3WYWMs7QJB0lFYOwEYs2Kt0rr9XebJxKSIrEA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=gbrLXPNLEXbXZgWkrAVXGHlD9JCoUvlp9AMURaqgzQt4Ah8lezdg/izfV3PzNi2I/
	 n8LnnygDdn1a4VwIBz0VliLat+lma6OkzmTRgm//6ElDLQSaKaAGdGUCp+5Pz4G/vy
	 ekdGyUrFPRfda44eDgXL5bXSmJ7eyav3LjBc6ZM8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730502AbgFURlA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 21 Jun 2020 13:41:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:52472 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730471AbgFURk7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 21 Jun 2020 13:40:59 -0400
Received: from sol.hsd1.ca.comcast.net (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1FCBF2242B;
        Sun, 21 Jun 2020 17:40:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592761259;
        bh=2pN1FI3WYWMs7QJB0lFYOwEYs2Kt0rr9XebJxKSIrEA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FQZahxO7jZkMXsnaQbG0m72HstkrjcH1IgS0f4txBPu6DrzpKvZ5lNFZCdZY1dIPR
         ApuOZhT0rLj4RvTnVJiop/uLVm36573mUQF47shSeNXPya6VszF84YTRswYgppgcK6
         gYer+XANs5+YCZSFH8EzlZgLu9expZ/Oze3PSfZk=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-scsi@vger.kernel.org
Cc:     linux-arm-msm@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Andy Gross <agross@kernel.org>,
        Avri Altman <avri.altman@wdc.com>,
        Barani Muthukumaran <bmuthuku@qti.qualcomm.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Can Guo <cang@codeaurora.org>,
        Elliot Berman <eberman@codeaurora.org>,
        John Stultz <john.stultz@linaro.org>,
        Satya Tangirala <satyat@google.com>,
        Steev Klimaszewski <steev@kali.org>,
        Thara Gopinath <thara.gopinath@linaro.org>
Subject: [PATCH v5 2/5] scsi: ufs-qcom: name the dev_ref_clk_ctrl registers
Date:   Sun, 21 Jun 2020 10:37:10 -0700
Message-Id: <20200621173713.132879-3-ebiggers@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200621173713.132879-1-ebiggers@kernel.org>
References: <20200621173713.132879-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

In preparation for adding another optional register range to the
ufs-qcom driver, name the existing optional register range
"dev_ref_clk_ctrl_mem".  This allows the driver to refer to the optional
register ranges by name rather than index.

No device-tree files actually have to be updated due to this change,
since none of them actually declares these registers.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 drivers/scsi/ufs/ufs-qcom.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufs-qcom.c b/drivers/scsi/ufs/ufs-qcom.c
index 2e6ddb5cdfc2..bd0b4ed7b37a 100644
--- a/drivers/scsi/ufs/ufs-qcom.c
+++ b/drivers/scsi/ufs/ufs-qcom.c
@@ -1275,7 +1275,8 @@ static int ufs_qcom_init(struct ufs_hba *hba)
 		host->dev_ref_clk_en_mask = BIT(26);
 	} else {
 		/* "dev_ref_clk_ctrl_mem" is optional resource */
-		res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
+		res = platform_get_resource_byname(pdev, IORESOURCE_MEM,
+						   "dev_ref_clk_ctrl_mem");
 		if (res) {
 			host->dev_ref_clk_ctrl_mmio =
 					devm_ioremap_resource(dev, res);
-- 
2.27.0

