From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: scsi disk registration - double messages
Date: Tue, 15 Feb 2005 08:48:58 -0800
Message-ID: <20050215164858.GA22096@us.ibm.com>
References: <Pine.SOC.4.61.0502151200470.2239@math.ut.ee> <20050215143335.GO29917@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from e1.ny.us.ibm.com ([32.97.182.141]:18059 "EHLO e1.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S261784AbVBOQtH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Feb 2005 11:49:07 -0500
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e1.ny.us.ibm.com (8.12.11/8.12.11) with ESMTP id j1FGn7JI001934
	for <linux-scsi@vger.kernel.org>; Tue, 15 Feb 2005 11:49:07 -0500
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay02.pok.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id j1FGn7Bk262636
	for <linux-scsi@vger.kernel.org>; Tue, 15 Feb 2005 11:49:07 -0500
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11/8.12.11) with ESMTP id j1FGn6rv007343
	for <linux-scsi@vger.kernel.org>; Tue, 15 Feb 2005 11:49:07 -0500
Content-Disposition: inline
In-Reply-To: <20050215143335.GO29917@parcelfarce.linux.theplanet.co.uk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>, viro@parcelfarce.linux.theplanet.co.uk
Cc: Meelis Roos <mroos@linux.ee>, linux-scsi@vger.kernel.org

On Tue, Feb 15, 2005 at 02:33:35PM +0000, Matthew Wilcox wrote:
> On Tue, Feb 15, 2005 at 12:01:11PM +0200, Meelis Roos wrote:
> > The messages about registration of sda appear tiwice for some reason. This 
> > is only cosmetic but still a little strange:
> 
> Yes, that happens for everyone.

I posted before but no replies:

Al's log for the patch says "Work around devices with bogus media change
indication on the first open".

What bogus device? Why not put the change in the driver or black list
the device, rather than doing so for all block devices?

This worked fine for me, but I might break with the bogus media:

diff -uprN -X /home/patman/dontdiff linux-2.6.11-rc1/fs/partitions/check.c no-double-sd-linux-2.6.11-rc1/fs/partitions/check.c
--- linux-2.6.11-rc1/fs/partitions/check.c	Fri Dec 24 13:35:28 2004
+++ no-double-sd-linux-2.6.11-rc1/fs/partitions/check.c	Fri Jan 21 11:19:00 2005
@@ -375,8 +375,6 @@ int rescan_partitions(struct gendisk *di
 	bdev->bd_invalidated = 0;
 	for (p = 1; p < disk->minors; p++)
 		delete_partition(disk, p);
-	if (disk->fops->revalidate_disk)
-		disk->fops->revalidate_disk(disk);
 	if (!get_capacity(disk) || !(state = check_partition(disk, bdev)))
 		return 0;
 	for (p = 1; p < state->limit; p++) {

-- Patrick Mansfield
