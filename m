From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 3/3] tcm ibmvscsis driver
Date: Wed, 16 Feb 2011 08:21:57 +0900
Message-ID: <20110216082140T.fujita.tomonori@lab.ntt.co.jp>
References: <AANLkTin3Zb3OQz0942-2bcpfwqd8dGGnHyBjmeYt0FwZ@mail.gmail.com>
	<20110215124208B.fujita.tomonori@lab.ntt.co.jp>
	<AANLkTimPyjgoSnZrSXT2asV1Ly5D3NFUM3cn0-Jmp3Zm@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:35860 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755731Ab1BOXWG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Feb 2011 18:22:06 -0500
In-Reply-To: <AANLkTimPyjgoSnZrSXT2asV1Ly5D3NFUM3cn0-Jmp3Zm@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bvanassche@acm.org
Cc: fujita.tomonori@lab.ntt.co.jp, linux-scsi@vger.kernel.org, brking@linux.vnet.ibm.com

On Tue, 15 Feb 2011 20:20:53 +0100
Bart Van Assche <bvanassche@acm.org> wrote:

> On Tue, Feb 15, 2011 at 4:42 AM, FUJITA Tomonori
> <fujita.tomonori@lab.ntt.co.jp> wrote:
> > On Mon, 14 Feb 2011 12:50:40 +0100
> > Bart Van Assche <bvanassche@acm.org> wrote:
> >
> >> - send_rsp() sends back an SRP response with req_lim_delta = 1 before
> >> srp_iu_put() is invoked. I think this is a race condition: it can
> >> happen that the SRP initiator has received an SRP_RSP and sends a new
> >> SRP_CMD before srp_iu_put() was invoked. On a heavily loaded system
> >> that can trigger a queue overflow in the target.
> >
> > Yeah, we had better to handle such case better.
> >
> > But I don't think that we hit a critical event such as crash, memory
> > corruption, etc, with the current code.
> >
> > In such case, srp_iu_get return NULL, so the target ignores the
> > request, then eventually the initiator recovers.
> 
> Sorry but I do not agree that hitting this race is harmless. If this
> race gets triggered the credit associated with the lost SRP
> information unit will never be returned to the initiator. If this
> happens frequently enough (INITIAL_SRP_LIMIT times), the initiator
> will run out of credits and will lock up forever.

I'm not sure that happens because the initiator increases
hostdata->request_limit when the request hits the time out.


> > Probably, we should set the queue size to INITIAL_SRP_LIMIT + 1.
> 
> With the current implementation of the SCSI storage target core that's
> probably sufficient. But if that core is ever modified such that
> multiple SCSI commands can be processed concurrently, that limit
> wouldn't be sufficient anymore because then the described race
> condition could be triggered in multiple threads simultaneously - at
> least in theory.

ok.


> An alternative solution is to modify send_iu() such that srp_iu_put()
> is invoked after all relevant data has been copied via h_copy_rdma()
> and to the CRQ and before h_send_crq() is invoked. That approach has
> e.g. been implemented in this patch:
> http://www.spinics.net/lists/linux-scsi/msg49105.html.

Sounds an option. I'll take a look.

Thanks,
