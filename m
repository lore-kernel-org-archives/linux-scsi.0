Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32DE2C433E0
	for <linux-scsi@archiver.kernel.org>; Mon, 15 Mar 2021 07:47:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 004A464E6B
	for <linux-scsi@archiver.kernel.org>; Mon, 15 Mar 2021 07:47:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230114AbhCOHrR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 15 Mar 2021 03:47:17 -0400
Received: from z11.mailgun.us ([104.130.96.11]:14370 "EHLO z11.mailgun.us"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230028AbhCOHrF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 15 Mar 2021 03:47:05 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1615794425; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=GQH/kOHUpisLYvOdA5Xbp3StY6qFqGdxoPdlOf0xsLg=;
 b=JONCL/zo2ko0SbdDkOr4oDsK3iHYR4Dc0Io3QoZBZ6uKPjCWoQyG71ToQYV+2JKn6W2qzHHW
 O5SMqbhAPWNas2A3gEVGcPDo6XBMrfvEkjmxfsCy8YsiwOJ7yQt2emXn4+yOO4gLncKQlFp7
 MDaqhOJVppLhlctxsOMbesyTg7U=
X-Mailgun-Sending-Ip: 104.130.96.11
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n05.prod.us-east-1.postgun.com with SMTP id
 604f10f84db3bb68012044c3 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 15 Mar 2021 07:47:04
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 0F27DC43462; Mon, 15 Mar 2021 07:47:04 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 37026C433CA;
        Mon, 15 Mar 2021 07:47:02 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 15 Mar 2021 15:47:02 +0800
From:   Can Guo <cang@codeaurora.org>
To:     daejun7.park@samsung.com
Cc:     Greg KH <gregkh@linuxfoundation.org>, avri.altman@wdc.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        asutoshd@codeaurora.org, stanley.chu@mediatek.com,
        bvanassche@acm.org, huobean@gmail.com,
        ALIM AKHTAR <alim.akhtar@samsung.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        JinHwan Park <jh.i.park@samsung.com>,
        Javier Gonzalez <javier.gonz@samsung.com>,
        SEUNGUK SHIN <seunguk.shin@samsung.com>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>
Subject: Re: [PATCH v29 4/4] scsi: ufs: Add HPB 2.0 support
In-Reply-To: <d6a4511fd85e6e47c5aef22e335bb253@codeaurora.org>
References: <2da1c963bd3ff5f682d18a251ed08989@codeaurora.org>
 <20210315012850epcms2p361447b689e925561c48aa9ca54434eb5@epcms2p3>
 <20210315013137epcms2p861f06e66be9faff32b6648401778434a@epcms2p8>
 <CGME20210315012850epcms2p361447b689e925561c48aa9ca54434eb5@epcms2p8>
 <20210315070728epcms2p87136c86803afa85a441ead524130245c@epcms2p8>
 <d6a4511fd85e6e47c5aef22e335bb253@codeaurora.org>
Message-ID: <a18909e8f4db023455b7513bf6c60312@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021-03-15 15:23, Can Guo wrote:
> On 2021-03-15 15:07, Daejun Park wrote:
>>>> This patch supports the HPB 2.0.
>>>> 
>>>> The HPB 2.0 supports read of varying sizes from 4KB to 512KB.
>>>> In the case of Read (<= 32KB) is supported as single HPB read.
>>>> In the case of Read (36KB ~ 512KB) is supported by as a combination 
>>>> of
>>>> write buffer command and HPB read command to deliver more PPN.
>>>> The write buffer commands may not be issued immediately due to busy
>>>> tags.
>>>> To use HPB read more aggressively, the driver can requeue the write
>>>> buffer
>>>> command. The requeue threshold is implemented as timeout and can be
>>>> modified with requeue_timeout_ms entry in sysfs.
>>>> 
>>>> Signed-off-by: Daejun Park <daejun7.park@samsung.com>
>>>> ---
>>>> +static struct attribute *hpb_dev_param_attrs[] = {
>>>> +        &dev_attr_requeue_timeout_ms.attr,
>>>> +        NULL,
>>>> +};
>>>> +
>>>> +struct attribute_group ufs_sysfs_hpb_param_group = {
>>>> +        .name = "hpb_param_sysfs",
>>>> +        .attrs = hpb_dev_param_attrs,
>>>> +};
>>>> +
>>>> +static int ufshpb_pre_req_mempool_init(struct ufshpb_lu *hpb)
>>>> +{
>>>> +        struct ufshpb_req *pre_req = NULL;
>>>> +        int qd = hpb->sdev_ufs_lu->queue_depth / 2;
>>>> +        int i, j;
>>>> +
>>>> +        INIT_LIST_HEAD(&hpb->lh_pre_req_free);
>>>> +
>>>> +        hpb->pre_req = kcalloc(qd, sizeof(struct ufshpb_req), 
>>>> GFP_KERNEL);
>>>> +        hpb->throttle_pre_req = qd;
>>>> +        hpb->num_inflight_pre_req = 0;
>>>> +
>>>> +        if (!hpb->pre_req)
>>>> +                goto release_mem;
>>>> +
>>>> +        for (i = 0; i < qd; i++) {
>>>> +                pre_req = hpb->pre_req + i;
>>>> +                INIT_LIST_HEAD(&pre_req->list_req);
>>>> +                pre_req->req = NULL;
>>>> +                pre_req->bio = NULL;
>>> 
>>> Why don't prepare bio as same as wb.m_page? Won't that save more time
>>> for ufshpb_issue_pre_req()?
>> 
>> It is pre_req pool. So although we prepare bio at this time, it just
>> only for first pre_req.
> 
> I meant removing the bio_alloc() in ufshpb_issue_pre_req() and 
> bio_put()
> in ufshpb_pre_req_compl_fn(). bios, in pre_req's case, just hold a 
> page.
> So, prepare 16 (if queue depth is 32) bios here, just use them along 
> with
> wb.m_page and call bio_reset() in ufshpb_pre_req_compl_fn(). Shall it 
> work?
> 

If it works, you can even have the bio_add_pc_page() called here. Later 
in
ufshpb_execute_pre_req(), you don't need to call 
ufshpb_pre_req_add_bio_page(),
just call ufshpb_prep_entry() once instead - it save many repeated steps 
for a
pre_req, and you don't even need to call bio_reset() in this case, since 
for a
bio, nothing changes after it is binded with a specific page...

Can Guo.

> Thanks,
> Can Guo.
> 
>> After use it, it should be prepared bio at issue phase.
>> 
>> Thanks,
>> Daejun
>> 
>>> 
>>> Thanks,
>>> Can Guo.
>>> 
>>>> +
>>>> +                pre_req->wb.m_page = alloc_page(GFP_KERNEL | 
>>>> __GFP_ZERO);
>>>> +                if (!pre_req->wb.m_page) {
>>>> +                        for (j = 0; j < i; j++)
>>>> +                                
>>>> __free_page(hpb->pre_req[j].wb.m_page);
>>>> +
>>>> +                        goto release_mem;
>>>> +                }
>>>> +                list_add_tail(&pre_req->list_req, 
>>>> &hpb->lh_pre_req_free);
>>>> +        }
>>>> +
>>>> +        return 0;
>>>> +release_mem:
>>>> +        kfree(hpb->pre_req);
>>>> +        return -ENOMEM;
>>>> +}
>>>> +
>>> 
>>> 
>>> 
