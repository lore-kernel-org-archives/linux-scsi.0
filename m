Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6A4AC433DB
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Mar 2021 02:30:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 728F864EE1
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Mar 2021 02:30:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230157AbhCRC3j (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Mar 2021 22:29:39 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:64534 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230260AbhCRC3h (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Mar 2021 22:29:37 -0400
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20210318022936epoutp030a15a9d4476c13e4ccc5234dd65e82c8~tTuKCx1U10919609196epoutp03-
        for <linux-scsi@vger.kernel.org>; Thu, 18 Mar 2021 02:29:36 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20210318022936epoutp030a15a9d4476c13e4ccc5234dd65e82c8~tTuKCx1U10919609196epoutp03-
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1616034576;
        bh=9ZrCd8nK9J373EMAX2Viia45bJMH2qB0e2lYh0RmLYI=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=WI9YUM+Vf/fXeQqzr1DiwnswgvRQ1ibSdCPGnLSWDLGhphW+GdEPOLYL8SBuJ1i3q
         +DihSDL9Pw4/izPpI9jB1ELjhgWnRtiUl5aRVwvuapDvRcLE9TS8m000iu45El6FSc
         XA5ejZ+39o2X16eV7AP/TIC47mauI3kNLzO1uH0s=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTP id
        20210318022935epcas2p119ac3c6c56cdfff3a4ea52871d194082~tTuJNjJ4w0607906079epcas2p1b;
        Thu, 18 Mar 2021 02:29:35 +0000 (GMT)
Received: from epsmges2p2.samsung.com (unknown [182.195.40.183]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4F19vx2HxZz4x9Px; Thu, 18 Mar
        2021 02:29:33 +0000 (GMT)
X-AuditID: b6c32a46-1efff7000000dbf8-e7-6052bb0d630b
Received: from epcas2p2.samsung.com ( [182.195.41.54]) by
        epsmges2p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        C9.A2.56312.D0BB2506; Thu, 18 Mar 2021 11:29:33 +0900 (KST)
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
In-Reply-To: <9c2be83e3fe9de29c503318053fd7fdd@codeaurora.org>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20210318022932epcms2p8af00b2547e5051b59780df3ecf99c3a7@epcms2p8>
Date:   Thu, 18 Mar 2021 11:29:32 +0900
X-CMS-MailID: 20210318022932epcms2p8af00b2547e5051b59780df3ecf99c3a7
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
CMS-TYPE: 102P
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrPJsWRmVeSWpSXmKPExsWy7bCmmS7v7qAEg483OSwezNvGZrG37QS7
        xcufV9ksDt9+x24x7cNPZotP65exWrw8pGmx6kG4RfPi9WwWc842MFn09m9ls3h85zO7xaIb
        25gs+v+1s1hc3jWHzaL7+g42i+XH/zFZ3N7CZbF0601Gi87pa1gcRDwuX/H2uNzXy+Sxc9Zd
        do8Jiw4weuyfu4bdo+XkfhaPj09vsXj0bVnF6PF5k5xH+4FupgCuqBybjNTElNQihdS85PyU
        zLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKDnlBTKEnNKgUIBicXFSvp2NkX5
        pSWpChn5xSW2SqkFKTkFhoYFesWJucWleel6yfm5VoYGBkamQJUJORlTj25iL3jTxlgxbcpi
        pgbG/0ldjJwcEgImEhsPfWTuYuTiEBLYwSjx5N101i5GDg5eAUGJvzuEQWqEBewlvm7Yxgpi
        CwkoSay/OIsdIq4ncevhGkYQm01AR2L6iftgcREBT4mvk1ezgsxkFljOJtG4bD8rxDJeiRnt
        T1kgbGmJ7cu3gjVzCthJ7J78GyquIfFjWS8zhC0qcXP1W3YY+/2x+YwQtohE672zUDWCEg9+
        7oaKS0oc2/2BCcKul9h65xcjyBESAj2MEod33oI6Ql/iWsdGsGW8Ar4SX58tALNZBFQl2lrm
        sEHUuEi0HpsLNohZQF5i+9s5zKBAYRbQlFi/Sx/ElBBQljhyiwXmrYaNv9nR2cwCfBIdh//C
        xXfMewJ1mprEup/rmSYwKs9ChPQsJLtmIexawMi8ilEstaA4Nz212KjACDl2NzGCU7qW2w7G
        KW8/6B1iZOJgPMQowcGsJMJrmheQIMSbklhZlVqUH19UmpNafIjRFOjLicxSosn5wKySVxJv
        aGpkZmZgaWphamZkoSTOW2zwIF5IID2xJDU7NbUgtQimj4mDU6qBafLajoeKWQH15jslMvSl
        7D8nxbJc9ki+FH/6WP7re5dM913M3PqbZc1+XbFFd4V2Hzjbo3VOyX4pc9Y/1rUiAutnNgu/
        /H1W3Tydi1vzTnGu95qFQrVT9Ld9l7Lf2uJQ1atqb9Fxtq50/pHzL+8GvTx8QPN47K5XmlFn
        p2RcmF1zy+38Hw6JLzM9L0aHzbbSEv8WoB338vjSWV8XfYxmu1cV4HvR4X/4jZxnSmuX1nA9
        4qs88FezTG1aTUvl/eyjIRtXVjUJ67zJTf/xS/y1/fW5+w68O7u5Jtry3IVuDYbWxy7d/LpS
        h2MireYv5pvcuOKQzl7e9fISz9fyZUWfbetIeLdYa8/ExfWKdsU9t5VYijMSDbWYi4oTAW+v
        zYlyBAAA
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210315012850epcms2p361447b689e925561c48aa9ca54434eb5
References: <9c2be83e3fe9de29c503318053fd7fdd@codeaurora.org>
        <79aea8a80c1be2ff7f05683c2f4918ce@codeaurora.org>
        <a18909e8f4db023455b7513bf6c60312@codeaurora.org>
        <2da1c963bd3ff5f682d18a251ed08989@codeaurora.org>
        <20210315012850epcms2p361447b689e925561c48aa9ca54434eb5@epcms2p3>
        <20210315013137epcms2p861f06e66be9faff32b6648401778434a@epcms2p8>
        <20210315070728epcms2p87136c86803afa85a441ead524130245c@epcms2p8>
        <d6a4511fd85e6e47c5aef22e335bb253@codeaurora.org>
        <20210317014253epcms2p1f45db6a281645282e1540e0070999d73@epcms2p1>
        <20210318020243epcms2p8259fa1d5e99e3c463c6b9e9106693476@epcms2p8>
        <CGME20210315012850epcms2p361447b689e925561c48aa9ca54434eb5@epcms2p8>
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
>> 
> 
>Can you share the change through attechment?

Sure,

diff --git a/drivers/scsi/ufs/ufshpb.c b/drivers/scsi/ufs/ufshpb.c
index 3522197b977e..7288eda44018 100644
--- a/drivers/scsi/ufs/ufshpb.c
+++ b/drivers/scsi/ufs/ufshpb.c
@@ -335,7 +335,7 @@ static inline void ufshpb_put_pre_req(struct ufshpb_lu *hpb,
                                      struct ufshpb_req *pre_req)
 {
        pre_req->req = NULL;
-       pre_req->bio = NULL;
+       //pre_req->bio = NULL;
        list_add_tail(&pre_req->list_req, &hpb->lh_pre_req_free);
        hpb->num_inflight_pre_req--;
 }
@@ -363,7 +363,6 @@ static void ufshpb_pre_req_compl_fn(struct request *req, blk_status_t error)
                        sshdr.byte6, sshdr.additional_length);
        }

-       bio_put(pre_req->bio);
        blk_mq_free_request(req);
        spin_lock_irqsave(&hpb->rgn_state_lock, flags);
        ufshpb_put_pre_req(pre_req->hpb, pre_req);
@@ -427,27 +426,14 @@ static int ufshpb_prep_entry(struct ufshpb_req *pre_req, struct page *page)
 }

 static int ufshpb_pre_req_add_bio_page(struct ufshpb_lu *hpb,
-                                      struct request_queue *q,
                                       struct ufshpb_req *pre_req)
 {
-       struct page *page = pre_req->wb.m_page;
-       struct bio *bio = pre_req->bio;
-       int entries_bytes, ret;
-
-       if (!page)
+       if (!pre_req->wb.m_page)
                return -ENOMEM;

-       if (ufshpb_prep_entry(pre_req, page))
+       if (ufshpb_prep_entry(pre_req, pre_req->wb.m_page))
                return -ENOMEM;

-       entries_bytes = pre_req->wb.len * sizeof(u64);
-
-       ret = bio_add_pc_page(q, bio, page, entries_bytes, 0);
-       if (ret != entries_bytes) {
-               dev_err(&hpb->sdev_ufs_lu->sdev_dev,
-                       "bio_add_pc_page fail: %d", ret);
-               return -ENOMEM;
-       }
        return 0;
 }

@@ -472,7 +458,7 @@ static int ufshpb_execute_pre_req(struct ufshpb_lu *hpb, struct scsi_cmnd *cmd,
                                             blk_rq_pos(cmd->request));
        pre_req->wb.len = sectors_to_logical(cmd->device,
                                             blk_rq_sectors(cmd->request));
-       if (ufshpb_pre_req_add_bio_page(hpb, q, pre_req))
+       if (ufshpb_pre_req_add_bio_page(hpb, pre_req))
                return -ENOMEM;

        req = pre_req->req;
@@ -482,7 +468,7 @@ static int ufshpb_execute_pre_req(struct ufshpb_lu *hpb, struct scsi_cmnd *cmd,
        req->rq_disk = NULL;
        req->end_io_data = (void *)pre_req;
        req->end_io = ufshpb_pre_req_compl_fn;
-
+       dev_err(&hpb->sdev_ufs_lu->sdev_dev, "bi vcnt %d\n",bio->bi_vcnt);
        /* 2. scsi_request setup */
        rq = scsi_req(req);
        rq->retries = 1;
@@ -504,7 +490,6 @@ static int ufshpb_issue_pre_req(struct ufshpb_lu *hpb, struct scsi_cmnd *cmd,
 {
        struct ufshpb_req *pre_req;
        struct request *req = NULL;
-       struct bio *bio = NULL;
        unsigned long flags;
        int _read_id;
        int ret = 0;
@@ -514,12 +499,6 @@ static int ufshpb_issue_pre_req(struct ufshpb_lu *hpb, struct scsi_cmnd *cmd,
        if (IS_ERR(req))
                return -EAGAIN;

-       bio = bio_alloc(GFP_ATOMIC, 1);
-       if (!bio) {
-               blk_put_request(req);
-               return -EAGAIN;
-       }
-
        spin_lock_irqsave(&hpb->rgn_state_lock, flags);
        pre_req = ufshpb_get_pre_req(hpb);
        if (!pre_req) {
@@ -530,7 +509,7 @@ static int ufshpb_issue_pre_req(struct ufshpb_lu *hpb, struct scsi_cmnd *cmd,
        spin_unlock_irqrestore(&hpb->rgn_state_lock, flags);

        pre_req->req = req;
-       pre_req->bio = bio;
+       dev_err(&hpb->sdev_ufs_lu->sdev_dev,"bio->bi_vcnt %d\n",pre_req->bio->bi_vcnt);

        ret = ufshpb_execute_pre_req(hpb, cmd, pre_req, _read_id);
        if (ret)
@@ -544,7 +523,6 @@ static int ufshpb_issue_pre_req(struct ufshpb_lu *hpb, struct scsi_cmnd *cmd,
        ufshpb_put_pre_req(hpb, pre_req);
 unlock_out:
        spin_unlock_irqrestore(&hpb->rgn_state_lock, flags);
-       bio_put(bio);
        blk_put_request(req);
        return ret;
 }
@@ -625,7 +603,6 @@ int ufshpb_prep(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
                dev_err(hba->dev, "get ppn failed. err %d\n", err);
                return err;
        }
-
        if (!ufshpb_is_legacy(hba) &&
            ufshpb_is_required_wb(hpb, transfer_len)) {
                err = ufshpb_issue_pre_req(hpb, cmd, &read_id);
@@ -1809,9 +1786,9 @@ struct attribute_group ufs_sysfs_hpb_param_group = {

 static int ufshpb_pre_req_mempool_init(struct ufshpb_lu *hpb)
 {
-       struct ufshpb_req *pre_req = NULL;
+       struct ufshpb_req *pre_req = NULL, *t;
        int qd = hpb->sdev_ufs_lu->queue_depth / 2;
-       int i, j;
+       int i;

        INIT_LIST_HEAD(&hpb->lh_pre_req_free);

@@ -1823,23 +1800,46 @@ static int ufshpb_pre_req_mempool_init(struct ufshpb_lu *hpb)
                goto release_mem;

        for (i = 0; i < qd; i++) {
+               int ret;
+
                pre_req = hpb->pre_req + i;
                INIT_LIST_HEAD(&pre_req->list_req);
                pre_req->req = NULL;
-               pre_req->bio = NULL;
+
+               pre_req->bio = bio_alloc(GFP_KERNEL, 1);
+               if (!pre_req->bio)
+                       goto release_mem;

                pre_req->wb.m_page = alloc_page(GFP_KERNEL | __GFP_ZERO);
                if (!pre_req->wb.m_page) {
-                       for (j = 0; j < i; j++)
-                               __free_page(hpb->pre_req[j].wb.m_page);
+                       bio_put(pre_req->bio);
+                       goto release_mem;
+               }
+
+               ret = bio_add_pc_page(hpb->sdev_ufs_lu->request_queue,
+                                     pre_req->bio, pre_req->wb.m_page,
+                                     PAGE_SIZE, 0);
+               dev_err(&hpb->sdev_ufs_lu->sdev_dev,"bio->bi_vcnt %d\n",pre_req->bio->bi_vcnt);
+               if (ret != PAGE_SIZE) {
+                       dev_err(&hpb->sdev_ufs_lu->sdev_dev,
+                               "bio_add_pc_page fail: %d", ret);

+                       bio_put(pre_req->bio);
+                       __free_page(pre_req->wb.m_page);
                        goto release_mem;
                }
+
                list_add_tail(&pre_req->list_req, &hpb->lh_pre_req_free);
        }

        return 0;
 release_mem:
+       list_for_each_entry_safe(pre_req, t, &hpb->lh_pre_req_free, list_req) {
+               list_del_init(&pre_req->list_req);
+               bio_put(pre_req->bio);
+               __free_page(pre_req->wb.m_page);
+       }
+
        kfree(hpb->pre_req);
        return -ENOMEM;
 }
@@ -1851,6 +1851,7 @@ static void ufshpb_pre_req_mempool_destroy(struct ufshpb_lu *hpb)

        for (i = 0; i < hpb->throttle_pre_req; i++) {
                pre_req = hpb->pre_req + i;
+               bio_put(hpb->pre_req[i].bio);
                if (!pre_req->wb.m_page)
                        __free_page(hpb->pre_req[i].wb.m_page);
                list_del_init(&pre_req->list_req);



>Thanks,
>Can Guo.
> 
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
