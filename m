From: Laurence Oberman <loberman@redhat.com>
Subject: Re: [Open-FCoE] Issue with fc_exch_alloc failing initiated by
 fc_queuecommand on NUMA or large configurations with Intel ixgbe running
 FCOE
Date: Sat, 8 Oct 2016 13:53:01 -0400 (EDT)
Message-ID: <1360350390.815966.1475949181371.JavaMail.zimbra@redhat.com>
References: <209207528.804499.1475931430678.JavaMail.zimbra@redhat.com> <2d30ad34-7a5e-b2ba-05f4-b0d831944f4c@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx6-phx2.redhat.com ([209.132.183.39]:33922 "EHLO
        mx6-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750745AbcJHRxH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 8 Oct 2016 13:53:07 -0400
In-Reply-To: <2d30ad34-7a5e-b2ba-05f4-b0d831944f4c@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, fcoe-devel@open-fcoe.org, "Curtis Taylor (cjt@us.ibm.com)" <cjt@us.ibm.com>, Bud Brown <bubrown@redhat.com>



----- Original Message -----
> From: "Hannes Reinecke" <hare@suse.de>
> To: "Laurence Oberman" <loberman@redhat.com>, "Linux SCSI Mailinglist" <linux-scsi@vger.kernel.org>,
> fcoe-devel@open-fcoe.org
> Cc: "Curtis Taylor (cjt@us.ibm.com)" <cjt@us.ibm.com>, "Bud Brown" <bubrown@redhat.com>
> Sent: Saturday, October 8, 2016 1:35:19 PM
> Subject: Re: [Open-FCoE] Issue with fc_exch_alloc failing initiated by fc_queuecommand on NUMA or large
> configurations with Intel ixgbe running FCOE
> 
> On 10/08/2016 02:57 PM, Laurence Oberman wrote:
> > Hello
> >
> > This has been a tough problem to chase down but was finally reproduced.
> > This issue is apparent on RHEL kernels and upstream so justified reporting
> > here.
> >
> > Its out there and some may not be aware its even happening other than very
> > slow
>  > performance using ixgbe and software FCOE on large configurations.
> >
> > Upstream Kernel used for reproducing is 4.8.0
> >
> > I/O performance was noted to be very impacted on a large NUMA test system
> > (64 CPUS 4 NUMA nodes) running the software fcoe stack with Intel ixgbe
> > interfaces.
> > After capturing blktraces we saw for every I/O there was at least one
> > blk_requeue_request and sometimes hundreds or more.
> > This resulted in IOPS rates being marginal at best with queuing and high
> > wait times.
> > After narrowing this down with systemtap and trace-cmd we added further
> > debug and it was apparent this was dues to SCSI_MLQUEUE_HOST_BUSY being
> > returned.
> > So I/O passes but very slowly as it constantly having to be requeued.
> >
> > The identical configuration in our lab with a single NUMA node and 4 CPUS
> > does not see this issue at all.
> > The same large system that reproduces this was booted with numa=off and
> > still sees the issue.
> >
> Have you tested with my FCoE fixes?
> I've done quite some fixes for libfc/fcoe, and it would be nice to see
> how the patches behave with this setup.
> 
> > The flow is as follows:
> >
> > From with fc_queuecommand
> >           fc_fcp_pkt_send() calls fc_fcp_cmd_send() calls
> >           tt.exch_seq_send() which calls fc_exch_seq_send
> >
> > this fails and returns NULL in fc_exch_alloc() as the list traveral never
> > creates a match.
> >
> > static struct fc_seq *fc_exch_seq_send(struct fc_lport *lport,
> > 				       struct fc_frame *fp,
> > 				       void (*resp)(struct fc_seq *,
> > 						    struct fc_frame *fp,
> > 						    void *arg),
> > 				       void (*destructor)(struct fc_seq *,
> > 							  void *),
> > 				       void *arg, u32 timer_msec)
> > {
> > 	struct fc_exch *ep;
> > 	struct fc_seq *sp = NULL;
> > 	struct fc_frame_header *fh;
> > 	struct fc_fcp_pkt *fsp = NULL;
> > 	int rc = 1;
> >
> > 	ep = fc_exch_alloc(lport, fp);     ***** Called Here and fails
> > 	if (!ep) {
> > 		fc_frame_free(fp);
> > 		printk("RHDEBUG: In fc_exch_seq_send returned NULL because !ep with ep =
> > 		%p\n",ep);
> > 		return NULL;
> > 	}
> > ..
> > ..
> > ]
> >
> >
> >  fc_exch_alloc() - Allocate an exchange from an EM on a
> >  *	/**
> >  *	     local port's list of EMs.
> >  * @lport: The local port that will own the exchange
> >  * @fp:	   The FC frame that the exchange will be for
> >  *
> >  * This function walks the list of exchange manager(EM)
> >  * anchors to select an EM for a new exchange allocation. The
> >  * EM is selected when a NULL match function pointer is encountered
> >  * or when a call to a match function returns true.
> >  */
> > static inline struct fc_exch *fc_exch_alloc(struct fc_lport *lport,
> > 					    struct fc_frame *fp)
> > {
> > 	struct fc_exch_mgr_anchor *ema;
> >
> > 	list_for_each_entry(ema, &lport->ema_list, ema_list)
> > 		if (!ema->match || ema->match(fp))
> > 			return fc_exch_em_alloc(lport, ema->mp);
> > 	return NULL;                                 ***** Never matches so
> > 	returns NULL
> > }
> >
> >
> > RHDEBUG: In fc_exch_seq_send returned NULL because !ep with ep = (null)
> > RHDEBUG: rc -1 with !seq = (null) after calling tt.exch_seq_send  within
> > fc_fcp_cmd_send
> > RHDEBUG: rc non zero in :unlock within fc_fcp_cmd_send = -1
> > RHDEBUG: In fc_fcp_pkt_send, we returned from  rc = lport->tt.fcp_cmd_send
> > with rc = -1
> >
> > RHDEBUG: We hit SCSI_MLQUEUE_HOST_BUSY in fc_queuecommand with rval in
> > fc_fcp_pkt_send=-1
> >
> > I am trying to get my head around why a large multi-node system sees this
> > issue even with NUMA disabled.
> > Has anybody seen this or is aware of this with configurations (using
> > fc_queuecommand)
> >
> > I am continuing to add debug to narrow this down.
> >
> You might actually be hitting a limitation in the exchange manager code.
> The libfc exchange manager tries to be really clever and will assign a
> per-cpu exchange manager (probably to increase locality). However, we
> only have a limited number of exchanges, so on large systems we might
> actually run into a exchange starvation problem, where we have in theory
> enough free exchanges, but none for the submitting cpu.
> 
> (Personally, the exchange manager code is in urgent need of reworking.
> It should be replaced by the sbitmap code from Omar).
> 
> Do check how many free exchanges are actually present for the stalling
> CPU; it might be that you run into a starvation issue.
> 
> Cheers,
> 
> Hannes
> --
> Dr. Hannes Reinecke		      zSeries & Storage
> hare@suse.de			      +49 911 74053 688
> SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
> GF: J. Hawn, J. Guild, F. Imendörffer, HRB 16746 (AG Nürnberg)
> 
Hi Hannes, 
Thanks for responding

I am adding additional debug as I type this.

I am using latest linux-next, I assume your latest FCOE are not in there yet.
What is puzzling here is a identical kernel with 1 numa node and only 8GB memory does not see this.
Surely if I was running out of exchanges that would show up on the smaller system as well.
I am able to get to 1500 IOPS/sec with the same I/O exerciser on the smaller system with ZERO blk_requeue_request() calls.
Again, same kernel, same ixgbe same FCOE switch etc.

I traced specifically those initially because we saw it in the blktrace.

I dont understand the match stuff going on in the list reversal stuff here very well, still trying to understand the code flow.
the bool match() I also cannot figure out from the code.
It runs the fc_exch_em_alloc() if ether bool *match is false or *match(fp)
I can't find the actual code for the match, will have to get a vmcore to find it.

 static inline struct fc_exch *fc_exch_alloc(struct fc_lport *lport,
 					    struct fc_frame *fp)
 {
	struct fc_exch_mgr_anchor *ema;

 	list_for_each_entry(ema, &lport->ema_list, ema_list)
 		if (!ema->match || ema->match(fp))
 			return fc_exch_em_alloc(lport, ema->mp);
 	return NULL;                                 ***** Never matches so
	returns NULL
 }

Will replay after some finer debug has been added

Again specific to fc_queuecommand and S/W FCOE, not an issue with the F/C queuecommand in the HBA templates fro example lpfc or qla2xxx and alos not applicable to full offload FCOE like the Emulex cards.
Thanks
Laurence
