Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 640EBEE3F27
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Sep 2023 20:52:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237593AbjIKUvi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Sep 2023 16:51:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240682AbjIKOvC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Sep 2023 10:51:02 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95F57106;
        Mon, 11 Sep 2023 07:50:58 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3171C433CA;
        Mon, 11 Sep 2023 14:50:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1694443858;
        bh=udKSbYP3wVvhUEdYIPakGzChRO+pxg48wNgSy+8DnZM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1ym9tlPjbsLpmvrpr5y8JxcW5AIaOD0ooYyB/GCglF5IxA+w+EXRcC09nIQoaE04p
         y92fVLjdeSzDMPT0jVgNdbfaCi0gY98CwlNLyOpIXRl5WBa3OrWHo0zoWJyk9LMZZq
         V1/kWNte+hjjVy7P5S1EQCgiL3x1LT8mA7e9vFX0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Saurav Kashyap <skashyap@marvell.com>,
        Rob Evers <revers@redhat.com>,
        Johannes Thumshirn <Johannes.Thumshirn@wdc.com>,
        David Laight <David.Laight@ACULAB.COM>,
        Jozef Bacik <jobacik@redhat.com>,
        Laurence Oberman <loberman@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        GR-QLogic-Storage-Upstream@marvell.com, linux-scsi@vger.kernel.org,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Oleksandr Natalenko <oleksandr@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 526/737] scsi: qedf: Do not touch __user pointer in qedf_dbg_fp_int_cmd_read() directly
Date:   Mon, 11 Sep 2023 15:46:25 +0200
Message-ID: <20230911134705.268954907@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.286315610@linuxfoundation.org>
References: <20230911134650.286315610@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

6.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oleksandr Natalenko <oleksandr@redhat.com>

[ Upstream commit 25dbc20deab5165f847b4eb42f376f725a986ee8 ]

The qedf_dbg_fp_int_cmd_read() function invokes sprintf() directly on a
__user pointer, which may crash the kernel.

Avoid doing that by vmalloc()'ating a buffer for scnprintf() and then
calling simple_read_from_buffer() which does a proper copy_to_user() call.

Fixes: 61d8658b4a43 ("scsi: qedf: Add QLogic FastLinQ offload FCoE driver framework.")
Link: https://lore.kernel.org/lkml/20230724120241.40495-1-oleksandr@redhat.com/
Link: https://lore.kernel.org/linux-scsi/20230726101236.11922-1-skashyap@marvell.com/
Cc: Saurav Kashyap <skashyap@marvell.com>
Cc: Rob Evers <revers@redhat.com>
Cc: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
Cc: David Laight <David.Laight@ACULAB.COM>
Cc: Jozef Bacik <jobacik@redhat.com>
Cc: Laurence Oberman <loberman@redhat.com>
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: GR-QLogic-Storage-Upstream@marvell.com
Cc: linux-scsi@vger.kernel.org
Reviewed-by: Laurence Oberman <loberman@redhat.com>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Tested-by: Laurence Oberman <loberman@redhat.com>
Acked-by: Saurav Kashyap <skashyap@marvell.com>
Signed-off-by: Oleksandr Natalenko <oleksandr@redhat.com>
Link: https://lore.kernel.org/r/20230731084034.37021-4-oleksandr@redhat.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qedf/qedf_dbg.h     |  2 ++
 drivers/scsi/qedf/qedf_debugfs.c | 21 +++++++++++++++------
 2 files changed, 17 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/qedf/qedf_dbg.h b/drivers/scsi/qedf/qedf_dbg.h
index f4d81127239eb..5ec2b817c694a 100644
--- a/drivers/scsi/qedf/qedf_dbg.h
+++ b/drivers/scsi/qedf/qedf_dbg.h
@@ -59,6 +59,8 @@ extern uint qedf_debug;
 #define QEDF_LOG_NOTICE	0x40000000	/* Notice logs */
 #define QEDF_LOG_WARN		0x80000000	/* Warning logs */
 
+#define QEDF_DEBUGFS_LOG_LEN (2 * PAGE_SIZE)
+
 /* Debug context structure */
 struct qedf_dbg_ctx {
 	unsigned int host_no;
diff --git a/drivers/scsi/qedf/qedf_debugfs.c b/drivers/scsi/qedf/qedf_debugfs.c
index 1c5716540e465..451fd236bfd05 100644
--- a/drivers/scsi/qedf/qedf_debugfs.c
+++ b/drivers/scsi/qedf/qedf_debugfs.c
@@ -8,6 +8,7 @@
 #include <linux/uaccess.h>
 #include <linux/debugfs.h>
 #include <linux/module.h>
+#include <linux/vmalloc.h>
 
 #include "qedf.h"
 #include "qedf_dbg.h"
@@ -98,7 +99,9 @@ static ssize_t
 qedf_dbg_fp_int_cmd_read(struct file *filp, char __user *buffer, size_t count,
 			 loff_t *ppos)
 {
+	ssize_t ret;
 	size_t cnt = 0;
+	char *cbuf;
 	int id;
 	struct qedf_fastpath *fp = NULL;
 	struct qedf_dbg_ctx *qedf_dbg =
@@ -108,19 +111,25 @@ qedf_dbg_fp_int_cmd_read(struct file *filp, char __user *buffer, size_t count,
 
 	QEDF_INFO(qedf_dbg, QEDF_LOG_DEBUGFS, "entered\n");
 
-	cnt = sprintf(buffer, "\nFastpath I/O completions\n\n");
+	cbuf = vmalloc(QEDF_DEBUGFS_LOG_LEN);
+	if (!cbuf)
+		return 0;
+
+	cnt += scnprintf(cbuf + cnt, QEDF_DEBUGFS_LOG_LEN - cnt, "\nFastpath I/O completions\n\n");
 
 	for (id = 0; id < qedf->num_queues; id++) {
 		fp = &(qedf->fp_array[id]);
 		if (fp->sb_id == QEDF_SB_ID_NULL)
 			continue;
-		cnt += sprintf((buffer + cnt), "#%d: %lu\n", id,
-			       fp->completions);
+		cnt += scnprintf(cbuf + cnt, QEDF_DEBUGFS_LOG_LEN - cnt,
+				 "#%d: %lu\n", id, fp->completions);
 	}
 
-	cnt = min_t(int, count, cnt - *ppos);
-	*ppos += cnt;
-	return cnt;
+	ret = simple_read_from_buffer(buffer, count, ppos, cbuf, cnt);
+
+	vfree(cbuf);
+
+	return ret;
 }
 
 static ssize_t
-- 
2.40.1



