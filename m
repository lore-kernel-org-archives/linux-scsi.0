Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41DF8C388F9
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Nov 2020 05:28:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AEF772137B
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Nov 2020 05:28:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="f+Xjgmb+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726199AbgKMF2Q (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 13 Nov 2020 00:28:16 -0500
Received: from m42-4.mailgun.net ([69.72.42.4]:64450 "EHLO m42-4.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726091AbgKMF2Q (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 13 Nov 2020 00:28:16 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1605245295; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=Z4CoPUQKb3P3VqbZKi4FCv9J+LRv6YJbMJ76h96Gghk=;
 b=f+Xjgmb+M2w6r3MpkNKl6hU2c+pCh2p1tOt7lCPnXiD3PXftBTtVAgV2ZvO9kNHGGGHUBBRK
 3Fx4vsctaJ02vLd4NKZH3z6YK791XLnv3MHfl7M25z+AZkPM2RcgVnjpMW0zEy7FNWYkVLad
 Jbhm1QDyKk64ChjIYAFLpmpp3DI=
X-Mailgun-Sending-Ip: 69.72.42.4
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n08.prod.us-west-2.postgun.com with SMTP id
 5fae196e8e090a8886634727 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Fri, 13 Nov 2020 05:28:14
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id BA2DDC433CB; Fri, 13 Nov 2020 05:28:14 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 4C60DC433C6;
        Fri, 13 Nov 2020 05:28:13 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Fri, 13 Nov 2020 13:28:13 +0800
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
        jiajie.hao@mediatek.com, alice.chao@mediatek.com
Subject: Re: [PATCH] scsi: ufs: Add retry flow for failed hba enabling
In-Reply-To: <20201112054537.22494-1-stanley.chu@mediatek.com>
References: <20201112054537.22494-1-stanley.chu@mediatek.com>
Message-ID: <473d79ef475169fac15f04c8da8f849e@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-11-12 13:45, Stanley Chu wrote:
> Once hba enabling is failed, add retry mechanism and in the
> meanwhile allow vendors to apply specific handlings before
> the next retry. For example, vendors can do vendor-specific
> host reset flow in variant function "ufshcd_vops_hce_enable_notify()".
> 
> Signed-off-by: Stanley Chu <stanley.chu@mediatek.com>

Reviewed-by: Can Guo <cang@codeaurora.org>

> ---
>  drivers/scsi/ufs/ufshcd.c | 14 ++++++++++----
>  1 file changed, 10 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 8001bbfec5c0..9186ee01379a 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -4328,8 +4328,10 @@ static inline void ufshcd_hba_stop(struct 
> ufs_hba *hba)
>   */
>  static int ufshcd_hba_execute_hce(struct ufs_hba *hba)
>  {
> -	int retry;
> +	int retry_outer = 3;
> +	int retry_inner;
> 
> +start:
>  	if (!ufshcd_is_hba_active(hba))
>  		/* change controller state to "reset state" */
>  		ufshcd_hba_stop(hba);
> @@ -4355,13 +4357,17 @@ static int ufshcd_hba_execute_hce(struct 
> ufs_hba *hba)
>  	ufshcd_delay_us(hba->vps->hba_enable_delay_us, 100);
> 
>  	/* wait for the host controller to complete initialization */
> -	retry = 50;
> +	retry_inner = 50;
>  	while (ufshcd_is_hba_active(hba)) {
> -		if (retry) {
> -			retry--;
> +		if (retry_inner) {
> +			retry_inner--;
>  		} else {
>  			dev_err(hba->dev,
>  				"Controller enable failed\n");
> +			if (retry_outer) {
> +				retry_outer--;
> +				goto start;
> +			}
>  			return -EIO;
>  		}
>  		usleep_range(1000, 1100);
