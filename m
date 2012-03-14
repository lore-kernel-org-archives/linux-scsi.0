From: Dan Williams <dan.j.williams@intel.com>
Subject: [isci PATCH v3 0/4] isci: suspend/resume support+
Date: Wed, 14 Mar 2012 00:13:48 -0700
Message-ID: <20120314071312.7223.10946.stgit@dwillia2-linux.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:55280 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751149Ab2CNG6a (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 14 Mar 2012 02:58:30 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-ide@vger.kernel.org

Changes since v2: http://marc.info/?l=linux-scsi&m=133144999728737&w=2

This topic has been rebased on top of the libsas topic / scsi-misc:
http://marc.info/?l=linux-scsi&m=133170574921314&w=2

1/ Fixed handling of the 'device unplugged during suspend' case.
   sd_remove() sets up an ABBA deadlock with the driver-core device_lock()
   and async_synchronize_full(), so this version arranges for resume
   actions to be flushed before attempting removals.

2/ Add a new fix for a case where the isci driver inadvertently filters
   BCNs

3/ Fix up compile breakage in the CONFIG_PM=n case

4/ Minor fixups for the rebase (sas_init_dev reindent collision)

[isci PATCH v3 1/4] libata: export ata_port suspend/resume infrastructure for sas
[isci PATCH v3 2/4] libsas: drop sata port multiplier infrastructure
[isci PATCH v3 3/4] libsas: suspend / resume support
[isci PATCH v3 4/4] isci: enable BCN in sci_port_add_phy()

Full diffstat versus scsi-misc (cd8df93..isci-for-3.4-v3):

Andrzej Jakowski (1):
      isci: Changes in COMSAS timings enabling ISCI to detect buggy disc drives.

Artur Wojcik (1):
      isci: implement suspend/resume support

Dan Williams (19):
      libsas: introduce sas_work to fix sas_drain_work vs sas_queue_work
      libsas: cleanup spurious calls to scsi_schedule_eh
      libata, libsas: introduce sched_eh and end_eh port ops
      libsas: enforce eh strategy handlers only in eh context
      isci: improve 'invalid state' warnings
      isci: kill ->is_direct_attached
      isci: kill sci_phy_protocol and sci_request_protocol
      isci: kill ->status, and ->state_lock in isci_host
      isci: kill isci_port.domain_dev_list
      isci: refactor initialization for S3/S4
      isci: fix controller stop
      isci: fix 'link-up' events occur after 'start-complete'
      isci: fix interrupt disable
      isci: kill isci_host.shost
      libata: make ata_print_id atomic
      libsas: continue revalidation
      libata: export ata_port suspend/resume infrastructure for sas
      libsas: drop sata port multiplier infrastructure
      libsas: suspend / resume support

Jesper Juhl (1):
      isci: Just #include "host.h" once in host.c

Maciej Trela (1):
      isci: enable BCN in sci_port_add_phy()

Tom Jackson (1):
      isci: Don't filter BROADCAST CHANGE primitives

 drivers/ata/libata-core.c                     |   66 +++-
 drivers/ata/libata-eh.c                       |   57 ++-
 drivers/ata/libata-scsi.c                     |    4 +-
 drivers/ata/libata.h                          |    2 +-
 drivers/scsi/isci/host.c                      |  565 +++++++++----------------
 drivers/scsi/isci/host.h                      |  118 ++----
 drivers/scsi/isci/init.c                      |  271 +++++++++++--
 drivers/scsi/isci/phy.c                       |   74 +++-
 drivers/scsi/isci/phy.h                       |    9 +-
 drivers/scsi/isci/port.c                      |   23 +-
 drivers/scsi/isci/port.h                      |    6 -
 drivers/scsi/isci/port_config.c               |   18 +-
 drivers/scsi/isci/probe_roms.c                |   12 -
 drivers/scsi/isci/probe_roms.h                |    2 -
 drivers/scsi/isci/registers.h                 |    8 +
 drivers/scsi/isci/remote_device.c             |   29 +-
 drivers/scsi/isci/remote_device.h             |    1 -
 drivers/scsi/isci/remote_node_context.c       |   60 ++--
 drivers/scsi/isci/request.c                   |   19 +-
 drivers/scsi/isci/request.h                   |    9 +-
 drivers/scsi/isci/unsolicited_frame_control.c |   30 +-
 drivers/scsi/isci/unsolicited_frame_control.h |    6 +-
 drivers/scsi/libsas/sas_ata.c                 |  149 ++++++--
 drivers/scsi/libsas/sas_discover.c            |  132 +++++--
 drivers/scsi/libsas/sas_dump.c                |    1 +
 drivers/scsi/libsas/sas_event.c               |   40 +-
 drivers/scsi/libsas/sas_expander.c            |    8 +-
 drivers/scsi/libsas/sas_init.c                |  129 +++++-
 drivers/scsi/libsas/sas_internal.h            |    7 +-
 drivers/scsi/libsas/sas_phy.c                 |   42 ++-
 drivers/scsi/libsas/sas_port.c                |   67 +++-
 drivers/scsi/libsas/sas_scsi_host.c           |  153 ++++++-
 include/linux/libata.h                        |   15 +
 include/scsi/libsas.h                         |   76 +++-
 include/scsi/sas.h                            |    1 +
 include/scsi/sas_ata.h                        |   19 +-
 36 files changed, 1409 insertions(+), 819 deletions(-)
