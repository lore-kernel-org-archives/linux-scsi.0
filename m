From: Erik Mouw <erik@harddisk-recovery.com>
Subject: Re: [BUG 2.6.17-git] kmem_cache_create: duplicate cache scsi_cmd_cache
Date: Fri, 12 May 2006 22:18:36 +0200
Message-ID: <20060512201835.GB29077@harddisk-recovery.com>
References: <20060511151456.GD3755@harddisk-recovery.com> <15ddcffd0605112153q57f139a1k7068e204a3eeaf1f@mail.gmail.com> <20060512171632.GA29077@harddisk-recovery.com> <20060512172729.GA2321@andrew-vasquezs-powerbook-g4-15.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dtp.xs4all.nl ([80.126.206.180]:63882 "HELO abra2.bitwizard.nl")
	by vger.kernel.org with SMTP id S932206AbWELUSh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 May 2006 16:18:37 -0400
Content-Disposition: inline
In-Reply-To: <20060512172729.GA2321@andrew-vasquezs-powerbook-g4-15.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: Or Gerlitz <or.gerlitz@gmail.com>, linux-scsi@vger.kernel.org, rmk@arm.linux.org.uk, axboe@suse.de, linux-kernel@vger.kernel.org, torvalds@osdl.org

On Fri, May 12, 2006 at 10:27:29AM -0700, Andrew Vasquez wrote:
> On Fri, 12 May 2006, Erik Mouw wrote:
> > I tracked it down with git bisect. The culprit is this commit:
> > 
> > 56cf6504fc1c0c221b82cebc16a444b684140fb7 is first bad commit
> > diff-tree 56cf6504fc1c0c221b82cebc16a444b684140fb7 (from
> > d98550e334715b2d9e45f8f0f4e1608720108640)
> > Author: Russell King <rmk@dyn-67.arm.linux.org.uk>
> > Date:   Fri May 5 17:57:52 2006 +0100
> > 
> >     [BLOCK] Fix oops on removal of SD/MMC card
> > 
> >     The block layer keeps a reference (driverfs_dev) to the struct
> >     device associated with the block device, and uses it internally
> >     for generating uevents in block_uevent.
> > 
> >     Block device uevents include umounting the partition, which can
> >     occur after the backing device has been removed.
> ...
> 
> THat's really weird... I reported a completely unrelated problem some
> days ago:
> 
> 	http://marc.theaimsgroup.com/?l=linux-kernel&m=114728598328769&w=2

AFAICS it's the same bug. Apparently you can trigger it with any scsi
host driver.


Erik

-- 
+-- Erik Mouw -- www.harddisk-recovery.com -- +31 70 370 12 90 --
| Lab address: Delftechpark 26, 2628 XH, Delft, The Netherlands
