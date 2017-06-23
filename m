From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH v2 3/6] qla2xxx: Add FC-NVMe F/W initialization and
 transport registration
Date: Fri, 23 Jun 2017 08:28:51 +0200
Message-ID: <20170623062850.GA13014@linux-x5ow.site>
References: <20170621204846.21663-1-himanshu.madhani@cavium.com>
 <20170621204846.21663-4-himanshu.madhani@cavium.com>
 <20170622094649.GD5670@linux-x5ow.site>
 <42181B8C-0E6A-436B-9201-E4C42D581B50@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56679 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754502AbdFWG3B (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 23 Jun 2017 02:29:01 -0400
Content-Disposition: inline
In-Reply-To: <42181B8C-0E6A-436B-9201-E4C42D581B50@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Madhani, Himanshu" <Himanshu.Madhani@cavium.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi <linux-scsi@vger.kernel.org>, "Trapp, Darren" <Darren.Trapp@cavium.com>, "Malavali, Giridhar" <Giridhar.Malavali@cavium.com>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>

On Fri, Jun 23, 2017 at 03:16:09AM +0000, Madhani, Himanshu wrote:
> if this is not *must* i’ll like to post patch for this with other patches that I am going to queue up during rc1 phase. 

Ok.

[...]

> I saw your response to James that this is okay for FC NVMe code.
> 
> > [...]
> > 
> >> +	vha = (struct scsi_qla_host *)lport->private;
> > 
> > No need to cast from void *
> >> +	ql_log(ql_log_info, vha, 0x2104,
> >> +	    "%s: handle %p, idx =%d, qsize %d\n",
> >> +	    __func__, handle, qidx, qsize);
> > 
> > Btw, sometime in the future you could change your ql_log() thingies to the
> > kernel's dyndebug facility.
> > 
> > […]
> 
> Thanks for the suggestions. I’ll bring it up to team and we can slowly convert these to kernel’s
> dynamic debugging facility. 

Thanks a lot.
> 
> 
> >> +	rval = ha->isp_ops->abort_command(sp);
> >> +	if (rval != QLA_SUCCESS)
> >> +		ql_log(ql_log_warn, fcport->vha, 0x2125,
> >> +		    "%s: failed to abort LS command for SP:%p rval=%x\n",
> >> +		    __func__, sp, rval);
> >> +
> >> +	ql_dbg(ql_dbg_io, fcport->vha, 0x212b,
> >> +	    "%s: aborted sp:%p on fcport:%p\n", __func__, sp, fcport);
> > 
> > If you insinst in having these two messages ("failed to abort" and "aborted")
> > can you at least fold it into one print statement.
> > 
> 
> I’ll send follow up patch for this cleanup, if its okay with you? 

OK

[...]
> > I've just seen this in qla2xxx_start_scsi_mq() and
> > qla2xxx_dif_start_scsi_mq() and was about to send you an RFC patch. But
> > here it is for completeness in the nvme version as well:
> > 
> > You save a pointer to the req_que from you qpair and _afterwards_ you grab
> > the qp_lock. What prevents someone from changing the request internals
> > underneath you?
> > 
> > Like this:
> > 
> > CPU0                               CPU1
> > req = qpair->req;
> >                                 qla2xxx_delete_qpair(vha, qpair);
> >                                 `-> ret = qla25xx_delete_req_que(vha, qpair->req);
> > spin_lock_irqsave(&qpair->qp_lock, flags);
> > handle = req->current_outstanding_cmd;
> > 
> > Oh and btw, neither qla2xxx_delete_qpair() nor qla25xx_delete_req_que() grab
> > the qp_lock.
> > 
> > I think this is something work re-thinking. Maybe you can identify the blocks
> > accessing struct members which need to be touched under a lock and extract
> > them into a helper function wich calls lockdep_assert_held(). No must just and
> > idea.
> > 
> 
> This is very valid point you brought up and thanks for the detail review comment. 
> from your patch submitted this morning, I’ll like to have our test team run through 
> regression testing with these changes and we can incorporate that into NVMe as well
> and send a follow up patch to correct this. Would you be okay with that? 

That patch has a bug and I'll need to respin it, but I'll be sending you a v2
today.

> 
> > [...]
> >> +
> >> +	/* Load data segments */
> >> +	for_each_sg(sgl, sg, tot_dsds, i) {
> > 
> > Do you really need the whole loop under a spin_lock_irqsave()? If the sglist
> > has a lot of entries (i.e. becasue we couldn't cluster it) we're in risk to
> > trigger a NMI watchdog soft-lockup WARN_ON(). You need to grab the lock when
> > accessing req's members but the rest of the loop? This applies to
> > qla24xx_build_scsi_iocbs() for SCSI as well.
> > 
> 
> Since these changes would need us to do regression testing, I would like to send a follow up 
> patch to correct them as a separate patch.

Sure.

> 
> > [...]
> > 
> >> +	struct qla_qpair *qpair = (struct qla_qpair *)hw_queue_handle;
> > 
> > Void pointer cast. Someone really should write a coccinelle script to get rid
> > of em.
> > 
> 
> Will send a follow up patch for cleanup
> 
> > [...]
> > 
> >> +	/* Alloc SRB structure */
> >> +	sp = qla2xxx_get_qpair_sp(qpair, fcport, GFP_ATOMIC);
> >> +	if (!sp)
> >> +		return -EIO;
> > 
> > __blk_mq_run_hw_queue()
> > `-> blk_mq_sched_dispatch_requests()
> >    `-> blk_mq_dispatch_rq_list()
> >        `-> nvme_fc_queue_rq()
> >            `-> nvme_fc_start_fcp_op() 
> >                `-> qla_nvme_post_cmd()
> > isn't called from an IRQ context and qla2xxx_get_qpair_sp() internally
> > uses mempool_alloc(). From mempool_alloc()'s documentation:
> > 
> > "Note that due to preallocation, this function *never* fails when called from
> > process contexts. (it might fail if called from an IRQ context.)"
> > mm/mempool.c:306
> > 
> 
> 
> Will investigate and work on fixing this. 


I think I did a mistake here, qla2xxx_get_qpair_sp() can fail for other
reasons than OOM. My bad, sorry.

> Thanks for these details review of this series and valuable input. 
> 
> I’ll send follow up series shortly. Let me know if this series is okay as is and
> a follow up patches to address concerns by you are okay.

Thanks a lot,
	Johannes
-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
