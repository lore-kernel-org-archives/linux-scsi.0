Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A9BEC12002
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Jul 2021 16:26:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5C101613CC
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Jul 2021 16:26:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229581AbhGPQ3j (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 16 Jul 2021 12:29:39 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:35134 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229751AbhGPQ3j (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 16 Jul 2021 12:29:39 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1626452804; h=Content-Transfer-Encoding: Content-Type:
 In-Reply-To: MIME-Version: Date: Message-ID: From: References: Cc: To:
 Subject: Sender; bh=UMd/3dedaPqo4HtWvmCQPPei64j7YnwvHfRfibg1n8k=; b=DT9+EJ03NypKwV5hn6sAPp0L1ZOee4MeMTmrfmaJziR7wrMWxe+FfqU7l0bvAmjAOWLI08eg
 W3d4CtxnK4htrqlDyQsVEXmJV/4kUG13al14P8oR8/yRQVse0MIphoOnsKRXUu+yudEpPcjg
 sKIv4cybgxDuPX+eKfcfd3FuWJw=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n05.prod.us-west-2.postgun.com with SMTP id
 60f1b332fcf9fe7b78271021 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Fri, 16 Jul 2021 16:26:26
 GMT
Sender: asutoshd=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id CBE43C43144; Fri, 16 Jul 2021 16:26:25 +0000 (UTC)
Received: from [192.168.8.168] (cpe-70-95-149-85.san.res.rr.com [70.95.149.85])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: asutoshd)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 56E7CC433F1;
        Fri, 16 Jul 2021 16:26:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 56E7CC433F1
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=asutoshd@codeaurora.org
Subject: Re: [PATCH v2 13/19] scsi: ufs: Fix a race in the completion path
To:     Avri Altman <Avri.Altman@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Can Guo <cang@codeaurora.org>
Cc:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Akinobu Mita <akinobu.mita@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Bean Huo <beanhuo@micron.com>
References: <20210709202638.9480-1-bvanassche@acm.org>
 <20210709202638.9480-15-bvanassche@acm.org>
 <DM6PR04MB65750B644072145010B7D952FC169@DM6PR04MB6575.namprd04.prod.outlook.com>
 <fe3076c3-f835-b7e4-c5be-4ba55d5e0e41@acm.org>
 <1b35777f-bea2-9443-0bac-c42b37acf8b3@acm.org>
 <DM6PR04MB65759F6FCD2293AC9FED6C9CFC119@DM6PR04MB6575.namprd04.prod.outlook.com>
From:   "Asutosh Das (asd)" <asutoshd@codeaurora.org>
Message-ID: <d43d94f4-8f9d-7391-a166-f839c03fb7b3@codeaurora.org>
Date:   Fri, 16 Jul 2021 09:26:23 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <DM6PR04MB65759F6FCD2293AC9FED6C9CFC119@DM6PR04MB6575.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/16/2021 5:39 AM, Avri Altman wrote:
>   
>> On 7/13/21 9:49 AM, Bart Van Assche wrote:
>>> On 7/11/21 5:29 AM, Avri Altman wrote:
>>>>> This patch is a performance improvement because it reduces the
>>>>> number of atomic operations in the hot path (test_and_clear_bit()).
>>>> Both Can & Stanley reported a performance improvement of RR with
>>>> "Optimize host lock..".
>>>> Can those short numerical studies can be repeated with this patch?
>>>
>>> I will measure the performance impact of this patch for rq_affinity=2
>>> as soon as I have the time. As you may know we are close to an
>>> internal deadline.
>>
>> (replying to my own email)
>>
>> Hi Avri,
>>
>> The performance I measure with the current upstream UFS driver is 61.0 K IOPS.
>> With a variant of this patch (outstanding_reqs protected with a new spinlock
>> instead of the host lock), I see 62.0 K IOPS. In other words, this patch realizes a
>> small performance improvement. This is what I had expected since this patch
>> reduces the number of atomic operations involved in updating
>> outstanding_reqs.
> Thank you for taking the time and running this.
> But does your platform make use of REG_UTP_TRANSFER_REQ_LIST_COMPL?
> With 60k IOPS I suspect it doesn't, and the comparison is irrelevant.
> 
> Thanks,
> Avri
> 
I agree. We saw substantial improvement with RR and RW too with the 
'Optimize host lock change'.

Hi Bart,
Is it possible to check the performance data with these changes on 
Android, say using Androbench?


-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
Linux Foundation Collaborative Project
