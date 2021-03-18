Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3220CC433DB
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Mar 2021 07:14:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D9E2264F30
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Mar 2021 07:14:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229664AbhCRHOV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 18 Mar 2021 03:14:21 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:64947 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbhCRHNr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 18 Mar 2021 03:13:47 -0400
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20210318071345epoutp0403c0eff2801565623d0b8dddb00a6fe5~tXmRA2grm2025720257epoutp046
        for <linux-scsi@vger.kernel.org>; Thu, 18 Mar 2021 07:13:45 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20210318071345epoutp0403c0eff2801565623d0b8dddb00a6fe5~tXmRA2grm2025720257epoutp046
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1616051626;
        bh=gySNewq6n0vk9lDqd9Ugaboa63g5WLsXWopfrDwchzc=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=sW2vcPiJjikJu07KVbdKErnCvrgHfdVBjWcSgMJaDgFRbMvrobRRi8ZLjcJISUYAp
         8dvs/KFN6Ec5KhO5KgHlibG6NmH8B4NUvF46V3Vl2U2QgiBeNRqRcrrLBD+oO/dM9M
         Bp//dSqVEZ6tEbOgZSMVILlhqV/m19z9EwquU8uA=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTP id
        20210318071344epcas2p17ba53d7753fea635c387a9bc92015e1c~tXmP5WrWD0101901019epcas2p1f;
        Thu, 18 Mar 2021 07:13:44 +0000 (GMT)
Received: from epsmges2p3.samsung.com (unknown [182.195.40.188]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4F1JCq2p2Gz4x9QH; Thu, 18 Mar
        2021 07:13:43 +0000 (GMT)
X-AuditID: b6c32a47-b97ff7000000148e-8c-6052fda75b5a
Received: from epcas2p3.samsung.com ( [182.195.41.55]) by
        epsmges2p3.samsung.com (Symantec Messaging Gateway) with SMTP id
        68.29.05262.7ADF2506; Thu, 18 Mar 2021 16:13:43 +0900 (KST)
Mime-Version: 1.0
Subject: RE: Re: [PATCH v29 4/4] scsi: ufs: Add HPB 2.0 support
Reply-To: daejun7.park@samsung.com
Sender: Daejun Park <daejun7.park@samsung.com>
From:   Daejun Park <daejun7.park@samsung.com>
To:     Can Guo <cang@codeaurora.org>,
        Daejun Park <daejun7.park@samsung.com>
CC:     Greg KH <gregkh@linuxfoundation.org>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "huobean@gmail.com" <huobean@gmail.com>,
        ALIM AKHTAR <alim.akhtar@samsung.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        JinHwan Park <jh.i.park@samsung.com>,
        Javier Gonzalez <javier.gonz@samsung.com>,
        SEUNGUK SHIN <seunguk.shin@samsung.com>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <4f34cad55311137d1b28d897187a69df@codeaurora.org>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20210318071342epcms2p12f1c6664bb62ed58fded46c20ee01f07@epcms2p1>
Date:   Thu, 18 Mar 2021 16:13:42 +0900
X-CMS-MailID: 20210318071342epcms2p12f1c6664bb62ed58fded46c20ee01f07
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
CMS-TYPE: 102P
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLJsWRmVeSWpSXmKPExsWy7bCmue7yv0EJBi1bhSwezNvGZrG37QS7
        xcufV9ksDt9+x24x7cNPZotP65exWrw8pGmx6kG4RfPi9WwWc842MFn09m9ls3h85zO7xaIb
        25gs+v+1s1hc3jWHzaL7+g42i+XH/zFZ3N7CZbF0601Gi87pa1gcRDwuX/H2uNzXy+Sxc9Zd
        do8Jiw4weuyfu4bdo+XkfhaPj09vsXj0bVnF6PF5k5xH+4FupgCuqBybjNTElNQihdS85PyU
        zLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKDnlBTKEnNKgUIBicXFSvp2NkX5
        pSWpChn5xSW2SqkFKTkFhoYFesWJucWleel6yfm5VoYGBkamQJUJORlXe6+yFXzzr7h3cwdj
        A+MXuy5GTg4JAROJtqUX2boYuTiEBHYwSvy+vpO5i5GDg1dAUOLvDmGQGmEBe4mvG7axgthC
        AkoS6y/OYoeI60nceriGEcRmE9CRmH7iPlhcRMBT4uvk1awgM5kFlrNJNC7bzwqxjFdiRvtT
        FghbWmL78q1gzZwCdhLHPl5jhohrSPxY1gtli0rcXP2WHcZ+f2w+I4QtItF67yxUjaDEg5+7
        oeKSEsd2f2CCsOsltt75xQhyhIRAD6PE4Z23oI7Ql7jWsZEF4klfiZ6JYHNYBFQlDs+5xQZR
        4iJx9fFusL3MAvIS29/OAYcJs4CmxPpd+iCmhICyxJFbLDBfNWz8zY7OZhbgk+g4/BcuvmPe
        E6jL1CTW/VzPNIFReRYioGch2TULYdcCRuZVjGKpBcW56anFRgXGyHG7iRGczrXcdzDOePtB
        7xAjEwfjIUYJDmYlEV7TvIAEId6UxMqq1KL8+KLSnNTiQ4ymQF9OZJYSTc4HZpS8knhDUyMz
        MwNLUwtTMyMLJXHeYoMH8UIC6YklqdmpqQWpRTB9TBycUg1Mu9jXO09KWbTM8z5zwcYS9dUL
        H6wo+rtk7XfF9sqd+yeuaF5Q8n//L08nm+Zz3ov4gibxXq2M9utv2sO/29TqdYRESbDLqU95
        F74t49w9aZ8x45tZC7ZuPMl9PXnmrQ4W6frWuf+E8gunsBjeEmfm38Z11rrqiBhLjZmMXehp
        xZop3nHvHm+/mn5iu2Lvmy33VLi0/UMiQx0fdsXVu2vzzY1omcTjWjch38VtzbL9kbZ+b39M
        vLFzJcdn1c6svPm3F/JOP7/P5vurr0UK1r8n9d990i1l8MHmkYhaQj/715c5Zt58x3I8YpUv
        f+B3jW2/21wjENn9/sr5PG0tph2cK9SuLMx8u37Hgb2rfTNvKbEUZyQaajEXFScCAHZfinZw
        BAAA
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210315012850epcms2p361447b689e925561c48aa9ca54434eb5
References: <4f34cad55311137d1b28d897187a69df@codeaurora.org>
        <79aea8a80c1be2ff7f05683c2f4918ce@codeaurora.org>
        <a18909e8f4db023455b7513bf6c60312@codeaurora.org>
        <2da1c963bd3ff5f682d18a251ed08989@codeaurora.org>
        <20210315012850epcms2p361447b689e925561c48aa9ca54434eb5@epcms2p3>
        <20210315013137epcms2p861f06e66be9faff32b6648401778434a@epcms2p8>
        <20210315070728epcms2p87136c86803afa85a441ead524130245c@epcms2p8>
        <d6a4511fd85e6e47c5aef22e335bb253@codeaurora.org>
        <20210317014253epcms2p1f45db6a281645282e1540e0070999d73@epcms2p1>
        <20210318020243epcms2p8259fa1d5e99e3c463c6b9e9106693476@epcms2p8>
        <CGME20210315012850epcms2p361447b689e925561c48aa9ca54434eb5@epcms2p1>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>On 2021-03-18 10:02, Daejun Park wrote:
>>> On 2021-03-17 09:42, Daejun Park wrote:
>>>>> On 2021-03-15 15:23, Can Guo wrote:
>>>>>> On 2021-03-15 15:07, Daejun Park wrote:
>>>>>>>>> This patch supports the HPB 2.0.
>>>>>>>>> 
>>>>>>>>> The HPB 2.0 supports read of varying sizes from 4KB to 512KB.
>>>>>>>>> In the case of Read (<= 32KB) is supported as single HPB read.
>>>>>>>>> In the case of Read (36KB ~ 512KB) is supported by as a
>>>>>>>>> combination
>>>>>>>>> of
>>>>>>>>> write buffer command and HPB read command to deliver more PPN.
>>>>>>>>> The write buffer commands may not be issued immediately due to
>>>>>>>>> busy
>>>>>>>>> tags.
>>>>>>>>> To use HPB read more aggressively, the driver can requeue the
>>>>>>>>> write
>>>>>>>>> buffer
>>>>>>>>> command. The requeue threshold is implemented as timeout and can
>>>>>>>>> be
>>>>>>>>> modified with requeue_timeout_ms entry in sysfs.
>>>>>>>>> 
>>>>>>>>> Signed-off-by: Daejun Park <daejun7.park@samsung.com>
>>>>>>>>> ---
>>>>>>>>> +static struct attribute *hpb_dev_param_attrs[] = {
>>>>>>>>> +        &dev_attr_requeue_timeout_ms.attr,
>>>>>>>>> +        NULL,
>>>>>>>>> +};
>>>>>>>>> +
>>>>>>>>> +struct attribute_group ufs_sysfs_hpb_param_group = {
>>>>>>>>> +        .name = "hpb_param_sysfs",
>>>>>>>>> +        .attrs = hpb_dev_param_attrs,
>>>>>>>>> +};
>>>>>>>>> +
>>>>>>>>> +static int ufshpb_pre_req_mempool_init(struct ufshpb_lu *hpb)
>>>>>>>>> +{
>>>>>>>>> +        struct ufshpb_req *pre_req = NULL;
>>>>>>>>> +        int qd = hpb->sdev_ufs_lu->queue_depth / 2;
>>>>>>>>> +        int i, j;
>>>>>>>>> +
>>>>>>>>> +        INIT_LIST_HEAD(&hpb->lh_pre_req_free);
>>>>>>>>> +
>>>>>>>>> +        hpb->pre_req = kcalloc(qd, sizeof(struct ufshpb_req),
>>>>>>>>> GFP_KERNEL);
>>>>>>>>> +        hpb->throttle_pre_req = qd;
>>>>>>>>> +        hpb->num_inflight_pre_req = 0;
>>>>>>>>> +
>>>>>>>>> +        if (!hpb->pre_req)
>>>>>>>>> +                goto release_mem;
>>>>>>>>> +
>>>>>>>>> +        for (i = 0; i < qd; i++) {
>>>>>>>>> +                pre_req = hpb->pre_req + i;
>>>>>>>>> +                INIT_LIST_HEAD(&pre_req->list_req);
>>>>>>>>> +                pre_req->req = NULL;
>>>>>>>>> +                pre_req->bio = NULL;
>>>>>>>> 
>>>>>>>> Why don't prepare bio as same as wb.m_page? Won't that save more
>>>>>>>> time
>>>>>>>> for ufshpb_issue_pre_req()?
>>>>>>> 
>>>>>>> It is pre_req pool. So although we prepare bio at this time, it 
>>>>>>> just
>>>>>>> only for first pre_req.
>>>>>> 
>>>>>> I meant removing the bio_alloc() in ufshpb_issue_pre_req() and
>>>>>> bio_put()
>>>>>> in ufshpb_pre_req_compl_fn(). bios, in pre_req's case, just hold a
>>>>>> page.
>>>>>> So, prepare 16 (if queue depth is 32) bios here, just use them 
>>>>>> along
>>>>>> with
>>>>>> wb.m_page and call bio_reset() in ufshpb_pre_req_compl_fn(). Shall 
>>>>>> it
>>>>>> work?
>>>>>> 
>>>>> 
>>>>> If it works, you can even have the bio_add_pc_page() called here.
>>>>> Later
>>>>> in
>>>>> ufshpb_execute_pre_req(), you don't need to call
>>>>> ufshpb_pre_req_add_bio_page(),
>>>>> just call ufshpb_prep_entry() once instead - it save many repeated
>>>>> steps
>>>>> for a
>>>>> pre_req, and you don't even need to call bio_reset() in this case,
>>>>> since
>>>>> for a
>>>>> bio, nothing changes after it is binded with a specific page...
>>>> 
>>>> Hi, Can Guo
>>>> 
>>>> I tried the idea that you suggested, but it doesn't work properly.
>>>> This optimization should be done next time for enhancement.
>>> 
>>> Can you elaborate please? Any error seen?
>>> 
>>> Per my understanding, in the case for pre_reqs, a bio is no different
>>> from a page. Here it can reserve 16 pages for later use, which can be
>>> done the same for bios.
>> 
>> I found some problem with re-using pre allocated bio.
>> 
>> The following kernel message is related with problem.
>> [    2.750530] ------------[ cut here ]------------
>> [    2.751404] WARNING: CPU: 4 PID: 170 at
>> drivers/scsi/scsi_lib.c:1020 scsi_alloc_sgtables+0x253/0x2b0
>> [    2.753054] Modules linked in:
>> [    2.753651] CPU: 4 PID: 170 Comm: mount Not tainted 5.12.0-rc1+ #331
>> [    2.754752] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
>> BIOS rel-1.13.0-0-gf21b5a4aeb02-prebuilt.qemu.org 04/01/2014
>> [    2.756813] RIP: 0010:scsi_alloc_sgtables+0x253/0x2b0
>> [    2.757699] Code: 85 c0 74 19 41 0f b6 44 24 18 8d 50 e0 83 fa 03
>> 76 30 41 bd 01 00 00 00 e9 1f fe ff ff be 01 00 00 00 45 31 ed e9 19
>> fe ff ff <0f> 0b b8 0a f
>> [    2.761021] RSP: 0018:ffffb06e0027f538 EFLAGS: 00010246
>> [    2.761902] RAX: 0000000000000000 RBX: ffff9c3a42d424d0 RCX: 
>> ffffb06e0027f5e0
>> [    2.763184] RDX: ffff9c3a42d426a8 RSI: 0000000000000000 RDI: 
>> ffff9c3a42d424d0
>> [    2.764446] RBP: ffffb06e0027f570 R08: 0000000000000000 R09: 
>> 0000000000000000
>> [    2.765704] R10: ffffffff8eb0dda0 R11: 00000000fffb7675 R12: 
>> ffff9c3a42d423c0
>> [    2.766976] R13: 0000000000000000 R14: ffff9c3a41bed000 R15: 
>> ffff9c3a420f4000
>> [    2.768225] FS:  00007f42d1eab100(0000) GS:ffff9c3b77c00000(0000)
>> knlGS:0000000000000000
>> [    2.769666] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> [    2.770719] CR2: 00007f42d1ac1000 CR3: 0000000104bee006 CR4: 
>> 0000000000370ee0
>> [    2.771997] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
>> 0000000000000000
>> [    2.773288] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 
>> 0000000000000400
>> [    2.774543] Call Trace:
>> [    2.775092]  scsi_queue_rq+0x9b6/0xb20
>> [    2.775754]  __blk_mq_try_issue_directly+0x150/0x1f0
>> [    2.776636]  blk_mq_request_issue_directly+0x49/0x80
>> [    2.777616]  blk_insert_cloned_request+0x85/0xd0
>> [    2.778470]  ufshpb_prep.cold+0x793/0x7be
>> [    2.779179]  ufshcd_queuecommand+0x114/0x690
>> [    2.779986]  scsi_queue_rq+0x38a/0xb20
>> [    2.780755]  blk_mq_dispatch_rq_list+0x13d/0x760
>> [    2.781605]  ? dd_dispatch_request+0x67/0x1c0
>> [    2.782337]  __blk_mq_do_dispatch_sched+0xb5/0x2c0
>> [    2.783291]  __blk_mq_sched_dispatch_requests+0x13c/0x180
>> [    2.784209]  blk_mq_sched_dispatch_requests+0x30/0x60
>> [    2.785195]  __blk_mq_run_hw_queue+0x49/0x90
>> [    2.786024]  __blk_mq_delay_run_hw_queue+0x162/0x180
>> [    2.786890]  blk_mq_run_hw_queue+0x85/0xe0
>> [    2.787590]  blk_mq_sched_insert_requests+0xdf/0x2b0
>> [    2.788558]  blk_mq_flush_plug_list+0x118/0x240
>> [    2.789405]  blk_flush_plug_list+0xde/0x110
>> [    2.790225]  blk_finish_plug+0x21/0x30
>> [    2.790878]  read_pages+0x16a/0x1d0
>> [    2.791534]  page_cache_ra_unbounded+0x123/0x1c0
>> [    2.792392]  do_page_cache_ra+0x38/0x40
>> [    2.793183]  force_page_cache_ra+0x97/0x110
>> [    2.793875]  page_cache_sync_ra+0x26/0x50
>> [    2.794671]  filemap_get_pages+0xc8/0x4b0
>> [    2.795482]  filemap_read+0xc9/0x340
>> [    2.796144]  ? find_held_lock+0x31/0x90
>> [    2.796809]  generic_file_read_iter+0xcc/0x130
>> [    2.797644]  blkdev_read_iter+0x30/0x40
>> [    2.798436]  new_sync_read+0x10e/0x190
>> [    2.799112]  vfs_read+0x178/0x1d0
>> [    2.799732]  ksys_read+0x6b/0xf0
>> [    2.800361]  __x64_sys_read+0x15/0x20
>> [    2.801027]  do_syscall_64+0x38/0x50
>> [    2.801770]  entry_SYSCALL_64_after_hwframe+0x44/0xae
>> [    2.802655] RIP: 0033:0x7f42d209a461
>> [    2.803313] Code: fe ff ff 50 48 8d 3d fe d0 09 00 e8 e9 03 02 00
>> 66 0f 1f 84 00 00 00 00 00 48 8d 05 99 62 0d 00 8b 00 85 c0 75 13 31
>> c0 0f 05 <48> 3d 00 f0 8
>> [    2.806632] RSP: 002b:00007ffe7b88bc88 EFLAGS: 00000246 ORIG_RAX:
>> 0000000000000000
>> [    2.807942] RAX: ffffffffffffffda RBX: 000055ccb2e070d0 RCX: 
>> 00007f42d209a461
>> [    2.809218] RDX: 0000000000040000 RSI: 00007f42d1ac1038 RDI: 
>> 0000000000000004
>> [    2.810482] RBP: 000055ccb2e07120 R08: 00007f42d1ac1010 R09: 
>> 0000000000000000
>> [    2.811729] R10: 0000000000000022 R11: 0000000000000246 R12: 
>> 0000003b95fc0000
>> [    2.813005] R13: 0000000000040000 R14: 00007f42d1ac1028 R15: 
>> 00007f42d1ac1010
>> [    2.814276] irq event stamp: 9319
>> [    2.814868] hardirqs last  enabled at (9327): [<ffffffff8c4d2033>]
>> console_unlock+0x4d3/0x5e0
>> [    2.816349] hardirqs last disabled at (9336): [<ffffffff8c4d1fa6>]
>> console_unlock+0x446/0x5e0
>> [    2.817837] softirqs last  enabled at (8674): [<ffffffff8d4002ec>]
>> __do_softirq+0x2ec/0x40f
>> [    2.819298] softirqs last disabled at (8669): [<ffffffff8c46ad9e>]
>> irq_exit_rcu+0xae/0xb0
>> [    2.820744] ---[ end trace af3986a7787eeecf ]---
>> 
>> It is related to bi_iter value of bio is changed after use it.
> 
>Understood the problem now, let's take the 1st way -
>1. prepare bios in ufshpb_pre_req_mempool_init() (leave 
>bio_add_pc_page() where it was)
>2. call bio_reset() in ufshpb_put_pre_req()
> 
>This should work.

OK, I will try this.

Thanks,
Daejuin


>Thanks,
>Can Guo.
> 
>> 
>> Thanks,
>> Daejun
>> 
>>> This is not an enhancement, but a doubt - why not? Unless it is not
>>> doable.
>>> 
>>> Thanks,
>>> Can Guo.
>>> 
>>>> 
>>>> Thanks
>>>> Daejun
>>>> 
>>>>> Can Guo.
>>>>> 
>>>>>> Thanks,
>>>>>> Can Guo.
>>>>>> 
>>>>>>> After use it, it should be prepared bio at issue phase.
>>>>>>> 
>>>>>>> Thanks,
>>>>>>> Daejun
>>>>>>> 
>>>>>>>> 
>>>>>>>> Thanks,
>>>>>>>> Can Guo.
>>>>>>>> 
>>>>>>>>> +
>>>>>>>>> +                pre_req->wb.m_page = alloc_page(GFP_KERNEL |
>>>>>>>>> __GFP_ZERO);
>>>>>>>>> +                if (!pre_req->wb.m_page) {
>>>>>>>>> +                        for (j = 0; j < i; j++)
>>>>>>>>> +
>>>>>>>>> __free_page(hpb->pre_req[j].wb.m_page);
>>>>>>>>> +
>>>>>>>>> +                        goto release_mem;
>>>>>>>>> +                }
>>>>>>>>> +                list_add_tail(&pre_req->list_req,
>>>>>>>>> &hpb->lh_pre_req_free);
>>>>>>>>> +        }
>>>>>>>>> +
>>>>>>>>> +        return 0;
>>>>>>>>> +release_mem:
>>>>>>>>> +        kfree(hpb->pre_req);
>>>>>>>>> +        return -ENOMEM;
>>>>>>>>> +}
>>>>>>>>> +
>>>>>>>> 
>>>>>>>> 
>>>>>>>> 
>>>>> 
>>>>> 
>>>>> 
>>> 
>>> 
>>> 
> 
> 
>  
