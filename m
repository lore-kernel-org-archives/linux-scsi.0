From: Mike Anderson <andmike@us.ibm.com>
Subject: [RFC][PATCH] 2.5 hosts.c and scsi_host list cleanup
Date: Wed, 4 Sep 2002 13:43:10 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020904204310.GA3588@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from westrelay05.boulder.ibm.com (westrelay05.boulder.ibm.com [9.17.193.33])
	by e21.nc.us.ibm.com (8.12.2/8.12.2) with ESMTP id g84KgBDf082280
	for <linux-scsi@vger.kernel.org>; Wed, 4 Sep 2002 16:42:12 -0400
Received: from dyn9-47-17-195 (dyn9-47-17-67.beaverton.ibm.com [9.47.17.67])
	by westrelay05.boulder.ibm.com (8.12.3/NCO/VER6.4) with ESMTP id g84Kg1uP072236
	for <linux-scsi@vger.kernel.org>; Wed, 4 Sep 2002 14:42:02 -0600
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I have created a patch against 2.5.33 that cleans up the scsi_host
lists.
	- Switch scsi host template, name, host lists to struct
	  list_head's.
	- Moved all scsi_host related register / unregister functions
	  into hosts.c
	- Added list accessor interface and created a function similar
	  to driverfs bus_for_each_dev.

The patch is available at:
http://www-124.ibm.com/storageio/gen-io/patch-scsi_hosts-2.5.33-1.gz


Included creation of error handler thread, proc, driverfs entries in
scsi_register as previously discussed in Stefan Bader's patch.

Included the host number changes previously described in patches by
Itai Nahshon / Pete Zaitcev / Aron Zeh 
http://marc.theaimsgroup.com/?t=102699115600003&r=1&w=2

Testing:

UML:
	scsi_debug

2-Way 2.5.33:
	sd,sr,sg,ips built-in

	scsihosts=ips,aic7xxx,isp1020
	insmod/rmmod testing of scsi_debug, aic7xxx, and isp1020.

	scsi all modules w/initrd

Compile only:
	block/cciss_scsi.c
	scsi/53c700.c
	scsi/pcmcia/*
	scsi/wd33c93.c

Note:
	Currently I have not come up with a solution for the megaraid
	driver to work with this patch. The driver wants to reorder the
	scsi host list.

-Mike

-- 
Michael Anderson
andmike@us.ibm.com

