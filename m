From: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
Subject: [PATCH v4 00/14] mpt3sas driver NVMe support:
Date: Mon, 21 Aug 2017 19:02:10 +0530
Message-ID: <1503322344-5900-1-git-send-email-suganath-prabu.subramani@broadcom.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@kernel.org, hch@infradead.org
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, Sathya.Prakash@broadcom.com, kashyap.desai@broadcom.com, linux-kernel@vger.kernel.org, suganath-prabu.subramani@broadcom.com, chaitra.basappa@broadcom.com, sreekanth.reddy@broadcom.com, martin.p^Cersen@oracle.com, linux-nvme@lists.infradead.org
List-Id: linux-scsi@vger.kernel.org

Ventura Series controller are Tri-mode. The controller and
firmware are capable of supporting NVMe devices and
PCIe switches to be connected with the controller. This
patch set adds driver level support for NVMe devices and
PCIe switches.

mpt3sas v4 patset:

1) Removed code which detects gaps/holes in IO data buffers.
2) Added Patch 14, This has sparse warning fixes.

mpt3sas v3 patset:
Posting version v3. This accommodates below changes
over v2 patch.

1. In the MPI header files patch, Reformatted headers to have type
and variable on one line as suggested.
2. As suggested, started using blk_queue_virt_boundary() API
for NVMe drives and simplified the PRP formation.
3. Removed 'TODO' comments.

Suganath Prabu S (14):
  mpt3sas: Update MPI Header
  mpt3sas: Add nvme device support in slave alloc, target alloc and
    probe
  mpt3sas: SGL to PRP Translation for I/Os to NVMe  devices
  mpt3sas: Added support for nvme encapsulated request message.
  mpt3sas: API 's to support NVMe drive addition to SML
  mpt3sas: API's to remove nvme drive from sml
  mpt3sas: Handle NVMe PCIe device related events generated             
         from firmware.
  mpt3sas: Set NVMe device queue depth as 128
  mpt3sas: scan and add nvme device after controller reset
  mpt3as: Add-Task-management-debug-info-for-NVMe-drives.
  mpt3sas: NVMe drive support for BTDHMAPPING ioctl command and log info
  mpt3sas: Fix nvme drives checking for tlr.
  mpt3sas: Update mpt3sas driver version.
  mpt3sas: Fix sparse warning

 drivers/scsi/mpt3sas/mpi/mpi2.h          |   43 +-
 drivers/scsi/mpt3sas/mpi/mpi2_cnfg.h     |  564 +++++++-
 drivers/scsi/mpt3sas/mpi/mpi2_init.h     |   11 +-
 drivers/scsi/mpt3sas/mpi/mpi2_ioc.h      |  282 +++-
 drivers/scsi/mpt3sas/mpi/mpi2_pci.h      |  112 ++
 drivers/scsi/mpt3sas/mpi/mpi2_tool.h     |   14 +-
 drivers/scsi/mpt3sas/mpt3sas_base.c      |  686 +++++++++-
 drivers/scsi/mpt3sas/mpt3sas_base.h      |  171 ++-
 drivers/scsi/mpt3sas/mpt3sas_config.c    |  100 ++
 drivers/scsi/mpt3sas/mpt3sas_ctl.c       |  158 ++-
 drivers/scsi/mpt3sas/mpt3sas_scsih.c     | 2076 +++++++++++++++++++++++++++---
 drivers/scsi/mpt3sas/mpt3sas_warpdrive.c |    2 +-
 12 files changed, 3945 insertions(+), 274 deletions(-)
 create mode 100644 drivers/scsi/mpt3sas/mpi/mpi2_pci.h

Thanks,
Suganath Prabu S

-- 
2.5.5
