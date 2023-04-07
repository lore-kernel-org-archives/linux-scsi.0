Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C095DC77B75
	for <linux-scsi@archiver.kernel.org>; Fri,  7 Apr 2023 20:08:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229459AbjDGUIn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 7 Apr 2023 16:08:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229982AbjDGUI2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Apr 2023 16:08:28 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05D2110B;
        Fri,  7 Apr 2023 13:08:26 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 337Fx1rb019789;
        Fri, 7 Apr 2023 20:06:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2022-7-12;
 bh=UaXiRnUvbEv30He/YhYeD9ZGXyi65KZYZn9ZpQm4nCo=;
 b=pgv0cWnMB3cQPINgddDEkWg0aFVx4thK08FJLWxYWdGQr9rINn78k/H41KawhNmif/An
 pK77jaix1Dr50OQrGvv+Wpz55uKDlEMfoH1rQneRcFA1uvL36ebZUxwMKaoDq4MYilQH
 DYPxuImu9qUXblsN9kvXRnMVnIrOttVyDJHhkuO4fxDZmfi9J96hKEmwouV2/QZeAZQ1
 xswF1ugpsLx+xswi56GAn0Fl7TzSWIS1kw8KNRI/As2moaQk+JE1WPtZL2/YN1vos6vj
 z0XR8oTs0lkGjcGiKPmZTpvqGTtfmCG1zyuE2cArREysF6n0eq15GxIKLfaVn8XHCQD1 Gw== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ppbd45w5a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 07 Apr 2023 20:06:12 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 337Iw2C5034229;
        Fri, 7 Apr 2023 20:06:12 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3pptjxeeqn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 07 Apr 2023 20:06:11 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 337K5tr4010228;
        Fri, 7 Apr 2023 20:06:11 GMT
Received: from mnchrist-mac.us.oracle.com (dhcp-10-154-128-1.vpn.oracle.com [10.154.128.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3pptjxeeam-7;
        Fri, 07 Apr 2023 20:06:11 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     bvanassche@acm.org, hch@lst.de, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com,
        linux-block@vger.kernel.org, dm-devel@redhat.com,
        snitzer@kernel.org, axboe@kernel.dk,
        linux-nvme@lists.infradead.org, chaitanyak@nvidia.com,
        kbusch@kernel.org, target-devel@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v6 06/18] dm: Add support for block PR read keys/reservation
Date:   Fri,  7 Apr 2023 15:05:39 -0500
Message-Id: <20230407200551.12660-7-michael.christie@oracle.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230407200551.12660-1-michael.christie@oracle.com>
References: <20230407200551.12660-1-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-07_12,2023-04-06_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0
 phishscore=0 bulkscore=0 mlxscore=0 suspectscore=0 spamscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304070180
X-Proofpoint-ORIG-GUID: h_W7aXW_dOPh0O53ByAJhOel7zPosL3m
X-Proofpoint-GUID: h_W7aXW_dOPh0O53ByAJhOel7zPosL3m
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
index dfde0088147a..b4103cb6eb9a 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -3119,6 +3119,8 @@ struct dm_pr {
 	bool	fail_early;
 	int	ret;
 	enum pr_type type;
+	struct pr_keys *read_keys;
+	struct pr_held_reservation *rsv;
 };
 
 static int dm_call_pr(struct block_device *bdev, iterate_devices_callout_fn fn,
@@ -3351,12 +3353,79 @@ static int dm_pr_clear(struct block_device *bdev, u64 key)
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

