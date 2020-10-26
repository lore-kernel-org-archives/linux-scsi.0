Return-Path: <SRS0=a792=EB=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DE2CC388F9
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Oct 2020 06:13:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 30F7020795
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Oct 2020 06:13:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1603692799;
	bh=aQujr3c5hIwOeShsApFTb7WRP6b5nsUJBe4uo9YQeTU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=oin5X+x+EHamav9eLXNWovJKMHbiRer51ujhjek4AyB2yoIVT7GZoN92j+BYXSg8m
	 4C9+ba5ZBUAsebk7AaMVWCSrfVtm3UcNxG460ITQLoFPghTiXcEkBqxqEQKmZfj8oN
	 EZSS1GzmTKzrmZTDlqdzX4tlOR/Lb13osuzxvlOs=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1770266AbgJZGNQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 26 Oct 2020 02:13:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:55836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390548AbgJZGNQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 26 Oct 2020 02:13:16 -0400
Received: from google.com (unknown [104.132.1.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7B35220738;
        Mon, 26 Oct 2020 06:13:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603692795;
        bh=aQujr3c5hIwOeShsApFTb7WRP6b5nsUJBe4uo9YQeTU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fDUIHOJzpTjLbbSu5shv3Avsw6Lwv0dRHZOu7umJUvvcoyetO36tCj6evv9gJ3Beo
         GKR61mkFHuZr3qIQp+K5P9HbWFsEt1DWCRRpjkYainBlffaRnKcSQH4uWEwFNW/Rkc
         ZWvjJ18r2gf8HsdWophkenPqDIiffXEe3SURJ/TQ=
Date:   Sun, 25 Oct 2020 23:13:13 -0700
From:   Jaegeuk Kim <jaegeuk@kernel.org>
To:     Can Guo <cang@codeaurora.org>
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, kernel-team@android.com,
        alim.akhtar@samsung.com, avri.altman@wdc.com, bvanassche@acm.org
Subject: Re: [PATCH v3 1/5] scsi: ufs: atomic update for clkgating_enable
Message-ID: <20201026061313.GA2517102@google.com>
References: <20201024150646.1790529-1-jaegeuk@kernel.org>
 <20201024150646.1790529-2-jaegeuk@kernel.org>
 <68cf5fe17691653f07544db5fe390c97@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <68cf5fe17691653f07544db5fe390c97@codeaurora.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/26, Can Guo wrote:
> On 2020-10-24 23:06, Jaegeuk Kim wrote:
> > From: Jaegeuk Kim <jaegeuk@google.com>
> > 
> > When giving a stress test which enables/disables clkgating, we hit
> > device
> > timeout sometimes. This patch avoids subtle racy condition to address
> > it.
> > 
> > If we use __ufshcd_release(), I've seen that gate_work can be called in
> > parallel
> > with ungate_work, which results in UFS timeout when doing hibern8.
> > Should avoid it.
> > 
> 
> I don't understand this comment. gate_work and ungate_work are queued on
> an ordered workqueue and an ordered workqueue executes at most one work item
> at any given time in the queued order. How can the two run in parallel?

When I hit UFS stuck, I saw this by clkgating tracepoint.

- REQ_CLK_OFF
- CLKS_OFF
- REQ_CLK_OFF
- REQ_CLKS_ON
..

By using active_req, I don't see any problem.

> 
> Thanks,
> 
> Can Guo.
> 
> > Signed-off-by: Jaegeuk Kim <jaegeuk@google.com>
> > ---
> >  drivers/scsi/ufs/ufshcd.c | 12 ++++++------
> >  1 file changed, 6 insertions(+), 6 deletions(-)
> > 
> > diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> > index b8f573a02713..e0b479f9eb8a 100644
> > --- a/drivers/scsi/ufs/ufshcd.c
> > +++ b/drivers/scsi/ufs/ufshcd.c
> > @@ -1807,19 +1807,19 @@ static ssize_t
> > ufshcd_clkgate_enable_store(struct device *dev,
> >  		return -EINVAL;
> > 
> >  	value = !!value;
> > +
> > +	spin_lock_irqsave(hba->host->host_lock, flags);
> >  	if (value == hba->clk_gating.is_enabled)
> >  		goto out;
> > 
> > -	if (value) {
> > -		ufshcd_release(hba);
> > -	} else {
> > -		spin_lock_irqsave(hba->host->host_lock, flags);
> > +	if (value)
> > +		hba->clk_gating.active_reqs--;
> > +	else
> >  		hba->clk_gating.active_reqs++;
> > -		spin_unlock_irqrestore(hba->host->host_lock, flags);
> > -	}
> > 
> >  	hba->clk_gating.is_enabled = value;
> >  out:
> > +	spin_unlock_irqrestore(hba->host->host_lock, flags);
> >  	return count;
> >  }
