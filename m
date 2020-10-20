Return-Path: <SRS0=ehq5=D3=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9FE4C388F7
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Oct 2020 19:17:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4FD4120704
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Oct 2020 19:17:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1603221442;
	bh=Bm4F8CTYzjWf85RBYIx0eDesOCAcBjrJdUMW2jlagDQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=ErDVyKPT9jYsy8co23kPq64ISoOFglnjNu+9ytH8tQMvJImeETb++Yy+PNY50KX7e
	 zeH9UST+9Osh//yiyDe0YFQ+wEAllZ1OuYOEsjLV6fwsp4BOm5u/wD3z/SmXJ2zVt4
	 anM5kYDIW7qK3iehHpGNq4skWgNWath1yCm1kBLA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390863AbgJTTRT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 20 Oct 2020 15:17:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:36590 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729588AbgJTTRS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 20 Oct 2020 15:17:18 -0400
Received: from localhost (unknown [104.132.1.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 917522224A;
        Tue, 20 Oct 2020 19:17:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603221437;
        bh=Bm4F8CTYzjWf85RBYIx0eDesOCAcBjrJdUMW2jlagDQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tB2bosF+dDn0kDKkFM+q0k6nlJlPspCm1klp8MPp2v16O46QCGMJMnfihtDFCetuq
         M1RPkyNIP4u64MgFS67II1BI1b/ezWLIxoh8QIvxJA/s+BdN+BKzePLgljpSS2zEaN
         d3mC2CRZPTVJtr2H7VyrlacVfHFK8RTVkGhDP0u8=
Date:   Tue, 20 Oct 2020 12:17:16 -0700
From:   jaegeuk@kernel.org
To:     Can Guo <cang@codeaurora.org>
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>
Subject: Re: [PATCH v2] scsi: ufs: fix clkgating on/off correctly
Message-ID: <20201020191716.GA1726050@google.com>
References: <20201016060259.390029-1-jaegeuk@kernel.org>
 <20201016211826.GA3441410@google.com>
 <5a59c4c4ec0959223fe0e879f2dd9d91@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5a59c4c4ec0959223fe0e879f2dd9d91@codeaurora.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/20, Can Guo wrote:
> On 2020-10-17 05:18, jaegeuk@kernel.org wrote:
> > The below call stack prevents clk_gating at every IO completion.
> > We can remove the condition, ufshcd_any_tag_in_use(), since
> > clkgating_work
> > will check it again.
> > 
> > ufshcd_complete_requests(struct ufs_hba *hba)
> >   ufshcd_transfer_req_compl()
> >     __ufshcd_transfer_req_compl()
> >       __ufshcd_release(hba)
> >         if (ufshcd_any_tag_in_use() == 1)
> >            return;
> >   ufshcd_tmc_handler(hba);
> >     blk_mq_tagset_busy_iter();
> > 
> > In addition, we have to avoid gate_work, if it was disabled.
> > 
> > Cc: Alim Akhtar <alim.akhtar@samsung.com>
> > Cc: Avri Altman <avri.altman@wdc.com>
> > Cc: Can Guo <cang@codeaurora.org>
> > Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
> > ---
> > 
> > Change log from v1:
> >  - change the patch subject
> >  - fix clkgate.is_enable to work
> > 
> >  drivers/scsi/ufs/ufshcd.c | 5 +++--
> >  drivers/scsi/ufs/ufshcd.h | 5 +++++
> >  2 files changed, 8 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> > index a2db8182663d..75e8a76f20c7 100644
> > --- a/drivers/scsi/ufs/ufshcd.c
> > +++ b/drivers/scsi/ufs/ufshcd.c
> > @@ -1729,9 +1729,10 @@ static void __ufshcd_release(struct ufs_hba *hba)
> > 
> >  	if (hba->clk_gating.active_reqs || hba->clk_gating.is_suspended
> >  		|| hba->ufshcd_state != UFSHCD_STATE_OPERATIONAL
> > -		|| ufshcd_any_tag_in_use(hba) || hba->outstanding_tasks
> > +		|| hba->outstanding_tasks
> >  		|| hba->active_uic_cmd || hba->uic_async_done
> > -		|| ufshcd_eh_in_progress(hba))
> > +		|| ufshcd_eh_in_progress(hba)
> > +		|| ufshcd_is_clkgating_enabled(hba))
> 
> I guess you want it to be "!ufshcd_is_clkgating_enabled(hba)" - if
> clk gating is enabled, we should let gating happen but not bail, right?
> 
> That said, I don't think we need to check whether clk gating is enabled or
> not here, since ufshcd_clkgating_store() manipulates clk_gating->active_reqs
> in an atomic way. If someone disables clk gating ->
> clk_gating->active_reqs++,
> this check becomes TURE on the very first condition.

Yeah, I found the above and and was testing it locally. Anyway, it seems you're
right. Let me give it a try back again.

Thanks,

> 
> So the very fisrt patch looks better to me.
> 
> Thanks,
> 
> Can Guo.
> 
> >  		return;
> > 
> >  	hba->clk_gating.state = REQ_CLKS_OFF;
> > diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
> > index 8344d8cb3678..09e59cb86e69 100644
> > --- a/drivers/scsi/ufs/ufshcd.h
> > +++ b/drivers/scsi/ufs/ufshcd.h
> > @@ -814,6 +814,11 @@ static inline bool
> > ufshcd_is_auto_hibern8_supported(struct ufs_hba *hba)
> >  		!(hba->quirks & UFSHCD_QUIRK_BROKEN_AUTO_HIBERN8);
> >  }
> > 
> > +static inline bool ufshcd_is_clkgating_enabled(struct ufs_hba *hba)
> > +{
> > +	return hba->clk_gating.is_enabled;
> > +}
> > +
> >  static inline bool ufshcd_is_auto_hibern8_enabled(struct ufs_hba *hba)
> >  {
> >  	return FIELD_GET(UFSHCI_AHIBERN8_TIMER_MASK, hba->ahit) ? true :
> > false;
