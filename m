From: Vivek Gautam <vivek.gautam@codeaurora.org>
Subject: Re: [PATCH 5/5] ufs/phy: qcom: Refactor to use phy_init call
Date: Wed, 27 Sep 2017 11:51:48 +0530
Message-ID: <CAFp+6iEha0Kxr+jR3Xes6w0DquEDrF6V_erk+W9+5DGXLEk8_w@mail.gmail.com>
References: <1501829332-5183-1-git-send-email-vivek.gautam@codeaurora.org>
 <1501829332-5183-6-git-send-email-vivek.gautam@codeaurora.org> <ae7e2eece45766f7471fc4e19a6fa264@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <ae7e2eece45766f7471fc4e19a6fa264@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Subhash Jadavani <subhashj@codeaurora.org>
Cc: kishon <kishon@ti.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, robh+dt <robh+dt@kernel.org>, linux-arm-msm <linux-arm-msm@vger.kernel.org>, Bjorn Andersson <bjorn.andersson@linaro.org>, "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, jejb@linux.vnet.ibm.com, Vinayak Holikatti <vinholikatti@gmail.com>
List-Id: linux-scsi@vger.kernel.org

Hi Subhash,


On Wed, Sep 27, 2017 at 4:43 AM, Subhash Jadavani
<subhashj@codeaurora.org> wrote:
> Hi Vivek,
>
> Please find one comment inline below, rest look good.
>
> Regards,
> Subhash
>
>
> On 2017-08-03 23:48, Vivek Gautam wrote:
>>
>> Refactor ufs_qcom_power_up_sequence() to get rid of ugly
>> exported phy APIs and use the phy_init() and phy_power_on()
>> to do the phy initialization.
>>
>> Signed-off-by: Vivek Gautam <vivek.gautam@codeaurora.org>
>> ---
>>  drivers/phy/qualcomm/phy-qcom-ufs-i.h        |  2 --
>>  drivers/phy/qualcomm/phy-qcom-ufs-qmp-14nm.c |  9 +++++--
>>  drivers/phy/qualcomm/phy-qcom-ufs-qmp-20nm.c |  9 +++++--
>>  drivers/phy/qualcomm/phy-qcom-ufs.c          | 38
>> ++++++++--------------------
>>  drivers/scsi/ufs/ufs-qcom.c                  | 36
>> ++++++++++----------------
>>  include/linux/phy/phy-qcom-ufs.h             |  3 ---
>>  6 files changed, 38 insertions(+), 59 deletions(-)
>>
>> diff --git a/drivers/phy/qualcomm/phy-qcom-ufs-i.h
>> b/drivers/phy/qualcomm/phy-qcom-ufs-i.h
>> index 94326ed107c3..495fd5941231 100644
>> --- a/drivers/phy/qualcomm/phy-qcom-ufs-i.h
>> +++ b/drivers/phy/qualcomm/phy-qcom-ufs-i.h
>> @@ -123,7 +123,6 @@ struct ufs_qcom_phy {
>>   * struct ufs_qcom_phy_specific_ops - set of pointers to functions which
>> have a
>>   * specific implementation per phy. Each UFS phy, should implement
>>   * those functions according to its spec and requirements
>> - * @calibrate_phy: pointer to a function that calibrate the phy
>>   * @start_serdes: pointer to a function that starts the serdes
>>   * @is_physical_coding_sublayer_ready: pointer to a function that
>>   * checks pcs readiness. returns 0 for success and non-zero for error.
>> @@ -132,7 +131,6 @@ struct ufs_qcom_phy {
>>   * and writes to QSERDES_RX_SIGDET_CNTRL attribute
>>   */
>>  struct ufs_qcom_phy_specific_ops {
>> -       int (*calibrate_phy)(struct ufs_qcom_phy *phy, bool is_rate_B);
>>         void (*start_serdes)(struct ufs_qcom_phy *phy);
>>         int (*is_physical_coding_sublayer_ready)(struct ufs_qcom_phy
>> *phy);
>>         void (*set_tx_lane_enable)(struct ufs_qcom_phy *phy, u32 val);
>> diff --git a/drivers/phy/qualcomm/phy-qcom-ufs-qmp-14nm.c
>> b/drivers/phy/qualcomm/phy-qcom-ufs-qmp-14nm.c
>> index af65785230b5..c39440b56b6d 100644
>> --- a/drivers/phy/qualcomm/phy-qcom-ufs-qmp-14nm.c
>> +++ b/drivers/phy/qualcomm/phy-qcom-ufs-qmp-14nm.c
>> @@ -44,7 +44,13 @@ void ufs_qcom_phy_qmp_14nm_advertise_quirks(struct
>> ufs_qcom_phy *phy_common)
>>
>>  static int ufs_qcom_phy_qmp_14nm_init(struct phy *generic_phy)
>>  {
>> -       return 0;
>> +       struct ufs_qcom_phy *phy_common = get_ufs_qcom_phy(generic_phy);
>> +       bool is_rate_B = false;
>> +
>> +       if (phy_common->mode == PHY_MODE_UFS_HS_B)
>> +               is_rate_B = true;
>> +
>> +       return ufs_qcom_phy_qmp_14nm_phy_calibrate(phy_common, is_rate_B);
>>  }
>>
>>  static int ufs_qcom_phy_qmp_14nm_exit(struct phy *generic_phy)
>> @@ -120,7 +126,6 @@ static int
>> ufs_qcom_phy_qmp_14nm_is_pcs_ready(struct ufs_qcom_phy *phy_common)
>>  };
>>
>>  static struct ufs_qcom_phy_specific_ops phy_14nm_ops = {
>> -       .calibrate_phy          = ufs_qcom_phy_qmp_14nm_phy_calibrate,
>>         .start_serdes           = ufs_qcom_phy_qmp_14nm_start_serdes,
>>         .is_physical_coding_sublayer_ready =
>> ufs_qcom_phy_qmp_14nm_is_pcs_ready,
>>         .set_tx_lane_enable     =
>> ufs_qcom_phy_qmp_14nm_set_tx_lane_enable,
>> diff --git a/drivers/phy/qualcomm/phy-qcom-ufs-qmp-20nm.c
>> b/drivers/phy/qualcomm/phy-qcom-ufs-qmp-20nm.c
>> index 5c18c41dbdb4..5705a2d4c6d2 100644
>> --- a/drivers/phy/qualcomm/phy-qcom-ufs-qmp-20nm.c
>> +++ b/drivers/phy/qualcomm/phy-qcom-ufs-qmp-20nm.c
>> @@ -63,7 +63,13 @@ void ufs_qcom_phy_qmp_20nm_advertise_quirks(struct
>> ufs_qcom_phy *phy_common)
>>
>>  static int ufs_qcom_phy_qmp_20nm_init(struct phy *generic_phy)
>>  {
>> -       return 0;
>> +       struct ufs_qcom_phy *phy_common = get_ufs_qcom_phy(generic_phy);
>> +       bool is_rate_B = false;
>> +
>> +       if (phy_common->mode == PHY_MODE_UFS_HS_B)
>> +               is_rate_B = true;
>> +
>> +       return ufs_qcom_phy_qmp_20nm_phy_calibrate(phy_common, is_rate_B);
>>  }
>>
>>  static int ufs_qcom_phy_qmp_20nm_exit(struct phy *generic_phy)
>> @@ -178,7 +184,6 @@ static int
>> ufs_qcom_phy_qmp_20nm_is_pcs_ready(struct ufs_qcom_phy *phy_common)
>>  };
>>
>>  static struct ufs_qcom_phy_specific_ops phy_20nm_ops = {
>> -       .calibrate_phy          = ufs_qcom_phy_qmp_20nm_phy_calibrate,
>>         .start_serdes           = ufs_qcom_phy_qmp_20nm_start_serdes,
>>         .is_physical_coding_sublayer_ready =
>> ufs_qcom_phy_qmp_20nm_is_pcs_ready,
>>         .set_tx_lane_enable     =
>> ufs_qcom_phy_qmp_20nm_set_tx_lane_enable,
>> diff --git a/drivers/phy/qualcomm/phy-qcom-ufs.c
>> b/drivers/phy/qualcomm/phy-qcom-ufs.c
>> index 43865ef340e2..1febe3294fe3 100644
>> --- a/drivers/phy/qualcomm/phy-qcom-ufs.c
>> +++ b/drivers/phy/qualcomm/phy-qcom-ufs.c
>> @@ -518,9 +518,8 @@ void ufs_qcom_phy_disable_iface_clk(struct
>> ufs_qcom_phy *phy)
>>         }
>>  }
>>
>> -int ufs_qcom_phy_start_serdes(struct phy *generic_phy)
>> +static int ufs_qcom_phy_start_serdes(struct ufs_qcom_phy *ufs_qcom_phy)
>>  {
>> -       struct ufs_qcom_phy *ufs_qcom_phy = get_ufs_qcom_phy(generic_phy);
>>         int ret = 0;
>>
>>         if (!ufs_qcom_phy->phy_spec_ops->start_serdes) {
>> @@ -533,7 +532,6 @@ int ufs_qcom_phy_start_serdes(struct phy *generic_phy)
>>
>>         return ret;
>>  }
>> -EXPORT_SYMBOL_GPL(ufs_qcom_phy_start_serdes);
>>
>>  int ufs_qcom_phy_set_tx_lane_enable(struct phy *generic_phy, u32
>> tx_lanes)
>>  {
>> @@ -564,31 +562,8 @@ void ufs_qcom_phy_save_controller_version(struct
>> phy *generic_phy,
>>  }
>>  EXPORT_SYMBOL_GPL(ufs_qcom_phy_save_controller_version);
>>
>> -int ufs_qcom_phy_calibrate_phy(struct phy *generic_phy, bool is_rate_B)
>> -{
>> -       struct ufs_qcom_phy *ufs_qcom_phy = get_ufs_qcom_phy(generic_phy);
>> -       int ret = 0;
>> -
>> -       if (!ufs_qcom_phy->phy_spec_ops->calibrate_phy) {
>> -               dev_err(ufs_qcom_phy->dev, "%s: calibrate_phy() callback
>> is not supported\n",
>> -                       __func__);
>> -               ret = -ENOTSUPP;
>> -       } else {
>> -               ret = ufs_qcom_phy->phy_spec_ops->
>> -                               calibrate_phy(ufs_qcom_phy, is_rate_B);
>> -               if (ret)
>> -                       dev_err(ufs_qcom_phy->dev, "%s: calibrate_phy()
>> failed %d\n",
>> -                               __func__, ret);
>> -       }
>> -
>> -       return ret;
>> -}
>> -EXPORT_SYMBOL_GPL(ufs_qcom_phy_calibrate_phy);
>> -
>> -int ufs_qcom_phy_is_pcs_ready(struct phy *generic_phy)
>> +static int ufs_qcom_phy_is_pcs_ready(struct ufs_qcom_phy *ufs_qcom_phy)
>>  {
>> -       struct ufs_qcom_phy *ufs_qcom_phy = get_ufs_qcom_phy(generic_phy);
>> -
>>         if
>> (!ufs_qcom_phy->phy_spec_ops->is_physical_coding_sublayer_ready) {
>>                 dev_err(ufs_qcom_phy->dev, "%s:
>> is_physical_coding_sublayer_ready()
>> callback is not supported\n",
>>                         __func__);
>> @@ -598,7 +573,6 @@ int ufs_qcom_phy_is_pcs_ready(struct phy *generic_phy)
>>         return ufs_qcom_phy->phy_spec_ops->
>>                         is_physical_coding_sublayer_ready(ufs_qcom_phy);
>>  }
>> -EXPORT_SYMBOL_GPL(ufs_qcom_phy_is_pcs_ready);
>>
>>  int ufs_qcom_phy_power_on(struct phy *generic_phy)
>>  {
>> @@ -609,6 +583,14 @@ int ufs_qcom_phy_power_on(struct phy *generic_phy)
>>         if (phy_common->is_powered_on)
>>                 return 0;
>>
>> +       err = ufs_qcom_phy_start_serdes(phy_common);
>> +       if (err)
>> +               return err;
>> +
>> +       err = ufs_qcom_phy_is_pcs_ready(phy_common);
>> +       if (err)
>> +               return err;
>> +
>
>
> Now that we are doing serdes start (and checking the PCS ready), I am not
> sure we can call phy_power_on() from ufs_qcom_resume(). Please check.
>

Right. Thanks for catching this. I will check this further.

BRs
Vivek

[snip]


-- 
QUALCOMM INDIA, on behalf of Qualcomm Innovation Center, Inc. is a member
of Code Aurora Forum, hosted by The Linux Foundation
