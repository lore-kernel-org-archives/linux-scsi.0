Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C22ABC2BB9A
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Dec 2020 01:42:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7551F23406
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Dec 2020 01:42:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729041AbgLQBmB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 16 Dec 2020 20:42:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:41384 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725988AbgLQBmB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 16 Dec 2020 20:42:01 -0500
Date:   Wed, 16 Dec 2020 17:41:18 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608169280;
        bh=A0rKcafmrWfZmMmNs98pYScvdmdVpQNpcuZposdShPI=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=hB6oxGqHxGUs3jADyqRnryg7BOmmCcTG5QTbpitaacTtqoO4XtBpP/WHp0tnPLMLz
         wDua2AGgEIqqf0k14JnY2pt7MRdDQOEI0R78PlAKCcGW5xlDIjllaJ7ZWj/5+JGPuQ
         jiNM7c8bSndy2b5vfep1iALIxgm7RqgwNGL2JKt6O0jQDfwxNfWjRCVyunSNbtZ2wH
         q5eemMGy+xoCnR1IXMQYd0sc8XnolBPGjo9ZpIbzVX96qmyujzUGS0/I9eB+WxcByd
         VKk5+4VmgWbH7q6/kJ3A2vsqDwt8rZfd4FECl9m0CRMAhHjm4rMHX5VKEYJduVohxD
         0DMQYJ81UF3Gw==
From:   Jaegeuk Kim <jaegeuk@kernel.org>
To:     Stanley Chu <stanley.chu@mediatek.com>
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, cang@codeaurora.org,
        alim.akhtar@samsung.com, avri.altman@wdc.com, bvanassche@acm.org,
        martin.petersen@oracle.com
Subject: Re: [PATCH] scsi: ufs: fix livelock on ufshcd_clear_ua_wlun
Message-ID: <X9q3PthnzV/6T/AR@google.com>
References: <20201216190225.2769012-1-jaegeuk@kernel.org>
 <1608168474.10163.37.camel@mtkswgap22>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1608168474.10163.37.camel@mtkswgap22>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/17, Stanley Chu wrote:
> Hi Jaegeuk,
> 
> On Wed, 2020-12-16 at 11:02 -0800, Jaegeuk Kim wrote:
> > From: Jaegeuk Kim <jaegeuk@google.com>
> > 
> > This fixes the below livelock which is caused by calling a scsi command before
> > ufshcd_scsi_unblock_requests() in ufshcd_ungate_work().
> > 
> > Workqueue: ufs_clk_gating_0 ufshcd_ungate_work
> > Call trace:
> >  __switch_to+0x298/0x2bc
> >  __schedule+0x59c/0x760
> >  schedule+0xac/0xf0
> >  schedule_timeout+0x44/0x1b4
> >  io_schedule_timeout+0x44/0x68
> >  wait_for_common_io+0x7c/0x100
> >  wait_for_completion_io+0x14/0x20
> >  blk_execute_rq+0x94/0xd0
> >  __scsi_execute+0x100/0x1c0
> >  ufshcd_clear_ua_wlun+0x124/0x1c8
> >  ufshcd_host_reset_and_restore+0x1d0/0x2cc
> >  ufshcd_link_recovery+0xac/0x134
> >  ufshcd_uic_hibern8_exit+0x1e8/0x1f0
> >  ufshcd_ungate_work+0xac/0x130
> 
> According to the latest mainstream kernel, once
> ufshcd_uic_hibern8_exit() encounters error, instead, error handler work
> will be scheduled without blocking ufshcd_uic_hibern8_exit(). In
> addition, ufshcd_scsi_unblock_requests() would be invoked before leaving
> ufshcd_uic_hibern8_exit(). So this stack is no longer existed.

Oh, thank you for pointing this out. It seems the below patch made it.
4db7a2360597 ("scsi: ufs: Fix concurrency of error handler and other error recovery paths")

Next time, I need to check upstream more carefully. :P

> 
> Thanks,
> Stanley Chu
> 
> >  process_one_work+0x270/0x47c
> >  worker_thread+0x27c/0x4d8
> >  kthread+0x13c/0x320
> >  ret_from_fork+0x10/0x18
> > 
> > Fixes: 1918651f2d7e ("scsi: ufs: Clear UAC for RPMB after ufshcd resets")
> > Signed-off-by: Jaegeuk Kim <jaegeuk@google.com>
> > ---
> >  drivers/scsi/ufs/ufshcd.c | 6 +++++-
> >  1 file changed, 5 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> > index e221add25a7e..b0998db1b781 100644
> > --- a/drivers/scsi/ufs/ufshcd.c
> > +++ b/drivers/scsi/ufs/ufshcd.c
> > @@ -1603,6 +1603,7 @@ static void ufshcd_ungate_work(struct work_struct *work)
> >  	}
> >  unblock_reqs:
> >  	ufshcd_scsi_unblock_requests(hba);
> > +	ufshcd_clear_ua_wluns(hba);
> >  }
> >  
> >  /**
> > @@ -6913,7 +6914,7 @@ static int ufshcd_host_reset_and_restore(struct ufs_hba *hba)
> >  
> >  	/* Establish the link again and restore the device */
> >  	err = ufshcd_probe_hba(hba, false);
> > -	if (!err)
> > +	if (!err && !hba->clk_gating.is_suspended)
> >  		ufshcd_clear_ua_wluns(hba);
> >  out:
> >  	if (err)
> > @@ -8745,6 +8746,7 @@ static int ufshcd_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
> >  		ufshcd_resume_clkscaling(hba);
> >  	hba->clk_gating.is_suspended = false;
> >  	hba->dev_info.b_rpm_dev_flush_capable = false;
> > +	ufshcd_clear_ua_wluns(hba);
> >  	ufshcd_release(hba);
> >  out:
> >  	if (hba->dev_info.b_rpm_dev_flush_capable) {
> > @@ -8855,6 +8857,8 @@ static int ufshcd_resume(struct ufs_hba *hba, enum ufs_pm_op pm_op)
> >  		cancel_delayed_work(&hba->rpm_dev_flush_recheck_work);
> >  	}
> >  
> > +	ufshcd_clear_ua_wluns(hba);
> > +
> >  	/* Schedule clock gating in case of no access to UFS device yet */
> >  	ufshcd_release(hba);
> >  
> 
