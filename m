Return-Path: <SRS0=d7EE=5G=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 294BFC4332D
	for <linux-scsi@archiver.kernel.org>; Sat, 21 Mar 2020 00:52:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DB1742070A
	for <linux-scsi@archiver.kernel.org>; Sat, 21 Mar 2020 00:52:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="lsG/hasV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726935AbgCUAwK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 20 Mar 2020 20:52:10 -0400
Received: from mail27.static.mailgun.info ([104.130.122.27]:59970 "EHLO
        mail27.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726773AbgCUAwK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 20 Mar 2020 20:52:10 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1584751929; h=Content-Transfer-Encoding: Content-Type:
 In-Reply-To: MIME-Version: Date: Message-ID: References: To: From:
 Subject: Sender; bh=G4z1oKf4SWHGRLRRuZmdZJiLNCa/sv2SEKL0nojzjCA=; b=lsG/hasVGX4qjtd01c36M2hKHDLtgD1HRn6hBkkWbcY1iIPEuy83RYA45xms04QUCxQn/1NA
 oix74Fc0vUf88IUsEQHbSPiCSR09IAlo6ylzTolnciYR9kuVSz9sGJvZLWdO36Iv7hrkxxVt
 bBEv2nOVHCnElS5zRCu3h0v+c7Y=
X-Mailgun-Sending-Ip: 104.130.122.27
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e756536.7fd0e8c2dea0-smtp-out-n05;
 Sat, 21 Mar 2020 00:52:06 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id CC1B3C433CB; Sat, 21 Mar 2020 00:52:05 +0000 (UTC)
Received: from [192.168.8.111] (cpe-70-95-153-89.san.res.rr.com [70.95.153.89])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: asutoshd)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 5044AC433D2;
        Sat, 21 Mar 2020 00:52:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 5044AC433D2
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=asutoshd@codeaurora.org
Subject: Re: [<RFC PATCH v2> 2/3] ufs-qcom: scsi: configure write booster type
From:   "Asutosh Das (asd)" <asutoshd@codeaurora.org>
To:     asutoshd@qti.qualcomm.com, linux-scsi@vger.kernel.org
References: <cover.1584750888.git.asutoshd@codeaurora.org>
 <116b8c6bed27ffbee9da6ccfd52a2fdc612648b4.1584750888.git.asutoshd@codeaurora.org>
Message-ID: <13af63cc-c0f2-72c0-14aa-18ff8fd3751f@codeaurora.org>
Date:   Fri, 20 Mar 2020 17:52:04 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <116b8c6bed27ffbee9da6ccfd52a2fdc612648b4.1584750888.git.asutoshd@codeaurora.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/20/2020 5:48 PM, Asutosh Das wrote:
> Configure the WriteBooster type to preserve user-space mode.
> This would ensure that no user-space capacity is reduced
> when write booster is enabled.
> 
> Change-Id: I4144531a73ea3b5d5ede76beae45722366b1e75c
> Signed-off-by: Asutosh Das <asutoshd@codeaurora.org>
> ---
>   drivers/scsi/ufs/ufs-qcom.c | 7 +++++++
>   1 file changed, 7 insertions(+)
> 
> diff --git a/drivers/scsi/ufs/ufs-qcom.c b/drivers/scsi/ufs/ufs-qcom.c
> index 6115ac6..59f3243 100644
> --- a/drivers/scsi/ufs/ufs-qcom.c
> +++ b/drivers/scsi/ufs/ufs-qcom.c
> @@ -1689,6 +1689,12 @@ static void ufs_qcom_device_reset(struct ufs_hba *hba)
>   	usleep_range(10, 15);
>   }
>   
> +static u32 ufs_qcom_wb_get_user_cap_mode(struct ufs_hba *hba)
> +{
> +	/* QCom prefers no user-space reduction mode */
> +	return UFS_WB_BUFF_PRESERVE_USER_SPACE;
> +}
> +
>   /**
>    * struct ufs_hba_qcom_vops - UFS QCOM specific variant operations
>    *
> @@ -1710,6 +1716,7 @@ static const struct ufs_hba_variant_ops ufs_hba_qcom_vops = {
>   	.resume			= ufs_qcom_resume,
>   	.dbg_register_dump	= ufs_qcom_dump_dbg_regs,
>   	.device_reset		= ufs_qcom_device_reset,
> +	.wb_get_user_cap_mode	= ufs_qcom_wb_get_user_cap_mode,
>   };
>   
>   /**
> 

Hi,
Please ignore this patch, I'll send the proper series.

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
Linux Foundation Collaborative Project
