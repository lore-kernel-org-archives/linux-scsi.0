Return-Path: <SRS0=/OAa=YS=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D18ACA9EBE
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Oct 2019 16:13:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E473C2053B
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Oct 2019 16:13:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2505248AbfJYQNJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 25 Oct 2019 12:13:09 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:14242 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2504292AbfJYQNB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 25 Oct 2019 12:13:01 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x9PG8vK8070155
        for <linux-scsi@vger.kernel.org>; Fri, 25 Oct 2019 12:13:00 -0400
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2vv46t0fec-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Fri, 25 Oct 2019 12:13:00 -0400
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <bblock@linux.ibm.com>;
        Fri, 25 Oct 2019 17:12:58 +0100
Received: from b06cxnps4074.portsmouth.uk.ibm.com (9.149.109.196)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 25 Oct 2019 17:12:56 +0100
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x9PGCsll39190618
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Oct 2019 16:12:54 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6789DAE051;
        Fri, 25 Oct 2019 16:12:54 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 460C6AE045;
        Fri, 25 Oct 2019 16:12:54 +0000 (GMT)
Received: from t480-pf1aa2c2 (unknown [9.152.212.148])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Fri, 25 Oct 2019 16:12:54 +0000 (GMT)
Received: from bblock by t480-pf1aa2c2 with local (Exim 4.92.3)
        (envelope-from <bblock@linux.ibm.com>)
        id 1iO2Cr-00074a-Vk; Fri, 25 Oct 2019 18:12:53 +0200
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
Subject: [PATCH v2 06/11] zfcp: implicitly refresh port-data diagnostics when reading SysFS
Date:   Fri, 25 Oct 2019 18:12:48 +0200
X-Mailer: git-send-email 2.21.0
In-Reply-To: <cover.1571934247.git.bblock@linux.ibm.com>
References: <cover.1571934247.git.bblock@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19102516-0012-0000-0000-0000035D96AD
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19102516-0013-0000-0000-00002198CDF5
Message-Id: <c145b5cfc99a63b6a018b1184fbd27bb09c955f5.1572018132.git.bblock@linux.ibm.com>
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

This patch adds implicit updates to the SysFS entries that read the
diagnostic data stored in the "caching buffer" for Exchange Port Data.

An update is triggered once the buffer is older than ZFCP_DIAG_MAX_AGE
milliseconds (5s). This entails sending an Exchange Port Data command to
the FCP-Channel, and during its ingress path updating the cached data
and the timestamp. To prevent multiple concurrent userspace-applications
from triggering this update in parallel we synchronize all of them using
a wait-queue (waiting threads are interruptible; the updating thread is
not).

Reviewed-by: Steffen Maier <maier@linux.ibm.com>
Signed-off-by: Benjamin Block <bblock@linux.ibm.com>
---
 drivers/s390/scsi/zfcp_diag.c  | 129 +++++++++++++++++++++++++++++++++
 drivers/s390/scsi/zfcp_diag.h  |  11 +++
 drivers/s390/scsi/zfcp_sysfs.c |   5 ++
 3 files changed, 145 insertions(+)

diff --git a/drivers/s390/scsi/zfcp_diag.c b/drivers/s390/scsi/zfcp_diag.c
index 8df3ace6135d..9c5a0f3431ca 100644
--- a/drivers/s390/scsi/zfcp_diag.c
+++ b/drivers/s390/scsi/zfcp_diag.c
@@ -22,6 +22,8 @@
 /* Max age of data in a diagnostics buffer before it needs a refresh (in ms). */
 #define ZFCP_DIAG_MAX_AGE (5 * 1000)
 
+static DECLARE_WAIT_QUEUE_HEAD(__zfcp_diag_publish_wait);
+
 /**
  * zfcp_diag_adapter_setup() - Setup storage for adapter diagnostics.
  * @adapter: the adapter to setup diagnostics for.
@@ -143,3 +145,130 @@ void zfcp_diag_update_xdata(struct zfcp_diag_header *const hdr,
 out:
 	spin_unlock_irqrestore(&hdr->access_lock, flags);
 }
+
+/**
+ * zfcp_diag_update_port_data_buffer() - Implementation of
+ *					 &typedef zfcp_diag_update_buffer_func
+ *					 to collect and update Port Data.
+ * @adapter: Adapter to collect Port Data from.
+ *
+ * This call is SYNCHRONOUS ! It blocks till the respective command has
+ * finished completely, or has failed in some way.
+ *
+ * Return:
+ * * 0		- Successfully retrieved new Diagnostics and Updated the buffer;
+ *		  this also includes cases where data was retrieved, but
+ *		  incomplete; you'll have to check the flag ``incomplete``
+ *		  of &struct zfcp_diag_header.
+ * * see zfcp_fsf_exchange_port_data_sync() for possible error-codes (
+ *   excluding -EAGAIN)
+ */
+int zfcp_diag_update_port_data_buffer(struct zfcp_adapter *const adapter)
+{
+	int rc;
+
+	rc = zfcp_fsf_exchange_port_data_sync(adapter->qdio, NULL);
+	if (rc == -EAGAIN)
+		rc = 0; /* signaling incomplete via struct zfcp_diag_header */
+
+	/* buffer-data was updated in zfcp_fsf_exchange_port_data_handler() */
+
+	return rc;
+}
+
+static int __zfcp_diag_update_buffer(struct zfcp_adapter *const adapter,
+				     struct zfcp_diag_header *const hdr,
+				     zfcp_diag_update_buffer_func buffer_update,
+				     unsigned long *const flags)
+	__must_hold(hdr->access_lock)
+{
+	int rc;
+
+	if (hdr->updating == 1) {
+		rc = wait_event_interruptible_lock_irq(__zfcp_diag_publish_wait,
+						       hdr->updating == 0,
+						       hdr->access_lock);
+		rc = (rc == 0 ? -EAGAIN : -EINTR);
+	} else {
+		hdr->updating = 1;
+		spin_unlock_irqrestore(&hdr->access_lock, *flags);
+
+		/* unlocked, because update function sleeps */
+		rc = buffer_update(adapter);
+
+		spin_lock_irqsave(&hdr->access_lock, *flags);
+		hdr->updating = 0;
+
+		/*
+		 * every thread waiting here went via an interruptible wait,
+		 * so its fine to only wake those
+		 */
+		wake_up_interruptible_all(&__zfcp_diag_publish_wait);
+	}
+
+	return rc;
+}
+
+static bool
+__zfcp_diag_test_buffer_age_isfresh(const struct zfcp_diag_header *const hdr)
+	__must_hold(hdr->access_lock)
+{
+	const unsigned long now = jiffies;
+
+	/*
+	 * Should not happen (data is from the future).. if it does, still
+	 * signal that it needs refresh
+	 */
+	if (!time_after_eq(now, hdr->timestamp))
+		return false;
+
+	if (jiffies_to_msecs(now - hdr->timestamp) >= ZFCP_DIAG_MAX_AGE)
+		return false;
+
+	return true;
+}
+
+/**
+ * zfcp_diag_update_buffer_limited() - Collect diagnostics and update a
+ *				       diagnostics buffer rate limited.
+ * @adapter: Adapter to collect the diagnostics from.
+ * @hdr: buffer-header for which to update with the collected diagnostics.
+ * @buffer_update: Specific implementation for collecting and updating.
+ *
+ * This function will cause an update of the given @hdr by calling the also
+ * given @buffer_update function. If called by multiple sources at the same
+ * time, it will synchornize the update by only allowing one source to call
+ * @buffer_update and the others to wait for that source to complete instead
+ * (the wait is interruptible).
+ *
+ * Additionally this version is rate-limited and will only exit if either the
+ * buffer is fresh enough (within the limit) - it will do nothing if the buffer
+ * is fresh enough to begin with -, or if the source/thread that started this
+ * update is the one that made the update (to prevent endless loops).
+ *
+ * Return:
+ * * 0		- If the update was successfully published and/or the buffer is
+ *		  fresh enough
+ * * -EINTR	- If the thread went into the wait-state and was interrupted
+ * * whatever @buffer_update returns
+ */
+int zfcp_diag_update_buffer_limited(struct zfcp_adapter *const adapter,
+				    struct zfcp_diag_header *const hdr,
+				    zfcp_diag_update_buffer_func buffer_update)
+{
+	unsigned long flags;
+	int rc;
+
+	spin_lock_irqsave(&hdr->access_lock, flags);
+
+	for (rc = 0; !__zfcp_diag_test_buffer_age_isfresh(hdr); rc = 0) {
+		rc = __zfcp_diag_update_buffer(adapter, hdr, buffer_update,
+					       &flags);
+		if (rc != -EAGAIN)
+			break;
+	}
+
+	spin_unlock_irqrestore(&hdr->access_lock, flags);
+
+	return rc;
+}
diff --git a/drivers/s390/scsi/zfcp_diag.h b/drivers/s390/scsi/zfcp_diag.h
index 2deebccda17d..7ff8fb0bb735 100644
--- a/drivers/s390/scsi/zfcp_diag.h
+++ b/drivers/s390/scsi/zfcp_diag.h
@@ -71,6 +71,17 @@ void zfcp_diag_sysfs_destroy(struct zfcp_adapter *const adapter);
 void zfcp_diag_update_xdata(struct zfcp_diag_header *const hdr,
 			    const void *const data, const bool incomplete);
 
+/*
+ * Function-Type used in zfcp_diag_update_buffer_limited() for the function
+ * that does the buffer-implementation dependent work.
+ */
+typedef int (*zfcp_diag_update_buffer_func)(struct zfcp_adapter *const adapter);
+
+int zfcp_diag_update_port_data_buffer(struct zfcp_adapter *const adapter);
+int zfcp_diag_update_buffer_limited(struct zfcp_adapter *const adapter,
+				    struct zfcp_diag_header *const hdr,
+				    zfcp_diag_update_buffer_func buffer_update);
+
 /**
  * zfcp_diag_support_sfp() - Return %true if the @adapter supports reporting
  *			     SFP Data.
diff --git a/drivers/s390/scsi/zfcp_sysfs.c b/drivers/s390/scsi/zfcp_sysfs.c
index 6c0cea71ae5d..a2fa3db5695d 100644
--- a/drivers/s390/scsi/zfcp_sysfs.c
+++ b/drivers/s390/scsi/zfcp_sysfs.c
@@ -693,6 +693,11 @@ struct device_attribute *zfcp_sysfs_shost_attrs[] = {
 									       \
 		diag_hdr = &adapter->diagnostics->port_data.header;	       \
 									       \
+		rc = zfcp_diag_update_buffer_limited(			       \
+			adapter, diag_hdr, zfcp_diag_update_port_data_buffer); \
+		if (rc != 0)						       \
+			goto out;					       \
+									       \
 		spin_lock_irqsave(&diag_hdr->access_lock, flags);	       \
 		rc = scnprintf(						       \
 			buf, (_prtsize) + 2, _prtfmt "\n",		       \
-- 
2.21.0

