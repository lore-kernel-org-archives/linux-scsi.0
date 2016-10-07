From: Subhash Jadavani <subhashj@codeaurora.org>
Subject: Re: [PATCH v2] scsi: ufshcd: fix possible unclocked register access
Date: Thu, 06 Oct 2016 18:20:03 -0700
Message-ID: <7f35c3fa2a9ac55991072569675ddd3d@codeaurora.org>
References: <CGME20161006021800epcas2p37d8a2c5f93e76c3e670adbb7f7c172ad@epcas2p3.samsung.com>
 <1475720241-25836-1-git-send-email-subhashj@codeaurora.org>
 <000401d21fbc$62fd3600$28f7a200$@samsung.com>
 <e00fa237216d667cff08e4268bb0d2f7@codeaurora.org>
 <00a301d22038$5d4adb50$17e091f0$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:34361 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935974AbcJGBUF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Oct 2016 21:20:05 -0400
In-Reply-To: <00a301d22038$5d4adb50$17e091f0$@samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kiwoong Kim <kwmad.kim@samsung.com>
Cc: vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, "'open list:UNIVERSAL FLASH STORAGE HOST CONTROLLER DRIVER'" <linux-scsi@vger.kernel.org>, 'open list' <linux-kernel@vger.kernel.org>, linux-scsi-owner@vger.kernel.org

On 2016-10-06 18:16, Kiwoong Kim wrote:
> Hi, Subhash.
> 
>> Thanks Kim for the response.
>> 
>> On 2016-10-06 03:28, Kiwoong Kim wrote:
>> > Hi, Subhash.
>> >
>> > Some UFS host controllers may need to call the vendor specific
>> > callback before and after controlling by clock control framework,
>> > regardless of whether available clocks are turned on or off.
>> 
>> Are you suggesting to call ufshcd_vops_setup_clocks() 2 times, one 
>> before
>> the on/off by ufshcd core driver and one after the on/off? If yes, 
>> then we
>> also have add 3rd argument clarifying if this is PRE_CHANGE or
> POST_CHANGE.
>> 
>> >
>> > Is there any special reason to limit to invoke the callback
>> > only when the clocks are turned on or not?
>> >
>> > Besides, the callback is acknowledged from core driver
>> > because 2nd argument is whether the clocks are turned on or not.
>> >
>> > If you have any other idea, please let me know.
>> 
>> This is my suggestion:
>> 1. Add 3rd argument to setup_clocks ops to let the vendor callback
>> function know if this is called PRE_CHANGE or POST_CHANGE.
>> 2. If #1 is in place, call setup_clocks 2 times, one with PRE_CHANGE
>> argument before making any clock changes in core driver, 2nd with
>> POST_CHANGE argument after making the clock changes to core driver.
> 
> Yes, that's exactly the same what I mean.

Thanks, Will send out new version adding that.

> 
> Thanks
> 
> 
>> 
>> Let me know if this would work or not.
>> 
>> Thanks,
>> Subhash
>> 
>> >
>> > Thanks
>> > Regards
>> >
>> >> Vendor specific setup_clocks callback may require the clocks managed
>> >> by ufshcd driver to be ON. So if the vendor specific setup_clocks
>> >> callback
>> >> is called while the required clocks are turned off, it could result
>> >> into
>> >> unclocked register access.
>> >>
>> >> To prevent possible unclock register access, this change makes sure
>> >> that
>> >> required clocks remain enabled before calling into vendor specific
>> >> setup_clocks callback.
>> >>
>> >> Signed-off-by: Subhash Jadavani <subhashj@codeaurora.org>
>> >> ---
>> >> Changes from v2:
>> >> * Don't call ufshcd_vops_setup_clocks() again for clock off
>> >> ---
>> >>  drivers/scsi/ufs/ufshcd.c | 22 +++++++++++++++++++++-
>> >>  1 file changed, 21 insertions(+), 1 deletion(-)
>> >>
>> >> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
>> >> index 05c7456..c1a77d3 100644
>> >> --- a/drivers/scsi/ufs/ufshcd.c
>> >> +++ b/drivers/scsi/ufs/ufshcd.c
>> >> @@ -5389,6 +5389,17 @@ static int __ufshcd_setup_clocks(struct ufs_hba
>> >> *hba, bool on,
>> >>  	if (!head || list_empty(head))
>> >>  		goto out;
>> >>
>> >> +	/*
>> >> +	 * vendor specific setup_clocks ops may depend on clocks managed by
>> >> +	 * this standard driver hence call the vendor specific setup_clocks
>> >> +	 * before disabling the clocks managed here.
>> >> +	 */
>> >> +	if (!on) {
>> >> +		ret = ufshcd_vops_setup_clocks(hba, on);
>> >> +		if (ret)
>> >> +			return ret;
>> >> +	}
>> >> +
>> >>  	list_for_each_entry(clki, head, list) {
>> >>  		if (!IS_ERR_OR_NULL(clki->clk)) {
>> >>  			if (skip_ref_clk && !strcmp(clki->name, "ref_clk"))
>> >> @@ -5410,7 +5421,16 @@ static int __ufshcd_setup_clocks(struct ufs_hba
>> >> *hba, bool on,
>> >>  		}
>> >>  	}
>> >>
>> >> -	ret = ufshcd_vops_setup_clocks(hba, on);
>> >> +	/*
>> >> +	 * vendor specific setup_clocks ops may depend on clocks managed by
>> >> +	 * this standard driver hence call the vendor specific setup_clocks
>> >> +	 * after enabling the clocks managed here.
>> >> +	 */
>> >> +	if (on) {
>> >> +		ret = ufshcd_vops_setup_clocks(hba, on);
>> >> +		if (ret)
>> >> +			return ret;
>> >> +	}
>> >>  out:
>> >>  	if (ret) {
>> >>  		list_for_each_entry(clki, head, list) {
>> >> --
>> >> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora
>> >> Forum,
>> >> a Linux Foundation Collaborative Project
>> >>
>> >> --
>> >> To unsubscribe from this list: send the line "unsubscribe linux-scsi"
>> >> in
>> >> the body of a message to majordomo@vger.kernel.org
>> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> >
>> >
>> > --
>> > To unsubscribe from this list: send the line "unsubscribe linux-scsi"
>> > in
>> > the body of a message to majordomo@vger.kernel.org
>> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> 
>> --
>> The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
>> a Linux Foundation Collaborative Project
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-scsi" 
>> in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" 
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
