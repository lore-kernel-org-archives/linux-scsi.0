Return-Path: <SRS0=On0Q=2P=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B515C2D0DA
	for <linux-scsi@archiver.kernel.org>; Wed, 25 Dec 2019 08:21:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4B2742071E
	for <linux-scsi@archiver.kernel.org>; Wed, 25 Dec 2019 08:21:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="KzZ1lYnZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726307AbfLYIVf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 25 Dec 2019 03:21:35 -0500
Received: from mail26.static.mailgun.info ([104.130.122.26]:38074 "EHLO
        mail26.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726196AbfLYIVe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 25 Dec 2019 03:21:34 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1577262094; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=K83HIkx3t93SDXJyO1FB5pObJwAm8xvbYEkqpHJP7VU=;
 b=KzZ1lYnZXABHLGW+LfuREx5Q16m+AVFcQym3kHGtrFukm2NIyIdHDvsTkgvHwq+umDbjUtJt
 YKTCwk9IY2q6MCa7wIh35785HevKtGTKbZb0094ahaSaiwfiXABY2ZaznlaChc0btMzpJ8pg
 z33Xn1WiJ388lALCQ9Wu+cln1hg=
X-Mailgun-Sending-Ip: 104.130.122.26
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e031c07.7f0166a369d0-smtp-out-n02;
 Wed, 25 Dec 2019 08:21:27 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id E6CBEC447A5; Wed, 25 Dec 2019 08:21:25 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 09744C433CB;
        Wed, 25 Dec 2019 08:21:25 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 25 Dec 2019 16:21:25 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Stanley Chu <stanley.chu@mediatek.com>
Cc:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        avri.altman@wdc.com, alim.akhtar@samsung.com,
        pedrom.sousa@synopsys.com, jejb@linux.ibm.com,
        matthias.bgg@gmail.com, beanhuo@micron.com,
        linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kuohong.wang@mediatek.com, peter.wang@mediatek.com,
        chun-hung.wu@mediatek.com, andy.teng@mediatek.com
Subject: Re: [PATCH v1 1/2] scsi: ufs: unify scsi_block_requests usage
In-Reply-To: <1577192466-20762-2-git-send-email-stanley.chu@mediatek.com>
References: <1577192466-20762-1-git-send-email-stanley.chu@mediatek.com>
 <1577192466-20762-2-git-send-email-stanley.chu@mediatek.com>
Message-ID: <d97b91ae4547e5b6e433891446a68545@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2019-12-24 21:01, Stanley Chu wrote:
> Currently UFS driver has ufshcd_scsi_block_requests() with
> reference counter mechanism to avoid possible racing of blocking and
> unblocking requests flow. Unify all users in UFS driver to use the
> same function.
> 
> Signed-off-by: Stanley Chu <stanley.chu@mediatek.com>
> ---
>  drivers/scsi/ufs/ufshcd.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index ed02a70..b6b9665 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -5177,7 +5177,7 @@ static void
> ufshcd_exception_event_handler(struct work_struct *work)
>  	hba = container_of(work, struct ufs_hba, eeh_work);
> 
>  	pm_runtime_get_sync(hba->dev);
> -	scsi_block_requests(hba->host);
> +	ufshcd_scsi_block_requests(hba);
>  	err = ufshcd_get_ee_status(hba, &status);
>  	if (err) {
>  		dev_err(hba->dev, "%s: failed to get exception status %d\n",
> @@ -5191,7 +5191,7 @@ static void
> ufshcd_exception_event_handler(struct work_struct *work)
>  		ufshcd_bkops_exception_event_handler(hba);
> 
>  out:
> -	scsi_unblock_requests(hba->host);
> +	ufshcd_scsi_unblock_requests(hba);
>  	pm_runtime_put_sync(hba->dev);
>  	return;
>  }

Reviewed-by: Can Guo <cang@codeaurora.org>
