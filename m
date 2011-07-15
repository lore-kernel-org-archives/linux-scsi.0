From: "Eddie Wai" <eddie.wai@broadcom.com>
Subject: Re: [PATCH v2] BNX2I: Fixed kernel panic due to illegal usage
 of sc->request->cpu
Date: Thu, 14 Jul 2011 18:11:01 -0700
Message-ID: <1310692261.3678.172.camel@ltirv-waie-lx1>
References: <Eddie Wai <eddie.wai@broadcom.com>
 <1310686953-601-1-git-send-email-eddie.wai@broadcom.com>
 <1310689761.7032.6.camel@HP1>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:2063 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754865Ab1GOBLP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 14 Jul 2011 21:11:15 -0400
In-Reply-To: <1310689761.7032.6.camel@HP1>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michael Chan <mchan@broadcom.com>
Cc: James Bottomley <jbottomley@parallels.com>, Mike Christie <michaelc@cs.wisc.edu>, open-iscsi <open-iscsi@googlegroups.com>, linux-scsi <linux-scsi@vger.kernel.org>, Anil Veerabhadrappa <anilgv@broadcom.com>, Benjamin Li <benli@broadcom.com>


On Thu, 2011-07-14 at 17:29 -0700, Michael Chan wrote:
> On Thu, 2011-07-14 at 16:42 -0700, Eddie Wai wrote:
> > A kernel panic was observed when passing the sc->request->cpu = -1 to
> > retrieve the per_cpu variable pointer:
> >  #0 [ffff880011203960] machine_kexec at ffffffff81022bc3
> >  #1 [ffff8800112039b0] crash_kexec at ffffffff81088630
> >  #2 [ffff880011203a80] __die at ffffffff8139ea20
> >  #3 [ffff880011203aa0] no_context at ffffffff8102f3a7
> >  #4 [ffff880011203ae0] __bad_area_nosemaphore at ffffffff8102f665
> >  #5 [ffff880011203ba0] retint_signal at ffffffff8139dd1f
> >  #6 [ffff880011203cc8] bnx2i_indicate_kcqe at ffffffffa03dc4f2
> >  #7 [ffff880011203da8] service_kcqes at ffffffffa03cb04f
> >  #8 [ffff880011203e68] cnic_service_bnx2x_kcq at ffffffffa03cb14a
> >  #9 [ffff880011203e88] cnic_service_bnx2x_bh at ffffffffa03cb1b3
> > 
> > The problem lies in the sg_io (and perhaps sg_scsi_ioctl) call to
> > blk_get_request->get_request/wait->blk_alloc_request->blk_rq_init which
> > re-initializes the request->cpu to -1.  There is no assignment for cpu from
> > that to the request_fn call to low level drivers.
> > 
> > When this happens, the sc->request->cpu will be using the init value of
> > -1.  This will create a kernel panic when it hits bnx2i because the code
> > refers it to get the per_cpu variables ptr.
> > 
> > This change is to put in a guard against that and also for cases when
> > bio affinity/queue completion to the same cpu is not enabled.  In those
> > cases, the request->cpu will remain a -1 also.
> > 
> > This bug was created from commit:  b5cf6b63f73abdc051035f0050b367beeb2ef94c
> > 
> > For the case when the blk layer did not setup the request->cpu, bnx2i
> > will complete the sc with the current CPU of the thread.
> > 
> > Signed-off-by: Eddie Wai <eddie.wai@broadcom.com>
> > ---
> >  drivers/scsi/bnx2i/bnx2i_hwi.c |    9 ++++++++-
> >  1 files changed, 8 insertions(+), 1 deletions(-)
> > 
> > diff --git a/drivers/scsi/bnx2i/bnx2i_hwi.c b/drivers/scsi/bnx2i/bnx2i_hwi.c
> > index 54978c1..0e71615 100644
> > --- a/drivers/scsi/bnx2i/bnx2i_hwi.c
> > +++ b/drivers/scsi/bnx2i/bnx2i_hwi.c
> > @@ -1901,6 +1901,7 @@ static int bnx2i_queue_scsi_cmd_resp(struct iscsi_session *session,
> >  	struct iscsi_task *task;
> >  	struct scsi_cmnd *sc;
> >  	int rc = 0;
> > +	int cpu;
> >  
> >  	spin_lock(&session->lock);
> >  	task = iscsi_itt_to_task(bnx2i_conn->cls_conn->dd_data,
> > @@ -1912,7 +1913,13 @@ static int bnx2i_queue_scsi_cmd_resp(struct iscsi_session *session,
> >  	sc = task->sc;
> >  	spin_unlock(&session->lock);
> >  
> > -	p = &per_cpu(bnx2i_percpu, sc->request->cpu);
> > +	if (!blk_rq_cpu_valid(sc->request)) {
> > +		cpu = get_cpu();
> > +		put_cpu();
> 
> Why not just use smp_processor_id()?
Good point.  This is run inside a tasklet which preemption is already
disabled.  I'll make the change, thanks.
> 
> > +	} else
> > +		cpu = sc->request->cpu;
> > +
> > +	p = &per_cpu(bnx2i_percpu, cpu);
> >  	spin_lock(&p->p_work_lock);
> >  	if (unlikely(!p->iothread)) {
> >  		rc = -EINVAL;
> 


