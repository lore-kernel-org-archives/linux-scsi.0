From: Andries Brouwer <aebr@win.tue.nl>
Subject: Re: [PATCH] fix sector_div use in scsicam.c
Date: Sun, 27 Oct 2002 23:10:07 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021027221007.GA28417@win.tue.nl>
References: <20021027192228.GA28395@win.tue.nl> <200210272053.g9RKrT612587@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200210272053.g9RKrT612587@localhost.localdomain>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

On Sun, Oct 27, 2002 at 02:53:29PM -0600, James Bottomley wrote:
> aebr@win.tue.nl said:
> > I see you trying to get this scsicam code do something that it should
> > not. No 64-bit handling required or even desirable. Any use of
> > sector_div here is wrong. 
> 
> Could you explain why?

On ancient machines, user space needs the number of sectors per track
and the number of heads in order to (i) write something appropriate
in the partition table, and (ii) help the boot loader interface with
the BIOS at boot time.

However, the number of cylinders does not play a role.
On new systems the geometry is entirely irrelevant.
On old systems the number of cylinders is not needed anywhere.
It is not written in the partition table. It is not used in BIOS interaction.

Some ancient software used C*H*S as a measure for the total disk size,
but that is broken, especially since geometry depends on the BIOS setup.
These days it is especially broken since HDIO_GETGEO returns a 16-bit
value for the number of cylinders.

The code I suggested returns something reasonable to be backwards
compatible with ancient software. Without the desire for compatibility
the assignment
	ip[2] = 0;
would be acceptable too.

The patches I reacted to were worse in two respects:
It invoked the sector_div macro designed to divide large numbers,
while here division of large numbers is meaningless.
Just superfluous code.
It suggests that the computation is meaningful, and before you know it
people will add ioctls to get the bits computed by this division
out to user space.

The current spec for HDIO_GETGEO is that the cylinder field of
what it returns has to be ignored. The total disk size is found
using BLKGETSIZE. If user space wants to compute a number of
cylinders, for whatever reason, it has to divide the total size
by H*S as returned by HDIO_GETGEO. That is what all recent software
does.

I am in the process of removing, extremely slowly, everything related
to disk geometries from the kernel. Disk geometries have not existed
the past ten years, and thousands of users have had to fight fake
geometries invented by disk, BIOS, kernel and software.
We must not add to this cruft, but only take away. Slowly.

Andries

