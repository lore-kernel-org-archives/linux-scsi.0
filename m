From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 00/24] libfc, libfcoe, fcoe and fnic updates for 2.6.32
Date: Fri, 18 Sep 2009 15:48:48 -0700
Message-ID: <20090918224847.5928.52092.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:21295 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751499AbZIRWso (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Sep 2009 18:48:44 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org

The following series implements the following changes-

1) Use of FCoE netdev changes
   - Use of the FCoE MTU and FCoE enable/disable functionality
     in netdev. The dependency for these patches was recently
     merged into mainline through net-next so there is no need
     for a post-merge tree.

2) New callback from libfc to LLDs
   - Callback when the FCID on a local port is changed. This
     allows LLDs (fcoe and fnic) to gather the FCID, timeout
     values and assigned MAC address.

3) FIP support for fnic
   - Adds support for FCoE Initialization Protocol to the
     fnic driver.

4) Miscellaneous fixes and improvements...

5) Update MAINTAINERS file.

These patches are built on scsi-misc.git + Vasu's queue_depth
patches submitted to linux-scsi + the 35 previously submitted
libfc, libfcoe and fcoe patches that have not yet been committed
to scsi-misc.

---

Joe Eykholt (15):
      libfc: register FC4 features with the FC switch
      fnic: Add FIP support to the fnic driver
      libfcoe: fcoe: simplify receive FLOGI response
      libfc: add host number to lport link up/down messages.
      libfc: add set_fid function to libfc template
      libfc: fix fc_els_resp_type to correct display of CT responses
      libfc: fix symbolic name registrations smashing skb data
      libfc: fix RNN_ID smashing skb payload
      libfcoe: don't send ELS in FIP mode if no FCF selected
      libfc: don't WARN_ON in lport_timeout for RESET state
      libfcoe: FIP should report link to libfc whether selected or not
      libfcoe: fip: allow FIP receive to be called from IRQ.
      libfcoe: fip: use SCSI host number to identify debug messages.
      libfcoe: Allow FIP to be disabled by the driver
      libfc: lport: fix minor documentation errors

Mike Christie (1):
      fcoe: initialize return value in fcoe_destroy

Robert Love (1):
      MAINTAINERS: Update for libfc, libfcoe, fcoe

Vasu Dev (3):
      libfc: removes unused disc_work and ex_list
      libfc: adds missing exch release for accepted RRQ
      libfc: removes initializing fc_cpu_order and fc_cpu_mask per lport

Yi Zou (3):
      fcoe: Call ndo_fcoe_enable/disable to turn FCoE feature on/off in LLD
      fcoe: Use NETIF_F_FCOE_MTU flag to set up max frame size (lport->mfs)
      fcoe: remove extra function decalrations

john fastabend (1):
      fcoe: add check to fail gracefully in bonding mode


 MAINTAINERS                   |   11 +
 drivers/scsi/Kconfig          |    2 
 drivers/scsi/fcoe/fcoe.c      |   58 +++--
 drivers/scsi/fcoe/fcoe.h      |    6 
 drivers/scsi/fcoe/libfcoe.c   |  142 ++++++------
 drivers/scsi/fnic/fnic.h      |   23 +-
 drivers/scsi/fnic/fnic_fcs.c  |  499 ++++++++++++++++++++---------------------
 drivers/scsi/fnic/fnic_main.c |   71 +++---
 drivers/scsi/fnic/fnic_res.c  |    5 
 drivers/scsi/fnic/fnic_res.h  |   50 ++++
 drivers/scsi/fnic/fnic_scsi.c |   73 +++---
 drivers/scsi/fnic/vnic_scsi.h |    1 
 drivers/scsi/libfc/fc_elsct.c |   41 +++
 drivers/scsi/libfc/fc_exch.c  |   37 ++-
 drivers/scsi/libfc/fc_lport.c |   89 +++++--
 include/scsi/fc/fc_fcp.h      |    6 
 include/scsi/fc/fc_ns.h       |   13 +
 include/scsi/fc_encode.h      |   30 ++
 include/scsi/libfc.h          |   23 ++
 include/scsi/libfcoe.h        |    5 
 20 files changed, 693 insertions(+), 492 deletions(-)

-- 
//Rob
