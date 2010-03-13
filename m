From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 00/16] libfc, libfcoe and fcoe fixes for 2.6.34
Date: Fri, 12 Mar 2010 16:07:31 -0800
Message-ID: <20100313000730.22251.54662.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:38226 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932782Ab0CMAHb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Mar 2010 19:07:31 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org

The following series implements a few fixes to libfc, libfcoe and fcoe. The majority
of fixes are to the Point-to-point code, but there are a few other fixes as well.

These patches were applied and tested against 2.6.34-rc1 before submission.

---

Joe Eykholt (12):
      libfc, libfcoe, fcoe: use smp_processor_id() only when preempt disabled
      libfc: fix sequence-initiative WARN in fc_seq_start_next
      libfcoe: eliminate unused link and last_link fields
      fcoe: remove an unused variable in fcoe_recv_frame()
      libfc: send point-to-poin FLOGI LS_ACC to assigned D_DID
      libfc: recognize incoming FLOGI for point-to-point mode
      fcoe: save gateway address when receiving FLOGI request
      libfcoe: fix debug message entering non-FIP mode
      fcoe: call fcoe_ctlr_els_send even for ELS responses
      libfc: fix oops in point-to-point mode
      libfc: add definition for task attribute mask
      libfc: recode incoming PRLI handling

Robert Love (1):
      libfc: Add debug statements when fc_fcp returns DID_ERROR to scsi-ml

Vasu Dev (3):
      libfc: fix fcp pkt recovery in fc_fcp_recv_data
      libfc: use offload EM instance again instead jumping to next EM
      libfc: fixes unnecessary seq id jump


 drivers/scsi/fcoe/fcoe.c      |   82 +++++++++++------
 drivers/scsi/fcoe/libfcoe.c   |   65 ++++++--------
 drivers/scsi/libfc/fc_exch.c  |   39 +++-----
 drivers/scsi/libfc/fc_fcp.c   |   74 +++++++++++-----
 drivers/scsi/libfc/fc_lport.c |   13 ++-
 drivers/scsi/libfc/fc_npiv.c  |    3 +
 drivers/scsi/libfc/fc_rport.c |  195 ++++++++++++++++++-----------------------
 include/scsi/fc/fc_fcp.h      |    1 
 include/scsi/libfc.h          |    9 --
 include/scsi/libfcoe.h        |    8 --
 10 files changed, 243 insertions(+), 246 deletions(-)

-- 
//Rob
