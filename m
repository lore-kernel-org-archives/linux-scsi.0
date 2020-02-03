Return-Path: <SRS0=0hmW=3X=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECC05C3524D
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Feb 2020 09:18:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C007220842
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Feb 2020 09:18:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="ohPtyx+s"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727976AbgBCJS1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 3 Feb 2020 04:18:27 -0500
Received: from mail26.static.mailgun.info ([104.130.122.26]:61986 "EHLO
        mail26.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727657AbgBCJST (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Feb 2020 04:18:19 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1580721499; h=References: In-Reply-To: Message-Id: Date:
 Subject: Cc: To: From: Sender;
 bh=52EghVzA6/poXiI2GuUROAvAoUlFjuX9k90DJG902HU=; b=ohPtyx+syvTmqW4B0U98IzclYILb9On8GVbFOjADEthw84rU0EcGoatuWb1aS966k/eQcIJV
 NYrjesqnvL/euXBGJ6kwwf2OLqXRk2Y/Tjvze/s4XmO5kjDNc04uFbT9W15jU4JaWpOXj202
 VA3Ca6deDQokvrnSSGB6UK9DyTk=
X-Mailgun-Sending-Ip: 104.130.122.26
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e37e554.7fa68aea4998-smtp-out-n03;
 Mon, 03 Feb 2020 09:18:12 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id EE776C433A2; Mon,  3 Feb 2020 09:18:10 +0000 (UTC)
Received: from pacamara-linux.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id E6559C43383;
        Mon,  3 Feb 2020 09:18:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org E6559C43383
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=cang@codeaurora.org
From:   Can Guo <cang@codeaurora.org>
To:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, rnayak@codeaurora.org,
        linux-scsi@vger.kernel.org, kernel-team@android.com,
        saravanak@google.com, salyzyn@google.com, cang@codeaurora.org
Cc:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Venkat Gopalakrishnan <venkatg@codeaurora.org>,
        Tomas Winkler <tomas.winkler@intel.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v5 2/8] scsi: ufs: set load before setting voltage in regulators
Date:   Mon,  3 Feb 2020 01:17:44 -0800
Message-Id: <1580721472-10784-3-git-send-email-cang@codeaurora.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1580721472-10784-1-git-send-email-cang@codeaurora.org>
References: <1580721472-10784-1-git-send-email-cang@codeaurora.org>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Asutosh Das <asutoshd@codeaurora.org>

This sequence change is required to avoid dips in voltage
during boot-up.

Apparently, this dip is caused because in the original
sequence, the regulators are initialized in lpm mode.
And then when the load is set to high, and more current
is drawn, than is allowed in lpm, the dip is seen.

Signed-off-by: Asutosh Das <asutoshd@codeaurora.org>
Signed-off-by: Can Guo <cang@codeaurora.org>
Reviewed-by: Hongwu Su <hongwus@codeaurora.org>
---
 drivers/scsi/ufs/ufshcd.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 10dbc0c..83ae093 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -7248,6 +7248,11 @@ static int ufshcd_config_vreg(struct device *dev,
 	name = vreg->name;
 
 	if (regulator_count_voltages(reg) > 0) {
+		uA_load = on ? vreg->max_uA : 0;
+		ret = ufshcd_config_vreg_load(dev, vreg, uA_load);
+		if (ret)
+			goto out;
+
 		if (vreg->min_uV && vreg->max_uV) {
 			min_uV = on ? vreg->min_uV : 0;
 			ret = regulator_set_voltage(reg, min_uV, vreg->max_uV);
@@ -7258,11 +7263,6 @@ static int ufshcd_config_vreg(struct device *dev,
 				goto out;
 			}
 		}
-
-		uA_load = on ? vreg->max_uA : 0;
-		ret = ufshcd_config_vreg_load(dev, vreg, uA_load);
-		if (ret)
-			goto out;
 	}
 out:
 	return ret;
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
