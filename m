From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: Is this a known problem with the SCSI mid layer?
Date: Fri, 15 Jan 2010 09:10:30 +0100
Message-ID: <20100115081030.GZ13771@kernel.dk>
References: <20100114165602.GY13413@beardog.cce.hp.com> <4B4F617B.5050609@interlog.com> <20100114200715.GB13413@beardog.cce.hp.com> <4B4FAC25.1050504@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:57929 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751879Ab0AOIKc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Jan 2010 03:10:32 -0500
Content-Disposition: inline
In-Reply-To: <4B4FAC25.1050504@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: scameron@beardog.cce.hp.com, Douglas Gilbert <dgilbert@interlog.com>, linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, mikem@beardog.cce.hp.com, dab@hp.com, hch@infradead.org, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

On Fri, Jan 15 2010, Stefan Richter wrote:
> scameron@beardog.cce.hp.com wrote:
> > On Thu, Jan 14, 2010 at 01:24:59PM -0500, Douglas Gilbert wrote:
> >> scameron@beardog.cce.hp.com wrote:
> >>> I'm seeing a problem which I think is a problem in the SCSI mid layer.
> [...]
> >>> Remove the device while something has it open:
> [...]
> >>> [root@slicer ~]# rmmod hpsa
> >>> ERROR: Module hpsa is in use
> 
> The sg driver's open method takes a reference to the underlying SCSI
> device representation of the mid layer.  Among else, this step increases
> the module use count of the respective low-level driver (transport layer
> driver) so that the SCSI mid layer can be sure that function pointers to
> driver methods stay valid during the lifetime of the SCSI device
> representation.
> 
> This reference taking is of course being reversed when the sg driver
> finishes its last uses of the underlying SCSI device.  This may be at
> the respective close() or even later.
> 
> In short, it is normal, expected, and necessary what you are seeing.

Hmm... Unless I'm reading Stephens email incorrectly, he's holding the
device open, removing it, closing the device, and then attempting to
remove the host driver. So at the point that he wants to rmmod the
module, there is indeed no references to it anymore.

It looks like a bug.

-- 
Jens Axboe

