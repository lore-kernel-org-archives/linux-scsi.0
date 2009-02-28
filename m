From: Abhijeet Joglekar <abjoglek@cisco.com>
Subject: [PATCH 0/6] FCoE HBA Driver (fnic) for 2.6.30 feature window
Date: Fri, 27 Feb 2009 18:31:16 -0800
Message-ID: <20090228022152.12158.11200.stgit@feynman.nuovasystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.nuovasystems.com ([67.91.200.194]:26822 "EHLO
	feynman.nuovasystems.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754594AbZB1CqL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Feb 2009 21:46:11 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org
Cc: abjoglek@cisco.com, jeykholt@cisco.com

The following series implements a driver for a Fibre Channel over Ethernet HBA.
The driver requires libFC module.

This patch series applies on top of:
(1) Linus' kernel tree (2.6.29-rc6) or scsi-misc or scsi-rc-fixes
WITH
(2) LibFC patches re-submitted today by Robert Love
(http://marc.info/?l=linux-scsi&m=123576089125544&w=2, libfc and fcoe fixes
for 2.6.29-rc)

The driver interfaces with scsi and scsi-transport-fc for SCSI FCP processing,
and with libFC for Fibre Channel Services (Fabric Login, Discovery, Remote
Port Logins)

Patch 1) This adds main module infrastructure files and interfaces to scsi,
scsi-transport-fc, and libFC

Patch 2) This adds SCSI FCP processing

Patch 3) This adds interface to libFC to handle Fibre Channel Services

Patch 4) Resource allocations for the driver

Patch 5) Interfaces to hardware, fw, queues, descriptors, buffers

Patch 6) This adds to scsi/Kconfig, scsi/Makefile, and MAINTAINERS

We would like to be considered for inclusion in the 2.6.30 feature window,
and would appreciate review comments.

Thanks,
Abhijeet Joglekar
Joe Eykholt

---

Abhijeet Joglekar (6):
      fnic: Patch MAINTAINERS, scsi Makefile, scsi Kconfig
      fnic: add descriptor right, buffers, device interface
      fnic: adds resource allocation, interupt interfaces
      fnic: Add support for Fibre Channel Services through libFC
      fnic: add SCSI FCP handling
      fnic: add main file with module infrastructure, fnic structure, Makefile


 MAINTAINERS                       |    8 
 drivers/scsi/Kconfig              |   11 
 drivers/scsi/Makefile             |    1 
 drivers/scsi/fnic/Makefile        |   15 
 drivers/scsi/fnic/cq_desc.h       |   78 ++
 drivers/scsi/fnic/cq_enet_desc.h  |  167 +++
 drivers/scsi/fnic/cq_exch_desc.h  |  182 ++++
 drivers/scsi/fnic/fcpio.h         |  780 +++++++++++++++
 drivers/scsi/fnic/fnic.h          |  283 ++++++
 drivers/scsi/fnic/fnic_attrs.c    |   71 +
 drivers/scsi/fnic/fnic_fcs.c      |  719 ++++++++++++++
 drivers/scsi/fnic/fnic_io.h       |   67 +
 drivers/scsi/fnic/fnic_isr.c      |  334 +++++++
 drivers/scsi/fnic/fnic_main.c     |  998 ++++++++++++++++++++
 drivers/scsi/fnic/fnic_res.c      |  431 +++++++++
 drivers/scsi/fnic/fnic_res.h      |  197 ++++
 drivers/scsi/fnic/fnic_scsi.c     | 1869 +++++++++++++++++++++++++++++++++++++
 drivers/scsi/fnic/rq_enet_desc.h  |   58 +
 drivers/scsi/fnic/vnic_cq.c       |   86 ++
 drivers/scsi/fnic/vnic_cq.h       |  121 ++
 drivers/scsi/fnic/vnic_cq_copy.h  |   62 +
 drivers/scsi/fnic/vnic_dev.c      |  690 ++++++++++++++
 drivers/scsi/fnic/vnic_dev.h      |  161 +++
 drivers/scsi/fnic/vnic_devcmd.h   |  281 ++++++
 drivers/scsi/fnic/vnic_intr.c     |   60 +
 drivers/scsi/fnic/vnic_intr.h     |  118 ++
 drivers/scsi/fnic/vnic_nic.h      |   69 +
 drivers/scsi/fnic/vnic_resource.h |   61 +
 drivers/scsi/fnic/vnic_rq.c       |  197 ++++
 drivers/scsi/fnic/vnic_rq.h       |  235 +++++
 drivers/scsi/fnic/vnic_scsi.h     |   99 ++
 drivers/scsi/fnic/vnic_stats.h    |   68 +
 drivers/scsi/fnic/vnic_wq.c       |  183 ++++
 drivers/scsi/fnic/vnic_wq.h       |  175 +++
 drivers/scsi/fnic/vnic_wq_copy.c  |  118 ++
 drivers/scsi/fnic/vnic_wq_copy.h  |  129 +++
 drivers/scsi/fnic/wq_enet_desc.h  |   96 ++
 37 files changed, 9278 insertions(+), 0 deletions(-)
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
 create mode 100644 drivers/scsi/fnic/vnic_cq.h
 create mode 100644 drivers/scsi/fnic/vnic_cq_copy.h
 create mode 100644 drivers/scsi/fnic/vnic_dev.c
 create mode 100644 drivers/scsi/fnic/vnic_dev.h
 create mode 100644 drivers/scsi/fnic/vnic_devcmd.h
 create mode 100644 drivers/scsi/fnic/vnic_intr.c
 create mode 100644 drivers/scsi/fnic/vnic_intr.h
 create mode 100644 drivers/scsi/fnic/vnic_nic.h
 create mode 100644 drivers/scsi/fnic/vnic_resource.h
 create mode 100644 drivers/scsi/fnic/vnic_rq.c
 create mode 100644 drivers/scsi/fnic/vnic_rq.h
 create mode 100644 drivers/scsi/fnic/vnic_scsi.h
 create mode 100644 drivers/scsi/fnic/vnic_stats.h
 create mode 100644 drivers/scsi/fnic/vnic_wq.c
 create mode 100644 drivers/scsi/fnic/vnic_wq.h
 create mode 100644 drivers/scsi/fnic/vnic_wq_copy.c
 create mode 100644 drivers/scsi/fnic/vnic_wq_copy.h
 create mode 100644 drivers/scsi/fnic/wq_enet_desc.h

-- 
Signature
