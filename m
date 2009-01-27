From: "Jing Huang" <huangj@Brocade.COM>
Subject: RE: [PATCH 2/5] bfa: Brocade BFA FC SCSI driver submission
Date: Tue, 27 Jan 2009 15:07:11 -0800
Message-ID: <4C94DE2070B172459E4F1EE14BD2364E027534DA@HQ-EXCH-5.corp.brocade.com>
References: <200901271854.n0RIs73a026759@swe37.brocade.com> <20090127221618.GA26480@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx30.brocade.com ([144.49.194.4]:47108 "EHLO mx30.brocade.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751332AbZA0XHP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 27 Jan 2009 18:07:15 -0500
Content-class: urn:content-classes:message
In-Reply-To: <20090127221618.GA26480@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: James.Bottomley@HansenPartnership.com, Krishna Gudipati <kgudipat@Brocade.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Ramkumar Vadivelu <rvadivel@Brocade.COM>, Vinodh Ravindran <vravindr@Brocade.COM>



> -----Original Message-----
> From: Christoph Hellwig [mailto:hch@infradead.org]
> Sent: Tuesday, January 27, 2009 2:16 PM
> To: Jing Huang
> Cc: James.Bottomley@HansenPartnership.com; Krishna Gudipati; linux-
> kernel@vger.kernel.org; linux-scsi@vger.kernel.org; Ramkumar Vadivelu;
> Vinodh Ravindran
> Subject: Re: [PATCH 2/5] bfa: Brocade BFA FC SCSI driver submission
> 
> On Tue, Jan 27, 2009 at 10:54:07AM -0800, Jing Huang wrote:
> > +/**
> > + * Generic HAL callback element.
> > + */
> > +struct bfa_cb_qe_s {
> > +	struct bfa_q_s         qe;
> > +	bfa_cb_cbfn_t  cbfn;
> > +	bfa_boolean_t   once;
> > +	u32		rsvd;
> > +	void           *cbarg;
> > +};
> > +
> > +#define bfa_cb_queue(__bfa, __hcb_qe, __cbfn, __cbarg) do {
\
> > +	(__hcb_qe)->cbfn  = (__cbfn);
\
> > +	(__hcb_qe)->cbarg = (__cbarg);
\
> > +	bfa_q_enq(&(__bfa)->comp_q, (__hcb_qe));
\
> > +} while (0)
> 
> Please stop here, weird HALs and own list management routines are not
> things we put into the tree.  (except for gregs junk subdirectory..)
> 
> Please rewrite this into a proper Linux driver.


Thanks Christoph for the code review,

I will clean up all the HAL references and also replace our own list
management code with standard linux implementation.

Jing
