From: "Mukker, Atul" <Atulm@lsil.com>
Subject: RE: [ANNOUNCE]: megaraid driver version 2.20.0.1
Date: Thu, 24 Jun 2004 21:07:48 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <0E3FA95632D6D047BA649F95DAB60E57033BC7CA@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:28827 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S264798AbUFYBI2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 24 Jun 2004 21:08:28 -0400
List-Id: linux-scsi@vger.kernel.org
To: 'Christoph Hellwig' <hch@infradead.org>, "Mukker, Atul" <Atulm@lsil.com>
Cc: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>

Christoph,

I have put the revised driver on the ftp server

ftp://ftp.lsil.com/pub/linux-megaraid/drivers/version-2.20.0.1/

This driver incorporates almost all your suggestions. I think it's high
time, the driver makes into the mainstream kernel.

Please see my other responses below


> Umm, of course.  But the default statements are usually only 
> for things
> which are nessecary to get a working ssystem.  E.g. the much 
> more widely
> used Intel PIIX or VIA IDE controller drivers found on just 
> about every
> motherboard don't have a default statement either.
> 
Fixed


> I didn't actually complain about macros, but that the include 
> files aren't
> in the individual files.
The low level drivers (megaraid_mbox.c) includes their main header file
(megaraid_mbox.h). The main header file includes all the relevant header
files

> 
> > >  - MRAID_GET_DEVICE_MAP is far too large for a macro, 
> please make it a
> > >    function call or opencode it in the callers
> > 
> > Still needs to be done.  There's only one caller anyway, so 
> no need for
> > the macro
> > AM> This code base uses at only one place, but there is 
> another low level
> > driver if offing which uses the same definitions. So this 
> should stay.
> 
> then please convert it to an inline function.
Then we would need to have a inline function in the header file itself (no
common C library anymore), which is a kludge. If the comments are ignored,
it isn't a very big macro after all.

> Sorry, my apologies.  I still looked huge beause you have 
> each ID spread
> over multiple lines.  
I am hesitant to club all on one line, since many entries would violate our
80-column rule

> 
> > >  - alloc_adapter_f/init_mbox_f in megaraid_probe_one and 
> use proper gotos
> > >    as I did in the old megaraid driver
> > 
> > still needs to be done.
FIXED

> 
> > >  - the detach path is bogus.  You need to do 
> scshi_remove_host first
FIXED

> 
> > >  - your locking looks far to fine-grained to me.  Did you 
> benchmark it?
Megaraid is not the only driver, which has fine-grained locks in 2.6.7. I
will anyway provide the driver comparisons
