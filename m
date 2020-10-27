Return-Path: <SRS0=LZqT=EC=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1ECA9C4363A
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Oct 2020 02:44:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BD54220872
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Oct 2020 02:44:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="ES0u1CQ6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391051AbgJ0CoS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 26 Oct 2020 22:44:18 -0400
Received: from m42-4.mailgun.net ([69.72.42.4]:56827 "EHLO m42-4.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390723AbgJ0CoR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 26 Oct 2020 22:44:17 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1603766656; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=79HQ6Qz4uXyUWuVIvkDHcYM8q1wj0DuO9ULceGzhRQM=;
 b=ES0u1CQ6HMkCG16X/wnn623YvQc3kLWvqj+sXvteFGILHYnUn4kfbJgJBJV5hFMfJPN78rZi
 nZPtM7BzViadoTAFNjHxzYcffQ2WkbbhJtEkzgqInoHJtmj8hFfCdENIqZG2/r5TCtdrUmBa
 HrJu3SVeTp2UNBulQ9LyzvQYkEA=
X-Mailgun-Sending-Ip: 69.72.42.4
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n01.prod.us-west-2.postgun.com with SMTP id
 5f97897f5c97867acecc9274 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 27 Oct 2020 02:44:15
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id A64DAC43391; Tue, 27 Oct 2020 02:44:15 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id B4407C433F0;
        Tue, 27 Oct 2020 02:44:14 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 27 Oct 2020 10:44:14 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Jaegeuk Kim <jaegeuk@kernel.org>
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, kernel-team@android.com,
        alim.akhtar@samsung.com, avri.altman@wdc.com, bvanassche@acm.org
Subject: Re: [PATCH v3 1/5] scsi: ufs: atomic update for clkgating_enable
In-Reply-To: <20201026194817.GA359340@google.com>
References: <20201024150646.1790529-1-jaegeuk@kernel.org>
 <20201024150646.1790529-2-jaegeuk@kernel.org>
 <68cf5fe17691653f07544db5fe390c97@codeaurora.org>
 <20201026061313.GA2517102@google.com>
 <6c029b64cb4d78e7624bc896f9c9f16d@codeaurora.org>
 <20201026194817.GA359340@google.com>
Message-ID: <63bb653fe0a26f092426945a8af1aba5@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-10-27 03:48, Jaegeuk Kim wrote:
> On 10/26, Can Guo wrote:
>> On 2020-10-26 14:13, Jaegeuk Kim wrote:
>> > On 10/26, Can Guo wrote:
>> > > On 2020-10-24 23:06, Jaegeuk Kim wrote:
>> > > > From: Jaegeuk Kim <jaegeuk@google.com>
>> > > >
>> > > > When giving a stress test which enables/disables clkgating, we hit
>> > > > device
>> > > > timeout sometimes. This patch avoids subtle racy condition to address
>> > > > it.
>> > > >
>> > > > If we use __ufshcd_release(), I've seen that gate_work can be called in
>> > > > parallel
>> > > > with ungate_work, which results in UFS timeout when doing hibern8.
>> > > > Should avoid it.
>> > > >
>> > >
>> > > I don't understand this comment. gate_work and ungate_work are
>> > > queued on
>> > > an ordered workqueue and an ordered workqueue executes at most one
>> > > work item
>> > > at any given time in the queued order. How can the two run in
>> > > parallel?
>> >
>> > When I hit UFS stuck, I saw this by clkgating tracepoint.
>> >
>> > - REQ_CLK_OFF
>> > - CLKS_OFF
>> > - REQ_CLK_OFF
>> > - REQ_CLKS_ON
>> > ..
>> >
>> 
>> I don't see how can you tell that the two works are running in 
>> parallel
>> just from above trace. May I know what is the exact error by "UFS 
>> timeout
>> when doing hibern8"?
>> 
>> By using __ufshcd_release() here, I do see one potential issue if your 
>> test
>> quickly toggles on/off of clk_gating - disable it, enable it, disable 
>> it and
>> enable it, which will cause that __ufshcd_release() being called 
>> twice,
>> meaning
>> we queue two gate_works back to back. So can you try below code and 
>> let me
>> know
>> if it helps or not? I am OK with your current change, but I would like 
>> to
>> understand the problem. Thanks.
>> 
>> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
>> index 1791bce..3eee438 100644
>> --- a/drivers/scsi/ufs/ufshcd.c
>> +++ b/drivers/scsi/ufs/ufshcd.c
>> @@ -2271,6 +2271,8 @@ static void ufshcd_gate_work(struct work_struct 
>> *work)
>>         unsigned long flags;
>> 
>>         spin_lock_irqsave(hba->host->host_lock, flags);
>> +       if (hba->clk_gating.state == CLKS_OFF)
>> +               goto rel_lock;
>>         /*
>>          * In case you are here to cancel this work the gating state
>>          * would be marked as REQ_CLKS_ON. In this case save time by
> 
> This doesn't help. So, I checked this back again, and, like what you 
> said, now
> suspect __ufshcd_release() which changed state to REQ_CLKS_OFF on 
> CLKS_OFF.
> 

Aha, sorry that I gave the right analysis but wrong fix - my check won't 
help
since it is checking CLKS_OFF, but at that moment it has become 
CLKS_REQ_OFF.
Your fix is fulfiling the right purpose.

Thanks,

Can Guo.


> With the below change, I can see the issue anymore. Let me send v4.
> 
> ---
>  drivers/scsi/ufs/ufshcd.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index b8f573a02713..cc8d5f0c3fdc 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -1745,7 +1745,8 @@ static void __ufshcd_release(struct ufs_hba *hba)
>  	if (hba->clk_gating.active_reqs || hba->clk_gating.is_suspended ||
>  	    hba->ufshcd_state != UFSHCD_STATE_OPERATIONAL ||
>  	    ufshcd_any_tag_in_use(hba) || hba->outstanding_tasks ||
> -	    hba->active_uic_cmd || hba->uic_async_done)
> +	    hba->active_uic_cmd || hba->uic_async_done ||
> +	    hba->clk_gating.state == CLKS_OFF)
>  		return;
> 
>  	hba->clk_gating.state = REQ_CLKS_OFF;
> --
> 2.29.0.rc1.297.gfa9743e501-goog
> 
> 
>> 
>> Regards,
>> 
>> Can Guo.
>> 
>> > By using active_req, I don't see any problem.
>> >
>> > >
>> > > Thanks,
>> > >
>> > > Can Guo.
>> > >
>> > > > Signed-off-by: Jaegeuk Kim <jaegeuk@google.com>
>> > > > ---
>> > > >  drivers/scsi/ufs/ufshcd.c | 12 ++++++------
>> > > >  1 file changed, 6 insertions(+), 6 deletions(-)
>> > > >
>> > > > diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
>> > > > index b8f573a02713..e0b479f9eb8a 100644
>> > > > --- a/drivers/scsi/ufs/ufshcd.c
>> > > > +++ b/drivers/scsi/ufs/ufshcd.c
>> > > > @@ -1807,19 +1807,19 @@ static ssize_t
>> > > > ufshcd_clkgate_enable_store(struct device *dev,
>> > > >  		return -EINVAL;
>> > > >
>> > > >  	value = !!value;
>> > > > +
>> > > > +	spin_lock_irqsave(hba->host->host_lock, flags);
>> > > >  	if (value == hba->clk_gating.is_enabled)
>> > > >  		goto out;
>> > > >
>> > > > -	if (value) {
>> > > > -		ufshcd_release(hba);
>> > > > -	} else {
>> > > > -		spin_lock_irqsave(hba->host->host_lock, flags);
>> > > > +	if (value)
>> > > > +		hba->clk_gating.active_reqs--;
>> > > > +	else
>> > > >  		hba->clk_gating.active_reqs++;
>> > > > -		spin_unlock_irqrestore(hba->host->host_lock, flags);
>> > > > -	}
>> > > >
>> > > >  	hba->clk_gating.is_enabled = value;
>> > > >  out:
>> > > > +	spin_unlock_irqrestore(hba->host->host_lock, flags);
>> > > >  	return count;
>> > > >  }
