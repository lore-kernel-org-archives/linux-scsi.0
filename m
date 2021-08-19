Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50535C4338F
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Aug 2021 07:27:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3714E60E78
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Aug 2021 07:27:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236713AbhHSH2C (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 Aug 2021 03:28:02 -0400
Received: from frasgout.his.huawei.com ([185.176.79.56]:3669 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232038AbhHSH2B (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Aug 2021 03:28:01 -0400
Received: from fraeml739-chm.china.huawei.com (unknown [172.18.147.201])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4GqxCT3XDBz6BH2P;
        Thu, 19 Aug 2021 15:26:29 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml739-chm.china.huawei.com (10.206.15.220) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Thu, 19 Aug 2021 09:27:23 +0200
Received: from [10.47.81.140] (10.47.81.140) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.8; Thu, 19 Aug
 2021 08:27:20 +0100
Subject: Re: [PATCH 0/3] Remove scsi_cmnd.tag
To:     Hannes Reinecke <hare@suse.de>,
        Bart Van Assche <bvanassche@acm.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     <satishkh@cisco.com>, <sebaddel@cisco.com>, <kartilak@cisco.com>,
        <jejb@linux.ibm.com>, <linux-scsi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <hch@lst.de>
References: <1628862553-179450-1-git-send-email-john.garry@huawei.com>
 <yq14kbppa42.fsf@ca-mkp.ca.oracle.com>
 <176ce4f2-42c9-bba6-c8f9-70a08faa21b8@huawei.com>
 <e0d7ba32-2999-794e-2ccb-fdba2c847eb1@acm.org>
 <038ec0c6-92c9-0f2a-7d81-afb91b8343af@suse.de>
From:   John Garry <john.garry@huawei.com>
Message-ID: <c9d9891b-780b-4641-2b60-6319d525e17c@huawei.com>
Date:   Thu, 19 Aug 2021 08:27:19 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <038ec0c6-92c9-0f2a-7d81-afb91b8343af@suse.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.47.81.140]
X-ClientProxiedBy: lhreml712-chm.china.huawei.com (10.201.108.63) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 19/08/2021 08:15, Hannes Reinecke wrote:
> Hey Bart,
> 
> Thanks for this!
> Really helpful.
> 
> Just a tiny wee snag:
> 
> On 8/19/21 4:41 AM, Bart Van Assche wrote:
>> On 8/18/21 11:08 AM, John Garry wrote:
>>> Or maybe you or Bart have a better idea?
>>
>> This is how I test compilation of SCSI drivers on a SUSE system (only
>> the cross-compilation prefix is distro specific):
>>
>>      # Acorn RiscPC
>>      make ARCH=arm xconfig
>>      # Select the RiscPC architecture (ARCH_RPC)
>>      make -j9 ARCH=arm CROSS_COMPILE=arm-suse-linux-gnueabi- </dev/null
>>
> 
> Acorn RiscPC is ARMv3, which sadly isn't supported anymore with gcc9.
> So for compilation I had to modify Kconfig to select ARMv4:
> 

Yeah, that is what I was tackling this very moment.

> diff --git a/arch/arm/mm/Kconfig b/arch/arm/mm/Kconfig
> index 8355c3895894..22ec9e275335 100644
> --- a/arch/arm/mm/Kconfig
> +++ b/arch/arm/mm/Kconfig
> @@ -278,7 +278,7 @@ config CPU_ARM1026
>   # SA110
>   config CPU_SA110
>          bool
> -       select CPU_32v3 if ARCH_RPC
> +       select CPU_32v4 if ARCH_RPC

Does that build fully for xconfig or any others which you tried?

>          select CPU_32v4 if !ARCH_RPC
>          select CPU_ABRT_EV4
>          select CPU_CACHE_V4WB
> 

Thanks to all!

