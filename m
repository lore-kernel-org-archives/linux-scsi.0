From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 00/28] libfc/libfcoe/fcoe updates for scsi-misc (2.6.39)
Date: Fri, 28 Jan 2011 16:03:10 -0800
Message-ID: <20110129000310.1784.58748.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:8747 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753258Ab1A2ADO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 Jan 2011 19:03:14 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org

This is a fairly significant update to libfc, libfcoe and fcoe.
The two major changes are the addition hooks for a FC/FCoE target
based on the new target infrastructure and the addition of a fcoe
transport which will allow the upcoming bnx2fc driver to work
with libfc and libfcoe.

1) fc4 provider hooks

   These changes have been around for months and allow libfc to
respond (as a target) to commands sent from an initiator. There
are also a few small changes here and there to libfc to make a
target mode work. This changeset paves the way for TCM_FC which
will bridge the TCM core with libfc/fcoe.

2) fcoe transport

   libfcoe.c has now been split out into two new files:
fcoe_transport.c and fcoe_ctlr.c. fcoe_transport.c implements
a registration system for fcoe transports. The first transport
is SW FCoE (i.e. fcoe.ko), the second will be bnx2fc (a brdcm
fcoe driver). Any fcoe transport will simply provide a match
function to determine if a netdevice is managed by the transport.
fcoe.ko is the default and will be used if no other transport
is available.

   One interesting outcome of this is that the create/destroy/etc...
entry points are moving from fcoe.ko to libfcoe.ko. There are
corresponding changes to fcoe-utils (fcoe user space suite), but
I don't intend to commit them until all of this code is accepted
to mainline. fcoe-utils is tagged against mainline.

3) Miscellaneous

   a) Removal of scsi_host lock usage in fc_queuecommand
   b) rport event callback to LLD from libfc (will be used by
      bnx2fc)
   c) Tejun Heo's workqueue change
   d) Memory leak fix and version bump to fnic

All of these patches have been tested against today's scsi-misc.

---

Bhanu Prakash Gollapudi (2):
      libfc: introduce LLD event callback
      libfcoe: Move common code from fcoe to libfcoe module

Dan Carpenter (1):
      libfc: dereferencing ERR_PTR in fc_tm_done()

Hillf Danton (2):
      libfc: Return a valid return code in fc_fcp_pkt_abort()
      libfc: Cleanup return paths in fc_rport_error_retry

Joe Eykholt (6):
      libfc: add hook for FC-4 provider registration
      libfc: add method for setting handler for incoming exchange
      libfc: add local port hook for provider session lookup
      libfc: add hook to notify providers of local port changes
      libfc: use PRLI hook to get parameters when sending outgoing PRLI
      libfc: export seq_release() for users of seq_assign()

Kiran Patil (2):
      libfc: Enhanced exchange ID selection mechanism and fix related EMA selection logic.
      libfc: Extending lport's roles for target if there is a registered target.

Randy Dunlap (1):
      libfc: fix sparse static and non-ANSI warnings

Robert Love (2):
      fcoe: Fix module reference count for vports
      libfc: Remove usage of the Scsi_Host's host_lock

Tejun Heo (1):
      fcoe: use dedicated workqueue instead of system_wq

Vasu Dev (1):
      fcoe: drop FCoE LOGO in FIP mode

Venkata Siva Vijayendra Bhamidipati (2):
      fnic: fix memory leak
      fnic: Bumping up fnic version from 1.4.0.145 to 1.5.0.1.

Yi Zou (8):
      libfc: always initialize the FCoE DDP exchange id for fsp as FC_XID_UNKNOWN
      libfcoe: move logging macros into the local libfcoe.h header file
      libfcoe: add fcoe_transport structure defines to include/scsi/libfcoe.h
      libfcoe: add implementation to support fcoe transport
      libfcoe: rename libfcoe.c to fcoe_cltr.c for the coming fcoe_transport.c
      libfcoe: include fcoe_transport.c into kernel libfcoe module
      fcoe: prepare fcoe for using fcoe transport
      fcoe: convert fcoe.ko to become an fcoe transport provider driver


 drivers/scsi/fcoe/Makefile         |    2 
 drivers/scsi/fcoe/fcoe.c           |  563 +++----
 drivers/scsi/fcoe/fcoe.h           |   44 -
 drivers/scsi/fcoe/fcoe_ctlr.c      | 2682 ++++++++++++++++++++++++++++++++++++
 drivers/scsi/fcoe/fcoe_transport.c |  726 ++++++++++
 drivers/scsi/fcoe/libfcoe.c        | 2708 ------------------------------------
 drivers/scsi/fcoe/libfcoe.h        |   31 
 drivers/scsi/fnic/fnic.h           |    2 
 drivers/scsi/fnic/vnic_dev.c       |    2 
 drivers/scsi/libfc/fc_exch.c       |  103 +
 drivers/scsi/libfc/fc_fcp.c        |   39 -
 drivers/scsi/libfc/fc_libfc.c      |  120 ++
 drivers/scsi/libfc/fc_libfc.h      |   14 
 drivers/scsi/libfc/fc_lport.c      |   68 +
 drivers/scsi/libfc/fc_npiv.c       |    1 
 drivers/scsi/libfc/fc_rport.c      |  190 ++-
 include/scsi/libfc.h               |   74 +
 include/scsi/libfcoe.h             |   99 +
 18 files changed, 4252 insertions(+), 3216 deletions(-)
 create mode 100644 drivers/scsi/fcoe/fcoe_ctlr.c
 create mode 100644 drivers/scsi/fcoe/fcoe_transport.c
 delete mode 100644 drivers/scsi/fcoe/libfcoe.c
 create mode 100644 drivers/scsi/fcoe/libfcoe.h

-- 
Thanks, //Rob

 LocalWords:  shortlog diffstat
