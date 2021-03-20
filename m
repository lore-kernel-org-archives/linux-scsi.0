Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF7E2C433C1
	for <linux-scsi@archiver.kernel.org>; Sat, 20 Mar 2021 11:56:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6C1376197D
	for <linux-scsi@archiver.kernel.org>; Sat, 20 Mar 2021 11:56:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229849AbhCTLza (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 20 Mar 2021 07:55:30 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:14112 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230218AbhCTLzS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 20 Mar 2021 07:55:18 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4F2XCS2qQyz16H17;
        Sat, 20 Mar 2021 15:17:40 +0800 (CST)
Received: from [127.0.0.1] (10.174.176.117) by DGGEMS408-HUB.china.huawei.com
 (10.3.19.208) with Microsoft SMTP Server id 14.3.498.0; Sat, 20 Mar 2021
 15:19:26 +0800
To:     <agk@redhat.com>, <snitzer@redhat.com>, <dm-devel@redhat.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>
CC:     <linux-kernel@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        linfeilong <linfeilong@huawei.com>,
        lixiaokeng <lixiaokeng@huawei.com>,
        "wubo (T)" <wubo40@huawei.com>, <liuzhiqiang26@huawei.com>
From:   Zhiqiang Liu <liuzhiqiang26@huawei.com>
Subject: [PATCH] md/dm-mpath: check whether all pgpaths have same uuid in
 multipath_ctr()
Message-ID: <c8f86351-3036-0945-90d2-2e020d68ccf2@huawei.com>
Date:   Sat, 20 Mar 2021 15:19:23 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.176.117]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Zhiqiang Liu <liuzhiqiang26@huawei.com>

When we make IO stress test on multipath device, there will
be a metadata err because of wrong path. In the test, we
concurrent execute 'iscsi device login|logout' and
'multipath -r' command with IO stress on multipath device.
In some case, systemd-udevd may have not time to process
uevents of iscsi device logout|login, and then 'multipath -r'
command triggers multipathd daemon calls ioctl to load table
with incorrect old device info from systemd-udevd.
Then, one iscsi path may be incorrectly attached to another
multipath which has different uuid. Finally, the metadata err
occurs when umounting filesystem to down write metadata on
the iscsi device which is actually not owned by the multipath
device.

So we need to check whether all pgpaths of one multipath have
the same uuid, if not, we should throw a error.

Signed-off-by: Zhiqiang Liu <liuzhiqiang26@huawei.com>
Signed-off-by: lixiaokeng <lixiaokeng@huawei.com>
Signed-off-by: linfeilong <linfeilong@huawei.com>
Signed-off-by: Wubo <wubo40@huawei.com>
---
 drivers/md/dm-mpath.c   | 52 +++++++++++++++++++++++++++++++++++++++++
 drivers/scsi/scsi_lib.c |  1 +
 2 files changed, 53 insertions(+)

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index bced42f082b0..f0b995784b53 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -24,6 +24,7 @@
 #include <linux/workqueue.h>
 #include <linux/delay.h>
 #include <scsi/scsi_dh.h>
+#include <linux/dm-ioctl.h>
 #include <linux/atomic.h>
 #include <linux/blk-mq.h>

@@ -1169,6 +1170,45 @@ static int parse_features(struct dm_arg_set *as, struct multipath *m)
 	return r;
 }

+#define SCSI_VPD_LUN_ID_PREFIX_LEN 4
+#define MPATH_UUID_PREFIX_LEN 7
+static int check_pg_uuid(struct priority_group *pg, char *md_uuid)
+{
+	char pgpath_uuid[DM_UUID_LEN] = {0};
+	struct request_queue *q;
+	struct pgpath *pgpath;
+	struct scsi_device *sdev;
+	ssize_t count;
+	int r = 0;
+
+	list_for_each_entry(pgpath, &pg->pgpaths, list) {
+		q = bdev_get_queue(pgpath->path.dev->bdev);
+		sdev = scsi_device_from_queue(q);
+		if (!sdev) {
+			r = -EINVAL;
+			goto out;
+		}
+
+		count = scsi_vpd_lun_id(sdev, pgpath_uuid, DM_UUID_LEN);
+		if (count <= SCSI_VPD_LUN_ID_PREFIX_LEN) {
+			r = -EINVAL;
+			put_device(&sdev->sdev_gendev);
+			goto out;
+		}
+
+		if (strcmp(md_uuid + MPATH_UUID_PREFIX_LEN,
+			   pgpath_uuid + SCSI_VPD_LUN_ID_PREFIX_LEN)) {
+			r = -EINVAL;
+			put_device(&sdev->sdev_gendev);
+			goto out;
+		}
+		put_device(&sdev->sdev_gendev);
+	}
+
+out:
+	return r;
+}
+
 static int multipath_ctr(struct dm_target *ti, unsigned argc, char **argv)
 {
 	/* target arguments */
@@ -1183,6 +1223,7 @@ static int multipath_ctr(struct dm_target *ti, unsigned argc, char **argv)
 	unsigned pg_count = 0;
 	unsigned next_pg_num;
 	unsigned long flags;
+	char md_uuid[DM_UUID_LEN] = {0};

 	as.argc = argc;
 	as.argv = argv;
@@ -1220,6 +1261,11 @@ static int multipath_ctr(struct dm_target *ti, unsigned argc, char **argv)
 		goto bad;
 	}

+	if (dm_copy_name_and_uuid(dm_table_get_md(ti->table), NULL, md_uuid)) {
+		r = -ENXIO;
+		goto bad;
+	}
+
 	/* parse the priority groups */
 	while (as.argc) {
 		struct priority_group *pg;
@@ -1231,6 +1277,12 @@ static int multipath_ctr(struct dm_target *ti, unsigned argc, char **argv)
 			goto bad;
 		}

+		if (check_pg_uuid(pg, md_uuid)) {
+			ti->error = "uuid of pgpaths mismatch";
+			r = -EINVAL;
+			goto bad;
+		}
+
 		nr_valid_paths += pg->nr_pgpaths;
 		atomic_set(&m->nr_valid_paths, nr_valid_paths);

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 7d52a11e1b61..fee82262a227 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1953,6 +1953,7 @@ struct scsi_device *scsi_device_from_queue(struct request_queue *q)

 	return sdev;
 }
+EXPORT_SYMBOL(scsi_device_from_queue);

 /**
  * scsi_block_requests - Utility function used by low-level drivers to prevent
-- 
2.19.1


