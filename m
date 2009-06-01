From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 0/6] Open-FCoE Features for 2.6.31
Date: Mon, 01 Jun 2009 10:49:48 -0700
Message-ID: <20090601174948.12911.35446.stgit@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:20293 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750776AbZFARtq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 1 Jun 2009 13:49:46 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org

The following series consists of logging improvements, watchdog and locking
optimizations and the move of the FIP protocol definition to a more appropriate
header file.

These patches apply to scsi-misc-post-merge with net-next-2.6 merged in. Some
fcoe/ code was touched by a net-next change (storage MAC address addition and
usage) and since the logging changes touch so many lines it created this
dependency.

These patches may or may not depend on the other five outstanding Open-FCoE
fixes as discussed on linux-scsi. Those five patches were in the tree that
this code was tested on before this submission.

---

Robert Love (4):
      libfc: Add runtime debugging with debug_logging module parameter
      libfcoe: Add runtime debugging with module param debug_logging
      fcoe: Add runtime debug logging with module parameter debug_logging
      net, libfcoe: Add the FCoE Initialization Protocol ethertype

Vasu Dev (2):
      fcoe: removes fcoe_watchdog
      fcoe: reduces lock cost when adding a new skb to fcoe_pending_queue


 drivers/scsi/fcoe/fcoe.c      |  195 ++++++++++++++++++-----------------------
 drivers/scsi/fcoe/fcoe.h      |   25 +++++
 drivers/scsi/fcoe/libfcoe.c   |   94 +++++++++++---------
 drivers/scsi/libfc/fc_disc.c  |   83 +++++++----------
 drivers/scsi/libfc/fc_exch.c  |   58 +++++-------
 drivers/scsi/libfc/fc_fcp.c   |   97 +++++++++++---------
 drivers/scsi/libfc/fc_lport.c |  156 ++++++++++++++++-----------------
 drivers/scsi/libfc/fc_rport.c |  120 +++++++++++--------------
 include/linux/if_ether.h      |    1 
 include/scsi/fc/fc_fip.h      |    7 -
 include/scsi/fc_encode.h      |    2 
 include/scsi/libfc.h          |   77 ++++++++++++++--
 12 files changed, 466 insertions(+), 449 deletions(-)

-- 

//Rob
