From: Vivek Gautam <vivek.gautam@codeaurora.org>
Subject: Re: [PATCH v3 09/12] ufs-qcom: phy/hcd: Refactoring phy clock handling
Date: Wed, 2 Nov 2016 13:04:09 +0530
Message-ID: <CAFp+6iGiQG2BV0W0rFKEW6YnEWDkjOqoruJ-neTjKjfKx7yVdA@mail.gmail.com>
References: <1477772534-14170-1-git-send-email-vivek.gautam@codeaurora.org>
 <1477772534-14170-10-git-send-email-vivek.gautam@codeaurora.org> <914fedca7fbd41436c085cf2d5b3c2b7@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <914fedca7fbd41436c085cf2d5b3c2b7@codeaurora.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: Subhash Jadavani <subhashj@codeaurora.org>
Cc: kishon <kishon@ti.com>, jejb@linux.vnet.ibm.com, Vinayak Holikatti <vinholikatti@gmail.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Stephen Boyd <sboyd@codeaurora.org>, Yaniv Gardi <ygardi@codeaurora.org>, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi Subhash,

On Wed, Nov 2, 2016 at 12:17 AM, Subhash Jadavani
<subhashj@codeaurora.org> wrote:
> On 2016-10-29 13:22, Vivek Gautam wrote:
>>
>> Add phy clock enable code to phy_power_on/off callbacks, and
>> remove explicit calls to enable these phy clocks from the
>> ufs-qcom hcd driver.
>>
>> Signed-off-by: Vivek Gautam <vivek.gautam@codeaurora.org>
>> ---
>>
>> Changes since v2:
>>  - Added phy_power_on() and phy_power_off() calls to
>>    power-cycle the PHY during aggressive clk gating.
>>
>> Changes since v1:
>>  - staticized ufs_qcom_phy_enable(/disable)_ref_clk(),
>>  - staticized ufs_qcom_phy_enable(/disable)_iface_clk()
>>  - removed function declaration and export symbol for these APIs.
>>
>>  drivers/phy/phy-qcom-ufs.c       | 36
>> ++++++++++++++++++------------------
>>  drivers/scsi/ufs/ufs-qcom.c      | 18 +++---------------
>>  include/linux/phy/phy-qcom-ufs.h | 18 ------------------
>>  3 files changed, 21 insertions(+), 51 deletions(-)
>>

[snip]

>> diff --git a/drivers/scsi/ufs/ufs-qcom.c b/drivers/scsi/ufs/ufs-qcom.c
>> index 3aedf73..9b6a081 100644
>> --- a/drivers/scsi/ufs/ufs-qcom.c
>> +++ b/drivers/scsi/ufs/ufs-qcom.c
>> @@ -1112,17 +1112,7 @@ static int ufs_qcom_setup_clocks(struct ufs_hba
>> *hba, bool on)
>>                 return 0;
>>
>>         if (on) {
>> -               err = ufs_qcom_phy_enable_iface_clk(host->generic_phy);
>> -               if (err)
>> -                       goto out;
>> -
>> -               err = ufs_qcom_phy_enable_ref_clk(host->generic_phy);
>> -               if (err) {
>> -                       dev_err(hba->dev, "%s enable phy ref clock failed,
>> err=%d\n",
>> -                               __func__, err);
>> -                       ufs_qcom_phy_disable_iface_clk(host->generic_phy);
>> -                       goto out;
>> -               }
>> +               phy_power_on(host->generic_phy);
>>                 /* enable the device ref clock for HS mode*/
>>                 if (ufshcd_is_hs_mode(&hba->pwr_info))
>>                         ufs_qcom_dev_ref_clk_ctrl(host, true);
>> @@ -1131,9 +1121,8 @@ static int ufs_qcom_setup_clocks(struct ufs_hba
>> *hba, bool on)
>>                         ufs_qcom_update_bus_bw_vote(host);
>>
>>         } else {
>> -
>> -               /* M-PHY RMMI interface clocks can be turned off */
>> -               ufs_qcom_phy_disable_iface_clk(host->generic_phy);
>> +               /* powering off PHY during aggressive clk gating */
>> +               phy_power_off(host->generic_phy);
>
>
> We can only power off PHY if link isn't active so phy_power_off call should
> be under phy link not active condition check below. Rest all looks good in
> this patch.

Correct, will update this.
Thanks!

>
>
>>                 if (!ufs_qcom_is_link_active(hba))
>>                         /* disable device ref_clk */
>>                         ufs_qcom_dev_ref_clk_ctrl(host, false);
>> @@ -1146,7 +1135,6 @@ static int ufs_qcom_setup_clocks(struct ufs_hba
>> *hba, bool on)
>>                 dev_err(hba->dev, "%s: set bus vote failed %d\n",
>>                                 __func__, err);
>>
>> -out:
>>         return err;
>>  }



-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
