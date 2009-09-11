From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 00/35] libfc, libfcoe and fcoe updates for 2.6.32
Date: Fri, 11 Sep 2009 16:56:55 -0700
Message-ID: <20090911235655.27223.69728.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:36273 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753850AbZIKX4w (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Sep 2009 19:56:52 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org

The following series implements a variety of features and fixes
for the 2.6.32 kernel. At a high level they are the following-

1) NPIV support

2) Symbolic name registration with the fabric

3) libfc FC passthrough support

4) Style and comment improvements

5) can_queue adjustments for frame allocation failures

6) Variety of minor improvements and bug fixes

These patches were built on scsi-misc.git rebased to the current
linux-2.6. As well as on top of Vasu Dev's queue depth patch set.

---

Chris Leech (15):
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
      libfc, fcoe: fixes for highmem skb linearize panics

Joe Eykholt (1):
      libfc: fix typo in retry check on received PRLI

Robert Love (12):
      fcoe: Formatting cleanups and commenting
      libfcoe: formatting and comment cleanups
      libfc: Formatting cleanups across libfc
      libfc: Remove unused fc_lport pointer from fc_fcp_pkt_abort
      libfc, fcoe: Don't EXPORT_SYMBOLS unnecessarily
      libfc: Add routine to copy data from a buffer to a SG list
      libfc: Export FC headers
      libfc: Move libfc_init and libfc_exit to fc_libfc.c
      libfc: Add libfc/fc_libfc.[ch] for libfc internal routines
      libfc: Remove fc_fcp_complete
      libfc: Move non-common routines and prototypes out of libfc.h
      fcoe: Increase FCOE_MAX_LUN to 0xFFFF (65535)

Steve Ma (1):
      libfc, fcoe: Add FC passthrough support

Vasu Dev (3):
      libfc: adds can_queue ramp up
      libfc: reduce can_queue for all FCP frame allocation failures
      fcoe, libfc: use single frame allocation API

Yi Zou (3):
      libfc: Fix wrong scsi return status under FC_DATA_UNDRUN
      fcoe: remove redundant checking of netdev->netdev_ops
      libfc: fix ddp in fc_fcp for 0 xid


 drivers/scsi/fcoe/fcoe.c      | 1073 ++++++++++++++++++++++++++-------------
 drivers/scsi/fcoe/fcoe.h      |   76 ++-
 drivers/scsi/fcoe/libfcoe.c   |  288 ++++++----
 drivers/scsi/fnic/fnic_main.c |   10 
 drivers/scsi/libfc/Makefile   |    4 
 drivers/scsi/libfc/fc_disc.c  |   80 +--
 drivers/scsi/libfc/fc_elsct.c |   34 +
 drivers/scsi/libfc/fc_exch.c  |  892 +++++++++++++++++++++-----------
 drivers/scsi/libfc/fc_fcp.c   |  988 +++++++++++++++++++-----------------
 drivers/scsi/libfc/fc_frame.c |   13 
 drivers/scsi/libfc/fc_libfc.c |  134 +++++
 drivers/scsi/libfc/fc_libfc.h |  112 ++++
 drivers/scsi/libfc/fc_lport.c |  757 +++++++++++++++++++--------
 drivers/scsi/libfc/fc_npiv.c  |  161 ++++++
 drivers/scsi/libfc/fc_rport.c |  243 +++++----
 include/scsi/Kbuild           |    1 
 include/scsi/fc/Kbuild        |    4 
 include/scsi/fc/fc_els.h      |    6 
 include/scsi/fc/fc_fs.h       |    2 
 include/scsi/fc/fc_gs.h       |    2 
 include/scsi/fc/fc_ns.h       |   22 +
 include/scsi/fc_encode.h      |   54 ++
 include/scsi/fc_frame.h       |   19 -
 include/scsi/libfc.h          | 1131 +++++++++++++++++++----------------------
 include/scsi/libfcoe.h        |   89 ++-
 25 files changed, 3851 insertions(+), 2344 deletions(-)
 create mode 100644 drivers/scsi/libfc/fc_libfc.c
 create mode 100644 drivers/scsi/libfc/fc_libfc.h
 create mode 100644 drivers/scsi/libfc/fc_npiv.c
 create mode 100644 include/scsi/fc/Kbuild

-- 
//Rob
