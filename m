Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88088C433B4
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Apr 2021 14:31:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 44010610FC
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Apr 2021 14:31:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234914AbhDPOcQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 16 Apr 2021 10:32:16 -0400
Received: from mx2.suse.de ([195.135.220.15]:53676 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232642AbhDPOcQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 16 Apr 2021 10:32:16 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 73DCFB134;
        Fri, 16 Apr 2021 14:31:50 +0000 (UTC)
Subject: Re: [PATCH 13/24] mpi3mr: implement scsi error handler hooks
To:     Kashyap Desai <kashyap.desai@broadcom.com>
Cc:     linux-scsi <linux-scsi@vger.kernel.org>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Steve Hagan <steve.hagan@broadcom.com>,
        Peter Rivera <peter.rivera@broadcom.com>,
        mpi3mr-drvr-developers <mpi3mr-linuxdrv.pdl@broadcom.com>,
        Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>
References: <20201222101156.98308-1-kashyap.desai@broadcom.com>
 <20201222101156.98308-14-kashyap.desai@broadcom.com>
 <f5040f4a-f994-39ff-423a-9eb3e94e361d@suse.de>
 <CAHsXFKHG=_QObsfEJRf2vUsdrb677Lurp+xjyY6FmHgcy1aH6Q@mail.gmail.com>
From:   Hannes Reinecke <hare@suse.de>
Organization: SUSE Linux GmbH
Message-ID: <0acddb21-7beb-05db-edfb-3179b5f251dd@suse.de>
Date:   Fri, 16 Apr 2021 16:31:49 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <CAHsXFKHG=_QObsfEJRf2vUsdrb677Lurp+xjyY6FmHgcy1aH6Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/16/21 4:12 PM, Kashyap Desai wrote:
>>> +     if (host_tag >= MPI3MR_HOSTTAG_DEVRMCMD_MIN &&
>>> +         host_tag <= MPI3MR_HOSTTAG_DEVRMCMD_MAX) {
>>> +             idx = host_tag - MPI3MR_HOSTTAG_DEVRMCMD_MIN;
>>> +             return &mrioc->dev_rmhs_cmds[idx];
>>> +     }
>>>
>>>       return NULL;
>>>   }
>>
>> Looks like this hunk is misdirected, and should be moved to the device
>> handling patch ...
> 
> Hannes -
> I missed to reply to this thread. I have handled this in V2. I am
> planning to post V3 soon.
> 
>>
>> Hmm. This looks a bit unfortunate.
>> You are reserving just one tag for task management commands, which is
>> okay for device and target reset (as there we're running in single-step
>> mode and will only ever need one tag), but it's certainly not okay for
>> task abort, which is issued in-line and as such can occur for _every_
>> command.
>>
>> So I guess you'll need to rethink you tag allocation strategy here.
> 
> Agree with you Hannes. Currently we are looking for a stable interface and
> improvement in upcoming driver updates.
> 
Alternatively you could drop task abort (in favour of doing a task set
abort/lun reset); that way your current tag allocation strategy would
work and we can think of command abort later.

Which will be even more of an issue once my patchset for private
commands in SCSI goes in (note to self: resend); there are other drivers
which will suffer from precisely this issue, too.

I'll be reviewing the other patches shortly.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		        Kernel Storage Architect
hare@suse.de			               +49 911 74053 688
SUSE Software Solutions Germany GmbH, 90409 Nürnberg
GF: F. Imendörffer, HRB 36809 (AG Nürnberg)
