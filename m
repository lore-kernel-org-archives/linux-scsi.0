From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 07/64] fcoe: Add sysfs parameter to fcoe for minimum DDP read
	I/O size
Date: Tue, 25 Aug 2009 13:59:03 -0700
Message-ID: <20090825205903.1553.34555.stgit@localhost.localdomain>
References: <20090825205826.1553.94414.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:28454 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756004AbZHYU7C (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Aug 2009 16:59:02 -0400
In-Reply-To: <20090825205826.1553.94414.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org
Cc: Yi Zou <yi.zou@intel.com>, Robert Love <robert.w.love@intel.com>

From: Yi Zou <yi.zou@intel.com>

This adds fcoe_ddp_min as a module parameter for fcoe module to:
/sys/module/fcoe/parameters/ddp_min

It is observed that for some hardware, particularly Intel 82599, there is too
much overhead in setting up context for direct data placement (DDP) read when
the requested read I/O size is small. This is added as a module parameter for
performance tuning and is set as 0 by default and user can change this based
on their own hardware.

Signed-off-by: Yi Zou <yi.zou@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---

 drivers/scsi/fcoe/fcoe.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index e32a0ed..a39d370 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -49,6 +49,12 @@ MODULE_AUTHOR("Open-FCoE.org");
 MODULE_DESCRIPTION("FCoE");
 MODULE_LICENSE("GPL v2");
 
+/* Performance tuning parameters for fcoe */
+static unsigned int fcoe_ddp_min;
+module_param_named(ddp_min, fcoe_ddp_min, uint, S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(ddp_min, "Minimum I/O size in bytes for "	\
+		 "Direct Data Placement (DDP).");
+
 /* fcoe host list */
 LIST_HEAD(fcoe_hostlist);
 DEFINE_RWLOCK(fcoe_hostlist_lock);
@@ -414,7 +420,8 @@ static int fcoe_shost_config(struct fc_lport *lp, struct Scsi_Host *shost,
  */
 bool fcoe_oem_match(struct fc_frame *fp)
 {
-	return fc_fcp_is_read(fr_fsp(fp));
+	return fc_fcp_is_read(fr_fsp(fp)) &&
+		(fr_fsp(fp)->data_len > fcoe_ddp_min);
 }
 
 /**

