From: Joe Lawrence <joe.lawrence@stratus.com>
Subject: [PATCH 0/2] _scsih_sas_host_add early exits can crash system
Date: Wed, 25 May 2016 15:14:27 -0400
Message-ID: <1464203669-31974-1-git-send-email-joe.lawrence@stratus.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2on0130.outbound.protection.outlook.com ([207.46.100.130]:28352
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751213AbcEYTOn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 May 2016 15:14:43 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: sathya.prakash@broadcom.com, chaitra.basappa@broadcom.com, suganath-prabu.subramani@broadcom.com, Joe Lawrence <joe.lawrence@stratus.com>

There are many error paths in _scsih_sas_host_add that lead to an early
exit and a few that leave IOC resources uninitialized, setting the stage
for a later crash.

This can be emulated using a systemtap script like:

  % stap -g -e \
  'probe module("mpt3sas").function("mpt3sas_config_get_sas_iounit_pg0").return { $return = -1 }'

to force early exit, while remove/re-adding an MPT3 adapter:

  % lspci -D | grep MPT
  0000:54:00.0 Mass storage controller: LSI Logic / Symbios Logic SAS3008 PCI-Express Fusion-MPT SAS-3 (rev 02)

  % SYSFS=$(find /sys/devices -name 0000:54:00.0)
  % SYSFS_PARENT=$(dirname $SYSFS)

  % echo 1 > $SYSFS/remove
  % sleep 1m
  % echo 1 > $SYSFS_PARENT/rescan

These two patches fix:
  1) referencing unallocated ioc->sas_hba.phy[] space
  2) passing a NULL ioc->sas_hba.parent_dev to the scsi_transport_sas
     layer.

Note: these changes don't improve or retry adapter initialization, but
      only try to prevent the system from crashing

Joe Lawrence (2):
  mpt3sas - set num_phys after allocating phy[] space
  mpt3sas - avoid mpt3sas_transport_port_add NULL parent_dev

 drivers/scsi/mpt3sas/mpt3sas_scsih.c     | 20 +++++++++++---------
 drivers/scsi/mpt3sas/mpt3sas_transport.c |  5 +++++
 2 files changed, 16 insertions(+), 9 deletions(-)

-- 
1.8.3.1

