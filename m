Return-Path: <SRS0=wj+1=BI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B44BFC433E1
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Jul 2020 08:43:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 95B152076E
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Jul 2020 08:43:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="ixT2Au1O"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727837AbgG2Inb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Jul 2020 04:43:31 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:14460 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726299AbgG2Inb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 29 Jul 2020 04:43:31 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1596012210; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=cIxFU1Sf6NzJjHO4VHHHl57xTd4T7Fn4JzLrmk5w8xk=;
 b=ixT2Au1O31fiI5G2+e91XLqSC2TQPf4F9PwfG4bob8O36/oCp89Iu2x06kGqidkm8N/2Eqag
 4IQODi/3hNG7efSYIN2VfBpa8BJrz0RvRRpQYD0EUy5yOXIUd1zilOFYSKxgr6D4LNmIOHmw
 kKq3LEgujZWeFfKbIYPA+9mGCQw=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n08.prod.us-west-2.postgun.com with SMTP id
 5f2136b135f3e3d31631d45e (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 29 Jul 2020 08:43:29
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 28C60C433A0; Wed, 29 Jul 2020 08:43:29 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 988A4C433CA;
        Wed, 29 Jul 2020 08:43:27 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 29 Jul 2020 16:43:27 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Stanley Chu <stanley.chu@mediatek.com>
Cc:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        avri.altman@wdc.com, alim.akhtar@samsung.com, jejb@linux.ibm.com,
        bvanassche@acm.org, beanhuo@micron.com, asutoshd@codeaurora.org,
        matthias.bgg@gmail.com, linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kuohong.wang@mediatek.com, peter.wang@mediatek.com,
        chun-hung.wu@mediatek.com, andy.teng@mediatek.com,
        chaotian.jing@mediatek.com, cc.chou@mediatek.com
Subject: Re: [PATCH v2] scsi: ufs: Fix possible infinite loop in ufshcd_hold
In-Reply-To: <20200729024037.23105-1-stanley.chu@mediatek.com>
References: <20200729024037.23105-1-stanley.chu@mediatek.com>
Message-ID: <bfbb48b06fa3464da0cbd2aee8a32649@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Stanley,

On 2020-07-29 10:40, Stanley Chu wrote:
> In ufshcd_suspend(), after clk-gating is suspended and link is set
> as Hibern8 state, ufshcd_hold() is still possibly invoked before
> ufshcd_suspend() returns. For example, MediaTek's suspend vops may
> issue UIC commands which would call ufshcd_hold() during the command
> issuing flow.
> 
> Now if UFSHCD_CAP_HIBERN8_WITH_CLK_GATING capability is enabled,
> then ufshcd_hold() may enter infinite loops because there is no
> clk-ungating work scheduled or pending. In this case, ufshcd_hold()
> shall just bypass, and keep the link as Hibern8 state.
> 

The infinite loop is expected as ufshcd_hold is called again after
link is put to hibern8 state, so in QCOM's code, we never do this.
The cap UFSHCD_CAP_HIBERN8_WITH_CLK_GATING means UIC link state
must not be HIBERN8 after ufshcd_hold(async=false) returns.

Instead of bailing out from that loop, which makes the logic of
ufshcd_hold and clk gating even more complex, how about removing
ufshcd_hold/release from ufshcd_send_uic_cmd()? I think they are
redundant and we should never send DME cmds if clocks/powers are
not ready. I mean callers should make sure they are ready to send
DME cmds (and only callers know when), but not leave that job to
ufshcd_send_uic_cmd(). It is convenient to remove ufshcd_hold/
release from ufshcd_send_uic_cmd() as there are not many places
sending DME cmds without holding the clocks, ufs_bsg.c is one.
And I have tested my idea on my setup, it worked well for me.
Another benefit is that it also allows us to use DME cmds
in clk gating/ungating contexts if we need to in the future.

Please let me know your idea, thanks.

Can Guo.

> Signed-off-by: Stanley Chu <stanley.chu@mediatek.com>
> Signed-off-by: Andy Teng <andy.teng@mediatek.com>
> 
> ---
> 
> Changes since v1:
> - Fix return value: Use unique bool variable to get the result of
> flush_work(). Thcan prevent incorrect returned value, i.e., rc, if
> flush_work() returns true
> - Fix commit message
> 
> ---
>  drivers/scsi/ufs/ufshcd.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 577cc0d7487f..acba2271c5d3 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -1561,6 +1561,7 @@ static void ufshcd_ungate_work(struct work_struct 
> *work)
>  int ufshcd_hold(struct ufs_hba *hba, bool async)
>  {
>  	int rc = 0;
> +	bool flush_result;
>  	unsigned long flags;
> 
>  	if (!ufshcd_is_clkgating_allowed(hba))
> @@ -1592,7 +1593,9 @@ int ufshcd_hold(struct ufs_hba *hba, bool async)
>  				break;
>  			}
>  			spin_unlock_irqrestore(hba->host->host_lock, flags);
> -			flush_work(&hba->clk_gating.ungate_work);
> +			flush_result = flush_work(&hba->clk_gating.ungate_work);
> +			if (hba->clk_gating.is_suspended && !flush_result)
> +				goto out;
>  			spin_lock_irqsave(hba->host->host_lock, flags);
>  			goto start;
>  		}
