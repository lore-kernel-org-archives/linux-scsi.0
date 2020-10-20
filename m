Return-Path: <SRS0=ehq5=D3=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 412EBC41604
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Oct 2020 18:37:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E006C2223C
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Oct 2020 18:37:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1603219021;
	bh=lOiQ/tk5QvPVG9AP0/WfjE9BL3EV6STWZmar57vdY5w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=iTTaCJC0WE/Jxahvs4lykay8Ahc2ort6olNPJBcfUfZ2PLdH9x4tKUVp9jyR8JJ+u
	 rLTjQ5vId8DX3Q1T2oFZb2ilFgWzmj39JV7EsrBlruI2mxUa/Rp48U9esxCWQGCkNO
	 LvJK/KjuerNYvtvOi3DGY4OpVssNmzw8QOk5mfkc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437527AbgJTSg5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 20 Oct 2020 14:36:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:50794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437524AbgJTSg5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 20 Oct 2020 14:36:57 -0400
Received: from localhost (unknown [104.132.1.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 116EA21D7B;
        Tue, 20 Oct 2020 18:36:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603219016;
        bh=lOiQ/tk5QvPVG9AP0/WfjE9BL3EV6STWZmar57vdY5w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=0RszO0H5ka9ulVR5UPb4BKU713HT8IuVcQfjjnUi7iY8Nx+x5pSyz/W4//8H19Cvh
         zIITV3spyqllZPK0VBnSmwQwTcf9HUB2BPjd7z2I2ZQIjOZXX8wS1TJrV9fJ5j4AmP
         eHly5JYyTkSbg3Nvhx6cjM52psz/CoatLzFX6ssE=
Date:   Tue, 20 Oct 2020 11:36:55 -0700
From:   jaegeuk@kernel.org
To:     Can Guo <cang@codeaurora.org>
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>
Subject: Re: [PATCH 2/4] scsi: ufs: clear UAC for FFU and RPMB LUNs
Message-ID: <20201020183655.GB1087816@google.com>
References: <20201005223635.2922805-1-jaegeuk@kernel.org>
 <20201005223635.2922805-2-jaegeuk@kernel.org>
 <3d9c3b844ac861c4cce7242e49e63059@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3d9c3b844ac861c4cce7242e49e63059@codeaurora.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/20, Can Guo wrote:
> On 2020-10-06 06:36, Jaegeuk Kim wrote:
> > From: Jaegeuk Kim <jaegeuk@google.com>
> > 
> > In order to conduct FFU or RPMB operations, UFS needs to clear UAC. This
> > patch
> > clears it explicitly, so that we could get no failure given early
> > execution.
> > 
> 
> Usually it is the user's/utility's/tool's responsiblity to clear UA by
> sending a
> request sense cmd and retry previous cmd, now we are doing it for the users
> in driver?
> As per my understanding, driver only reports UA to SCSI layer and let users
> decide
> what to do with it - maybe users need to do something specifically regs it,
> but
> the change clears it even before the users get to know it.

Well, instead of your expectation, many users have actually complained about why
they need to do this. Even, taking a look at some custom implementations given
by SoC branches, they simply clears it internally.

> 
> Besides, this change clears UA for W-LUs, but the UFS driver still reports
> UA to SCSI
> layer for each SCSI device by calling scsi_report_bus_reset() in
> ufshcd_reset_and_restore(). This will make SCSI layer treat
> sdev->expecting_cc_ua
> wrongly, because for W-LUs, their expecting_cc_ua should not be set as you
> have
> cleared their UAs.

Is that fully restricted? What is the buggy scenario if sub-scsi clears it under
its control?

> 
> Thanks,
> 
> Can Guo.
> 
> > Cc: Alim Akhtar <alim.akhtar@samsung.com>
> > Cc: Avri Altman <avri.altman@wdc.com>
> > Cc: Can Guo <cang@codeaurora.org>
> > Signed-off-by: Jaegeuk Kim <jaegeuk@google.com>
> > ---
> >  drivers/scsi/ufs/ufshcd.c | 70 +++++++++++++++++++++++++++++++++++----
> >  drivers/scsi/ufs/ufshcd.h |  1 +
> >  2 files changed, 65 insertions(+), 6 deletions(-)
> > 
> > diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> > index d929c3d1e58cc..0bb07b50bd23e 100644
> > --- a/drivers/scsi/ufs/ufshcd.c
> > +++ b/drivers/scsi/ufs/ufshcd.c
> > @@ -6841,7 +6841,6 @@ static inline void
> > ufshcd_blk_pm_runtime_init(struct scsi_device *sdev)
> >  static int ufshcd_scsi_add_wlus(struct ufs_hba *hba)
> >  {
> >  	int ret = 0;
> > -	struct scsi_device *sdev_rpmb;
> >  	struct scsi_device *sdev_boot;
> > 
> >  	hba->sdev_ufs_device = __scsi_add_device(hba->host, 0, 0,
> > @@ -6854,14 +6853,14 @@ static int ufshcd_scsi_add_wlus(struct ufs_hba
> > *hba)
> >  	ufshcd_blk_pm_runtime_init(hba->sdev_ufs_device);
> >  	scsi_device_put(hba->sdev_ufs_device);
> > 
> > -	sdev_rpmb = __scsi_add_device(hba->host, 0, 0,
> > +	hba->sdev_rpmb = __scsi_add_device(hba->host, 0, 0,
> >  		ufshcd_upiu_wlun_to_scsi_wlun(UFS_UPIU_RPMB_WLUN), NULL);
> > -	if (IS_ERR(sdev_rpmb)) {
> > -		ret = PTR_ERR(sdev_rpmb);
> > +	if (IS_ERR(hba->sdev_rpmb)) {
> > +		ret = PTR_ERR(hba->sdev_rpmb);
> >  		goto remove_sdev_ufs_device;
> >  	}
> > -	ufshcd_blk_pm_runtime_init(sdev_rpmb);
> > -	scsi_device_put(sdev_rpmb);
> > +	ufshcd_blk_pm_runtime_init(hba->sdev_rpmb);
> > +	scsi_device_put(hba->sdev_rpmb);
> > 
> >  	sdev_boot = __scsi_add_device(hba->host, 0, 0,
> >  		ufshcd_upiu_wlun_to_scsi_wlun(UFS_UPIU_BOOT_WLUN), NULL);
> > @@ -7385,6 +7384,63 @@ static int ufshcd_add_lus(struct ufs_hba *hba)
> >  	return ret;
> >  }
> > 
> > +static int
> > +ufshcd_send_request_sense(struct ufs_hba *hba, struct scsi_device
> > *sdp);
> > +
> > +static int ufshcd_clear_ua_wlun(struct ufs_hba *hba, u8 wlun)
> > +{
> > +	struct scsi_device *sdp;
> > +	unsigned long flags;
> > +	int ret = 0;
> > +
> > +	spin_lock_irqsave(hba->host->host_lock, flags);
> > +	if (wlun  == UFS_UPIU_UFS_DEVICE_WLUN)
> > +		sdp = hba->sdev_ufs_device;
> > +	else if (wlun  == UFS_UPIU_RPMB_WLUN)
> > +		sdp = hba->sdev_rpmb;
> > +	else
> > +		BUG_ON(1);
> > +	if (sdp) {
> > +		ret = scsi_device_get(sdp);
> > +		if (!ret && !scsi_device_online(sdp)) {
> > +			ret = -ENODEV;
> > +			scsi_device_put(sdp);
> > +		}
> > +	} else {
> > +		ret = -ENODEV;
> > +	}
> > +	spin_unlock_irqrestore(hba->host->host_lock, flags);
> > +	if (ret)
> > +		goto out_err;
> > +
> > +	ret = ufshcd_send_request_sense(hba, sdp);
> > +	scsi_device_put(sdp);
> > +out_err:
> > +	if (ret)
> > +		dev_err(hba->dev, "%s: UAC clear LU=%x ret = %d\n",
> > +				__func__, wlun, ret);
> > +	return ret;
> > +}
> > +
> > +static int ufshcd_clear_ua_wluns(struct ufs_hba *hba)
> > +{
> > +	int ret = 0;
> > +
> > +	if (!hba->wlun_dev_clr_ua)
> > +		goto out;
> > +
> > +	ret = ufshcd_clear_ua_wlun(hba, UFS_UPIU_UFS_DEVICE_WLUN);
> > +	if (!ret)
> > +		ret = ufshcd_clear_ua_wlun(hba, UFS_UPIU_RPMB_WLUN);
> > +	if (!ret)
> > +		hba->wlun_dev_clr_ua = false;
> > +out:
> > +	if (ret)
> > +		dev_err(hba->dev, "%s: Failed to clear UAC WLUNS ret = %d\n",
> > +				__func__, ret);
> > +	return ret;
> > +}
> > +
> >  /**
> >   * ufshcd_probe_hba - probe hba to detect device and initialize
> >   * @hba: per-adapter instance
> > @@ -7500,6 +7556,8 @@ static void ufshcd_async_scan(void *data,
> > async_cookie_t cookie)
> >  		pm_runtime_put_sync(hba->dev);
> >  		ufshcd_exit_clk_scaling(hba);
> >  		ufshcd_hba_exit(hba);
> > +	} else {
> > +		ufshcd_clear_ua_wluns(hba);
> >  	}
> >  }
> > 
> > diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
> > index 363589c0bd370..8344d8cb36786 100644
> > --- a/drivers/scsi/ufs/ufshcd.h
> > +++ b/drivers/scsi/ufs/ufshcd.h
> > @@ -662,6 +662,7 @@ struct ufs_hba {
> >  	 * "UFS device" W-LU.
> >  	 */
> >  	struct scsi_device *sdev_ufs_device;
> > +	struct scsi_device *sdev_rpmb;
> > 
> >  	enum ufs_dev_pwr_mode curr_dev_pwr_mode;
> >  	enum uic_link_state uic_link_state;
