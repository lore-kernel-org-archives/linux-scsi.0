From: James Smart <jsmart2021@gmail.com>
Subject: Re: [PATCH v2 12/20] lpfc: Limit amount of work processed in IRQ
Date: Mon, 7 Aug 2017 13:50:59 -0700
Message-ID: <389dd23c-6cc4-8498-5980-9fdd0610b516@gmail.com>
References: <20170805004731.1335-1-jsmart2021@gmail.com>
 <20170805004731.1335-13-jsmart2021@gmail.com>
 <20170807084354.GO3978@linux-x5ow.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f195.google.com ([209.85.220.195]:33148 "EHLO
        mail-qk0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751662AbdHGUvE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Aug 2017 16:51:04 -0400
Received: by mail-qk0-f195.google.com with SMTP id d145so1605630qkc.0
        for <linux-scsi@vger.kernel.org>; Mon, 07 Aug 2017 13:51:04 -0700 (PDT)
In-Reply-To: <20170807084354.GO3978@linux-x5ow.site>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: linux-scsi@vger.kernel.org, Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

On 8/7/2017 1:43 AM, Johannes Thumshirn wrote:
> On Fri, Aug 04, 2017 at 05:47:23PM -0700, James Smart wrote:
>> From: Dick Kennedy <dick.kennedy@broadcom.com>
>>
>> Various oops being seen on being in the ISR too long and cpu
>> lockups, when under heavy load.
>>
>> The amount of work being posted off of completion queues kept
>> the ISR running almost all the time
>>
>> Correct the issue by limiting the amount of work per itteration.
> 
> Have you considered using the IRQ poll mechanism for this? It deferres the
> heavy lifing into the Soft-IRQ layer and this could help you a lot here. IIRC
> I've sent James the "Slides" from my LSF/MM session which have the function
> protoypes on 'em. See 'lib/irq_poll.c' or the be2iscsi driver for further
> details.

We considered it, so far declined it - preferring the behavior of the 
dynamic hw coalescing we have. That said, we're already considering the 
softirq approach, which shouldn't be that large of a delta. However, 
we've chosen to delay that change while we harden the overall stability.

-- james
