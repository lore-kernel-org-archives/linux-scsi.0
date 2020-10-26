Return-Path: <SRS0=a792=EB=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D517CC2D0A3
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Oct 2020 19:48:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A166B207F7
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Oct 2020 19:48:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1603741703;
	bh=0CP8uZo286GYB4ZeSsm3JEfEaYF6gJ46de7Wm5oEt9g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=aV1OvByXeE8Q6NrHdCRIgjQDdnzIr625c6vCiUbJUVoaHdmPC+d7QOjQbJgLbGs5N
	 hWXIMV0UCcxQkw5WBLbjx0mA218ZwMQf6RoedbL/hfTW6Hy/z+86xLUSv+EslUS0WZ
	 +OQrNOIhwWtHIuA+Z+3LJcB7IhXtsaesWFBl9LfI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726107AbgJZTsV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 26 Oct 2020 15:48:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:46138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726085AbgJZTsU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 26 Oct 2020 15:48:20 -0400
Received: from google.com (unknown [104.132.1.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7F7BC2076D;
        Mon, 26 Oct 2020 19:48:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603741699;
        bh=0CP8uZo286GYB4ZeSsm3JEfEaYF6gJ46de7Wm5oEt9g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YFfbfsOmu7bIpEI6O6D6dWmYeueVt5Ls58K7cJojaOUDcA/W5Ogra1vmfp4tFoG/b
         Q+BwBZl0EuQg39eDEe1fUs8OirTqXyKFzYX/8CAZUzGYxtZT2XN5P89avKRKXF1wbI
         9PBQ9fu/oUUKPKRmra78sKl1gVvO/GRQvrqDh6mE=
Date:   Mon, 26 Oct 2020 12:48:17 -0700
From:   Jaegeuk Kim <jaegeuk@kernel.org>
To:     Can Guo <cang@codeaurora.org>
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, kernel-team@android.com,
        alim.akhtar@samsung.com, avri.altman@wdc.com, bvanassche@acm.org
Subject: Re: [PATCH v3 1/5] scsi: ufs: atomic update for clkgating_enable
Message-ID: <20201026194817.GA359340@google.com>
References: <20201024150646.1790529-1-jaegeuk@kernel.org>
 <20201024150646.1790529-2-jaegeuk@kernel.org>
 <68cf5fe17691653f07544db5fe390c97@codeaurora.org>
 <20201026061313.GA2517102@google.com>
 <6c029b64cb4d78e7624bc896f9c9f16d@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6c029b64cb4d78e7624bc896f9c9f16d@codeaurora.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/26, Can Guo wrote:
> On 2020-10-26 14:13, Jaegeuk Kim wrote:
> > On 10/26, Can Guo wrote:
> > > On 2020-10-24 23:06, Jaegeuk Kim wrote:
> > > > From: Jaegeuk Kim <jaegeuk@google.com>
> > > >
> > > > When giving a stress test which enables/disables clkgating, we hit
> > > > device
> > > > timeout sometimes. This patch avoids subtle racy condition to address
> > > > it.
> > > >
> > > > If we use __ufshcd_release(), I've seen that gate_work can be called in
> > > > parallel
> > > > with ungate_work, which results in UFS timeout when doing hibern8.
> > > > Should avoid it.
> > > >
> > > 
> > > I don't understand this comment. gate_work and ungate_work are
> > > queued on
> > > an ordered workqueue and an ordered workqueue executes at most one
> > > work item
> > > at any given time in the queued order. How can the two run in
> > > parallel?
> > 
> > When I hit UFS stuck, I saw this by clkgating tracepoint.
> > 
> > - REQ_CLK_OFF
> > - CLKS_OFF
> > - REQ_CLK_OFF
> > - REQ_CLKS_ON
> > ..
> > 
> 
> I don't see how can you tell that the two works are running in parallel
> just from above trace. May I know what is the exact error by "UFS timeout
> when doing hibern8"?
> 
> By using __ufshcd_release() here, I do see one potential issue if your test
> quickly toggles on/off of clk_gating - disable it, enable it, disable it and
> enable it, which will cause that __ufshcd_release() being called twice,
> meaning
> we queue two gate_works back to back. So can you try below code and let me
> know
> if it helps or not? I am OK with your current change, but I would like to
> understand the problem. Thanks.
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 1791bce..3eee438 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -2271,6 +2271,8 @@ static void ufshcd_gate_work(struct work_struct *work)
>         unsigned long flags;
> 
>         spin_lock_irqsave(hba->host->host_lock, flags);
> +       if (hba->clk_gating.state == CLKS_OFF)
> +               goto rel_lock;
>         /*
>          * In case you are here to cancel this work the gating state
>          * would be marked as REQ_CLKS_ON. In this case save time by

This doesn't help. So, I checked this back again, and, like what you said, now
suspect __ufshcd_release() which changed state to REQ_CLKS_OFF on CLKS_OFF.

With the below change, I can see the issue anymore. Let me send v4.

---
 drivers/scsi/ufs/ufshcd.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index b8f573a02713..cc8d5f0c3fdc 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -1745,7 +1745,8 @@ static void __ufshcd_release(struct ufs_hba *hba)
 	if (hba->clk_gating.active_reqs || hba->clk_gating.is_suspended ||
 	    hba->ufshcd_state != UFSHCD_STATE_OPERATIONAL ||
 	    ufshcd_any_tag_in_use(hba) || hba->outstanding_tasks ||
-	    hba->active_uic_cmd || hba->uic_async_done)
+	    hba->active_uic_cmd || hba->uic_async_done ||
+	    hba->clk_gating.state == CLKS_OFF)
 		return;
 
 	hba->clk_gating.state = REQ_CLKS_OFF;
-- 
2.29.0.rc1.297.gfa9743e501-goog


> 
> Regards,
> 
> Can Guo.
> 
> > By using active_req, I don't see any problem.
> > 
> > > 
> > > Thanks,
> > > 
> > > Can Guo.
> > > 
> > > > Signed-off-by: Jaegeuk Kim <jaegeuk@google.com>
> > > > ---
> > > >  drivers/scsi/ufs/ufshcd.c | 12 ++++++------
> > > >  1 file changed, 6 insertions(+), 6 deletions(-)
> > > >
> > > > diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> > > > index b8f573a02713..e0b479f9eb8a 100644
> > > > --- a/drivers/scsi/ufs/ufshcd.c
> > > > +++ b/drivers/scsi/ufs/ufshcd.c
> > > > @@ -1807,19 +1807,19 @@ static ssize_t
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
> > > > +		hba->clk_gating.active_reqs--;
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
