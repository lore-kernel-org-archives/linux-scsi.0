From: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
Subject: [v5 00/14] mpt3sas driver NVMe support:
Date: Wed, 30 Aug 2017 19:38:24 +0530
Message-ID: <1504102118-7152-1-git-send-email-suganath-prabu.subramani@broadcom.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Sathya.Prakash@broadcom.com, linux-kernel@vger.kernel.org, sreekanth.reddy@broadcom.com, linux-nvme@lists.infradead.org, Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
List-Id: linux-scsi@vger.kernel.org

Ventura Series controller are Tri-mode. The controller and
firmware are capable of supporting NVMe devices and
PCIe switches to be connected with the controller. This
patch set adds driver level support for NVMe devices and
PCIe switches.

mpt3sas v5 patset:
1) Removed the check to find data transfer length
exceeding MDTS, Since we are setting max I/O size to
match MDTS, this check is not required.

mpt3sas v4 patset:
1) Removed code which detects gaps/holes in IO data buffers.
With commit-id 5a8d75a1b8c99bdc926ba69b7b7dbe4fae81a5af (block:
fix bio_will_gap() for first bvec with offset) driver can always assume that
their won't be any holes in the data buffers pointed by SGE's

2) Added Patch 14, This has sparse warning fixes.

mpt3sas v3 patset:
Posting version v3. This accommodates below changes
over v2 patch.

1. In the MPI header files patch, Reformatted headers to have type
and variable on one line as suggested.
2. As suggested, started using blk_queue_virt_boundary() API
for NVMe drives and simplified the PRP formation.
3. Removed 'TODO' comments

Suganath Prabu S (14):
  Update MPI Header
  mpt3sas: Add nvme device support in slave alloc,  target      alloc
    and probe
  mpt3sas: SGL to PRP Translation for I/Os to NVMe  devices
  mpt3sas: Added support for nvme encapsulated request      message.
  mpt3sas: API 's to support NVMe drive addition to  SML
  mpt3sas: API's to remove nvme drive from sml
  mpt3sas: Handle NVMe PCIe device related events  generated            
           from firmware.
  mpt3sas: Set NVMe device queue depth as 128
  mpt3sas: scan and add nvme device after controller  reset
  mpt3as: Add-Task-management-debug-info-for-NVMe-drives.
  mpt3sas: NVMe drive support for BTDHMAPPING ioctl  command      and
    log info
  mpt3sas: Fix nvme drives checking for tlr.
  mpt3sas: Update mpt3sas driver version.
  mpt3sas: Fix sparse warnings

 drivers/scsi/mpt3sas/mpi/mpi2.h          |   43 +-
 drivers/scsi/mpt3sas/mpi/mpi2_cnfg.h     |  564 +++++++-
 drivers/scsi/mpt3sas/mpi/mpi2_init.h     |   11 +-
 drivers/scsi/mpt3sas/mpi/mpi2_ioc.h      |  282 +++-
 drivers/scsi/mpt3sas/mpi/mpi2_pci.h      |  112 ++
 drivers/scsi/mpt3sas/mpi/mpi2_tool.h     |   14 +-
 drivers/scsi/mpt3sas/mpt3sas_base.c      |  675 +++++++++-
 drivers/scsi/mpt3sas/mpt3sas_base.h      |  171 ++-
 drivers/scsi/mpt3sas/mpt3sas_config.c    |  100 ++
 drivers/scsi/mpt3sas/mpt3sas_ctl.c       |  158 ++-
 drivers/scsi/mpt3sas/mpt3sas_scsih.c     | 2079 +++++++++++++++++++++++++++---
 drivers/scsi/mpt3sas/mpt3sas_warpdrive.c |    2 +-
 12 files changed, 3937 insertions(+), 274 deletions(-)
 create mode 100644 drivers/scsi/mpt3sas/mpi/mpi2_pci.h

-- 
2.5.5
