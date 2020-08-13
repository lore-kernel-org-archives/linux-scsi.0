Return-Path: <SRS0=CV/f=BX=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 750F0C433DF
	for <linux-scsi@archiver.kernel.org>; Thu, 13 Aug 2020 03:03:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2B3D120768
	for <linux-scsi@archiver.kernel.org>; Thu, 13 Aug 2020 03:03:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="W6pi6V6A"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726587AbgHMDDI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 12 Aug 2020 23:03:08 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:43573 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726531AbgHMDDG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Aug 2020 23:03:06 -0400
Received: from epcas1p4.samsung.com (unknown [182.195.41.48])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20200813030302epoutp04f617423973f7f46e0aec9b814639a24d~qtMZ_YVvw2491924919epoutp04U
        for <linux-scsi@vger.kernel.org>; Thu, 13 Aug 2020 03:03:02 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20200813030302epoutp04f617423973f7f46e0aec9b814639a24d~qtMZ_YVvw2491924919epoutp04U
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1597287782;
        bh=7f7Wx77ro3njF4wJp6XljVnikOWida+WRuDzYhPy9KM=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=W6pi6V6A29IkIpta2XyJjgNw5peSjhLia7e2ok4wrwbjQ0yS4xxQBLhkMmV56ubqQ
         DpqTSujOjUKHeQW+WdKMLDE5nFFXiBqLC6HrmSecJYwjiHicQ9LbIA/RmRt5orkNV+
         f559dP5idSnT0MIM0ogSRR7keqDEpYXZGjbIwsHM=
Received: from epcpadp2 (unknown [182.195.40.12]) by epcas1p2.samsung.com
        (KnoxPortal) with ESMTP id
        20200813030301epcas1p279939599c673383d20d74c67e911bcdf~qtMZg_4bO1439714397epcas1p2A;
        Thu, 13 Aug 2020 03:03:01 +0000 (GMT)
Mime-Version: 1.0
Subject: Re: [PATCH v8 2/4] scsi: ufs: Introduce HPB feature
Reply-To: daejun7.park@samsung.com
From:   Daejun Park <daejun7.park@samsung.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        Daejun Park <daejun7.park@samsung.com>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "tomas.winkler@intel.com" <tomas.winkler@intel.com>,
        ALIM AKHTAR <alim.akhtar@samsung.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sang-yoon Oh <sangyoon.oh@samsung.com>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        Adel Choi <adel.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <2154d9c6-4b29-7d24-0261-26d2aa05caef@acm.org>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <231786897.01597287781957.JavaMail.epsvc@epcpadp2>
Date:   Thu, 13 Aug 2020 12:00:31 +0900
X-CMS-MailID: 20200813030031epcms2p35237d7a91be23392745b773006db48aa
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20200806073257epcms2p61564ed62e02fc42fc3c2b18fa92a038d
References: <2154d9c6-4b29-7d24-0261-26d2aa05caef@acm.org>
        <231786897.01596705001840.JavaMail.epsvc@epcpadp1>
        <231786897.01596704281715.JavaMail.epsvc@epcpadp2>
        <231786897.01596705302142.JavaMail.epsvc@epcpadp1>
        <CGME20200806073257epcms2p61564ed62e02fc42fc3c2b18fa92a038d@epcms2p3>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Bart,

On 2020-08-06 02:11, Daejun Park wrote:
> > This is a patch for the HPB feature.
> > This patch adds HPB function calls to UFS core driver.
> > 
> > The mininum size of the memory pool used in the HPB is implemented as a
>       ^^^^^^^
>       minimum?

I will fix it.

> > Kconfig parameter (SCSI_UFS_HPB_HOST_MEM), so that it can be configurable.
> 
> > +config SCSI_UFS_HPB
> > +    bool "Support UFS Host Performance Booster"
> > +    depends on SCSI_UFSHCD
> > +    help
> > +      A UFS HPB Feature improves random read performance. It caches
>           ^         ^^^^^^^
>           The?      feature?

I will fix it.

> > +      L2P map of UFS to host DRAM. The driver uses HPB read command
> > +      by piggybacking physical page number for bypassing FTL's L2P address
> > +      translation.
> 
> Please explain what L2P and FTL mean. Not everyone is familiar with SSD
> internals.

I added full name of the abbreviation.


L2P (logical to physical) map of UFS to host DRAM. The driver uses HPB read command
     ^^^^^^^^^^^^^^^^^^^
by piggybacking physical page number for bypassing FTL (flash translation layer)
                                                        ^^^^^^^^^^^^^^^^^^^^^^^^

> > +config SCSI_UFS_HPB_HOST_MEM
> > +    int "Host-side cached memory size (KB) for HPB support"
> > +    default 32
> > +    depends on SCSI_UFS_HPB
> > +    help
> > +      The mininum size of the memory pool used in the HPB module. It can
> > +      be configurable by the user. If this value is larger than required
> > +      memory size, kernel resizes cached memory size.
>                               ^^^^^^^ ^^^^^^^^^^^^^^^^^^
>                              reduces?    cache size?
> 
> Please make this a kernel module parameter instead of a compile-time constant.

OK, I will change it.
 
> > +#ifndef CONFIG_SCSI_UFS_HPB
> > +static void ufshpb_resume(struct ufs_hba *hba) {}
> > +static void ufshpb_suspend(struct ufs_hba *hba) {}
> > +static void ufshpb_reset(struct ufs_hba *hba) {}
> > +static void ufshpb_reset_host(struct ufs_hba *hba) {}
> > +static void ufshpb_rsp_upiu(struct ufs_hba *hba, struct ufshcd_lrb *lrbp) {}
> > +static void ufshpb_prep(struct ufs_hba *hba, struct ufshcd_lrb *lrbp) {}
> > +static void ufshpb_remove(struct ufs_hba *hba) {}
> > +static void ufshpb_scan_feature(struct ufs_hba *hba) {}
> > +#endif
> 
> Please move these definitions into ufshpb.h since that is the
> recommended Linux kernel coding style.

OK, I will move them.

> > diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
> > index b2ef18f1b746..904c19796e09 100644
> > --- a/drivers/scsi/ufs/ufshcd.h
> > +++ b/drivers/scsi/ufs/ufshcd.h
> > @@ -47,6 +47,9 @@
> >  #include "ufs.h"
> >  #include "ufs_quirks.h"
> >  #include "ufshci.h"
> > +#ifdef CONFIG_SCSI_UFS_HPB
> > +#include "ufshpb.h"
> > +#endif
> 
> Please move #ifdef CONFIG_SCSI_UFS_HPB / #endif into ufshpb.h. From
> Documentation/process/4.Coding.rst: "As a general rule, #ifdef use
> should be confined to header files whenever possible."

OK, I will fix it.

> > +struct ufsf_feature_info {
> > +    atomic_t slave_conf_cnt;
> > +    wait_queue_head_t sdev_wait;
> > +};
> 
> Please add a comment above this data structure that explains the role
> of this data structure and also what "ufsf" stands for.

"ufsf" is stands for ufs feature. I wiil add comments for the data structure.

> > +static int ufshpb_create_sysfs(struct ufs_hba *hba, struct ufshpb_lu *hpb);
> 
> I don't think that this forward declaration is necessary so please leave it
> out.

OK, I will remove it.

> > +static inline int ufshpb_is_valid_srgn(struct ufshpb_region *rgn,
> > +                 struct ufshpb_subregion *srgn)
> > +{
> > +    return rgn->rgn_state != HPB_RGN_INACTIVE &&
> > +        srgn->srgn_state == HPB_SRGN_VALID;
> > +}
> 
> Please do not declare functions inside .c files inline but instead let
> the compiler decide which functions to inline. Modern compilers are really
> good at this.

I didn't know about it. Thanks.

> > +static struct kobj_type ufshpb_ktype = {
> > +    .sysfs_ops = &ufshpb_sysfs_ops,
> > +    .release = NULL,
> > +};
> 
> If the release method of a kobj_type is NULL that is a strong sign that
> there is something wrong ...
> 
> > +static int ufshpb_create_sysfs(struct ufs_hba *hba, struct ufshpb_lu *hpb)
> > +{
> > +    int ret;
> > +
> > +    ufshpb_stat_init(hpb);
> > +
> > +    kobject_init(&hpb->kobj, &ufshpb_ktype);
> > +    mutex_init(&hpb->sysfs_lock);
> > +
> > +    ret = kobject_add(&hpb->kobj, kobject_get(&hba->dev->kobj),
> > +              "ufshpb_lu%d", hpb->lun);
> > +
> > +    if (ret)
> > +        return ret;
> > +
> > +    ret = sysfs_create_group(&hpb->kobj, &ufshpb_sysfs_group);
> > +
> > +    if (ret) {
> > +        dev_err(hba->dev, "ufshpb_lu%d create file error\n", hpb->lun);
> > +        return ret;
> > +    }
> > +
> > +    dev_info(hba->dev, "ufshpb_lu%d sysfs adds uevent", hpb->lun);
> > +    kobject_uevent(&hpb->kobj, KOBJ_ADD);
> > +
> > +    return 0;
> > +}
> 
> Please attach these sysfs attributes to /sys/class/scsi_device/*/device
> instead of creating a new kobject. Consider using the following
> scsi_host_template member to define LUN sysfs attributes:

I am not rejecting your comment. But I added kobject for distinguishing 
between other attributes and attributes related to HPB feature.
If you think it's pointless, I'll fix it.

>     /*
>      * Pointer to the SCSI device attribute groups for this host,
>      * NULL terminated.
>      */
>     const struct attribute_group **sdev_groups;
> 
> > +static void ufshpb_scan_hpb_lu(struct ufs_hba *hba,
> > +                   struct ufshpb_dev_info *hpb_dev_info,
> > +                   u8 *desc_buf)
> > +{
> > +    struct scsi_device *sdev;
> > +    struct ufshpb_lu *hpb;
> > +    int find_hpb_lu = 0;
> > +    int ret;
> > +
> > +    shost_for_each_device(sdev, hba->host) {
> > +        struct ufshpb_lu_info hpb_lu_info = { 0 };
> > +        int lun = sdev->lun;
> > +
> > +        if (lun >= hba->dev_info.max_lu_supported)
> > +            continue;
> > +
> > +        ret = ufshpb_get_lu_info(hba, lun, &hpb_lu_info, desc_buf);
> > +        if (ret)
> > +            continue;
> > +
> > +        hpb = ufshpb_alloc_hpb_lu(hba, lun, hpb_dev_info,
> > +                      &hpb_lu_info);
> > +        if (!hpb)
> > +            continue;
> > +
> > +        hpb->sdev_ufs_lu = sdev;
> > +        sdev->hostdata = hpb;
> > +
> > +        list_add_tail(&hpb->list_hpb_lu, &lh_hpb_lu);
> > +        find_hpb_lu++;
> > +    }
> > +
> > +    if (!find_hpb_lu)
> > +        return;
> > +
> > +    ufshpb_check_hpb_reset_query(hba);
> > +
> > +    list_for_each_entry(hpb, &lh_hpb_lu, list_hpb_lu) {
> > +        dev_info(hba->dev, "set state to present\n");
> > +        ufshpb_set_state(hpb, HPB_PRESENT);
> > +    }
> > +}
> 
> Please remove the loop from the above function, make this function accept a
> SCSI device pointer as argument and call this function from
> ufshcd_slave_configure() or ufshcd_hpb_configure().

I will move the loop to ufshcd_hpb_configure().

> 
> > +static void ufshpb_init(void *data, async_cookie_t cookie)
> > +{
> > +    struct ufsf_feature_info *ufsf = (struct ufsf_feature_info *)data;
> > +    struct ufs_hba *hba;
> > +    struct ufshpb_dev_info hpb_dev_info = { 0 };
> > +    char *desc_buf;
> > +    int ret;
> > +
> > +    hba = container_of(ufsf, struct ufs_hba, ufsf);
> > +
> > +    desc_buf = kzalloc(QUERY_DESC_MAX_SIZE, GFP_KERNEL);
> > +    if (!desc_buf)
> > +        goto release_desc_buf;
> > +
> > +    ret = ufshpb_get_dev_info(hba, &hpb_dev_info, desc_buf);
> > +    if (ret)
> > +        goto release_desc_buf;
> > +
> > +    /*
> > +     * Because HPB driver uses scsi_device data structure,
> > +     * we should wait at this point until finishing initialization of all
> > +     * scsi devices. Even if timeout occurs, HPB driver will search
> > +     * the scsi_device list on struct scsi_host (shost->__host list_head)
> > +     * and can find out HPB logical units in all scsi_devices
> > +     */
> > +    wait_event_timeout(hba->ufsf.sdev_wait,
> > +               (atomic_read(&hba->ufsf.slave_conf_cnt)
> > +                == hpb_dev_info.num_lu),
> > +               SDEV_WAIT_TIMEOUT);
> > +
> > +    ufshpb_issue_hpb_reset_query(hba);
> > +
> > +    dev_dbg(hba->dev, "ufshpb: slave count %d, lu count %d\n",
> > +        atomic_read(&hba->ufsf.slave_conf_cnt), hpb_dev_info.num_lu);
> > +
> > +    ufshpb_scan_hpb_lu(hba, &hpb_dev_info, desc_buf);
> > +
> > +release_desc_buf:
> > +    kfree(desc_buf);
> > +}
> 
> Since the UFS driver calls scsi_scan_host() from ufshcd_add_lus(), do you
> agree that the above wait_event_timeout() call can be eliminated by splitting
> ufshpb_init() into two functions and by calling the part below
> wait_event_timeout() after scsi_scan_host() has finished?

Yes, I agree the above wait_event_timeout() call can be eliminated.
I will change these functions.

> > +void ufshpb_remove(struct ufs_hba *hba)
> > +{
> > +    struct ufshpb_lu *hpb, *n_hpb;
> > +    struct ufsf_feature_info *ufsf;
> > +    struct scsi_device *sdev;
> > +
> > +    ufsf = &hba->ufsf;
> > +
> > +    list_for_each_entry_safe(hpb, n_hpb, &lh_hpb_lu, list_hpb_lu) {
> > +        ufshpb_set_state(hpb, HPB_FAILED);
> > +
> > +        sdev = hpb->sdev_ufs_lu;
> > +        sdev->hostdata = NULL;
> > +
> > +        ufshpb_destroy_region_tbl(hpb);
> > +
> > +        list_del_init(&hpb->list_hpb_lu);
> > +        ufshpb_remove_sysfs(hpb);
> > +
> > +        kfree(hpb);
> > +    }
> > +
> > +    dev_info(hba->dev, "ufshpb: remove success\n");
> > +}
> 
> Should the code in the body of the above loop perhaps be called from inside
> ufshcd_slave_destroy()?

Moving other stuffs in the loop is good idea, but removing attributes is problem.
To avoid adding new kobject, I will try to use sysfs_merge_group() 
for adding attributes. To delete merged attributes, sysfs_unmerge_group() 
should be called. But sysfs_remove_groups() is called before calling ufshcd_slave_destroy().
 
> > +void ufshpb_scan_feature(struct ufs_hba *hba)
> > +{
> > +    init_waitqueue_head(&hba->ufsf.sdev_wait);
> > +    atomic_set(&hba->ufsf.slave_conf_cnt, 0);
> > +
> > +    if (hba->dev_info.wspecversion >= HPB_SUPPORT_VERSION &&
> > +        (hba->dev_info.b_ufs_feature_sup & UFS_DEV_HPB_SUPPORT))
> > +        async_schedule(ufshpb_init, &hba->ufsf);
> > +}
> 
> Why does this function use async_schedule()?

The wait_event_timeout() call will be removed, so it will be changed.

Thanks,

Daejun
