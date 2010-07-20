From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 03/28] libfc: IO errors on link down due to cable unplug
Date: Tue, 20 Jul 2010 15:19:20 -0700
Message-ID: <20100720221920.17116.59505.stgit@localhost.localdomain>
References: <20100720221904.17116.78553.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:40070 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761872Ab0GTWTW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Jul 2010 18:19:22 -0400
In-Reply-To: <20100720221904.17116.78553.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: Vasu Dev <vasu.dev@intel.com>

From: Vasu Dev <vasu.dev@intel.com>

In this case, sync IO fails with EIO(5) errors as:-

"Thread:1 System call error:5 - Input/output error (::pwrite() failed)".

This is due to IO time out while libfc doing link down processing
to block all rports and if timed out IO was at last retry
attempt then it fails to user with EIO error followed by
these log messages.

[77848.612169] host2: rport bf0015: Delete port
[77848.612221] host2: rport e10aef: work delete
[77848.612232] host2: rport e10002: work event 3
[77848.612422] sd 2:0:1:1: [sdi] Unhandled error code
[77848.612426] sd 2:0:1:1: [sdi] Result: hostbyte=DID_ERROR
driverbyte=DRIVER_OK
[77848.612431] sd 2:0:1:1: [sdi] CDB: Write(10): 2a 00 00 00 11 20 00 00 20 00
[77848.612445] end_request: I/O error, dev sdi, sector 4384
[77848.612553] sd 2:0:1:2: [sdj] Unhandled error code

To fix these EIO errors, such timed out incomplete IOs needs
to be re-queued without counting retry attempt and this patch
does that using DID_REQUEUE scsi code.

Signed-off-by: Vasu Dev <vasu.dev@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/libfc/fc_fcp.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/libfc/fc_fcp.c b/drivers/scsi/libfc/fc_fcp.c
index a0a3ae7..61a1297 100644
--- a/drivers/scsi/libfc/fc_fcp.c
+++ b/drivers/scsi/libfc/fc_fcp.c
@@ -1971,6 +1971,11 @@ static void fc_io_compl(struct fc_fcp_pkt *fsp)
 		break;
 	}
 
+	if (lport->state != LPORT_ST_READY && fsp->status_code != FC_COMPLETE) {
+		sc_cmd->result = (DID_REQUEUE << 16);
+		FC_FCP_DBG(fsp, "Returning DID_REQUEUE to scsi-ml\n");
+	}
+
 	spin_lock_irqsave(&si->scsi_queue_lock, flags);
 	list_del(&fsp->list);
 	spin_unlock_irqrestore(&si->scsi_queue_lock, flags);

