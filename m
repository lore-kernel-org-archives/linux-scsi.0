From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 5 of 8] sd: Detect non-rotational devices
Date: Thu, 23 Apr 2009 11:25:31 -0600
Message-ID: <20090423172531.GQ1926@parisc-linux.org>
References: <patchbomb.1240464567@sermon.lab.mkp.net> <d14109aa6209be628074.1240464572@sermon.lab.mkp.net> <20090423105245.GX4593@kernel.dk> <49F04C71.6050304@garzik.org> <20090423113841.GK1926@parisc-linux.org> <yq1r5zjbje2.fsf@sermon.lab.mkp.net> <49F06E3B.104@garzik.org> <1240495814.3514.8.camel@mulgrave.int.hansenpartnership.com> <20090423141644.GP1926@parisc-linux.org> <49F07DAD.7080107@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:52918 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752858AbZDWRZc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 23 Apr 2009 13:25:32 -0400
Content-Disposition: inline
In-Reply-To: <49F07DAD.7080107@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Jens Axboe <jens.axboe@oracle.com>, rwheeler@redhat.com, snitzer@redhat.com, neilb@suse.de, dgilbert@interlog.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org

On Thu, Apr 23, 2009 at 10:39:41AM -0400, Jeff Garzik wrote:
> Matthew Wilcox wrote:
> >On Thu, Apr 23, 2009 at 02:10:13PM +0000, James Bottomley wrote:
> >>I'm with Jeff on this one.  We had an identically similar problem with
> >>REPORT LUNS, which, today is the basis of SCSI discovery.
> >
> >Yes, REPORT LUNS is quite essential.
> >
> >It's not exactly in the same category as reporting device form factor
> >and rotational speed.  If REPORT LUNS is wrong, we're in really deep
> >trouble.  If device form factr is wrong ... umm ... nothing much happens.
> >If rotational speed is wrong, we might have a suboptimal IO pattern.
> 
> If the general attitude is "oh, that info might be wrong", why will app 
> developers bother at all?

Any info might be wrong.  SCSI drives might return the wrong thing in
EVPD b1 too.  We don't check that in the kernel, we just return it to
user space.

> >It's also fixable by udev.
> 
> By that logic we should leave it to udev to handle the ata_version <= 7 
> stuff, since that is the early adopter special case.

I'm perfectly fine with never setting this bit in the kernel and having
udev handle all cases, including checking for garbage.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
