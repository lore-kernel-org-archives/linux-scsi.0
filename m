From: Roland Dreier <rdreier@cisco.com>
Subject: Re: [PATCH 4/7] [SCSI] scst: Add SRP target driver
Date: Thu, 06 Jan 2011 11:00:10 -0800
Message-ID: <adahbdldfid.fsf@cisco.com>
References: <201012201849.27639.bvanassche@acm.org>
	<adaaajfdrtr.fsf@cisco.com>
	<AANLkTineDYxbjEdtfBJ6WjLfxs2VvqnQ9v887vExHga7@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sj-iport-4.cisco.com ([171.68.10.86]:5485 "EHLO
	sj-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751553Ab1AFTAN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Jan 2011 14:00:13 -0500
In-Reply-To: <AANLkTineDYxbjEdtfBJ6WjLfxs2VvqnQ9v887vExHga7@mail.gmail.com>
	(Bart Van Assche's message of "Thu, 6 Jan 2011 18:41:41 +0100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: linux-scsi@vger.kernel.org, scst-devel@lists.sourceforge.net, linux-rdma@vger.kernel.org, James.Bottomley@suse.de, Vu Pham <vu@mellanox.com>, Roland Dreier <rolandd@cisco.com>, David Dillow <dave@thedillows.org>

 > I'll have a look at converting these atomic operations into regular
 > locking. The current implementation should be fine though.

I believe that the current implementation is correct.  However it is
much harder for someone naive like me to understand, since using cmpxch=
g
is much subtler than just using a lock to protect data.  If this isn't
on the hottest of hot paths then I think cmpxchg is over-optimization -=
-
much better to have less fancy code.

 > > Also, there is processing_compl:
 > >
 > > =C2=A0> +static void srpt_completion(struct ib_cq *cq, void *ctx)
 > > =C2=A0> +{
 > > =C2=A0> + =C2=A0 =C2=A0struct srpt_rdma_ch *ch =3D ctx;
 > > =C2=A0> +
 > > =C2=A0> + =C2=A0 =C2=A0BUG_ON(!ch);
 > > =C2=A0> + =C2=A0 =C2=A0atomic_inc(&ch->processing_compl);
 > >
 > > and
 > >
 > > =C2=A0> +static void srpt_unregister_channel(struct srpt_rdma_ch *=
ch)
 > > =C2=A0> ...
 > > =C2=A0> + =C2=A0 =C2=A0while (atomic_read(&ch->processing_compl))
 > > =C2=A0> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0;
 > >
 > > this seems racy to me -- I don't see any reason why we couldn't ha=
ve:
 > >
 > > =C2=A0 =C2=A0 =C2=A0 =C2=A0srpt_completion()
 > >
 > > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
srpt_unregister_channel()
 > > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0processing_compl =3D=3D 0,
 > > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0continue
 > >
 > > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0atomic_inc(&ch->processing_compl=
);
 > >
 > > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0finish unregistering channel
 > >
 > > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0use unregistered channel
 >=20
 > I'm not sure what the above pseudo-code should do ?

I'm trying to illustrate the race by showing what two different context=
s
might be doing -- the left column is one context, the right column is
the other context.

In this specific case, if the while loop testing processing_compl
actually ever does anything then I don't see how it could be safe -- if
srpt_completion() could be executing during the while loop, then I don'=
t
see anything that prevents the while loop from finishing before
srpt_completion does its atomic_inc().

 > Regarding the current implementation: there is a hard requirement in
 > SCST that no new commands are queued for a given session after
 > scst_unregister_session() has been invoked. So
 > scst_unregister_session() must only be invoked after the IB queue pa=
ir
 > has been reset *and* srpt_completion() has finished. It would be gre=
at
 > if that could be implemented without using one or another kind of
 > counter. I'm not sure however whether it is possible to eliminate th=
e
 > "processing_compl" counter entirely.

I don't pretend to understand the flow of code here.  But it seems the
only safe way to implement this cleanup code is to stop posting work
requests and then wait until all the requests you've posted are
complete.  Trying to wait for the completion handler to stop executing
does not seem possible to implement in a safe way.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
