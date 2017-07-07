From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: Re: [PATCH 1/5] scsi: bnx2i: convert to workqueue
Date: Fri, 7 Jul 2017 15:32:27 +0200
Message-ID: <20170707133227.dopa2a5spe3hnaj7@linutronix.de>
References: <20170410171254.30367-1-bigeasy@linutronix.de>
 <20170410171254.30367-2-bigeasy@linutronix.de>
 <20170629135756.GP3808@linux-x5ow.site>
 <20170707131419.bfglh4kqwwuowyej@linutronix.de>
 <alpine.OSX.2.00.1707070918420.891@administrators-MacBook-Pro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from Galois.linutronix.de ([146.0.238.70]:60427 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750984AbdGGNcg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Jul 2017 09:32:36 -0400
Content-Disposition: inline
In-Reply-To: <alpine.OSX.2.00.1707070918420.891@administrators-MacBook-Pro.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chad Dupuis <chad.dupuis@cavium.com>
Cc: Johannes Thumshirn <jthumshirn@suse.de>, "Martin K . Petersen" <martin.petersen@oracle.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, rt@linutronix.de, Lee Duncan <lduncan@suse.com>, Chris Leech <cleech@redhat.com>, Chad Dupuis <chad.dupuis@qlogic.com>, QLogic-Storage-Upstream@qlogic.com, Johannes Thumshirn <jth@kernel.org>, Christoph Hellwig <hch@lst.de>, Andrew Morton <akpm@linux-foundation.org>

On 2017-07-07 09:20:02 [-0400], Chad Dupuis wrote:
> What was the question?  My observation is that the patch I proposed fixed 
> the issue we saw on testing the patch set.  With that small change 
> (essentially modulo by the number of active CPUs vs. the total number) 
> your patch set worked ok.

That mail at the bottom of this mail where I said why I think your patch
is a nop in this context.

Sebastian

On 2017-05-17 17:07:34 [+0200], To Chad Dupuis wrote:
> > > Sebastian, can you add this change to your patch set?
> >
> > Are sure that you can reliably reproduce the issue and fix it with the
> > patch above? Because this patch:
>
> oh. Okay. Now it clicked. It can fix the issue but it is still possible,
> that CPU0 goes down between your check for it and schedule_work_on()
> returning. Let my think of something…

Oh wait. I already thought about this: it may take bnx2fc_percpu from
CPU7 and run the worker on CPU3. The job isn't lost, because the worker
does:
                                                    
| static void bnx2fc_percpu_io_work(struct work_struct *work_s)
| {
|         struct bnx2fc_percpu_s *p;
 …
|         p = container_of(work_s, struct bnx2fc_percpu_s, work);
|
|         spin_lock_bh(&p->fp_work_lock);

and so will access bnx2fc_percpu of CPU7 running on CPU3. So I *think*
that your patch should make no difference and there should be no leak if
schedule_work_on() is invoked on an offline CPU.
