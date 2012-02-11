From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 00/12] libfc, libfcoe and fcoe updates for scsi-misc
Date: Fri, 10 Feb 2012 17:17:54 -0800
Message-ID: <20120211011754.7668.51489.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:56003 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753419Ab2BKBRz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Feb 2012 20:17:55 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This series contains a variety of fixes and general
improvements to the libfc, libfcoe and fcoe kernel
modules.

Note that this series resends Neerav Parikh's FDMI
feature patch series that was previously posted to
linux-scsi. It's a FC/FCoE feature, so I put it in
my tree to make sure I keep track of it. If I should
resend this series without it, please let me know,
I would be happy to do so.

Aside from the contributors own testing I ran
basic tests against this series on scsi-misc on
the day of this posting.

---

Bhanu Prakash Gollapudi (2):
      libfc: Fix panic in fc_exch_recv
      libfc: Handle discovery failure during ctlr link down

Neerav Parikh (6):
      scsi_transport_fc: Add FDMI host attributes
      scsi_transport_fc: Getting FC Port Speed in sync with FC-GS
      libfc: Make the libfc Common Transport(CT) code generic
      libfc: Add support for FDMI
      fcoe: Add support for FDMI in fcoe
      fcoe: Allow exposing FDMI attributes via sysfs

Robert Love (4):
      libfcoe: Don't KERN_ERR on netdev notification
      fcoe: Rename out_nomod label to out_putmod
      fcoe: Do not switch context in vport_delete callback
      fcoe: Remove reference counting on 'stuct fcoe_interface'


 drivers/scsi/fcoe/fcoe.c           |  159 ++++++++++------
 drivers/scsi/fcoe/fcoe.h           |    3 
 drivers/scsi/fcoe/fcoe_transport.c |    4 
 drivers/scsi/libfc/fc_disc.c       |    7 +
 drivers/scsi/libfc/fc_elsct.c      |    3 
 drivers/scsi/libfc/fc_exch.c       |    7 -
 drivers/scsi/libfc/fc_lport.c      |  227 ++++++++++++++++++++++-
 drivers/scsi/scsi_transport_fc.c   |   30 +++
 include/scsi/fc/fc_ms.h            |  213 +++++++++++++++++++++
 include/scsi/fc_encode.h           |  363 +++++++++++++++++++++++++++++++++++-
 include/scsi/libfc.h               |   11 +
 include/scsi/scsi_transport_fc.h   |   32 +++
 12 files changed, 976 insertions(+), 83 deletions(-)
 create mode 100644 include/scsi/fc/fc_ms.h

-- 
Thanks, //Rob
