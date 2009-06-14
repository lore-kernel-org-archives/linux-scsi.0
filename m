From: "Michael Chan" <mchan@broadcom.com>
Subject: Re: -git tree build failure #2: drivers/net/cnic.c:2520: error:
 implicit declaration of function
 =?UTF-8?Q?=E2=80=98=5F=5Fsymbol=5Fget=E2=80=99?=
Date: Sat, 13 Jun 2009 19:18:05 -0700
Message-ID: <1244945885.12000.13.camel@HP1>
References: <20090612184343.GA11900@elte.hu>
 <4A32A1E4.8080708@oracle.com> <20090613062933.GA14034@elte.hu>
 <alpine.LFD.2.01.0906131309560.3237@localhost.localdomain>
 <1244925747.5323.57.camel@mulgrave.site> <1244940182.12000.5.camel@HP1>
 <1244943216.5323.86.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1152 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751474AbZFNCZC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 13 Jun 2009 22:25:02 -0400
In-Reply-To: <1244943216.5323.86.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>, Randy Dunlap <randy.dunlap@oracle.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>, linux-scsi <linux-scsi@vger.kernel.org>


On Sat, 2009-06-13 at 18:33 -0700, James Bottomley wrote:
> On Sat, 2009-06-13 at 17:43 -0700, Michael Chan wrote:
> > On Sat, 2009-06-13 at 13:42 -0700, James Bottomley wrote:
> > > On Sat, 2009-06-13 at 13:11 -0700, Linus Torvalds wrote:
> > > > 
> > > > 
> > > > That makes no sense. 
> > > > 
> > > > Look at the first #include in the file - it already includes 
> > > > <linux/module.h>.
> > > > 
> > > > Why do we need to do it twice?
> > > 
> > > We don't ... it's the wrong fix.  The actual problem is that
> > > __symbol_get() is only defined for the modular case.  What it looks to
> > > be doing is a reflection call on bnx2_cnic_probe().  I'm not sure why
> > > it's doing this ... other than perhaps cnic wants to avoid an explicit
> > > bnx2 dependency?  I actually think it's incorrect, since the netdev code
> > > before it just checked bnx2 is present, so I see no harm in an explicit
> > > call, so this should fix it.
> > > 
> > > If it had a good reason for the reflective call, then symbol_get()
> > > without the __ should be used.
> > > 
> > > Michael Chan, could you confirm?
> > > 
> > Thanks James and Ingo.  We don't want to have a symbol dependency on
> > bnx2 because this driver eventually will support the 10G bnx2x driver as
> > well.  So we want the driver to support either or both NIC drivers
> > without both drivers loaded.  Please use the patch below.
> 
> Um, but that's not going to work very well.  When you have your 10G
> driver, they'll both have to export the symbol name bnx2_cnic_probe
> which the kernel isn't going to like.  You can differentiate the symbols
> and add a multiple symbol lookup in init_bnx2_cnic(), but that's getting
> ugly.

Yeah, the plan is to have a bnx2x_cnic_probe() when we add support for
that.  There will be a separate init_bnx2x_cnic() because the hardware
interface is not exactly the same.

> 
> What about doing something more standard, like bus matching?  That's how
> the SCSI upper layer drivers work:  we export a virtual SCSI bus and
> they bind to it if a supporting device appears.  You could do something
> similar exporting a virtual cnic bus from your network drivers and get
> the cnic driver to bind to it.
> 

This will require some additional infra-structure.  We can look into
this when we support the 10G driver.  Thanks.


