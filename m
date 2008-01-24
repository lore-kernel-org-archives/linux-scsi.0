From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: [PATCH 0/9] scsi_dh: Move dm device handler to SCSI layer
Date: Wed, 23 Jan 2008 16:30:10 -0800
Message-ID: <20080124003010.18871.84095.sendpatchset@localhost.localdomain>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e36.co.us.ibm.com ([32.97.110.154]:42016 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752314AbYAXAaN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Jan 2008 19:30:13 -0500
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e36.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id m0O0UDEq000622
	for <linux-scsi@vger.kernel.org>; Wed, 23 Jan 2008 19:30:13 -0500
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m0O0UCLk032216
	for <linux-scsi@vger.kernel.org>; Wed, 23 Jan 2008 17:30:12 -0700
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m0O0UBie028021
	for <linux-scsi@vger.kernel.org>; Wed, 23 Jan 2008 17:30:12 -0700
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dm-devel@redhat.com, linux-scsi@vger.kernel.org
Cc: andmike@us.ibm.com, michaelc@cs.wisc.edu, Chandra Seetharaman <sekharan@us.ibm.com>, jens.axboe@oracle.com

Hello,

The set of patches that follow this email facilitate movement of hardware
handlers from dm layer to SCSI layer.

Patches posted along with this email are based off of the patches
Mike Christie posted on June 09, 2007. The first email Mike posted
gives the rationale for moving the hardware handler from dm to SCSI.

Patches posted by Mike Christie:
http://marc.info/?l=linux-scsi&m=118141609715090&w=2
http://marc.info/?l=linux-scsi&m=118141614418681&w=2
http://marc.info/?l=linux-scsi&m=118141614501241&w=2
http://marc.info/?l=linux-scsi&m=118141614303990&w=2
http://marc.info/?l=linux-scsi&m=118141614425996&w=2
http://marc.info/?l=linux-scsi&m=118141802719861&w=2
http://marc.info/?l=linux-scsi&m=118141614331436&w=2
http://marc.info/?l=linux-scsi&m=118141614421759&w=2

Current set of patches has 3 additional advantages:
 1. It is totally compatible with the current multipath tools.
 2. Moving from dm hardware handler to SCSI hardware handler is not
    imposed on the user community. They can use either of those by using
    either of the modules.
    dm hardware handler can be depracated slowly.
 3. It adds a new device state SDEV_PASSIVE which avoids I/O being sent
    to the passive side of a multipath device, thereby reducing the device
    probe time and boot time.
    Booting a system with 40 luns with 1 active path and 1 inactive path
    shows the following as the last printk before login prompt.
    ------------
    With SCSI HW Handler
    [  171.702366] Buffer I/O error on device sdbl, logical block 262128

    Without SCSI HW Handler
    [ 1426.772390] end_request: I/O error, dev sdbm, sector 2097136
    ------------

Patches are created on top of 2.6.24-rc8-mm1.

Testing has been done with a IBM DS4800 storage device, which means the
infrastructure and the lsi_rdac hardware handler has been tested. Testing
by someone with the EMC hardware and/or HP hardware would be appreciated.

Comments, suggestions solicited.

Thanks,

chandra

-- 

----------------------------------------------------------------------
    Chandra Seetharaman               | Be careful what you choose....
              - sekharan@us.ibm.com   |      .......you may get it.
----------------------------------------------------------------------
