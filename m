From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 4/7] [SCSI] scst: Add SRP target driver
Date: Wed, 05 Jan 2011 12:21:52 -0800
Message-ID: <adaaajfdrtr.fsf@cisco.com>
References: <201012201849.27639.bvanassche@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201012201849.27639.bvanassche-HInyCGIudOg@public.gmane.org> (Bart Van Assche's
	message of "Mon, 20 Dec 2010 18:49:27 +0100")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, scst-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, James.Bottomley-l3A5Bk7waGM@public.gmane.org, Vu Pham <vu-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

So, just looking over some of the atomic_t usage here (which is usually
one of the first places I review):

 > +struct srpt_send_ioctx {
 > ...
 > +	atomic_t		state;

this seems to be accessed only with atomic_read(), atomic_set() and
atomic_cmpxchg() (without any memory barriers).  It's rather hard to see
that this is correct (and indeed without memory barriers I suspect it's
not; also since atomic_read() does not protect the state from changing
immediately afterwards there may be other races).

I think it might be better to handle this in a simpler, more naive
way -- just have a lock (probably an existing one) that protects the
contents of state and not use cmpxchg().

In any case since no "real" atomic operations are used, I suspect it
would be better to just code this in terms of unsigned int and regular
cmpxchg().

Also, there is processing_compl:

 > +static void srpt_completion(struct ib_cq *cq, void *ctx)
 > +{
 > +	struct srpt_rdma_ch *ch = ctx;
 > +
 > +	BUG_ON(!ch);
 > +	atomic_inc(&ch->processing_compl);

and

 > +static void srpt_unregister_channel(struct srpt_rdma_ch *ch)
 > ...
 > +	while (atomic_read(&ch->processing_compl))
 > +		;

this seems racy to me -- I don't see any reason why we couldn't have:

	srpt_completion()

					srpt_unregister_channel()
					  processing_compl == 0,
					  continue

	  atomic_inc(&ch->processing_compl);

					  finish unregistering channel

	  use unregistered channel

 - R.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
