Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98D39C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Oct 2021 06:10:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7629A60F57
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Oct 2021 06:10:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231248AbhJUGMu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 21 Oct 2021 02:12:50 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:22853 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230095AbhJUGMu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 21 Oct 2021 02:12:50 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1634796635; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=JfB3g7Mo4BBuUaUjm4HKsQghLnYQpwiZK7oz3TCDBnI=;
 b=wrsdXf3m0uHbqBh2/k1nxBhc0zVqtb2b2KMdHfcP/2ZQGGKffCsHBsVBGbi0ejeyk3g7yvi6
 wYtn0LQiUoCOTNcEqdQVCIqA4INp7xmocTagkZJnfwc35U0/svnkIjMBsTRWgrE5RMEXNNrV
 rYpERhcPgGUxRRmrmoiem/ctJXA=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n06.prod.us-west-2.postgun.com with SMTP id
 6171044dbc30296958a5453a (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 21 Oct 2021 06:10:21
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 36E02C4360D; Thu, 21 Oct 2021 06:10:21 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 28BE3C4338F;
        Thu, 21 Oct 2021 06:10:19 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 21 Oct 2021 14:10:19 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Kiwoong Kim <kwmad.kim@samsung.com>
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        alim.akhtar@samsung.com, avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, beanhuo@micron.com,
        adrian.hunter@intel.com, sc.suh@samsung.com, hy50.seo@samsung.com,
        sh425.lee@samsung.com, bhoon95.kim@samsung.com,
        vkumar.1997@samsung.com
Subject: Re: [PATCH RESEND v2] scsi: ufs: clear doorbell for hibern8 errors
 when using ah8
In-Reply-To: <1634619427-171880-1-git-send-email-kwmad.kim@samsung.com>
References: <CGME20211019051346epcas2p132d3b9c6a1c812f3132e913525235b83@epcas2p1.samsung.com>
 <1634619427-171880-1-git-send-email-kwmad.kim@samsung.com>
Message-ID: <ce88a8c47d46acd43b3645a3b97ab956@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021-10-19 12:57, Kiwoong Kim wrote:
> Changes from v1:
> * Change the time to requeue pended commands
> 
> When an scsi command is dispatched right after host complete
> all the pended requests and ufs driver tries to ring a doorbell,
> host might be still during entering into hibern8.
> If the hibern8 error occurrs during that period, the doorbell
> might not be zero and clearing it should have done.
> But, current ufshcd_err_handler goes directly to reset
> w/o clearing the doorbell when the driver's link state is broken.

         /*
          * Stop the host controller and complete the requests
          * cleared by h/w
          */
         ufshcd_hba_stop(hba);
         hba->silence_err_logs = true;
         ufshcd_complete_requests(hba);

Same ask as Adrian did, ufshcd_hba_stop() should clear all doorbell
bits as it disables UFS host controller, then ufshcd_complete_requests()
completes any pending requests, no?

> This patch is to requeue pended commands after host reset.
> 
> Here's an actual symptom that I've faced. At the time, tag #17
> is still pended even after host reset. And then the block timer
> is expired.
> 
> exynos-ufs 11100000.ufs: ufshcd_check_errors: Auto Hibern8
> Enter failed - status: 0x00000040, upmcrs: 0x00000001
> ..
> host_regs: 00000050: b8671000 00000008 00020000 00000000
> ..
> exynos-ufs 11100000.ufs: ufshcd_abort: Device abort task at tag 17
> 
> Signed-off-by: Kiwoong Kim <kwmad.kim@samsung.com>
> ---
>  drivers/scsi/ufs/ufshcd.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 9faf02c..e5d4ef7 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -7136,8 +7136,10 @@ static int ufshcd_host_reset_and_restore(struct
> ufs_hba *hba)
>  	err = ufshcd_hba_enable(hba);
> 
>  	/* Establish the link again and restore the device */
> -	if (!err)
> +	if (!err) {
> +		ufshcd_retry_aborted_requests(hba);
>  		err = ufshcd_probe_hba(hba, false);
> +	}
> 
>  	if (err)
>  		dev_err(hba->dev, "%s: Host init failed %d\n", __func__, err);
