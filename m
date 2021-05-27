Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD59CC4707F
	for <linux-scsi@archiver.kernel.org>; Thu, 27 May 2021 06:32:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B8743613AC
	for <linux-scsi@archiver.kernel.org>; Thu, 27 May 2021 06:32:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229861AbhE0Gde (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 27 May 2021 02:33:34 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:15073 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229740AbhE0Gdc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 27 May 2021 02:33:32 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1622097120; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=akK0YcDnlMmUdrl3whgiB7gbhZG1JABylH+StbnX3vw=;
 b=H9MH7/VwxluW4x1F+9wpFuNInO6qeTp/+5TAp9MDuikxQSCUm9hb3rRYNEvvIpeIkjrNwsbK
 fmZvtZ3RNEadYNSjIItAbXkOHBu0Gwt9OIjd3AO8N76nt0ZLc3p+6t2mO12Mzm1qxsZ7B0Vw
 7cQ5U3aKGqfp6QCnjuA91GH7C1Y=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-west-2.postgun.com with SMTP id
 60af3ccb67d156359a32560c (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 27 May 2021 06:31:39
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 536FEC43460; Thu, 27 May 2021 06:31:39 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 55BD8C433D3;
        Thu, 27 May 2021 06:31:37 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 27 May 2021 14:31:37 +0800
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
Message-ID: <c02fafb3b4e1b0cb363384de8177a969@codeaurora.org>
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

Unless you are not using runtime PM. Otherwise, when abort happens
to SSU cmd (sent from pm ops), your change will lead to a live lock,
because ufshcd_eh_host_reset_handler() invokes error handling and
flushes it, error handling calls runtime_pm_get_sync(), which flushes
pm ops, while pm ops is blocked by SSU cmd.

To be on the safe side, you should move these codes after below
check in ufshcd_abort(), right before sending task abort TMRs.

  /*
   * Task abort to the device W-LUN is illegal. When this command
   * will fail, due to spec violation, scsi err handling next step
   * will be to send LU reset which, again, is a spec violation.
   * To avoid these unnecessary/illegal steps, first we clean up
   * the lrb taken by this cmd and mark the lrb as in_use, then
   * queue the eh_work and bail.
   */
   if (lrbp->lun == UFS_UPIU_UFS_DEVICE_WLUN) {
     ...

     goto out;
   }

Thanks,

Can Guo.

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
