From: Kishon Vijay Abraham I <kishon@ti.com>
Subject: Re: [PATCH v4 11/11] scsi: ufs-exynos: add UFS host support for
 Exynos SoCs
Date: Fri, 23 Oct 2015 20:48:59 +0530
Message-ID: <562A4FE3.9080200@ti.com>
References: <1444827351-24128-1-git-send-email-alim.akhtar@samsung.com>
 <1444827351-24128-12-git-send-email-alim.akhtar@samsung.com>
 <561F18C5.10406@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:35289 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751490AbbJWPTL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 23 Oct 2015 11:19:11 -0400
In-Reply-To: <561F18C5.10406@samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alim Akhtar <alim.akhtar@samsung.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: JBottomley@odin.com, vinholikatti@gmail.com, amit.daniel@samsung.com, essuuj@gmail.com, devicetree@vger.kernel.org, arnd@arndb.de

Hi,

On Thursday 15 October 2015 08:38 AM, Alim Akhtar wrote:
> +CCing kishon Vijay,
> 
> On 10/14/2015 06:25 PM, Alim Akhtar wrote:
>> From: Seungwon Jeon <essuuj@gmail.com>
>>
>> This patch introduces Exynos UFS host controller driver,
>> which mainly handles vendor-specific operations including
>> link startup, power mode change and hibernation/unhibernation.
>>
>> Signed-off-by: Seungwon Jeon <essuuj@gmail.com>
>> Signed-off-by: Alim Akhtar <alim.akhtar@samsung.com>
>> ---
>>   drivers/scsi/ufs/Kconfig         |   12 +
>>   drivers/scsi/ufs/Makefile        |    1 +
>>   drivers/scsi/ufs/ufs-exynos-hw.c |  131 ++++
>>   drivers/scsi/ufs/ufs-exynos-hw.h |   43 ++
>>   drivers/scsi/ufs/ufs-exynos.c    | 1317
>> ++++++++++++++++++++++++++++++++++++++
>>   drivers/scsi/ufs/ufs-exynos.h    |  247 +++++++
>>   drivers/scsi/ufs/ufshci.h        |   26 +-
>>   drivers/scsi/ufs/unipro.h        |   47 ++
>>   8 files changed, 1823 insertions(+), 1 deletion(-)
>>   create mode 100644 drivers/scsi/ufs/ufs-exynos-hw.c
>>   create mode 100644 drivers/scsi/ufs/ufs-exynos-hw.h
>>   create mode 100644 drivers/scsi/ufs/ufs-exynos.c
>>   create mode 100644 drivers/scsi/ufs/ufs-exynos.h
>>
.
.
<snip>
.
.
>> diff --git a/drivers/scsi/ufs/ufs-exynos-hw.c
>> b/drivers/scsi/ufs/ufs-exynos-hw.c
>> new file mode 100644
>> index 000000000000..be6c61541a8f
>> --- /dev/null
>> +++ b/drivers/scsi/ufs/ufs-exynos-hw.c
>> @@ -0,0 +1,131 @@
.
.
<snip>
.
.
>> +
>> +#define PWR_MODE_STR_LEN    64
>> +static int exynos_ufs_post_pwr_mode(struct ufs_hba *hba,
>> +                struct ufs_pa_layer_attr *pwr_max,
>> +                struct ufs_pa_layer_attr *pwr_req)
>> +{
>> +    struct exynos_ufs *ufs = to_exynos_ufs(hba);
>> +    struct exynos_ufs_phy_info *phy_info = phy_get_drvdata(ufs->phy);

This is abusing the interface. phy_get_drvdata is meant to be used only
by the PHY driver.
>> +    struct exynos_ufs_phy_specific_ops *phy_ops =
>> +                    phy_info->phy_specific_ops;

I'm really not happy about having platform specific ops for PHY. We have
to see if existing PHY ops can be used for this or in worst case add new
PHY ops.
>> +    struct uic_pwr_mode *pwr = &ufs->pwr_act;
>> +    char pwr_str[PWR_MODE_STR_LEN] = "";
>> +    int ret = 0;
>> +
>> +    if (ufs->drv_data->post_pwr_change)
>> +        ufs->drv_data->post_pwr_change(ufs, pwr);
>> +
>> +    if (IS_UFS_PWR_MODE_HS(pwr->mode)) {
>> +        switch (pwr->hs_series) {
>> +        case PA_HS_MODE_A:
>> +        case PA_HS_MODE_B:
>> +            phy_ops->calibrate_phy(ufs->phy, CFG_POST_PWR_HS,
>> +                PWR_MODE_HS(pwr->gear, pwr->hs_series));
>> +            break;
>> +        }
>> +
>> +        ret = phy_ops->wait_for_lock_acq(ufs->phy);
>> +        snprintf(pwr_str, sizeof(pwr_str), "Fast%s series_%s G_%d L_%d",
>> +            pwr->mode == FASTAUTO_MODE ? "_Auto" : "",
>> +            pwr->hs_series == PA_HS_MODE_A ? "A" : "B",
>> +            pwr->gear, pwr->lane);
>> +    } else if (IS_UFS_PWR_MODE_PWM(pwr->mode)) {
>> +        snprintf(pwr_str, sizeof(pwr_str), "Slow%s G_%d L_%d",
>> +            pwr->mode == SLOWAUTO_MODE ? "_Auto" : "",
>> +            pwr->gear, pwr->lane);
>> +    }
>> +
>> +    dev_info(hba->dev, "Power mode change %d : %s\n", ret, pwr_str);
>> +    return ret;
>> +}
>> +
>> +static void exynos_ufs_specify_nexus_t_xfer_req(struct ufs_hba *hba,
>> +                        int tag, struct scsi_cmnd *cmd)
>> +{
>> +    struct exynos_ufs *ufs = to_exynos_ufs(hba);
>> +    u32 type;
>> +
>> +    type =  hci_readl(ufs, HCI_UTRL_NEXUS_TYPE);
>> +
>> +    if (cmd)
>> +        hci_writel(ufs, type | (1 << tag), HCI_UTRL_NEXUS_TYPE);
>> +    else
>> +        hci_writel(ufs, type & ~(1 << tag), HCI_UTRL_NEXUS_TYPE);
>> +}
>> +
>> +static void exynos_ufs_specify_nexus_t_tm_req(struct ufs_hba *hba,
>> +                        int tag, u8 func)
>> +{
>> +    struct exynos_ufs *ufs = to_exynos_ufs(hba);
>> +    u32 type;
>> +
>> +    type =  hci_readl(ufs, HCI_UTMRL_NEXUS_TYPE);
>> +
>> +    switch (func) {
>> +    case UFS_ABORT_TASK:
>> +    case UFS_QUERY_TASK:
>> +        hci_writel(ufs, type | (1 << tag), HCI_UTMRL_NEXUS_TYPE);
>> +        break;
>> +    case UFS_ABORT_TASK_SET:
>> +    case UFS_CLEAR_TASK_SET:
>> +    case UFS_LOGICAL_RESET:
>> +    case UFS_QUERY_TASK_SET:
>> +        hci_writel(ufs, type & ~(1 << tag), HCI_UTMRL_NEXUS_TYPE);
>> +        break;
>> +    }
>> +}
>> +
>> +static void exynos_ufs_phy_init(struct exynos_ufs *ufs)
>> +{
>> +    struct ufs_hba *hba = ufs->hba;
>> +    struct exynos_ufs_phy_info *phy_info = phy_get_drvdata(ufs->phy);
>> +    struct exynos_ufs_phy_specific_ops *phy_ops =
>> +                    phy_info->phy_specific_ops;
>> +
>> +    if (ufs->avail_ln_rx == 0 || ufs->avail_ln_tx == 0) {
>> +        ufshcd_dme_get(hba, UIC_ARG_MIB(PA_AVAILRXDATALANES),
>> +            &ufs->avail_ln_rx);
>> +        ufshcd_dme_get(hba, UIC_ARG_MIB(PA_AVAILTXDATALANES),
>> +            &ufs->avail_ln_tx);
>> +        WARN(ufs->avail_ln_rx != ufs->avail_ln_tx,
>> +            "available data lane is not equal(rx:%d, tx:%d)\n",
>> +            ufs->avail_ln_rx, ufs->avail_ln_tx);
>> +    }
>> +
>> +    phy_ops->set_lane_cnt(ufs->phy, ufs->avail_ln_rx);

can't bus_width attribute in phy core be reused for this?

>> +    phy_ops->calibrate_phy(ufs->phy, CFG_PRE_INIT, PWR_MODE_ANY);

Why can't calibrate PHY be directly done in phy_init?

Thanks
Kishon
