From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: scsi: BUG in scsi_init_io
Date: Tue, 31 Jan 2017 10:58:22 +0100
Message-ID: <20170131095822.GC3687@linux-x5ow.site>
References: <CACT4Y+YAX_SmwzsHenzkswM0kp=om5NivmLW8d9Js6EN3zKmGQ@mail.gmail.com>
 <20170131092048.GB3687@linux-x5ow.site>
 <CACT4Y+Y0Yi43kN+sAOd=pu4FTnW4wPeGwiDHEU45s6DTXs_JmQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52253 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750896AbdAaJ6m (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 31 Jan 2017 04:58:42 -0500
Content-Disposition: inline
In-Reply-To: <CACT4Y+Y0Yi43kN+sAOd=pu4FTnW4wPeGwiDHEU45s6DTXs_JmQ@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dmitry Vyukov <dvyukov@google.com>
Cc: jejb@linux.vnet.ibm.com, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, syzkaller <syzkaller@googlegroups.com>, Hannes Reinecke <hare@suse.de>

On Tue, Jan 31, 2017 at 10:50:49AM +0100, Dmitry Vyukov wrote:
> On Tue, Jan 31, 2017 at 10:20 AM, Johannes Thumshirn <jthumshirn@suse.de> wrote:
> > On Tue, Jan 31, 2017 at 09:55:52AM +0100, Dmitry Vyukov wrote:

[...]

> Please-please-please, let's not use WARN for something that is not a
> kernel bug and is user-triggerable. This makes it impossible to
> automate kernel testing and requires hiring an army of people doing
> mechanical job of sorting out WARNING reports into kernel-bugs and
> non-kernel-bugs.
> If the message is absolutely necessary (while kernel does not
> generally explain every EINVAL on console), the following will do:
> 
>       if (!blk_rq_nr_phys_segments(rq)) {
>               pr_err("you are doing something wrong\n");
>               return -EINVAL;
>       }

Yes I understand that. OTOH having the WARN helps you finding the caller because
of to the stack trace. But arguably that could be accomplished with function
graph tracing as well. I'll re-send a v2 as a proper patch.

Thanks,
	Johannes

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
