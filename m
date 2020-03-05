Return-Path: <SRS0=fWC9=4W=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACF0AC3F2D1
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Mar 2020 05:45:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7F7582146E
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Mar 2020 05:45:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="q10U0i6D"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725900AbgCEFp7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 5 Mar 2020 00:45:59 -0500
Received: from mail26.static.mailgun.info ([104.130.122.26]:61650 "EHLO
        mail26.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725880AbgCEFp6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Mar 2020 00:45:58 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1583387158; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=xJc+7Bp3FwZ9FEajchA9Dd3Tszwww0y5sCjNNZKDRO0=;
 b=q10U0i6D5v3zTmSJDSuf5WD8O8dJ5QE8gvk25KAkgJaZuVPjOEoeIoD7t1bHn9oa3OpRUCFL
 kP5MULLLw1ihWRMpNuCMCmjMRC1ESrPGq3lC699Senkq/Im8hXHrk/krNynagMlyzYf4Sh8U
 yDVMGkU+eGae/P9IvCCX2L1N/4Q=
X-Mailgun-Sending-Ip: 104.130.122.26
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e609211.7f6d2737ee30-smtp-out-n03;
 Thu, 05 Mar 2020 05:45:53 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id E1998C4479F; Thu,  5 Mar 2020 05:45:51 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 03824C43383;
        Thu,  5 Mar 2020 05:45:50 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 05 Mar 2020 13:45:49 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Stanley Chu <stanley.chu@mediatek.com>
Cc:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        avri.altman@wdc.com, alim.akhtar@samsung.com, jejb@linux.ibm.com,
        beanhuo@micron.com, asutoshd@codeaurora.org,
        matthias.bgg@gmail.com, bvanassche@acm.org,
        linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kuohong.wang@mediatek.com, peter.wang@mediatek.com,
        chun-hung.wu@mediatek.com, andy.teng@mediatek.com
Subject: Re: [PATCH v1 3/4] scsi: ufs: allow customized delay for host
 enabling
In-Reply-To: <20200305040704.10645-4-stanley.chu@mediatek.com>
References: <20200305040704.10645-1-stanley.chu@mediatek.com>
 <20200305040704.10645-4-stanley.chu@mediatek.com>
Message-ID: <1d7964c76ceb218529f0101499fabbea@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Stanley,

On 2020-03-05 12:07, Stanley Chu wrote:
> Currently a 1 ms delay is applied before polling CONTROLLER_ENABLE
> bit. This delay may not be required or can be changed in different
> controllers. Make the delay as a changeable value in struct ufs_hba to
> allow it customized by vendors.
> 
> Signed-off-by: Stanley Chu <stanley.chu@mediatek.com>

Reviewed-by: Can Guo <cang@codeaurora.org>

> ---
>  drivers/scsi/ufs/ufshcd.c | 6 +++++-
>  drivers/scsi/ufs/ufshcd.h | 1 +
>  2 files changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index ed61ecb98b2d..39cae907abd0 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -4282,7 +4282,10 @@ int ufshcd_hba_enable(struct ufs_hba *hba)
>  	 * instruction might be read back.
>  	 * This delay can be changed based on the controller.
>  	 */
> -	usleep_range(1000, 1100);
> +	if (hba->hba_enable_delay_us) {
> +		usleep_range(hba->hba_enable_delay_us,
> +			     hba->hba_enable_delay_us + 100);
> +	}
> 
>  	/* wait for the host controller to complete initialization */
>  	retry = 10;
> @@ -8402,6 +8405,7 @@ int ufshcd_init(struct ufs_hba *hba, void
> __iomem *mmio_base, unsigned int irq)
> 
>  	hba->mmio_base = mmio_base;
>  	hba->irq = irq;
> +	hba->hba_enable_delay_us = 1000;
> 
>  	err = ufshcd_hba_init(hba);
>  	if (err)
> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
> index 49ade1bfd085..baf1143d4839 100644
> --- a/drivers/scsi/ufs/ufshcd.h
> +++ b/drivers/scsi/ufs/ufshcd.h
> @@ -662,6 +662,7 @@ struct ufs_hba {
>  	u32 eh_flags;
>  	u32 intr_mask;
>  	u16 ee_ctrl_mask;
> +	u16 hba_enable_delay_us;
>  	bool is_powered;
> 
>  	/* Work Queues */
