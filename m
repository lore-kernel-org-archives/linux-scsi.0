Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4327AC433E6
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Jan 2021 06:58:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F105522EBF
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Jan 2021 06:58:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726496AbhAGG5w (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Jan 2021 01:57:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:52998 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725916AbhAGG5v (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 7 Jan 2021 01:57:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 66EBF22E00;
        Thu,  7 Jan 2021 06:57:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610002630;
        bh=IzxIYfx3G54HyI3gMs+bXaMvGFHVwR8I61rAhwwFa4c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TdrpMbwiSsV6OCAFx7PxO4udmHoXHNYnPmIr3NiwwCSADCNvj1W0j03b5Hmf9HW53
         WgmddIsDasX+MM1VfgjnRqerEvSd/yWJkrw6/Dy0YNtFzEP4SC6JGenKnMrYQQxYx8
         rr4O6sgP62ghCKJ2rq/Z9CaejxNkHmhN0y5a7lg5Nsr6IkJtjxFJMqshlQBz3rp21W
         KZGfUSp/KlBff8/PU2jn/ajwSzId0FAo/qJOZph7+QlW6WOPWxwHxa3+xpwYW5h71E
         jgI1WHs1yBWcHMYpx7+nxMNIqvENSyNQ/8IwKCcLYrEaPCTbUlLAMbXyuFLruvulFd
         5gxd42RhA2DMA==
Date:   Wed, 6 Jan 2021 22:57:08 -0800
From:   Jaegeuk Kim <jaegeuk@kernel.org>
To:     Can Guo <cang@codeaurora.org>
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, alim.akhtar@samsung.com,
        avri.altman@wdc.com, bvanassche@acm.org,
        martin.petersen@oracle.com, stanley.chu@mediatek.com
Subject: Re: [PATCH v3 1/2] scsi: ufs: fix livelock of ufshcd_clear_ua_wluns
Message-ID: <X/awxP3m1VG3b+bX@google.com>
References: <20210106214109.44041-1-jaegeuk@kernel.org>
 <20210106214109.44041-2-jaegeuk@kernel.org>
 <fc4cb27df8bd6b2c1037d82e4b5d3860@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fc4cb27df8bd6b2c1037d82e4b5d3860@codeaurora.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 01/07, Can Guo wrote:
> On 2021-01-07 05:41, Jaegeuk Kim wrote:
> > When gate_work/ungate_work gets an error during hibern8_enter or exit,
> >  ufshcd_err_handler()
> >    ufshcd_scsi_block_requests()
> >    ufshcd_reset_and_restore()
> >      ufshcd_clear_ua_wluns() -> stuck
> >    ufshcd_scsi_unblock_requests()
> > 
> > In order to avoid it, ufshcd_clear_ua_wluns() can be called per recovery
> > flows
> > such as suspend/resume, link_recovery, and error_handler.
> > 
> > Fixes: 1918651f2d7e ("scsi: ufs: Clear UAC for RPMB after ufshcd
> > resets")
> > Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
> > ---
> >  drivers/scsi/ufs/ufshcd.c | 15 ++++++++++-----
> >  1 file changed, 10 insertions(+), 5 deletions(-)
> > 
> > diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> > index bedb822a40a3..1678cec08b51 100644
> > --- a/drivers/scsi/ufs/ufshcd.c
> > +++ b/drivers/scsi/ufs/ufshcd.c
> > @@ -3996,6 +3996,8 @@ int ufshcd_link_recovery(struct ufs_hba *hba)
> >  	if (ret)
> >  		dev_err(hba->dev, "%s: link recovery failed, err %d",
> >  			__func__, ret);
> > +	else
> > +		ufshcd_clear_ua_wluns(hba);
> 
> Can we put it right after ufshcd_scsi_add_wlus() in ufshcd_add_lus()?

May I ask the reason? We'll call it after ufshcd_add_lus() later tho.

> 
> Thanks,
> Can Guo.
> 
> > 
> >  	return ret;
> >  }
> > @@ -6003,6 +6005,9 @@ static void ufshcd_err_handler(struct work_struct
> > *work)
> >  	ufshcd_scsi_unblock_requests(hba);
> >  	ufshcd_err_handling_unprepare(hba);
> >  	up(&hba->eh_sem);
> > +
> > +	if (!err && needs_reset)
> > +		ufshcd_clear_ua_wluns(hba);
> >  }
> > 
> >  /**
> > @@ -6940,14 +6945,11 @@ static int
> > ufshcd_host_reset_and_restore(struct ufs_hba *hba)
> >  	ufshcd_set_clk_freq(hba, true);
> > 
> >  	err = ufshcd_hba_enable(hba);
> > -	if (err)
> > -		goto out;
> > 
> >  	/* Establish the link again and restore the device */
> > -	err = ufshcd_probe_hba(hba, false);
> >  	if (!err)
> > -		ufshcd_clear_ua_wluns(hba);
> > -out:
> > +		err = ufshcd_probe_hba(hba, false);
> > +
> >  	if (err)
> >  		dev_err(hba->dev, "%s: Host init failed %d\n", __func__, err);
> >  	ufshcd_update_evt_hist(hba, UFS_EVT_HOST_RESET, (u32)err);
> > @@ -8777,6 +8779,7 @@ static int ufshcd_suspend(struct ufs_hba *hba,
> > enum ufs_pm_op pm_op)
> >  		ufshcd_resume_clkscaling(hba);
> >  	hba->clk_gating.is_suspended = false;
> >  	hba->dev_info.b_rpm_dev_flush_capable = false;
> > +	ufshcd_clear_ua_wluns(hba);
> >  	ufshcd_release(hba);
> >  out:
> >  	if (hba->dev_info.b_rpm_dev_flush_capable) {
> > @@ -8887,6 +8890,8 @@ static int ufshcd_resume(struct ufs_hba *hba,
> > enum ufs_pm_op pm_op)
> >  		cancel_delayed_work(&hba->rpm_dev_flush_recheck_work);
> >  	}
> > 
> > +	ufshcd_clear_ua_wluns(hba);
> > +
> >  	/* Schedule clock gating in case of no access to UFS device yet */
> >  	ufshcd_release(hba);
