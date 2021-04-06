Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9416EC433ED
	for <linux-scsi@archiver.kernel.org>; Tue,  6 Apr 2021 06:00:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4DF57613C2
	for <linux-scsi@archiver.kernel.org>; Tue,  6 Apr 2021 06:00:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232253AbhDFGAy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 6 Apr 2021 02:00:54 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:20901 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231751AbhDFGAx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 6 Apr 2021 02:00:53 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1617688846; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=zVvDrghM7JFU1bfKo/fdPpx8ufnljDWLYH8Sfh6TgSw=;
 b=pdZtOlZIdoxLOQLGDqh367jp0RR/CmCD5kByesmexHNPzWTLtYC51bzVDT8L0w3npsN48z2X
 ddubc7mdkpE5nem2KEU/kx0TNIjSu+FRciaZMszXeYR0eAA4VH3GlSAtKzZl/vsLNHGs8VNV
 H25CihqsNT2hpc3bde5/q44JRXw=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n06.prod.us-east-1.postgun.com with SMTP id
 606bf90dc06dd10a2dc7baff (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 06 Apr 2021 06:00:45
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 36A79C433CA; Tue,  6 Apr 2021 06:00:45 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 06F89C433C6;
        Tue,  6 Apr 2021 06:00:42 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 06 Apr 2021 14:00:42 +0800
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
Subject: Re: [PATCH v7 06/11] scsi: ufshpb: Region inactivation in host mode
In-Reply-To: <DM6PR04MB6575719C78D67B7FA1557C21FC769@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20210331073952.102162-1-avri.altman@wdc.com>
 <20210331073952.102162-7-avri.altman@wdc.com>
 <e29e33769f23036f936a6b60c7430387@codeaurora.org>
 <DM6PR04MB6575719C78D67B7FA1557C21FC769@DM6PR04MB6575.namprd04.prod.outlook.com>
Message-ID: <6bb2fd28feb0cd6372a32673d6cfa164@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021-04-06 13:20, Avri Altman wrote:
>> > -static void __ufshpb_evict_region(struct ufshpb_lu *hpb,
>> > -                               struct ufshpb_region *rgn)
>> > +static int __ufshpb_evict_region(struct ufshpb_lu *hpb,
>> > +                              struct ufshpb_region *rgn)
>> >  {
>> >       struct victim_select_info *lru_info;
>> >       struct ufshpb_subregion *srgn;
>> >       int srgn_idx;
>> >
>> > +     lockdep_assert_held(&hpb->rgn_state_lock);
>> > +
>> > +     if (hpb->is_hcm) {
>> > +             unsigned long flags;
>> > +             int ret;
>> > +
>> > +             spin_unlock_irqrestore(&hpb->rgn_state_lock, flags);
>> 
>> Never seen a usage like this... Here flags is used without being
>> intialized.
>> The flag is needed when spin_unlock_irqrestore ->
>> local_irq_restore(flags) to
>> restore the DAIF register (in terms of ARM).
> OK.

Hi Avri,

Checked on my setup, this lead to compilation error. Will you fix it in 
next version?

warning: variable 'flags' is uninitialized when used here 
[-Wuninitialized]

Thanks,
Can Guo.

> 
> Thanks,
> Avri
> 
>> 
>> Thanks,
>> 
>> Can Guo.
>> 
>> > +             ret = ufshpb_issue_umap_single_req(hpb, rgn);
>> > +             spin_lock_irqsave(&hpb->rgn_state_lock, flags);
>> > +             if (ret)
>> > +                     return ret;
>> > +     }
>> > +
>> >       lru_info = &hpb->lru_info;
>> >
>> >       dev_dbg(&hpb->sdev_ufs_lu->sdev_dev, "evict region %d\n",
>> > rgn->rgn_idx);
>> > @@ -1130,6 +1150,8 @@ static void __ufshpb_evict_region(struct
>> > ufshpb_lu *hpb,
>> >
>> >       for_each_sub_region(rgn, srgn_idx, srgn)
>> >               ufshpb_purge_active_subregion(hpb, srgn);
>> > +
>> > +     return 0;
>> >  }
>> >
>> >  static int ufshpb_evict_region(struct ufshpb_lu *hpb, struct
>> > ufshpb_region *rgn)
>> > @@ -1151,7 +1173,7 @@ static int ufshpb_evict_region(struct ufshpb_lu
>> > *hpb, struct ufshpb_region *rgn)
>> >                       goto out;
>> >               }
>> >
>> > -             __ufshpb_evict_region(hpb, rgn);
>> > +             ret = __ufshpb_evict_region(hpb, rgn);
>> >       }
>> >  out:
>> >       spin_unlock_irqrestore(&hpb->rgn_state_lock, flags);
>> > @@ -1285,7 +1307,9 @@ static int ufshpb_add_region(struct ufshpb_lu
>> > *hpb, struct ufshpb_region *rgn)
>> >                               "LRU full (%d), choose victim %d\n",
>> >                               atomic_read(&lru_info->active_cnt),
>> >                               victim_rgn->rgn_idx);
>> > -                     __ufshpb_evict_region(hpb, victim_rgn);
>> > +                     ret = __ufshpb_evict_region(hpb, victim_rgn);
>> > +                     if (ret)
>> > +                             goto out;
>> >               }
>> >
>> >               /*
>> > @@ -1856,6 +1880,7 @@ ufshpb_sysfs_attr_show_func(rb_noti_cnt);
>> >  ufshpb_sysfs_attr_show_func(rb_active_cnt);
>> >  ufshpb_sysfs_attr_show_func(rb_inactive_cnt);
>> >  ufshpb_sysfs_attr_show_func(map_req_cnt);
>> > +ufshpb_sysfs_attr_show_func(umap_req_cnt);
>> >
>> >  static struct attribute *hpb_dev_stat_attrs[] = {
>> >       &dev_attr_hit_cnt.attr,
>> > @@ -1864,6 +1889,7 @@ static struct attribute *hpb_dev_stat_attrs[] = {
>> >       &dev_attr_rb_active_cnt.attr,
>> >       &dev_attr_rb_inactive_cnt.attr,
>> >       &dev_attr_map_req_cnt.attr,
>> > +     &dev_attr_umap_req_cnt.attr,
>> >       NULL,
>> >  };
>> >
>> > @@ -1988,6 +2014,7 @@ static void ufshpb_stat_init(struct ufshpb_lu
>> > *hpb)
>> >       hpb->stats.rb_active_cnt = 0;
>> >       hpb->stats.rb_inactive_cnt = 0;
>> >       hpb->stats.map_req_cnt = 0;
>> > +     hpb->stats.umap_req_cnt = 0;
>> >  }
>> >
>> >  static void ufshpb_param_init(struct ufshpb_lu *hpb)
>> > diff --git a/drivers/scsi/ufs/ufshpb.h b/drivers/scsi/ufs/ufshpb.h
>> > index 87495e59fcf1..1ea58c17a4de 100644
>> > --- a/drivers/scsi/ufs/ufshpb.h
>> > +++ b/drivers/scsi/ufs/ufshpb.h
>> > @@ -191,6 +191,7 @@ struct ufshpb_stats {
>> >       u64 rb_inactive_cnt;
>> >       u64 map_req_cnt;
>> >       u64 pre_req_cnt;
>> > +     u64 umap_req_cnt;
>> >  };
>> >
>> >  struct ufshpb_lu {
