From: "Smart, James" <James.Smart@Emulex.Com>
Subject: RE: [Emulex] queuecommands and GFP_ATOMIC
Date: Tue, 8 Jun 2004 15:06:58 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3356669BBE90C448AD4645C843E2BF28034F9470@xbl.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:44454 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S265291AbUFHTHO
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 8 Jun 2004 15:07:14 -0400
List-Id: linux-scsi@vger.kernel.org
To: 'Christoph Hellwig' <hch@infradead.org>
Cc: Anton Blanchard <anton@samba.org>, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>

Actually, we are using spin_unlock_irq().  We're looking further...  I take
it from your response, this calling sequence should not have been an issue ?

-- james


> -----Original Message-----
> From: 'Christoph Hellwig' [mailto:hch@infradead.org]
> Sent: Tuesday, June 08, 2004 2:24 PM
> To: Smart, James
> Cc: 'Christoph Hellwig'; Anton Blanchard; 'linux-scsi@vger.kernel.org'
> Subject: Re: [Emulex] queuecommands and GFP_ATOMIC
> 
> 
> On Tue, Jun 08, 2004 at 02:21:05PM -0400, Smart, James wrote:
> > So we've done some testing with the locks moved and the GFP_xxx flag
> > changed...
> > 
> > On a RedHat 3.90 2.6.5 kernel, we hit the following:
> > 
> > Debug: sleeping function called from invalid context at 
> mm/slab.c:1980
> > in_atomic():1, irqs_disabled():0
> > Call Trace:
> 
> Looks like you used spin_unlock instead of spin_unlock_irq 
> for the host
> lock.
> 
