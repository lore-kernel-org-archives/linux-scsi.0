From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 01/12] libfcoe: Don't fill MAC desc in FLOGI if FIP negotiated
	FPMA
Date: Fri, 09 Apr 2010 14:22:17 -0700
Message-ID: <20100409212217.1968.29837.stgit@localhost.localdomain>
References: <20100409212212.1968.59251.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:26101 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755323Ab0DIVWS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 9 Apr 2010 17:22:18 -0400
In-Reply-To: <20100409212212.1968.59251.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: Robert Love <robert.w.love@intel.com>, Chris Leech <christopher.leech@intel.com>Robert Love <robert.w.love@intel.com>

FPMA indicates that the Fabric will provide the host's
N_Port's MAC address. When sending a FLOGI/FDISC frame
and FPMA was negotiated through FIP discovery we still
need to provide the MAC descriptor, as per the
specification, but the MAC should be zero'd out since
the FCF will be providing it in the FLOGI/FDISC ACC.

In FC-BB-5 section 7.8.7.4.2 (Fabric login) it states:

The MAC address field in the MAC address descriptor of a FIP FLOGI
Request operation or a FIP NPIV FDISC Request operation shall contain:
a) the proposed MAC address to use as VN_Port MAC address if the ENode
   is requesting to use SPMA (see table 27);
b) all zeroes to indicate no MAC address is proposed if the ENode is
   requesting to use FPMA (see table 27); or
c) the proposed MAC address to use as VN_Port MAC address if the ENode
   supports both SPMA and FPMA and leaves the decision of which
   addressing scheme to use to the FCF (i.e., if both the FP and SP
   bits are set to one, see table 27).

This patch fixes case B.

This patch also adds debug statements to illustrate
whether a FPMA or SPMA MAC is added to a FLOGI/FDISC
frame.

Signed-off-by: Robert Love <robert.w.love@intel.com>
Signed-off-by: Chris Leech <christopher.leech@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/fcoe/libfcoe.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/fcoe/libfcoe.c b/drivers/scsi/fcoe/libfcoe.c
index ff5ccba..de5c329 100644
--- a/drivers/scsi/fcoe/libfcoe.c
+++ b/drivers/scsi/fcoe/libfcoe.c
@@ -442,10 +442,15 @@ static int fcoe_ctlr_encaps(struct fcoe_ctlr *fip, struct fc_lport *lport,
 	memset(mac, 0, sizeof(mac));
 	mac->fd_desc.fip_dtype = FIP_DT_MAC;
 	mac->fd_desc.fip_dlen = sizeof(*mac) / FIP_BPW;
-	if (dtype != FIP_DT_FLOGI && dtype != FIP_DT_FDISC)
+	if (dtype != FIP_DT_FLOGI && dtype != FIP_DT_FDISC) {
 		memcpy(mac->fd_mac, fip->get_src_addr(lport), ETH_ALEN);
-	else if (fip->spma)
+	} else if (fip_flags & FIP_FL_SPMA) {
+		LIBFCOE_FIP_DBG(fip, "FLOGI/FDISC sent with SPMA\n");
 		memcpy(mac->fd_mac, fip->ctl_src_addr, ETH_ALEN);
+	} else {
+		LIBFCOE_FIP_DBG(fip, "FLOGI/FDISC sent with FPMA\n");
+		/* FPMA only FLOGI must leave the MAC desc set to all 0s */
+	}
 
 	skb->protocol = htons(ETH_P_FIP);
 	skb_reset_mac_header(skb);

