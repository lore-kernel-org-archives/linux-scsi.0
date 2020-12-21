Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72945C433E0
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Dec 2020 15:15:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4353B22C7E
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Dec 2020 15:15:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725938AbgLUPPa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 21 Dec 2020 10:15:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:34912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725782AbgLUPPa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 21 Dec 2020 10:15:30 -0500
Date:   Mon, 21 Dec 2020 07:14:47 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608563689;
        bh=Iu9TuhJ7NDvhFKKeIzHd4mGP0QOBHupZAguizw7gbiA=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=T8DMub7MxY8tOQ9YY08z0bgQQSsOY+P8aNc1dOCCKiRArpHAS6Hu9RzeHMzmuEHW5
         qLJmnPrWRdg93LaOlP90BWYHmIALafjfEzIGv/C3svodn9gyVKEIhHW5X1CQdsmIZ5
         SOBPWkj/36YqsVCkaGzjZTmr1Xquspwb+ndvspGsMDAMnE/ZR1eTajYAtWbRiuW+RL
         X/0gLVST9ybIsXBehGqlmy7m+eNNdllHP+yhoJyqLWmCzhJ4qhYQ6alO5kE6sKbL1o
         dVoZhgp6zkqLSuI562ZCMbWvfd8U0diDnL8k8D7paR53ziM4kcVEJD6T/vg/TgixAJ
         QsotNGWA1T5aQ==
From:   Jaegeuk Kim <jaegeuk@kernel.org>
To:     Can Guo <cang@codeaurora.org>
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, alim.akhtar@samsung.com,
        avri.altman@wdc.com, bvanassche@acm.org,
        martin.petersen@oracle.com, stanley.chu@mediatek.com
Subject: Re: [PATCH] scsi: ufs: fix livelock of ufshcd_clear_ua_wluns
Message-ID: <X+C75+WtgktRI9cA@google.com>
References: <20201218033131.2624065-1-jaegeuk@kernel.org>
 <153e563a381c580f76447a12df9f4138@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <153e563a381c580f76447a12df9f4138@codeaurora.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/21, Can Guo wrote:
> On 2020-12-18 11:31, Jaegeuk Kim wrote:
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
> > Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
> > ---
> >  drivers/scsi/ufs/ufshcd.c | 14 +++++++++-----
> >  1 file changed, 9 insertions(+), 5 deletions(-)
> > 
> > diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> > index e221add25a7e..e711def829cd 100644
> > --- a/drivers/scsi/ufs/ufshcd.c
> > +++ b/drivers/scsi/ufs/ufshcd.c
> > @@ -3963,6 +3963,8 @@ int ufshcd_link_recovery(struct ufs_hba *hba)
> >  	if (ret)
> >  		dev_err(hba->dev, "%s: link recovery failed, err %d",
> >  			__func__, ret);
> > +	else
> > +		ufshcd_clear_ua_wluns(hba);
> > 
> >  	return ret;
> >  }
> > @@ -5968,6 +5970,8 @@ static void ufshcd_err_handler(struct work_struct
> > *work)
> >  	ufshcd_scsi_unblock_requests(hba);
> >  	ufshcd_err_handling_unprepare(hba);
> >  	up(&hba->eh_sem);
> > +
> 
> Maybe add a check like if (!err && needs_reset) as error handler
> also handles non-fatal errors which do not require a full reset
> and restore?

I see. Let me add it in v2.

> 
> > +	ufshcd_clear_ua_wluns(hba);
> >  }
> > 
> >  /**
> > @@ -6908,14 +6912,11 @@ static int
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
> > @@ -8745,6 +8746,7 @@ static int ufshcd_suspend(struct ufs_hba *hba,
> > enum ufs_pm_op pm_op)
> >  		ufshcd_resume_clkscaling(hba);
> >  	hba->clk_gating.is_suspended = false;
> >  	hba->dev_info.b_rpm_dev_flush_capable = false;
> > +	ufshcd_clear_ua_wluns(hba);
> >  	ufshcd_release(hba);
> >  out:
> >  	if (hba->dev_info.b_rpm_dev_flush_capable) {
> > @@ -8855,6 +8857,8 @@ static int ufshcd_resume(struct ufs_hba *hba,
> > enum ufs_pm_op pm_op)
> >  		cancel_delayed_work(&hba->rpm_dev_flush_recheck_work);
> >  	}
> > 
> > +	ufshcd_clear_ua_wluns(hba);
> > +
> >  	/* Schedule clock gating in case of no access to UFS device yet */
> >  	ufshcd_release(hba);
