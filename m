From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [Patch 1/2] cciss: fix for 2TB support
Date: Thu, 22 Feb 2007 15:41:24 -0600
Message-ID: <1172180484.3378.34.camel@mulgrave.il.steeleye.com>
References: <20070221211039.GA2672@beardog.cca.cpqcorp.net>
	 <20070221191427.9b7cf4b0.akpm@linux-foundation.org>
	 <20070222165123.GC2672@beardog.cca.cpqcorp.net>
	 <20070222132434.d84d3248.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1751950AbXBVVml@vger.kernel.org>
In-Reply-To: <20070222132434.d84d3248.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Mike Miller (OS Dev)" <mikem@beardog.cca.cpqcorp.net>, mike.miller@hp.com, jens.axboe@oracle.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, gregkh@novell.com
List-Id: linux-scsi@vger.kernel.org

On Thu, 2007-02-22 at 13:24 -0800, Andrew Morton wrote:
> > On Thu, 22 Feb 2007 10:51:23 -0600 "Mike Miller (OS Dev)" <mikem@beardog.cca.cpqcorp.net> wrote:
> > On Wed, Feb 21, 2007 at 07:14:27PM -0800, Andrew Morton wrote:
> > > On Wed, 21 Feb 2007 15:10:39 -0600 "Mike Miller (OS Dev)" <mikem@beardog.cca.cpqcorp.net> wrote:
> > > 
> > > > Patch 1/2
> > > > +  	if (total_size == 0xFFFFFFFF) {
> > > 
> > > I seem to remember having already questioned this.  total_size is sector_t, which
> > > can be either 32-bit or 64-bit.  Are you sure that comparison works as
> > > intended in both cases?
> > > 
> > > 
> > > > +		if(total_size == 0xFFFFFFFF) {
> > > >  			cciss_read_capacity_16(cntl_num, i, 0,
> > > >  			&total_size, &block_size);
> > > >  			hba[cntl_num]->cciss_read = CCISS_READ_16;
> > > 
> > > Here too.
> > It has worked in all of the configs I've tested. Should I change it from sector_t to a
> > __64? I have not tested all possible configs.
> > 
> 
> I'd suggest using -1: that just works.

Actually, no, that won't work.

This is a SCSI heuristic for determining when to use the 16 byte version
of the read capacity command.  The 10 byte command can only return 32
bits of information (this is in sectors, so it returns up to 2TB of
bytes).

The heuristic requirement is that if the size is exactly 0xffffffff then
you should try the 16 byte command (which can return 64 bits of
information).  If that fails then you assume the 0xfffffff is a real
size otherwize, you assume it was truncated and take the real result
from the 16 byte command.

You can see a far more elaborate version of this in operation in
sd.c:sd_read_capacity().

The only thing I'd suggest is to use 0xFFFFFFFFULL as the constant to
prevent sign extension issues.

James
