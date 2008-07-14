From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] advansys: use request_firmware
Date: Mon, 14 Jul 2008 09:15:44 -0600
Message-ID: <20080714151543.GE14894@parisc-linux.org>
References: <1215770322.2733.12.camel@jaswinder.satnam> <20080712162921.GZ14894@parisc-linux.org> <1215882548.19076.57.camel@jaswinder.satnam> <20080714145033.GD14894@parisc-linux.org> <1216047404.27455.31.camel@shinybook.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:44681 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751808AbYGNPQA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Jul 2008 11:16:00 -0400
Content-Disposition: inline
In-Reply-To: <1216047404.27455.31.camel@shinybook.infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David Woodhouse <dwmw2@infradead.org>
Cc: Jaswinder Singh <jaswinder@infradead.org>, LKML <linux-kernel@vger.kernel.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>, kernel-janitors <kernel-janitors@vger.kernel.org>, kernelnewbies <kernelnewbies@nl.linux.org>, linux-scsi@vger.kernel.org, hch@infradead.org

On Mon, Jul 14, 2008 at 07:56:44AM -0700, David Woodhouse wrote:
> On Mon, 2008-07-14 at 08:50 -0600, Matthew Wilcox wrote:
> > I'm not quite sure whether my question was answered ...
> > 
> > When firmware is built in, does
> > 1) request_firmware() make a copy of it and then release_firmware free
> >    that copy?
> > 2) request_firmware() return a pointer to the built-in firmware with
> >    release_firmware() being a no-op?
> > 3) request_firmware() return a pointer to the built-in firmware with
> >    release_firmware() freeing the original?
> > 
> > Cases 1 and 2 are fine, case 3 is a problem.
> 
> Effectively (2).
> 
> Actually we do allocate and free the 'struct firmware' but fw->data is
> just pointed to the original blob, and then that blob doesn't get freed.

Thanks.  Revised patch

Acked-by: Matthew Wilcox <willy@linux.intel.com>

although I would like to see the firmware go under a BSD licence still.

Something I'd like to get rid of in the driver is the decompression
of the firmware files.  I don't think AdvLoadMicrocode() should have
a custom decompresser built into it.  Do your future plans include the
ability to gzip the data and transparently decompress it when the driver
calls request_firmware()?

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
