Return-Path: <SRS0=I90e=23=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66A0DC33C9B
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Jan 2020 17:34:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3DA8920731
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Jan 2020 17:34:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="iSb4af44"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726700AbgAFReR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 6 Jan 2020 12:34:17 -0500
Received: from mail25.static.mailgun.info ([104.130.122.25]:22630 "EHLO
        mail25.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726641AbgAFReP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Jan 2020 12:34:15 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1578332054; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=LtY77c4ckIl8xeGO5RUZJ/girLgK8v2bv5Hi6fr6xIs=;
 b=iSb4af44CA6/wU2Pek/ZrATPSUpmUgHj/Jh4Dv7vCS0AMLtQudBfB8iYzYPk1tjcixprWmyZ
 krnBw5OyMRP4l4Ixr+Mqg9JpE7fopfHtSDrt6exRAcG4im8U+VejEJ3JGgwnMg/XZ0plaSc3
 7V1VCKfl/wlIa5AoWGUgYPCfxL4=
X-Mailgun-Sending-Ip: 104.130.122.25
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e136f91.7ff56db82bc8-smtp-out-n02;
 Mon, 06 Jan 2020 17:34:09 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 5219AC447AA; Mon,  6 Jan 2020 17:34:07 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: asutoshd)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id BC4CAC43383;
        Mon,  6 Jan 2020 17:34:05 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 06 Jan 2020 09:34:05 -0800
From:   asutoshd@codeaurora.org
To:     Stanley Chu <stanley.chu@mediatek.com>
Cc:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        avri.altman@wdc.com, alim.akhtar@samsung.com, jejb@linux.ibm.com,
        beanhuo@micron.com, cang@codeaurora.org, matthias.bgg@gmail.com,
        bvanassche@acm.org, linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kuohong.wang@mediatek.com, peter.wang@mediatek.com,
        chun-hung.wu@mediatek.com, andy.teng@mediatek.com,
        linux-scsi-owner@vger.kernel.org
Subject: Re: [PATCH v1 1/3] scsi: ufs: fix empty check of error history
In-Reply-To: <1578147968-30938-2-git-send-email-stanley.chu@mediatek.com>
References: <1578147968-30938-1-git-send-email-stanley.chu@mediatek.com>
 <1578147968-30938-2-git-send-email-stanley.chu@mediatek.com>
Message-ID: <926596b3823333bd8d31aed8630509de@codeaurora.org>
X-Sender: asutoshd@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-01-04 06:26, Stanley Chu wrote:
> Currently checking if an error history element is empty or
> not is by its "value". In most cases, value is error code.
> 
> However this checking is not correct because some errors or
> events do not specify any values in error history so values
> remain as 0, and this will lead to incorrect empty checking.
> 
> Fix it by checking "timestamp" instead of "value" because
> timestamp will be always assigned for all history elements
> 
> Cc: Alim Akhtar <alim.akhtar@samsung.com>
> Cc: Asutosh Das <asutoshd@codeaurora.org>
> Cc: Avri Altman <avri.altman@wdc.com>
> Cc: Bart Van Assche <bvanassche@acm.org>
> Cc: Bean Huo <beanhuo@micron.com>
> Cc: Can Guo <cang@codeaurora.org>
> Cc: Matthias Brugger <matthias.bgg@gmail.com>
> Signed-off-by: Stanley Chu <stanley.chu@mediatek.com>
> ---
>  drivers/scsi/ufs/ufshcd.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 1b97f2dc0b63..bae43da00bb6 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -385,7 +385,7 @@ static void ufshcd_print_err_hist(struct ufs_hba 
> *hba,
>  	for (i = 0; i < UFS_ERR_REG_HIST_LENGTH; i++) {
>  		int p = (i + err_hist->pos) % UFS_ERR_REG_HIST_LENGTH;
> 
> -		if (err_hist->reg[p] == 0)
> +		if (err_hist->tstamp[p] == 0)
>  			continue;
>  		dev_err(hba->dev, "%s[%d] = 0x%x at %lld us\n", err_name, p,
>  			err_hist->reg[p], ktime_to_us(err_hist->tstamp[p]));

Looks good to me.

Reviewed by:- Asutosh Das <asutoshd@codeaurora.org>
