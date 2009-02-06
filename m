From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 00/17] Open-FCoE Updates
Date: Fri, 06 Feb 2009 10:55:49 -0800
Message-ID: <20090206185548.26188.51580.stgit@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:24027 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750945AbZBFSzt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 6 Feb 2009 13:55:49 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org

The following series implements bug fixes, adds a module param for runtime debug logging and cleans up some coding style issues. The top patch is a patch that was posted to linux-scsi on 01/04, but doesn't seem to have made it in yet.

This patch set is based on Linus' tree + the Open-FCoE patches submitted to linux-scsi on 01/21.

---

Robert Love (14):
      fcoe: Correct fcoe_transports initialization vs. registration
      fcoe: Use setup_timer() and mod_timer()
      libfc, fcoe: Remove unnecessary cast by removing inline wrapper
      libfc, fcoe: Cleanup function formatting and minor typos
      libfc, fcoe: Fix kerneldoc comments
      libfc: Cleanup libfc_function_template comments
      libfc: Logging review changes
      libfc: runtime debugging with debug_logging module parameter
      fcoe: Logging review changes
      fcoe: runtime debugging with debug_logging module parameter
      libfc: check for err when recv and state is incorrect
      libfc: rename rp to rdata in fc_disc_new_target()
      libfc: correct RPORT_TO_PRIV usage
      libfc: Don't violate transport template for rogue port creation

Roel Kluin (1):
      [SCSI] fcoe: fix kfree(skb)

Steve Ma (1):
      fcoe: exch mgr is freed while lport still retrying sequences

Vasu Dev (1):
      libfc: fixed a read IO data integrity issue when a IO data frame lost


 drivers/scsi/fcoe/fc_transport_fcoe.c |  174 ++++++++++-----------
 drivers/scsi/fcoe/fcoe.h              |   31 ++++
 drivers/scsi/fcoe/fcoe_sw.c           |   70 ++++----
 drivers/scsi/fcoe/libfcoe.c           |  267 ++++++++++++++++----------------
 drivers/scsi/libfc/fc_disc.c          |  154 +++++++++---------
 drivers/scsi/libfc/fc_exch.c          |   62 +++----
 drivers/scsi/libfc/fc_fcp.c           |  139 ++++++++---------
 drivers/scsi/libfc/fc_lport.c         |  278 ++++++++++++++++-----------------
 drivers/scsi/libfc/fc_rport.c         |  197 +++++++++++------------
 include/scsi/fc_encode.h              |    2 
 include/scsi/libfc.h                  |  167 +++++++++++++-------
 include/scsi/libfcoe.h                |    8 -
 12 files changed, 793 insertions(+), 756 deletions(-)
 create mode 100644 drivers/scsi/fcoe/fcoe.h

-- 
//Rob
