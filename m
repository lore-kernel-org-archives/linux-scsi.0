From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [PATCH] sd_many done right (1/5)
Date: Fri, 26 Jul 2002 11:50:27 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020726175027.GC2746@clusterfs.com>
References: <20020726154533.GD19721@nbkurt.etpnet.phys.tue.nl> <Pine.GSO.4.21.0207261245070.21586-100000@weyl.math.psu.edu> <20020726165411.GI19721@nbkurt.etpnet.phys.tue.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20020726165411.GI19721@nbkurt.etpnet.phys.tue.nl>
List-Id: linux-scsi@vger.kernel.org
To: Kurt Garloff <garloff@suse.de>, Alexander Viro <viro@math.psu.edu>, Linux SCSI list <linux-scsi@vger.kernel.org>, Linux kernel list <linux-kernel@vger.kernel.org>, Marcelo Tosatti <marcelo@conectiva.com.br>

On Jul 26, 2002  18:54 +0200, Kurt Garloff wrote:
> On Fri, Jul 26, 2002 at 12:45:41PM -0400, Alexander Viro wrote:
> > On Fri, 26 Jul 2002, Kurt Garloff wrote:
> > > The patches are all available at
> > > http://www.suse.de/~garloff/linux/scsi-many/
> > 
> > As long as you realize that it won't go in 2.5 in that form...
> 
> The sd parts can and should be ported to 2.5, I think.
> The /proc/scsi/scsi extensions and other stuff I wrote to support it, 
> won't be needed, as we have driverfs in 2.5.
> And, of course, the device number management will be solved in a more
> general way, but I do not yet see how. 

Actually, one interesting aspect of the EVMS vs. device-mapper argument
going on that has totally been missed is that EVMS can do management of
ALL disk block devices.

At startup time it "consumes" all of the disk block devices in order to
generate the various mappings (LVM, RAID, etc) and at the end it spits
out the resulting devices as EVMS major devices.  This includes devices
that have not been remapped, like hdXY or sdMN.  EVMS has facilities
to ensure that devices get repeatable major/minor numbers if needed,
but they are allocated on an as-needed basis.

Currently EVMS only has a single major number, but it is my understanding
that they could easily take over all of the IDE and SCSI major numbers.
We would not have to worry about sparse device number allocation anymore,
and could have thousands of disks/partitions without any problems.

Cheers, Andreas
--
Andreas Dilger
http://www-mddsp.enel.ucalgary.ca/People/adilger/
http://sourceforge.net/projects/ext2resize/

