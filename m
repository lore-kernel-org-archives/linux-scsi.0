From: Jens Axboe <axboe@suse.de>
Subject: Re: [ANNOUNCE] QLogic qla2xxx driver update available (v8.00.00b6).
Date: Thu, 6 Nov 2003 18:14:09 +0100
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <20031106171409.GN437@suse.de>
References: <B179AE41C1147041AA1121F44614F0B0598CE5@AVEXCH02.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <B179AE41C1147041AA1121F44614F0B0598CE5@AVEXCH02.qlogic.org>
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: Mike Anderson <andmike@us.ibm.com>, Linux-Kernel <linux-kernel@vger.kernel.org>, Linux-SCSI <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, Nov 06 2003, Andrew Vasquez wrote:
> Jens,
> 
> > > 	o Given the ISPs inability to handle data segments that cross
> > > 	  32-bit page boundaries, and the overhead in defensive logic
> > > 	  within the driver to prevent these cases (compare the 6.x
> > > 	  code to the 8.x code and you will see what I mean), by
> > > 	  disabling clustering we guarantee that a single SG element
> > > 	  never crosses a 4GB boundary.
> > 
> > That is not, however. Linux will never give you a segment crossing a
> > 4GB boundary, exactly because most hardware cannot handle this.
> > 
> > > Now, in 2.6 there are some significant changes.  For one, with the
> > > block layer rewrite and the ability to limit segment boundaries of a
> > > block queue request with the blk_queue_segment_boundary() call, a LLDD
> > > need not concern itself with any defensive fast-path logic to handle
> > > the 4GB cross.
> > 
> > Ditto 2.4. See BH_PHYS_4G().
> > 
> 
> Yes, but if I recall, these checks did not enter until late in the 2.4
> branch.  The original (engineering) intent of the 6.x series branch
> was to support all 2.4 kernels, though we are slowly (formally) moving
> away from the restrictions.

They were there at the same time as Linux supported > 1GB IO at all. So
that is incorrect, it's been there all along.

> > > So, we're left with the benefits of the overhead of this merge
> > > process done by the block layer.  I'm certainly receptive to the
> > > notion of reexamining the use of clustering given some solid data
> > > points showing an (significant -- this is subjective) increase in
> > > performance and/or a resounding 'yeah, enable it!' from those in
> > > the block-layer 'know.'
> > 
> > In 2.6 clustering comes for free, so it would be silly not to enable
> > it.
> > 
> 
> Thanks for the clarification, I'll add the parameter back into the
> template for the 8.x series driver.

Cool, thanks.

-- 
Jens Axboe
