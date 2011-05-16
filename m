From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 0/8] libfc, libfcoe and fcoe patches for 2.6.40
Date: Mon, 16 May 2011 16:45:19 -0700
Message-ID: <20110516234519.24502.22027.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:31844 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751052Ab1EPXpT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 May 2011 19:45:19 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

The following series implements a variety of fixes for
libfc, libfcoe and fcoe. There isn't any theme to this
series and the the only noteworthy patch is one that
removes some unnecessary module state checks as it was
discussed a bit on linux-scsi.

These patches were tested against scsi-misc the day of
this posting.

---

Bhanu Prakash Gollapudi (1):
      libfcoe: Incorrect CVL handling for NPIV ports

Hillf Danton (1):
      libfc: fix mm leak in handling incoming request for target discovery

Neerav Parikh (1):
      fcoe: Prevent creation of an NPIV port with duplicate WWPN

Robert Love (1):
      libfcoe: Remove unnecessary module state checks

Vasu Dev (2):
      libfc: don't call resp handler after FC_EX_TIMEOUT
      libfc: fix race in SRR response

Yi Zou (2):
      libfc: release DDP context if frame_send() fails
      libfc: do not immediately retry the cmd when seq_send fails in fc_fcp_send_data


 drivers/scsi/fcoe/fcoe.c           |   58 ++++++++++++++++
 drivers/scsi/fcoe/fcoe.h           |   10 +++
 drivers/scsi/fcoe/fcoe_ctlr.c      |  133 ++++++++++++++++++++++++------------
 drivers/scsi/fcoe/fcoe_transport.c |   40 -----------
 drivers/scsi/libfc/fc_disc.c       |    1 
 drivers/scsi/libfc/fc_exch.c       |    2 +
 drivers/scsi/libfc/fc_fcp.c        |   16 ++--
 drivers/scsi/libfc/fc_libfc.h      |    1 
 8 files changed, 168 insertions(+), 93 deletions(-)

-- 
Thanks, //Rob
