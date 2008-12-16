From: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH][RFC 2/23]: SCST core
Date: Tue, 16 Dec 2008 22:49:26 +0100
Message-ID: <20081216214926.GU14787@elte.hu>
References: <494009D7.4020602@vlnb.net> <49400ACD.3070502@vlnb.net> <20081210191213.GA15273@uranus.ravnborg.org> <49414DBE.6070801@vlnb.net> <20081211210917.GB27010@uranus.ravnborg.org> <4942BA85.3070408@vlnb.net> <1229118607.24995.18.camel@localhost.localdomain> <4943CAAB.4050008@vlnb.net> <c62985530812131635k362fc8d2q3c65e8284141f491@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.mail.elte.hu ([157.181.151.9]:58074 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752248AbYLPVuS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 16 Dec 2008 16:50:18 -0500
Content-Disposition: inline
In-Reply-To: <c62985530812131635k362fc8d2q3c65e8284141f491@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Cc: Vladislav Bolkhovitin <vst@vlnb.net>, Steven Rostedt <srostedt@redhat.com>, Sam Ravnborg <sam@ravnborg.org>, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@hansenpartnership.com>, Andrew Morton <akpm@linux-foundation.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Jeff Garzik <jeff@garzik.org>, Boaz Harrosh <bharrosh@panasas.com>, Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org, scst-devel@lists.sourceforge.net, Bart Van Assche <bart.vanassche@gmail.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>


* Fr=E9d=E9ric Weisbecker <fweisbec@gmail.com> wrote:

> > All the above functionality is almost what we need. The only thing=20
> > left, which I forgot to mention, is possibility to log also functio=
ns=20
> > return value on exit. This is what TRACE_EXIT_RES() in SCST does. I=
s=20
> > it possible to add those?
>=20
> I want to add that on the function graph tracer. That can be done pre=
tty=20
> easily. The only problem comes with the type of the return value. Wou=
ld=20
> this tracer be supposed to always return a 64 bits value regardless o=
f=20
> the real typ of the value? There would be some pointless bytes on mos=
t=20
> return values. I don't know how to proceed for this problem.

Things like mov ...,%eax are zero-extend so they'll zap the high 32 bit=
s.

The real problem are byte return values generated via things like:

   movb $1, %al

those wont zero-extend, so you could get garbage in the output. One=20
approach would be to try a quick hack just to see how common a problem=20
this is.

We could extract the return type from the debuginfo, hash it in a=20
read-mostly table and then look it up, but that seems complex both in=20
terms of build overhead and in terms of runtime overhead.

	Ingo
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
