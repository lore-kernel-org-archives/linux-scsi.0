From: Arjan van de Ven <arjan@infradead.org>
Subject: Re: memcpy_toio/memcpy_fromio 64 bit safe?
Date: Wed, 16 Mar 2005 21:18:21 +0100
Message-ID: <1111004301.6292.56.camel@laptopd505.fenrus.org>
References: <60807403EABEB443939A5A7AA8A7458BED2483@otce2k01.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Received: from pentafluge.infradead.org ([213.146.154.40]:8920 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S262776AbVCPUSZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Mar 2005 15:18:25 -0500
In-Reply-To: <60807403EABEB443939A5A7AA8A7458BED2483@otce2k01.adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Cc: linux-scsi@vger.kernel.org

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
> The first argument should be 'volatile void __iomem * dst' I would have
> expected. As such, the 64 bit virtual address representing the adapter
> address passed in gets truncated (please correct me if I am wrong).

well ioremap returns a void* so the pointer math should be fine...

Also longs are 64 bit (on x86-64)... so what's the big deal ?

