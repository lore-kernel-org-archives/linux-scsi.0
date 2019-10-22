Return-Path: <SRS0=5qjn=YP=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC52ACA9EB0
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Oct 2019 01:59:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AC15322475
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Oct 2019 01:59:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387670AbfJVB75 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 21 Oct 2019 21:59:57 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:36060 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387651AbfJVB74 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 21 Oct 2019 21:59:56 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 814A59BA869A78E425DB;
        Tue, 22 Oct 2019 09:59:53 +0800 (CST)
Received: from [127.0.0.1] (10.184.213.217) by DGGEMS403-HUB.china.huawei.com
 (10.3.19.203) with Microsoft SMTP Server id 14.3.439.0; Tue, 22 Oct 2019
 09:59:45 +0800
Subject: Re: [PATCH v5 00/13] scsi: core: fix uninit-value access of variable
 sshdr
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     <bvanassche@acm.org>, <jejb@linux.ibm.com>,
        <linux-scsi@vger.kernel.org>, <yi.zhang@huawei.com>,
        <yanaijie@huawei.com>, Johannes Thumshirn <jthumshirn@suse.de>
References: <1571387071-28853-1-git-send-email-zhengbin13@huawei.com>
 <f9c663fe-6359-fc7b-e9f5-cf173f6fafbe@suse.de> <yq1lftii2yi.fsf@oracle.com>
 <b09013a1-648e-7cfc-9751-fc955161aba4@huawei.com>
 <75974004-7216-b035-123b-b1d88e6561e4@suse.de>
From:   "zhengbin (A)" <zhengbin13@huawei.com>
Message-ID: <f3c9b935-07a5-6055-e60b-e2b86eb54c80@huawei.com>
Date:   Tue, 22 Oct 2019 09:59:08 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.0
MIME-Version: 1.0
In-Reply-To: <75974004-7216-b035-123b-b1d88e6561e4@suse.de>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [10.184.213.217]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


On 2019/10/21 21:06, Hannes Reinecke wrote:
> On 10/21/19 3:49 AM, zhengbin (A) wrote:
>> On 2019/10/18 21:43, Martin K. Petersen wrote:
>>> Hannes,
>>>
>>>> The one thing which I patently don't like is the ambivalence between
>>>> DRIVER_SENSE and scsi_sense_valid().  What shall we do if only _one_
>>>> of them is set?  IE what would be the correct way of action if
>>>> DRIVER_SENSE is not set, but we have a valid sense code?  Or the other
>>>> way around?
>>> I agree, it's a mess.
>>>
>>> (Sorry, zhengbin, you opened a can of worms. This is some of our oldest
>>> and most arcane code in SCSI)
>>>
>>>> But more important, from a quick glance not all drivers set the
>>>> DRIVER_SENSE bit; so for things like hpsa or smartpqi the sense code is
>>>> never evaluated after this patchset.
>>> And yet we appear to have several code paths where sense evaluation is
>>> contingent on DRIVER_SENSE. So no matter what, behavior might
>>> change if we enforce consistent semantics. *sigh*
>> So what should we do to prevent unit-value access of sshdr?
>>
> Where do you see it?
> >From my reading, __scsi_execute() is clearing sshdr by way of
>
> __scsi_execute()
> -> scsi_normalize_sense()
>     -> memset(sshdr)

__scsi_execute

      req = blk_get_request(sdev->request_queue,
            data_direction == DMA_TO_DEVICE ?
            REQ_OP_SCSI_OUT : REQ_OP_SCSI_IN, BLK_MQ_REQ_PREEMPT);
    if (IS_ERR(req))
        return ret;   -->just return
    rq = scsi_req(req);

    if (bufflen &&    blk_rq_map_kern(sdev->request_queue, req,
                    buffer, bufflen, GFP_NOIO))
        goto out;  -->just goto out

>
> Cheers,
>
> Hannes

