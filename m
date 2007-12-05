From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: broken dpt_i2o in 2.6.23 (was: ext2_check_page: bad entry in
 directory)
Date: Wed, 05 Dec 2007 10:04:03 +0900
Message-ID: <20071205100403Y.fujita.tomonori@lab.ntt.co.jp>
References: <20071128172132.GA30202@schlund.de>
	<20071129123150.GA24851@schlund.de>
	<20071204165738.48003b8a.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama555.ecl.ntt.co.jp ([129.60.39.106]:43971 "EHLO
	tama555.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750969AbXLEBFO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Dec 2007 20:05:14 -0500
In-Reply-To: <20071204165738.48003b8a.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@linux-foundation.org
Cc: anders.henke@1und1.de, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, jens.axboe@oracle.com, fujita.tomonori@lab.ntt.co.jp

On Tue, 4 Dec 2007 16:57:38 -0800
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Thu, 29 Nov 2007 13:31:50 +0100
> Anders Henke <anders.henke@1und1.de> wrote:
> 
> > On November 28 2007, Anders Henke wrote:
> > > As "everything is reported as being zero" is quite odd an Jan took a
> > > guess that it might be block-layer or driver-related, I've assumed
> > > that the driver is responsible for this; just out of the curiousity, 
> > > I've manually replaced the dpt_i2o driver by the 2.6.19 one by copying 
> > > driver/scsi/dpt_i2o.c driver/scsi/dpti.h and driver/scsi/dpt/ into a 
> > > vanilla 2.6.23.1. kernel; using this kernel fixed the issue for me.
> > > 
> > > I haven't yet fine-tested from which kernel release on the dpt_i2o driver 
> > > behaves like this and spews out zeroed blocks when trying to mount
> > > the rootfs. Maybe this is just some timing issue.
> > 
> > I've started the fine-tests and can say so far that dpt_i2o from 
> > 2.6.22 is still fine. Test is simple:
> > 
> > anders@ista:/usr/src/linux-2.6.22/drivers/scsi/dpt$ cp -r dpt/ dpt_i2o.c dpti.h /usr/src/linux-2.6.23.1/drivers/scsi/
> > 
> > ... recompile the kernel, reboot: works.
> > 
> > 2.6.22 and 2.6.23 differ in terms of the dpt_i2o driver by two different
> > patch sets:
> > -one 2 Kb small set of patches from 2.6.22 to 2.6.22-rc1
> > -one 7 Kb set of patches from 2.6.23-rc2 to 2.6.23-rc3
> > -one 162 Kb set of patches from 2.6.23-rc9 to 2.6.23-rc10.
> > 
> > When applying the 2.6.23-rc1-based driver to "my" 2.6.31.1 kernel,
> > the "zero blocks"-symptom show up, so it's the "lucky" situation
> > that the smallest patch actually seams to be the broken one.
> > 
> > According to the 2.6.23-rc1 short-form changelog, there is
> > one major edit on the dpt_i2o driver:
> > 
> > FUJITA Tomonori 
> > 
> >       [SCSI] dpt_i2o: convert to use the data buffer accessors
> > 
> > Stephen Rothwell 
> >       dpt_i2o depends on virt_to_bus
> > 
> > Fujita, would you please take a look at this?
> 
> He won't have seen this.  cc's added.
> 
> > I think that something's broken in there, leading to the dpt_i2o 
> > sending out blocks of zeroes right after initialization, at least on
> > some specific controllers (in this case, Adaptec 2010S on Intel
> > SE7501WV2S-based boxes).
> > 
> > I don't have insight kernel driver development knowledge, so I'm
> > quite out of help right now. Nevertheless, I'll add the diff
> > from 2.6.22 to 2.6.23-rc1 in terms of dpt_i2o:
> > 
> 
> Can you please confirm that this revert (against 2.6.24-rc4) fixes the data
> corruption problems?

Anders said that my patch is fine and seems that Matthew's hotplug
conversion patch leads to the problem:

http://marc.info/?l=linux-kernel&m=119641892129732&w=2
