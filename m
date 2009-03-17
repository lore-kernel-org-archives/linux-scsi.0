From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 00/14] Open-FCoE fixes and features for 2.6.30 merge window
Date: Tue, 17 Mar 2009 11:41:24 -0700
Message-ID: <20090317184124.22987.65368.stgit@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:11482 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755654AbZCQSl0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Mar 2009 14:41:26 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org

The following series implements a few fixes, some preparation work and the implementation
of FIP.

1) Fix of CPU hotplug handling.

2) Removal of fc_transport_fcoe.[ch]. This code was written so a LLD could load a transport
   for Ethernet devices that support FCoE offloads. This aproach was discarded in favor of
   directly providing offload capabilities through netdev. FCoE offload patches have been
   Ack'd by netdev and are in the scsi-misc tree already. In this set we just clean up the
   previous and unused FCoE transport method.
   
3) fcoe/* reorgainzation. Since both FIP and fnic are targeting the 2.6.30 merge window we
   wanted to do some cleanup of the fcoe layer. We've better defined each module so that
   fcoe.ko will only have the netdev related SW implementation (fnic does not use) and
   libfcoe.ko which will have common FCoE routines available to all FCoE LLDs.

4) FIP implementation. FIP == FCoE Initialization Protocol. This is a new standard way to
   discover FCoE capable switches. This code becomes the majority of libfcoe.ko. These
   patches had previously been sent to linux-scsi. This series resends them as they've
   been slightly modified to better fit into the reorganization. Functionality is the
   same as previously posted.

This patchset is built on scsi-misc-2.6 and are intended for 2.6.30.

---

Joe Eykholt (2):
      fcoe, libfcoe: Add support for FIP. FCoE discovery and keep-alive.
      fcoe: Add a header file defining the FIP protocol for FCoE.

Robert Love (4):
      fcoe: create/destroy fcoe Rx threads on CPU hotplug events
      fcoe: Use per-CPU kernel function for dev_stats instead of an array
      fcoe: Use percpu kernel funcs for struct fcoe_percpu_s
      fcoe: Initialize all possilbe skb_queue(s) when module is loaded

Vasu Dev (8):
      fcoe, libfc: fix double fcoe_softc memory alloc
      fcoe: cleans up libfcoe.h and adds fcoe.h for fcoe module
      fcoe: moves common FCoE library API functions to libfcoe module
      fcoe, libfc, scsi: adds libfcoe module
      fcoe: renames libfcoe.c to fcoe.c as the only fcoe module file
      fcoe: removes default sw transport code file fcoe_sw.c
      fcoe: removes fc_transport_fcoe.[ch] code files
      fcoe: prep work to completely remove fc_transport_fcoe code


 drivers/scsi/Kconfig                  |    8 
 drivers/scsi/Makefile                 |    1 
 drivers/scsi/fcoe/Makefile            |    8 
 drivers/scsi/fcoe/fc_transport_fcoe.c |  443 -------
 drivers/scsi/fcoe/fcoe.c              | 1865 ++++++++++++++++++++++++++++
 drivers/scsi/fcoe/fcoe.h              |   75 +
 drivers/scsi/fcoe/fcoe_sw.c           |  561 --------
 drivers/scsi/fcoe/libfcoe.c           | 2216 +++++++++++++++------------------
 drivers/scsi/libfc/fc_fcp.c           |   10 
 drivers/scsi/libfc/fc_lport.c         |   11 
 include/scsi/fc/fc_fip.h              |  237 ++++
 include/scsi/fc_transport_fcoe.h      |   54 -
 include/scsi/libfc.h                  |   45 +
 include/scsi/libfcoe.h                |  227 ++-
 14 files changed, 3396 insertions(+), 2365 deletions(-)
 delete mode 100644 drivers/scsi/fcoe/fc_transport_fcoe.c
 create mode 100644 drivers/scsi/fcoe/fcoe.c
 create mode 100644 drivers/scsi/fcoe/fcoe.h
 delete mode 100644 drivers/scsi/fcoe/fcoe_sw.c
 create mode 100644 include/scsi/fc/fc_fip.h
 delete mode 100644 include/scsi/fc_transport_fcoe.h

-- 
//Rob
