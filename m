From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 5 of 8] sd: Detect non-rotational devices
Date: Thu, 23 Apr 2009 17:37:03 +0000
Message-ID: <1240508223.3514.18.camel@mulgrave.int.hansenpartnership.com>
References: <patchbomb.1240464567@sermon.lab.mkp.net>
	 <d14109aa6209be628074.1240464572@sermon.lab.mkp.net>
	 <20090423105245.GX4593@kernel.dk> <49F04C71.6050304@garzik.org>
	 <20090423113841.GK1926@parisc-linux.org>
	 <yq1r5zjbje2.fsf@sermon.lab.mkp.net> <49F06E3B.104@garzik.org>
	 <1240495814.3514.8.camel@mulgrave.int.hansenpartnership.com>
	 <20090423141644.GP1926@parisc-linux.org> <49F07DAD.7080107@garzik.org>
	 <20090423172531.GQ1926@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20090423172531.GQ1926@parisc-linux.org>
Sender: linux-ide-owner@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Jeff Garzik <jeff@garzik.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Jens Axboe <jens.axboe@oracle.com>, rwheeler@redhat.com, snitzer@redhat.com, neilb@suse.de, dgilbert@interlog.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, 2009-04-23 at 11:25 -0600, Matthew Wilcox wrote:
> On Thu, Apr 23, 2009 at 10:39:41AM -0400, Jeff Garzik wrote:
> > Matthew Wilcox wrote:
> > >On Thu, Apr 23, 2009 at 02:10:13PM +0000, James Bottomley wrote:
> > >>I'm with Jeff on this one.  We had an identically similar problem with
> > >>REPORT LUNS, which, today is the basis of SCSI discovery.
> > >
> > >Yes, REPORT LUNS is quite essential.
> > >
> > >It's not exactly in the same category as reporting device form factor
> > >and rotational speed.  If REPORT LUNS is wrong, we're in really deep
> > >trouble.  If device form factr is wrong ... umm ... nothing much happens.
> > >If rotational speed is wrong, we might have a suboptimal IO pattern.
> > 
> > If the general attitude is "oh, that info might be wrong", why will app 
> > developers bother at all?
> 
> Any info might be wrong.  SCSI drives might return the wrong thing in
> EVPD b1 too.  We don't check that in the kernel, we just return it to
> user space.

Right, that's the REPORT LUNs case:  If you report compliance to a
standard that doesn't have it, we don't use it *unless* you have an
inquiry data whitelist to say we should.

If you report compliance to a standard that does, then we lead with
REPORT LUNs *unless* you're in a blacklist of people who don't implement
correctly.

The point is that we use the gross standard compliance data to flip how
we treat the device.

So we're chasing the case where what we're doing is most likely to work
and then we fix up the corner problems in each of the cases.

James


