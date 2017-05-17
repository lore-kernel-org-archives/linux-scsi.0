From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: Re: [PREEMPT-RT] [REEEEPOST] bnx2i + bnx2fc: convert to generic
 workqueue (#3)
Date: Wed, 17 May 2017 17:07:34 +0200
Message-ID: <20170517150734.dkfghfgd4v4ucttf@linutronix.de>
References: <20170410171254.30367-1-bigeasy@linutronix.de>
 <20170504174427.6hebbnqwfgems6dg@linutronix.de>
 <yq1inlass3y.fsf@oracle.com>
 <alpine.OSX.2.00.1705091015070.1067@administrators-MacBook-Pro.local>
 <1494343100.2688.34.camel@linux.vnet.ibm.com>
 <alpine.OSX.2.00.1705121149580.1329@n6024mn55p0yw1.qlogic.org>
 <20170517150153.2eamcjtc4frx2cae@linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from Galois.linutronix.de ([146.0.238.70]:46432 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754085AbdEQPHl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 May 2017 11:07:41 -0400
Content-Disposition: inline
In-Reply-To: <20170517150153.2eamcjtc4frx2cae@linutronix.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chad Dupuis <chad.dupuis@cavium.com>
Cc: Chris Leech <cleech@redhat.com>, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, Chad Dupuis <chad.dupuis@qlogic.com>, rt@linutronix.de, Lee Duncan <lduncan@suse.com>, QLogic-Storage-Upstream@qlogic.com, Andrew Morton <akpm@linux-foundation.org>, Johannes Thumshirn <jth@kernel.org>, Christoph Hellwig <hch@lst.de>

On 2017-05-17 17:01:53 [+0200], To Chad Dupuis wrote:
> On 2017-05-12 11:55:52 [-0400], Chad Dupuis wrote:
> > Ok, I believe I've found the issue here.  The machine that the test has 
> > performed on had many more possible CPUs than active CPUs.  We calculate 
> > which CPU to the work time on in bnx2fc_process_new_cqes() like this:
> > 
> > unsigned int cpu = wqe % num_possible_cpus();
> > 
> > Since not all CPUs are active, we were trying to schedule work on 
> > non-active CPUs which meant that the upper layers were never notified of 
> > the completion.  With this change:
> > 
> > diff --git a/drivers/scsi/bnx2fc/bnx2fc_hwi.c 
> > b/drivers/scsi/bnx2fc/bnx2fc_hwi.c
> > index c2288d6..6f08e43 100644
> > --- a/drivers/scsi/bnx2fc/bnx2fc_hwi.c
> > +++ b/drivers/scsi/bnx2fc/bnx2fc_hwi.c
> > @@ -1042,7 +1042,12 @@ static int bnx2fc_process_new_cqes(struct 
> > bnx2fc_rport *tgt)
> >                         /* Pending work request completion */
> >                         struct bnx2fc_work *work = NULL;
> >                         struct bnx2fc_percpu_s *fps = NULL;
> > -                       unsigned int cpu = wqe % num_possible_cpus();
> > +                       unsigned int cpu = wqe % num_active_cpus();
> > +
> > +                       /* Sanity check cpu to make sure it's online */
> > +                       if (!cpu_active(cpu))
> > +                               /* Default to CPU 0 */
> > +                               cpu = 0;
> >  
> >                         work = bnx2fc_alloc_work(tgt, wqe);
> >                         if (work) {
> > 
> > The issue is fixed.
> > 
> > Sebastian, can you add this change to your patch set?
> 
> Are sure that you can reliably reproduce the issue and fix it with the
> patch above? Because this patch:

oh. Okay. Now it clicked. It can fix the issue but it is still possible,
that CPU0 goes down between your check for it and schedule_work_on()
returning. Let my think of something…

Sebastian
