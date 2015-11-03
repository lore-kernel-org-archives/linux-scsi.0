From: Alim Akhtar <alim.akhtar-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH v4 11/11] scsi: ufs-exynos: add UFS host support for Exynos
 SoCs
Date: Tue, 03 Nov 2015 17:14:58 +0530
Message-ID: <56389E3A.7060004@samsung.com>
References: <1444827351-24128-1-git-send-email-alim.akhtar@samsung.com>
 <1444827351-24128-12-git-send-email-alim.akhtar@samsung.com>
 <561F18C5.10406@samsung.com> <562A4FE3.9080200@ti.com>
 <CAGOxZ51cFDvvSKN+=nNnHD=P756r74edUX5XrkvrHv+NXU_NTw@mail.gmail.com>
 <5630C55D.80800@ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-reply-to: <5630C55D.80800-l0cyMroinI0@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kishon Vijay Abraham I <kishon-l0cyMroinI0@public.gmane.org>, Alim Akhtar <alim.akhtar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "James E.J. Bottomley" <JBottomley-wo1vFcy6AUs@public.gmane.org>, vinayak holikatti <vinholikatti-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Seungwon Jeon <essuuj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

Hi Kishon,
Thanks for your time.

On 10/28/2015 06:23 PM, Kishon Vijay Abraham I wrote:
> Hi,
>
> On Sunday 25 October 2015 05:34 PM, Alim Akhtar wrote:
>> Hi Kishon
>> Thanks again for you review.
>>
>> On Fri, Oct 23, 2015 at 8:48 PM, Kishon Vijay Abraham I <kishon-l0cyMroinI0@public.gmane.org> wrote:
>>> Hi,
>>>
>>> On Thursday 15 October 2015 08:38 AM, Alim Akhtar wrote:
>>>> +CCing kishon Vijay,
>>>>
>>>> On 10/14/2015 06:25 PM, Alim Akhtar wrote:
>>>>> From: Seungwon Jeon <essuuj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>>>>>
>>>>> This patch introduces Exynos UFS host controller driver,
>>>>> which mainly handles vendor-specific operations including
>>>>> link startup, power mode change and hibernation/unhibernation.
>>>>>
>>>>> Signed-off-by: Seungwon Jeon <essuuj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>>>>> Signed-off-by: Alim Akhtar <alim.akhtar-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
>>>>> ---
>>>>>    drivers/scsi/ufs/Kconfig         |   12 +
>>>>>    drivers/scsi/ufs/Makefile        |    1 +
>>>>>    drivers/scsi/ufs/ufs-exynos-hw.c |  131 ++++
>>>>>    drivers/scsi/ufs/ufs-exynos-hw.h |   43 ++
>>>>>    drivers/scsi/ufs/ufs-exynos.c    | 1317
>>>>> ++++++++++++++++++++++++++++++++++++++
>>>>>    drivers/scsi/ufs/ufs-exynos.h    |  247 +++++++
>>>>>    drivers/scsi/ufs/ufshci.h        |   26 +-
>>>>>    drivers/scsi/ufs/unipro.h        |   47 ++
>>>>>    8 files changed, 1823 insertions(+), 1 deletion(-)
>>>>>    create mode 100644 drivers/scsi/ufs/ufs-exynos-hw.c
>>>>>    create mode 100644 drivers/scsi/ufs/ufs-exynos-hw.h
>>>>>    create mode 100644 drivers/scsi/ufs/ufs-exynos.c
>>>>>    create mode 100644 drivers/scsi/ufs/ufs-exynos.h
>>>>>
>>> .
>>> .
>>> <snip>
>>> .
>>> .
>>>>> diff --git a/drivers/scsi/ufs/ufs-exynos-hw.c
>>>>> b/drivers/scsi/ufs/ufs-exynos-hw.c
>>>>> new file mode 100644
>>>>> index 000000000000..be6c61541a8f
>>>>> --- /dev/null
>>>>> +++ b/drivers/scsi/ufs/ufs-exynos-hw.c
>>>>> @@ -0,0 +1,131 @@
>>> .
>>> .
>>> <snip>
>>> .
>>> .
>>>>> +
>>>>> +#define PWR_MODE_STR_LEN    64
>>>>> +static int exynos_ufs_post_pwr_mode(struct ufs_hba *hba,
>>>>> +                struct ufs_pa_layer_attr *pwr_max,
>>>>> +                struct ufs_pa_layer_attr *pwr_req)
>>>>> +{
>>>>> +    struct exynos_ufs *ufs = to_exynos_ufs(hba);
>>>>> +    struct exynos_ufs_phy_info *phy_info = phy_get_drvdata(ufs->phy);
>>>
>>> This is abusing the interface. phy_get_drvdata is meant to be used only
>>> by the PHY driver.
>>>>> +    struct exynos_ufs_phy_specific_ops *phy_ops =
>>>>> +                    phy_info->phy_specific_ops;
>>>
>>> I'm really not happy about having platform specific ops for PHY. We have
>>> to see if existing PHY ops can be used for this or in worst case add new
>>> PHY ops.
>> Well you said you like the controller driver to use only PHY ops[1], I
>> am sorry If I misunderstood that point, can you please help me to
>> understand that?
>
> I meant PHY generic ops and not PHY ops.
Ok, got it, will use only generic phy here in controller driver.
- Will remove the platform specific PHY ops from phy driver introduce in 
this series (patch 02/11)
>> [1]-> https://lkml.org/lkml/2015/9/18/29
>>
>>>>> +    struct uic_pwr_mode *pwr = &ufs->pwr_act;
>>>>> +    char pwr_str[PWR_MODE_STR_LEN] = "";
>>>>> +    int ret = 0;
>>>>> +
>>>>> +    if (ufs->drv_data->post_pwr_change)
>>>>> +        ufs->drv_data->post_pwr_change(ufs, pwr);
>>>>> +
>>>>> +    if (IS_UFS_PWR_MODE_HS(pwr->mode)) {
>>>>> +        switch (pwr->hs_series) {
>>>>> +        case PA_HS_MODE_A:
>>>>> +        case PA_HS_MODE_B:
>>>>> +            phy_ops->calibrate_phy(ufs->phy, CFG_POST_PWR_HS,
>>>>> +                PWR_MODE_HS(pwr->gear, pwr->hs_series));
>>>>> +            break;
>>>>> +        }
>>>>> +
>>>>> +        ret = phy_ops->wait_for_lock_acq(ufs->phy);
>>>>> +        snprintf(pwr_str, sizeof(pwr_str), "Fast%s series_%s G_%d L_%d",
>>>>> +            pwr->mode == FASTAUTO_MODE ? "_Auto" : "",
>>>>> +            pwr->hs_series == PA_HS_MODE_A ? "A" : "B",
>>>>> +            pwr->gear, pwr->lane);
>>>>> +    } else if (IS_UFS_PWR_MODE_PWM(pwr->mode)) {
>>>>> +        snprintf(pwr_str, sizeof(pwr_str), "Slow%s G_%d L_%d",
>>>>> +            pwr->mode == SLOWAUTO_MODE ? "_Auto" : "",
>>>>> +            pwr->gear, pwr->lane);
>>>>> +    }
>>>>> +
>>>>> +    dev_info(hba->dev, "Power mode change %d : %s\n", ret, pwr_str);
>>>>> +    return ret;
>>>>> +}
>>>>> +
>>>>> +static void exynos_ufs_specify_nexus_t_xfer_req(struct ufs_hba *hba,
>>>>> +                        int tag, struct scsi_cmnd *cmd)
>>>>> +{
>>>>> +    struct exynos_ufs *ufs = to_exynos_ufs(hba);
>>>>> +    u32 type;
>>>>> +
>>>>> +    type =  hci_readl(ufs, HCI_UTRL_NEXUS_TYPE);
>>>>> +
>>>>> +    if (cmd)
>>>>> +        hci_writel(ufs, type | (1 << tag), HCI_UTRL_NEXUS_TYPE);
>>>>> +    else
>>>>> +        hci_writel(ufs, type & ~(1 << tag), HCI_UTRL_NEXUS_TYPE);
>>>>> +}
>>>>> +
>>>>> +static void exynos_ufs_specify_nexus_t_tm_req(struct ufs_hba *hba,
>>>>> +                        int tag, u8 func)
>>>>> +{
>>>>> +    struct exynos_ufs *ufs = to_exynos_ufs(hba);
>>>>> +    u32 type;
>>>>> +
>>>>> +    type =  hci_readl(ufs, HCI_UTMRL_NEXUS_TYPE);
>>>>> +
>>>>> +    switch (func) {
>>>>> +    case UFS_ABORT_TASK:
>>>>> +    case UFS_QUERY_TASK:
>>>>> +        hci_writel(ufs, type | (1 << tag), HCI_UTMRL_NEXUS_TYPE);
>>>>> +        break;
>>>>> +    case UFS_ABORT_TASK_SET:
>>>>> +    case UFS_CLEAR_TASK_SET:
>>>>> +    case UFS_LOGICAL_RESET:
>>>>> +    case UFS_QUERY_TASK_SET:
>>>>> +        hci_writel(ufs, type & ~(1 << tag), HCI_UTMRL_NEXUS_TYPE);
>>>>> +        break;
>>>>> +    }
>>>>> +}
>>>>> +
>>>>> +static void exynos_ufs_phy_init(struct exynos_ufs *ufs)
>>>>> +{
>>>>> +    struct ufs_hba *hba = ufs->hba;
>>>>> +    struct exynos_ufs_phy_info *phy_info = phy_get_drvdata(ufs->phy);
>>>>> +    struct exynos_ufs_phy_specific_ops *phy_ops =
>>>>> +                    phy_info->phy_specific_ops;
>>>>> +
>>>>> +    if (ufs->avail_ln_rx == 0 || ufs->avail_ln_tx == 0) {
>>>>> +        ufshcd_dme_get(hba, UIC_ARG_MIB(PA_AVAILRXDATALANES),
>>>>> +            &ufs->avail_ln_rx);
>>>>> +        ufshcd_dme_get(hba, UIC_ARG_MIB(PA_AVAILTXDATALANES),
>>>>> +            &ufs->avail_ln_tx);
>>>>> +        WARN(ufs->avail_ln_rx != ufs->avail_ln_tx,
>>>>> +            "available data lane is not equal(rx:%d, tx:%d)\n",
>>>>> +            ufs->avail_ln_rx, ufs->avail_ln_tx);
>>>>> +    }
>>>>> +
>>>>> +    phy_ops->set_lane_cnt(ufs->phy, ufs->avail_ln_rx);
>>>
>>> can't bus_width attribute in phy core be reused for this?
>>>
>> I will take a look on it.
>>
>>>>> +    phy_ops->calibrate_phy(ufs->phy, CFG_PRE_INIT, PWR_MODE_ANY);
>>>
>>> Why can't calibrate PHY be directly done in phy_init?
>>>
>> This is just one instance, need to calibrate PHY when the ufs pwr mode changes.
>
> Then maybe we should check when the power mode changes and see if it
> makes sense to calibrate PHY in other generic PHY ops like phy_power_on
> etc..
>
I did explore this but looks like in current situation it is not the 
best option.
Will post next revision after I am done with modifications, PTAL.

> Thanks
> Kishon
>
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
