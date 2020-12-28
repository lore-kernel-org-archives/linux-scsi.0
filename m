Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C82EC433E0
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Dec 2020 01:33:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 36D9A225A9
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Dec 2020 01:33:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726417AbgL1Bdc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 27 Dec 2020 20:33:32 -0500
Received: from m43-15.mailgun.net ([69.72.43.15]:51688 "EHLO
        m43-15.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726269AbgL1Bdb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 27 Dec 2020 20:33:31 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1609119190; h=Content-Transfer-Encoding: Content-Type:
 In-Reply-To: MIME-Version: Date: Message-ID: From: References: Cc: To:
 Subject: Sender; bh=5izmRUaFyiNbQJAkrmtwoShw5y9ugaVMj3WX1TS+BDw=; b=fJUoQL1Xb1hpPmIn9htogjkv6rT6MhpOdQu945CiMkuJHkglYYdWtlWGUVUq0fXyQcpnVTkx
 6a6VfnfEmWDe8hR7zHW04zoclDyuvpgxsxEROJDV0f1ZWslvfP/a/yQdEwkpv9l8LqQQNsxn
 pudkxOwzKRufPUBUERH6ewAKrRo=
X-Mailgun-Sending-Ip: 69.72.43.15
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n07.prod.us-west-2.postgun.com with SMTP id
 5fe935b56d011aad66cda476 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 28 Dec 2020 01:32:37
 GMT
Sender: asutoshd=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id C4759C43464; Mon, 28 Dec 2020 01:32:37 +0000 (UTC)
Received: from [192.168.8.168] (cpe-70-95-149-85.san.res.rr.com [70.95.149.85])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: asutoshd)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id A2AF9C433CA;
        Mon, 28 Dec 2020 01:32:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org A2AF9C433CA
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=asutoshd@codeaurora.org
Subject: Re: [PATCH v1] scsi: ufs-mediatek: Enable
 UFSHCI_QUIRK_SKIP_MANUAL_WB_FLUSH_CTRL
To:     Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <huobean@gmail.com>
Cc:     Avri Altman <Avri.Altman@wdc.com>, Can Guo <cang@codeaurora.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kuohong.wang@mediatek.com" <kuohong.wang@mediatek.com>,
        "peter.wang@mediatek.com" <peter.wang@mediatek.com>,
        "chun-hung.wu@mediatek.com" <chun-hung.wu@mediatek.com>,
        "andy.teng@mediatek.com" <andy.teng@mediatek.com>,
        "chaotian.jing@mediatek.com" <chaotian.jing@mediatek.com>,
        "cc.chou@mediatek.com" <cc.chou@mediatek.com>,
        "jiajie.hao@mediatek.com" <jiajie.hao@mediatek.com>,
        "alice.chao@mediatek.com" <alice.chao@mediatek.com>
References: <20201222072928.32328-1-stanley.chu@mediatek.com>
 <c862866ec97516a7ffb891e5de3d132d@codeaurora.org>
 <1608697172.14045.5.camel@mtkswgap22>
 <c83d34ca8b0338526f6440f1c4ee43dd@codeaurora.org>
 <ff8efda608e6f95737a675ee03fa3ca2@codeaurora.org>
 <1608796334.14045.21.camel@mtkswgap22>
 <DM6PR04MB6575D0DD2C04692AEF771494FCDD0@DM6PR04MB6575.namprd04.prod.outlook.com>
 <5eb12622222bd9ba5e705801a204f3160ba3966b.camel@gmail.com>
 <1608817657.14045.30.camel@mtkswgap22>
From:   "Asutosh Das (asd)" <asutoshd@codeaurora.org>
Message-ID: <d77a22a9-ea8b-0785-4a9b-62056d8e8e56@codeaurora.org>
Date:   Sun, 27 Dec 2020 17:32:35 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <1608817657.14045.30.camel@mtkswgap22>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/24/2020 5:47 AM, Stanley Chu wrote:
> Hi Avri, Bean,
> 
> On Thu, 2020-12-24 at 13:01 +0100, Bean Huo wrote:
>> On Thu, 2020-12-24 at 11:03 +0000, Avri Altman wrote:
>>>>> Do you see any substantial benefit of having
>>>>> fWriteBoosterBufferFlushEn
>>>>> disabled?
>>>>
>>>> 1. The definition of fWriteBoosterBufferFlushEn is that host allows
>>>> device to do flush in anytime after fWriteBoosterBufferFlushEn is
>>>> set as
>>>> on. This is not what we want.
>>>>
>>>> Just Like BKOP, We do not want flush happening beyond host's
>>>> expected
>>>> timing that device performance may be "randomly" dropped.
>>>
>>> Explicit flush takes place only when the device is idle:
>>> if fWriteBoosterBufferFlushEn is set, the device is idle, and before
>>> h8 received.
>>> If a request arrives, the flush operation should be halted.
>>> So no performance degradation is expected.
>>
>> Hi Stanley
>>
>> Avri's comment is correct, fWriteBoosterBufferFlushEn==1, device will
>> flush only when it is in idle, once there is new incoming request, the
>> flush will be suspended. You should be very careful when you want to
>> skip this stetting of this flag.
> 
> Very appreciate your the clarification.
> 
> However similar to "Background Operations Termination Latency", while
> the next request comes, device may need some time to suspend on-going
> flush operations. This delay may "randomly" degrade the performance
> right?
> 

Have you actually seen this happening? I've not come across any random 
performance degradation concerns, hence asking.

 From what I've observed is the handling of WB buffer flush depends on 
how flash vendors implement it. Some vendors that I've seen just create 
a separate WB buffer in an instant. I don't know the intricacies of 
their implementation, but I guess the new WB buffer handles the requests 
while the previous one is being flushed.
Anyway, for Qualcomm platforms we plan to have 
fWriteBoosterBufferFlushEn=1 by default.

> Since the configuration, i.e., enable
> fWriteBoosterBufferFlushDuringHibernate only with
> fWriteBoosterBufferFlushEn disabled, has been applied in many of our
> mass-produced products these yeas, we would like to keep it unless the
> new setting has obvious benefits.
> 
> Thanks,
> Stanley Chu
> 
>>
>> Bean
>>
> 


-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
Linux Foundation Collaborative Project
