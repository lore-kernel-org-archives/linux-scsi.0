From: Paul Mackerras <paulus@ozlabs.org>
Subject: Regression in v4.6-rc due to SCSI multipath change
Date: Wed, 4 May 2016 16:51:02 +1000
Message-ID: <20160504065101.GA19436@oak.ozlabs.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Current upstream kernels fail to boot on my POWER8 server with
multipath SCSI disks and IPR host bus adapters.  What happens is that
the system finds each disk twice (as normal) and then prints messages
like this:

[    2.827761] sd 1:2:4:0: alua: supports implicit TPGS
[    2.827875] sd 1:2:4:0: alua: No device descriptors found
[    2.827923] sd 1:2:4:0: alua: Attach failed (-22)
[    2.827979] device-mapper: table: 253:0: multipath: error attaching hardware handler
[    2.828048] device-mapper: ioctl: error adding target to table

Eventually dracut times out (this is with Fedora 23) enters emergency
mode.

I bisected the problem down to commit 0047220c6c36 ("scsi_dh_alua: use
unique device id", 2016-02-19).  It seems that this commit adds the
restriction that we can only do multipath with disks that have stuff
in their VPD page 83 that scsi_vpd_lun_id() can parse.  The disks on
my server apparently don't.

I instrumented scsi_vpd_lun_id() to find out what was going on.  The
disks on this machine have a vendor-specific designator and a T10
vendor ID based designator, but no designators of types 2, 3 or 8.
An example from one disk is:

02 01 00 20 49 42 4d 20 20 20 20 20 49 50 52 2d 30 20 20 20 35 45 43
34 41 42 30 30 30 30 30 30 30 30 32 30

02 00 00 14 30 20 20 20 20 20 20 20 20 20 20 20 20 20 20 20 20 20 20 20

I have a patch that extends scsi_vpd_lun_id() to be able to use the
T10 vendor ID based designator, which fixes the problem on my system.
I'll post the patch shortly.

However, was it really intentional that multipath now can't be used
with disks like these, when it worked just fine previously?

Paul.
