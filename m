From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 00/15] Open-FCoE updates (fixes and a feature) for 2.6.30
	merge window
Date: Fri, 03 Apr 2009 14:57:58 -0700
Message-ID: <20090403215758.10856.6946.stgit@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:28608 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761611AbZDCV6A (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 3 Apr 2009 17:58:00 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org

The following series implements some bug fixes to libfc
and the addition of dynamic logging capabilities for libfc,
libfcoe and fcoe.

The bug fixes are mostly related to the rogue rport
tracking that libfc does before getting a "real"
rport from the FC transport. Also there are locking
and state verification fixes.

The dynamic logging code was originally mailed to
linux-scsi during the 2.6.29 rc phase, but was
incorrectly mixed in with fixes. This is a refresh
of that patch set. Since that original patch set
libfcoe and fcoe have been better distinguished as
separate modules, so this patch set was modified to
reflect that change.

---

Abhijeet Joglekar (6):
      libfc: whenever queueing delete ev for rport, set state to NONE
      libfc: Change state to NONE in fc_lport_destroy
      libfc: During fabric logoff, flush the rport Q after logging off dns port
      libfc: Track rogue remote ports
      libfc: Do not retry if the new state is not the same as old state
      libfc: Hold disc mutex while processing gpn ft resp

Robert Love (9):
      libfc: Remove unused FC_DBG macro
      libfc: Convert debug statements in fc_exch.c to use new libfc debug macros.
      libfc: Convert debug statements in fc_fcp.c to use new libfc debug macros.
      libfc: Convert debug statements in fc_rport.c to use new libfc debug macros.
      libfc: Convert debug statements in fc_disc.c to use new libfc debug macros.
      libfc: Convert debug statements in fc_lport.c to use new libfc debug macros.
      libfc: Add runtime debugging with debug_logging module parameter
      libfcoe: Add runtime debugging with module param debug_logging
      fcoe: Add runtime debug logging with module parameter debug_logging


 drivers/scsi/fcoe/fcoe.c      |  108 ++++++++++----------
 drivers/scsi/fcoe/fcoe.h      |   24 ++++
 drivers/scsi/fcoe/libfcoe.c   |   94 ++++++++++--------
 drivers/scsi/libfc/fc_disc.c  |  137 ++++++++++++++------------
 drivers/scsi/libfc/fc_exch.c  |   58 +++++------
 drivers/scsi/libfc/fc_fcp.c   |   97 +++++++++---------
 drivers/scsi/libfc/fc_lport.c |  220 +++++++++++++++++++++--------------------
 drivers/scsi/libfc/fc_rport.c |  184 +++++++++++++++++++---------------
 include/scsi/fc_encode.h      |    2 
 include/scsi/libfc.h          |   78 ++++++++++++---
 10 files changed, 565 insertions(+), 437 deletions(-)

-- 
//Rob
