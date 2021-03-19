Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98F90C433C1
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Mar 2021 15:06:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 692386191C
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Mar 2021 15:06:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230308AbhCSPGC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 19 Mar 2021 11:06:02 -0400
Received: from smtp.infotech.no ([82.134.31.41]:41601 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231139AbhCSPFj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 19 Mar 2021 11:05:39 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id 7A2CC204269;
        Fri, 19 Mar 2021 16:05:30 +0100 (CET)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id XcoPgPSA46M6; Fri, 19 Mar 2021 16:05:20 +0100 (CET)
Received: from xtwo70.bingwo.ca (host-45-58-219-4.dyn.295.ca [45.58.219.4])
        by smtp.infotech.no (Postfix) with ESMTPA id 94629204192;
        Fri, 19 Mar 2021 16:05:18 +0100 (CET)
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, mcgrof@kernel.org, hare@suse.de
Subject: [RFC] scsi_debug: add hosts initialization --> worker
Date:   Fri, 19 Mar 2021 11:05:14 -0400
Message-Id: <20210319150514.17083-1-dgilbert@interlog.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Adding (pseudo) SCSI hosts has been done in the scsi_debug_init()
function. Each added SCSI host triggers an (async) scan and for
every LUN found, the host environment can trigger a lot of work.
On a recent Ubuntu/Debian distribution a lot of this "work" seems
to involve udev and its scripts. The result of this work can be
seconds elapsed before scsi_debug_init() returns.

This experimental code places the function to add those SCSI hosts
in its own thread. This allows scsi_debug_init() to complete a lot
faster. To impede malevolent user space code that might try to send
a 'rmmod scsi_debug', an extra module_get() reference is taken
before the worker thread starts and that worker gives back that
reference when it completes.

This patch is against MKP's repository and its 5.13/scsi-queue
branch which is sitting at lk 5.12.0-rc1. It should apply to later
release candidates in that series.

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
---

This RFC is in response to
   https://bugzilla.kernel.org/show_bug.cgi?id=212337
titled: "[Bug 212337] scsi_debug: race at module load and module
unload" raised by Luis Chamberlain. It has been lightly tested and
seems to work and make the 'modprobe scsi_debug ...' command 
complete almost immediately. And this pair of commands causes no
crash: 'modprobe scsi_debug ... ; rmmod scsi_debug' just a warning:
   rmmod: ERROR: Module scsi_debug is in use

 drivers/scsi/scsi_debug.c | 81 ++++++++++++++++++++++-----------------
 1 file changed, 46 insertions(+), 35 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 70165be10f00..aa74bf59e827 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -361,6 +361,8 @@ static atomic_t sdebug_a_tsf;	     /* 'almost task set full' counter */
 static atomic_t sdeb_inject_pending;
 static atomic_t sdeb_mq_poll_count;  /* bumped when mq_poll returns > 0 */
 
+static struct execute_work ew_init;
+
 struct opcode_info_t {
 	u8 num_attached;	/* 0 if this is it (i.e. a leaf); use 0xff */
 				/* for terminating element */
@@ -6651,14 +6653,51 @@ static struct attribute *sdebug_drv_attrs[] = {
 };
 ATTRIBUTE_GROUPS(sdebug_drv);
 
+static void sdeb_add_hosts_thr(struct work_struct *work)
+{
+	bool want_store = (sdebug_fake_rw == 0);
+	int k, ret, hosts_to_add;
+	int idx = -1;
+
+	if (want_store) {
+		idx = sdebug_add_store();
+		if (idx < 0) {
+			pr_warn("%s: unable to allocate any store\n", __func__);
+			goto fini;
+		}
+	}
+	hosts_to_add = READ_ONCE(sdebug_add_host);
+	WRITE_ONCE(sdebug_add_host, 0);
+
+	for (k = 0; k < hosts_to_add; k++) {
+		if (want_store && k == 0) {
+			ret = sdebug_add_host_helper(idx);
+			if (ret < 0) {
+				pr_err("add_host_helper k=%d, error=%d\n",
+				       k, -ret);
+				break;
+			}
+		} else {
+			ret = sdebug_do_add_host(want_store &&
+						 sdebug_per_host_store);
+			if (ret < 0) {
+				pr_err("add_host k=%d error=%d\n", k, -ret);
+				break;
+			}
+		}
+	}
+	if (sdebug_verbose)
+		pr_info("built %d host(s)\n", sdebug_num_hosts);
+fini:
+	module_put(THIS_MODULE);
+}
+
 static struct device *pseudo_primary;
 
 static int __init scsi_debug_init(void)
 {
-	bool want_store = (sdebug_fake_rw == 0);
 	unsigned long sz;
-	int k, ret, hosts_to_add;
-	int idx = -1;
+	int k, ret;
 
 	ramdisk_lck_a[0] = &atomic_rw;
 	ramdisk_lck_a[1] = &atomic_rw2;
@@ -6841,19 +6880,12 @@ static int __init scsi_debug_init(void)
 		}
 	}
 	xa_init_flags(per_store_ap, XA_FLAGS_ALLOC | XA_FLAGS_LOCK_IRQ);
-	if (want_store) {
-		idx = sdebug_add_store();
-		if (idx < 0) {
-			ret = idx;
-			goto free_q_arr;
-		}
-	}
 
 	pseudo_primary = root_device_register("pseudo_0");
 	if (IS_ERR(pseudo_primary)) {
 		pr_warn("root_device_register() error\n");
 		ret = PTR_ERR(pseudo_primary);
-		goto free_vm;
+		goto free_q_arr;
 	}
 	ret = bus_register(&pseudo_lld_bus);
 	if (ret < 0) {
@@ -6866,28 +6898,9 @@ static int __init scsi_debug_init(void)
 		goto bus_unreg;
 	}
 
-	hosts_to_add = sdebug_add_host;
-	sdebug_add_host = 0;
-
-	for (k = 0; k < hosts_to_add; k++) {
-		if (want_store && k == 0) {
-			ret = sdebug_add_host_helper(idx);
-			if (ret < 0) {
-				pr_err("add_host_helper k=%d, error=%d\n",
-				       k, -ret);
-				break;
-			}
-		} else {
-			ret = sdebug_do_add_host(want_store &&
-						 sdebug_per_host_store);
-			if (ret < 0) {
-				pr_err("add_host k=%d error=%d\n", k, -ret);
-				break;
-			}
-		}
-	}
-	if (sdebug_verbose)
-		pr_info("built %d host(s)\n", sdebug_num_hosts);
+	__module_get(THIS_MODULE);	/* _put() at end of sdeb_add_hosts_thr() */
+	INIT_WORK(&ew_init.work, sdeb_add_hosts_thr);
+	schedule_work(&ew_init.work);
 
 	return 0;
 
@@ -6895,8 +6908,6 @@ static int __init scsi_debug_init(void)
 	bus_unregister(&pseudo_lld_bus);
 dev_unreg:
 	root_device_unregister(pseudo_primary);
-free_vm:
-	sdebug_erase_store(idx, NULL);
 free_q_arr:
 	kfree(sdebug_q_arr);
 	return ret;
-- 
2.25.1

