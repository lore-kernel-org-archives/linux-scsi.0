From: Naveen Burmi <naveenb@cisco.com>
Subject: [PATCH] iscsi driver update 4.0.1.8
Date: Thu, 15 Jul 2004 16:02:45 +0530
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200407151602.45830.naveenb@cisco.com>
Reply-To: naveenb@cisco.com
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from syd-iport-1.cisco.com ([64.104.193.196]:45484 "EHLO
	syd-iport-1.cisco.com") by vger.kernel.org with ESMTP
	id S264571AbUGOKc4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 15 Jul 2004 06:32:56 -0400
Received: from naveenb-lnx.cisco.com (naveenb-lnx.cisco.com [10.77.7.56])
	by syd-core-1.cisco.com (8.12.10/8.12.6) with ESMTP id i6FAWnNq008766
	for <linux-scsi@vger.kernel.org>; Thu, 15 Jul 2004 20:32:50 +1000 (EST)
Received: from localhost (localhost [[UNIX: localhost]])
	by naveenb-lnx.cisco.com (8.11.6/8.11.6) id i6FAWkc04860
	for linux-scsi@vger.kernel.org; Thu, 15 Jul 2004 16:02:46 +0530
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>

This version of the iSCSI driver (4.0.1.8) contains the following changes
since 4.0.1.7:

1. The issue of deadlock due to multiple kmaps has been partially resolved.
   We now use sendpage along the xmit path.
2. The driver used to overwrite scsi midlayer naming. This has been removed.
   Now proc_name field is used for iSCSI device lookup in sysfs.
3. The driver's queuecommand now returns SCSI_MLQUEUE_DEVICE_BUSY and
   SCSI_MLQUEUE_HOST_BUSY on failure.
4. We have removed bus reset handler from the code.

The following items are being worked on/debated:

a) Per target probe via hotplug.
In earlier reviews, it was debated that the hotplug mechanism should be used
for target activation. Though scsi_scan_host() is exported,
scsi_scan_host_selected() isn't. So, an adapter scan is exported to LLDD
whereas anything else (target or lun scan) has to go through hotplug.
Network oriented storage like iSCSI has to deal with delays in targets
getting discovered through SendTargets discovery and poll for SLP
discoveries.
It would help a lot to use scsi_scan_host_selected() in such cases and needs
to be exported for such LLDDs.

b) Removal of multiple kmaps from recv path.

c) Use of TCQ from include/linux/scsi_tcq.h

4.0.1.8 release of linux iscsi driver also contains an incremental patch 
against 4.0.1.7 release. (linux-iscsi-kernel-4.0.1.7-incremental.patch)

The driver was not included as a patch because the file is too big, but it can 
be downloaded from:

http://sourceforge.net/project/showfiles.php?group_id=26396&package_id=106938&release_id=252559

P.S. The current driver is tested against 2.6.7 linux kernel.

Thanks,
Naveen.
