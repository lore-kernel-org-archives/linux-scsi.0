From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
Subject: Re: [PATCH][RFC 2/23]: SCST core
Date: Tue, 16 Dec 2008 23:13:44 +0100
Message-ID: <c62985530812161413j59fc0fdy31024a540bf0c197@mail.gmail.com>
References: <494009D7.4020602@vlnb.net> <49400ACD.3070502@vlnb.net>
	 <20081210191213.GA15273@uranus.ravnborg.org>
	 <49414DBE.6070801@vlnb.net>
	 <20081211210917.GB27010@uranus.ravnborg.org>
	 <4942BA85.3070408@vlnb.net>
	 <1229118607.24995.18.camel@localhost.localdomain>
	 <4943CAAB.4050008@vlnb.net>
	 <c62985530812131635k362fc8d2q3c65e8284141f491@mail.gmail.com>
	 <20081216214926.GU14787@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.24]:59627 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752682AbYLPWNp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Dec 2008 17:13:45 -0500
In-Reply-To: <20081216214926.GU14787@elte.hu>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ingo Molnar <mingo@elte.hu>
Cc: Vladislav Bolkhovitin <vst@vlnb.net>, Steven Rostedt <srostedt@redhat.com>, Sam Ravnborg <sam@ravnborg.org>, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@hansenpartnership.com>, Andrew Morton <akpm@linux-foundation.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Jeff Garzik <jeff@garzik.org>, Boaz Harrosh <bharrosh@panasas.com>, Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org, scst-devel@lists.sourceforge.net, Bart Van Assche <bart.vanassche@gmail.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>

2008/12/16 Ingo Molnar <mingo@elte.hu>:
>
> * Fr=E9d=E9ric Weisbecker <fweisbec@gmail.com> wrote:
>
>> > All the above functionality is almost what we need. The only thing
>> > left, which I forgot to mention, is possibility to log also functi=
ons
>> > return value on exit. This is what TRACE_EXIT_RES() in SCST does. =
Is
>> > it possible to add those?
>>
>> I want to add that on the function graph tracer. That can be done pr=
etty
>> easily. The only problem comes with the type of the return value. Wo=
uld
>> this tracer be supposed to always return a 64 bits value regardless =
of
>> the real typ of the value? There would be some pointless bytes on mo=
st
>> return values. I don't know how to proceed for this problem.
>
> Things like mov ...,%eax are zero-extend so they'll zap the high 32 b=
its.


That's right, but the problem occurs under 32 bits. The return values
for 64 bits
are in eax and edx. And most of the time, the high part (edx) will be j=
unk.


> The real problem are byte return values generated via things like:
>
>   movb $1, %al
>
> those wont zero-extend, so you could get garbage in the output. One
> approach would be to try a quick hack just to see how common a proble=
m
> this is.


Yes, I will try something.

> We could extract the return type from the debuginfo, hash it in a
> read-mostly table and then look it up, but that seems complex both in
> terms of build overhead and in terms of runtime overhead.

I thought about it too and as you say it's rather complex. And
thinking about non primitive types (like pid_t....)
that would require a second pass of analysis to retrieve the
corresponding primitive...
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
