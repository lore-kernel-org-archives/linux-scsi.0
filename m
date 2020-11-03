Return-Path: <SRS0=0yur=EJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A18DC2D0A3
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Nov 2020 13:29:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0EBDB21534
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Nov 2020 13:29:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="kgMtwDp4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729275AbgKCN2n (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 3 Nov 2020 08:28:43 -0500
Received: from m42-4.mailgun.net ([69.72.42.4]:45803 "EHLO m42-4.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729258AbgKCN2j (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 3 Nov 2020 08:28:39 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1604410118; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=dldIYfTJS6IkZ8/7xmZR8OD1UnVkZixlc/QiTKGvk1I=;
 b=kgMtwDp4AWGehadPrFceA+O2rE7drbpHUhZbSOJCygbsfI48X7hlYW8ZEBmiJP7F5HHokt9+
 gH0gxO4vZwkEK6DdQ9chb0TDfzCJoc5bMAe2v2wNZ41DH3LwQcjaB0mQFvgyy7ILxkLUdcTk
 09OPublYBcrZLqXGFaR48sUEdw4=
X-Mailgun-Sending-Ip: 69.72.42.4
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n01.prod.us-east-1.postgun.com with SMTP id
 5fa15af8b64b1c5b780e9878 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 03 Nov 2020 13:28:24
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 02243C4345F; Tue,  3 Nov 2020 05:28:11 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 638A0C433B1;
        Tue,  3 Nov 2020 05:28:10 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 03 Nov 2020 13:28:10 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Jaegeuk Kim <jaegeuk@kernel.org>
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, alim.akhtar@samsung.com,
        avri.altman@wdc.com, bvanassche@acm.org
Subject: Re: [PATCH v4 1/5] scsi: ufs: atomic update for clkgating_enable
In-Reply-To: <20201028194352.GA3060274@google.com>
References: <20201026195124.363096-1-jaegeuk@kernel.org>
 <20201026195124.363096-2-jaegeuk@kernel.org>
 <20d1c2ca06e95beb207fd4ba1b61dc80@codeaurora.org>
 <20201027033311.GA1745317@google.com>
 <76df977d164683c7404d2dc702f2e5ad@codeaurora.org>
 <20201028194352.GA3060274@google.com>
Message-ID: <2c73eb84991227b7e42ba4c1d268d390@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-10-29 03:43, Jaegeuk Kim wrote:
> On 10/27, Can Guo wrote:
>> On 2020-10-27 11:33, Jaegeuk Kim wrote:
>> > On 10/27, Can Guo wrote:
>> > > On 2020-10-27 03:51, Jaegeuk Kim wrote:
>> > > > From: Jaegeuk Kim <jaegeuk@google.com>
>> > > >
>> > > > When giving a stress test which enables/disables clkgating, we hit
>> > > > device
>> > > > timeout sometimes. This patch avoids subtle racy condition to address
>> > > > it.
>> > > >
>> > > > Note that, this requires a patch to address the device stuck by
>> > > > REQ_CLKS_OFF in
>> > > > __ufshcd_release().
>> > > >
>> > > > The fix is "scsi: ufs: avoid to call REQ_CLKS_OFF to CLKS_OFF".
>> > >
>> > > Why don't you just squash the fix into this one?
>> >
>> > I'm seeing this patch just revealed that problem.
>> 
>> That scenario (back to back calling of ufshcd_release()) only happens
>> when you stress the clkgate_enable sysfs node, so let's keep the fix
>> as one to make things simple. What do you think?
> 
> If we don't have this patch, do you think this issue won't happen at 
> all?
> 

At least I've never seen this scenario these years, otherwise I would 
have
put up a fix.

Thanks,

Can Guo.

>> 
>> Thanks,
>> 
>> Can Guo.
>> 
>> >
>> > >
>> > > Thanks,
>> > >
>> > > Can Guo.
>> > >
>> > > >
>> > > > Signed-off-by: Jaegeuk Kim <jaegeuk@google.com>
>> > > > ---
>> > > >  drivers/scsi/ufs/ufshcd.c | 12 ++++++------
>> > > >  1 file changed, 6 insertions(+), 6 deletions(-)
>> > > >
>> > > > diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
>> > > > index cc8d5f0c3fdc..6c9269bffcbd 100644
>> > > > --- a/drivers/scsi/ufs/ufshcd.c
>> > > > +++ b/drivers/scsi/ufs/ufshcd.c
>> > > > @@ -1808,19 +1808,19 @@ static ssize_t
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
>> > > > +		__ufshcd_release(hba);
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
