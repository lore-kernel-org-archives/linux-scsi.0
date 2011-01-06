From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH 4/7] [SCSI] scst: Add SRP target driver
Date: Thu, 6 Jan 2011 18:41:41 +0100
Message-ID: <AANLkTineDYxbjEdtfBJ6WjLfxs2VvqnQ9v887vExHga7@mail.gmail.com>
References: <201012201849.27639.bvanassche@acm.org> <adaaajfdrtr.fsf@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <adaaajfdrtr.fsf-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, scst-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, James.Bottomley-l3A5Bk7waGM@public.gmane.org, Vu Pham <vu-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, Jan 5, 2011 at 9:21 PM, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> wrote=
:
>
> So, just looking over some of the atomic_t usage here (which is usual=
ly
> one of the first places I review):
>
> =A0> +struct srpt_send_ioctx {
> =A0> ...
> =A0> + =A0 =A0atomic_t =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0state;
>
> this seems to be accessed only with atomic_read(), atomic_set() and
> atomic_cmpxchg() (without any memory barriers). =A0It's rather hard t=
o see
> that this is correct (and indeed without memory barriers I suspect it=
's
> not; also since atomic_read() does not protect the state from changin=
g
> immediately afterwards there may be other races).
>
> I think it might be better to handle this in a simpler, more naive
> way -- just have a lock (probably an existing one) that protects the
> contents of state and not use cmpxchg().
>
> In any case since no "real" atomic operations are used, I suspect it
> would be better to just code this in terms of unsigned int and regula=
r
> cmpxchg().

Hello Roland,

Thanks for the feedback.

I'll have a look at converting these atomic operations into regular
locking. The current implementation should be fine though.
Manipulating I/O context state only happens inside callback functions.
These callback functions are either invoked by the SCST core or from
inside an IB completion callback. For each I/O context at most one
such callback function is active at any time. Even if different
callback functions would be invoked on different CPU cores, it is the
responsibility of either the SCST core or the IB core / driver to
provide proper synchronization (memory barrier).

There is one exception though: the function srpt_pending_cmd_timeout()
can in theory proceed concurrently with an IB completion callback.
This is why I/O context state manipulation was implemented via atomic
operations. That race is unlikely to cause any harm though: the
callback srpt_pending_cmd_timeout() is only invoked if 60 seconds
(srpt_template.max_hw_pending_time) after an IB send was posted no IB
completion has been received. This timeout should be a magnitude
larger than the time needed to receive an IB completion indicating
either success or failure.

Please note that with IB firmware that complies to the IB specs the
function srpt_pending_cmd_timeout() will never be invoked because
before that function gets invoked an IB completion will already have
been received.

> Also, there is processing_compl:
>
> =A0> +static void srpt_completion(struct ib_cq *cq, void *ctx)
> =A0> +{
> =A0> + =A0 =A0struct srpt_rdma_ch *ch =3D ctx;
> =A0> +
> =A0> + =A0 =A0BUG_ON(!ch);
> =A0> + =A0 =A0atomic_inc(&ch->processing_compl);
>
> and
>
> =A0> +static void srpt_unregister_channel(struct srpt_rdma_ch *ch)
> =A0> ...
> =A0> + =A0 =A0while (atomic_read(&ch->processing_compl))
> =A0> + =A0 =A0 =A0 =A0 =A0 =A0;
>
> this seems racy to me -- I don't see any reason why we couldn't have:
>
> =A0 =A0 =A0 =A0srpt_completion()
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0srpt_unregister_channel()
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0processing_compl =3D=3D 0,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0continue
>
> =A0 =A0 =A0 =A0 =A0atomic_inc(&ch->processing_compl);
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0finish unregistering channel
>
> =A0 =A0 =A0 =A0 =A0use unregistered channel

I'm not sure what the above pseudo-code should do ?

Regarding the current implementation: there is a hard requirement in
SCST that no new commands are queued for a given session after
scst_unregister_session() has been invoked. So
scst_unregister_session() must only be invoked after the IB queue pair
has been reset *and* srpt_completion() has finished. It would be great
if that could be implemented without using one or another kind of
counter. I'm not sure however whether it is possible to eliminate the
"processing_compl" counter entirely.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
