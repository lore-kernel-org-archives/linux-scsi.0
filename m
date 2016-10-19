From: Subhash Jadavani <subhashj@codeaurora.org>
Subject: Re: [PATCH 08/10] ufs-qcom: phy/hcd: Refactoring phy clock handling
Date: Wed, 19 Oct 2016 12:18:12 -0700
Message-ID: <b5e0234aea75ab395bc42ad85d45fe4e@codeaurora.org>
References: <1476800897-19898-1-git-send-email-vivek.gautam@codeaurora.org>
 <1476800897-19898-9-git-send-email-vivek.gautam@codeaurora.org>
 <d105d41f88e886f20df0384569b0b688@codeaurora.org>
 <CAFp+6iGN3_1+9Rj+ewMucMY2gVWpSuszM8_dB2Xu4a_iT+ZAHw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAFp+6iGN3_1+9Rj+ewMucMY2gVWpSuszM8_dB2Xu4a_iT+ZAHw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Vivek Gautam <vivek.gautam@codeaurora.org>
Cc: kishon <kishon@ti.com>, jejb@linux.vnet.ibm.com, vinholikatti@gmail.com, martin.petersen@oracle.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 2016-10-19 10:45, Vivek Gautam wrote:
> Hi,
> 
> 
> On Wed, Oct 19, 2016 at 1:43 AM, Subhash Jadavani
> <subhashj@codeaurora.org> wrote:
>> On 2016-10-18 07:28, Vivek Gautam wrote:
>>> 
>>> Add phy clock enable code to phy_power_on/off callbacks, and
>>> remove explicit calls to enable these phy clocks from the
>>> ufs-qcom hcd driver.
>>> 
>>> Signed-off-by: Vivek Gautam <vivek.gautam@codeaurora.org>
>>> ---
>>> 
>>> Changes since v1:
>>>  - staticized ufs_qcom_phy_enable(/disable)_ref_clk(),
>>>  - staticized ufs_qcom_phy_enable(/disable)_iface_clk()
>>>  - removed function declaration and export symbol for these APIs.
> 
> [snip]
> 
>>> --- a/drivers/scsi/ufs/ufs-qcom.c
>>> +++ b/drivers/scsi/ufs/ufs-qcom.c
>>> @@ -1112,17 +1112,6 @@ static int ufs_qcom_setup_clocks(struct 
>>> ufs_hba
>>> *hba, bool on)
>>>                 return 0;
>>> 
>>>         if (on) {
>>> -               err = 
>>> ufs_qcom_phy_enable_iface_clk(host->generic_phy);
>>> -               if (err)
>>> -                       goto out;
>>> -
>>> -               err = ufs_qcom_phy_enable_ref_clk(host->generic_phy);
>>> -               if (err) {
>>> -                       dev_err(hba->dev, "%s enable phy ref clock 
>>> failed,
>>> err=%d\n",
>>> -                               __func__, err);
>>> -                       
>>> ufs_qcom_phy_disable_iface_clk(host->generic_phy);
>>> -                       goto out;
>>> -               }
>> 
>> 
>> Now that you are moving these ref clk enable/disable to 
>> phy_power_on/off and
>> these phy_power_on/off are called only in runtime suspend/resume (3 
>> seconds
>> after last UFS access).
>> Goal is to disable the phy reference clock during aggressive gating 
>> (10ms
>> from last UFS access) so shouldn't we call the phy_power_on/off from 
>> these
>> setup_clocks() function as well?
>> 
> 
> So setup_clocks() is called for aggressive clock gating as well ?
> If that's the case then yes, we may need to call. But we should try to
> understand here. The phy_power_off turns off all the clocks - reflclk,
> and other interface clocks. Do we want all of them to be turned off ?

Yes, we want to turn off the ref clock (& other clocks) during 
aggressive gating.

> 
> phy_power_off will also turn off the PHY. Do we want all this for 
> aggressive
> clock gating ?

Yes, PHY rails can be powered off both during the aggressive clk gating 
and runtime suspend. But as the regulator on/off latencies could be 
higher (especially for the shared rail), we were turning them off doing 
it in runtime suspend only (via phy_power_off()).
Now that phy_power_on/off is managing both clocks and regulators, and we 
will really want to turn off the ref clocks during clock gating, there 
is no option but to call phy_power_on/off during aggressive gating.

> 
> 
> [snip]
> 
> 
> Regards
> Vivek

-- 
The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
