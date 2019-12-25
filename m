Return-Path: <SRS0=On0Q=2P=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 361A4C2D0DC
	for <linux-scsi@archiver.kernel.org>; Wed, 25 Dec 2019 08:18:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0BE492072A
	for <linux-scsi@archiver.kernel.org>; Wed, 25 Dec 2019 08:18:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="q7IUso9U"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726943AbfLYISk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 25 Dec 2019 03:18:40 -0500
Received: from mail26.static.mailgun.info ([104.130.122.26]:60678 "EHLO
        mail26.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726896AbfLYISk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 25 Dec 2019 03:18:40 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1577261919; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=RiSbEYGAd8tj1/i8Rgfcv4ZB+PqlDH70iICtBq7Oqs8=;
 b=q7IUso9UeIIESKxFc5WgRVejkqZAd1577Nu0yetvSQSiTDi/+j2SI4HKMH7y5jgwvVoFFmas
 GSjmQ5bjcto0RTvfj4uYY8VNVrw09pXyuIvO+/i9iL5M0tZOHLlgk3YlmocZsRehemz6WqYY
 6R0i2DJ8ALLdF5c8QMQpZuLvnJw=
X-Mailgun-Sending-Ip: 104.130.122.26
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e031b5b.7fb37621d1b8-smtp-out-n03;
 Wed, 25 Dec 2019 08:18:35 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 4701AC447A0; Wed, 25 Dec 2019 08:18:35 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 90274C433CB;
        Wed, 25 Dec 2019 08:18:34 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 25 Dec 2019 16:18:34 +0800
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
Subject: Re: [PATCH v1 2/2] scsi: ufs: use ufshcd_vops_dbg_register_dump for
 vendor specific dumps
In-Reply-To: <1577192466-20762-3-git-send-email-stanley.chu@mediatek.com>
References: <1577192466-20762-1-git-send-email-stanley.chu@mediatek.com>
 <1577192466-20762-3-git-send-email-stanley.chu@mediatek.com>
Message-ID: <bcd1f1aa6bcc94951f1f52de9d4b0e38@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2019-12-24 21:01, Stanley Chu wrote:
> We already have ufshcd_vops_dbg_register_dump() thus all
> "hba->vops->dbg_register_dump" references can be replaced by it.
> 
> Signed-off-by: Stanley Chu <stanley.chu@mediatek.com>
> ---
>  drivers/scsi/ufs/ufshcd.c |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index b6b9665..1ac9272 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -428,8 +428,7 @@ static void ufshcd_print_host_regs(struct ufs_hba 
> *hba)
> 
>  	ufshcd_print_clk_freqs(hba);
> 
> -	if (hba->vops && hba->vops->dbg_register_dump)
> -		hba->vops->dbg_register_dump(hba);
> +	ufshcd_vops_dbg_register_dump(hba);
>  }
> 
>  static

Reviewed-by: Can Guo <cang@codeaurora.org>
