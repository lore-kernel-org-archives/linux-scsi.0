From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 7/8] fcoe: removes reserving memory for vlan_ethdr on tx path
Date: Wed, 06 May 2009 10:52:46 -0700
Message-ID: <20090506175245.26695.66340.stgit@fritz>
References: <20090506175206.26695.19457.stgit@fritz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:34266 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758627AbZEFRws (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 6 May 2009 13:52:48 -0400
In-Reply-To: <20090506175206.26695.19457.stgit@fritz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org
Cc: Vasu Dev <vasu.dev@intel.com>

From: Vasu Dev <vasu.dev@intel.com>

This is not required as VLAN header is added by device
interface driver, this was causing bad FC_CRC in FCoE pkts when
using VLAN interface.

Signed-off-by: Vasu Dev <vasu.dev@intel.com>
---

 drivers/scsi/fcoe/fcoe.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index cf62e99..b8db2a8 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -1036,8 +1036,7 @@ int fcoe_xmit(struct fc_lport *lp, struct fc_frame *fp)
 	sof = fr_sof(fp);
 	eof = fr_eof(fp);
 
-	elen = (fc->real_dev->priv_flags & IFF_802_1Q_VLAN) ?
-		sizeof(struct vlan_ethhdr) : sizeof(struct ethhdr);
+	elen = sizeof(struct ethhdr);
 	hlen = sizeof(struct fcoe_hdr);
 	tlen = sizeof(struct fcoe_crc_eof);
 	wlen = (skb->len - tlen + sizeof(crc)) / FCOE_WORD_TO_BYTE;

