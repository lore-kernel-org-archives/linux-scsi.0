Return-Path: <SRS0=/Ihf=62=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1B41C54E8D
	for <linux-scsi@archiver.kernel.org>; Tue, 12 May 2020 02:20:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CEA4A206D3
	for <linux-scsi@archiver.kernel.org>; Tue, 12 May 2020 02:20:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="GtGpcsoc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728533AbgELCUG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 May 2020 22:20:06 -0400
Received: from mail26.static.mailgun.info ([104.130.122.26]:24180 "EHLO
        mail26.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727892AbgELCUG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 11 May 2020 22:20:06 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1589250005; h=Content-Transfer-Encoding: Content-Type:
 In-Reply-To: MIME-Version: Date: Message-ID: From: References: Cc: To:
 Subject: Sender; bh=k2YIPX12MuXHG4Ed0EuQtB9gnhkLejakrxn5AILaJgM=; b=GtGpcsocr7MWZoYWhISm1A/+I/SpgoVCvPBXktE34LdydoG5Gt40xMKT41EX5oFbDqZd04Zv
 7qDnXO/N3ojEtzbwV/FxFRlBDWdnrGm4h1bUChc1AWhv3OuQqn/5ZiDlQL5EjD9hztgkt4SJ
 3GmnFf4SL/F+lKZrkCN76m9GLQQ=
X-Mailgun-Sending-Ip: 104.130.122.26
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n01.prod.us-east-1.postgun.com with SMTP id
 5eba07c377c5b4a9096c17f9 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 12 May 2020 02:19:47
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 8B23EC44788; Tue, 12 May 2020 02:19:45 +0000 (UTC)
Received: from [192.168.8.150] (cpe-70-95-149-85.san.res.rr.com [70.95.149.85])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: asutoshd)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 4DE55C433CB;
        Tue, 12 May 2020 02:19:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 4DE55C433CB
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=asutoshd@codeaurora.org
Subject: Re: [PATCH v2 4/4] scsi: ufs-mediatek: customize WriteBooster flush
 policy
To:     Stanley Chu <stanley.chu@mediatek.com>, linux-scsi@vger.kernel.org,
        martin.petersen@oracle.com, avri.altman@wdc.com,
        alim.akhtar@samsung.com, jejb@linux.ibm.com
Cc:     beanhuo@micron.com, cang@codeaurora.org, matthias.bgg@gmail.com,
        bvanassche@acm.org, linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kuohong.wang@mediatek.com, peter.wang@mediatek.com,
        chun-hung.wu@mediatek.com, andy.teng@mediatek.com
References: <20200509093716.21010-1-stanley.chu@mediatek.com>
 <20200509093716.21010-5-stanley.chu@mediatek.com>
From:   "Asutosh Das (asd)" <asutoshd@codeaurora.org>
Message-ID: <635f91f6-3a27-ffdd-4021-67705d4063fc@codeaurora.org>
Date:   Mon, 11 May 2020 19:19:42 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200509093716.21010-5-stanley.chu@mediatek.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/9/2020 2:37 AM, Stanley Chu wrote:
> Change the WriteBooster policy to keep VCC on during
> runtime suspend if available WriteBooster buffer is less
> than 80%.
> 
> Signed-off-by: Stanley Chu <stanley.chu@mediatek.com>
> ---
>   drivers/scsi/ufs/ufs-mediatek.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/scsi/ufs/ufs-mediatek.c b/drivers/scsi/ufs/ufs-mediatek.c
> index 56620f7d88ce..94e97701f456 100644
> --- a/drivers/scsi/ufs/ufs-mediatek.c
> +++ b/drivers/scsi/ufs/ufs-mediatek.c
> @@ -271,6 +271,7 @@ static int ufs_mtk_init(struct ufs_hba *hba)
>   
>   	/* Enable WriteBooster */
>   	hba->caps |= UFSHCD_CAP_WB_EN;
> +	hba->vps->wb_flush_threshold = UFS_WB_BUF_REMAIN_PERCENT(80);
>   
>   	/*
>   	 * ufshcd_vops_init() is invoked after
> 

Patchset looks good to me.

Reviewed-by: Asutosh Das <asutoshd@codeaurora.org>


-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
Linux Foundation Collaborative Project
