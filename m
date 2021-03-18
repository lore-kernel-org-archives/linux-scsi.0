Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36834C433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Mar 2021 01:02:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D226464EFD
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Mar 2021 01:02:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229866AbhCRBBV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Mar 2021 21:01:21 -0400
Received: from m42-10.mailgun.net ([69.72.42.10]:10289 "EHLO
        m42-10.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbhCRBAz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Mar 2021 21:00:55 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1616029255; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=cdXXKx/6cmpJ3k5zTd24Wab1Zl+Vk9yFNKDeZVbO238=;
 b=vINr4YwVgzaE90t7B4wZKjnRvdL3L39wNBbfmrsqhEY72dMPRN6ccuB5erjhfMnLy7iPXsg2
 o0LK9bopvfkBoCgL1GrbNSjSDHK1RYC3KSChYzbL2PMBER858z3k0fuONZXnZcK83Rio79Od
 wFN1Cd4J4pZqSE+HSdlt//EitKQ=
X-Mailgun-Sending-Ip: 69.72.42.10
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-west-2.postgun.com with SMTP id
 6052a63b3f267701a49f0d15 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 18 Mar 2021 01:00:43
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id F1BADC43468; Thu, 18 Mar 2021 01:00:42 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 46873C433C6;
        Thu, 18 Mar 2021 01:00:41 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 18 Mar 2021 09:00:41 +0800
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
Subject: Re: [PATCH v5 06/10] scsi: ufshpb: Add hpb dev reset response
In-Reply-To: <DM6PR04MB65757E84F80B654689FBAE05FC6A9@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20210302132503.224670-1-avri.altman@wdc.com>
 <20210302132503.224670-7-avri.altman@wdc.com>
 <59a62fc17ec9229a8498e696eb0474be@codeaurora.org>
 <DM6PR04MB6575006E0682C3D11F54965DFC6A9@DM6PR04MB6575.namprd04.prod.outlook.com>
 <1d0e3c5441ecf14b6614ec0af0d30af6@codeaurora.org>
 <DM6PR04MB65750C0AE1F1EDB41EDEE491FC6A9@DM6PR04MB6575.namprd04.prod.outlook.com>
 <37d0a4f115ad5d08ab12a76e6cbe17a5@codeaurora.org>
 <DM6PR04MB65755C69AD3D64BC5B1E93D8FC6A9@DM6PR04MB6575.namprd04.prod.outlook.com>
 <4562e78aee9c5fbb7bbff65930fc81cd@codeaurora.org>
 <DM6PR04MB65757E84F80B654689FBAE05FC6A9@DM6PR04MB6575.namprd04.prod.outlook.com>
Message-ID: <546d67b328afcd0d26dff41180288b63@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021-03-17 23:46, Avri Altman wrote:
>> >> >> >>
>> >> >> >> Just curious, directly doing below things inside ufshpb_rsp_upiu()
>> >> >> >> does
>> >> >> >> not
>> >> >> >> seem a problem to me, does this really deserve a separate work?
>> >> >> > I don't know, I never even consider of doing this.
>> >> >> > The active region list may contain up to few thousands of regions -
>> >> >> > It is not rare to see configurations that covers the entire device.
>> >> >> >
>> >> >>
>> >> >> Yes, true, it can be a huge list. But what does the ops
>> >> >> "HPB_RSP_DEV_RESET"
>> >> >> really mean? The specs says "Device reset HPB Regions information",
>> >> >> but
>> >> >> I
>> >> >> don't know what is really happening. Could you please elaborate?
>> >> > It means that the device informs the host that the L2P cache is no
>> >> > longer valid.
>> >> > The spec doesn't say what to do in that case.
>> >>
>> >> Then it means that all the clean (without DIRTY flag set) HPB entries
>> >> (ppns)
>> >> in active rgns in host memory side may not be valid to the device
>> >> anymore.
>> >> Please correct me if I am wrong.
>> >>
>> >> > We thought that in host mode, it make sense to update all the active
>> >> > regions.
>> >>
>> >> But current logic does not set the state of the sub-regions (in active
>> >> regions) to
>> >> INVALID, it only marks all active regions as UPDATE.
>> >>
>> >> Although one of subsequent read cmds shall put the sub-region back to
>> >> activate_list,
>> >> ufshpb_test_ppn_dirty() can still return false, thus these read cmds
>> >> still think the
>> >> ppns are valid and they shall move forward to send HPB Write Buffer
>> >> (buffer id = 0x2,
>> >> in case of HPB2.0) and HPB Read cmds.
>> >>
>> >> HPB Read cmds with invalid ppns will be treated as normal Read cmds by
>> >> device as the
>> >> specs says, but what would happen to HPB Write Buffer cmds (buffer id
>> >> =
>> >> 0x2, in case
>> >> of HPB2.0) with invalid ppns? Can this be a real problem?
>> > No need to control the ppn dirty / invalid state for this case.
>> > The device send device reset so it is aware that all the L2P cache is
>> > invalid.
>> > Any HPB_READ is treated like normal READ10.
>> >
>> > Only once HPB-READ-BUFFER is completed,
>> > the device will relate back to the physical address.
>> 
>> What about HPB-WRITE-BUFFER (buffer id = 0x2) cmds?
> Same.
> Oper 0x2 is a relative simple case.
> The device is expected to manage some versioning framework not to be
> "fooled" by erroneous ppn.
> There are some more challenging races that the device should meet.
> 

But I don't find the handling w.r.t this scenario on HPB2.0 specs -
how would the device re-act/respond to HPB-WRITE-BUFFER cmds with
invalid HPB entries? Could you please point me to relevant 
section/paragraph?

Thanks,
Can Guo.

> Thanks,
> Avri
>> 
>> Thanks,
>> Can Guo.
>> 
>> >
>> >>
>> >> >
>> >> > I think I will go with your suggestion.
>> >> > Effectively, in host mode, since it is deactivating "cold" regions,
>> >> > the lru list is kept relatively small, and contains only "hot" regions.
>> >>
>> >> hmm... I don't really have a idea on this, please go with whatever you
>> >> and Daejun think is fine here.
>> > I will take your advice and remove the worker.
>> >
>> >
>> > Thanks,
>> > Avri
>> >
>> >>
>> >> Thanks,
>> >> Can Guo.
>> >>
>> >> >
>> >> > Thanks,
>> >> > Avri
>> >> >
>> >> >>
>> >> >> Thanks,
>> >> >> Can Guo.
>> >> >>
>> >> >> > But yes, I can do that.
>> >> >> > Better to get ack from Daejun first.
>> >> >> >
>> >> >> > Thanks,
>> >> >> > Avri
>> >> >> >
>> >> >> >>
>> >> >> >> Thanks,
>> >> >> >> Can Guo.
>> >> >> >>
>> >> >> >> > +{
>> >> >> >> > +     struct ufshpb_lu *hpb;
>> >> >> >> > +     struct victim_select_info *lru_info;
>> >> >> >> > +     struct ufshpb_region *rgn;
>> >> >> >> > +     unsigned long flags;
>> >> >> >> > +
>> >> >> >> > +     hpb = container_of(work, struct ufshpb_lu,
>> >> ufshpb_lun_reset_work);
>> >> >> >> > +
>> >> >> >> > +     lru_info = &hpb->lru_info;
>> >> >> >> > +
>> >> >> >> > +     spin_lock_irqsave(&hpb->rgn_state_lock, flags);
>> >> >> >> > +
>> >> >> >> > +     list_for_each_entry(rgn, &lru_info->lh_lru_rgn, list_lru_rgn)
>> >> >> >> > +             set_bit(RGN_FLAG_UPDATE, &rgn->rgn_flags);
>> >> >> >> > +
>> >> >> >> > +     spin_unlock_irqrestore(&hpb->rgn_state_lock, flags);
>> >> >> >> > +}
>> >> >> >> > +
>> >> >> >> >  static void ufshpb_normalization_work_handler(struct work_struct
>> >> >> >> > *work)
>> >> >> >> >  {
>> >> >> >> >       struct ufshpb_lu *hpb;
>> >> >> >> > @@ -1798,6 +1832,8 @@ static int ufshpb_alloc_region_tbl(struct
>> >> >> >> > ufs_hba *hba, struct ufshpb_lu *hpb)
>> >> >> >> >               } else {
>> >> >> >> >                       rgn->rgn_state = HPB_RGN_INACTIVE;
>> >> >> >> >               }
>> >> >> >> > +
>> >> >> >> > +             rgn->rgn_flags = 0;
>> >> >> >> >       }
>> >> >> >> >
>> >> >> >> >       return 0;
>> >> >> >> > @@ -2012,9 +2048,12 @@ static int ufshpb_lu_hpb_init(struct
>> >> ufs_hba
>> >> >> >> > *hba, struct ufshpb_lu *hpb)
>> >> >> >> >       INIT_LIST_HEAD(&hpb->list_hpb_lu);
>> >> >> >> >
>> >> >> >> >       INIT_WORK(&hpb->map_work, ufshpb_map_work_handler);
>> >> >> >> > -     if (hpb->is_hcm)
>> >> >> >> > +     if (hpb->is_hcm) {
>> >> >> >> >               INIT_WORK(&hpb->ufshpb_normalization_work,
>> >> >> >> >                         ufshpb_normalization_work_handler);
>> >> >> >> > +             INIT_WORK(&hpb->ufshpb_lun_reset_work,
>> >> >> >> > +                       ufshpb_reset_work_handler);
>> >> >> >> > +     }
>> >> >> >> >
>> >> >> >> >       hpb->map_req_cache =
>> kmem_cache_create("ufshpb_req_cache",
>> >> >> >> >                         sizeof(struct ufshpb_req), 0, 0, NULL);
>> >> >> >> > @@ -2114,8 +2153,10 @@ static void
>> ufshpb_discard_rsp_lists(struct
>> >> >> >> > ufshpb_lu *hpb)
>> >> >> >> >
>> >> >> >> >  static void ufshpb_cancel_jobs(struct ufshpb_lu *hpb)
>> >> >> >> >  {
>> >> >> >> > -     if (hpb->is_hcm)
>> >> >> >> > +     if (hpb->is_hcm) {
>> >> >> >> > +             cancel_work_sync(&hpb->ufshpb_lun_reset_work);
>> >> >> >> >               cancel_work_sync(&hpb->ufshpb_normalization_work);
>> >> >> >> > +     }
>> >> >> >> >       cancel_work_sync(&hpb->map_work);
>> >> >> >> >  }
>> >> >> >> >
>> >> >> >> > diff --git a/drivers/scsi/ufs/ufshpb.h b/drivers/scsi/ufs/ufshpb.h
>> >> >> >> > index 84598a317897..37c1b0ea0c0a 100644
>> >> >> >> > --- a/drivers/scsi/ufs/ufshpb.h
>> >> >> >> > +++ b/drivers/scsi/ufs/ufshpb.h
>> >> >> >> > @@ -121,6 +121,7 @@ struct ufshpb_region {
>> >> >> >> >       struct list_head list_lru_rgn;
>> >> >> >> >       unsigned long rgn_flags;
>> >> >> >> >  #define RGN_FLAG_DIRTY 0
>> >> >> >> > +#define RGN_FLAG_UPDATE 1
>> >> >> >> >
>> >> >> >> >       /* region reads - for host mode */
>> >> >> >> >       spinlock_t rgn_lock;
>> >> >> >> > @@ -217,6 +218,7 @@ struct ufshpb_lu {
>> >> >> >> >       /* for selecting victim */
>> >> >> >> >       struct victim_select_info lru_info;
>> >> >> >> >       struct work_struct ufshpb_normalization_work;
>> >> >> >> > +     struct work_struct ufshpb_lun_reset_work;
>> >> >> >> >
>> >> >> >> >       /* pinned region information */
>> >> >> >> >       u32 lu_pinned_start;
