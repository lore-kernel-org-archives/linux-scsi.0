From: Parag Warudkar <parag.lkml@gmail.com>
Subject: Re: [PATCH] SCSI IOCTL: Check for device deletion [was Re:
 __elv_add_request OOPS]
Date: Wed, 25 May 2011 19:00:10 -0400
Message-ID: <BANLkTimuomu=_JuMr7SWrMVvboMX4BX0fA@mail.gmail.com>
References: <alpine.DEB.2.02.1105232329040.1910@natty-nar>
	<4DDB8BF6.2000304@fusionio.com>
	<alpine.DEB.2.02.1105242127340.3472@ubuntu-natty>
	<4DDCB1C8.7040708@fusionio.com>
	<alpine.DEB.2.02.1105251416340.3472@ubuntu-natty>
	<BANLkTimZi6rPSA-1OX+ZAh3135SMpDcHKg@mail.gmail.com>
	<4DDD5240.2060308@fusionio.com>
	<BANLkTikSXMZ3a6-e4-k5dV5vHtegxuUL-w@mail.gmail.com>
	<4DDD55D6.1080909@fusionio.com>
	<alpine.DEB.2.02.1105251548420.2742@ubuntu-natty>
	<BANLkTimWPWc4k2_q0KZpmWo9G93UmVWoxA@mail.gmail.com>
	<alpine.DEB.2.02.1105251613500.8972@ubuntu-natty>
	<BANLkTimndXcBJ9wwJrcTt3Pf3vaNVUUtwg@mail.gmail.com>
	<alpine.DEB.2.02.1105251638220.8972@ubuntu-natty>
	<1306356735.1641.61.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1306356735.1641.61.camel@mulgrave.site>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Jens Axboe <jaxboe@fusionio.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, Linux SCSI List <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, May 25, 2011 at 4:52 PM, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
> On Wed, 2011-05-25 at 16:42 -0400, Parag Warudkar wrote:
>> Yeah - that makes sense. By that logic, looks like we can only disal=
low
>> for SDEV_DEL (if we decide to do that check here).
>
> I don't think this is the root cause. =A0I think q is non-NULL but ha=
s
> already been released, so we're just getting a NULL deref on the actu=
al
> list head.
>
> Does this fix it? =A0It adds the refcounting at approximately the cor=
rect
> places. =A0Of course, we'll now be trying elevator operations on an e=
xtant
> queue but one whose elevator functions have been destroyed, so there =
are
> probably additional state guards to place.

[ Resend with URL - I got a bounce back from vger for attaching the OOP=
S JPEG ]

It doesn't seem to help. Machine locked up and I was dropped to text
console. I could only capture the oops by a camera.

OOPS available at below URLs [*]

Parag

[*] https://picasaweb.google.com/lh/photo/yccmqaz3xwumwjvecb-b0pTdDOYIf=
=46RksMrZBIo-Inw?feat=3Ddirectlink

[*] https://picasaweb.google.com/lh/photo/Lim6d3b8p7Lj4D3nHmkbFJTdDOYIf=
=46RksMrZBIo-Inw?feat=3Ddirectlink
