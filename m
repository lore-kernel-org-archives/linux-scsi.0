From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Changes to the SCSI sysfs tree
Date: 10 Sep 2004 17:39:57 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1094852403.2553.257.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:4786 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S267920AbUIJVkN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Sep 2004 17:40:13 -0400
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>

The patches effecting the changes listed below are at

bk://linux-scsi.bkbits.net/scsi-target-2.6

Andrew, could you add this to the -mm tree so it gets some wide testing
before I submit it for inclusion in the kernel proper?  Thanks...

What I'm actually doing is:

I'd like to change the layout of the SCSI sysfs tree to add a target
generic device.  This is essential because we need to hang certainl
device class attributes off the target not replicate them throughout the
LUNs of the individual device.

This means that a current SCSI sysfs device like:

lrwxrwxrwx  1 root root 0 Sep 10 09:44 /sys/block/sda/device ->
../../devices/parisc8/parisc8:0/pci0000:00/0000:00:13.0/host0/0:0:5:0/

will instead become:

lrwxrwxrwx  1 root root 0 Sep 10 09:44 /sys/block/sda/device ->
../../devices/parisc8/parisc8:0/pci0000:00/0000:00:13.0/host0/target0:0:5/0:0:5:0/

(note the extra target).

James


