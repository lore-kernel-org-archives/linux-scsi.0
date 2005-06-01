From: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Subject: [PATCH 4/4] fusion - Miscellanous updates, and bump driver version
Date: Wed, 1 Jun 2005 10:47:45 -0600
Message-ID: <200506011047.45902.Eric.Moore@lsil.com>
Reply-To: Eric.Moore@lsil.com
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:56549 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S261466AbVFAQvD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Jun 2005 12:51:03 -0400
Received: from milmhbs0.lsil.com (mhbs.lsil.com [147.145.1.30])
	by mail0.lsil.com (8.12.8/8.12.8) with ESMTP id j51Glgo7007775
	for <linux-scsi@vger.kernel.org>; Wed, 1 Jun 2005 09:47:42 -0700 (PDT)
Received: from mailmux (popmil.lsil.com [147.145.13.217])
	by milmhbs0.lsil.com (8.12.11/8.12.11) with SMTP id j51Gp2O9005864
	for <linux-scsi@vger.kernel.org>; Wed, 1 Jun 2005 09:51:02 -0700
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux scsi <linux-scsi@vger.kernel.org>

mptfusion patch 4/4:

This patch can also be found at this URL:
ftp://ftp.lsil.com/HostAdapterDrivers/linux/Fusion-MPT/2.6-kernel/3.03.03/

Changelog:
* bump driver version to 3.03.03 
* SAS pci id recoginzation
* implemented new SAS functions for host page buffers - 
this feature is for firmware to allow usage of host physical memory 
for RAID related features, when memory is limited in controller memory space
* implemented new SAS funtions for clearing the persistant mappings - this can
occur if ioc facts config page says it needs clearing, or we could receive an
async event from firmware requesting it cleared when table is full, or we can
force clearing it thru a command line option when driver loads
* mpt_interrupt clean up code - main interrupt handler, also adding 0xdeadbeef
check for validating message frames being in use or freed.
* removed RAID related data from the _SpiCfgData struct, and moved to
new structure called _RaidCfgData, also created new struct _SasCfgData.
* MSI Suport - this is enabled thru command line option
* SAS fixes for firmware download boot
* Event Handling - updated debug strings with support for new SAS and RAID 
events
* Some changes in scsi completion routine - handling returning proper status
for underrun case 
* added target reset in mptscsih_slave_destroy function when scsi device is
being removed - clears the firmware outstanding io queue.
* eh entry points - cleanup, and added some more debuging info, added dumping
fw response code
* minor domain validation fixes.

Signed-off-by: Eric.Moore<Eric.Moore@lsil.com>
