From: "Jing Huang" <huangj@Brocade.COM>
Subject: RE: [PATCH 2/5] bfa: Brocade BFA FC SCSI driver submission
Date: Wed, 28 Jan 2009 10:02:43 -0800
Message-ID: <4C94DE2070B172459E4F1EE14BD2364E02753674@HQ-EXCH-5.corp.brocade.com>
References: <200901271854.n0RIs73a026759@swe37.brocade.com> <20090127221618.GA26480@infradead.org> <4C94DE2070B172459E4F1EE14BD2364E027534DA@HQ-EXCH-5.corp.brocade.com> <1233164662.3236.93.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx40.brocade.com ([144.49.195.4]:27635 "EHLO mx40.brocade.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750954AbZA1SC6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Jan 2009 13:02:58 -0500
Content-class: urn:content-classes:message
In-Reply-To: <1233164662.3236.93.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Christoph Hellwig <hch@infradead.org>, Krishna Gudipati <kgudipat@Brocade.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Ramkumar Vadivelu <rvadivel@Brocade.COM>, Vinodh Ravindran <vravindr@Brocade.COM>

James Bottomley Wrote:
> > > > + * Generic HAL callback element.
> > > > + */
> > > > +struct bfa_cb_qe_s {
> > > > +	struct bfa_q_s         qe;
> > > > +	bfa_cb_cbfn_t  cbfn;
> > > > +	bfa_boolean_t   once;
> > > > +	u32		rsvd;
> > > > +	void           *cbarg;
> > > > +};
> > > > +
> > > > +#define bfa_cb_queue(__bfa, __hcb_qe, __cbfn, __cbarg) do {
> > \
> > > > +	(__hcb_qe)->cbfn  = (__cbfn);
> > \
> > > > +	(__hcb_qe)->cbarg = (__cbarg);
> > \
> > > > +	bfa_q_enq(&(__bfa)->comp_q, (__hcb_qe));
> > \
> > > > +} while (0)
> > >
> > > Please stop here, weird HALs and own list management routines are
not
> > > things we put into the tree.  (except for gregs junk
subdirectory..)
> > >
> > > Please rewrite this into a proper Linux driver.
> >
> >
> > Thanks Christoph for the code review,
> >
> > I will clean up all the HAL references and also replace our own list
> > management code with standard linux implementation.
> 
> This might take a while.  I can offer to put this driver in the
staging
> tree while you work on it if that would be helpful?
> 
> The way the staging tree works is that drivers are held in a separate
> area (drivers/staging) in the linux kernel while they're being worked
> on.  The driver can be installed by users while it's in the staging
tree
> (so made use of) but it will taint the kernel with a warning that it's
> not of linux kernel quality yet.  Once we get an acceptable driver in
> drivers/staging, I'll move it across to drivers/scsi and remove the
> taint.
> 
> James
> 
> 

This is definitely helpful, thanks James!

Jing

