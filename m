From: Alim Akhtar <alim.akhtar@samsung.com>
Subject: Re: [PATCH v3 5/5] Revert
 "scsi: ufs: disable vccq if it's not needed by UFS device"
Date: Wed, 6 Feb 2019 20:53:33 +0530
Message-ID: <64b97f5b-fac3-5348-7118-b5edc72901df@samsung.com>
References: <e3c82a49-c601-effc-348f-f768656c659f@free.fr>
        <CGME20190204174549epcas4p4682667176f55101f69cc24cc455c9f3c@epcas4p4.samsung.com>
        <70618c25-83f0-b9db-51a3-c1d74b605a45@free.fr>
        <5f2a8378-1f22-6a52-356d-56d3b393ab1d@samsung.com>
        <20190205062720.GF31919@minitux>
        <b190a7f0-eec9-3e87-f9c7-4969e05590df@samsung.com>
        <20190205194607.GH31919@minitux>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190205194607.GH31919@minitux>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Bjorn Andersson <bjorn.andersson@linaro.org>
Cc: Marc Gonzalez <marc.w.gonzalez@free.fr>, MSM <linux-arm-msm@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Jeffrey Hugo <jhugo@codeaurora.org>, Andy Gross <andy.gross@linaro.org>, David Brown <david.brown@linaro.org>, Evan Green <evgreen@chromium.org>, Douglas Anderson <dianders@chromium.org>, Avri Altman <avri.altman@wdc.com>, Pedro Sousa <pedrom.sousa@synopsys.com>, Subhash Jadavani <subhashj@codeaurora.org>, Bart Van Assche <bvanassche@acm.org>, SCSI <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org



On 06/02/19 1:16 AM, Bjorn Andersson wrote:
> On Tue 05 Feb 02:52 PST 2019, Alim Akhtar wrote:
> 
>> Hi Bjorn,
>>
>> On 05/02/19 11:57 AM, Bjorn Andersson wrote:
>>> On Mon 04 Feb 20:58 PST 2019, Alim Akhtar wrote:
>>>
>>>> Hi Marc,
>>>>
>>>> On 04/02/19 11:12 PM, Marc Gonzalez wrote:
>>>>> This reverts commit 60f0187031c05e04cbadffb62f557d0ff3564490.
>>>>>
>>>>> Calling ufshcd_set_vccq_rail_unused hangs my system.
>>>>> It seems vccq is not *not* needed.
>>>>>
>>>>> Signed-off-by: Marc Gonzalez <marc.w.gonzalez@free.fr>
>>>>> ---
>>>>
>>>> AFAIK Samsung and Toshiba UFS devices does not use VCCQ (this pin is
>>>> either floating or connected to Ground, at least on the devices that I
>>>> have worked on).
>>>
>>> But why does such system define a vccq-supply? If the system doesn't
>>> have a regulator connected to VCCQ, then the UFS driver shouldn't be
>>> told that there is one. And if VCCQ is optional the UFS driver should
>>> support the fact that this regulator might not be supplied (i.e. call
>>> regulator_get_optional() and handle the error indicating that the supply
>>> isn't specified).
>>>
>> As per JESD220C, chapter 6.1, it does says "VCCQ - Supply voltage used
>> typically for the memory controller and optionally for the PHY
>> interface, the memory IO, and any other internal very low voltage block"
>> And we have VCCQ2 - which serve the pretty much same purpose. The
>> voltage range for VCCQ and VCCQ2 are different, VCCQ has a lower voltage
>> suitable to some low voltage block inside UFS device. I think this is
>> design consideration which allow some vendor to use one less physical
>> pin may be. And also depends on the voltage requirements of some of the
>> internal circuit.
>>
> 
> This looks to me that you are required to have a VCCQ. But you said that
> you do not have a regulator supplying VCCQ on your board, and if that
> really is the case then you should not specify vccq-supply.
> 
> The patch Marc is reverting states that for devices that does not have
> VCCQ connected, some unrelated regulator should be assigned to the UFS
> driver so that it can turn it off.
> 
> 
> If you have a regulator connected to VCCQ then it should go in
> vccq-supply, if you have a regulator connected to VCCQ2 the is should go
> in vccq2-supply. If you don't have these pins connected then there
> shouldn't be any regulators specified here!
> 
Yes, that's correct, it should be like what you are suggesting, DT 
entries should match the board schematic.

> Regards,
> Bjorn
> 
>>
>>> Regards,
>>> Bjorn
>>>
>>>> You said your system hanged, I believe you have set UFS_DEVICE_NO_VCCQ
>>>> quirks, in that case VCCQ regulator should having been disabled.
>>>> So you mean your system hanged because vccq regulator got disabled?
>>>>
>>>>>     drivers/scsi/ufs/ufs.h    |  1 -
>>>>>     drivers/scsi/ufs/ufshcd.c | 59 +++------------------------------------
>>>>>     2 files changed, 4 insertions(+), 56 deletions(-)
>>>>>
>>>>> diff --git a/drivers/scsi/ufs/ufs.h b/drivers/scsi/ufs/ufs.h
>>>>> index dd65fea07687..7da7318eb6a6 100644
>>>>> --- a/drivers/scsi/ufs/ufs.h
>>>>> +++ b/drivers/scsi/ufs/ufs.h
>>>>> @@ -514,7 +514,6 @@ struct ufs_vreg {
>>>>>     	struct regulator *reg;
>>>>>     	const char *name;
>>>>>     	bool enabled;
>>>>> -	bool unused;
>>>>>     	int min_uV;
>>>>>     	int max_uV;
>>>>>     	int min_uA;
>>>>> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
>>>>> index 9ba7671b84f8..8b9a01073d62 100644
>>>>> --- a/drivers/scsi/ufs/ufshcd.c
>>>>> +++ b/drivers/scsi/ufs/ufshcd.c
>>>>> @@ -245,7 +245,6 @@ static int ufshcd_probe_hba(struct ufs_hba *hba);
>>>>>     static int __ufshcd_setup_clocks(struct ufs_hba *hba, bool on,
>>>>>     				 bool skip_ref_clk);
>>>>>     static int ufshcd_setup_clocks(struct ufs_hba *hba, bool on);
>>>>> -static int ufshcd_set_vccq_rail_unused(struct ufs_hba *hba, bool unused);
>>>>>     static int ufshcd_uic_hibern8_exit(struct ufs_hba *hba);
>>>>>     static int ufshcd_uic_hibern8_enter(struct ufs_hba *hba);
>>>>>     static inline void ufshcd_add_delay_before_dme_cmd(struct ufs_hba *hba);
>>>>> @@ -6819,11 +6818,6 @@ static int ufshcd_probe_hba(struct ufs_hba *hba)
>>>>>     	ufs_fixup_device_setup(hba, &card);
>>>>>     	ufshcd_tune_unipro_params(hba);
>>>>>     
>>>>> -	ret = ufshcd_set_vccq_rail_unused(hba,
>>>>> -		(hba->dev_quirks & UFS_DEVICE_NO_VCCQ) ? true : false);
>>>>> -	if (ret)
>>>>> -		goto out;
>>>>> -
>>>>>     	/* UFS device is also active now */
>>>>>     	ufshcd_set_ufs_dev_active(hba);
>>>>>     	ufshcd_force_reset_auto_bkops(hba);
>>>>> @@ -7007,24 +7001,13 @@ static int ufshcd_config_vreg_load(struct device *dev, struct ufs_vreg *vreg,
>>>>>     static inline int ufshcd_config_vreg_lpm(struct ufs_hba *hba,
>>>>>     					 struct ufs_vreg *vreg)
>>>>>     {
>>>>> -	if (!vreg)
>>>>> -		return 0;
>>>>> -	else if (vreg->unused)
>>>>> -		return 0;
>>>>> -	else
>>>>> -		return ufshcd_config_vreg_load(hba->dev, vreg,
>>>>> -					       UFS_VREG_LPM_LOAD_UA);
>>>>> +	return ufshcd_config_vreg_load(hba->dev, vreg, UFS_VREG_LPM_LOAD_UA);
>>>>>     }
>>>>>     
>>>>>     static inline int ufshcd_config_vreg_hpm(struct ufs_hba *hba,
>>>>>     					 struct ufs_vreg *vreg)
>>>>>     {
>>>>> -	if (!vreg)
>>>>> -		return 0;
>>>>> -	else if (vreg->unused)
>>>>> -		return 0;
>>>>> -	else
>>>>> -		return ufshcd_config_vreg_load(hba->dev, vreg, vreg->max_uA);
>>>>> +	return ufshcd_config_vreg_load(hba->dev, vreg, vreg->max_uA);
>>>>>     }
>>>>>     
>>>>>     static int ufshcd_config_vreg(struct device *dev,
>>>>> @@ -7062,9 +7045,7 @@ static int ufshcd_enable_vreg(struct device *dev, struct ufs_vreg *vreg)
>>>>>     {
>>>>>     	int ret = 0;
>>>>>     
>>>>> -	if (!vreg)
>>>>> -		goto out;
>>>>> -	else if (vreg->enabled || vreg->unused)
>>>>> +	if (!vreg || vreg->enabled)
>>>>>     		goto out;
>>>>>     
>>>>>     	ret = ufshcd_config_vreg(dev, vreg, true);
>>>>> @@ -7084,9 +7065,7 @@ static int ufshcd_disable_vreg(struct device *dev, struct ufs_vreg *vreg)
>>>>>     {
>>>>>     	int ret = 0;
>>>>>     
>>>>> -	if (!vreg)
>>>>> -		goto out;
>>>>> -	else if (!vreg->enabled || vreg->unused)
>>>>> +	if (!vreg || !vreg->enabled)
>>>>>     		goto out;
>>>>>     
>>>>>     	ret = regulator_disable(vreg->reg);
>>>>> @@ -7192,36 +7171,6 @@ static int ufshcd_init_hba_vreg(struct ufs_hba *hba)
>>>>>     	return 0;
>>>>>     }
>>>>>     
>>>>> -static int ufshcd_set_vccq_rail_unused(struct ufs_hba *hba, bool unused)
>>>>> -{
>>>>> -	int ret = 0;
>>>>> -	struct ufs_vreg_info *info = &hba->vreg_info;
>>>>> -
>>>>> -	if (!info)
>>>>> -		goto out;
>>>>> -	else if (!info->vccq)
>>>>> -		goto out;
>>>>> -
>>>>> -	if (unused) {
>>>>> -		/* shut off the rail here */
>>>>> -		ret = ufshcd_toggle_vreg(hba->dev, info->vccq, false);
>>>>> -		/*
>>>>> -		 * Mark this rail as no longer used, so it doesn't get enabled
>>>>> -		 * later by mistake
>>>>> -		 */
>>>>> -		if (!ret)
>>>>> -			info->vccq->unused = true;
>>>>> -	} else {
>>>>> -		/*
>>>>> -		 * rail should have been already enabled hence just make sure
>>>>> -		 * that unused flag is cleared.
>>>>> -		 */
>>>>> -		info->vccq->unused = false;
>>>>> -	}
>>>>> -out:
>>>>> -	return ret;
>>>>> -}
>>>>> -
>>>>>     static int __ufshcd_setup_clocks(struct ufs_hba *hba, bool on,
>>>>>     					bool skip_ref_clk)
>>>>>     {
>>>>>
>>>
>>>
> 
> 
