From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: memcpy_toio/memcpy_fromio 64 bit safe?
Date: Wed, 16 Mar 2005 15:20:13 -0500
Message-ID: <60807403EABEB443939A5A7AA8A7458BED2496@otce2k01.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Received: from magic.adaptec.com ([216.52.22.17]:22731 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S262779AbVCPUUQ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Mar 2005 15:20:16 -0500
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-scsi@vger.kernel.org

OK, 64 bit unsigned long was the missing piece.

Still locking up when we make the call, will attack this as a different
issue.

Sincerely -- Mark Salyzyn

-----Original Message-----
From: linux-scsi-owner@vger.kernel.org
[mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Arjan van de Ven
Sent: Wednesday, March 16, 2005 3:18 PM
To: Salyzyn, Mark
Cc: linux-scsi@vger.kernel.org
Subject: Re: memcpy_toio/memcpy_fromio 64 bit safe?

On Wed, 2005-03-16 at 15:08 -0500, Salyzyn, Mark wrote:
> The dpt_i2o driver uses the function memcpy_toio to copy the message
> frame to the adapter. Under arch/x86_64/lib/io.c, it's helper function
> is defined as:
> 
> void __memcpy_toio(unsigned long dst,const void*src,unsigned len)
> {
>         __inline_memcpy((void *) dst,src,len);
> }
> 
> The first argument should be 'volatile void __iomem * dst' I would
have
> expected. As such, the 64 bit virtual address representing the adapter
> address passed in gets truncated (please correct me if I am wrong).

well ioremap returns a void* so the pointer math should be fine...

Also longs are 64 bit (on x86-64)... so what's the big deal ?

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
