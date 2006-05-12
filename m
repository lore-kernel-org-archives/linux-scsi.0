From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: Re: [PATCH] make kernel ignore bogus partitions
Date: Fri, 12 May 2006 12:32:47 +0200 (MEST)
Message-ID: <Pine.LNX.4.61.0605121223560.9918@yvahk01.tjqt.qr>
References: <20060503210055.GB31048@beardog.cca.cpqcorp.net>
 <20060509124138.43e4bac0.akpm@osdl.org> <20060509224848.GA29754@apps.cwi.nl>
 <20060511040014.66ea16fc.akpm@osdl.org> <20060511115117.GA870@apps.cwi.nl>
 <Pine.LNX.4.64.0605111822320.6713@iabervon.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from linux01.gwdg.de ([134.76.13.21]:37611 "EHLO linux01.gwdg.de")
	by vger.kernel.org with ESMTP id S1751148AbWELKdj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 May 2006 06:33:39 -0400
In-Reply-To: <Pine.LNX.4.64.0605111822320.6713@iabervon.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Daniel Barkalow <barkalow@iabervon.org>
Cc: Andries Brouwer <Andries.Brouwer@cwi.nl>, Andrew Morton <akpm@osdl.org>, mikem@beardog.cca.cpqcorp.net, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

>
>Perhaps the kernel should try reading beyond the ends of disks when it 
>detects them, so that it can determine if there's actually available 
>storage there, and automatically increase the size if there is? Or, at 
>least, it could check whether the medium actually goes out to the point 
>the partition table implies, and suppress the I/O error if the disk 
>actually ends where it claims to.
>
Sounds like a good idea. In fact, I had miscreated a sun disklabel on a 
disk because it has a slightly different notion of cylinders that I am used 
to from x86; IOW:

dmesg:
SCSI device sdb: 35378533 512-byte hdwr sectors (18114 MB)

fdisk:
Disk /dev/sdb (Sun disk label): 19 heads, 248 sectors, 7200 rpm
7508 cylinders, 2 alternate cylinders, 7510 physical cylinders
0 extra sects/cyl, interleave 1:1
(should have been 7506 cyl, 2 alt, 7508 phys)

And Solaris rightfully barfs about it when scanning disks,
because 7510*19*248 > 35378533. Linux keeps silent,
and I am not sure if I have a silent data corruption there (currently not 
as it seems).
(Since it's just a test box ATM, it's not critical.)


Jan Engelhardt
-- 
