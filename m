Return-Path: <SRS0=hn0g=D4=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C599C55ABD
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Oct 2020 04:52:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 46FD522242
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Oct 2020 04:52:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1603255938;
	bh=Uxranx5I3OGhkPHJfsPFLNiWaCpoSwTMv15+EX3IyVg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=PeNXggWExD58PO0HkGoWOmInBjzqVOinQR9WFbS+mL7sYApyGq5j2kqDWTMQYJz8S
	 PHtdu8HyLrt7fjG+8Vk3EXVeLyYmhAvCKXU51Y3v7mkMe+jiPqqGjqhKLqojD/G//I
	 hp+7hEUBzx++DUubc3qaIdlFwZFNW6/+o6hE8G18=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440263AbgJUEwO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 21 Oct 2020 00:52:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:57540 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2411687AbgJUEwO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 21 Oct 2020 00:52:14 -0400
Received: from localhost (unknown [104.132.1.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C788D22200;
        Wed, 21 Oct 2020 04:52:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603255933;
        bh=Uxranx5I3OGhkPHJfsPFLNiWaCpoSwTMv15+EX3IyVg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=2RG30yAT64+MikDZWgfeUXZeTbDEo6N56hFWAK5sLWxFvpVhyL8Dpgf9GRL2ASc+s
         w2WVwgIIXqVuZ0qTH3KxBqDN2HkWvQdmmKcg81cfrjS2RqLJ0KtmwXTMnv/kdeYavk
         nzVMccfgvlCvP2FEQd/2e7k7pn0RdOHv6FMUE+y8=
Date:   Tue, 20 Oct 2020 21:52:13 -0700
From:   jaegeuk@kernel.org
To:     Can Guo <cang@codeaurora.org>
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, kernel-team@android.com,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>
Subject: Re: [PATCH v2 5/5] scsi: ufs: fix clkgating on/off correctly
Message-ID: <20201021045213.GB3004521@google.com>
References: <20201020195258.2005605-1-jaegeuk@kernel.org>
 <20201020195258.2005605-6-jaegeuk@kernel.org>
 <2a8ecc4185b3a5411077f4e3fc66000f@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2a8ecc4185b3a5411077f4e3fc66000f@codeaurora.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/21, Can Guo wrote:
> On 2020-10-21 03:52, Jaegeuk Kim wrote:
> > The below call stack prevents clk_gating at every IO completion.
> > We can remove the condition, ufshcd_any_tag_in_use(), since
> > clkgating_work
> > will check it again.
> > 
> 
> I think checking ufshcd_any_tag_in_use() in either ufshcd_release() or
> gate_work() can break UFS clk gating's functionality.
> 
> ufshcd_any_tag_in_use() was introduced to replace hba->lrb_in_use. However,
> they are not exactly same - ufshcd_any_tag_in_use() returns true if any tag
> assigned from block layer is still in use, but tags are released
> asynchronously
> (through block softirq), meaning it does not reflect the real occupation of
> UFS host.
> That is after UFS host finishes all tasks, ufshcd_any_tag_in_use() can still
> return true.
> 
> This change only removes the check of ufshcd_any_tag_in_use() in
> ufshcd_release(),
> but having the check of it in gate_work() can still prevent gating from
> happening.
> The current change works for you maybe because the tags are release before
> hba->clk_gating.delay_ms expires, but if hba->clk_gating.delay_ms is shorter
> or
> somehow block softirq is retarded, gate_work() may have chance to see
> ufshcd_any_tag_in_use()
> returns true. What do you think?

I don't think this breaks clkgating, but fix the wrong condition check which
prevented gate_work at all. As you mentioned, even if this schedules gate_work
by racy conditions, gate_work will handle it as a last resort.

> 
> Thanks,
> 
> Can Guo.
> 
> In __ufshcd_transfer_req_compl
> Ihba->lrb_in_use is cleared immediately when UFS driver
> finishes all tasks
> 
> > ufshcd_complete_requests(struct ufs_hba *hba)
> >   ufshcd_transfer_req_compl()
> >     __ufshcd_transfer_req_compl()
> >       __ufshcd_release(hba)
> >         if (ufshcd_any_tag_in_use() == 1)
> >            return;
> >   ufshcd_tmc_handler(hba);
> >     blk_mq_tagset_busy_iter();
> > 
> > Cc: Alim Akhtar <alim.akhtar@samsung.com>
> > Cc: Avri Altman <avri.altman@wdc.com>
> > Cc: Can Guo <cang@codeaurora.org>
> > Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
> > ---
> >  drivers/scsi/ufs/ufshcd.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> > index b5ca0effe636..cecbd4ace8b4 100644
> > --- a/drivers/scsi/ufs/ufshcd.c
> > +++ b/drivers/scsi/ufs/ufshcd.c
> > @@ -1746,7 +1746,7 @@ static void __ufshcd_release(struct ufs_hba *hba)
> > 
> >  	if (hba->clk_gating.active_reqs || hba->clk_gating.is_suspended ||
> >  	    hba->ufshcd_state != UFSHCD_STATE_OPERATIONAL ||
> > -	    ufshcd_any_tag_in_use(hba) || hba->outstanding_tasks ||
> > +	    hba->outstanding_tasks ||
> >  	    hba->active_uic_cmd || hba->uic_async_done)
> >  		return;
