From: David Miller <davem@davemloft.net>
Subject: Re: [patch 4/6] ps3: Disk Storage Driver
Date: Fri, 15 Jun 2007 16:08:58 -0700 (PDT)
Message-ID: <20070615.160858.26276547.davem@davemloft.net>
References: <20070615171545.316dfac7@the-village.bc.nu>
	<20070615.141917.85409547.davem@davemloft.net>
	<1181947242.3600.8.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56842
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755635AbXFOXIl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Jun 2007 19:08:41 -0400
In-Reply-To: <1181947242.3600.8.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: alan@lxorguk.ukuu.org.uk, Geert.Uytterhoeven@sonycom.com, dwmw2@infradead.org, axboe@kernel.dk, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org, paulus@samba.org

From: James Bottomley <James.Bottomley@SteelEye.com>
Date: Fri, 15 Jun 2007 15:40:42 -0700

> On Fri, 2007-06-15 at 14:19 -0700, David Miller wrote:
> > Another quirk I have to deal with is that under LDOMs you
> > can export full disks and also just slices.  So I'll have
> > to get down into the partition machinery to support that
> > somehow.
> 
> For this, it sounds like you might find nbd a more enticing
> proposition ... it already is partition independent and is basically a
> block to net socket exporter.

That's not gonna work, it's a totally different model.

I have a predefined protocol over hypervisor provided "channels" and
page flipping also done by the hypervisor for the bulk data transfer.
For the client side I cannot change the hypervisor nor the server
speaking on the other end.  And when I do write a server I do want
it to be able to speak to all of the existing clients.

There's SCSI command pass through as well, as I keep mentioning as
it's an important reason I don't want to go with any of the non-SCSI
solutions (other than perhaps ATA) being suggested.
