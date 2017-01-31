From: James Bottomley <jejb@linux.vnet.ibm.com>
Subject: Re: scsi: BUG in scsi_init_io
Date: Tue, 31 Jan 2017 07:41:51 -0800
Message-ID: <1485877311.3199.4.camel@linux.vnet.ibm.com>
References: <CACT4Y+YAX_SmwzsHenzkswM0kp=om5NivmLW8d9Js6EN3zKmGQ@mail.gmail.com>
         <20170131092048.GB3687@linux-x5ow.site>
         <CACT4Y+Y0Yi43kN+sAOd=pu4FTnW4wPeGwiDHEU45s6DTXs_JmQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:59500 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750935AbdAaPmO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 31 Jan 2017 10:42:14 -0500
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v0VFcddS119059
        for <linux-scsi@vger.kernel.org>; Tue, 31 Jan 2017 10:41:58 -0500
Received: from e18.ny.us.ibm.com (e18.ny.us.ibm.com [129.33.205.208])
        by mx0a-001b2d01.pphosted.com with ESMTP id 28avx71r64-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Tue, 31 Jan 2017 10:41:58 -0500
Received: from localhost
        by e18.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <jejb@linux.vnet.ibm.com>;
        Tue, 31 Jan 2017 10:41:57 -0500
In-Reply-To: <CACT4Y+Y0Yi43kN+sAOd=pu4FTnW4wPeGwiDHEU45s6DTXs_JmQ@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dmitry Vyukov <dvyukov@google.com>, Johannes Thumshirn <jthumshirn@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, syzkaller <syzkaller@googlegroups.com>, Hannes Reinecke <hare@suse.de>

On Tue, 2017-01-31 at 10:50 +0100, Dmitry Vyukov wrote:
> On Tue, Jan 31, 2017 at 10:20 AM, Johannes Thumshirn <
> jthumshirn@suse.de> wrote:
> > On Tue, Jan 31, 2017 at 09:55:52AM +0100, Dmitry Vyukov wrote:
> > > Hello,
> > > 
> > > The following program triggers BUG in scsi_init_io:
> > 
> > Well crashing a machine just because of an empty dma transfer is a
> > bit harsh,
> > isn't it?
> > 
> > From 86e6fa5f618fe588b98e923e032f33e075fcd4f4 Mon Sep 17 00:00:00
> > 2001
> > From: Johannes Thumshirn <jthumshirn@suse.de>
> > Date: Tue, 31 Jan 2017 10:16:00 +0100
> > Subject: [PATCH] scsi: don't BUG_ON() empty DMA transfers
> > 
> > Don't crash the machine just because of an empty transfer. Use
> > WARN_ON()
> > combined with returning an error.
> > 
> > Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
> > ---
> >  drivers/scsi/scsi_lib.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> > index e9e1e14..414588a 100644
> > --- a/drivers/scsi/scsi_lib.c
> > +++ b/drivers/scsi/scsi_lib.c
> > @@ -1040,7 +1040,8 @@ int scsi_init_io(struct scsi_cmnd *cmd)
> >         bool is_mq = (rq->mq_ctx != NULL);
> >         int error;
> > 
> > -       BUG_ON(!blk_rq_nr_phys_segments(rq));
> > +       if (WARN_ON(!blk_rq_nr_phys_segments(rq)))
> > +               return -EINVAL;
> 
> 
> Please-please-please, let's not use WARN for something that is not a
> kernel bug and is user-triggerable.

It is a kernel bug and it should not be user triggerable, so it should
have a warn_on or bug_on.  It means something called a data setup
function with no data.  There's actually a root cause that patches like
this won't fix, can we find it?

James

