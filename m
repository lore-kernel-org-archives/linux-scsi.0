Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 752ACC433C1
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Mar 2021 06:48:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3CF3B619B7
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Mar 2021 06:48:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229920AbhCWGsX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 23 Mar 2021 02:48:23 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:14056 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229500AbhCWGru (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 23 Mar 2021 02:47:50 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1616482070; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=GQDRjKMzMn2+736kUV4uRKS35DZD8tV3wfgPO5h+uR0=;
 b=u53rk7vTftVLJrjPbyYj1pwPWlnHFyl8os3BObeFSyHZ45VEtpQIAYvWJ/tX1U/mw15tNd5e
 QDslMln+1Eo8XVT2afwVjj7Ta+CGUabAfGxmsOR/lAX3ZjeC6Ai1Mmq92wVRDwkO3bx9hDCU
 VCyUZXcxvWSG2rSW/S8FZr/VrzY=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-west-2.postgun.com with SMTP id
 60598f072b0e10a0bac653be (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 23 Mar 2021 06:47:35
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 3F706C433C6; Tue, 23 Mar 2021 06:47:35 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 10FB9C433CA;
        Tue, 23 Mar 2021 06:47:32 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Tue, 23 Mar 2021 14:47:32 +0800
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
In-Reply-To: <20210323063726epcms2p28aadb16bb96943ade1d2b288bb634811@epcms2p2>
References: <f224bea78cf235ee94823528f07e28a6@codeaurora.org>
 <1df7bb51dc481c3141cdcf85105d3a5b@codeaurora.org>
 <e9b912bca9fd48c9b2fd76bea80439ae@codeaurora.org>
 <20210322065127epcms2p5021a61416a6b427c62fcaf5d8b660860@epcms2p5>
 <20210322065410epcms2p431f73262f508e9e3e16bd4995db56a4b@epcms2p4>
 <75df140d2167eadf1089d014f571d711a9aeb6a5.camel@gmail.com>
 <d6a032261a642a4afed80188ea4772ee@codeaurora.org>
 <20210323053731epcms2p70788f357b546e9ca21248175a8884554@epcms2p7>
 <20210323061922epcms2p739666492ebb458d70deab026d074caf4@epcms2p7>
 <CGME20210322065127epcms2p5021a61416a6b427c62fcaf5d8b660860@epcms2p2>
 <20210323063726epcms2p28aadb16bb96943ade1d2b288bb634811@epcms2p2>
Message-ID: <a9017bbb57618c5560b21c1cdadb4f80@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021-03-23 14:37, Daejun Park wrote:
>> On 2021-03-23 14:19, Daejun Park wrote:
>>>> On 2021-03-23 13:37, Daejun Park wrote:
>>>>>> On 2021-03-23 12:22, Can Guo wrote:
>>>>>>> On 2021-03-22 17:11, Bean Huo wrote:
>>>>>>>> On Mon, 2021-03-22 at 15:54 +0900, Daejun Park wrote:
>>>>>>>>> +       switch (rsp_field->hpb_op) {
>>>>>>>>> 
>>>>>>>>> +       case HPB_RSP_REQ_REGION_UPDATE:
>>>>>>>>> 
>>>>>>>>> +               if (data_seg_len != DEV_DATA_SEG_LEN)
>>>>>>>>> 
>>>>>>>>> +                       dev_warn(&hpb->sdev_ufs_lu->sdev_dev,
>>>>>>>>> 
>>>>>>>>> +                                "%s: data seg length is not
>>>>>>>>> same.\n",
>>>>>>>>> 
>>>>>>>>> +                                __func__);
>>>>>>>>> 
>>>>>>>>> +               ufshpb_rsp_req_region_update(hpb, rsp_field);
>>>>>>>>> 
>>>>>>>>> +               break;
>>>>>>>>> 
>>>>>>>>> +       case HPB_RSP_DEV_RESET:
>>>>>>>>> 
>>>>>>>>> +               dev_warn(&hpb->sdev_ufs_lu->sdev_dev,
>>>>>>>>> 
>>>>>>>>> +                        "UFS device lost HPB information 
>>>>>>>>> during
>>>>>>>>> PM.\n");
>>>>>>>>> 
>>>>>>>>> +               break;
>>>>>>>> 
>>>>>>>> Hi Deajun,
>>>>>>>> This series looks good to me. Just here I have one question. You
>>>>>>>> didn't
>>>>>>>> handle HPB_RSP_DEV_RESET, just a warning.  Based on your SS UFS,
>>>>>>>> how
>>>>>>>> to
>>>>>>>> handle HPB_RSP_DEV_RESET from the host side? Do you think we 
>>>>>>>> shoud
>>>>>>>> reset host side HPB entry as well or what else?
>>>>>>>> 
>>>>>>>> 
>>>>>>>> Bean
>>>>>>> 
>>>>>>> Same question here - I am still collecting feedbacks from flash
>>>>>>> vendors
>>>>>>> about
>>>>>>> what is recommanded host behavior on reception of HPB Op code 
>>>>>>> 0x2,
>>>>>>> since it
>>>>>>> is not cleared defined in HPB2.0 specs.
>>>>>>> 
>>>>>>> Can Guo.
>>>>>> 
>>>>>> I think the question should be asked in the HPB2.0 patch, since in
>>>>>> HPB1.0 device
>>>>>> control mode, a HPB reset in device side does not impact anything 
>>>>>> in
>>>>>> host side -
>>>>>> host is not writing back any HPB entries to device anyways and HPB
>>>>>> Read
>>>>>> cmd with
>>>>>> invalid HPB entries shall be treated as normal Read(10) cmd 
>>>>>> without
>>>>>> any
>>>>>> problems.
>>>>> 
>>>>> Yes, UFS device will process read command even the HPB entries are
>>>>> valid or
>>>>> not. So it is warning about read performance drop by dev reset.
>>>> 
>>>> Yeah, but still I am 100% sure about what should host do in case of
>>>> HPB2.0
>>>> when it receives HPB Op code 0x2, I am waiting for feedbacks.
>>> 
>>> I think the host has two choices when it receives 0x2.
>>> One is nothing on host.
>>> The other is discarding all HPB entries in the host.
>>> 
>>> In the JEDEC HPB spec, it as follows:
>>> When the device is powered off by the host, the device may restore 
>>> L2P
>>> map
>>> data upon power up or build from the host’s HPB READ command.
>>> 
>>> If some UFS builds L2P map data from the host's HPB READ commands, we
>>> don't
>>> have to discard HPB entries in the host.
>>> 
>>> So I thinks there is nothing to do when it receives 0x2.
>> 
>> But in HPB2.0, if we do nothing to active regions in host side, host 
>> can
>> write
>> HPB entries (which host thinks valid, but actually invalid in device
>> side since
>> reset happened) back to device through HPB Write Buffer cmds (BUFFER 
>> ID
>> = 0x2).
>> My question is that are all UFSs OK with this?
> 
> Yes, it must be OK.
> 
> Please refer the following the HPB 2.0 spec:
> 
> If the HPB Entries sent by HPB WRITE BUFFER are removed by the device,
> for example, because they are not consumed for a long enough period of 
> time,
> then the HPB READ command for the removed HPB entries shall be handled 
> as a
> normal READ command.
> 

No, it is talking about the subsequent HPB READ cmd sent after a HPB 
WRITE BUFFER cmd,
but not the HPB WRITE BUFFER cmd itself...

Thanks,
Can Guo.

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
>>>> Thanks,
>>>> Can Guo.
>>>> 
>>>>> 
>>>>> Thanks,
>>>>> Daejun
>>>>> 
>>>>>> Please correct me if I am wrong.
>>>>> 
>>>>> 
>>>>> 
>>>>>> Thanks,
>>>>>> Can Guo.
>>>>>> 
>>>>>> 
>>>>>> 
>>>> 
>>>> 
>>>> 
>> 
>> 
>> 
