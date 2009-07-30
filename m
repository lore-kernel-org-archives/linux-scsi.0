From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 02/22] libfcoe: Set fip_flags according to fcf and lport's
	capability of SPMA support
Date: Wed, 29 Jul 2009 17:03:55 -0700
Message-ID: <20090730000355.24658.20116.stgit@localhost.localdomain>
References: <20090730000345.24658.24830.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:27217 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755261AbZG3AD4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Jul 2009 20:03:56 -0400
In-Reply-To: <20090730000345.24658.24830.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org
Cc: Yi Zou <yi.zou@intel.com>, Robert Love <robert.w.love@intel.com>

From: Yi Zou <yi.zou@intel.com>

When encap the els for FIP, set the fip_flags according to the FCF and lport's
capability of supporting SPMA or FPMA or both.

Signed-off-by: Yi Zou <yi.zou@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/fcoe/libfcoe.c |   12 +++++++++---
 1 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/fcoe/libfcoe.c b/drivers/scsi/fcoe/libfcoe.c
index d6ed3f8..78caa6b 100644
--- a/drivers/scsi/fcoe/libfcoe.c
+++ b/drivers/scsi/fcoe/libfcoe.c
@@ -413,10 +413,18 @@ static int fcoe_ctlr_encaps(struct fcoe_ctlr *fip,
 	struct fip_mac_desc *mac;
 	struct fcoe_fcf *fcf;
 	size_t dlen;
+	u16 fip_flags;
 
 	fcf = fip->sel_fcf;
 	if (!fcf)
 		return -ENODEV;
+
+	/* set flags according to both FCF and lport's capability on SPMA */
+	fip_flags = fcf->flags;
+	fip_flags &= fip->spma ? FIP_FL_SPMA | FIP_FL_FPMA : FIP_FL_FPMA;
+	if (!fip_flags)
+		return -ENODEV;
+
 	dlen = sizeof(struct fip_encaps) + skb->len;	/* len before push */
 	cap = (struct fip_encaps_head *)skb_push(skb, sizeof(*cap));
 
@@ -429,9 +437,7 @@ static int fcoe_ctlr_encaps(struct fcoe_ctlr *fip,
 	cap->fip.fip_op = htons(FIP_OP_LS);
 	cap->fip.fip_subcode = FIP_SC_REQ;
 	cap->fip.fip_dl_len = htons((dlen + sizeof(*mac)) / FIP_BPW);
-	cap->fip.fip_flags = htons(FIP_FL_FPMA);
-	if (fip->spma)
-		cap->fip.fip_flags |= htons(FIP_FL_SPMA);
+	cap->fip.fip_flags = htons(fip_flags);
 
 	cap->encaps.fd_desc.fip_dtype = dtype;
 	cap->encaps.fd_desc.fip_dlen = dlen / FIP_BPW;

