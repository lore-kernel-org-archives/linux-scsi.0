From: Matt Domsch <Matt_Domsch@Dell.com>
Subject: Re: [2.5 patch] MegaRAID driver: remove kernel 2.0 and 2.2 code
Date: Tue, 21 Jan 2003 22:04:23 -0600 (CST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0301212153400.3575-100000@humbolt.us.dell.com>
References: <20030121141351.GB6870@fs.tum.de>
Reply-To: Matt Domsch <Matt_Domsch@Dell.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20030121141351.GB6870@fs.tum.de>
List-Id: linux-scsi@vger.kernel.org
To: Adrian Bunk <bunk@fs.tum.de>
Cc: Alan <alan@lxorguk.ukuu.org.uk>, groudier@free.fr, linux-scsi@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>

> > AMI still issue 2.2 versions of this driver so its probably excessive
> > (AMI ? -- LSI now I guess)
> 
> In megaraid.c IO_LOCK_IRQ and IO_UNLOCK_IRQ are only defined for >= 2.4
> (they are present since 2.5.1-pre2) and the since Al Viro's
> kdev_t -> block_device * conversion you get a compile error when trying 
> to use megaraid.{c,h} in 2.2.23.
> 
> If it's intended that this file is still used in kernels < 2.4 some
> changes are needed.

There are several branches of the megaraid driver available.  
(Un)fortunately, it's not one common source file anymore.

For 2.4.x, the driver in BK now (1.18g) is fine.  This has the
backward-compatability stuff for 2.2.x that isn't quite right, but patches 
on linux-megaraid-devel exist to make it sufficient.  See January 2 
archives at http://lists.us.dell.com.

For 2.5.x, the driver in BK now (1.18 + 2.5-specific fixes)  should be
superceeded by v2.00.2 at some point.  This replaces the existing driver, 
and doesn't have backward compatability cruft.  -ac and the OSDL patch set 
have this now (-ac has 2.00.1, minor update for really old iomapped 
controllers is needed).  Since 2.00.2's release around the holidays I 
haven't heard of any problems with the driver - eventually someone needs 
to pull the trigger and submit the switch.

There's also a v2.00.2 specifically for kernel 2.4.x available that drops 
in alongside the existing megaraid, new one is 'megaraid2', to maintain 
stability.

Patches:  http://domsch.com/linux/megaraid
BK: http://mdomsch.bkbits.net

Thanks,
Matt

-- 
Matt Domsch
Sr. Software Engineer, Lead Engineer, Architect
Dell Linux Solutions www.dell.com/linux
Linux on Dell mailing lists @ http://lists.us.dell.com


