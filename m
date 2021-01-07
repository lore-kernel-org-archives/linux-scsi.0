Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16908C433E0
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Jan 2021 07:41:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C573F23123
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Jan 2021 07:41:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726013AbhAGHlM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Jan 2021 02:41:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:56216 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725306AbhAGHlM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 7 Jan 2021 02:41:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3F3042311A;
        Thu,  7 Jan 2021 07:40:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610005231;
        bh=sdq6syVaDrNYq3YLoMTwQn2crIXyKwGokuzzAZriVNE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Penxc7aXySvgQKe1F0THm1NffrsT3AOmVDktRMhiSG2OjZeMycVNT0qWD7IYHZC5g
         m3uEe0raFphJ8Ie+vbcu5PTq2K0/5KTnhEVNiLiDk7v8KWVq/fQ66NZYDhKwCCoMc0
         BRNfBy0wDjz+TJfu94ygCz4L6zhV6X9SoTqnRM6RvWubwb8GNl7ZSx/rVNvZsrK50l
         72J8t9Nen0nqbmeTFByBA+keeGiP4mKTyoe3fhCz1RWFrQ0jzqj3WSPYO5QRKJFtMR
         E5EcwKyb80AnHV4HdF28iq96Fa2UF31ND2fZnf0vq50I/TEKb12dZqM0BVXn/3Jyuq
         IQ6yutJZBt/Iw==
Date:   Wed, 6 Jan 2021 23:40:29 -0800
From:   Jaegeuk Kim <jaegeuk@kernel.org>
To:     Can Guo <cang@codeaurora.org>
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, alim.akhtar@samsung.com,
        avri.altman@wdc.com, bvanassche@acm.org,
        martin.petersen@oracle.com, stanley.chu@mediatek.com
Subject: Re: [PATCH v3 1/2] scsi: ufs: fix livelock of ufshcd_clear_ua_wluns
Message-ID: <X/a67YjcNgfJAGcc@google.com>
References: <20210106214109.44041-1-jaegeuk@kernel.org>
 <20210106214109.44041-2-jaegeuk@kernel.org>
 <fc4cb27df8bd6b2c1037d82e4b5d3860@codeaurora.org>
 <X/awxP3m1VG3b+bX@google.com>
 <c47ca5307e67de386aa3e99256b837e4@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c47ca5307e67de386aa3e99256b837e4@codeaurora.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 01/07, Can Guo wrote:
> On 2021-01-07 14:57, Jaegeuk Kim wrote:
> > On 01/07, Can Guo wrote:
> > > On 2021-01-07 05:41, Jaegeuk Kim wrote:
> > > > When gate_work/ungate_work gets an error during hibern8_enter or exit,
> > > >  ufshcd_err_handler()
> > > >    ufshcd_scsi_block_requests()
> > > >    ufshcd_reset_and_restore()
> > > >      ufshcd_clear_ua_wluns() -> stuck
> > > >    ufshcd_scsi_unblock_requests()
> > > >
> > > > In order to avoid it, ufshcd_clear_ua_wluns() can be called per recovery
> > > > flows
> > > > such as suspend/resume, link_recovery, and error_handler.
> > > >
> > > > Fixes: 1918651f2d7e ("scsi: ufs: Clear UAC for RPMB after ufshcd
> > > > resets")
> > > > Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
> > > > ---
> > > >  drivers/scsi/ufs/ufshcd.c | 15 ++++++++++-----
> > > >  1 file changed, 10 insertions(+), 5 deletions(-)
> > > >
> > > > diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> > > > index bedb822a40a3..1678cec08b51 100644
> > > > --- a/drivers/scsi/ufs/ufshcd.c
> > > > +++ b/drivers/scsi/ufs/ufshcd.c
> > > > @@ -3996,6 +3996,8 @@ int ufshcd_link_recovery(struct ufs_hba *hba)
> > > >  	if (ret)
> > > >  		dev_err(hba->dev, "%s: link recovery failed, err %d",
> > > >  			__func__, ret);
> > > > +	else
> > > > +		ufshcd_clear_ua_wluns(hba);
> > > 
> > > Can we put it right after ufshcd_scsi_add_wlus() in ufshcd_add_lus()?
> > 
> > May I ask the reason? We'll call it after ufshcd_add_lus() later tho.
> > 
> 
> I think the code will be more readable - we do all the LU related
> stuffs in one func, just nit-picking though. I found this because
> I am planning to move the devfreq init codes out of ufshcd_add_lus()
> due to it is inappropriate to init devfreq in there by its naming,
> but it might be a good place for ufshcd_clear_ua_wluns().

Ok, that looks good to me. Thanks.

> 
> Thanks,
> Can Guo.
> 
> > > 
> > > Thanks,
> > > Can Guo.
> > > 
> > > >
> > > >  	return ret;
> > > >  }
> > > > @@ -6003,6 +6005,9 @@ static void ufshcd_err_handler(struct work_struct
> > > > *work)
> > > >  	ufshcd_scsi_unblock_requests(hba);
> > > >  	ufshcd_err_handling_unprepare(hba);
> > > >  	up(&hba->eh_sem);
> > > > +
> > > > +	if (!err && needs_reset)
> > > > +		ufshcd_clear_ua_wluns(hba);
> > > >  }
> > > >
> > > >  /**
> > > > @@ -6940,14 +6945,11 @@ static int
> > > > ufshcd_host_reset_and_restore(struct ufs_hba *hba)
> > > >  	ufshcd_set_clk_freq(hba, true);
> > > >
> > > >  	err = ufshcd_hba_enable(hba);
> > > > -	if (err)
> > > > -		goto out;
> > > >
> > > >  	/* Establish the link again and restore the device */
> > > > -	err = ufshcd_probe_hba(hba, false);
> > > >  	if (!err)
> > > > -		ufshcd_clear_ua_wluns(hba);
> > > > -out:
> > > > +		err = ufshcd_probe_hba(hba, false);
> > > > +
> > > >  	if (err)
> > > >  		dev_err(hba->dev, "%s: Host init failed %d\n", __func__, err);
> > > >  	ufshcd_update_evt_hist(hba, UFS_EVT_HOST_RESET, (u32)err);
> > > > @@ -8777,6 +8779,7 @@ static int ufshcd_suspend(struct ufs_hba *hba,
> > > > enum ufs_pm_op pm_op)
> > > >  		ufshcd_resume_clkscaling(hba);
> > > >  	hba->clk_gating.is_suspended = false;
> > > >  	hba->dev_info.b_rpm_dev_flush_capable = false;
> > > > +	ufshcd_clear_ua_wluns(hba);
> > > >  	ufshcd_release(hba);
> > > >  out:
> > > >  	if (hba->dev_info.b_rpm_dev_flush_capable) {
> > > > @@ -8887,6 +8890,8 @@ static int ufshcd_resume(struct ufs_hba *hba,
> > > > enum ufs_pm_op pm_op)
> > > >  		cancel_delayed_work(&hba->rpm_dev_flush_recheck_work);
> > > >  	}
> > > >
> > > > +	ufshcd_clear_ua_wluns(hba);
> > > > +
> > > >  	/* Schedule clock gating in case of no access to UFS device yet */
> > > >  	ufshcd_release(hba);
