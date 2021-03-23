Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63837C433E0
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Mar 2021 06:12:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2BFCE619B4
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Mar 2021 06:12:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229590AbhCWGHN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 23 Mar 2021 02:07:13 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:25990 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229437AbhCWGHJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 23 Mar 2021 02:07:09 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1616479629; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=rXI6ox2+IZMGJEKwTCSVJrsayqWDTIvB/El8Dnh3JbM=;
 b=dKk62noGm8qHzXXJPRqf9GBOVgRwpnl6eCHLqoAEwDBykPLRPRv7XM2pL63S7BAnQEltCw/2
 Yaenbu79gltdOfyOQyTPqZn9n3jHsAvILDAKsk18dMt/5vPi0pyomdleByNBOfNMHW42d7CQ
 NUbNc6PoESLMsZQGKrs6clfbyVw=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n05.prod.us-west-2.postgun.com with SMTP id
 60598585c32ceb3a917a8e5f (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 23 Mar 2021 06:07:01
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id B318CC433ED; Tue, 23 Mar 2021 06:07:01 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id BEC2AC433CA;
        Tue, 23 Mar 2021 06:07:00 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 23 Mar 2021 14:07:00 +0800
From:   Can Guo <cang@codeaurora.org>
To:     daejun7.park@samsung.com
Cc:     Bean Huo <huobean@gmail.com>, Greg KH <gregkh@linuxfoundation.org>,
        avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, asutoshd@codeaurora.org,
        stanley.chu@mediatek.com, bvanassche@acm.org,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        ALIM AKHTAR <alim.akhtar@samsung.com>,
        JinHwan Park <jh.i.park@samsung.com>,
        Javier Gonzalez <javier.gonz@samsung.com>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        Dukhyun Kwon <d_hyun.kwon@samsung.com>,
        Keoseong Park <keosung.park@samsung.com>,
        Jaemyung Lee <jaemyung.lee@samsung.com>,
        Jieon Seol <jieon.seol@samsung.com>
Subject: Re: [PATCH v31 2/4] scsi: ufs: L2P map management for HPB read
In-Reply-To: <20210323053731epcms2p70788f357b546e9ca21248175a8884554@epcms2p7>
References: <e9b912bca9fd48c9b2fd76bea80439ae@codeaurora.org>
 <20210322065127epcms2p5021a61416a6b427c62fcaf5d8b660860@epcms2p5>
 <20210322065410epcms2p431f73262f508e9e3e16bd4995db56a4b@epcms2p4>
 <75df140d2167eadf1089d014f571d711a9aeb6a5.camel@gmail.com>
 <d6a032261a642a4afed80188ea4772ee@codeaurora.org>
 <CGME20210322065127epcms2p5021a61416a6b427c62fcaf5d8b660860@epcms2p7>
 <20210323053731epcms2p70788f357b546e9ca21248175a8884554@epcms2p7>
Message-ID: <1df7bb51dc481c3141cdcf85105d3a5b@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021-03-23 13:37, Daejun Park wrote:
>> On 2021-03-23 12:22, Can Guo wrote:
>>> On 2021-03-22 17:11, Bean Huo wrote:
>>>> On Mon, 2021-03-22 at 15:54 +0900, Daejun Park wrote:
>>>>> +       switch (rsp_field->hpb_op) {
>>>>> 
>>>>> +       case HPB_RSP_REQ_REGION_UPDATE:
>>>>> 
>>>>> +               if (data_seg_len != DEV_DATA_SEG_LEN)
>>>>> 
>>>>> +                       dev_warn(&hpb->sdev_ufs_lu->sdev_dev,
>>>>> 
>>>>> +                                "%s: data seg length is not
>>>>> same.\n",
>>>>> 
>>>>> +                                __func__);
>>>>> 
>>>>> +               ufshpb_rsp_req_region_update(hpb, rsp_field);
>>>>> 
>>>>> +               break;
>>>>> 
>>>>> +       case HPB_RSP_DEV_RESET:
>>>>> 
>>>>> +               dev_warn(&hpb->sdev_ufs_lu->sdev_dev,
>>>>> 
>>>>> +                        "UFS device lost HPB information during
>>>>> PM.\n");
>>>>> 
>>>>> +               break;
>>>> 
>>>> Hi Deajun,
>>>> This series looks good to me. Just here I have one question. You
>>>> didn't
>>>> handle HPB_RSP_DEV_RESET, just a warning.  Based on your SS UFS, how
>>>> to
>>>> handle HPB_RSP_DEV_RESET from the host side? Do you think we shoud
>>>> reset host side HPB entry as well or what else?
>>>> 
>>>> 
>>>> Bean
>>> 
>>> Same question here - I am still collecting feedbacks from flash 
>>> vendors
>>> about
>>> what is recommanded host behavior on reception of HPB Op code 0x2,
>>> since it
>>> is not cleared defined in HPB2.0 specs.
>>> 
>>> Can Guo.
>> 
>> I think the question should be asked in the HPB2.0 patch, since in
>> HPB1.0 device
>> control mode, a HPB reset in device side does not impact anything in
>> host side -
>> host is not writing back any HPB entries to device anyways and HPB 
>> Read
>> cmd with
>> invalid HPB entries shall be treated as normal Read(10) cmd without 
>> any
>> problems.
> 
> Yes, UFS device will process read command even the HPB entries are 
> valid or
> not. So it is warning about read performance drop by dev reset.

Yeah, but still I am 100% sure about what should host do in case of 
HPB2.0
when it receives HPB Op code 0x2, I am waiting for feedbacks.

Thanks,
Can Guo.

> 
> Thanks,
> Daejun
> 
>> Please correct me if I am wrong.
> 
> 
> 
>> Thanks,
>> Can Guo.
>> 
>> 
>> 
