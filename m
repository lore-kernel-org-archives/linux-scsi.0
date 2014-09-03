From: "Dolev Raviv" <draviv@codeaurora.org>
Subject: RE: [PATCH/RFC V2 10/16] scsi: ufs: add UFS power management
 support
Date: Wed, 3 Sep 2014 13:04:20 -0000
Message-ID: <7b5925f81c3e6a344fd50251405a0789.squirrel@www.codeaurora.org>
References: <1408023067-26103-1-git-send-email-draviv@codeaurora.org>
    <1408023067-26103-11-git-send-email-draviv@codeaurora.org>
    <17296D9F8FF2234F831FC3DF505A87A911B24B10@shsmsx102.ccr.corp.intel.com>
    <17296D9F8FF2234F831FC3DF505A87A911B25A0C@shsmsx102.ccr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:40857 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932379AbaICNEV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Sep 2014 09:04:21 -0400
In-Reply-To: <17296D9F8FF2234F831FC3DF505A87A911B25A0C@shsmsx102.ccr.corp.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Dong, Chuanxiao" <chuanxiao.dong@intel.com>
Cc: Dolev Raviv <draviv@codeaurora.org>, "James.Bottomley@HansenPartnership.com" <james.bottomley@hansenpartnership.com>, "hch@infradead.org" <hch@infradead.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-scsi-owner@vger.kernel.org" <linux-scsi-owner@vger.kernel.org>, "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>, "santoshsy@gmail.com" <santoshsy@gmail.com>, Subhash Jadavani <subhashj@codeaurora.org>, Sujit Reddy Thumma <sthumma@codeaurora.org>

Hi all,
Thanks for reviewing the patches, I'm sorry for the late replay. I was
waiting for some comments before I address all at once and re-send the
series.

>> > +/**
>> > + * ufshcd_resume - helper function for resume operations
>> > + * @hba: per adapter instance
>> > + * @pm_op: runtime PM or system PM
>> > + *
>> > + * This function basically brings the UFS device, UniPro link and
>> > +controller
>> > + * to active state.
>> > + *
>> > + * Returns 0 for success and non-zero for failure  */ static int
>> > +ufshcd_resume(struct ufs_hba *hba, enum ufs_pm_op pm_op)
>> >  {
>> > -	if (!hba)
>> > -		return 0;
>> > +	int ret;
>> > +	enum uic_link_state old_link_state;
>> > +
>> > +	hba->pm_op_in_progress = 1;
>> > +	old_link_state = hba->uic_link_state;
>> > +	/* Make sure clocks are enabled before accessing controller */
>> > +	ret = ufshcd_setup_clocks(hba, true);
>> > +	if (ret)
>> > +		goto out;
>> > +
>> > +	if (hba->vops && hba->vops->setup_clocks) {
>> > +		ret = hba->vops->setup_clocks(hba, true);
>> > +		if (ret)
>> > +			goto disable_clks;
>> > +	}
>> > +
>> > +	/* enable the host irq as host controller would be active soon */
>> > +	ufshcd_enable_irq(hba);
>> > +
>> > +	ret = ufshcd_vreg_set_hpm(hba);
>> > +	if (ret)
>> > +		goto disable_irq_and_vops_clks;
>> >
>> >  	/*
>> > -	 * The device is idle with no requests in the queue,
>> > -	 * allow background operations.
>> > +	 * Call vendor specific resume callback. As these callbacks may
>> access
>> > +	 * vendor specific host controller register space call them when the
>> > +	 * host clocks are ON.
>> >  	 */
>> > -	return ufshcd_enable_auto_bkops(hba);
>> > +	if (hba->vops && hba->vops->resume) {
>> > +		ret = hba->vops->resume(hba, pm_op);
>> > +		if (ret)
>> > +			goto disable_vreg;
>> > +	}
>> > +
>> > +	if (ufshcd_is_link_hibern8(hba)) {
>> > +		ret = ufshcd_uic_hibern8_exit(hba);
>> > +		if (!ret)
>> > +			ufshcd_set_link_active(hba);
>> > +		else
>> > +			goto vendor_suspend;
>> > +	} else if (ufshcd_is_link_off(hba)) {
>> > +		ret = ufshcd_host_reset_and_restore(hba);
>> > +		/*
>> > +		 * ufshcd_host_reset_and_restore() should have already
>> > +		 * set the link state as active
>> > +		 */
>> > +		if (ret || !ufshcd_is_link_active(hba))
>> > +			goto vendor_suspend;
>> > +	}
>> > +
>> > +	if (!ufshcd_is_ufs_dev_active(hba)) {
>> > +		ret = ufshcd_set_dev_pwr_mode(hba, UFS_ACTIVE_PWR_MODE);
>> > +		if (ret)
>> > +			goto set_old_link_state;
>> > +	}
>> > +
>> > +	ufshcd_disable_auto_bkops(hba);
>
> Should be auto background operation enabled again in ufshcd_resume()? It
> is disabled during ufshcd_suspend().
>
> Thanks
> Chuanxiao

Chuanxiao,
If the system is going for runtime suspend, the bkops are enabled if
necessary, and in any case disabled before the suspend. On resume we make
sure, bkops are disabled.

Thanks,
Dolev

>> > --
>> > To unsubscribe from this list: send the line "unsubscribe linux-scsi"
>> in the body
>> > of a message to majordomo@vger.kernel.org More majordomo info at
>> > http://vger.kernel.org/majordomo-info.html
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


-- 
QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member
of Code Aurora Forum, hosted by The Linux Foundation

