From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 08/10] libfcoe: Fix incorrect MAC address clearing
Date: Fri, 07 May 2010 15:18:52 -0700
Message-ID: <20100507221852.14971.2206.stgit@localhost.localdomain>
References: <20100507221804.14971.11739.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:10753 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751720Ab0EGWSw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 7 May 2010 18:18:52 -0400
In-Reply-To: <20100507221804.14971.11739.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: Kaladhar Musunuru <kmusunuru@juniper.net>, Joe Eykholt <jeykholt@cisco.com>, Robert Love <robert.w.love@intel.com>

From: Kaladhar Musunuru <kmusunuru@juniper.net>

Fix typo in memset. Incorrect length parameter to memset resulting non-zero MAC address in FPMA messages.

Signed-off-by: Kaladhar Musunuru <kmusunuru@juniper.net>
Acked-by: Joe Eykholt <jeykholt@cisco.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/fcoe/libfcoe.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/fcoe/libfcoe.c b/drivers/scsi/fcoe/libfcoe.c
index 948364a..080e4ec 100644
--- a/drivers/scsi/fcoe/libfcoe.c
+++ b/drivers/scsi/fcoe/libfcoe.c
@@ -439,7 +439,7 @@ static int fcoe_ctlr_encaps(struct fcoe_ctlr *fip, struct fc_lport *lport,
 	cap->encaps.fd_desc.fip_dlen = dlen / FIP_BPW;
 
 	mac = (struct fip_mac_desc *)skb_put(skb, sizeof(*mac));
-	memset(mac, 0, sizeof(mac));
+	memset(mac, 0, sizeof(*mac));
 	mac->fd_desc.fip_dtype = FIP_DT_MAC;
 	mac->fd_desc.fip_dlen = sizeof(*mac) / FIP_BPW;
 	if (dtype != FIP_DT_FLOGI && dtype != FIP_DT_FDISC) {

