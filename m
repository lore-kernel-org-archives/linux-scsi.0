From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH] sym53c8xx: Fix bogus sym_que_entry re-implementation
	of container_of
Date: Mon, 07 Jul 2008 16:43:37 +1000
Message-ID: <1215413017.8970.101.camel@pasglop>
References: <20080707005030.503A3DDE08@ozlabs.org>
	 <da824cf30807062335q5057a816wf4071bbec3052093@mail.gmail.com>
Reply-To: benh@kernel.crashing.org
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gate.crashing.org ([63.228.1.57]:55920 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752938AbYGGGns (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 7 Jul 2008 02:43:48 -0400
In-Reply-To: <da824cf30807062335q5057a816wf4071bbec3052093@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Grant Grundler <grundler@google.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@hansenpartnership.com>, Matthew Wilcox <matthew@wil.cx>

On Sun, 2008-07-06 at 23:35 -0700, Grant Grundler wrote:
> > --- linux-work.orig/drivers/scsi/sym53c8xx_2/sym_misc.h 2008-07-07 10:42:03.000000000 +1000
> > +++ linux-work/drivers/scsi/sym53c8xx_2/sym_misc.h      2008-07-07 10:44:41.000000000 +1000
> > @@ -121,9 +121,7 @@ static __inline void sym_que_move(struct
> >        }
> >  }
> >
> > -#define sym_que_entry(ptr, type, member) \
> > -       ((type *)((char *)(ptr)-(unsigned int)(&((type *)0)->member)))
> > -
> > +#define sym_que_entry(ptr, type, member) container_of(ptr, type, member)
> 
> There are 11 uses of sym_que_entry() macro. Is that too many to
> completely remove it's use?
> (question for willy to decide I guess).

Willy wants to completely remove the queue management. While that might
be the right thing to do, I'd like the small fixup to go in to at least
remove the warnings in the meantime.

Cheers,
Ben.


