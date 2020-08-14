Return-Path: <SRS0=qkKg=BY=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D76FAC433E1
	for <linux-scsi@archiver.kernel.org>; Fri, 14 Aug 2020 16:37:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B089120791
	for <linux-scsi@archiver.kernel.org>; Fri, 14 Aug 2020 16:37:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="UCbc3fnG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726897AbgHNQhX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 Aug 2020 12:37:23 -0400
Received: from mail29.static.mailgun.info ([104.130.122.29]:42982 "EHLO
        mail29.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726196AbgHNQhW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 14 Aug 2020 12:37:22 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1597423042; h=In-Reply-To: Content-Type: MIME-Version:
 References: Message-ID: Subject: Cc: To: From: Date: Sender;
 bh=4xiBrWPGNBnaNNIAe493itARuZ6OD6wP68Tooso72rw=; b=UCbc3fnGbHMMQ2j8rJAJ3XdkumEhz4DM2qgB7sIDpYZAhMFrjdcGVnb/IpgzQapqxZxQvT5a
 nlt6AF1HhdAPKEGAmBGKuBKbAb7WMgTcq0wKfyi1OR/kFAp5GGM6VU7kMu76/Ff7s2n9xkMZ
 gAI7ejUyifUjM/397zVuvGxIJDs=
X-Mailgun-Sending-Ip: 104.130.122.29
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n06.prod.us-east-1.postgun.com with SMTP id
 5f36bdbaba4c2cd367fe044b (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Fri, 14 Aug 2020 16:37:14
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id E8464C433B1; Fri, 14 Aug 2020 16:37:12 +0000 (UTC)
Received: from asutoshd-linux1.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: asutoshd)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 6E414C433CA;
        Fri, 14 Aug 2020 16:37:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 6E414C433CA
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=asutoshd@codeaurora.org
Date:   Fri, 14 Aug 2020 09:37:04 -0700
From:   Asutosh Das <asutoshd@codeaurora.org>
To:     Bean Huo <huobean@gmail.com>
Cc:     alim.akhtar@samsung.com, avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/2] scsi: ufs: change ufshcd_comp_devman_upiu() to
 ufshcd_compose_devman_upiu()
Message-ID: <20200814163704.GA1217@asutoshd-linux1.qualcomm.com>
References: <20200814095034.20709-1-huobean@gmail.com>
 <20200814095034.20709-2-huobean@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20200814095034.20709-2-huobean@gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Aug 14 2020 at 02:50 -0700, Bean Huo wrote:
>From: Bean Huo <beanhuo@micron.com>
>
>ufshcd_comp_devman_upiu() alwasy make me confuse that it is a request
>completion calling function. Change it to ufshcd_compose_devman_upiu().
>
>Signed-off-by: Bean Huo <beanhuo@micron.com>
>Acked-by: Avri Altman <avri.altman@wdc.com>
>---

Reviewed-by: Asutosh Das <asutoshd@codeaurora.org>

> drivers/scsi/ufs/ufshcd.c | 7 ++++---
> 1 file changed, 4 insertions(+), 3 deletions(-)
>
>diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
>index 5f09cda7b21c..e3663b85e8ee 100644
>--- a/drivers/scsi/ufs/ufshcd.c
>+++ b/drivers/scsi/ufs/ufshcd.c
>@@ -2391,12 +2391,13 @@ static inline void ufshcd_prepare_utp_nop_upiu(struct ufshcd_lrb *lrbp)
> }
>
> /**
>- * ufshcd_comp_devman_upiu - UFS Protocol Information Unit(UPIU)
>+ * ufshcd_compose_devman_upiu - UFS Protocol Information Unit(UPIU)
>  *			     for Device Management Purposes
>  * @hba: per adapter instance
>  * @lrbp: pointer to local reference block
>  */
>-static int ufshcd_comp_devman_upiu(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
>+static int ufshcd_compose_devman_upiu(struct ufs_hba *hba,
>+				      struct ufshcd_lrb *lrbp)
> {
> 	u8 upiu_flags;
> 	int ret = 0;
>@@ -2590,7 +2591,7 @@ static int ufshcd_compose_dev_cmd(struct ufs_hba *hba,
> 	ufshcd_prepare_lrbp_crypto(NULL, lrbp);
> 	hba->dev_cmd.type = cmd_type;
>
>-	return ufshcd_comp_devman_upiu(hba, lrbp);
>+	return ufshcd_compose_devman_upiu(hba, lrbp);
> }
>
> static int
>-- 
>2.17.1
>
