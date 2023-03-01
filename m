Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC365C7EE2D
	for <linux-scsi@archiver.kernel.org>; Wed,  1 Mar 2023 18:55:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229674AbjCASzm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 1 Mar 2023 13:55:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229534AbjCASzk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Mar 2023 13:55:40 -0500
Received: from mail-qt1-x835.google.com (mail-qt1-x835.google.com [IPv6:2607:f8b0:4864:20::835])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31F41206AB
        for <linux-scsi@vger.kernel.org>; Wed,  1 Mar 2023 10:55:39 -0800 (PST)
Received: by mail-qt1-x835.google.com with SMTP id c3so11170563qtc.8
        for <linux-scsi@vger.kernel.org>; Wed, 01 Mar 2023 10:55:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sladewatkins.net; s=googled;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=3TgiKhi42q3wmBGdmYMiHUCevyqh6Uh75vpv8WVPRks=;
        b=Nvam5+nR8S3y+Y2B55SxN0JnRfea2d/xXFDMc2DiAQ4NLLMcC5QtM1IX+bRmoqasi3
         Qo84Th0ptQ4NBDEal1mMUscjKvAWBhR6nNrR/0RAv5un4R2koGPpwdo7jp8xu+vzLYN8
         jlvuTr6W5//iyX4ois4HUaN3/uWk3Ns9wllzCzZp6VSuVAvLbsveFHMGT39+Egp0VMgE
         KoCzt1jYszpGV4c4cMwpmokLmJHmSXnobaURMirxB8nWSHGyJg066X3C5nqGvMCllcHK
         o/TWn80MhVmUIBKYJznLLT3/Si4vfFvA2R0tsnpyN/qvdtmav/eQTvoe7M2FDc19oYXs
         09Ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3TgiKhi42q3wmBGdmYMiHUCevyqh6Uh75vpv8WVPRks=;
        b=MdhRPKWeYfnhAEdhf3wPOvk/hLAbC70C0hV13+0/mE5PIfb+PKruOA1crXz85wQVem
         tlwWuFEhRpY3hpTe/h1r5DA+M+iW+26h9WmMNl2Df3OokFcGyXWgYjK09DzacI6fdde7
         ZYWuKzqj1vwzbba6qXvbjrcjEwqAsYp4HrYCd92QPLmquE0/MKxCI8S/1LnkScmrojBP
         YGW13tPNDBjyjGdgkX5S131lvjiv6pkvVepL7GcktTBO+MwUVFSvd/JOoKQZFrOTvV/E
         jO+Yo8OEVrH8nVjlc7gHSa9X+OBQsdUu9B5PA7Jedath9sFvcMIy62pPA4yTlQYYJitP
         2SFQ==
X-Gm-Message-State: AO0yUKWb2gH8spNP0oMwYOivdQOPdIGkYF9dnulF6N5ejX7jmZGBTd4e
        RLVHwso2Qxa7Dn7N0LaDiwMLmQ==
X-Google-Smtp-Source: AK7set8efE2ic1qDCl5vB6UuSzw5tDGfuj/AWkp5gIlZw4LegN7+lqFUd1Y4loxlJ7hLAeQjAsur5g==
X-Received: by 2002:a05:622a:1650:b0:3b9:ca2b:a923 with SMTP id y16-20020a05622a165000b003b9ca2ba923mr13763023qtj.67.1677696938199;
        Wed, 01 Mar 2023 10:55:38 -0800 (PST)
Received: from ghost.leviathan.sladewatkins.net (pool-108-44-32-49.albyny.fios.verizon.net. [108.44.32.49])
        by smtp.gmail.com with ESMTPSA id x11-20020a05620a0ecb00b00741b312c899sm9390094qkm.6.2023.03.01.10.55.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Mar 2023 10:55:36 -0800 (PST)
Message-ID: <0ac05d7c-a885-2e13-93fc-20a58643abcb@sladewatkins.net>
Date:   Wed, 1 Mar 2023 13:55:32 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
From:   Slade's Kernel Patch Bot <KernelPatchBot@sladewatkins.net>
Subject: Re: [PATCH v2 4/7] scsi: ufs: core: Add hwq print for debug
To:     =?UTF-8?B?UG93ZW4gS2FvICjpq5jkvK/mlocp?= <Powen.Kao@mediatek.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        "quic_nguyenb@quicinc.com" <quic_nguyenb@quicinc.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "quic_ziqichen@quicinc.com" <quic_ziqichen@quicinc.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>
Cc:     =?UTF-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= 
        <peter.wang@mediatek.com>,
        =?UTF-8?B?RWRkaWUgSHVhbmcgKOm7g+aZuuWCkSk=?= 
        <eddie.huang@mediatek.com>,
        =?UTF-8?B?SmlhamllIEhhbyAo6YOd5Yqg6IqCKQ==?= 
        <jiajie.hao@mediatek.com>,
        =?UTF-8?B?Q0MgQ2hvdSAo5ZGo5b+X5p2wKQ==?= <cc.chou@mediatek.com>,
        =?UTF-8?B?QWxpY2UgQ2hhbyAo6LaZ54+u5Z2HKQ==?= 
        <Alice.Chao@mediatek.com>,
        wsd_upstream <wsd_upstream@mediatek.com>,
        =?UTF-8?B?Q2h1bi1IdW5nIFd1ICjlt6vpp7/lro8p?= 
        <Chun-hung.Wu@mediatek.com>,
        "quic_asutoshd@quicinc.com" <quic_asutoshd@quicinc.com>,
        =?UTF-8?B?Q2hhb3RpYW4gSmluZyAo5LqV5pyd5aSpKQ==?= 
        <Chaotian.Jing@mediatek.com>,
        =?UTF-8?B?TmFvbWkgQ2h1ICjmnLHoqaDnlLAp?= <Naomi.Chu@mediatek.com>,
        =?UTF-8?B?U3RhbmxleSBDaHUgKOacseWOn+mZnik=?= 
        <stanley.chu@mediatek.com>,
        =?UTF-8?B?TWFzb24gWmhhbmcgKOeroOi+iSk=?= <Mason.Zhang@mediatek.com>,
        "quic_cang@quicinc.com" <quic_cang@quicinc.com>,
        Slade Watkins <srw@sladewatkins.net>
References: <20230222030427.957-1-powen.kao@mediatek.com>
 <20230222030427.957-5-powen.kao@mediatek.com>
 <1b9c2bc9-a349-062a-597c-336804c05394@quicinc.com>
 <74bedcff32df0c93c14b004814017f3344247528.camel@mediatek.com>
 <0c17dd26-b1aa-54b0-6dc4-561cd996cead@quicinc.com>
 <76f74b86-8ff1-2346-4f5e-0048543bd8b0@quicinc.com>
 <f629f1b72e4859d79aac279ef3327715000e3210.camel@mediatek.com>
Content-Language: en-US
In-Reply-To: <f629f1b72e4859d79aac279ef3327715000e3210.camel@mediatek.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/28/23 21:17, Powen Kao (高伯文) wrote:
> Hi Bao,
> 
> Sure, we can first integrate ur patch and see if anything is missing
> that need further upstream. Due to comapct schedule, I would kindly ask
> if it will be ready by the end of this week? :) Thanks
> 

This is Slade's kernel patch bot. When scanning his mailbox, I came across
this message, which appears to be a top-post. Please do not top-post on Linux
mailing lists.

A: Because it messes up the order in which people normally read text.
Q: Why is top-posting such a bad thing?
A: Top-posting.
Q: What is the most annoying thing in e-mail?

Please bottom-post to Linux mailing lists in the future. See also:
https://daringfireball.net/2007/07/on_top

If you believe this is an error, please address a message to Slade Watkins
<srw@sladewatkins.net>.

Thank you,
-- Slade's kernel patch bot

> 
> On Mon, 2023-02-27 at 18:57 -0800, Bao D. Nguyen wrote:
>> On 2/26/2023 7:14 Sure PM, Ziqi Chen wrote:
>>> Hi Powen,
>>>
>>> The Bao. D . Nguyen (quic_nguyenb@quicinc.com) from QCOM already
>>> made 
>>> patch to support MCQ abort.
>>>
>>> ++ Bao here to be aware of it in case your error handing patch 
>>> conflict with his abort handling patch.
>>>
>>>
>>> Best Regards,
>>>
>>> Ziqi
>>>
>>>
>>> On 2/23/2023 10:13 PM, Powen Kao (高伯文) wrote:
>>>> Hi Ziqi,
>>>>
>>>> Thanks for ur comments.
>>>>
>>>> This piece of code successfully dump relevent registers on our
>>>> platform. As you know, mcq error handling flow is not ready yet
>>>> so the
>>>> insertion point might not seems to be reasonable.
>>>>
>>>> Maybe drop this patch for now, I will send it later with error
>>>> handling
>>>> patches.
>>>>
>>>>
>>>> On Thu, 2023-02-23 at 18:14 +0800, Ziqi Chen wrote:
>>>>> Hi Po-Wen,
>>>>>
>>>>> On 2/22/2023 11:04 AM, Po-Wen Kao wrote:
>>>>>> +void ufshcd_mcq_print_hwqs(struct ufs_hba *hba, unsigned
>>>>>> long
>>>>>> bitmap)
>>>>>> +{
>>>>>> +    int id, i;
>>>>>> +    char prefix[15];
>>>>>> +
>>>>>> +    if (!is_mcq_enabled(hba))
>>>>>> +        return;
>>>>>> +
>>>>>> +    for_each_set_bit(id, &bitmap, hba->nr_hw_queues) {
>>>>>> +        snprintf(prefix, sizeof(prefix), "q%d SQCFG: ", id);
>>>>>> +        ufshcd_hex_dump(prefix,
>>>>>> +            hba->mcq_base + MCQ_QCFG_SIZE * id,
>>>>>> MCQ_QCFG_SQ_SIZE);
>>>>>
>>>>> Is your purpose dump per hardware queue registers here?  If
>>>>> yes, why
>>>>> don't use ufsmcq_readl() to save to a buffer and then use
>>>>> ufshcd_hex_dump()
>>>>>
>>>>> to dump ? Are you sure ufshcd_hex_dump() can dump register
>>>>> directly?
>>>>>
>>>>>> +
>>>>>> +        snprintf(prefix, sizeof(prefix), "q%d CQCFG: ", id);
>>>>>> +        ufshcd_hex_dump(prefix,
>>>>>> +            hba->mcq_base + MCQ_QCFG_SIZE * id +
>>>>>> MCQ_QCFG_SQ_SIZE, MCQ_QCFG_CQ_SIZE);
>>>>>
>>>>> Same to above comment.
>>>>>> +
>>>>>> +        for (i = 0; i < OPR_MAX ; i++) {
>>>>>> +            snprintf(prefix, sizeof(prefix), "q%d OPR%d: ",
>>>>>> id, i);
>>>>>> +            ufshcd_hex_dump(prefix, mcq_opr_base(hba, i,
>>>>>> id), mcq_opr_size[i]);
>>>>>
>>>>> Same.
>>>>>> +        }
>>>>>> +    }
>>>>>> +}
>>>>>> +
>>>>>>
>>>>>>    @@ -574,7 +569,16 @@ void ufshcd_print_trs(struct ufs_hba
>>>>>> *hba,
>>>>>> unsigned long bitmap, bool pr_prdt)
>>>>>>            if (pr_prdt)
>>>>>>                ufshcd_hex_dump("UPIU PRDT: ", lrbp-
>>>>>>> ucd_prdt_ptr,
>>>>>>
>>>>>>                    ufshcd_sg_entry_size(hba) *
>>>>>> prdt_length);
>>>>>> +
>>>>>> +        if (is_mcq_enabled(hba)) {
>>>>>> +            cmd = lrbp->cmd;
>>>>>> +            if (!cmd)
>>>>>> +                return;
>>>>>> +            hwq = ufshcd_mcq_req_to_hwq(hba,
>>>>>> scsi_cmd_to_rq(cmd));
>>>>>> +            ufshcd_mcq_print_hwqs(hba, 1 << hwq->id);
>>>>>
>>>>> Calling registers dump function in ufshcd_print_trs() is not
>>>>> reasonable,
>>>>> eg.. for each aborted request, it would print out all hwq
>>>>> registers,
>>>>> it's not make sense.
>>>>>
>>>>> I think we should move it out of ufshcd_print_trs().
>>>>>
>>>>>> +        }
>>>>>>        }
>>>>>> +
>>>>>>    }
>>>>>
>>>>> Best Regards,
>>>>>
>>>>> Ziqi
>>>>>
>>
>> Hi Powen,
>>
>> I am going to push the mcq abort handling and mcq error handling
>> code 
>> upstream for review in a couple days. Would that work for you?
>>
>> Regards,
>> Bao
>>

