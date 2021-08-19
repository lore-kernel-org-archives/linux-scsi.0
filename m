Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A9DFC4338F
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Aug 2021 09:09:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6462B6113C
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Aug 2021 09:09:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236873AbhHSJKJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 Aug 2021 05:10:09 -0400
Received: from frasgout.his.huawei.com ([185.176.79.56]:3671 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229804AbhHSJKI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Aug 2021 05:10:08 -0400
Received: from fraeml715-chm.china.huawei.com (unknown [172.18.147.206])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4GqzTG6WSDz6BGCj;
        Thu, 19 Aug 2021 17:08:34 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml715-chm.china.huawei.com (10.206.15.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Thu, 19 Aug 2021 11:09:29 +0200
Received: from [10.202.227.179] (10.202.227.179) by
 lhreml724-chm.china.huawei.com (10.201.108.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Thu, 19 Aug 2021 10:09:28 +0100
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
 <c9d9891b-780b-4641-2b60-6319d525e17c@huawei.com>
 <6090371d-9688-11ae-8219-ba9929a96526@suse.de>
From:   John Garry <john.garry@huawei.com>
Message-ID: <6c83bd7f-9fd2-1b43-627f-615467fa55d4@huawei.com>
Date:   Thu, 19 Aug 2021 10:09:27 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <6090371d-9688-11ae-8219-ba9929a96526@suse.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.202.227.179]
X-ClientProxiedBy: lhreml710-chm.china.huawei.com (10.201.108.61) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 19/08/2021 08:50, Hannes Reinecke wrote:
>>>    select CPU_32v4 if ARCH_RPC
>>
>> Does that build fully for xconfig or any others which you tried?
>>
>  > Yep, xconfig and full build works.
> 
> Well.
> 
> Would've worked if you hadn't messed up tag handling for acornscsi :-)
>  > Besides: tag handling in acornscsi (and fas216, for that matter) seems
> to be completely broken.
> 
> Consider this beauty:
> 
> #ifdef CONFIG_SCSI_ACORNSCSI_TAGGED_QUEUE
>         /*
>          * tagged queueing - allocate a new tag to this command
>          */
>         if (SCpnt->device->simple_tags) {
>             SCpnt->device->current_tag += 1;
>             if (SCpnt->device->current_tag == 0)
>                 SCpnt->device->current_tag = 1;
>             SCpnt->tag = SCpnt->device->current_tag;
>         } else
> #endif

So isn't this just using the scsi_cmnd.tag as it own scribble?

> 
> which is broken on _soo many_ counts.
> Not only does it try to allocate its own tags, the code also assumes 
> that a tag value of '0' indicates that tagged queueing is not active:
> 

In case you missed it, Arnd B tried to clear out some old platforms 
earlier this year. With respect to rpc, Russell King apparently still 
uses it and has some SCSI patches:

https://lore.kernel.org/lkml/20210109174357.GB1551@shell.armlinux.org.uk/

I wonder what they are and maybe we can check. Anyway... I'd run any 
changes by him...

> static
> void acornscsi_abortcmd(AS_Host *host, unsigned char tag)
> {
>      host->scsi.phase = PHASE_ABORTED;
>      sbic_arm_write(host, SBIC_CMND, CMND_ASSERTATN);
> 
>      msgqueue_flush(&host->scsi.msgs);
> #ifdef CONFIG_SCSI_ACORNSCSI_TAGGED_QUEUE
>      if (tag)
>          msgqueue_addmsg(&host->scsi.msgs, 2, ABORT_TAG, tag);
>      else
> #endif
>          msgqueue_addmsg(&host->scsi.msgs, 1, ABORT);
> }
> 
> And, of course, there's the usual confusion about when to check for
> sdev->tagged_supported and sdev->simple_tags.
> 
> Drop me a note if I can give a hand.

Thanks! Let's see what happens to the series which you just sent.
