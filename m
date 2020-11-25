Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F003DC63798
	for <linux-scsi@archiver.kernel.org>; Wed, 25 Nov 2020 02:03:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A1DB32067D
	for <linux-scsi@archiver.kernel.org>; Wed, 25 Nov 2020 02:03:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="t5qwlasE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726392AbgKYCDI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 24 Nov 2020 21:03:08 -0500
Received: from m42-4.mailgun.net ([69.72.42.4]:30597 "EHLO m42-4.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726347AbgKYCDI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 24 Nov 2020 21:03:08 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1606269788; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=DT2VV0QdqZenIkzRRGGu7GK5OFXsOFdMYtbDob6PZ60=;
 b=t5qwlasEC4QBlMnMe+Cur/XchFIFxGmjq+t9biRuJAO0oOFGSdH/UmztHD0sWx5LxeyoY7vc
 sVCxPaIBLQTl16mY17qIEvMbmRuiG2bEqdlY1gtnfsA4jEUwK3wnjwKpR4LlQU7mVznTVnHi
 8DS7lxo+0f7rb/A0qvkmDonwzqA=
X-Mailgun-Sending-Ip: 69.72.42.4
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n07.prod.us-west-2.postgun.com with SMTP id
 5fbdbb3deb04c00160615dd8 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 25 Nov 2020 02:02:37
 GMT
Sender: hongwus=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id BBC87C43460; Wed, 25 Nov 2020 02:02:37 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: hongwus)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 042DFC433C6;
        Wed, 25 Nov 2020 02:02:36 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 25 Nov 2020 10:02:36 +0800
From:   hongwus@codeaurora.org
To:     Can Guo <cang@codeaurora.org>
Cc:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        ziqichen@codeaurora.org, rnayak@codeaurora.org,
        linux-scsi@vger.kernel.org, kernel-team@android.com,
        saravanak@google.com, salyzyn@google.com,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] scsi: ufs-qcom: Keep core_clk_unipro ON while link
 is active
In-Reply-To: <1606202906-14485-3-git-send-email-cang@codeaurora.org>
References: <1606202906-14485-1-git-send-email-cang@codeaurora.org>
 <1606202906-14485-3-git-send-email-cang@codeaurora.org>
Message-ID: <cb6f75c6cbced8a0cc33587141bb6ea7@codeaurora.org>
X-Sender: hongwus@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-11-24 15:28, Can Guo wrote:
> If we want to disable clocks to save power but still keep the link 
> active,
> core_clk_unipro, as same as ref_clk, should not be the one being 
> disabled.
> 
> Signed-off-by: Can Guo <cang@codeaurora.org>
> ---
>  drivers/scsi/ufs/ufs-qcom.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/drivers/scsi/ufs/ufs-qcom.c b/drivers/scsi/ufs/ufs-qcom.c
> index f9d6ef3..70df357 100644
> --- a/drivers/scsi/ufs/ufs-qcom.c
> +++ b/drivers/scsi/ufs/ufs-qcom.c
> @@ -977,6 +977,7 @@ static int ufs_qcom_init(struct ufs_hba *hba)
>  	struct platform_device *pdev = to_platform_device(dev);
>  	struct ufs_qcom_host *host;
>  	struct resource *res;
> +	struct ufs_clk_info *clki;
> 
>  	if (strlen(android_boot_dev) && strcmp(android_boot_dev, 
> dev_name(dev)))
>  		return -ENODEV;
> @@ -1075,6 +1076,11 @@ static int ufs_qcom_init(struct ufs_hba *hba)
>  		}
>  	}
> 
> +	list_for_each_entry(clki, &hba->clk_list_head, list) {
> +		if (!strcmp(clki->name, "core_clk_unipro"))
> +			clki->always_on_while_link_active = true;
> +	}
> +
>  	err = ufs_qcom_init_lane_clks(host);
>  	if (err)
>  		goto out_variant_clear;

Reviewed-by: Hongwu Su<hongwus@codeaurora.org>
