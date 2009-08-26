From: Vasu Dev <vasu.dev@intel.com>
Subject: [RFC PATCH 9/9] libfc: adds queue_depth ramp up to libfc
Date: Wed, 26 Aug 2009 11:04:03 -0700
Message-ID: <20090826180403.23396.61277.stgit@vi1.jf.intel.com>
References: <20090826180234.23396.8148.stgit@vi1.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:34213 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752437AbZHZSEB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 26 Aug 2009 14:04:01 -0400
In-Reply-To: <20090826180234.23396.8148.stgit@vi1.jf.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: michaelc@cs.wisc.edu, linux-scsi@vger.kernel.org

Increases queue_depth by one on fc_change_queue_depth call back
with reason SCSI_QDEPTH_RAMP_UP.

Signed-off-by: Vasu Dev <vasu.dev@intel.com>
---

 drivers/scsi/libfc/fc_fcp.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/libfc/fc_fcp.c b/drivers/scsi/libfc/fc_fcp.c
index dda4162..92e8a1b 100644
--- a/drivers/scsi/libfc/fc_fcp.c
+++ b/drivers/scsi/libfc/fc_fcp.c
@@ -2054,6 +2054,11 @@ int fc_change_queue_depth(struct scsi_device *sdev, int qdepth, int reason)
 	case SCSI_QDEPTH_QFULL:
 		scsi_track_queue_full(sdev, qdepth);
 		break;
+	case SCSI_QDEPTH_RAMP_UP:
+		if (qdepth + 1 <= FC_FCP_DFLT_QUEUE_DEPTH)
+			scsi_adjust_queue_depth(sdev, scsi_get_tag_type(sdev),
+						qdepth + 1);
+		break;
 	default:
 		return -EOPNOTSUPP;
 	}

