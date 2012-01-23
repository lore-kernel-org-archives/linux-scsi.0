From: Neerav Parikh <neerav.parikh@intel.com>
Subject: [PATCH 0/6] Support FDMI in libfc
Date: Sun, 22 Jan 2012 17:29:44 -0800
Message-ID: <20120123012944.923.63220.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:11283 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752528Ab2AWBk6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 22 Jan 2012 20:40:58 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: JBottomley@parallels.com, james.smart@emulex.com, devel@open-fcoe.org


The following series implements support for FC-GS
Fabric Device Management Interface (FDMI) in libfc
and scsi_transport_fc in preparation to support
FDMI via open-fcoe stack in the kernel.

The series provides an optional capability for any
driver dependent on libfc to register FDMI HBA and
Port attributes with the Fabric's Management Service
entity via libfc lport state machine.

It also allows any FC/FCoE HBA/CNA driver that does
not depend on libfc to expose FDMI attributes via
fc_host class in sysfs.

The last two patches utilizes the FDMI facility of
libfc in FCoE driver.

---

Neerav Parikh (6):
      scsi_transport_fc: Add FDMI host attributes
      scsi_transport_fc: Getting FC Port Speed in sync with FC-GS
      libfc: Make the libfc Common Transport(CT) code generic
      libfc: Add support for FDMI
      fcoe: Add support for FDMI in fcoe
      fcoe: Allow exposing FDMI attributes via sysfs


 drivers/scsi/fcoe/fcoe.c         |   90 +++++++++
 drivers/scsi/libfc/fc_elsct.c    |    3 
 drivers/scsi/libfc/fc_lport.c    |  227 +++++++++++++++++++++++-
 drivers/scsi/scsi_transport_fc.c |   30 +++
 include/scsi/fc/fc_ms.h          |  213 ++++++++++++++++++++++
 include/scsi/fc_encode.h         |  363 +++++++++++++++++++++++++++++++++++++-
 include/scsi/libfc.h             |   11 +
 include/scsi/scsi_transport_fc.h |   32 +++
 8 files changed, 949 insertions(+), 20 deletions(-)
 create mode 100644 include/scsi/fc/fc_ms.h

-- 
Neerav Parikh <neerav.parikh@intel.com>
