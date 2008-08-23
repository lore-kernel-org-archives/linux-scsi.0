From: jeykholt@cisco.com
Subject: [RFC][PATCH 0/6] fnic: initial submission of driver for FCoE HBA
Date: Fri, 22 Aug 2008 19:51:56 -0700
Message-ID: <20080823024949.13569.94133.stgit@feynman.nuovasystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sj-iport-6.cisco.com ([171.71.176.117]:38773 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751707AbYHWCwI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Aug 2008 22:52:08 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: jre@nuovasystems.com, ajoglekar@nuovasystems.com

The following patches add a driver for a Fibre Channel over Ethernet HBA.
This requires the libfc code to be integrated first.
This applies on top of the open-fcoe.org initiator tree at
        git://open-fcoe.org/openfc/open-fcoe-initiator.git

Cisco is working on developing a new product offering that will
leverage open-source code and will use specialized network adapter for
connectivity to existing LAN and SAN infrastructures.  The submitted
driver is required to guarantee the proper level of interoperability
and support.

This driver was written by Abhijeet Joglekar and myself.

We would appreciate any review comments.

        Thanks,
        Joe and Abhijeet


---

Joe Eykholt (6):
      fnic: add Makefile, patch Kconfig, MAINTAINERS, pci_ids.h
      fnic: add queue interfaces
      fnic: add resource, interrupt, and firmware interfaces.
      fnic:  Add fnic_fcs.c and fnic_attr.c.
      fnic: add fnic_scsi.c and fnic_io.h.
      fnic: add main file with module infrastructure, etc.


 MAINTAINERS                       |    8 
 drivers/scsi/Kconfig              |   10 
 drivers/scsi/Makefile             |    1 
 drivers/scsi/fnic/Makefile        |   15 
 drivers/scsi/fnic/cq_desc.h       |   90 ++
 drivers/scsi/fnic/cq_enet_desc.h  |  222 +++++
 drivers/scsi/fnic/cq_exch_desc.h  |  261 ++++++
 drivers/scsi/fnic/fcpio.h         |  743 +++++++++++++++++
 drivers/scsi/fnic/fnic.h          |  233 +++++
 drivers/scsi/fnic/fnic_attrs.c    |   71 ++
 drivers/scsi/fnic/fnic_fcs.c      |  710 ++++++++++++++++
 drivers/scsi/fnic/fnic_io.h       |   65 +
 drivers/scsi/fnic/fnic_isr.c      |  345 ++++++++
 drivers/scsi/fnic/fnic_main.c     |  918 +++++++++++++++++++++
 drivers/scsi/fnic/fnic_res.c      |  367 ++++++++
 drivers/scsi/fnic/fnic_res.h      |  199 +++++
 drivers/scsi/fnic/fnic_scsi.c     | 1605 +++++++++++++++++++++++++++++++++++++
 drivers/scsi/fnic/rq_enet_desc.h  |   58 +
 drivers/scsi/fnic/vnic_cq.c       |   86 ++
 drivers/scsi/fnic/vnic_cq.h       |  113 +++
 drivers/scsi/fnic/vnic_cq_copy.h  |   62 +
 drivers/scsi/fnic/vnic_dev.c      |  577 +++++++++++++
 drivers/scsi/fnic/vnic_dev.h      |   92 ++
 drivers/scsi/fnic/vnic_devcmd.h   |  204 +++++
 drivers/scsi/fnic/vnic_intr.c     |   60 +
 drivers/scsi/fnic/vnic_intr.h     |   89 ++
 drivers/scsi/fnic/vnic_nic.h      |   63 +
 drivers/scsi/fnic/vnic_resource.h |   61 +
 drivers/scsi/fnic/vnic_rq.c       |  192 ++++
 drivers/scsi/fnic/vnic_rq.h       |  205 +++++
 drivers/scsi/fnic/vnic_scsi.h     |   58 +
 drivers/scsi/fnic/vnic_stats.h    |   62 +
 drivers/scsi/fnic/vnic_wq.c       |  173 ++++
 drivers/scsi/fnic/vnic_wq.h       |  150 +++
 drivers/scsi/fnic/vnic_wq_copy.c  |  117 +++
 drivers/scsi/fnic/vnic_wq_copy.h  |  125 +++
 drivers/scsi/fnic/wq_enet_desc.h  |   92 ++
 include/linux/pci_ids.h           |    3 
 38 files changed, 8505 insertions(+), 0 deletions(-)
 create mode 100644 drivers/scsi/fnic/Makefile
 create mode 100644 drivers/scsi/fnic/cq_desc.h
 create mode 100644 drivers/scsi/fnic/cq_enet_desc.h
 create mode 100644 drivers/scsi/fnic/cq_exch_desc.h
 create mode 100644 drivers/scsi/fnic/fcpio.h
 create mode 100644 drivers/scsi/fnic/fnic.h
 create mode 100644 drivers/scsi/fnic/fnic_attrs.c
 create mode 100644 drivers/scsi/fnic/fnic_fcs.c
 create mode 100644 drivers/scsi/fnic/fnic_io.h
 create mode 100644 drivers/scsi/fnic/fnic_isr.c
 create mode 100644 drivers/scsi/fnic/fnic_main.c
 create mode 100644 drivers/scsi/fnic/fnic_res.c
 create mode 100644 drivers/scsi/fnic/fnic_res.h
 create mode 100644 drivers/scsi/fnic/fnic_scsi.c
 create mode 100644 drivers/scsi/fnic/rq_enet_desc.h
 create mode 100644 drivers/scsi/fnic/vnic_cq.c
 create mode 100755 drivers/scsi/fnic/vnic_cq.h
 create mode 100644 drivers/scsi/fnic/vnic_cq_copy.h
 create mode 100644 drivers/scsi/fnic/vnic_dev.c
 create mode 100644 drivers/scsi/fnic/vnic_dev.h
 create mode 100644 drivers/scsi/fnic/vnic_devcmd.h
 create mode 100644 drivers/scsi/fnic/vnic_intr.c
 create mode 100755 drivers/scsi/fnic/vnic_intr.h
 create mode 100755 drivers/scsi/fnic/vnic_nic.h
 create mode 100644 drivers/scsi/fnic/vnic_resource.h
 create mode 100644 drivers/scsi/fnic/vnic_rq.c
 create mode 100755 drivers/scsi/fnic/vnic_rq.h
 create mode 100755 drivers/scsi/fnic/vnic_scsi.h
 create mode 100755 drivers/scsi/fnic/vnic_stats.h
 create mode 100644 drivers/scsi/fnic/vnic_wq.c
 create mode 100755 drivers/scsi/fnic/vnic_wq.h
 create mode 100644 drivers/scsi/fnic/vnic_wq_copy.c
 create mode 100644 drivers/scsi/fnic/vnic_wq_copy.h
 create mode 100644 drivers/scsi/fnic/wq_enet_desc.h

-- 
Signature
