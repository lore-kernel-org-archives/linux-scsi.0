From: Russell King <rmk@arm.linux.org.uk>
Subject: Re: 2.6.0-test9: scsi_dev_flags
Date: Sat, 1 Nov 2003 13:13:09 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031101131309.A31429@flint.arm.linux.org.uk>
References: <20031026144741.A4326@flint.arm.linux.org.uk> <20031026083850.A15515@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from caramon.arm.linux.org.uk ([212.18.232.186]:32016 "EHLO
	caramon.arm.linux.org.uk") by vger.kernel.org with ESMTP
	id S263845AbTKANNM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 1 Nov 2003 08:13:12 -0500
Content-Disposition: inline
In-Reply-To: <20031026083850.A15515@beaverton.ibm.com>; from patmans@us.ibm.com on Sun, Oct 26, 2003 at 08:38:50AM -0800
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: linux-scsi@vger.kernel.org

On Sun, Oct 26, 2003 at 08:38:50AM -0800, Patrick Mansfield wrote:
> On Sun, Oct 26, 2003 at 02:47:41PM +0000, Russell King wrote:
> 
> > So, I then tried doing exactly that:
> > 
> > 	scsi_dev_flags=SyQuest:SQ3270S:4096
> 
> If that is the kernel boot line, you need to prefix the argument with
> scsi_mod., i.e. scsi_mod.scsi_dev_flags=, per the module_param
> interface(s).
> 
> > An additional question comes out from this - if quirk information is now
> > to be passed on the kernel command line, how are users supposed to work
> > out the correct command line argument to give for their quirky hardware
> > given that it doesn't appear to be as trivial as the code suggests?
> > (IOW, the scsi_dev_flags option appears to be rather undocumented!)
> 
> There is a bit in Documentation/kernel-parameters.txt, but there should be
> more documentation added somewhere. Also the integer value can be hex
> (0x1000).

Ok, I've tried scsi_mod.scsi_dev_flags= and the kernel whinges:

Unknown boot option `scsi_mod.scsi_dev_flags=SyQuest:SQ3270S:4096': ignoring

and it still wants to spin up the drive (I ended up allowing it during
the first spinup attempt):

sda: Spinning up disk...................ready
SCSI device sda: 524288 512-byte hdwr sectors (268 MB)
sda: Write Protect is off
sda: Mode Sense: 99 00 00 08
SCSI device sda: drive cache: write back
 sda: sda1 sda2
Attached scsi removable disk sda at scsi0, channel 0, id 2, lun 0
Attached scsi generic sg0 at scsi0, channel 0, id 1, lun 0,  type 1
Attached scsi generic sg1 at scsi0, channel 0, id 2, lun 0,  type 0

Note that unlike my recent mail to linux-scsi, this time it didn't try
to add the same partitions multiple times.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:  2.6 PCMCIA      - http://pcmcia.arm.linux.org.uk/
                 2.6 Serial core
