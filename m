From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 3/3] sg: remove unnecessary forward declaration
Date: Wed, 11 Mar 2009 10:02:47 +0900
Message-ID: <1236733367-30967-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1236733367-30967-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:40760 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753215AbZCKBEN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 Mar 2009 21:04:13 -0400
In-Reply-To: <1236733367-30967-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: dgilbert@interlog.com, linux-scsi@vger.kernel.org, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/scsi/sg.c |   17 +++++++----------
 1 files changed, 7 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 7d713a0..24f09ea 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -99,17 +99,9 @@ static int scatter_elem_sz_prev = SG_SCATTER_SZ;
 
 #define SG_SECTOR_SZ 512
 
-static int sg_add(struct device *, struct class_interface *);
-static void sg_remove(struct device *, struct class_interface *);
-
 static DEFINE_IDR(sg_index_idr);
-static DEFINE_RWLOCK(sg_index_lock);	/* Also used to lock
-							   file descriptor list for device */
-
-static struct class_interface sg_interface = {
-	.add_dev	= sg_add,
-	.remove_dev	= sg_remove,
-};
+/* Also used to lock file descriptor list for device */
+static DEFINE_RWLOCK(sg_index_lock);
 
 typedef struct sg_scatter_hold { /* holding area for scsi scatter gather info */
 	unsigned short k_use_sg; /* Count of kernel scatter-gather pieces */
@@ -1531,6 +1523,11 @@ static void sg_remove(struct device *cl_dev, struct class_interface *cl_intf)
 	sg_put_dev(sdp);
 }
 
+static struct class_interface sg_interface = {
+	.add_dev	= sg_add,
+	.remove_dev	= sg_remove,
+};
+
 module_param_named(scatter_elem_sz, scatter_elem_sz, int, S_IRUGO | S_IWUSR);
 module_param_named(def_reserved_size, def_reserved_size, int,
 		   S_IRUGO | S_IWUSR);
-- 
1.6.0.6

