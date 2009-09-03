From: Vasu Dev <vasu.dev@intel.com>
Subject: [PATCH 09/10] libfc: adds queue_depth ramp up to libfc
Date: Thu, 03 Sep 2009 15:23:15 -0700
Message-ID: <20090903222315.24946.63010.stgit@vi1.jf.intel.com>
References: <20090903221910.24946.39993.stgit@vi1.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:55160 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932411AbZICWXN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 3 Sep 2009 18:23:13 -0400
In-Reply-To: <20090903221910.24946.39993.stgit@vi1.jf.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, James Smart <james.smart@emulex.com>, Mike Christie <michaelc@cs.wisc.edu>, Robert Love <robert.w.love@intel.com>, Christof Schmitt <christof.schmitt@de.ibm.com>

Increases queue_depth by one on fc_change_queue_depth call back
with reason SCSI_QDEPTH_RAMP_UP.

Signed-off-by: Vasu Dev <vasu.dev@intel.com>
---

 drivers/scsi/libfc/fc_fcp.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/libfc/fc_fcp.c b/drivers/scsi/libfc/fc_fcp.c
index b49f48b..71b49b0 100644
--- a/drivers/scsi/libfc/fc_fcp.c
+++ b/drivers/scsi/libfc/fc_fcp.c
@@ -2054,6 +2054,11 @@ int fc_change_queue_depth(struct scsi_device *sdev, int qdepth, int reason)
 	case SCSI_QDEPTH_QFULL:
 		scsi_track_queue_full(sdev, qdepth);
 		break;
+	case SCSI_QDEPTH_RAMP_UP:
+		if (qdepth <= FC_FCP_DFLT_QUEUE_DEPTH)
+			scsi_adjust_queue_depth(sdev, scsi_get_tag_type(sdev),
+						qdepth);
+		break;
 	default:
 		return -EOPNOTSUPP;
 	}

