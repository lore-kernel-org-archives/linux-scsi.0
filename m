From: Jeff Moyer <jmoyer@redhat.com>
Subject: [patch,v3,repost 00/10] make I/O path allocations more numa-friendly
Date: Tue, 27 Nov 2012 11:46:28 -0500
Message-ID: <1354034799-8460-1-git-send-email-jmoyer@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, JBottomley@parallels.com
Cc: Bart Van Assche <bvanassche@acm.org>
List-Id: linux-scsi@vger.kernel.org

Hi,

This patch set makes memory allocations for data structures used in
the I/O path more numa friendly by allocating them from the same numa
node as the storage device.  I've only converted a handful of drivers
at this point.  My testing is limited by the hardware I have on hand.
Using these patches, I was able to max out the bandwidth of the storage
controller when issuing I/O from any node on my 4 node system.  Without
the patch, I/O from nodes remote to the storage device would suffer a
penalty ranging from 6-12%.  Given my relatively low-end setup[1], I
wouldn't be surprised if others could show a more significant performance
advantage.

This is a repost of the last posting.  The only changes are additional
reviewed-by/acked-by tags.  I think this version is ready for inclusion.
James, would you mind taking a look?

Cheers,
Jeff

[1] LSI Megaraid SAS controller with 1GB battery-backed cache,
fronting a RAID 6 10+2.  The workload I used was tuned to not
have to hit disk.  Fio file attached.

--
changes from v2->v3:
- Made the numa_node Scsi_Host structure member dependent on CONFIG_NUMA
- Got rid of a GFP_ZERO I added accidentally
changes from v1->v2:
- got rid of the vfs patch, as Al pointed out some fundamental
  problems with it
- credited Bart van Assche properly


Jeff Moyer (10):
  scsi: add scsi_host_alloc_node
  scsi: make __scsi_alloc_queue numa-aware
  scsi: make scsi_alloc_sdev numa-aware
  scsi: allocate scsi_cmnd-s from the device's local numa node
  sd: use alloc_disk_node
  ata: use scsi_host_alloc_node
  megaraid_sas: use scsi_host_alloc_node
  mpt2sas: use scsi_host_alloc_node
  lpfc: use scsi_host_alloc_node
  cciss: use blk_init_queue_node

 drivers/ata/libata-scsi.c                 |    3 ++-
 drivers/block/cciss.c                     |    3 ++-
 drivers/scsi/hosts.c                      |   13 +++++++++++--
 drivers/scsi/lpfc/lpfc_init.c             |   10 ++++++----
 drivers/scsi/megaraid/megaraid_sas_base.c |    5 +++--
 drivers/scsi/mpt2sas/mpt2sas_scsih.c      |    4 ++--
 drivers/scsi/scsi.c                       |   16 ++++++++++------
 drivers/scsi/scsi_lib.c                   |    3 ++-
 drivers/scsi/scsi_scan.c                  |    4 ++--
 drivers/scsi/sd.c                         |    2 +-
 include/scsi/scsi_host.h                  |   28 ++++++++++++++++++++++++++++
 11 files changed, 69 insertions(+), 22 deletions(-)
