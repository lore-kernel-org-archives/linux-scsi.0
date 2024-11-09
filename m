Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09FCE13B280
	for <linux-scsi@vger.kernel.org>; Sat,  9 Nov 2024 04:45:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731127534; cv=none; b=BxZooyOd7PrDvJ/W1ug22VF3FsOO71SkCcfJvCUPEn7VQq4WyNM8cX3vJf2YYn0LE1/3nNLekuqs55oqNp12Ilfqh4JnkzMFDONMPFjHJcQon1zPWmsjmDr4AN7E/mIRpo/q6SOMdbrsHDvpETOB76pDYmtQR/OW8tmGPti8SUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731127534; c=relaxed/simple;
	bh=D5d93k89D+QZyzNGgsaNrH7jQApOu6qGK3BqX6iHGeU=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IFuDy4z5vrABu/4qq22B752bvdShB1gBiLgX8Qzm6R8dJpQjErHLBS1IDyhIyj1Xo11L6mr8hHef2QwQDc168QDVlTEnUMwiCnzo1JTQn5Te8o9jK7l7neELCS6yX0EXle6/drIj3YnVjutINAaSpguplJH7JMFSgrDfQpDZmHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ArRwitL1; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ArRwitL1"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4A94PdN2005286
	for <linux-scsi@vger.kernel.org>; Sat, 9 Nov 2024 04:45:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2023-11-20; bh=twXep
	2c6powMlcxmqDfgQi+ZEuHOdb/wN3zCSA1rAPQ=; b=ArRwitL1V0gaDsuyONCZ6
	hyYDth1RLmSmoOpCTEG8OqIcT5icOVBSWdtVDypGjTj7ejqELGmXY4YrYBOdqNf+
	LjDhXh+RD85YdfQ5Bnj29OIjTQ1qSpe6BCE0OeUpN/u38w4O3tO7W6YBYQ4JQZwj
	05jU8O6LFKDQdfKN8k/zZKudcsB9LbtG3fQF0iHQxzDgE2CQMZz9gYsx4eANei/m
	/tGHFAREmsIwdSqpLvETVVm+FJcWoGsXArC1DpLOmOBft6mTy4bHW91wQF+bAltH
	p+2+RQeAgmrT9YcuJ1hc4qQjyXRrjz5Mf70kHt2NPEodMXObtZGdLBYKzpt3nhFu
	Q==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42t0heg0bb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Sat, 09 Nov 2024 04:45:31 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4A91Xe3Z034332
	for <linux-scsi@vger.kernel.org>; Sat, 9 Nov 2024 04:45:31 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 42sx65aja8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Sat, 09 Nov 2024 04:45:30 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 4A94jTdW001575
	for <linux-scsi@vger.kernel.org>; Sat, 9 Nov 2024 04:45:30 GMT
Received: from hmadhani-upstream.osdevelopmeniad.oraclevcn.com (hmadhani-upstream.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.255.48])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 42sx65aj9h-6;
	Sat, 09 Nov 2024 04:45:30 +0000
From: himanshu.madhani@oracle.com
To: martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Subject: [RFC v1 5/8] scsi: Add scsi multipath sysfs hooks
Date: Sat,  9 Nov 2024 04:45:26 +0000
Message-ID: <20241109044529.992935-6-himanshu.madhani@oracle.com>
X-Mailer: git-send-email 2.41.0.rc2
In-Reply-To: <20241109044529.992935-1-himanshu.madhani@oracle.com>
References: <20241109044529.992935-1-himanshu.madhani@oracle.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-11-09_03,2024-11-08_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 adultscore=0 phishscore=0 bulkscore=0 suspectscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2409260000 definitions=main-2411090036
X-Proofpoint-ORIG-GUID: -IUXNJVmxdj7XlHpNvwlJQOgpR9r6loH
X-Proofpoint-GUID: -IUXNJVmxdj7XlHpNvwlJQOgpR9r6loH

From: Himanshu Madhani <himanshu.madhani@oracle.com>

Add Sysfs hook to
- Show current multipath state
- Show and update multipath iopolicy

Signed-off-by: Himanshu Madhani <himanshu.madhani@oracle.com>
---
 drivers/scsi/scsi_sysfs.c | 104 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 104 insertions(+)

diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 32f94db6d6bf..cc7dc5c30d2c 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -1198,6 +1198,103 @@ sdev_show_preferred_path(struct device *dev,
 static DEVICE_ATTR(preferred_path, S_IRUGO, sdev_show_preferred_path, NULL);
 #endif
 
+#ifdef CONFIG_SCSI_MULTIPATH
+static const struct {
+	unsigned char	value;
+	char		*name;
+} scsi_multipath_iopolicy[] = {
+	{ SCSI_MPATH_IOPOLICY_NUMA, "NUMA" },
+	{ SCSI_MPATH_IOPOLICY_RR, "Round-Robin" },
+};
+static const char *scsi_mpath_policy_name(unsigned char policy)
+{
+	int i;
+	char *name = NULL;
+
+	for (i = 0; i < ARRAY_SIZE(scsi_multipath_iopolicy); i++) {
+		if (scsi_multipath_iopolicy[i].value == policy) {
+			name = scsi_multipath_iopolicy[i].name;
+			break;
+		}
+	}
+	return name;
+}
+
+static ssize_t
+sdev_show_multipath_iopolicy(struct device *dev,
+			     struct device_attribute *attr,
+			     char *buf)
+{
+	struct scsi_device *sdev = to_scsi_device(dev);
+	const char *name = scsi_mpath_policy_name(sdev->mpath_iopolicy);
+
+	if (!sdev->mpath_disk)
+		return -EINVAL;
+
+	return sysfs_emit(buf, "%s\n", name);
+}
+
+static ssize_t sdev_store_multipath_iopolicy(struct device *dev,
+    struct device_attribute *attr, const char *buf, size_t count)
+{
+	struct scsi_device *sdev = to_scsi_device(dev);
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(scsi_multipath_iopolicy); i++) {
+		if (sysfs_streq(buf, scsi_mpath_policy_name(i))) {
+			scsi_multipath_iopolicy_update(sdev, i);
+			return count;
+		}
+	}
+
+	return -EINVAL;
+}
+static DEVICE_ATTR(multipath_iopolicy, S_IRUGO, sdev_show_multipath_iopolicy,
+    sdev_store_multipath_iopolicy);
+
+static const struct {
+	unsigned char	value;
+	char		*name;
+} scsi_mpath_states[] = {
+	{ SCSI_MPATH_OPTIMAL,	"active/optimized" },
+	{ SCSI_MPATH_ACTIVE,	"active/non-optimized" },
+	{ SCSI_MPATH_STANDBY,	"standby" },
+	{ SCSI_MPATH_UNAVAILABLE,"unavailable" },
+	{ SCSI_MPATH_LBA,	"lba-dependent" },
+	{ SCSI_MPATH_OFFLINE,	"offline" },
+	{ SCSI_MPATH_TRANSITIONING,"transitioning" },
+};
+
+static const char *scsi_mpath_state_names(unsigned char state)
+{
+	int i;
+	char *name = NULL;
+
+	for (i = 0; i < ARRAY_SIZE(scsi_mpath_states); i++) {
+		if (scsi_mpath_states[i].value == state) {
+		    name = scsi_mpath_states[i].name;
+		    break;
+		}
+	}
+	return name;
+}
+
+static ssize_t
+sdev_show_multipath_state(struct device *dev,
+			  struct device_attribute *attr,
+			  char *buf)
+{
+	struct scsi_device *sdev = to_scsi_device(dev);
+	const char *name = scsi_mpath_state_names(sdev->mpath_state);
+
+	if (!sdev->mpath_disk)
+		return -EINVAL;
+
+	return sysfs_emit(buf, "%s\n", name);
+}
+static DEVICE_ATTR(multipath_state, S_IRUGO, sdev_show_multipath_state, NULL);
+#endif
+
 static ssize_t
 sdev_show_queue_ramp_up_period(struct device *dev,
 			       struct device_attribute *attr,
@@ -1335,6 +1432,10 @@ static struct attribute *scsi_sdev_attrs[] = {
 	&dev_attr_dh_state.attr,
 	&dev_attr_access_state.attr,
 	&dev_attr_preferred_path.attr,
+#endif
+#ifdef CONFIG_SCSI_MULTIPATH
+	&dev_attr_multipath_iopolicy.attr,
+	&dev_attr_multipath_state.attr,
 #endif
 	&dev_attr_queue_ramp_up_period.attr,
 	&dev_attr_cdl_supported.attr,
@@ -1500,6 +1601,9 @@ void __scsi_remove_device(struct scsi_device *sdev)
 	} else
 		put_device(&sdev->sdev_dev);
 
+	if (scsi_is_sdev_multipath(sdev))
+		scsi_mpath_dev_release(sdev);
+
 	/*
 	 * Stop accepting new requests and wait until all queuecommand() and
 	 * scsi_run_queue() invocations have finished before tearing down the
-- 
2.41.0.rc2

