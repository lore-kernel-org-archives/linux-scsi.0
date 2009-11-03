From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 53/54] libfcoe: Do not pad FIP keep-alive to full frame size
Date: Tue, 03 Nov 2009 11:50:16 -0800
Message-ID: <20091103195016.4085.9583.stgit@localhost.localdomain>
References: <20091103194530.4085.37963.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:23896 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755239AbZKCTuL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 3 Nov 2009 14:50:11 -0500
In-Reply-To: <20091103194530.4085.37963.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org
Cc: Yi Zou <yi.zou@intel.com>, Robert Love <robert.w.love@intel.com>

From: Yi Zou <yi.zou@intel.com>

According to the FC-BB-5 Rev2.0, 7.8.6.2, we should not pad FIP keep-alive
frames.

Signed-off-by: Yi Zou <yi.zou@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/fcoe/libfcoe.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/fcoe/libfcoe.c b/drivers/scsi/fcoe/libfcoe.c
index 2988b71..3c501d4 100644
--- a/drivers/scsi/fcoe/libfcoe.c
+++ b/drivers/scsi/fcoe/libfcoe.c
@@ -351,8 +351,7 @@ static void fcoe_ctlr_send_keep_alive(struct fcoe_ctlr *fip,
 	if (!fcf || !fc_host_port_id(lp->host))
 		return;
 
-	len = fcoe_ctlr_fcoe_size(fip) + sizeof(struct ethhdr);
-	BUG_ON(len < sizeof(*kal) + sizeof(*vn));
+	len = sizeof(*kal) + ports * sizeof(*vn);
 	skb = dev_alloc_skb(len);
 	if (!skb)
 		return;

