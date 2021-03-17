Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98B86C433E6
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 02:51:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 69FD264F8C
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 02:51:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229559AbhCQCuw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 16 Mar 2021 22:50:52 -0400
Received: from a0.mail.mailgun.net ([198.61.254.59]:15646 "EHLO
        a0.mail.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbhCQCuh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Mar 2021 22:50:37 -0400
X-Greylist: delayed 302 seconds by postgrey-1.27 at vger.kernel.org; Tue, 16 Mar 2021 22:50:37 EDT
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1615949437; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=LLkskVKJ0/VJZ4sWWdNWp0SqtcV6E5vYcTSjxdMUdjI=;
 b=xFNO9U4KCLszN+MzdXDK69366W/M2fXILYLLW33m1Fk0RXAJnHZBFT+N19x1d14SiXwQtPQF
 0j0qQdvcUpfr3Lw0v4D3/VAEKQM0jFh5OwJ8atnhxmT5JHuwAx53aJdX+gT9xQe3BcIjgrux
 PMrK8yaUuuM12oQaKzXGnzMYVJ0=
X-Mailgun-Sending-Ip: 198.61.254.59
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n03.prod.us-east-1.postgun.com with SMTP id
 60516d3c4db3bb68013ae78e (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 17 Mar 2021 02:45:16
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id D0D10C43464; Wed, 17 Mar 2021 02:45:15 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 60511C433C6;
        Wed, 17 Mar 2021 02:45:14 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 17 Mar 2021 10:45:14 +0800
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
Subject: Re: [PATCH v5 07/10] scsi: ufshpb: Add "Cold" regions timer
In-Reply-To: <DM6PR04MB65755EE82C8D19B27E8B576BFC6B9@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20210302132503.224670-1-avri.altman@wdc.com>
 <20210302132503.224670-8-avri.altman@wdc.com>
 <be5c0c390d7c0cf13e67f51cdc7dd8c2@codeaurora.org>
 <DM6PR04MB65755EE82C8D19B27E8B576BFC6B9@DM6PR04MB6575.namprd04.prod.outlook.com>
Message-ID: <5dc7f93e6a1b1328fe8b5bb28a9ea34f@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021-03-16 17:21, Avri Altman wrote:
>> > +static void ufshpb_read_to_handler(struct work_struct *work)
>> > +{
>> > +     struct delayed_work *dwork = to_delayed_work(work);
>> > +     struct ufshpb_lu *hpb;
>> > +     struct victim_select_info *lru_info;
>> > +     struct ufshpb_region *rgn;
>> > +     unsigned long flags;
>> > +     LIST_HEAD(expired_list);
>> > +
>> > +     hpb = container_of(dwork, struct ufshpb_lu, ufshpb_read_to_work);
>> > +
>> > +     spin_lock_irqsave(&hpb->rgn_state_lock, flags);
>> > +
>> > +     lru_info = &hpb->lru_info;
>> > +
>> > +     list_for_each_entry(rgn, &lru_info->lh_lru_rgn, list_lru_rgn) {
>> > +             bool timedout = ktime_after(ktime_get(), rgn->read_timeout);
>> > +
>> > +             if (timedout) {
>> > +                     rgn->read_timeout_expiries--;
>> > +                     if (is_rgn_dirty(rgn) ||
>> > +                         rgn->read_timeout_expiries == 0)
>> > +                             list_add(&rgn->list_expired_rgn, &expired_list);
>> > +                     else
>> > +                             rgn->read_timeout = ktime_add_ms(ktime_get(),
>> > +                                                      READ_TO_MS);
>> > +             }
>> > +     }
>> > +
>> > +     spin_unlock_irqrestore(&hpb->rgn_state_lock, flags);
>> > +
>> > +     list_for_each_entry(rgn, &expired_list, list_expired_rgn) {
>> 
>> Here can be problematic - since you don't have the native expired_list
>> initialized
>> before use, if above loop did not insert anything to expired_list, it
>> shall become
>> a dead loop here.
> Not sure what you meant by native initialization.
> LIST_HEAD is statically initializing an empty list, resulting the same
> outcome as INIT_LIST_HEAD.
> 

Sorry for making you confused, you should use list_for_each_entry_safe()
instead of list_for_each_entry() as you are deleting entries within the 
loop,
otherwise, this can become an infinite loop. Again, have you tested this 
patch
before upload? I am sure this is problematic - when it becomes an 
inifinite
loop, below path will hang...

ufshcd_suspend()->ufshpb_suspend()->cancel_jobs()->cancel_delayed_work()

>> 
>> And, which lock is protecting rgn->list_expired_rgn? If two
>> read_to_handler works
>> are running in parallel, one can be inserting it to its expired_list
>> while another
>> can be deleting it.
> The timeout handler, being a delayed work, is meant to run every 
> polling period.
> Originally, I had it protected from 2 handlers running concurrently,
> But I removed it following Daejun's comment, which I accepted,
> Since it is always scheduled using the same polling period.

But one can set the delay to 0 through sysfs, right?

Thanks,
Can Guo.

> 
> Thanks,
> Avri
> 
>> 
>> Can Guo.
>> 
>> > +             list_del_init(&rgn->list_expired_rgn);
>> > +             spin_lock_irqsave(&hpb->rsp_list_lock, flags);
>> > +             ufshpb_update_inactive_info(hpb, rgn->rgn_idx);
>> > +             hpb->stats.rb_inactive_cnt++;
>> > +             spin_unlock_irqrestore(&hpb->rsp_list_lock, flags);
>> > +     }
>> > +
>> > +     ufshpb_kick_map_work(hpb);
>> > +
>> > +     schedule_delayed_work(&hpb->ufshpb_read_to_work,
>> > +                           msecs_to_jiffies(POLLING_INTERVAL_MS));
>> > +}
>> > +
>> >  static void ufshpb_add_lru_info(struct victim_select_info *lru_info,
>> >                               struct ufshpb_region *rgn)
>> >  {
>> >       rgn->rgn_state = HPB_RGN_ACTIVE;
>> >       list_add_tail(&rgn->list_lru_rgn, &lru_info->lh_lru_rgn);
>> >       atomic_inc(&lru_info->active_cnt);
>> > +     if (rgn->hpb->is_hcm) {
>> > +             rgn->read_timeout = ktime_add_ms(ktime_get(), READ_TO_MS);
>> > +             rgn->read_timeout_expiries = READ_TO_EXPIRIES;
>> > +     }
>> >  }
>> >
>> >  static void ufshpb_hit_lru_info(struct victim_select_info *lru_info,
>> > @@ -1813,6 +1865,7 @@ static int ufshpb_alloc_region_tbl(struct
>> > ufs_hba *hba, struct ufshpb_lu *hpb)
>> >
>> >               INIT_LIST_HEAD(&rgn->list_inact_rgn);
>> >               INIT_LIST_HEAD(&rgn->list_lru_rgn);
>> > +             INIT_LIST_HEAD(&rgn->list_expired_rgn);
>> >
>> >               if (rgn_idx == hpb->rgns_per_lu - 1) {
>> >                       srgn_cnt = ((hpb->srgns_per_lu - 1) %
>> > @@ -1834,6 +1887,7 @@ static int ufshpb_alloc_region_tbl(struct
>> > ufs_hba *hba, struct ufshpb_lu *hpb)
>> >               }
>> >
>> >               rgn->rgn_flags = 0;
>> > +             rgn->hpb = hpb;
>> >       }
>> >
>> >       return 0;
>> > @@ -2053,6 +2107,8 @@ static int ufshpb_lu_hpb_init(struct ufs_hba
>> > *hba, struct ufshpb_lu *hpb)
>> >                         ufshpb_normalization_work_handler);
>> >               INIT_WORK(&hpb->ufshpb_lun_reset_work,
>> >                         ufshpb_reset_work_handler);
>> > +             INIT_DELAYED_WORK(&hpb->ufshpb_read_to_work,
>> > +                               ufshpb_read_to_handler);
>> >       }
>> >
>> >       hpb->map_req_cache = kmem_cache_create("ufshpb_req_cache",
>> > @@ -2087,6 +2143,10 @@ static int ufshpb_lu_hpb_init(struct ufs_hba
>> > *hba, struct ufshpb_lu *hpb)
>> >       ufshpb_stat_init(hpb);
>> >       ufshpb_param_init(hpb);
>> >
>> > +     if (hpb->is_hcm)
>> > +             schedule_delayed_work(&hpb->ufshpb_read_to_work,
>> > +                                   msecs_to_jiffies(POLLING_INTERVAL_MS));
>> > +
>> >       return 0;
>> >
>> >  release_pre_req_mempool:
>> > @@ -2154,6 +2214,7 @@ static void ufshpb_discard_rsp_lists(struct
>> > ufshpb_lu *hpb)
>> >  static void ufshpb_cancel_jobs(struct ufshpb_lu *hpb)
>> >  {
>> >       if (hpb->is_hcm) {
>> > +             cancel_delayed_work_sync(&hpb->ufshpb_read_to_work);
>> >               cancel_work_sync(&hpb->ufshpb_lun_reset_work);
>> >               cancel_work_sync(&hpb->ufshpb_normalization_work);
>> >       }
>> > @@ -2264,6 +2325,10 @@ void ufshpb_resume(struct ufs_hba *hba)
>> >                       continue;
>> >               ufshpb_set_state(hpb, HPB_PRESENT);
>> >               ufshpb_kick_map_work(hpb);
>> > +             if (hpb->is_hcm)
>> > +                     schedule_delayed_work(&hpb->ufshpb_read_to_work,
>> > +                             msecs_to_jiffies(POLLING_INTERVAL_MS));
>> > +
>> >       }
>> >  }
>> >
>> > diff --git a/drivers/scsi/ufs/ufshpb.h b/drivers/scsi/ufs/ufshpb.h
>> > index 37c1b0ea0c0a..b49e9a34267f 100644
>> > --- a/drivers/scsi/ufs/ufshpb.h
>> > +++ b/drivers/scsi/ufs/ufshpb.h
>> > @@ -109,6 +109,7 @@ struct ufshpb_subregion {
>> >  };
>> >
>> >  struct ufshpb_region {
>> > +     struct ufshpb_lu *hpb;
>> >       struct ufshpb_subregion *srgn_tbl;
>> >       enum HPB_RGN_STATE rgn_state;
>> >       int rgn_idx;
>> > @@ -126,6 +127,10 @@ struct ufshpb_region {
>> >       /* region reads - for host mode */
>> >       spinlock_t rgn_lock;
>> >       unsigned int reads;
>> > +     /* region "cold" timer - for host mode */
>> > +     ktime_t read_timeout;
>> > +     unsigned int read_timeout_expiries;
>> > +     struct list_head list_expired_rgn;
>> >  };
>> >
>> >  #define for_each_sub_region(rgn, i, srgn)                            \
>> > @@ -219,6 +224,7 @@ struct ufshpb_lu {
>> >       struct victim_select_info lru_info;
>> >       struct work_struct ufshpb_normalization_work;
>> >       struct work_struct ufshpb_lun_reset_work;
>> > +     struct delayed_work ufshpb_read_to_work;
>> >
>> >       /* pinned region information */
>> >       u32 lu_pinned_start;
