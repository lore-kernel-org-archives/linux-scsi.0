Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E409C433E0
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Jan 2021 05:54:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 372D92253A
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Jan 2021 05:54:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725885AbhAKFyE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Jan 2021 00:54:04 -0500
Received: from m43-15.mailgun.net ([69.72.43.15]:62030 "EHLO
        m43-15.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725797AbhAKFyD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Jan 2021 00:54:03 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1610344418; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=cwnfahSMqI6baLZQoFMM2lVfnr2c3yNUVMgIdG5YGZc=;
 b=PMxoRiSxCaZTjTUCj2P5OPcRqIkOL3HbNyJDqhdUCbcOllIKzt2Cx51862GURi9qDomqljqg
 LXPwPNzM3mqa/hAbOcewKxksh+7s/KjoTAQmDXgcFgV7H06lKe9B3aPe25Ol4Hr+lPkLeKEd
 lt4NjUKTPw/Vo+LYPySirv2Xvsk=
X-Mailgun-Sending-Ip: 69.72.43.15
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n06.prod.us-west-2.postgun.com with SMTP id
 5ffbe7c8e53eb5da8cabc2b7 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 11 Jan 2021 05:53:11
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id AF7B7C43464; Mon, 11 Jan 2021 05:53:11 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id ECEB7C433CA;
        Mon, 11 Jan 2021 05:53:10 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 11 Jan 2021 13:53:10 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Jaegeuk Kim <jaegeuk@kernel.org>
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, alim.akhtar@samsung.com,
        avri.altman@wdc.com, bvanassche@acm.org,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        Jaegeuk Kim <jaegeuk@google.com>
Subject: Re: [PATCH] scsi: ufs: should not override buffer lengh
In-Reply-To: <20210111044443.1405049-1-jaegeuk@kernel.org>
References: <20210111044443.1405049-1-jaegeuk@kernel.org>
Message-ID: <6551e7d6dd7dc4132dc69e77a51f6f21@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Jaegeuk,

I think the problem is that func ufshcd_read_desc_param() is not 
expecting
one access unsupported descriptors on all W-LUs, not just RPMB LU.

If we can get the right buf_len from func 
ufshcd_map_desc_id_to_length(),
the issue won't happen. - 
https://lore.kernel.org/patchwork/patch/1323421/.

What do you think if we update ufshcd_map_desc_id_to_length(add one 
param - desc_index)
so that it can tell the correct buf_len in case of W-LUs?

Thanks,
Can Guo.

On 2021-01-11 12:44, Jaegeuk Kim wrote:
> From: Jaegeuk Kim <jaegeuk@google.com>
> 
> Kernel stack violation when getting unit_descriptor/wb_buf_alloc_units 
> from
> rpmb lun. The reason is the unit descriptor length is different per LU.
> 
> The lengh of Normal LU is 45, while the one of rpmb LU is 35.
> 
> int ufshcd_read_desc_param(struct ufs_hba *hba, ...)
> {
> 	param_offset=41;
> 	param_size=4;
> 	buff_len=45;
> 	...
> 	buff_len=35 by rpmb LU;
> 
> 	if (is_kmalloc) {
> 		/* Make sure we don't copy more data than available */
> 		if (param_offset + param_size > buff_len)
> 			param_size = buff_len - param_offset;
> 			--> param_size = 250;
> 		memcpy(param_read_buf, &desc_buf[param_offset], param_size);
> 		--> memcpy(param_read_buf, desc_buf+41, 250);
> 
> [  141.868974][ T9174] Kernel panic - not syncing: stack-protector:
> Kernel stack is corrupted in: wb_buf_alloc_units_show+0x11c/0x11c
> 	}
> }
> 
> Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
> ---
>  drivers/scsi/ufs/ufshcd.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 2a715f13fe1d..722697b57777 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -3293,8 +3293,12 @@ int ufshcd_read_desc_param(struct ufs_hba *hba,
> 
>  	if (is_kmalloc) {
>  		/* Make sure we don't copy more data than available */
> -		if (param_offset + param_size > buff_len)
> -			param_size = buff_len - param_offset;
> +		if (param_offset + param_size > buff_len) {
> +			if (buff_len > param_offset)
> +				param_size = buff_len - param_offset;
> +			else
> +				param_size = 0;
> +		}
>  		memcpy(param_read_buf, &desc_buf[param_offset], param_size);
>  	}
>  out:
