Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7F7BC433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 05:35:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 84E9064FAB
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 05:35:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229498AbhCQFel (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Mar 2021 01:34:41 -0400
Received: from a0.mail.mailgun.net ([198.61.254.59]:23955 "EHLO
        a0.mail.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbhCQFeS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Mar 2021 01:34:18 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1615959257; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=d/u3tI1DepCfLnIa6rIn3JLbEb1AR0kvLruAKZtROAk=;
 b=SxPv080DC0Oj/SkzSXWnX5jlA4ycPI3pgzpzObiMnF5XDw+G4NO9UunizVT9Lr4fUs6vsuXF
 NoMFkR2XMtJYTpOn1LCnpDW+55m9Q1WFYHvizwe5ia+Nfu+TKpCaHeBwbH7avPXmGW3u5JsM
 284VMpM71n3teYHpdGF4BG0tNRA=
X-Mailgun-Sending-Ip: 198.61.254.59
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n01.prod.us-east-1.postgun.com with SMTP id
 605194d6e3fca7d0a6b7ad0f (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 17 Mar 2021 05:34:14
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 6C1EDC43461; Wed, 17 Mar 2021 05:34:13 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 2DC2FC433CA;
        Wed, 17 Mar 2021 05:34:12 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 17 Mar 2021 13:34:12 +0800
From:   Can Guo <cang@codeaurora.org>
To:     daejun7.park@samsung.com
Cc:     Avri Altman <Avri.Altman@wdc.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, Bart Van Assche <bvanassche@acm.org>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        ALIM AKHTAR <alim.akhtar@samsung.com>, asutoshd@codeaurora.org,
        Zang Leigang <zangleigang@hisilicon.com>,
        Avi Shchislowski <Avi.Shchislowski@wdc.com>,
        Bean Huo <beanhuo@micron.com>, stanley.chu@mediatek.com
Subject: Re: [PATCH v5 05/10] scsi: ufshpb: Region inactivation in host mode
In-Reply-To: <1796371666.41615958582147.JavaMail.epsvc@epcpadp4>
References: <064483451ff0d9ef8703871332ea5c3b@codeaurora.org>
 <DM6PR04MB65751EE32D25C7E57A6BABE8FC6B9@DM6PR04MB6575.namprd04.prod.outlook.com>
 <20210302132503.224670-1-avri.altman@wdc.com>
 <20210302132503.224670-6-avri.altman@wdc.com>
 <25da7378d5bf4c52443ae9b47f3fd778@codeaurora.org>
 <57afb2b5d7edda61a40493d8545785b1@codeaurora.org>
 <2038148563.21615949282962.JavaMail.epsvc@epcpadp4>
 <CGME20210316083014epcas2p32d6b84e689cdbe06ee065c870b236d65@epcms2p4>
 <1796371666.41615958582147.JavaMail.epsvc@epcpadp4>
Message-ID: <a5958ce2eca11b6ddcf75fa3aeeaaa4f@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021-03-17 13:19, Daejun Park wrote:
>>>>> >> ---
>>>>> >>  drivers/scsi/ufs/ufshpb.c | 14 ++++++++++++++
>>>>> >>  drivers/scsi/ufs/ufshpb.h |  1 +
>>>>> >>  2 files changed, 15 insertions(+)
>>>>> >>
>>>>> >> diff --git a/drivers/scsi/ufs/ufshpb.c b/drivers/scsi/ufs/ufshpb.c
>>>>> >> index 6f4fd22eaf2f..0744feb4d484 100644
>>>>> >> --- a/drivers/scsi/ufs/ufshpb.c
>>>>> >> +++ b/drivers/scsi/ufs/ufshpb.c
>>>>> >> @@ -907,6 +907,7 @@ static int ufshpb_execute_umap_req(struct
>>>>> >> ufshpb_lu *hpb,
>>>>> >>
>>>>> >>      blk_execute_rq_nowait(q, NULL, req, 1, ufshpb_umap_req_compl_fn);
>>>>> >>
>>>>> >> +    hpb->stats.umap_req_cnt++;
>>>>> >>      return 0;
>>>>> >>  }
>>>>> >>
>>>>> >> @@ -1103,6 +1104,12 @@ static int ufshpb_issue_umap_req(struct
>>>>> >> ufshpb_lu *hpb,
>>>>> >>      return -EAGAIN;
>>>>> >>  }
>>>>> >>
>>>>> >> +static int ufshpb_issue_umap_single_req(struct ufshpb_lu *hpb,
>>>>> >> +                                    struct ufshpb_region *rgn)
>>>>> >> +{
>>>>> >> +    return ufshpb_issue_umap_req(hpb, rgn);
>>>>> >> +}
>>>>> >> +
>>>>> >>  static int ufshpb_issue_umap_all_req(struct ufshpb_lu *hpb)
>>>>> >>  {
>>>>> >>      return ufshpb_issue_umap_req(hpb, NULL);
>>>>> >> @@ -1115,6 +1122,10 @@ static void __ufshpb_evict_region(struct
>>>>> >> ufshpb_lu *hpb,
>>>>> >>      struct ufshpb_subregion *srgn;
>>>>> >>      int srgn_idx;
>>>>> >>
>>>>> >> +
>>>>> >> +    if (hpb->is_hcm && ufshpb_issue_umap_single_req(hpb, rgn))
>>>>> >
>>>>> > __ufshpb_evict_region() is called with rgn_state_lock held and IRQ
>>>>> > disabled,
>>>>> > when ufshpb_issue_umap_single_req() invokes blk_execute_rq_nowait(),
>>>>> > below
>>>>> > warning shall pop up every time, fix it?
>>>>> >
>>>>> > void blk_execute_rq_nowait(struct request_queue *q, struct gendisk
>>>>> > *bd_disk,
>>>>> >                  struct request *rq, int at_head,
>>>>> >                          rq_end_io_fn *done)
>>>>> > {
>>>>> >       WARN_ON(irqs_disabled());
>>>>> > ...
>>>>> >
>>>>> 
>>>>> Moreover, since we are here with rgn_state_lock held and IRQ
>>>>> disabled,
>>>>> in ufshpb_get_req(), rq = kmem_cache_alloc(hpb->map_req_cache,
>>>>> GFP_KERNEL)
>>>>> has the GFP_KERNEL flag, scheduling while atomic???
>>>> I think your comment applies to  ufshpb_issue_umap_all_req as well,
>>>> Which is called from slave_configure/scsi_add_lun.
>>>> 
>>>> Since the host-mode series is utilizing the framework laid by the
>>>> device-mode,
>>>> Maybe you can add this comment to  Daejun's last version?
>>> 
>>> Hi Avri, Can Guo
>>> 
>>> I think ufshpb_issue_umap_single_req() can be moved to end of
>>> ufshpb_evict_region().
>>> Then we can avoid rgn_state_lock when it sends unmap command.
>> 
>> I am not the expert here, please you two fix it. I am just reporting
>> what can be wrong. Anyways, ufshpb_issue_umap_single_req() should not
>> be called with rgn_state_lock held - think about below (another 
>> deadly)
>> scenario.
>> 
>> lock(rgn_state_lock)
>>   ufshpb_issue_umap_single_req()
>>     ufshpb_prep()
>>        lock(rgn_state_lock)   <---------- recursive spin_lock
>> 
>> BTW, @Daejun shouldn't we stop passthrough cmds from stepping
>> into ufshpb_prep()? In current code, you are trying to use below
>> check to block cmds other than write/discard/read, but a passthrough
>> cmd can not be blocked by the check.
>> 
>>          if (!ufshpb_is_write_or_discard_cmd(cmd) &&
>>              !ufshpb_is_read_cmd(cmd) )
>>                  return 0;
> 
> I found this problem too. I fixed it and submit next patch.

You mean in V30, which has not been uploaded yet, right?

Thanks,
Can Guo.

> 
> if (blk_rq_is_scsi(cmd->request) ||
> 	    (!ufshpb_is_write_or_discard_cmd(cmd) &&
> 	    !ufshpb_is_read_cmd(cmd)))
> 		return 0;
> 
> 
> Thanks,
> Daejun
> 
>> Thanks,
>> Can Guo.
>> 
>>> 
>>> Thanks,
>>> Daejun
>>> 
>>> 
>>>> Thanks,
>>>> Avri
>>>> 
>>>>> 
>>>>> Can Guo.
>>>>> 
>>>>> > Thanks.
>>>>> > Can Guo.
>>>>> >
>>>>> >> +            return;
>>>>> >> +
>>>>> >>      lru_info = &hpb->lru_info;
>>>>> >>
>>>>> >>      dev_dbg(&hpb->sdev_ufs_lu->sdev_dev, "evict region %d\n",
>>>>> >> rgn->rgn_idx);
>>>>> >> @@ -1855,6 +1866,7 @@ ufshpb_sysfs_attr_show_func(rb_noti_cnt);
>>>>> >>  ufshpb_sysfs_attr_show_func(rb_active_cnt);
>>>>> >>  ufshpb_sysfs_attr_show_func(rb_inactive_cnt);
>>>>> >>  ufshpb_sysfs_attr_show_func(map_req_cnt);
>>>>> >> +ufshpb_sysfs_attr_show_func(umap_req_cnt);
>>>>> >>
>>>>> >>  static struct attribute *hpb_dev_stat_attrs[] = {
>>>>> >>      &dev_attr_hit_cnt.attr,
>>>>> >> @@ -1863,6 +1875,7 @@ static struct attribute *hpb_dev_stat_attrs[] =
>>>>> >> {
>>>>> >>      &dev_attr_rb_active_cnt.attr,
>>>>> >>      &dev_attr_rb_inactive_cnt.attr,
>>>>> >>      &dev_attr_map_req_cnt.attr,
>>>>> >> +    &dev_attr_umap_req_cnt.attr,
>>>>> >>      NULL,
>>>>> >>  };
>>>>> >>
>>>>> >> @@ -1978,6 +1991,7 @@ static void ufshpb_stat_init(struct ufshpb_lu
>>>>> >> *hpb)
>>>>> >>      hpb->stats.rb_active_cnt = 0;
>>>>> >>      hpb->stats.rb_inactive_cnt = 0;
>>>>> >>      hpb->stats.map_req_cnt = 0;
>>>>> >> +    hpb->stats.umap_req_cnt = 0;
>>>>> >>  }
>>>>> >>
>>>>> >>  static void ufshpb_param_init(struct ufshpb_lu *hpb)
>>>>> >> diff --git a/drivers/scsi/ufs/ufshpb.h b/drivers/scsi/ufs/ufshpb.h
>>>>> >> index bd4308010466..84598a317897 100644
>>>>> >> --- a/drivers/scsi/ufs/ufshpb.h
>>>>> >> +++ b/drivers/scsi/ufs/ufshpb.h
>>>>> >> @@ -186,6 +186,7 @@ struct ufshpb_stats {
>>>>> >>      u64 rb_inactive_cnt;
>>>>> >>      u64 map_req_cnt;
>>>>> >>      u64 pre_req_cnt;
>>>>> >> +    u64 umap_req_cnt;
>>>>> >>  };
>>>>> >>
>>>>> >>  struct ufshpb_lu {
>>>> 
>>>> 
>>>> 
>> 
>> 
>> 
