From: "Mukker, Atul" <Atulm@lsil.com>
Subject: RE: [ANNOUNCE]: megaraid driver version 2.20.0.1
Date: Tue, 20 Jul 2004 17:21:46 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <0E3FA95632D6D047BA649F95DAB60E57033BC897@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:9696 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S266281AbUGTVWC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Jul 2004 17:22:02 -0400
List-Id: linux-scsi@vger.kernel.org
To: 'James Bottomley' <James.Bottomley@SteelEye.com>
Cc: 'Christoph Hellwig' <hch@infradead.org>, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>

This is a delayed post because of some offline discussions.



> The biggest structural issue still seems to be the pending queue.  It
> looks to me like the driver could be nicely simplified if you 
> got rid of
> it and simply relied on returning SCSI_MLQUEUE_HOST_BUSY from
> queeucommand().  You'd still get the queue restart almost from the ISR
> like you want.
Is there a existing driver using this interface.

> The biggest structural issue still seems to be the pending queue.  It
> looks to me like the driver could be nicely simplified if you 
> got rid of
> it and simply relied on returning SCSI_MLQUEUE_HOST_BUSY from
> queeucommand().  You'd still get the queue restart almost from the ISR
> like you want.
> 
> My other main gripe is things like this:
> 
> +	// wait for maximum 1 second for status to post
> +	for (i = 0; i < 40000; i++) {
> +		if (mbox->numstatus != 0xFF) break;
> +		udelay(25); yield();
> +	}
> 
Also, are these two changes gating factor for the driver to be included in
the kernel. I do not want to make driver releases too often, unless
of-course there is a critical fix, since it reset the driver validation in
our testing labs. I have marked this and the yield() fix for the next drop
of the driver
