From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 00/64] libfc, libfcoe and fcoe updates for scsi-misc
Date: Tue, 25 Aug 2009 13:58:26 -0700
Message-ID: <20090825205826.1553.94414.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:38970 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752638AbZHYU6Y (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Aug 2009 16:58:24 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org

These patches are targeting the 2.6.32 merge window.

There are three main focuses in this patch series. First,
there are contributions that modify the stack for VLANs
and prepare for NPIV. For both of those technologies resources
need to be shared between VLANs on a physical port or
VN_Ports on an N_Port. Second, there are improvements to
the discovery and remote port layers. Discovery is now much
more graceful (ADISC) and there is a cleaner division between
fc_rports that are used by the FC transport and libfc's
internal remote port tracking structures. Third, there is
a performance optomization for the exchange manager where
per-CPU exchange ID (XID) pools are created so that each CPU
is not contending for a shared lock when trying to acquire a
new XID.

Other than these primary changes there are other smaller
contributions. A user-tunable DDP limit has been added.
There are various improvements to the debug logging macros
and uses of them. FC headers are exported for user space
tools. The fcoe create/destroy path has been improved.

---

Chris Leech (15):
      fcoe: use rtnl mutex in place of hostlist lock
      fcoe: Fix module ref count bug by adding NETDEV UNREGISTER handling
      fcoe: move the host-list add/remove to keep out VN_Ports
      fcoe: add mutex to protect create and destroy
      fcoe: split out per interface setup
      fcoe: fcoe_interface create, destroy and refcounting
      fcoe: remove fcoe_interface->priv pointer
      fcoe: move offload exchange manager pointer from fcoe_port to fcoe_interface
      fcoe: move FIP controller from fcoe_port to fcoe_interface
      fcoe: move packet handlers from fcoe_port to fcoe_interface
      fcoe: move netdev to fcoe_interface
      fcoe: Introduce and allocate fcoe_interface structure, 1:1 with net_device
      fcoe: interface changes to fcoe_if_create and fcoe_if_destroy
      fcoe: fix missing error check in call to fcoe_if_init
      libfcoe: fcoe_ctlr_destroy use cancel_work_sync instead of flush_work

Joe Eykholt (41):
      fcoe: flush per-cpu thread work when destroying interface
      libfc: don't swap OX_ID and RX_ID when sending BA_RJT
      libfc: send GPN_ID in reaction to single-port RSCNs.
      libfc: fix handling of incoming Discover Address (ADISC) requests
      libfc: use ADISC to verify rport login state
      libfc: LOGO response code had extraeous enter_rtv
      libfc: re-login to remote ports that send us LOGO
      libfc: fix rport error handling for login-required and invalid ops
      libfc: correctly handle incoming PLOGI request.
      libfc: improve debug messages for ELS response handlers
      libfc: fix: rport_recv_req needs disc_mutex when calling rport_lookup
      libfc: move remote port lookup for ELS requests into fc_rport.c.
      libfc: don't do discovery before callback is set
      libfc: clean up point-to-point discovery code.
      libfc: discovery gpn_ft parse bug
      libfc: discovery retry should clear pending first.
      libfc: fix: empty zone causes endless discovery retries.
      libfc: handle discovery failure more correctly.
      libfc: rearrange code in fc_disc_gpn_ft_resp()
      libfc: discovery restart sequence error fix
      libfc: do not log off rports before or after discovery
      libfc: move rport_lookup into fc_rport.c
      libfc: change to make remote port callback optional
      libfc: have rport_create do a lookup for pre-existing rports first
      libfc: make rport module maintain the rport list
      libfc: simplify fc_lport_rport_callback
      libfc: rport debug messages were printing pointer values
      libfc: remove unused disc->delay element
      libfc: eliminate disc->event
      libfc: fix rport event race between READY and LOGO
      libfc: don't create dummy (rogue) remote ports
      libfc: rename rport event CREATED to READY
      libfc: rearrange code in fc_rport_work
      libfc: make rport structure optional
      libfc: change elsct to use FC_ID instead of rdata
      libfc: make fc_rport_priv the primary rport interface.
      libfc: fix RPORT_TO_PRIV and PRIV_TO_RPORT() macros.
      libfc: change interface for rport_create
      libfc: prepare to split off struct fc_rport_priv from fc_rport_libfc_priv
      fcoe: remove unnecessary list and lock initializations.
      fcoe: libfcoe: extra semicolon in CHECK_LOGGING macros causes compile error

Robert Love (5):
      libfc: Always reset remote port roles when receiving PRLI
      libfc: Initialize fc_rport_identifiers inside fc_rport_create
      libfc: Export FC headers
      libfc: Fix misleading debug statement
      fcoe: Add format spacing to FCOE_NETDEV_DBG debug macro

Vasu Dev (2):
      fcoe, libfc: fully makes use of per cpu exch pool and then removes em_lock
      fcoe, libfc: adds per cpu exch pool within exchange manager(EM)

Yi Zou (1):
      fcoe: Add sysfs parameter to fcoe for minimum DDP read I/O size


 drivers/scsi/fcoe/fcoe.c      |  948 ++++++++++++++++++++----------------
 drivers/scsi/fcoe/fcoe.h      |   32 +
 drivers/scsi/fcoe/libfcoe.c   |   10 
 drivers/scsi/libfc/fc_disc.c  |  523 ++++++++------------
 drivers/scsi/libfc/fc_elsct.c |   49 ++
 drivers/scsi/libfc/fc_exch.c  |  286 +++++++----
 drivers/scsi/libfc/fc_fcp.c   |    2 
 drivers/scsi/libfc/fc_lport.c |  222 ++------
 drivers/scsi/libfc/fc_rport.c | 1091 +++++++++++++++++++++++++----------------
 include/scsi/Kbuild           |    1 
 include/scsi/fc/Kbuild        |    4 
 include/scsi/fc/fc_gs.h       |    1 
 include/scsi/fc_encode.h      |   60 ++
 include/scsi/libfc.h          |  122 +++--
 14 files changed, 1824 insertions(+), 1527 deletions(-)
 create mode 100644 include/scsi/fc/Kbuild

-- 
//Rob
