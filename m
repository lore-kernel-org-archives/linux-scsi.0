From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 00/27] libfc, libfcoe and fcoe updates for 2.6.38
Date: Tue, 30 Nov 2010 16:17:56 -0800
Message-ID: <20101201001756.18369.7107.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:6548 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752132Ab0LAAR5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Nov 2010 19:17:57 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org

The following series contains a variety of fixes to
libfc, libfcoe and fcoe for the 2.6.38 merge window.

The "drivers/scsi/fcoe: Update WARN uses" patch was
pulled in from another series submitted to linux-scsi.

---

Hillf Danton (8):
      libfc: remove define of fc_seq_exch in fc_exch.c
      libfc: fix mem leak in fc_exch_recv_seq_resp()
      libfc: tune fc_exch_em_alloc() to be O(2)
      libfc: fix mem leak in fc_seq_assign()
      libfc: fix stats computation in fc_queuecommand()
      libfc: fix memory leakage in local port
      libfc: fix memory leakage in local port
      libfc: fix memory leakage in remote port

Joe Eykholt (8):
      libfcoe: update FIP FCF announcements
      libfcoe: move some timer code to make it reusable.
      libfcoe: fix checking of conflicting fabrics in fcoe_ctlr_select()
      libfcoe: retry rejected FLOGI to another FCF if possible
      libfcoe: add debug message for FCF destination MAC
      libfcoe: reorder FCF list to put latest advertiser first
      libfcoe: change fip_select to return new FCF
      libfc: fix statistics for FCP input/output megabytes

Joe Perches (1):
      drivers/scsi/fcoe: Update WARN uses

Robert Love (1):
      libfc: Fix incorrect locking and unlocking in FCP

Yi Zou (6):
      libfc: fix NULL pointer dereference bug in fc_fcp_pkt_release
      libfc: add print of exchange id for debugging fc_fcp
      libfc: do not fc_io_compl on fsp w/o any scsi_cmnd associated
      libfc: fix exchange being deleted when the abort itself is timed out
      libfc: the timeout for the REC itself is 2 * R_A_TOV_els
      libfc: fix fc_tm_done not freeing the allocated fsp pkt

john fastabend (3):
      libfc: incorrect scsi host byte codes returned to scsi-ml
      libfc: use rport timeout values for fcp recovery
      libfc: remove tgt_flags from fc_fcp_pkt struct


 drivers/scsi/fcoe/fcoe.c      |    4 -
 drivers/scsi/fcoe/libfcoe.c   |  300 +++++++++++++++++++++++++++++++++--------
 drivers/scsi/libfc/fc_exch.c  |   48 +++++--
 drivers/scsi/libfc/fc_fcp.c   |  147 +++++++++++++-------
 drivers/scsi/libfc/fc_libfc.h |   16 ++
 drivers/scsi/libfc/fc_lport.c |   16 ++
 drivers/scsi/libfc/fc_rport.c |    3 
 include/scsi/libfc.h          |   10 +
 include/scsi/libfcoe.h        |    8 +
 9 files changed, 422 insertions(+), 130 deletions(-)

-- 
Thanks, //Rob
