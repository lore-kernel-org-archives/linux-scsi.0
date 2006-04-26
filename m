From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: aha152x(_cs) oops
Date: Wed, 26 Apr 2006 23:32:06 +0200 (CEST)
Message-ID: <Pine.LNX.4.60.0604262312580.6890@poirot.grange>
References: <20060413093615.661b7018.rdunlap@xenotime.net>
 <1144950036.3474.36.camel@mulgrave.il.steeleye.com>
 <20060425115709.0db4332f.rdunlap@xenotime.net> <Pine.LNX.4.60.0604252143550.3893@poirot.grange>
 <20060425140327.605f22ac.rdunlap@xenotime.net> <Pine.LNX.4.60.0604262202200.6890@poirot.grange>
 <20060426132901.ec6d0952.rdunlap@xenotime.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.gmx.de ([213.165.64.20]:43465 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S964887AbWDZVe6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 26 Apr 2006 17:34:58 -0400
In-Reply-To: <20060426132901.ec6d0952.rdunlap@xenotime.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Randy.Dunlap" <rdunlap@xenotime.net>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org

On Wed, 26 Apr 2006, Randy.Dunlap wrote:

> I'm using a PCMCIA (not CardBus) Adapter AP-1460 card on a new Dell
> notebook, with an iomega Jaz drive attached to it.

Ok, I attached a ZIP drive to my card...

> I haven't tested without highmem.  I know that the in-kernel driver
> with a one-line patch works for me.  The patch forces all buffers
> to lowmem, by setting
> +       .unchecked_isa_dma              = 1,
> in the scsi_host_template.
> 
> I can test with a non-highmem kernel if you want me to, but I don't
> see much need to do that.

What I want to achieve with this test is see, if the stock driver works 
fine without highmem in the PIO case. As you know, the driver has to 
calculate the position in the buffer where from/to it has to transfer the 
data. So, by disabling highmem we would see, if those calculations are 
right there, that would mean we have a problem with the kmem_atomic 
conversion, in which case we just have to check carefully our own 
calculations and compare them with the stock lowmem case. Whereas, if 
already the stock driver has a problem with lowmem PIO, then we, probably, 
won't get much further without chip docs.

> To reproduce the error:  a kernel build will do it.  However, the
> easiest way (hardest on the driver) is:  mkfs.ext3 /dev/sdX4

Ok, just tried

smartctl -a -T permissive /dev/sda

on my Zip - and got

(scsi0:6:9) command sent incompletely (6/10)

which also looks like a case similar to yours? Whereas creating a ext3 fs 
+ running fsck -c -f didn't produce any more output. However, this doesn't 
mean much.

Thanks
Guennadi
---
Guennadi Liakhovetski
