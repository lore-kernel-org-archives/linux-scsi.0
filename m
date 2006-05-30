From: "Ju, Seokmann" <Seokmann.Ju@lsil.com>
Subject: RE: [PATCH] megaraid_mbox: fix section mismatch warnings
Date: Tue, 30 May 2006 11:11:59 -0600
Message-ID: <890BF3111FB9484E9526987D912B261901BD9C@NAMAIL3.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:10186 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S932322AbWE3RMN convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 May 2006 13:12:13 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: "Randy.Dunlap" <rdunlap@xenotime.net>, __smail D?nmez <ismail@pardus.org.tr>, scsi <linux-scsi@vger.kernel.org>, akpm <akpm@osdl.org>, jejb <james.bottomley@steeleye.com>, "Kolli, Neela" <Neela.Kolli@engenio.com>


> Why would you want to do that?  A subfunction of a __devinit function
> should also be __devinit (unless it's alsoi used by something which
> isn't __devinit, of course)
For similar reason as you pointed out, I thought it would be good to remove (unless it is required) the tag so that it can be called by any functions in the driver if needed be.
I don't have enough knowledge on the topic, unfortunately. Is it hardly required to have the tag on all sub-functions called in the function?
If so, there are couple of other sub-functions need to have the tag.

Thank you,

Seokmann

> -----Original Message-----
> From: Matthew Wilcox [mailto:matthew@wil.cx] 
> Sent: Tuesday, May 30, 2006 1:03 PM
> To: Ju, Seokmann
> Cc: Randy.Dunlap; __smail D?nmez; scsi; akpm; jejb; Kolli, Neela
> Subject: Re: [PATCH] megaraid_mbox: fix section mismatch warnings
> 
> On Tue, May 30, 2006 at 07:37:18AM -0600, Ju, Seokmann wrote:
> > >   */
> > > -static int __init
> > > +static int __devinit
> > >  megaraid_init_mbox(adapter_t *adapter)
> 
> > Thank you for pointing out a bug.
> > However, in my opinion, I would rather to simply remove 
> '__init' from the function.
> > The function is just a sub function called by 
> megaraid_probe_one which has '__devinit' tag.
> > Please let me know if this is acceptable.
> > I will submit a patch with proper change.
> 
> Why would you want to do that?  A subfunction of a __devinit function
> should also be __devinit (unless it's alsoi used by something which
> isn't __devinit, of course)
> 
