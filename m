From: Dmitry Vyukov <dvyukov@google.com>
Subject: Re: scsi: BUG in scsi_init_io
Date: Tue, 31 Jan 2017 11:06:29 +0100
Message-ID: <CACT4Y+by0FrDzT_aLPTyqvc1A5hiLpV1rmUAAYWbUZ25g7YpCA@mail.gmail.com>
References: <CACT4Y+YAX_SmwzsHenzkswM0kp=om5NivmLW8d9Js6EN3zKmGQ@mail.gmail.com>
 <20170131092048.GB3687@linux-x5ow.site> <CACT4Y+Y0Yi43kN+sAOd=pu4FTnW4wPeGwiDHEU45s6DTXs_JmQ@mail.gmail.com>
 <20170131095822.GC3687@linux-x5ow.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-vk0-f50.google.com ([209.85.213.50]:33942 "EHLO
        mail-vk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751470AbdAaKG4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 31 Jan 2017 05:06:56 -0500
Received: by mail-vk0-f50.google.com with SMTP id r136so233771299vke.1
        for <linux-scsi@vger.kernel.org>; Tue, 31 Jan 2017 02:06:56 -0800 (PST)
In-Reply-To: <20170131095822.GC3687@linux-x5ow.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: jejb@linux.vnet.ibm.com, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, syzkaller <syzkaller@googlegroups.com>, Hannes Reinecke <hare@suse.de>

On Tue, Jan 31, 2017 at 10:58 AM, Johannes Thumshirn <jthumshirn@suse.de> wrote:
>
> [...]
>
>> Please-please-please, let's not use WARN for something that is not a
>> kernel bug and is user-triggerable. This makes it impossible to
>> automate kernel testing and requires hiring an army of people doing
>> mechanical job of sorting out WARNING reports into kernel-bugs and
>> non-kernel-bugs.
>> If the message is absolutely necessary (while kernel does not
>> generally explain every EINVAL on console), the following will do:
>>
>>       if (!blk_rq_nr_phys_segments(rq)) {
>>               pr_err("you are doing something wrong\n");
>>               return -EINVAL;
>>       }
>
> Yes I understand that. OTOH having the WARN helps you finding the caller because
> of to the stack trace. But arguably that could be accomplished with function
> graph tracing as well. I'll re-send a v2 as a proper patch.


Thank you very much.
Stack trace can be done with dump_stack() if necessary, e.g.

               pr_err("you are doing something wrong here:\n");
               dump_stack();
