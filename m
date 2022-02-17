Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE523C433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Feb 2022 11:47:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239980AbiBQLrv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Feb 2022 06:47:51 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:55488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232390AbiBQLrr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Feb 2022 06:47:47 -0500
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DD902819AF
        for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2022 03:47:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1645098453; x=1676634453;
  h=message-id:date:mime-version:subject:to:references:from:
   in-reply-to:content-transfer-encoding;
  bh=ZXx2QI0VRETtLqzLOEMPddmXh7gULvr9JzYh6G8VKkk=;
  b=mVOGD1LSsaEwxEH5nediRqpVEMOQGWd0GyRRLJz/BluBPPMtcwl6ASrF
   q1VO9kPoJG0fyntLqWj5eHmdAA0Lj9mixZpQZ/tX4ICPYNxJSBLoZ+JAg
   JMn9hT39YTwfm72W7wuFBqhdw7PuAhlDoJQ7nCmWi/RmGJx9WzXQ7gpD3
   QRUHgaCKfY+YgpApIQkXYszyt463mszu6K6a+WdnTXafdbjDTLKUaFLtx
   KpH29gYuaajm1baOnzWk6TT0dnPqzywZ1BXMWu/PMCoqv4X+gIGmwe+we
   AJH0TL65+WPhgbYebJUbZFiEjjB1TUhbjHHgQVH0CeB86jrk6CdCBEQHs
   g==;
X-IronPort-AV: E=Sophos;i="5.88,375,1635177600"; 
   d="scan'208";a="305085715"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 17 Feb 2022 19:47:33 +0800
IronPort-SDR: RcxDdPLoy23d+bO9TmuqMC0DkwmuIBSVhyhsCRakGqCAN5CLHajzCe5sdPcyyzA6fT/KtyG2OL
 b0JKO/ngo02+PmURLxZ1j8tQvcg208B6l818naGYuc+tboqE86eA1hE9fFQ3H0AB9a5e9+51ky
 9f+z95wG/QN7wCb05VBVWPrqIbWLY8B0D0F3+A80LcaMSoCGAXoA1rImOiCwjGY+ytZYIvH878
 GAaD7AxP6CR8yhx6FUbHieeHuRBosoU0oJsZth3KSNRkyo7uK00NcRsAnRXy9bUmEbfgE0UatC
 XkkFP9Zea9xeKRnMH6ig7pzY
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2022 03:20:19 -0800
IronPort-SDR: LYLPZW8HSKlBkBLqgBxFp9jkg1RglK/VJ9KgWMgZsh2nl3MYsNLLEBomR8MrTKl0TU85QLOU+l
 dADQuty1PXO5cbgmCKTtQeghsCMV5JCo6xLJgHEp/M4hBvU5Oa3zkhZcjTczDOBa6vYwW9IpYV
 gb1fkpSOe0MARHJnhcC0Bs5X8nICs1ZIn6fnGhfx9KnCxPHFZ2DR1Mr/BS0aTNvLeARszvnLvT
 4y4umNEZcsGrJhyCuozwaat3ibascVh8l3EG8DyfOYMiRfp3I2jOic66tDzZniNhia9+Q6+bo+
 jlc=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2022 03:47:34 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4JztNh6Jbtz1SVp1
        for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2022 03:47:32 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1645098452; x=1647690453; bh=ZXx2QI0VRETtLqzLOEMPddmXh7gULvr9JzY
        h6G8VKkk=; b=lemaOJasalE7FGane66uThyUvW19XmD1JZOkPBJSMsMGQIDS9ah
        C9XQtFhg8smFXVVFSECAkluwIZ0LGLM0lru9q6bOJzp0qFVE2KyhoOlFDt4OB9BL
        sQV5nujVLOpPTWshrOnbjhYwqUiX0zJFFWhKf7nJKJubJe7g27quctSYoU7wnsW2
        vxUc5DuREgFXREnlltKivd3bs/rKFVlOFWrlU094c2nZHs4fPQaJtUumJe+ogb6Q
        ahSikaQNlt+Q8SnuF9shZIiPbn0sxG/9YxZfy6JQJpKdt8zrEDqZmhmi/rpBntgD
        4a/DktAgE1QCv3O2IosTPi75qkiHKN2jloQ==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id OFRNZxXaI0jI for <linux-scsi@vger.kernel.org>;
        Thu, 17 Feb 2022 03:47:32 -0800 (PST)
Received: from [10.225.163.77] (unknown [10.225.163.77])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4JztNg35Ddz1Rwrw;
        Thu, 17 Feb 2022 03:47:31 -0800 (PST)
Message-ID: <eac105a1-4ce1-dcd3-38ba-088acbc9e85f@opensource.wdc.com>
Date:   Thu, 17 Feb 2022 20:47:29 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v3 27/31] scsi: pm8001: Cleanup pm8001_queue_command()
Content-Language: en-US
To:     John Garry <john.garry@huawei.com>, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        Jason Yan <yanaijie@huawei.com>
References: <20220214021747.4976-1-damien.lemoal@opensource.wdc.com>
 <20220214021747.4976-28-damien.lemoal@opensource.wdc.com>
 <51d7c127-f975-14e9-a036-c37416ed8679@huawei.com>
 <32efd519-3485-ee34-84e2-34a0d8c27e17@opensource.wdc.com>
 <38090771-ad24-1b20-9b79-f7f89d42ea66@huawei.com>
 <37df3c92-c28e-72d4-76d8-33356829af5a@opensource.wdc.com>
 <5a5481af-e975-c6fb-2d48-961769eae551@huawei.com>
 <9c22abeb-1b22-4613-66bc-276aaa4a639c@opensource.wdc.com>
 <e7b5c48b-4217-7247-8bc9-e5f8ae9411ce@huawei.com>
 <e9b40eaf-7aa5-798b-1bde-1a2ce8d83433@opensource.wdc.com>
 <712a4702-8534-fad2-2679-cc5cf62e4a9e@huawei.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <712a4702-8534-fad2-2679-cc5cf62e4a9e@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/17/22 18:23, John Garry wrote:
> On 17/02/2022 00:12, Damien Le Moal wrote:
>>>>> I'll have a look at it. And that is on mainline or mkp-scsi staging, and
>>>>> not your patchset.
>>>> Are you saying that my patches suppresses the above ? This is submission
>>>> path and the dma code seems to complain about alignment... So bad buffer
>>>> addresses ?
>>> Your series does not suppress it. It doesn't occur often, so I need to
>>> check more.
>>>
>>> I think the issue is that we call dma_map_sg() twice, i.e. ccb never
>>> unmapped.
>> That would be a big issue indeed. We could add a flag to CCBs to track
>> the buf_prd DMA mapping state and BUG_ON() when ccb free function is
>> called with the buffer still mapped. That should allow catching this
>> infrequent problem ?
>>
> 
> I figured out what is happening here and it does not help solve the 
> mystery of my hang.
> 
> Here's the steps:
> a. scsi_cmnd times out
> b. scsi error handling kicks in
> c. libsas attempts to abort the task, which fails
> d. libsas then tries IT nexus reset, which passes
>   - libsas assumes the scsi_cmnd has completed with failure
> e. error handling concludes
> f. scsi midlayer then retries the same scsi_cmnd
> g. since we did not "free" associated ccb earlier or dma unmap at d., 
> the dma unmap on the same scsi_cmnd causes the warn
> 
> So the LLD should really free resources and dma unmap at point IT nexus 
> reset completes, but it doesn't. I think in certain conditions dma map 
> should not be done twice.
> 
> Anyway, that can be fixed, but I still have the hang :(

One thought: could it be bug with the DMA engine of your platform ?
What if you simply run an fio workload on the disk directly (no FS),
hang happens too ?

For the bugs I fixed with my series, it was the reverse: fio worked
great but everything broke down when I ran libzbc tests...

> 
> Thanks,
> John


-- 
Damien Le Moal
Western Digital Research
