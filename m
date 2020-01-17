Return-Path: <SRS0=Mkh6=3G=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5072C33CB6
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Jan 2020 18:23:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B04B0206D5
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Jan 2020 18:23:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="Yj0+ip9v"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728773AbgAQSXO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Jan 2020 13:23:14 -0500
Received: from mail25.static.mailgun.info ([104.130.122.25]:43194 "EHLO
        mail25.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727115AbgAQSXN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 17 Jan 2020 13:23:13 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1579285393; h=Content-Transfer-Encoding: Content-Type:
 In-Reply-To: MIME-Version: Date: Message-ID: From: References: Cc: To:
 Subject: Sender; bh=HAaZWipyM1y+vRZdQSfIUDV8Xxf9D/hWbucFY0TcBKk=; b=Yj0+ip9vwDduhqmesh30U/ZwVYkJ2LqPtkqhg9LeXpR588Gn/dNPmsqLWm4XU2uI+ZK0Ke68
 GSwUTbXY5XFPUHpoqdZnGUeySjIHP+ThuYgMUUi6MdBjx7NTZuGluKggy/JIsA1d8qO5D/ah
 FcYJ1SG374lc9IDxELe+jSyPCAs=
X-Mailgun-Sending-Ip: 104.130.122.25
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e21fb8e.7fd20340cab0-smtp-out-n02;
 Fri, 17 Jan 2020 18:23:10 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 73023C447A2; Fri, 17 Jan 2020 18:23:09 +0000 (UTC)
Received: from [10.46.161.159] (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: asutoshd)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 38CC4C43383;
        Fri, 17 Jan 2020 18:23:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 38CC4C43383
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=none smtp.mailfrom=asutoshd@codeaurora.org
Subject: Re: [PATCH v2 1/9] scsi: ufs: goto with returned value while failed
 to add WL
To:     Bean Huo <huobean@gmail.com>, alim.akhtar@samsung.com,
        avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200116215914.16015-1-huobean@gmail.com>
 <20200116215914.16015-2-huobean@gmail.com>
From:   "Asutosh Das (asd)" <asutoshd@codeaurora.org>
Message-ID: <4f93045d-6c42-5f74-0e85-8b7019cd765f@codeaurora.org>
Date:   Fri, 17 Jan 2020 10:23:07 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <20200116215914.16015-2-huobean@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/16/2020 1:59 PM, Bean Huo wrote:
> From: Bean Huo <beanhuo@micron.com>
> 
> This patch is to make goto statement with failure result in case of
> failure of adding well known LUs.
> 
> Fixes: 2a8fa600445c ("ufs: manually add well known logical units")
> Signed-off-by: Bean Huo <beanhuo@micron.com>
> ---
>   drivers/scsi/ufs/ufshcd.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index bea036ab189a..9a9085a7bcc5 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -7032,7 +7032,8 @@ static int ufshcd_probe_hba(struct ufs_hba *hba)
>   			ufshcd_init_icc_levels(hba);
>   
>   		/* Add required well known logical units to scsi mid layer */
> -		if (ufshcd_scsi_add_wlus(hba))
> +		ret = ufshcd_scsi_add_wlus(hba);
> +		if (ret)
>   			goto out;
>   
>   		/* Initialize devfreq after UFS device is detected */
> 

Please retain my reviewed-by tag, if you change the commit message as 
per Bart's reviews in your next version.

Reviewed-by: Asutosh Das <asutoshd@codeaurora.org>

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
Linux Foundation Collaborative Project
