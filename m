From: Narsimhulu Musini <nmusini@cisco.com>
Subject: [PATCH v4 0/9] snic:initial submission of snic driver for Cisco SCSI HBA
Date: Thu,  9 Apr 2015 04:49:40 -0700
Message-ID: <1428580189-22785-1-git-send-email-nmusini@cisco.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcdn-iport-7.cisco.com ([173.37.86.78]:63690 "EHLO
	rcdn-iport-7.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755546AbbDILxJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Apr 2015 07:53:09 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@Parallels.com, linux-scsi@vger.kernel.org, hare@suse.de, hch@infradead.org
Cc: Narsimhulu Musini <nmusini@cisco.com>

The following patch series adds snic driver for Cisco SCSI HBA

Cisco has developed a new PCI HBA interface called sNIC, which stands for 
SCSI NIC. This is a new storage feature supported on specialized network
adapter. The new PCI function provides a uniform host interface and abstracts
backend storage.

* v4
- Incorporated Christoph Hellwig's comments.

* v3
- Incorporated Dr. Hannes Reinecke's review comments.

* v2
- Incorporated Dr. Hannes Reinecke's review comments.

	Thanks
	Narsimhulu Musini & Sesidhar Baddela

Narsimhulu Musini (9):
  snic: snic module infrastructure
  snic:Add interrupt, resource firmware interfaces
  snic:Add meta request,  handling of meta requests.
  snic:Add snic target discovery
  snic:add SCSI handling, AEN, and fwreset handling
  snic:Add low level queuing interfaces
  snic:Add sysfs entries to list stats and trace data
  snic:Add event tracing to capture IO events.
  snic:Add Makefile, patch Kconfig, MAINTAINERS

 MAINTAINERS                       |    7 +
 drivers/scsi/Kconfig              |   17 +
 drivers/scsi/Makefile             |    1 +
 drivers/scsi/snic/Makefile        |   21 +
 drivers/scsi/snic/cq_desc.h       |   76 ++
 drivers/scsi/snic/cq_enet_desc.h  |   38 +
 drivers/scsi/snic/snic.h          |  415 ++++++
 drivers/scsi/snic/snic_attrs.c    |   79 ++
 drivers/scsi/snic/snic_ctl.c      |  276 ++++
 drivers/scsi/snic/snic_debugfs.c  |  562 ++++++++
 drivers/scsi/snic/snic_disc.c     |  602 +++++++++
 drivers/scsi/snic/snic_disc.h     |  124 ++
 drivers/scsi/snic/snic_fwint.h    |  525 ++++++++
 drivers/scsi/snic/snic_io.c       |  519 ++++++++
 drivers/scsi/snic/snic_io.h       |  118 ++
 drivers/scsi/snic/snic_isr.c      |  209 +++
 drivers/scsi/snic/snic_main.c     | 1039 +++++++++++++++
 drivers/scsi/snic/snic_res.c      |  297 +++++
 drivers/scsi/snic/snic_res.h      |   96 ++
 drivers/scsi/snic/snic_scsi.c     | 2638 +++++++++++++++++++++++++++++++++++++
 drivers/scsi/snic/snic_stats.h    |  123 ++
 drivers/scsi/snic/snic_trc.c      |  182 +++
 drivers/scsi/snic/snic_trc.h      |  121 ++
 drivers/scsi/snic/vnic_cq.c       |   86 ++
 drivers/scsi/snic/vnic_cq.h       |  120 ++
 drivers/scsi/snic/vnic_cq_fw.h    |   62 +
 drivers/scsi/snic/vnic_dev.c      |  749 +++++++++++
 drivers/scsi/snic/vnic_dev.h      |  140 ++
 drivers/scsi/snic/vnic_devcmd.h   |  270 ++++
 drivers/scsi/snic/vnic_intr.c     |   59 +
 drivers/scsi/snic/vnic_intr.h     |  119 ++
 drivers/scsi/snic/vnic_resource.h |   68 +
 drivers/scsi/snic/vnic_snic.h     |   54 +
 drivers/scsi/snic/vnic_stats.h    |   68 +
 drivers/scsi/snic/vnic_wq.c       |  236 ++++
 drivers/scsi/snic/vnic_wq.h       |  187 +++
 drivers/scsi/snic/wq_enet_desc.h  |   91 ++
 37 files changed, 10394 insertions(+)
 create mode 100644 drivers/scsi/snic/Makefile
 create mode 100644 drivers/scsi/snic/cq_desc.h
 create mode 100644 drivers/scsi/snic/cq_enet_desc.h
 create mode 100644 drivers/scsi/snic/snic.h
 create mode 100644 drivers/scsi/snic/snic_attrs.c
 create mode 100644 drivers/scsi/snic/snic_ctl.c
 create mode 100644 drivers/scsi/snic/snic_debugfs.c
 create mode 100644 drivers/scsi/snic/snic_disc.c
 create mode 100644 drivers/scsi/snic/snic_disc.h
 create mode 100644 drivers/scsi/snic/snic_fwint.h
 create mode 100644 drivers/scsi/snic/snic_io.c
 create mode 100644 drivers/scsi/snic/snic_io.h
 create mode 100644 drivers/scsi/snic/snic_isr.c
 create mode 100644 drivers/scsi/snic/snic_main.c
 create mode 100644 drivers/scsi/snic/snic_res.c
 create mode 100644 drivers/scsi/snic/snic_res.h
 create mode 100644 drivers/scsi/snic/snic_scsi.c
 create mode 100644 drivers/scsi/snic/snic_stats.h
 create mode 100644 drivers/scsi/snic/snic_trc.c
 create mode 100644 drivers/scsi/snic/snic_trc.h
 create mode 100644 drivers/scsi/snic/vnic_cq.c
 create mode 100644 drivers/scsi/snic/vnic_cq.h
 create mode 100644 drivers/scsi/snic/vnic_cq_fw.h
 create mode 100644 drivers/scsi/snic/vnic_dev.c
 create mode 100644 drivers/scsi/snic/vnic_dev.h
 create mode 100644 drivers/scsi/snic/vnic_devcmd.h
 create mode 100644 drivers/scsi/snic/vnic_intr.c
 create mode 100644 drivers/scsi/snic/vnic_intr.h
 create mode 100644 drivers/scsi/snic/vnic_resource.h
 create mode 100644 drivers/scsi/snic/vnic_snic.h
 create mode 100644 drivers/scsi/snic/vnic_stats.h
 create mode 100644 drivers/scsi/snic/vnic_wq.c
 create mode 100644 drivers/scsi/snic/vnic_wq.h
 create mode 100644 drivers/scsi/snic/wq_enet_desc.h

-- 
1.8.5.4

