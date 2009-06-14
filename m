From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: -git tree build failure #2: drivers/net/cnic.c:2520: error:
 implicit declaration of function
 =?UTF-8?Q?=E2=80=98=5F=5Fsymbol=5Fget=E2=80=99?=
Date: Sun, 14 Jun 2009 09:15:11 -0500
Message-ID: <1244988911.4096.23.camel@mulgrave.site>
References: <20090612184343.GA11900@elte.hu> <4A32A1E4.8080708@oracle.com>
	 <20090613062933.GA14034@elte.hu>
	 <alpine.LFD.2.01.0906131309560.3237@localhost.localdomain>
	 <1244925747.5323.57.camel@mulgrave.site> <1244940182.12000.5.camel@HP1>
	 <1244943216.5323.86.camel@mulgrave.site>  <1244945885.12000.13.camel@HP1>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:51356 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759290AbZFNOPP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 14 Jun 2009 10:15:15 -0400
In-Reply-To: <1244945885.12000.13.camel@HP1>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michael Chan <mchan@broadcom.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>, Randy Dunlap <randy.dunlap@oracle.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>, linux-scsi <linux-scsi@vger.kernel.org>

On Sat, 2009-06-13 at 19:18 -0700, Michael Chan wrote:
> On Sat, 2009-06-13 at 18:33 -0700, James Bottomley wrote:
> > On Sat, 2009-06-13 at 17:43 -0700, Michael Chan wrote:
[...]
> > > Thanks James and Ingo.  We don't want to have a symbol dependency on
> > > bnx2 because this driver eventually will support the 10G bnx2x driver as
> > > well.  So we want the driver to support either or both NIC drivers
> > > without both drivers loaded.  Please use the patch below.
> > 
> > Um, but that's not going to work very well.  When you have your 10G
> > driver, they'll both have to export the symbol name bnx2_cnic_probe
> > which the kernel isn't going to like.  You can differentiate the symbols
> > and add a multiple symbol lookup in init_bnx2_cnic(), but that's getting
> > ugly.
> 
> Yeah, the plan is to have a bnx2x_cnic_probe() when we add support for
> that.  There will be a separate init_bnx2x_cnic() because the hardware
> interface is not exactly the same.
> 
> > 
> > What about doing something more standard, like bus matching?  That's how
> > the SCSI upper layer drivers work:  we export a virtual SCSI bus and
> > they bind to it if a supporting device appears.  You could do something
> > similar exporting a virtual cnic bus from your network drivers and get
> > the cnic driver to bind to it.
> > 
> 
> This will require some additional infra-structure.  We can look into
> this when we support the 10G driver.  Thanks.

So if you're going to redo it for the 10G driver, and without the 10G
driver there really seems no need to have a call by reflection in there,
why not simply do a direct call until the 10G driver is added?  This
will save everyone potential hassle from what is a highly unusual
interface.

James


