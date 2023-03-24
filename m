Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAD83C6FD1C
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Mar 2023 18:20:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232020AbjCXSUT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 24 Mar 2023 14:20:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231839AbjCXSUO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Mar 2023 14:20:14 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FF4C1F935;
        Fri, 24 Mar 2023 11:20:13 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32OI4tI3002258;
        Fri, 24 Mar 2023 18:18:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2022-7-12;
 bh=dHmmYvbYKfRvWLLY2b49fpKD4kMlliQIKpBAmzsZNWw=;
 b=i2E7mnyJeyhn4QzT1w2U2+tJJojgOvQ57a8YVjlQdy9Y7J8OEwN6dzn3UGW3NuQsGnf8
 UDt7hzh1AjGT4fa1unyLwJNdhQq31DlVNU+bHKJDE/Z/Pt8pF1ZmVhI/E0ERorTi8v4D
 9MtBAue6za6nLnTQoXwOjHH4+SpDGzDcN0z5gkBNgb2y6E2cRWEvxsHldtxhGOg8uET/
 XGHYosTCpoi/w07dKPDrFy0YFBhUBcVqJo1lGT3J8SMl3RtkjicJDYfZSnIcxFKDJIIL
 fs9deSDnv95PiJhbCATvAPMqklTFcMcF6sMVqPU1aptPnpwwA5bDwMh8RlFkNMupx/43 HQ== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3phgtr80wq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Mar 2023 18:18:00 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 32OGThGe001264;
        Fri, 24 Mar 2023 18:17:59 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3pgxk4bx9n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Mar 2023 18:17:59 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32OIHiEV021017;
        Fri, 24 Mar 2023 18:17:59 GMT
Received: from mnchrist-mac.us.oracle.com (dhcp-10-154-153-54.vpn.oracle.com [10.154.153.54])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3pgxk4bx19-7;
        Fri, 24 Mar 2023 18:17:59 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, hch@lst.de, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com,
        linux-block@vger.kernel.org, dm-devel@redhat.com,
        snitzer@kernel.org, axboe@kernel.dk,
        linux-nvme@lists.infradead.org, chaitanyak@nvidia.com,
        kbusch@kernel.org, target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v5 06/18] dm: Add support for block PR read keys/reservation
Date:   Fri, 24 Mar 2023 13:17:29 -0500
Message-Id: <20230324181741.13908-7-michael.christie@oracle.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230324181741.13908-1-michael.christie@oracle.com>
References: <20230324181741.13908-1-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-24_11,2023-03-24_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 mlxlogscore=999 spamscore=0 adultscore=0 bulkscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2303240143
X-Proofpoint-ORIG-GUID: lo8nCVWV4v9FXP0Ceb4i4HzqvTPLG3bs
X-Proofpoint-GUID: lo8nCVWV4v9FXP0Ceb4i4HzqvTPLG3bs
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This adds support in dm for the block PR read keys and read reservation
callouts.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/md/dm.c | 69 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 69 insertions(+)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index f5cc330bb549..51e34e1a16bb 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -3114,6 +3114,8 @@ struct dm_pr {
 	bool	fail_early;
 	int	ret;
 	enum pr_type type;
+	struct pr_keys *read_keys;
+	struct pr_held_reservation *rsv;
 };
 
 static int dm_call_pr(struct block_device *bdev, iterate_devices_callout_fn fn,
@@ -3346,12 +3348,79 @@ static int dm_pr_clear(struct block_device *bdev, u64 key)
 	return r;
 }
 
+static int __dm_pr_read_keys(struct dm_target *ti, struct dm_dev *dev,
+			     sector_t start, sector_t len, void *data)
+{
+	struct dm_pr *pr = data;
+	const struct pr_ops *ops = dev->bdev->bd_disk->fops->pr_ops;
+
+	if (!ops || !ops->pr_read_keys) {
+		pr->ret = -EOPNOTSUPP;
+		return -1;
+	}
+
+	pr->ret = ops->pr_read_keys(dev->bdev, pr->read_keys);
+	if (!pr->ret)
+		return -1;
+
+	return 0;
+}
+
+static int dm_pr_read_keys(struct block_device *bdev, struct pr_keys *keys)
+{
+	struct dm_pr pr = {
+		.read_keys = keys,
+	};
+	int ret;
+
+	ret = dm_call_pr(bdev, __dm_pr_read_keys, &pr);
+	if (ret)
+		return ret;
+
+	return pr.ret;
+}
+
+static int __dm_pr_read_reservation(struct dm_target *ti, struct dm_dev *dev,
+				    sector_t start, sector_t len, void *data)
+{
+	struct dm_pr *pr = data;
+	const struct pr_ops *ops = dev->bdev->bd_disk->fops->pr_ops;
+
+	if (!ops || !ops->pr_read_reservation) {
+		pr->ret = -EOPNOTSUPP;
+		return -1;
+	}
+
+	pr->ret = ops->pr_read_reservation(dev->bdev, pr->rsv);
+	if (!pr->ret)
+		return -1;
+
+	return 0;
+}
+
+static int dm_pr_read_reservation(struct block_device *bdev,
+				  struct pr_held_reservation *rsv)
+{
+	struct dm_pr pr = {
+		.rsv = rsv,
+	};
+	int ret;
+
+	ret = dm_call_pr(bdev, __dm_pr_read_reservation, &pr);
+	if (ret)
+		return ret;
+
+	return pr.ret;
+}
+
 static const struct pr_ops dm_pr_ops = {
 	.pr_register	= dm_pr_register,
 	.pr_reserve	= dm_pr_reserve,
 	.pr_release	= dm_pr_release,
 	.pr_preempt	= dm_pr_preempt,
 	.pr_clear	= dm_pr_clear,
+	.pr_read_keys	= dm_pr_read_keys,
+	.pr_read_reservation = dm_pr_read_reservation,
 };
 
 static const struct block_device_operations dm_blk_dops = {
-- 
2.25.1

