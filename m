Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68948C433F5
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Dec 2021 13:57:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346978AbhLBOA3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 2 Dec 2021 09:00:29 -0500
Received: from out2.migadu.com ([188.165.223.204]:46235 "EHLO out2.migadu.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229492AbhLBOA2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 2 Dec 2021 09:00:28 -0500
Subject: Re: [PATCH V2] scsi:spraid: initial commit of Ramaxel spraid driver
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1638453424;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ev0Vxs67iUL8RpRHafepDqlDRZH3r3mTewlarVzd+WU=;
        b=GOqlC7Fyss86NLuxOY3qMrJNRzKbuoXaJg2sE4muQ4JPfreH8euVBRxw/oOM5wgl7WHab5
        HqmIAHHAzddfYwZ2FOxIRU0AT5QSjR2yJMPRcseV7qkgUHLYE9PIFO/y1T3c5XhV84sTHj
        08eVyzpjA9Pk2509Ms2VQ8lWYIDT0xU=
To:     Hannes Reinecke <hare@suse.de>, Yanling Song <songyl@ramaxel.com>
Cc:     martin.petersen@oracle.com, bvanassche@acm.org,
        linux-scsi@vger.kernel.org, yujiang@ramaxel.com
References: <20211126073310.87683-1-songyl@ramaxel.com>
 <99fb2d55-88c0-2911-3b71-7670d386ab1c@suse.de>
 <20211130113836.1bb8e91c@songyl>
 <69541d78-49cd-900a-21ca-b9f56e9dca00@suse.de>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Yanling song <yanling.song@linux.dev>
Message-ID: <8992fcbe-6e9c-0b90-0be2-7fbd1822a4fd@linux.dev>
Date:   Thu, 2 Dec 2021 13:56:55 +0000
MIME-Version: 1.0
In-Reply-To: <69541d78-49cd-900a-21ca-b9f56e9dca00@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



On 11/30/21 11:55 AM, Hannes Reinecke wrote:
> On 11/30/21 12:38 PM, Yanling Song wrote:
>> On Mon, 29 Nov 2021 14:04:12 +0100
>> Hannes Reinecke <hare@suse.de> wrote:
>>
>>> On 11/26/21 8:33 AM, Yanling Song wrote:
>>>> This initial commit contains Ramaxel's spraid module.
>>>>
>>>> Signed-off-by: Yanling Song <songyl@ramaxel.com>
>>>>
>>>> Changes from V1:
>>>> 1. Use BSG module to replace with ioctrl
>>>> 2. Use author's email as MODULE_AUTHOR
>>>> 3. Remove "default=m" in drivers/scsi/spraid/Kconfig
>>>> 4. To be changed in the next version:
>>>>     a. Use get_unaligned_be*() in spraid_setup_rw_cmd();
>>>>     b. Use pr_debug() instead of introducing dev_log_dbg().
>>>>
>>>> ---
>>>>   Documentation/scsi/spraid.rst     |   16 +
>>>>   MAINTAINERS                       |    7 +
>>>>   drivers/scsi/Kconfig              |    1 +
>>>>   drivers/scsi/Makefile             |    1 +
>>>>   drivers/scsi/spraid/Kconfig       |   10 +
>>>>   drivers/scsi/spraid/Makefile      |    7 +
>>>>   drivers/scsi/spraid/spraid.h      |  693 ++++++
>>>>   drivers/scsi/spraid/spraid_main.c | 3328
>>>> +++++++++++++++++++++++++++++ 8 files changed, 4063 insertions(+)
>>>>   create mode 100644 Documentation/scsi/spraid.rst
>>>>   create mode 100644 drivers/scsi/spraid/Kconfig
>>>>   create mode 100644 drivers/scsi/spraid/Makefile
>>>>   create mode 100644 drivers/scsi/spraid/spraid.h
>>>>   create mode 100644 drivers/scsi/spraid/spraid_main.c
>>>>   
>>> Hmm.
>>> This entire thing looks like an NVMe controller which is made to look 
>>> like a SCSI controller.
>>> It even uses most of the NVMe structures.
>>> And from what I've seen there is not much SCSI specific in here; I/O
>>> and queue setup is pretty much what every NVMe controller does.
>>> So why not make it a true NVMe controller?
>>> Yes, you would need to discuss with the NVMe folks on how a RAID 
>>> controller should look like in NVMe terms.
>>> But overall I guess the driver would be far smaller and possibly
>>> easier to maintain.
>>>
>>> So where's the benefit having it as a SCSI driver (apart from the
>>> fact that is allows you to side-step having to discuss the interface
>>> with NVMexpress.org ...)?
>>> Or, to put it the other way round: Is there anything SCSI specific
>>> which would prevent such an approach?
>>>
>>
>> Actually it is a SCSI driver, and it does register a scsi_host_template
>> and host does send SCSI commands to our raid controller just like other
>> raid controllers. You are right "it looks a lot like NVMe" since we
>> believe the communication mechanism of NVME between host and the end
>> device is good and it was leveraged when we designed the raid
>> controller. That's why it looks like there are some code from NVME
>> because the mechanism is the same.
>>
> Thank you, but that was precisely my question.
> 
> Seeing that the driver is using the NVMe mechanism to communicate
> commands between the driver and the hardware, doesn't it make it a NVMe
> driver?
> Especially as you are sending NVMe commands and not SCSI commands, so
> you always will have to re-write the incoming SCSI commands into NVMe
> commands, and knowing from experience this is not a good fit.
> 
> Hence my question: what exactly is SCSI specific on the hardware side?
> Wouldn't an implementation as a NVMe driver be a better fit, as then you
> could leverage all the existing code like setup prps, completion
> handling etc?
> 
Our controller supports both SCSI and NVMe. In current raid mode, it only supports SAS/SATA disks.
and reports SCSI disk to host after creating raid group. In this use case, SCSI is the protocol and the spraid driver is needed.
In another mode, controller can support NVMe disks and works with the NVMe driver in linux kernel.
To reduce the complexity, NVMe mechanism is used as the communication method between driver and controller so that we can use the same interface for both SCSI and NVMe.

> Cheers,
> 
> Hannes
> 
