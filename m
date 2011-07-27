From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 02/10] libfc: use FC_MAX_ERROR_CNT
Date: Wed, 27 Jul 2011 15:10:28 -0700
Message-ID: <20110727221028.23675.44066.stgit@localhost6.localdomain6>
References: <20110727221018.23675.3551.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:27341 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755226Ab1G0WK3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 27 Jul 2011 18:10:29 -0400
In-Reply-To: <20110727221018.23675.3551.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Hillf Danton <dhillf@gmail.com>

From: Hillf Danton <dhillf@gmail.com>

Though defined, FC_MAX_ERROR_CNT is not used. It is used now for CRC error in
the path of receiving FCP frame.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/libfc/fc_fcp.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/libfc/fc_fcp.c b/drivers/scsi/libfc/fc_fcp.c
index 9cd2149..41f7070 100644
--- a/drivers/scsi/libfc/fc_fcp.c
+++ b/drivers/scsi/libfc/fc_fcp.c
@@ -498,7 +498,7 @@ crc_err:
 			stats = per_cpu_ptr(lport->dev_stats, get_cpu());
 			stats->ErrorFrames++;
 			/* per cpu count, not total count, but OK for limit */
-			if (stats->InvalidCRCCount++ < 5)
+			if (stats->InvalidCRCCount++ < FC_MAX_ERROR_CNT)
 				printk(KERN_WARNING "libfc: CRC error on data "
 				       "frame for port (%6.6x)\n",
 				       lport->port_id);

