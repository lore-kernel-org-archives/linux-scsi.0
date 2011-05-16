From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 3/8] libfc: fix mm leak in handling incoming request for
	target discovery
Date: Mon, 16 May 2011 16:45:35 -0700
Message-ID: <20110516234535.24502.33714.stgit@localhost6.localdomain6>
References: <20110516234519.24502.22027.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:34511 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753144Ab1EPXpf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 May 2011 19:45:35 -0400
In-Reply-To: <20110516234519.24502.22027.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Hillf Danton <dhillf@gmail.com>

From: Hillf Danton <dhillf@gmail.com>

When handling incoming request, if the operation code carried by the
received frame is not RSCN, the frame should be freed as in the RSCN
case, or there is memory leakage.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/libfc/fc_disc.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/libfc/fc_disc.c b/drivers/scsi/libfc/fc_disc.c
index 911b273..b9cb814 100644
--- a/drivers/scsi/libfc/fc_disc.c
+++ b/drivers/scsi/libfc/fc_disc.c
@@ -205,6 +205,7 @@ static void fc_disc_recv_req(struct fc_lport *lport, struct fc_frame *fp)
 	default:
 		FC_DISC_DBG(disc, "Received an unsupported request, "
 			    "the opcode is (%x)\n", op);
+		fc_frame_free(fp);
 		break;
 	}
 }

