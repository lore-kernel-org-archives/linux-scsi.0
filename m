From: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH][RFC 2/23]: SCST core
Date: Tue, 16 Dec 2008 23:22:03 +0100
Message-ID: <20081216222203.GI14787@elte.hu>
References: <49400ACD.3070502@vlnb.net> <20081210191213.GA15273@uranus.ravnborg.org> <49414DBE.6070801@vlnb.net> <20081211210917.GB27010@uranus.ravnborg.org> <4942BA85.3070408@vlnb.net> <1229118607.24995.18.camel@localhost.localdomain> <4943CAAB.4050008@vlnb.net> <c62985530812131635k362fc8d2q3c65e8284141f491@mail.gmail.com> <20081216214926.GU14787@elte.hu> <c62985530812161413j59fc0fdy31024a540bf0c197@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx3.mail.elte.hu ([157.181.1.138]:56944 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751671AbYLPWWf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 16 Dec 2008 17:22:35 -0500
Content-Disposition: inline
In-Reply-To: <c62985530812161413j59fc0fdy31024a540bf0c197@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Cc: Vladislav Bolkhovitin <vst@vlnb.net>, Steven Rostedt <srostedt@redhat.com>, Sam Ravnborg <sam@ravnborg.org>, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@hansenpartnership.com>, Andrew Morton <akpm@linux-foundation.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Jeff Garzik <jeff@garzik.org>, Boaz Harrosh <bharrosh@panasas.com>, Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org, scst-devel@lists.sourceforge.net, Bart Van Assche <bart.vanassche@gmail.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>


* Fr=E9d=E9ric Weisbecker <fweisbec@gmail.com> wrote:

> 2008/12/16 Ingo Molnar <mingo@elte.hu>:
> >
> > * Fr=E9d=E9ric Weisbecker <fweisbec@gmail.com> wrote:
> >
> >> > All the above functionality is almost what we need. The only thi=
ng
> >> > left, which I forgot to mention, is possibility to log also func=
tions
> >> > return value on exit. This is what TRACE_EXIT_RES() in SCST does=
=2E Is
> >> > it possible to add those?
> >>
> >> I want to add that on the function graph tracer. That can be done =
pretty
> >> easily. The only problem comes with the type of the return value. =
Would
> >> this tracer be supposed to always return a 64 bits value regardles=
s of
> >> the real typ of the value? There would be some pointless bytes on =
most
> >> return values. I don't know how to proceed for this problem.
> >
> > Things like mov ...,%eax are zero-extend so they'll zap the high 32=
 bits.
>=20
>=20
> That's right, but the problem occurs under 32 bits. The return values=
=20
> for 64 bits are in eax and edx. And most of the time, the high part=20
> (edx) will be junk.

for wider types i'd suggest to just print the low bits. Most of the=20
interesting return types fit into machine word.

> > The real problem are byte return values generated via things like:
> >
> >   movb $1, %al
> >
> > those wont zero-extend, so you could get garbage in the output. One
> > approach would be to try a quick hack just to see how common a prob=
lem
> > this is.
>=20
>=20
> Yes, I will try something.
>=20
> > We could extract the return type from the debuginfo, hash it in a
> > read-mostly table and then look it up, but that seems complex both =
in
> > terms of build overhead and in terms of runtime overhead.
>=20
> I thought about it too and as you say it's rather complex. And thinki=
ng=20
> about non primitive types (like pid_t....) that would require a secon=
d=20
> pass of analysis to retrieve the corresponding primitive...

structure returns would be rather evil to handle, agreed.

Unrelated:

it would be really nice if we could extend ftrace to trace system calls=
=20
and their parameters and return values. We used to have that in the=20
latency-tracer in -rt, and it was rather useful. Controlled by a=20
trace_option i guess - and blendable into any of the tracer outputs=20
(function tracer most notably).

Explicit calls in the entry.S files would be OK for this - but maybe we=
=20
can get this via the tricky use of a TIF_ flags as well, to force the c=
ode=20
into the ptrace callbacks and then divert it for ftrace's pleasure?

	Ingo
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
