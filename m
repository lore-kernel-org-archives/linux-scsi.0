Return-Path: <SRS0=/OAa=YS=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1297CCA9EA0
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Oct 2019 16:13:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D8DBB2070B
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Oct 2019 16:13:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2505233AbfJYQNH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 25 Oct 2019 12:13:07 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:33914 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732660AbfJYQNB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 25 Oct 2019 12:13:01 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x9PG9hKP029304
        for <linux-scsi@vger.kernel.org>; Fri, 25 Oct 2019 12:12:59 -0400
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2vv1ua693a-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Fri, 25 Oct 2019 12:12:59 -0400
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <bblock@linux.ibm.com>;
        Fri, 25 Oct 2019 17:12:57 +0100
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 25 Oct 2019 17:12:56 +0100
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x9PGCsm738535414
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Oct 2019 16:12:54 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5FDDB11C05E;
        Fri, 25 Oct 2019 16:12:54 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4CC9011C04C;
        Fri, 25 Oct 2019 16:12:54 +0000 (GMT)
Received: from t480-pf1aa2c2 (unknown [9.152.212.148])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Fri, 25 Oct 2019 16:12:54 +0000 (GMT)
Received: from bblock by t480-pf1aa2c2 with local (Exim 4.92.3)
        (envelope-from <bblock@linux.ibm.com>)
        id 1iO2Cs-00074p-1f; Fri, 25 Oct 2019 18:12:54 +0200
From:   Benjamin Block <bblock@linux.ibm.com>
To:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Benjamin Block <bblock@linux.ibm.com>,
        Steffen Maier <maier@linux.ibm.com>,
        Jens Remus <jremus@linux.ibm.com>,
        Fedor Loshakov <loshakov@linux.ibm.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [PATCH v2 09/11] zfcp: move maximum age of diagnostic buffers into a per-adapter variable
Date:   Fri, 25 Oct 2019 18:12:51 +0200
X-Mailer: git-send-email 2.21.0
In-Reply-To: <cover.1571934247.git.bblock@linux.ibm.com>
References: <cover.1571934247.git.bblock@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19102516-0012-0000-0000-0000035D96AC
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19102516-0013-0000-0000-00002198CDF3
Message-Id: <b1d0977cc884b16dd4ca6418e4320c56a4c31d63.1572018132.git.bblock@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-10-25_08:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1910250148
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Replace the static define (ZFCP_DIAG_MAX_AGE) with a per-adapter
variable (${adapter}->diagnostics->max_age). This new variable is
exported via SysFS, along with other, already existing adapter
variables, and can both be read and written. This way users can choose
how much time should pass between refreshes of diagnostic buffers. The
default value for the age remains to be five seconds.

By setting this new variable to 0, the caching of diagnostic buffers for
userspace accesses can also be completely removed.

All diagnostic buffers of a given adapter are subject to this setting in
the same way.

Reviewed-by: Steffen Maier <maier@linux.ibm.com>
Signed-off-by: Benjamin Block <bblock@linux.ibm.com>
---
 drivers/s390/scsi/zfcp_diag.c  | 23 ++++++++---------
 drivers/s390/scsi/zfcp_diag.h  |  4 +++
 drivers/s390/scsi/zfcp_sysfs.c | 45 ++++++++++++++++++++++++++++++++++
 3 files changed, 61 insertions(+), 11 deletions(-)

diff --git a/drivers/s390/scsi/zfcp_diag.c b/drivers/s390/scsi/zfcp_diag.c
index 5ef7b3288c6f..67a8f4e57db1 100644
--- a/drivers/s390/scsi/zfcp_diag.c
+++ b/drivers/s390/scsi/zfcp_diag.c
@@ -19,9 +19,6 @@
 #include "zfcp_ext.h"
 #include "zfcp_def.h"
 
-/* Max age of data in a diagnostics buffer before it needs a refresh (in ms). */
-#define ZFCP_DIAG_MAX_AGE (5 * 1000)
-
 static DECLARE_WAIT_QUEUE_HEAD(__zfcp_diag_publish_wait);
 
 /**
@@ -38,9 +35,6 @@ static DECLARE_WAIT_QUEUE_HEAD(__zfcp_diag_publish_wait);
  */
 int zfcp_diag_adapter_setup(struct zfcp_adapter *const adapter)
 {
-	/* set the timestamp so that the first test on age will always fail */
-	const unsigned long initial_timestamp =
-		jiffies - msecs_to_jiffies(ZFCP_DIAG_MAX_AGE);
 	struct zfcp_diag_adapter *diag;
 	struct zfcp_diag_header *hdr;
 
@@ -48,13 +42,16 @@ int zfcp_diag_adapter_setup(struct zfcp_adapter *const adapter)
 	if (diag == NULL)
 		return -ENOMEM;
 
+	diag->max_age = (5 * 1000); /* default value: 5 s */
+
 	/* setup header for port_data */
 	hdr = &diag->port_data.header;
 
 	spin_lock_init(&hdr->access_lock);
 	hdr->buffer = &diag->port_data.data;
 	hdr->buffer_size = sizeof(diag->port_data.data);
-	hdr->timestamp = initial_timestamp;
+	/* set the timestamp so that the first test on age will always fail */
+	hdr->timestamp = jiffies - msecs_to_jiffies(diag->max_age);
 
 	/* setup header for config_data */
 	hdr = &diag->config_data.header;
@@ -62,7 +59,8 @@ int zfcp_diag_adapter_setup(struct zfcp_adapter *const adapter)
 	spin_lock_init(&hdr->access_lock);
 	hdr->buffer = &diag->config_data.data;
 	hdr->buffer_size = sizeof(diag->config_data.data);
-	hdr->timestamp = initial_timestamp;
+	/* set the timestamp so that the first test on age will always fail */
+	hdr->timestamp = jiffies - msecs_to_jiffies(diag->max_age);
 
 	adapter->diagnostics = diag;
 	return 0;
@@ -240,7 +238,8 @@ static int __zfcp_diag_update_buffer(struct zfcp_adapter *const adapter,
 }
 
 static bool
-__zfcp_diag_test_buffer_age_isfresh(const struct zfcp_diag_header *const hdr)
+__zfcp_diag_test_buffer_age_isfresh(const struct zfcp_diag_adapter *const diag,
+				    const struct zfcp_diag_header *const hdr)
 	__must_hold(hdr->access_lock)
 {
 	const unsigned long now = jiffies;
@@ -252,7 +251,7 @@ __zfcp_diag_test_buffer_age_isfresh(const struct zfcp_diag_header *const hdr)
 	if (!time_after_eq(now, hdr->timestamp))
 		return false;
 
-	if (jiffies_to_msecs(now - hdr->timestamp) >= ZFCP_DIAG_MAX_AGE)
+	if (jiffies_to_msecs(now - hdr->timestamp) >= diag->max_age)
 		return false;
 
 	return true;
@@ -291,7 +290,9 @@ int zfcp_diag_update_buffer_limited(struct zfcp_adapter *const adapter,
 
 	spin_lock_irqsave(&hdr->access_lock, flags);
 
-	for (rc = 0; !__zfcp_diag_test_buffer_age_isfresh(hdr); rc = 0) {
+	for (rc = 0;
+	     !__zfcp_diag_test_buffer_age_isfresh(adapter->diagnostics, hdr);
+	     rc = 0) {
 		rc = __zfcp_diag_update_buffer(adapter, hdr, buffer_update,
 					       &flags);
 		if (rc != -EAGAIN)
diff --git a/drivers/s390/scsi/zfcp_diag.h b/drivers/s390/scsi/zfcp_diag.h
index cf2947cd8c8f..b9c93d15f67c 100644
--- a/drivers/s390/scsi/zfcp_diag.h
+++ b/drivers/s390/scsi/zfcp_diag.h
@@ -42,6 +42,8 @@ struct zfcp_diag_header {
  *			      adapter.
  * @sysfs_established: flag showing that the associated sysfs-group was created
  *		       during run of zfcp_adapter_enqueue().
+ * @max_age: maximum age of data in diagnostic buffers before they need to be
+ *	     refreshed (in ms).
  * @port_data: data retrieved using exchange port data.
  * @port_data.header: header with metadata for the cache in @port_data.data.
  * @port_data.data: cached QTCB Bottom of command exchange port data.
@@ -52,6 +54,8 @@ struct zfcp_diag_header {
 struct zfcp_diag_adapter {
 	u64	sysfs_established	:1;
 
+	unsigned long	max_age;
+
 	struct {
 		struct zfcp_diag_header		header;
 		struct fsf_qtcb_bottom_port	data;
diff --git a/drivers/s390/scsi/zfcp_sysfs.c b/drivers/s390/scsi/zfcp_sysfs.c
index ae8e9137f448..494b9fe9cc94 100644
--- a/drivers/s390/scsi/zfcp_sysfs.c
+++ b/drivers/s390/scsi/zfcp_sysfs.c
@@ -326,6 +326,50 @@ static ssize_t zfcp_sysfs_port_remove_store(struct device *dev,
 static ZFCP_DEV_ATTR(adapter, port_remove, S_IWUSR, NULL,
 		     zfcp_sysfs_port_remove_store);
 
+static ssize_t
+zfcp_sysfs_adapter_diag_max_age_show(struct device *dev,
+				     struct device_attribute *attr, char *buf)
+{
+	struct zfcp_adapter *adapter = zfcp_ccw_adapter_by_cdev(to_ccwdev(dev));
+	ssize_t rc;
+
+	if (!adapter)
+		return -ENODEV;
+
+	/* ceil(log(2^64 - 1) / log(10)) = 20 */
+	rc = scnprintf(buf, 20 + 2, "%lu\n", adapter->diagnostics->max_age);
+
+	zfcp_ccw_adapter_put(adapter);
+	return rc;
+}
+
+static ssize_t
+zfcp_sysfs_adapter_diag_max_age_store(struct device *dev,
+				      struct device_attribute *attr,
+				      const char *buf, size_t count)
+{
+	struct zfcp_adapter *adapter = zfcp_ccw_adapter_by_cdev(to_ccwdev(dev));
+	unsigned long max_age;
+	ssize_t rc;
+
+	if (!adapter)
+		return -ENODEV;
+
+	rc = kstrtoul(buf, 10, &max_age);
+	if (rc != 0)
+		goto out;
+
+	adapter->diagnostics->max_age = max_age;
+
+	rc = count;
+out:
+	zfcp_ccw_adapter_put(adapter);
+	return rc;
+}
+static ZFCP_DEV_ATTR(adapter, diag_max_age, 0644,
+		     zfcp_sysfs_adapter_diag_max_age_show,
+		     zfcp_sysfs_adapter_diag_max_age_store);
+
 static struct attribute *zfcp_adapter_attrs[] = {
 	&dev_attr_adapter_failed.attr,
 	&dev_attr_adapter_in_recovery.attr,
@@ -338,6 +382,7 @@ static struct attribute *zfcp_adapter_attrs[] = {
 	&dev_attr_adapter_lic_version.attr,
 	&dev_attr_adapter_status.attr,
 	&dev_attr_adapter_hardware_version.attr,
+	&dev_attr_adapter_diag_max_age.attr,
 	NULL
 };
 
-- 
2.21.0

