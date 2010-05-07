From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 09/10] libfcoe: FIP Keep-Alive messages for VPorts are sent
	with incorrect port_id and wwn
Date: Fri, 07 May 2010 15:18:57 -0700
Message-ID: <20100507221857.14971.40259.stgit@localhost.localdomain>
References: <20100507221804.14971.11739.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:19628 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751720Ab0EGWS6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 7 May 2010 18:18:58 -0400
In-Reply-To: <20100507221804.14971.11739.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: Kaladhar Musunuru <kmusunuru@juniper.net>, Joe Eykholt <jeykholt@cisco.com>, Robert Love <robert.w.love@intel.com>

From: Kaladhar Musunuru <kmusunuru@juniper.net>

All VNports are sending FIP Keep-Alive messages with port_id and wwpn of the parent host instead of it's own port_id and wwpn. Standard FIP descriptor type 11 indicates to send own port_id and port_name.

Signed-off-by: Kaladhar Musunuru <kmusunuru@juniper.net>
Acked-by: Joe Eykholt <jeykholt@cisco.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/fcoe/libfcoe.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/fcoe/libfcoe.c b/drivers/scsi/fcoe/libfcoe.c
index 080e4ec..50aaa4b 100644
--- a/drivers/scsi/fcoe/libfcoe.c
+++ b/drivers/scsi/fcoe/libfcoe.c
@@ -374,8 +374,8 @@ static void fcoe_ctlr_send_keep_alive(struct fcoe_ctlr *fip,
 		vn->fd_desc.fip_dtype = FIP_DT_VN_ID;
 		vn->fd_desc.fip_dlen = sizeof(*vn) / FIP_BPW;
 		memcpy(vn->fd_mac, fip->get_src_addr(lport), ETH_ALEN);
-		hton24(vn->fd_fc_id, lp->port_id);
-		put_unaligned_be64(lp->wwpn, &vn->fd_wwpn);
+		hton24(vn->fd_fc_id, lport->port_id);
+		put_unaligned_be64(lport->wwpn, &vn->fd_wwpn);
 	}
 	skb_put(skb, len);
 	skb->protocol = htons(ETH_P_FIP);

