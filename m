From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 49/54] libfc: do not use DID_NO_CONNECT for pkt alloc failures.
Date: Tue, 03 Nov 2009 11:49:54 -0800
Message-ID: <20091103194954.4085.42179.stgit@localhost.localdomain>
References: <20091103194530.4085.37963.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:44645 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754963AbZKCTtt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 3 Nov 2009 14:49:49 -0500
In-Reply-To: <20091103194530.4085.37963.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>, Robert Love <robert.w.love@intel.com>

From: Mike Christie <michaelc@cs.wisc.edu>

DID_NO_CONNECT is not a nice value to use for pkt alloc failures,
because you can probably retry and IO will become available again.
For the device reset callout, we do not want to set the scsi command
result for the above reason, and because we do not need to set
the scsi_cmd->result in this path. We and other drivers do not set it
for success for example, and we do not set it for other failure.
And scsi-ml does not send every command through this path, and it is
not expecting us to use the scsi_cmnd struct like a cmd coming thruogh
queuecommand. I think it is more for storage in case we need a cmd
struct for a tmf and to give us certain params like the LUN.

Patch was made over scsi-misc today.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/libfc/fc_fcp.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/libfc/fc_fcp.c b/drivers/scsi/libfc/fc_fcp.c
index 4bfab4f..db252e2 100644
--- a/drivers/scsi/libfc/fc_fcp.c
+++ b/drivers/scsi/libfc/fc_fcp.c
@@ -2029,7 +2029,6 @@ int fc_eh_device_reset(struct scsi_cmnd *sc_cmd)
 	fsp = fc_fcp_pkt_alloc(lport, GFP_NOIO);
 	if (fsp == NULL) {
 		printk(KERN_WARNING "libfc: could not allocate scsi_pkt\n");
-		sc_cmd->result = DID_NO_CONNECT << 16;
 		goto out;
 	}
 

