From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 0/8] Open-FCoE fixes for 2.6.30 RC
Date: Wed, 06 May 2009 10:52:07 -0700
Message-ID: <20090506175206.26695.19457.stgit@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:21343 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759445AbZEFRwH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 6 May 2009 13:52:07 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org

The following series implements general fixes to libfc, libfcoe and fcoe. 

Note: One patch adds the FIP ehtertype to if_ether.h. As discussed on netdev,
this change was pre-acked and it was requested that the change go through
the SCSI tree.

---

Chris Leech (1):
      fcoe: use ETH_P_FIP for skb->protocol of FIP frames

Joe Eykholt (2):
      net, libfcoe: Add the FCoE Initialization Protocol ethertype
      libfcoe: fip: fix non-FIP-mode FLOGI state after reset.

Mike Christie (1):
      libfc: use DID_ERROR when we have internall aborted command

Steve Ma (1):
      libfc: Check if exchange is completed when receiving a sequence

Vasu Dev (3):
      fcoe: removes reserving memory for vlan_ethdr on tx path
      fcoe: removes fcoe_watchdog
      fcoe: reduces lock cost when adding a new skb to fcoe_pending_queue


 drivers/scsi/fcoe/fcoe.c     |   90 +++++++++++++++---------------------------
 drivers/scsi/fcoe/fcoe.h     |    1 
 drivers/scsi/fcoe/libfcoe.c  |   21 ++++++----
 drivers/scsi/libfc/fc_exch.c |    4 ++
 drivers/scsi/libfc/fc_fcp.c  |    2 -
 include/linux/if_ether.h     |    1 
 include/scsi/fc/fc_fip.h     |    7 ---
 7 files changed, 53 insertions(+), 73 deletions(-)

-- 
//Rob
