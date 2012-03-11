From: Dan Williams <dan.j.williams@intel.com>
Subject: [isci PATCH v2 00/18] isci: suspend/resume support + general updates
Date: Sat, 10 Mar 2012 23:27:44 -0800
Message-ID: <20120311072518.6320.61717.stgit@dwillia2-linux.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Changes since v1: http://marc.info/?l=linux-scsi&m=132886463201718&w=2

This series has been rebased on top of v10 of the libsas reworks, merged
with a recent scsi-rc-fixes (commit fea6d60).

1/ PATCH 1 - 3, 6, 11, 15: Cleanups identified along the way towards
   implementing the below fixes and features.

2/ PATCH 4, 9, 13, 18: Fixes to discovery in both the driver and libsas.

3/ PATCH 7 - 8, 12, 14, 16 - 17:  Suspend support.  The approach taken
   with suspend/resume support is to put the bulk of the responsibility on
   libsas.  The lldd is free to tear down its links and domain_device info
   with the knowledge that libsas will handle recovering those connections
   and devices at resume time.
  
---

[isci PATCH v2 01/18] isci: improve 'invalid state' warnings
[isci PATCH v2 02/18] isci: kill ->is_direct_attached
[isci PATCH v2 03/18] isci: kill sci_phy_protocol and sci_request_protocol
[isci PATCH v2 04/18] isci: Don't filter BROADCAST CHANGE primitives
[isci PATCH v2 05/18] isci: kill ->status, and ->state_lock in isci_host
[isci PATCH v2 06/18] isci: kill isci_port.domain_dev_list
[isci PATCH v2 07/18] isci: refactor initialization for S3/S4
[isci PATCH v2 08/18] isci: fix controller stop
[isci PATCH v2 09/18] isci: fix 'link-up' events occur after 'start-complete'
[isci PATCH v2 10/18] isci: fix interrupt disable
[isci PATCH v2 11/18] isci: kill isci_host.shost
[isci PATCH v2 12/18] libata: make ata_print_id atomic
[isci PATCH v2 13/18] libsas: continue revalidation
[isci PATCH v2 14/18] libata: export ata_port suspend/resume infrastructure for sas
[isci PATCH v2 15/18] libsas: drop sata port multiplier infrastructure
[isci PATCH v2 16/18] libsas: suspend / resume support
[isci PATCH v2 17/18] isci: implement suspend/resume support
[isci PATCH v2 18/18] isci: Changes in COMSAS timings enabling ISCI to detect buggy disc drives.

 drivers/ata/libata-core.c                     |   62 ++-
 drivers/ata/libata-scsi.c                     |    4 
 drivers/ata/libata.h                          |    2 
 drivers/scsi/isci/host.c                      |  564 +++++++++----------------
 drivers/scsi/isci/host.h                      |  118 +----
 drivers/scsi/isci/init.c                      |  271 +++++++++++-
 drivers/scsi/isci/phy.c                       |   74 +++
 drivers/scsi/isci/phy.h                       |    9 
 drivers/scsi/isci/port.c                      |   21 -
 drivers/scsi/isci/port.h                      |    6 
 drivers/scsi/isci/port_config.c               |   18 -
 drivers/scsi/isci/probe_roms.c                |   12 -
 drivers/scsi/isci/probe_roms.h                |    2 
 drivers/scsi/isci/registers.h                 |    8 
 drivers/scsi/isci/remote_device.c             |   29 -
 drivers/scsi/isci/remote_device.h             |    1 
 drivers/scsi/isci/remote_node_context.c       |   60 +--
 drivers/scsi/isci/request.c                   |   19 -
 drivers/scsi/isci/request.h                   |    9 
 drivers/scsi/isci/unsolicited_frame_control.c |   30 -
 drivers/scsi/isci/unsolicited_frame_control.h |    6 
 drivers/scsi/libsas/sas_ata.c                 |   86 ++++
 drivers/scsi/libsas/sas_discover.c            |   74 +++
 drivers/scsi/libsas/sas_dump.c                |    1 
 drivers/scsi/libsas/sas_event.c               |    4 
 drivers/scsi/libsas/sas_expander.c            |    8 
 drivers/scsi/libsas/sas_init.c                |   90 ++++
 drivers/scsi/libsas/sas_internal.h            |    2 
 drivers/scsi/libsas/sas_phy.c                 |   21 +
 drivers/scsi/libsas/sas_port.c                |   52 ++
 drivers/scsi/libsas/sas_scsi_host.c           |    2 
 include/linux/libata.h                        |    2 
 include/scsi/libsas.h                         |   21 +
 include/scsi/sas.h                            |    1 
 include/scsi/sas_ata.h                        |   10 
 35 files changed, 1017 insertions(+), 682 deletions(-)
