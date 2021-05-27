Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E71F0C47089
	for <linux-scsi@archiver.kernel.org>; Thu, 27 May 2021 06:54:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C6102613D4
	for <linux-scsi@archiver.kernel.org>; Thu, 27 May 2021 06:54:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233044AbhE0Gzb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 27 May 2021 02:55:31 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:16413 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233633AbhE0Gza (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 27 May 2021 02:55:30 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1622098438; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=TQxrZsZkNMWPoXXaHnAVoq6d9by44utK3awW5Rc63x8=;
 b=tMs6LUerR60sfvP5vIQ8dBc3n5wUriqSuK3TNf9c+Qy8tHkl1iKz2qoNjBU9fTiB8EVj2Uyp
 DypmbjfAw1PNMd3mmK5nl2IID9ifD3Zz3UNYUIsC73sgr/0ykHNWJNE7J5/J7W4owjLIDFPU
 K3J2J2IkkAz/O0L24c2akqaxLS4=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n06.prod.us-east-1.postgun.com with SMTP id
 60af41f3d1aee7698ddbf905 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 27 May 2021 06:53:39
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id EAC5DC43460; Thu, 27 May 2021 06:53:38 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id C9744C433F1;
        Thu, 27 May 2021 06:53:36 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 27 May 2021 14:53:36 +0800
From:   Can Guo <cang@codeaurora.org>
To:     jongmin jeong <jjmin.jeong@samsung.com>
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        alim.akhtar@samsung.com, avri.altman@wdc.com, beanhuo@micron.com,
        adrian.hunter@intel.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] scsi: ufs: add quirk to support host reset only
In-Reply-To: <20210527030901.88403-4-jjmin.jeong@samsung.com>
References: <20210527030901.88403-1-jjmin.jeong@samsung.com>
 <CGME20210527031220epcas2p41a5ba641919769ca95ccea81e5f3bfb0@epcas2p4.samsung.com>
 <20210527030901.88403-4-jjmin.jeong@samsung.com>
Message-ID: <a31867eaf47a298baeec714f29e9cafe@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021-05-27 11:09, jongmin jeong wrote:
> samsung ExynosAuto SoC has two types of host controller interface to
> support the virtualization of UFS Device.
> One is the physical host(PH) that the same as conventaional UFSHCI,
> and the other is the virtual host(VH) that support data transfer 
> function only.
> 
> In this structure, the virtual host does support host reset handler 
> only.
> This patch calls the host reset handler when abort or device reset 
> handler
> has occured in the virtual host.

One more question, as per the plot in the cover letter, the VH does 
support TMRs.
Why are you trying to make ufshcd_abort() and 
ufshcd_eh_device_reset_handler()
no-ops?

Thanks,

Can Guo.

> 
> Change-Id: I3f07e772415a35fe1e7374e02b3c37ef0bf5660d
> Signed-off-by: jongmin jeong <jjmin.jeong@samsung.com>
> ---
>  drivers/scsi/ufs/ufshcd.c | 7 +++++++
>  drivers/scsi/ufs/ufshcd.h | 6 ++++++
>  2 files changed, 13 insertions(+)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 4787e40c6a2d..9d1912290f87 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -6826,6 +6826,9 @@ static int ufshcd_eh_device_reset_handler(struct
> scsi_cmnd *cmd)
>  	u8 resp = 0xF, lun;
>  	unsigned long flags;
> 
> +	if (hba->quirks & UFSHCD_QUIRK_BROKEN_RESET_HANDLER)
> +		return ufshcd_eh_host_reset_handler(cmd);
> +
>  	host = cmd->device->host;
>  	hba = shost_priv(host);
> 
> @@ -6972,6 +6975,10 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
>  	host = cmd->device->host;
>  	hba = shost_priv(host);
>  	tag = cmd->request->tag;
> +
> +	if (hba->quirks & UFSHCD_QUIRK_BROKEN_RESET_HANDLER)
> +		return ufshcd_eh_host_reset_handler(cmd);
> +
>  	lrbp = &hba->lrb[tag];
>  	if (!ufshcd_valid_tag(hba, tag)) {
>  		dev_err(hba->dev,
> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
> index 0ab4c296be32..82a9c6889978 100644
> --- a/drivers/scsi/ufs/ufshcd.h
> +++ b/drivers/scsi/ufs/ufshcd.h
> @@ -581,6 +581,12 @@ enum ufshcd_quirks {
>  	 * support interface configuration.
>  	 */
>  	UFSHCD_QUIRK_SKIP_INTERFACE_CONFIGURATION	= 1 << 16,
> +
> +	/*
> +	 * This quirk needs to be enabled if the host controller support
> +	 * host reset handler only.
> +	 */
> +	UFSHCD_QUIRK_BROKEN_RESET_HANDLER		= 1 << 17,
>  };
> 
>  enum ufshcd_caps {
