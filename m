From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 00/54] libfc, libfcoe, fcoe and fnic updates for 2.6.33
Date: Tue, 03 Nov 2009 11:45:31 -0800
Message-ID: <20091103194530.4085.37963.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:40643 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754395AbZKCTp0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 3 Nov 2009 14:45:26 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org

The following series implements a few features and fixes.
Most of these patches have been published to linux-scsi
before.

The main features in the set are NPIV support and FC
Passthrough support.

---

Abhijeet Joglekar (1):
      fnic: Allocate OS interrupt resources just before enabling interrupts

Chris Leech (15):
      libfc, fcoe: fixes for highmem skb linearize panics
      fcoe: vport symbolic name support
      libfc: combine name server registration request functions
      libfc: combine name server registration response handlers
      libfc: Register Symbolic Port Name (RSPN_ID)
      libfc: Register Symbolic Node Name (RSNN_NN)
      libfc: RNN_ID may be required before RSNN_NN with some switches
      libfc: RPN_ID is obsolete and unnecessary
      fcoe: NPIV vport create/destroy
      fcoe: add a separate scsi transport template for NPIV vports
      libfcoe, fcoe: libfcoe NPIV support
      libfc, libfcoe: FDISC ELS for NPIV
      libfc: vport link handling and fc_vport state managment
      libfc: add some generic NPIV support routines to libfc
      libfc: changes to libfc_host_alloc to consolidate initialization with allocation

Joe Eykholt (15):
      libfc fcoe: increase ELS and CT timeouts
      fnic: enable bsg pass-thru for fcping
      libfc: register FC4 features with the FC switch
      fnic: Add FIP support to the fnic driver
      libfcoe: fcoe: simplify receive FLOGI response
      libfc: add host number to lport link up/down messages.
      libfc: add set_fid function to libfc template
      libfc: fix fc_els_resp_type to correct display of CT responses
      libfc: fix symbolic name registrations smashing skb data
      libfc: fix RNN_ID smashing skb payload
      libfcoe: don't send ELS in FIP mode if no FCF selected
      libfcoe: FIP should report link to libfc whether selected or not
      libfcoe: fip: allow FIP receive to be called from IRQ.
      libfcoe: fip: use SCSI host number to identify debug messages.
      libfcoe: Allow FIP to be disabled by the driver

Mike Christie (1):
      libfc: do not use DID_NO_CONNECT for pkt alloc failures.

Robert Love (10):
      fcoe: Formatting cleanups and commenting
      libfcoe: formatting and comment cleanups
      libfc: Formatting cleanups across libfc
      libfc: Add routine to copy data from a buffer to a SG list
      libfc: Export FC headers
      libfc: Move libfc_init and libfc_exit to fc_libfc.c
      libfc: Add libfc/fc_libfc.[ch] for libfc internal routines
      libfc: Remove fc_fcp_complete
      libfc: Move non-common routines and prototypes out of libfc.h
      fcoe: Increase FCOE_MAX_LUN to 0xFFFF (65535)

Steve Ma (1):
      libfc, fcoe: Add FC passthrough support

Vasu Dev (4):
      libfc: fix an issue of pending exch/es after i/f destroyed or rmmod fcoe
      libfc: adds can_queue ramp up
      libfc: reduce can_queue for all FCP frame allocation failures
      fcoe, libfc: use single frame allocation API

Yi Zou (6):
      libfcoe: Do not pad FIP keep-alive to full frame size
      fcoe: Fix using VLAN ID in creating lport's WWWN/WWPN
      fcoe: Fix setting lport's WWNN/WWPN to use san mac address
      fcoe: Fix getting san mac for VLAN interface
      fcoe: Fix checking san mac address
      fcoe: remove extra function decalrations

john fastabend (1):
      fcoe: add check to fail gracefully in bonding mode


 drivers/scsi/Kconfig          |    2 
 drivers/scsi/fcoe/fcoe.c      | 1087 ++++++++++++++++++++++++++-------------
 drivers/scsi/fcoe/fcoe.h      |   76 ++-
 drivers/scsi/fcoe/libfcoe.c   |  413 ++++++++-------
 drivers/scsi/fnic/fnic.h      |   23 +
 drivers/scsi/fnic/fnic_fcs.c  |  499 +++++++++---------
 drivers/scsi/fnic/fnic_main.c |  103 ++--
 drivers/scsi/fnic/fnic_res.c  |    5 
 drivers/scsi/fnic/fnic_res.h  |   50 ++
 drivers/scsi/fnic/fnic_scsi.c |   73 +--
 drivers/scsi/fnic/vnic_scsi.h |    1 
 drivers/scsi/libfc/Makefile   |    4 
 drivers/scsi/libfc/fc_disc.c  |   83 ++-
 drivers/scsi/libfc/fc_elsct.c |   75 ++-
 drivers/scsi/libfc/fc_exch.c  |  899 +++++++++++++++++++++-----------
 drivers/scsi/libfc/fc_fcp.c   |  975 +++++++++++++++++++----------------
 drivers/scsi/libfc/fc_frame.c |   12 
 drivers/scsi/libfc/fc_libfc.c |  134 +++++
 drivers/scsi/libfc/fc_libfc.h |  112 ++++
 drivers/scsi/libfc/fc_lport.c |  823 +++++++++++++++++++++--------
 drivers/scsi/libfc/fc_npiv.c  |  161 ++++++
 drivers/scsi/libfc/fc_rport.c |  250 +++++----
 include/scsi/Kbuild           |    1 
 include/scsi/fc/Kbuild        |    4 
 include/scsi/fc/fc_els.h      |    6 
 include/scsi/fc/fc_fcp.h      |    6 
 include/scsi/fc/fc_fs.h       |    2 
 include/scsi/fc/fc_gs.h       |    2 
 include/scsi/fc/fc_ns.h       |   35 +
 include/scsi/fc_encode.h      |   68 ++
 include/scsi/fc_frame.h       |   19 -
 include/scsi/libfc.h          | 1148 ++++++++++++++++++++---------------------
 include/scsi/libfcoe.h        |   92 ++-
 33 files changed, 4457 insertions(+), 2786 deletions(-)
 create mode 100644 drivers/scsi/libfc/fc_libfc.c
 create mode 100644 drivers/scsi/libfc/fc_libfc.h
 create mode 100644 drivers/scsi/libfc/fc_npiv.c
 create mode 100644 include/scsi/fc/Kbuild

-- 
//Rob
