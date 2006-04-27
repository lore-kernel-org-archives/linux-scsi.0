From: "Randy.Dunlap" <rdunlap@xenotime.net>
Subject: Re: aha152x(_cs) oops
Date: Thu, 27 Apr 2006 09:19:37 -0700
Message-ID: <20060427091937.f21c6e81.rdunlap@xenotime.net>
References: <20060413093615.661b7018.rdunlap@xenotime.net>
	<1144950036.3474.36.camel@mulgrave.il.steeleye.com>
	<20060425115709.0db4332f.rdunlap@xenotime.net>
	<Pine.LNX.4.60.0604252143550.3893@poirot.grange>
	<20060425140327.605f22ac.rdunlap@xenotime.net>
	<Pine.LNX.4.60.0604262202200.6890@poirot.grange>
	<20060426132901.ec6d0952.rdunlap@xenotime.net>
	<Pine.LNX.4.60.0604262312580.6890@poirot.grange>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from xenotime.net ([66.160.160.81]:54435 "HELO xenotime.net")
	by vger.kernel.org with SMTP id S965047AbWD0QRT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 27 Apr 2006 12:17:19 -0400
Received: from midway.site ([71.111.157.99]) by xenotime.net for <linux-scsi@vger.kernel.org>; Thu, 27 Apr 2006 09:17:10 -0700
In-Reply-To: <Pine.LNX.4.60.0604262312580.6890@poirot.grange>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org

On Wed, 26 Apr 2006 23:32:06 +0200 (CEST) Guennadi Liakhovetski wrote:

> On Wed, 26 Apr 2006, Randy.Dunlap wrote:
> 
> > I'm using a PCMCIA (not CardBus) Adapter AP-1460 card on a new Dell
> > notebook, with an iomega Jaz drive attached to it.
> 
> Ok, I attached a ZIP drive to my card...
> 
> > I haven't tested without highmem.  I know that the in-kernel driver
> > with a one-line patch works for me.  The patch forces all buffers
> > to lowmem, by setting
> > +       .unchecked_isa_dma              = 1,
> > in the scsi_host_template.
> > 
> > I can test with a non-highmem kernel if you want me to, but I don't
> > see much need to do that.
> 
> What I want to achieve with this test is see, if the stock driver works 
> fine without highmem in the PIO case. As you know, the driver has to 
> calculate the position in the buffer where from/to it has to transfer the 
> data. So, by disabling highmem we would see, if those calculations are 
> right there, that would mean we have a problem with the kmem_atomic 
> conversion, in which case we just have to check carefully our own 
> calculations and compare them with the stock lowmem case. Whereas, if 
> already the stock driver has a problem with lowmem PIO, then we, probably, 
> won't get much further without chip docs.
> 
> > To reproduce the error:  a kernel build will do it.  However, the
> > easiest way (hardest on the driver) is:  mkfs.ext3 /dev/sdX4
> 
> Ok, just tried
> 
> smartctl -a -T permissive /dev/sda
> 
> on my Zip - and got
> 
> (scsi0:6:9) command sent incompletely (6/10)
> 
> which also looks like a case similar to yours? Whereas creating a ext3 fs 
> + running fsck -c -f didn't produce any more output. However, this doesn't 
> mean much.

I built a kernel without highmem support and banged on the jaz drive
quite a bit with it, without errors AFAICT.  I also did not see any
evidence of "resend"s being needed, so it was a bit inconclusive.

---
~Randy
