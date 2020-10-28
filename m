Return-Path: <SRS0=SSlb=ED=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B853C63699
	for <linux-scsi@archiver.kernel.org>; Wed, 28 Oct 2020 22:12:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 19CBE20809
	for <linux-scsi@archiver.kernel.org>; Wed, 28 Oct 2020 22:12:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1603923156;
	bh=Uig8XlVVywuZSs/xiHVDxKfmc2EvUkGvRLURSxmRfOM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=dojBQ0+aLOuyLCRApKxJUqjDUeBra3j269RUiyi+dmfNTKXJGOjaBZLr8IXb/FA/F
	 nfOiPP8Wfrh5Wb6XUglNVQhe96Y+mvROEhssZ4RzGEy9rqm8ppYLadYeqwR7Pr/jdC
	 u688jFJTovDOe9oSVPL8/yGolU9P3LmfmYrFdkwE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730850AbgJ1WMc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 28 Oct 2020 18:12:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:56480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730832AbgJ1WMY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 28 Oct 2020 18:12:24 -0400
Received: from google.com (unknown [104.132.1.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E2A9E24795;
        Wed, 28 Oct 2020 19:43:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603914234;
        bh=Uig8XlVVywuZSs/xiHVDxKfmc2EvUkGvRLURSxmRfOM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dfusWPKWqTKRnMdbvN3oZ846WjjPGP1zahpiGLPq7lLhrOPyDeFDLz1cHc9PWFcZx
         AfCnIMUYVw2KHtvQTMXiA8EyfosDwA6yEnKTaOfqCqREvHybxFLydVlbuyxPljCaBW
         36b9cwb9UexFKfBKUhyXKkEQkJPSzToDbMT4hDOI=
Date:   Wed, 28 Oct 2020 12:43:52 -0700
From:   Jaegeuk Kim <jaegeuk@kernel.org>
To:     Can Guo <cang@codeaurora.org>
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, alim.akhtar@samsung.com,
        avri.altman@wdc.com, bvanassche@acm.org
Subject: Re: [PATCH v4 1/5] scsi: ufs: atomic update for clkgating_enable
Message-ID: <20201028194352.GA3060274@google.com>
References: <20201026195124.363096-1-jaegeuk@kernel.org>
 <20201026195124.363096-2-jaegeuk@kernel.org>
 <20d1c2ca06e95beb207fd4ba1b61dc80@codeaurora.org>
 <20201027033311.GA1745317@google.com>
 <76df977d164683c7404d2dc702f2e5ad@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <76df977d164683c7404d2dc702f2e5ad@codeaurora.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/27, Can Guo wrote:
> On 2020-10-27 11:33, Jaegeuk Kim wrote:
> > On 10/27, Can Guo wrote:
> > > On 2020-10-27 03:51, Jaegeuk Kim wrote:
> > > > From: Jaegeuk Kim <jaegeuk@google.com>
> > > >
> > > > When giving a stress test which enables/disables clkgating, we hit
> > > > device
> > > > timeout sometimes. This patch avoids subtle racy condition to address
> > > > it.
> > > >
> > > > Note that, this requires a patch to address the device stuck by
> > > > REQ_CLKS_OFF in
> > > > __ufshcd_release().
> > > >
> > > > The fix is "scsi: ufs: avoid to call REQ_CLKS_OFF to CLKS_OFF".
> > > 
> > > Why don't you just squash the fix into this one?
> > 
> > I'm seeing this patch just revealed that problem.
> 
> That scenario (back to back calling of ufshcd_release()) only happens
> when you stress the clkgate_enable sysfs node, so let's keep the fix
> as one to make things simple. What do you think?

If we don't have this patch, do you think this issue won't happen at all?

> 
> Thanks,
> 
> Can Guo.
> 
> > 
> > > 
> > > Thanks,
> > > 
> > > Can Guo.
> > > 
> > > >
> > > > Signed-off-by: Jaegeuk Kim <jaegeuk@google.com>
> > > > ---
> > > >  drivers/scsi/ufs/ufshcd.c | 12 ++++++------
> > > >  1 file changed, 6 insertions(+), 6 deletions(-)
> > > >
> > > > diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> > > > index cc8d5f0c3fdc..6c9269bffcbd 100644
> > > > --- a/drivers/scsi/ufs/ufshcd.c
> > > > +++ b/drivers/scsi/ufs/ufshcd.c
> > > > @@ -1808,19 +1808,19 @@ static ssize_t
> > > > ufshcd_clkgate_enable_store(struct device *dev,
> > > >  		return -EINVAL;
> > > >
> > > >  	value = !!value;
> > > > +
> > > > +	spin_lock_irqsave(hba->host->host_lock, flags);
> > > >  	if (value == hba->clk_gating.is_enabled)
> > > >  		goto out;
> > > >
> > > > -	if (value) {
> > > > -		ufshcd_release(hba);
> > > > -	} else {
> > > > -		spin_lock_irqsave(hba->host->host_lock, flags);
> > > > +	if (value)
> > > > +		__ufshcd_release(hba);
> > > > +	else
> > > >  		hba->clk_gating.active_reqs++;
> > > > -		spin_unlock_irqrestore(hba->host->host_lock, flags);
> > > > -	}
> > > >
> > > >  	hba->clk_gating.is_enabled = value;
> > > >  out:
> > > > +	spin_unlock_irqrestore(hba->host->host_lock, flags);
> > > >  	return count;
> > > >  }
