From: "Mukker, Atul" <atulm@lsil.com>
Subject: RE: [PATCH] megaraid driver fix for 2.5.70
Date: Fri, 6 Jun 2003 11:03:48 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <0E3FA95632D6D047BA649F95DAB60E570185F235@EXA-ATLANTA.se.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:58028 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S261825AbTFFOuV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Jun 2003 10:50:21 -0400
List-Id: linux-scsi@vger.kernel.org
To: 'James Bottomley' <James.Bottomley@SteelEye.com>
Cc: Mark Haverkamp <markh@osdl.org>, Linus Torvalds <torvalds@transmeta.com>, Linux Kernel <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

> > Coming back to main issue, declaring complete mailbox would 
> be superfluous
> > since driver uses 16 bytes at most. The following patch 
> should fix the panic
> > 
> >  	mbox = (mbox_t *)raw_mbox;
> >  
> > -	memset(mbox, 0, sizeof(*mbox));
> > +	memset(mbox, 0, 16);
> >  
> >  	memset((void *)adapter->mega_buffer, 0, MEGA_BUFFER_SIZE);
> >  
> 
> This, I think, is a bad idea.  It looks intrinsically wrong 
> to allocate
> storage and assign a pointer to it of a type that is longer than the
> allocated storage.  The initial buffer overrun was due to 
> problems with
> this.

IMO then, your original patch should be good.

