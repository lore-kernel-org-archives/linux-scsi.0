From: "Randy.Dunlap" <rdunlap@xenotime.net>
Subject: Re: aha152x(_cs) oops
Date: Tue, 25 Apr 2006 11:57:09 -0700
Message-ID: <20060425115709.0db4332f.rdunlap@xenotime.net>
References: <20060413093615.661b7018.rdunlap@xenotime.net>
	<1144950036.3474.36.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from xenotime.net ([66.160.160.81]:6817 "HELO xenotime.net")
	by vger.kernel.org with SMTP id S1751514AbWDYSyo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Apr 2006 14:54:44 -0400
Received: from midway.site ([71.111.157.99]) by xenotime.net for <linux-scsi@vger.kernel.org>; Tue, 25 Apr 2006 11:54:42 -0700
In-Reply-To: <1144950036.3474.36.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org, g.liakhovetski@gmx.de

On Thu, 13 Apr 2006 12:40:36 -0500 James Bottomley wrote:

> On Thu, 2006-04-13 at 09:36 -0700, Randy.Dunlap wrote:
> > Is aha152x(_cs) known not to work with highmem or is it just busted
> > in its use of s/g list handling?
> > This is 2.6.17-rc1-git7 on a Dell notebook with 2 GB RAM.
> > 
> > On all recent kernels, I get an Oops in aha152x.c:datao_run(),
> > where the SG_ADDRESS() macro uses page_address().
> 
> This routine is trying to do the identical action that Guennady
> Liakhovetski just posted a dc395x patch for (i.e. re-feed a DMA
> transaction via PIO) could we see if we can utilise pieces of that patch
> to do this correctly (or provide more common infrastructure)?

I've spent a lot of time using the sg-PIO patch with the aha152x
driver.  The sg-PIO part of it works for me, but the aha152x driver
sometimes does not complete a full DMA-out transfer (data-out phase).
The driver calls this the need to "resend" some data (in datao_end()).
I can't get this resend logic to work correctly with the sg-PIO
changes and I can't keep spending time on it without some docs and/or
errata, so I'll just continue to use my lowmem patch for the
aha152x driver.

---
~Randy
