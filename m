Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE758C433DB
	for <linux-scsi@archiver.kernel.org>; Mon, 15 Mar 2021 09:32:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 940A064E6B
	for <linux-scsi@archiver.kernel.org>; Mon, 15 Mar 2021 09:32:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229553AbhCOJbq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 15 Mar 2021 05:31:46 -0400
Received: from m42-2.mailgun.net ([69.72.42.2]:26344 "EHLO m42-2.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229684AbhCOJba (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 15 Mar 2021 05:31:30 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1615800690; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=zrHHjVyRUaxOp7+pztnXqhCMulxmhKFQRdxif8qsoV0=;
 b=huDBEKNWA8oL/vGKAeIdr1X3Ci4iBYenj/jJmL5OwBmtnHcDvIpO9dwGln+eBg1Gg9UQB+HJ
 ry1mKec1F3Eee7k7MEZrlqKwEoCyHT4emEnP2amn6qCSqR/H4vun7Hb8kAbJUZdIrgNZJW37
 9j+q+fh5l3KvT0DfbsZiL1jy7EY=
X-Mailgun-Sending-Ip: 69.72.42.2
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n06.prod.us-east-1.postgun.com with SMTP id
 604f29606dc1045b7de10448 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 15 Mar 2021 09:31:12
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id A249DC433ED; Mon, 15 Mar 2021 09:31:11 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 31CFEC433ED;
        Mon, 15 Mar 2021 09:31:10 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 15 Mar 2021 17:31:10 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Avri Altman <Avri.Altman@wdc.com>
Cc:     "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, Bart Van Assche <bvanassche@acm.org>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Daejun Park <daejun7.park@samsung.com>,
        alim.akhtar@samsung.com, asutoshd@codeaurora.org,
        Zang Leigang <zangleigang@hisilicon.com>,
        Avi Shchislowski <Avi.Shchislowski@wdc.com>,
        Bean Huo <beanhuo@micron.com>, stanley.chu@mediatek.com
Subject: Re: [PATCH v5 03/10] scsi: ufshpb: Add region's reads counter
In-Reply-To: <DM6PR04MB6575A58446F1EB9ABDFBB7A6FC6C9@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20210302132503.224670-1-avri.altman@wdc.com>
 <20210302132503.224670-4-avri.altman@wdc.com>
 <343d6b0d7802b58bec6e3c06e6f9be57@codeaurora.org>
 <DM6PR04MB6575A58446F1EB9ABDFBB7A6FC6C9@DM6PR04MB6575.namprd04.prod.outlook.com>
Message-ID: <aa82d7011c102b5d0991cad8908ac9ee@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021-03-15 17:20, Avri Altman wrote:
>> > +
>> > +             if (hpb->is_hcm) {
>> > +                     spin_lock_irqsave(&rgn->rgn_lock, flags);
>> 
>> rgn_lock is never used in IRQ contexts, so no need of irqsave and
>> irqrestore everywhere, which can impact performance. Please correct
>> me if I am wrong.
> Thanks.  Will do.
> 
>> 
>> Meanwhile, have you ever initialized the rgn_lock before use it???
> Yep - forgot to do that here (but not in gs20 and mi10).  Thanks.

You mean you didn't test this specific series before upload?
I haven't moved to the test stage, but this will definitely
cause you error...

Can Guo.

> 
> Thanks,
> Avri
> 
>> 
>> Thanks,
>> Can Guo.
>> 
>> > +                     rgn->reads = 0;
>> > +                     spin_unlock_irqrestore(&rgn->rgn_lock, flags);
>> > +             }
>> > +
>> >               return 0;
>> >       }
>> >
>> >       if (!ufshpb_is_support_chunk(hpb, transfer_len))
>> >               return 0;
>> >
>> > +     if (hpb->is_hcm) {
>> > +             bool activate = false;
>> > +             /*
>> > +              * in host control mode, reads are the main source for
>> > +              * activation trials.
>> > +              */
>> > +             spin_lock_irqsave(&rgn->rgn_lock, flags);
>> > +             rgn->reads++;
>> > +             if (rgn->reads == ACTIVATION_THRESHOLD)
>> > +                     activate = true;
>> > +             spin_unlock_irqrestore(&rgn->rgn_lock, flags);
>> > +             if (activate) {
>> > +                     spin_lock_irqsave(&hpb->rsp_list_lock, flags);
>> > +                     ufshpb_update_active_info(hpb, rgn_idx, srgn_idx);
>> > +                     hpb->stats.rb_active_cnt++;
>> > +                     spin_unlock_irqrestore(&hpb->rsp_list_lock, flags);
>> > +                     dev_dbg(&hpb->sdev_ufs_lu->sdev_dev,
>> > +                             "activate region %d-%d\n", rgn_idx, srgn_idx);
>> > +             }
>> > +
>> > +             /* keep those counters normalized */
>> > +             if (rgn->reads > hpb->entries_per_srgn)
>> > +                     schedule_work(&hpb->ufshpb_normalization_work);
>> > +     }
>> > +
>> >       spin_lock_irqsave(&hpb->rgn_state_lock, flags);
>> >       if (ufshpb_test_ppn_dirty(hpb, rgn_idx, srgn_idx, srgn_offset,
>> >                                  transfer_len)) {
>> > @@ -745,21 +794,6 @@ static int ufshpb_clear_dirty_bitmap(struct
>> > ufshpb_lu *hpb,
>> >       return 0;
>> >  }
>> >
>> > -static void ufshpb_update_active_info(struct ufshpb_lu *hpb, int
>> > rgn_idx,
>> > -                                   int srgn_idx)
>> > -{
>> > -     struct ufshpb_region *rgn;
>> > -     struct ufshpb_subregion *srgn;
>> > -
>> > -     rgn = hpb->rgn_tbl + rgn_idx;
>> > -     srgn = rgn->srgn_tbl + srgn_idx;
>> > -
>> > -     list_del_init(&rgn->list_inact_rgn);
>> > -
>> > -     if (list_empty(&srgn->list_act_srgn))
>> > -             list_add_tail(&srgn->list_act_srgn, &hpb->lh_act_srgn);
>> > -}
>> > -
>> >  static void ufshpb_update_inactive_info(struct ufshpb_lu *hpb, int
>> > rgn_idx)
>> >  {
>> >       struct ufshpb_region *rgn;
>> > @@ -1079,6 +1113,14 @@ static void __ufshpb_evict_region(struct
>> > ufshpb_lu *hpb,
>> >
>> >       ufshpb_cleanup_lru_info(lru_info, rgn);
>> >
>> > +     if (hpb->is_hcm) {
>> > +             unsigned long flags;
>> > +
>> > +             spin_lock_irqsave(&rgn->rgn_lock, flags);
>> > +             rgn->reads = 0;
>> > +             spin_unlock_irqrestore(&rgn->rgn_lock, flags);
>> > +     }
>> > +
>> >       for_each_sub_region(rgn, srgn_idx, srgn)
>> >               ufshpb_purge_active_subregion(hpb, srgn);
>> >  }
>> > @@ -1523,6 +1565,31 @@ static void
>> > ufshpb_run_inactive_region_list(struct ufshpb_lu *hpb)
>> >       spin_unlock_irqrestore(&hpb->rsp_list_lock, flags);
>> >  }
>> >
>> > +static void ufshpb_normalization_work_handler(struct work_struct
>> > *work)
>> > +{
>> > +     struct ufshpb_lu *hpb;
>> > +     int rgn_idx;
>> > +     unsigned long flags;
>> > +
>> > +     hpb = container_of(work, struct ufshpb_lu,
>> > ufshpb_normalization_work);
>> > +
>> > +     for (rgn_idx = 0; rgn_idx < hpb->rgns_per_lu; rgn_idx++) {
>> > +             struct ufshpb_region *rgn = hpb->rgn_tbl + rgn_idx;
>> > +
>> > +             spin_lock_irqsave(&rgn->rgn_lock, flags);
>> > +             rgn->reads = (rgn->reads >> 1);
>> > +             spin_unlock_irqrestore(&rgn->rgn_lock, flags);
>> > +
>> > +             if (rgn->rgn_state != HPB_RGN_ACTIVE || rgn->reads)
>> > +                     continue;
>> > +
>> > +             /* if region is active but has no reads - inactivate it */
>> > +             spin_lock(&hpb->rsp_list_lock);
>> > +             ufshpb_update_inactive_info(hpb, rgn->rgn_idx);
>> > +             spin_unlock(&hpb->rsp_list_lock);
>> > +     }
>> > +}
>> > +
>> >  static void ufshpb_map_work_handler(struct work_struct *work)
>> >  {
>> >       struct ufshpb_lu *hpb = container_of(work, struct ufshpb_lu,
>> > map_work);
>> > @@ -1913,6 +1980,9 @@ static int ufshpb_lu_hpb_init(struct ufs_hba
>> > *hba, struct ufshpb_lu *hpb)
>> >       INIT_LIST_HEAD(&hpb->list_hpb_lu);
>> >
>> >       INIT_WORK(&hpb->map_work, ufshpb_map_work_handler);
>> > +     if (hpb->is_hcm)
>> > +             INIT_WORK(&hpb->ufshpb_normalization_work,
>> > +                       ufshpb_normalization_work_handler);
>> >
>> >       hpb->map_req_cache = kmem_cache_create("ufshpb_req_cache",
>> >                         sizeof(struct ufshpb_req), 0, 0, NULL);
>> > @@ -2012,6 +2082,8 @@ static void ufshpb_discard_rsp_lists(struct
>> > ufshpb_lu *hpb)
>> >
>> >  static void ufshpb_cancel_jobs(struct ufshpb_lu *hpb)
>> >  {
>> > +     if (hpb->is_hcm)
>> > +             cancel_work_sync(&hpb->ufshpb_normalization_work);
>> >       cancel_work_sync(&hpb->map_work);
>> >  }
>> >
>> > diff --git a/drivers/scsi/ufs/ufshpb.h b/drivers/scsi/ufs/ufshpb.h
>> > index 8119b1a3d1e5..bd4308010466 100644
>> > --- a/drivers/scsi/ufs/ufshpb.h
>> > +++ b/drivers/scsi/ufs/ufshpb.h
>> > @@ -121,6 +121,10 @@ struct ufshpb_region {
>> >       struct list_head list_lru_rgn;
>> >       unsigned long rgn_flags;
>> >  #define RGN_FLAG_DIRTY 0
>> > +
>> > +     /* region reads - for host mode */
>> > +     spinlock_t rgn_lock;
>> > +     unsigned int reads;
>> >  };
>> >
>> >  #define for_each_sub_region(rgn, i, srgn)                            \
>> > @@ -211,6 +215,7 @@ struct ufshpb_lu {
>> >
>> >       /* for selecting victim */
>> >       struct victim_select_info lru_info;
>> > +     struct work_struct ufshpb_normalization_work;
>> >
>> >       /* pinned region information */
>> >       u32 lu_pinned_start;
