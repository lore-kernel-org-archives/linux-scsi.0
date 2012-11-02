From: Jeff Moyer <jmoyer@redhat.com>
Subject: [patch,v2 00/10] make I/O path allocations more numa-friendly
Date: Fri,  2 Nov 2012 17:45:53 -0400
Message-ID: <1351892763-21325-1-git-send-email-jmoyer@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: Bart Van Assche <bvanassche@acm.org>
List-Id: linux-scsi@vger.kernel.org

Hi,

This patch set makes memory allocations for data structures used in
the I/O path more numa friendly by allocating them from the same numa
node as the storage device.  I've only converted a handfull of drivers
at this point.  My testing showed that, for workloads where the I/O
processes were not tied to the numa node housing the device, a speedup
of around 6% was observed.  When the I/O processes were tied to the
numa node of the device, there was no measurable difference in my test
setup.  Given my relatively low-end setup[1], I wouldn't be surprised
if others could show a more significant performance advantage.

Comments would be greatly appreciated.

Cheers,
Jeff

[1] LSI Megaraid SAS controller with 1GB battery-backed cache,
fronting a RAID 6 10+2.  The workload I used was tuned to not
have to hit disk.  Fio file attached.

--
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
 drivers/scsi/scsi.c                       |   17 +++++++++++------
 drivers/scsi/scsi_lib.c                   |    2 +-
 drivers/scsi/scsi_scan.c                  |    4 ++--
 drivers/scsi/sd.c                         |    2 +-
 include/scsi/scsi_host.h                  |    8 ++++++++
 11 files changed, 49 insertions(+), 22 deletions(-)
