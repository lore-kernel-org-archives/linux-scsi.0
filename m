Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2429AC77B7C
	for <linux-scsi@archiver.kernel.org>; Thu, 27 Apr 2023 12:12:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243853AbjD0MMs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 27 Apr 2023 08:12:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243806AbjD0MMp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 27 Apr 2023 08:12:45 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48FD1559A;
        Thu, 27 Apr 2023 05:12:18 -0700 (PDT)
Received: from kwepemm600012.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Q6ZLp6VY6zsR61;
        Thu, 27 Apr 2023 20:10:26 +0800 (CST)
Received: from build.huawei.com (10.175.101.6) by
 kwepemm600012.china.huawei.com (7.193.23.74) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 27 Apr 2023 20:12:05 +0800
From:   Wenchao Hao <haowenchao2@huawei.com>
To:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Douglas Gilbert <dgilbert@interlog.com>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <linfeilong@huawei.com>, <louhongxiang@huawei.com>,
        Wenchao Hao <haowenchao2@huawei.com>
Subject: [PATCH v2 4/6] scsi:scsi_debug: timeout command if the error is injected
Date:   Fri, 28 Apr 2023 09:33:18 +0800
Message-ID: <20230428013320.347050-5-haowenchao2@huawei.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20230428013320.347050-1-haowenchao2@huawei.com>
References: <20230428013320.347050-1-haowenchao2@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemm600012.china.huawei.com (7.193.23.74)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If a timeout error is injected, return 0 from scsi_debug_queuecommand to
make the command timeout.

For example, the following command would inject timeout error for
inquiry(0x12) command for 10 times:
  error=/sys/kernel/debug/scsi_debug/0:0:0:1/error
  echo "0 -10 0x12" > $error

Signed-off-by: Wenchao Hao <haowenchao2@huawei.com>
---
 drivers/scsi/scsi_debug.c | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 2c380cddcb84..2d31ae15bd97 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -7714,6 +7714,30 @@ static int sdebug_blk_mq_poll(struct Scsi_Host *shost, unsigned int queue_num)
 	return num_entries;
 }
 
+static int sdebug_timeout_cmd(struct scsi_cmnd *cmnd)
+{
+	struct scsi_device *sdp = cmnd->device;
+	struct sdebug_dev_info *devip = (struct sdebug_dev_info *)sdp->hostdata;
+	struct sdebug_err_inject *err;
+	unsigned char *cmd = cmnd->cmnd;
+	int ret = 0;
+
+	if (devip == NULL)
+		return 0;
+
+	list_for_each_entry(err, &devip->inject_err_list, list) {
+		if (err->type == ERR_TMOUT_CMD &&
+		    (err->cmd == cmd[0] || err->cmd == 0xff)) {
+			ret = !!err->cnt;
+			if (err->cnt < 0)
+				err->cnt++;
+			return ret;
+		}
+	}
+
+	return 0;
+}
+
 static int scsi_debug_queuecommand(struct Scsi_Host *shost,
 				   struct scsi_cmnd *scp)
 {
@@ -7772,6 +7796,12 @@ static int scsi_debug_queuecommand(struct Scsi_Host *shost,
 		if (NULL == devip)
 			goto err_out;
 	}
+
+	if (sdebug_timeout_cmd(scp)) {
+		scmd_printk(KERN_INFO, scp, "timeout command 0x%x\n", opcode);
+		return 0;
+	}
+
 	if (unlikely(inject_now && !atomic_read(&sdeb_inject_pending)))
 		atomic_set(&sdeb_inject_pending, 1);
 
-- 
2.32.0

