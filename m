Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16812C63777
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Dec 2020 05:34:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B323720758
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Dec 2020 05:34:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727177AbgLCFej (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 3 Dec 2020 00:34:39 -0500
Received: from a2.mail.mailgun.net ([198.61.254.61]:61932 "EHLO
        a2.mail.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726230AbgLCFej (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Dec 2020 00:34:39 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1606973660; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=sqV3wNOA6wV/oHBe9aLAtgMazUTZWFPTZRerFCF5Yc8=;
 b=vdQC13pXd3yCqOptwfP0vlNJN9PiaDwkGnMJ360ejhXT7DXifGb+7GknC0VrhtyRM0VCZVon
 Se8eTfYmo1TJV+efMbHhXTytKa/8irULMqqGXcZSPzgki+kID3WOz4iFrYVZvJlxzFCTr9ui
 hl7GHvff4n3ExgHUBG04fbbeA7Y=
X-Mailgun-Sending-Ip: 198.61.254.61
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-east-1.postgun.com with SMTP id
 5fc878ae89b9bc626853cdf3 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 03 Dec 2020 05:33:34
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 6672AC43462; Thu,  3 Dec 2020 05:33:33 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 3B3D9C433ED;
        Thu,  3 Dec 2020 05:33:32 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 03 Dec 2020 13:33:32 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Stanley Chu <stanley.chu@mediatek.com>
Cc:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        avri.altman@wdc.com, alim.akhtar@samsung.com, jejb@linux.ibm.com,
        beanhuo@micron.com, asutoshd@codeaurora.org,
        matthias.bgg@gmail.com, bvanassche@acm.org,
        linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kuohong.wang@mediatek.com, peter.wang@mediatek.com,
        chun-hung.wu@mediatek.com, andy.teng@mediatek.com,
        chaotian.jing@mediatek.com, cc.chou@mediatek.com,
        jiajie.hao@mediatek.com, alice.chao@mediatek.com,
        huadian.liu@mediatek.com
Subject: Re: [PATCH v1 1/3] scsi: ufs: Add error history for abort event in
 UFS Device W-LUN
In-Reply-To: <20201126053839.25889-2-stanley.chu@mediatek.com>
References: <20201126053839.25889-1-stanley.chu@mediatek.com>
 <20201126053839.25889-2-stanley.chu@mediatek.com>
Message-ID: <e22b55de9d0b0dd26b26b1425180592c@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-11-26 13:38, Stanley Chu wrote:
> Add error history for abort event in UFS Device W-LUN.
> Besides, use specified value as parameter of ufshcd_update_reg_hist()
> to identify the aborted tag or LUNs.
> 
> Signed-off-by: Stanley Chu <stanley.chu@mediatek.com>
> ---
>  drivers/scsi/ufs/ufshcd.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 0e5473d4699b..28e4def13f21 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -6742,8 +6742,10 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
>  	 * To avoid these unnecessary/illegal step we skip to the last error
>  	 * handling stage: reset and restore.
>  	 */
> -	if (lrbp->lun == UFS_UPIU_UFS_DEVICE_WLUN)
> +	if (lrbp->lun == UFS_UPIU_UFS_DEVICE_WLUN) {
> +		ufshcd_update_reg_hist(&hba->ufs_stats.task_abort, lrbp->lun);
>  		return ufshcd_eh_host_reset_handler(cmd);
> +	}
> 
>  	ufshcd_hold(hba, false);
>  	reg = ufshcd_readl(hba, REG_UTP_TRANSFER_REQ_DOOR_BELL);
> @@ -6767,7 +6769,7 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
>  	 */
>  	scsi_print_command(hba->lrb[tag].cmd);
>  	if (!hba->req_abort_count) {
> -		ufshcd_update_reg_hist(&hba->ufs_stats.task_abort, 0);
> +		ufshcd_update_reg_hist(&hba->ufs_stats.task_abort, tag);
>  		ufshcd_print_host_regs(hba);
>  		ufshcd_print_host_state(hba);
>  		ufshcd_print_pwr_info(hba);

Reviewed-by: Can Guo <cang@codeaurora.org>
