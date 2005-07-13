From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: map gendisk (or blockdev) -> scsi_device
Date: Wed, 13 Jul 2005 16:46:54 -0700
Message-ID: <20050713234654.GA7222@us.ibm.com>
References: <db1npr$c1d$1@sea.gmane.org> <20050713143843.GC26025@infradead.org> <db3nei$nrs$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.133]:10145 "EHLO
	e35.co.us.ibm.com") by vger.kernel.org with ESMTP id S261812AbVGMXrK
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 Jul 2005 19:47:10 -0400
Received: from westrelay02.boulder.ibm.com (westrelay02.boulder.ibm.com [9.17.195.11])
	by e35.co.us.ibm.com (8.12.10/8.12.9) with ESMTP id j6DNl9eR617844
	for <linux-scsi@vger.kernel.org>; Wed, 13 Jul 2005 19:47:09 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by westrelay02.boulder.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id j6DNl9Sl425754
	for <linux-scsi@vger.kernel.org>; Wed, 13 Jul 2005 17:47:09 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11/8.13.3) with ESMTP id j6DNl8MK028991
	for <linux-scsi@vger.kernel.org>; Wed, 13 Jul 2005 17:47:09 -0600
Content-Disposition: inline
In-Reply-To: <db3nei$nrs$1@sea.gmane.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Edward Falk <efalk@google.com>
Cc: linux-scsi@vger.kernel.org

On Wed, Jul 13, 2005 at 11:44:34AM -0700, Edward Falk wrote:
> 
> >You should revisit your code to not need access to the scsi_device
> >structure, and follow the layering of the block and scsi subsystems.
> 
> Maybe I should explain what I'm trying to do here.
> 
> Some of our software reads some of the values in /proc/ide/hda/.  We're 
> porting this facility to libata-based drivers in 2.6 and moving it to 
> /sysfs/block/sda/.  The sysfs show() functions will be given pointers to 
> gendisk structures but will need to obtain information from the 
> associated scsi_device structure.
> 
> Does anybody have any suggestions as to the "right" way to proceed?

Add or use the attributes under the scsi_device, then use the
/sysfs/block/sd/device symlink to find the corresponding scsi_device.

This is similar to what udev and lsscsi use to find device attributes.

udev uses libsysfs (included with udev).

[elm3b79 patman]$ ls -l /sys/block/sdo/device
lrwxrwxrwx    1 root     root            0 Jul 13 16:44 /sys/block/sdo/device -> ../../devices/pci0000:01/0000:01:0c.0/host2/rport-2:0-8/target2:0:8/2:0:8:0

[elm3b79 patman]$ ls /sys/block/sdo/device/
block   device_blocked  iodone_cnt     model        rescan      state vendor
bus     driver          ioerr_cnt      queue_depth  rev         timeout
delete  iocounterbits   iorequest_cnt  queue_type   scsi_level  type

-- Patrick Mansfield
