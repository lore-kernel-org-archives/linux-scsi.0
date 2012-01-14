From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 4/4] libfc: remove redundant timer init for fcp
Date: Fri, 13 Jan 2012 17:26:30 -0800
Message-ID: <20120114012630.19185.81821.stgit@localhost6.localdomain6>
References: <20120114012609.19185.66603.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:50602 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754318Ab2ANB0b (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Jan 2012 20:26:31 -0500
In-Reply-To: <20120114012609.19185.66603.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Ross Brattain <ross.b.brattain@intel.com>, Yi Zou <yi.zou@intel.com>

From: Yi Zou <yi.zou@intel.com>

The fcp timer is already initialized when it gets allocated.

Signed-off-by: Yi Zou <yi.zou@intel.com>
Tested-by: Ross Brattain <ross.b.brattain@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/libfc/fc_fcp.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/libfc/fc_fcp.c b/drivers/scsi/libfc/fc_fcp.c
index 221875e..f607314 100644
--- a/drivers/scsi/libfc/fc_fcp.c
+++ b/drivers/scsi/libfc/fc_fcp.c
@@ -155,6 +155,7 @@ static struct fc_fcp_pkt *fc_fcp_pkt_alloc(struct fc_lport *lport, gfp_t gfp)
 		fsp->xfer_ddp = FC_XID_UNKNOWN;
 		atomic_set(&fsp->ref_cnt, 1);
 		init_timer(&fsp->timer);
+		fsp->timer.data = (unsigned long)fsp;
 		INIT_LIST_HEAD(&fsp->list);
 		spin_lock_init(&fsp->scsi_pkt_lock);
 	}
@@ -1850,9 +1851,6 @@ int fc_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *sc_cmd)
 	}
 	put_cpu();
 
-	init_timer(&fsp->timer);
-	fsp->timer.data = (unsigned long)fsp;
-
 	/*
 	 * send it to the lower layer
 	 * if we get -1 return then put the request in the pending

