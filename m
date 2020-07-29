Return-Path: <SRS0=wj+1=BI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44873C433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Jul 2020 10:53:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1AE5B20663
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Jul 2020 10:53:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="r5xDh54R"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726385AbgG2Kxa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Jul 2020 06:53:30 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:12924 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726299AbgG2Kxa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 29 Jul 2020 06:53:30 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1596020009; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=n1CY9UAqIvLrlKb0rj2uThTnQrOwR0zo841z1xrGeiw=;
 b=r5xDh54R9jzZ0Gu/zFJZHzeNpBRaP97XnD7uuKSa627w+pZhRIUuBwSfPHr5coJqY3TvDeRa
 pDDSOalk6zEkbH9N5tdvSlpqAeuJDe4nBkwYkBoTrIv2bf77CaVQnOnwN6/g6Gq5g9wa76TS
 d45J8EGFQHcpm4K7FiWC9TKWEY4=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n05.prod.us-east-1.postgun.com with SMTP id
 5f215527fcbecb3df12f577c (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 29 Jul 2020 10:53:27
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 5BE42C433AD; Wed, 29 Jul 2020 10:53:26 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id DF473C433C6;
        Wed, 29 Jul 2020 10:53:24 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 29 Jul 2020 18:53:24 +0800
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
In-Reply-To: <1596018374.17247.41.camel@mtkswgap22>
References: <20200729024037.23105-1-stanley.chu@mediatek.com>
 <bfbb48b06fa3464da0cbd2aee8a32649@codeaurora.org>
 <1596018374.17247.41.camel@mtkswgap22>
Message-ID: <4cb7403fae7226b70a133d4a7ecee755@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Stanley,

On 2020-07-29 18:26, Stanley Chu wrote:
> Hi Can,
> 
> On Wed, 2020-07-29 at 16:43 +0800, Can Guo wrote:
>> Hi Stanley,
>> 
>> On 2020-07-29 10:40, Stanley Chu wrote:
>> > In ufshcd_suspend(), after clk-gating is suspended and link is set
>> > as Hibern8 state, ufshcd_hold() is still possibly invoked before
>> > ufshcd_suspend() returns. For example, MediaTek's suspend vops may
>> > issue UIC commands which would call ufshcd_hold() during the command
>> > issuing flow.
>> >
>> > Now if UFSHCD_CAP_HIBERN8_WITH_CLK_GATING capability is enabled,
>> > then ufshcd_hold() may enter infinite loops because there is no
>> > clk-ungating work scheduled or pending. In this case, ufshcd_hold()
>> > shall just bypass, and keep the link as Hibern8 state.
>> >
>> 
>> The infinite loop is expected as ufshcd_hold is called again after
>> link is put to hibern8 state, so in QCOM's code, we never do this.
> 
> Sadly MediaTek have to do this to make our UniPro to enter low-power
> mode.
> 
>> The cap UFSHCD_CAP_HIBERN8_WITH_CLK_GATING means UIC link state
>> must not be HIBERN8 after ufshcd_hold(async=false) returns.
> 
> If driver is not in PM scenarios, e.g., suspended, above statement 
> shall
> be always followed. But two obvious violations are existed,
> 
> 1. In ufshcd_suspend(), link is set as HIBERN8 behind ufshcd_hold()
> 2. In ufshcd_resume(), link is set back as Active before
> ufshcd_release() is invoked
> 
> So as my understanding, special conditions are allowed in PM scenarios,
> and this is why "hba->clk_gating.is_suspended" is introduced. By this
> thought, I used "hba->clk_gating.is_suspended" in this patch as the
> mandatory condition to allow ufshcd_hold() usage in vendor suspend and
> resume callbacks.
> 
> 
>> Instead of bailing out from that loop, which makes the logic of
>> ufshcd_hold and clk gating even more complex, how about removing
>> ufshcd_hold/release from ufshcd_send_uic_cmd()? I think they are
>> redundant and we should never send DME cmds if clocks/powers are
>> not ready. I mean callers should make sure they are ready to send
>> DME cmds (and only callers know when), but not leave that job to
>> ufshcd_send_uic_cmd(). It is convenient to remove ufshcd_hold/
>> release from ufshcd_send_uic_cmd() as there are not many places
>> sending DME cmds without holding the clocks, ufs_bsg.c is one.
>> And I have tested my idea on my setup, it worked well for me.
>> Another benefit is that it also allows us to use DME cmds
>> in clk gating/ungating contexts if we need to in the future.
>> 
> 
> Brilliant idea! But this may not solve problems if vendor callbacks 
> need
> more than UIC commands in the future.
> 
> This simple patch could make all vendor operations on UFSHCI in PM
> callbacks possible with UFSHCD_CAP_HIBERN8_WITH_CLK_GATING enabled, and
> again, it allows those operations in PM scenarios only.
> 

Other than UIC cmds, I can only think of device manangement cmds (like 
query).
If device management cmds come into the way in the future, we fix it as 
well.
I mean that is the right thing to do in my opinion - just like we don't 
call
pm_runtime_get_sync() in ufshcd_send_uic_cmd().

I can understand that you want a simple/quick fix to get it work for you 
once
for all, but from my point of view, debugging clk gating/ungating really 
takes
huge efforts sometime (I've spent a lot of time on it). Some flash 
vendors also
use it in their own driver widely which makes some failure scenes even 
harder to
undertand/debug. So the first thing comes to my head is that we should 
avoid
making it more complex or giving it more exceptions.

 From functionality point of view, it looks ok to me. It is just that I 
cannot
predict it won't cause new problems since the clk gating/ungating 
sequeces are
like magic in some use cases sometime.

Thanks,

Can Guo.

>> Please let me know your idea, thanks.
>> 
>> Can Guo.
> 
> Thanks,
> Stanley Chu
> 
>> 
>> > Signed-off-by: Stanley Chu <stanley.chu@mediatek.com>
>> > Signed-off-by: Andy Teng <andy.teng@mediatek.com>
>> >
>> > ---
>> >
>> > Changes since v1:
>> > - Fix return value: Use unique bool variable to get the result of
>> > flush_work(). Thcan prevent incorrect returned value, i.e., rc, if
>> > flush_work() returns true
>> > - Fix commit message
>> >
>> > ---
>> >  drivers/scsi/ufs/ufshcd.c | 5 ++++-
>> >  1 file changed, 4 insertions(+), 1 deletion(-)
>> >
>> > diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
>> > index 577cc0d7487f..acba2271c5d3 100644
>> > --- a/drivers/scsi/ufs/ufshcd.c
>> > +++ b/drivers/scsi/ufs/ufshcd.c
>> > @@ -1561,6 +1561,7 @@ static void ufshcd_ungate_work(struct work_struct
>> > *work)
>> >  int ufshcd_hold(struct ufs_hba *hba, bool async)
>> >  {
>> >  	int rc = 0;
>> > +	bool flush_result;
>> >  	unsigned long flags;
>> >
>> >  	if (!ufshcd_is_clkgating_allowed(hba))
>> > @@ -1592,7 +1593,9 @@ int ufshcd_hold(struct ufs_hba *hba, bool async)
>> >  				break;
>> >  			}
>> >  			spin_unlock_irqrestore(hba->host->host_lock, flags);
>> > -			flush_work(&hba->clk_gating.ungate_work);
>> > +			flush_result = flush_work(&hba->clk_gating.ungate_work);
>> > +			if (hba->clk_gating.is_suspended && !flush_result)
>> > +				goto out;
>> >  			spin_lock_irqsave(hba->host->host_lock, flags);
>> >  			goto start;
>> >  		}
