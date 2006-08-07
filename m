From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: [PATCH 1/4] aacraid:  interruptible ioctl
Date: Mon, 7 Aug 2006 07:49:24 -0400
Message-ID: <547AF3BD0F3F0B4CBDC379BAC7E4189F02AC7454@otce2k03.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gw3.adaptec.com ([216.52.22.36]:37035 "EHLO
	mail-gw3.adaptec.com") by vger.kernel.org with ESMTP
	id S1750773AbWHGLtZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Aug 2006 07:49:25 -0400
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, Mark Haverkamp <markh@osdl.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi <linux-scsi@vger.kernel.org>

We need to leak the fib, as it is still owned by the controller until
the command has infact completed. The interrupt service completing the
command, if it ever occurs, will cause the FIB to be returned to the
pool.

Sincerely -- Mark Salyzyn

> -----Original Message-----
> From: Christoph Hellwig [mailto:hch@infradead.org] 
> Sent: Friday, August 04, 2006 11:20 AM
> To: Mark Haverkamp
> Cc: James Bottomley; Salyzyn, Mark; linux-scsi
> Subject: Re: [PATCH 1/4] aacraid: interruptible ioctl
> 
> 
> > -#include <linux/delay.h>
> > +#include <linux/delay.h> /* ssleep prototype */
> 
> do we really need that comment?
> 
> >  #include <linux/kthread.h>
> >  #include <asm/semaphore.h>
> >  #include <asm/uaccess.h>
> > @@ -140,7 +140,8 @@
> >  		fibptr->hw_fib_pa = hw_fib_pa;
> >  		fibptr->hw_fib = hw_fib;
> >  	}
> > -	aac_fib_free(fibptr);
> > +	if (retval != -EINTR)
> > +		aac_fib_free(fibptr);
> 
> even if we are interrupted we shouldn't leak the fib, should we?
> 
> 
