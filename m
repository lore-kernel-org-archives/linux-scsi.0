From: Jeremy Higdon <jeremy@sgi.com>
Subject: Re: [RFC PATCH 2.6.9-rc2] Add sysfs queue depth override to qla2xxx
Date: Wed, 29 Sep 2004 15:12:08 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040929221208.GA199641@sgi.com>
References: <B179AE41C1147041AA1121F44614F0B0012AD92B@AVEXCH02.qlogic.org> <20040928193614.GB192475@sgi.com> <1096401196.2008.97.camel@mulgrave> <20040929003611.GK192475@sgi.com> <1096476093.10859.73.camel@praka>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from omx2-ext.sgi.com ([192.48.171.19]:20710 "EHLO omx2.sgi.com")
	by vger.kernel.org with ESMTP id S269079AbUI2WMV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Sep 2004 18:12:21 -0400
Content-Disposition: inline
In-Reply-To: <1096476093.10859.73.camel@praka>
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Wed, Sep 29, 2004 at 09:41:33AM -0700, Andrew Vasquez wrote:
> On Tue, 2004-09-28 at 17:36, Jeremy Higdon wrote:
> > So do we have a consensus on what the driver should limit queue
> > depth to?  Currently, it's 32 or ql2xmaxqdepth, if that was specified.
> > From what I can see, ql2xmaxqdepth is effectively limited to 65535.
> > 
> > We don't want one lun to use host driver or host adapter resources
> > to the point that it starves other luns.  Ideally, the max would
> > depend on what else was attached, but I don't think we want to
> > make this too complicated.
> 
> I agree.
> 
> >   Anyone changing the queue depth should
> > have a clue about what they're doing.
> > 
> > Andrew, how many command slots are there in the various adapters,
> > and do the continuation entries each eat a command slot?
> > 
> 
> Well, determining that can be complicated...
> 
> The request-queue size is based on the amount of SRAM available to the
> ISP.   For most HBAs (qla2100, qla2200, qla2300, qla2310, qla2342) which
> have an 128KB memory chip (per-port), the 8.x driver will allocate
> 2048-entry queue for requests.  
> 
> Many new(-er) boards (qla235x, qla236x) and embedded implementations
> (fibre-down) have a 512KB or 1MB chip.  Not wanting to digress into
> another layer of firmware resource-usage details, let's just say that
> the extra memory allows for the firmware to manage a larger number of
> requests.  The driver in these cases will allocate a 4096-entry
> request-queue.

I thought that there was not a one to one mapping between the request
queue size and the number of commands the chip/board could hold.

Anyway, this is probably far enough down that rathole.

> I'm not sure if it brings us any closer to answering the question of
> 'what's the max queue-depth we support?'  Is it even possible, since as
> you mentioned earlier, the admin will have to possess some outside
> knowledge (backend-storage, I/O type, I/O patterns) while tuning the
> queue-depth value.

Since there's no obvious answer, let's not try to out think the admin.
Andrew, I think you can just choose a maximum.  I would suggest that
the maximum be the same as the maximum for ql2xmaxqdepth, just to be
consistent.  Is that indeed 65535?

jeremy
