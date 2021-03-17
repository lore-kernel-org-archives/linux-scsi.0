Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BD99C433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 02:48:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0896F64F97
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 02:48:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229660AbhCQCsJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 16 Mar 2021 22:48:09 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:33201 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229526AbhCQCsF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Mar 2021 22:48:05 -0400
Received: from epcas3p1.samsung.com (unknown [182.195.41.19])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20210317024803epoutp01ef90d54072cdfbe27dff553c87d83ee6~tAU-RDeD50301703017epoutp01R
        for <linux-scsi@vger.kernel.org>; Wed, 17 Mar 2021 02:48:03 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20210317024803epoutp01ef90d54072cdfbe27dff553c87d83ee6~tAU-RDeD50301703017epoutp01R
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1615949283;
        bh=bfExUxnKegOWp6W/y7hdz5ArFPx8jVEPrZCmuu0WVDs=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=Pa6p8HHJo4m2RMUKtg5pUnpNEYAv1aYOVAV5iwyWYEEQC4+gBJbZWEmCJtU2pbzzk
         m2Ek9ahLq2rFs1Bcj7BH13oRTB1m5Ct5rLMZbph+siQZijW1kCMW34ti5iWUCrV5b2
         Q5+jRVC16XLcjzsnWuviWMtypLmNtyWHymrmAXPA=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas3p4.samsung.com (KnoxPortal) with ESMTP id
        20210317024803epcas3p4e31b63ad570b303cc4296439e8617aa1~tAU_t3xJ_0166101661epcas3p4A;
        Wed, 17 Mar 2021 02:48:03 +0000 (GMT)
Received: from epcpadp4 (unknown [182.195.40.18]) by epsnrtp4.localdomain
        (Postfix) with ESMTP id 4F0ZMk71GVz4x9QH; Wed, 17 Mar 2021 02:48:02 +0000
        (GMT)
Mime-Version: 1.0
Subject: RE: RE: [PATCH v5 05/10] scsi: ufshpb: Region inactivation in host
 mode
Reply-To: daejun7.park@samsung.com
Sender: Daejun Park <daejun7.park@samsung.com>
From:   Daejun Park <daejun7.park@samsung.com>
To:     Avri Altman <Avri.Altman@wdc.com>, Can Guo <cang@codeaurora.org>
CC:     "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Bart Van Assche <bvanassche@acm.org>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Daejun Park <daejun7.park@samsung.com>,
        ALIM AKHTAR <alim.akhtar@samsung.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        Zang Leigang <zangleigang@hisilicon.com>,
        Avi Shchislowski <Avi.Shchislowski@wdc.com>,
        Bean Huo <beanhuo@micron.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <DM6PR04MB65751EE32D25C7E57A6BABE8FC6B9@DM6PR04MB6575.namprd04.prod.outlook.com>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <2038148563.21615949282962.JavaMail.epsvc@epcpadp4>
Date:   Wed, 17 Mar 2021 11:28:48 +0900
X-CMS-MailID: 20210317022848epcms2p3e17fe87903f54d520bef8c4a815afa59
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20210316083014epcas2p32d6b84e689cdbe06ee065c870b236d65
References: <DM6PR04MB65751EE32D25C7E57A6BABE8FC6B9@DM6PR04MB6575.namprd04.prod.outlook.com>
        <20210302132503.224670-1-avri.altman@wdc.com>
        <20210302132503.224670-6-avri.altman@wdc.com>
        <25da7378d5bf4c52443ae9b47f3fd778@codeaurora.org>
        <57afb2b5d7edda61a40493d8545785b1@codeaurora.org>
        <CGME20210316083014epcas2p32d6b84e689cdbe06ee065c870b236d65@epcms2p3>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>> >> ---
>> >>  drivers/scsi/ufs/ufshpb.c | 14 ++++++++++++++
>> >>  drivers/scsi/ufs/ufshpb.h |  1 +
>> >>  2 files changed, 15 insertions(+)
>> >>
>> >> diff --git a/drivers/scsi/ufs/ufshpb.c b/drivers/scsi/ufs/ufshpb.c
>> >> index 6f4fd22eaf2f..0744feb4d484 100644
>> >> --- a/drivers/scsi/ufs/ufshpb.c
>> >> +++ b/drivers/scsi/ufs/ufshpb.c
>> >> @@ -907,6 +907,7 @@ static int ufshpb_execute_umap_req(struct
>> >> ufshpb_lu *hpb,
>> >>
>> >>      blk_execute_rq_nowait(q, NULL, req, 1, ufshpb_umap_req_compl_fn);
>> >>
>> >> +    hpb->stats.umap_req_cnt++;
>> >>      return 0;
>> >>  }
>> >>
>> >> @@ -1103,6 +1104,12 @@ static int ufshpb_issue_umap_req(struct
>> >> ufshpb_lu *hpb,
>> >>      return -EAGAIN;
>> >>  }
>> >>
>> >> +static int ufshpb_issue_umap_single_req(struct ufshpb_lu *hpb,
>> >> +                                    struct ufshpb_region *rgn)
>> >> +{
>> >> +    return ufshpb_issue_umap_req(hpb, rgn);
>> >> +}
>> >> +
>> >>  static int ufshpb_issue_umap_all_req(struct ufshpb_lu *hpb)
>> >>  {
>> >>      return ufshpb_issue_umap_req(hpb, NULL);
>> >> @@ -1115,6 +1122,10 @@ static void __ufshpb_evict_region(struct
>> >> ufshpb_lu *hpb,
>> >>      struct ufshpb_subregion *srgn;
>> >>      int srgn_idx;
>> >>
>> >> +
>> >> +    if (hpb->is_hcm && ufshpb_issue_umap_single_req(hpb, rgn))
>> >
>> > __ufshpb_evict_region() is called with rgn_state_lock held and IRQ
>> > disabled,
>> > when ufshpb_issue_umap_single_req() invokes blk_execute_rq_nowait(),
>> > below
>> > warning shall pop up every time, fix it?
>> >
>> > void blk_execute_rq_nowait(struct request_queue *q, struct gendisk
>> > *bd_disk,
>> >                  struct request *rq, int at_head,
>> >                          rq_end_io_fn *done)
>> > {
>> >       WARN_ON(irqs_disabled());
>> > ...
>> >
>> 
>> Moreover, since we are here with rgn_state_lock held and IRQ disabled,
>> in ufshpb_get_req(), rq = kmem_cache_alloc(hpb->map_req_cache,
>> GFP_KERNEL)
>> has the GFP_KERNEL flag, scheduling while atomic???
>I think your comment applies to  ufshpb_issue_umap_all_req as well,
>Which is called from slave_configure/scsi_add_lun.
> 
>Since the host-mode series is utilizing the framework laid by the device-mode,
>Maybe you can add this comment to  Daejun's last version?

Hi Avri, Can Guo

I think ufshpb_issue_umap_single_req() can be moved to end of ufshpb_evict_region().
Then we can avoid rgn_state_lock when it sends unmap command.

Thanks,
Daejun


>Thanks,
>Avri
> 
>> 
>> Can Guo.
>> 
>> > Thanks.
>> > Can Guo.
>> >
>> >> +            return;
>> >> +
>> >>      lru_info = &hpb->lru_info;
>> >>
>> >>      dev_dbg(&hpb->sdev_ufs_lu->sdev_dev, "evict region %d\n",
>> >> rgn->rgn_idx);
>> >> @@ -1855,6 +1866,7 @@ ufshpb_sysfs_attr_show_func(rb_noti_cnt);
>> >>  ufshpb_sysfs_attr_show_func(rb_active_cnt);
>> >>  ufshpb_sysfs_attr_show_func(rb_inactive_cnt);
>> >>  ufshpb_sysfs_attr_show_func(map_req_cnt);
>> >> +ufshpb_sysfs_attr_show_func(umap_req_cnt);
>> >>
>> >>  static struct attribute *hpb_dev_stat_attrs[] = {
>> >>      &dev_attr_hit_cnt.attr,
>> >> @@ -1863,6 +1875,7 @@ static struct attribute *hpb_dev_stat_attrs[] =
>> >> {
>> >>      &dev_attr_rb_active_cnt.attr,
>> >>      &dev_attr_rb_inactive_cnt.attr,
>> >>      &dev_attr_map_req_cnt.attr,
>> >> +    &dev_attr_umap_req_cnt.attr,
>> >>      NULL,
>> >>  };
>> >>
>> >> @@ -1978,6 +1991,7 @@ static void ufshpb_stat_init(struct ufshpb_lu
>> >> *hpb)
>> >>      hpb->stats.rb_active_cnt = 0;
>> >>      hpb->stats.rb_inactive_cnt = 0;
>> >>      hpb->stats.map_req_cnt = 0;
>> >> +    hpb->stats.umap_req_cnt = 0;
>> >>  }
>> >>
>> >>  static void ufshpb_param_init(struct ufshpb_lu *hpb)
>> >> diff --git a/drivers/scsi/ufs/ufshpb.h b/drivers/scsi/ufs/ufshpb.h
>> >> index bd4308010466..84598a317897 100644
>> >> --- a/drivers/scsi/ufs/ufshpb.h
>> >> +++ b/drivers/scsi/ufs/ufshpb.h
>> >> @@ -186,6 +186,7 @@ struct ufshpb_stats {
>> >>      u64 rb_inactive_cnt;
>> >>      u64 map_req_cnt;
>> >>      u64 pre_req_cnt;
>> >> +    u64 umap_req_cnt;
>> >>  };
>> >>
>> >>  struct ufshpb_lu {
> 
> 
>  
