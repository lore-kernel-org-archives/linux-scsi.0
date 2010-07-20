From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 00/28] libfc, libfcoe and fcoe updates for scsi-misc
Date: Tue, 20 Jul 2010 15:19:05 -0700
Message-ID: <20100720221904.17116.78553.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:22880 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758626Ab0GTWTF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Jul 2010 18:19:05 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org

The following series implements multiple bug fixes, FCoE VN2VN
mode and a VLAN ID patch revert.

VN2VN is a point-to-multipoint FCoE mode. It allows direct
connections from the initiator to VN2VN capable FCoE targets.

The VLAN ID revert removes the VLAN ID from the generated WWPN.
Adding the VLAN ID to the WWPN is not typical and can cause
zoning issues in a variety of scenarios. Note that this change
will cause a one time rezone for the new WWPN.

Please apply these patches to scsi-misc.

---

Bart Van Assche (1):
      fcoe: make it possible to verify fcoe with sparse

Bhanu Prakash Gollapudi (1):
      libfc: Add retry logic to lport state machine when receiving LS_RJT

Joe Eykholt (19):
      libfc: convert rport lookup to be RCU safe
      libfc: provide space for LLD after remote port structure
      libfcoe: convert FIP to lock with mutex instead of spin lock
      libfc: add discovery-private pointer for LLD
      libfcoe: fcoe: fnic: change fcoe_ctlr_init interface to specify mode
      libfc: Add local port point-to-multipoint flag
      libfc: add FLOGI state to rport for VN2VN
      libfc: track FIP exchanges
      libfcoe: add protocol description of FIP VN2VN mode
      libfcoe: add state change debugging
      libfcoe: fcoe: fnic: add FIP VN2VN point-to-multipoint support
      libfcoe: Fix FIP ELS encapsulation details for FLOGI responses
      fcoe libfcoe: use correct FC-MAP for VN2VN mode
      fcoe: config via separate create_vn2vn module parameter
      libfc: eliminate rport LOGO state
      libfc: add fc_frame_sid() and fc_frame_did() functions
      libfc: add fc_fill_reply_hdr() and fc_fill_hdr()
      libfc: add interface to allocate a sequence for incoming requests
      libfc: don't require a local exchange for incoming requests

Vasu Dev (5):
      libfc: IO errors on link down due to cable unplug
      fcoe: cleans up fcoe_disable and fcoe_enable
      fcoe: adds src and dest mac address checking for fcoe frames
      Revert "[SCSI] fcoe: Fix using VLAN ID in creating lport's WWWN/WWPN"
      fcoe: remove check for zero fabric name

Yi Zou (2):
      libfc: fix slowpath error from WARN_ON in fc_fcp_send_data
      fcoe: fix offload feature flag change from netdev


 drivers/scsi/fcoe/fcoe.c      |  147 +++--
 drivers/scsi/fcoe/libfcoe.c   | 1306 ++++++++++++++++++++++++++++++++++++-----
 drivers/scsi/fnic/fnic_main.c |   11 
 drivers/scsi/libfc/fc_disc.c  |   39 +
 drivers/scsi/libfc/fc_elsct.c |    2 
 drivers/scsi/libfc/fc_exch.c  |  215 ++++---
 drivers/scsi/libfc/fc_fcp.c   |   13 
 drivers/scsi/libfc/fc_libfc.c |   78 ++
 drivers/scsi/libfc/fc_libfc.h |    2 
 drivers/scsi/libfc/fc_lport.c |  210 +++----
 drivers/scsi/libfc/fc_rport.c |  564 +++++++++++-------
 include/scsi/fc/fc_els.h      |    2 
 include/scsi/fc/fc_fip.h      |   46 +
 include/scsi/fc/fc_ns.h       |    7 
 include/scsi/fc_encode.h      |    7 
 include/scsi/fc_frame.h       |   52 ++
 include/scsi/libfc.h          |   68 +-
 include/scsi/libfcoe.h        |   72 ++
 18 files changed, 2157 insertions(+), 684 deletions(-)

-- 
Thanks, //Rob
