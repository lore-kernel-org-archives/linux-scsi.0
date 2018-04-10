From: Vivek Gautam <vivek.gautam@codeaurora.org>
Subject: Re: [PATCH 1/1] scsi/ufs: qcom: Don't enable PHY_QCOM_UFS by default
Date: Tue, 10 Apr 2018 12:01:19 +0530
Message-ID: <fa02c578-a89e-7934-2e88-d3728957ab71@codeaurora.org>
References: <20180409132404.20876-1-vivek.gautam@codeaurora.org>
 <20180409165127.GK453@tuxbook-pro>
 <2588cd12-081a-5fad-7ef5-af78b18168eb@codeaurora.org>
 <20180409200904.GL453@tuxbook-pro>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180409200904.GL453@tuxbook-pro>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Bjorn Andersson <bjorn.andersson@linaro.org>
Cc: martin.petersen@oracle.com, kishon@ti.com, jejb@linux.vnet.ibm.com, subhashj@codeaurora.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org



On 4/10/2018 1:39 AM, Bjorn Andersson wrote:
> On Mon 09 Apr 10:38 PDT 2018, Vivek Gautam wrote:
>> On 4/9/2018 10:21 PM, Bjorn Andersson wrote:
>>> On Mon 09 Apr 06:24 PDT 2018, Vivek Gautam wrote:
> [..]
>>>> diff --git a/include/linux/phy/phy-qcom-ufs.h b/include/linux/phy/phy-qcom-ufs.h
>>>> index 0a2c18a9771d..1388c2a2965e 100644
>>>> --- a/include/linux/phy/phy-qcom-ufs.h
>>>> +++ b/include/linux/phy/phy-qcom-ufs.h
>>>> @@ -31,8 +31,21 @@ void ufs_qcom_phy_enable_dev_ref_clk(struct phy *phy);
>>>>     */
>>>>    void ufs_qcom_phy_disable_dev_ref_clk(struct phy *phy);
>>>> +#if IS_ENABLED(CONFIG_PHY_QCOM_UFS)
>>>>    int ufs_qcom_phy_set_tx_lane_enable(struct phy *phy, u32 tx_lanes);
>>>>    void ufs_qcom_phy_save_controller_version(struct phy *phy,
>>>> -			u8 major, u16 minor, u16 step);
>>>> +					  u8 major, u16 minor, u16 step);
>>>> +#else
>>>> +static inline int ufs_qcom_phy_set_tx_lane_enable(struct phy *phy, u32 tx_lanes)
>>>> +{
>>>> +	return -ENOSYS;
>>>> +}
>>>> +
>>>> +static inline void ufs_qcom_phy_save_controller_version(struct phy *phy,
>>>> +							u8 major, u16 minor,
>>>> +							u16 step)
>>>> +{
>>>> +}
>>>> +#endif /* PHY_QCOM_UFS */
>>> What's the timeline for getting rid of the references to these
>>> functions? I presume that code depending on these being here will
>>> compile but won't actually work?
>> Yes, these inline definitions are just to keep ufs-qcom happy with the
>> direct
>> calls that it makes to these functions.
>> As you would know these couple of functions are just used by the 20nm phy.
>> However, we don't have any platform yet in the upstream that enables this
>> phy.
>> I am hoping that we will eventually get rid of these functions when we
>> further
>> clean up ufs-qcom driver.
>>
> I see, but that means that we're calling this function with a struct phy
> that might not be a struct ufs_qcom_phy and as such a defconfig with
> both enabled will have undefined outcome for the migrated phys.

No, we will have to add support for separate phys as sdm845 has phy per 
each lane,
and the older struct phy will exist alongside.
We will call this function only with the older phy pointer.

> In particular we do expect that the same kernel will boot on db820c and
> sdm845-mtp, so we will have to enable support for the 14nm & 20nm phy
> driver (and we don't want random crashes because someone happened to
> enable it).

Right, so we create new struct phy while keeping older one intact to 
keep the
ufs-qcom work with both - ufs_qcom_phy and qmp_phy.
Some of the controller drivers, such as usb/dwc3/ keep support for old 
and new phys,
although there the difference is between generic phy and the usb-phy.
So, I am assuming that if we want to keep ufs-qcom on platforms using 20nm,
14nm and 10nm phys happy, we will have to keep the phys separately for 
sometime.
What do you say about it?

On db820c, we can still work with the ufs_qcom_phy.

Regards
Vivek
>
>
> So either we add the 10nm support to the existing driver or I think we
> should migrate, at least, the 14nm support to the QMP driver (and mark
> the remaining 20nm BROKEN for now).
>
> Regardless of the path chosen this should be cleaned up to the point
> where all three phys are supported.
>
> Regards,
> Bjorn
> --
> To unsubscribe from this list: send the line "unsubscribe linux-arm-msm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
