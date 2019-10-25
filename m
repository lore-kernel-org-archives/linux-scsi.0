Return-Path: <SRS0=/OAa=YS=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4347BCA9EBC
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Oct 2019 16:13:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1E8282053B
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Oct 2019 16:13:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2505186AbfJYQNE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 25 Oct 2019 12:13:04 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:50114 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2505157AbfJYQND (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 25 Oct 2019 12:13:03 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x9PG9jlr029417
        for <linux-scsi@vger.kernel.org>; Fri, 25 Oct 2019 12:13:01 -0400
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2vv1ua694k-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Fri, 25 Oct 2019 12:13:01 -0400
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <bblock@linux.ibm.com>;
        Fri, 25 Oct 2019 17:12:59 +0100
Received: from b06cxnps4075.portsmouth.uk.ibm.com (9.149.109.197)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 25 Oct 2019 17:12:56 +0100
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x9PGCseq58261740
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Oct 2019 16:12:54 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 698B6A4054;
        Fri, 25 Oct 2019 16:12:54 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 540D7A4060;
        Fri, 25 Oct 2019 16:12:54 +0000 (GMT)
Received: from t480-pf1aa2c2 (unknown [9.152.212.148])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Fri, 25 Oct 2019 16:12:54 +0000 (GMT)
Received: from bblock by t480-pf1aa2c2 with local (Exim 4.92.3)
        (envelope-from <bblock@linux.ibm.com>)
        id 1iO2Cs-00074k-0x; Fri, 25 Oct 2019 18:12:54 +0200
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
Subject: [PATCH v2 08/11] zfcp: implicitly refresh config-data diagnostics when reading SysFS
Date:   Fri, 25 Oct 2019 18:12:50 +0200
X-Mailer: git-send-email 2.21.0
In-Reply-To: <cover.1571934247.git.bblock@linux.ibm.com>
References: <cover.1571934247.git.bblock@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19102516-0012-0000-0000-0000035D96AB
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19102516-0013-0000-0000-00002198CDF4
Message-Id: <60a94f55f2630b74b468fed5f39880208abb2679.1572018132.git.bblock@linux.ibm.com>
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

Adds implicit updates of cached diagnostics via Exchange Config Data
when reading SysFS attributes interfacing them. Right now this only
affects the new B2B-Credit diagnostic attribute.

This uses the same mechanism previously also used for cached diagnostics
of Exchange Port Data.

Reviewed-by: Steffen Maier <maier@linux.ibm.com>
Signed-off-by: Benjamin Block <bblock@linux.ibm.com>
---
 drivers/s390/scsi/zfcp_diag.c  | 30 ++++++++++++++++++++++++++++++
 drivers/s390/scsi/zfcp_diag.h  |  1 +
 drivers/s390/scsi/zfcp_sysfs.c |  5 +++++
 3 files changed, 36 insertions(+)

diff --git a/drivers/s390/scsi/zfcp_diag.c b/drivers/s390/scsi/zfcp_diag.c
index 9c5a0f3431ca..5ef7b3288c6f 100644
--- a/drivers/s390/scsi/zfcp_diag.c
+++ b/drivers/s390/scsi/zfcp_diag.c
@@ -176,6 +176,36 @@ int zfcp_diag_update_port_data_buffer(struct zfcp_adapter *const adapter)
 	return rc;
 }
 
+/**
+ * zfcp_diag_update_config_data_buffer() - Implementation of
+ *					   &typedef zfcp_diag_update_buffer_func
+ *					   to collect and update Config Data.
+ * @adapter: Adapter to collect Config Data from.
+ *
+ * This call is SYNCHRONOUS ! It blocks till the respective command has
+ * finished completely, or has failed in some way.
+ *
+ * Return:
+ * * 0		- Successfully retrieved new Diagnostics and Updated the buffer;
+ *		  this also includes cases where data was retrieved, but
+ *		  incomplete; you'll have to check the flag ``incomplete``
+ *		  of &struct zfcp_diag_header.
+ * * see zfcp_fsf_exchange_config_data_sync() for possible error-codes (
+ *   excluding -EAGAIN)
+ */
+int zfcp_diag_update_config_data_buffer(struct zfcp_adapter *const adapter)
+{
+	int rc;
+
+	rc = zfcp_fsf_exchange_config_data_sync(adapter->qdio, NULL);
+	if (rc == -EAGAIN)
+		rc = 0; /* signaling incomplete via struct zfcp_diag_header */
+
+	/* buffer-data was updated in zfcp_fsf_exchange_config_data_handler() */
+
+	return rc;
+}
+
 static int __zfcp_diag_update_buffer(struct zfcp_adapter *const adapter,
 				     struct zfcp_diag_header *const hdr,
 				     zfcp_diag_update_buffer_func buffer_update,
diff --git a/drivers/s390/scsi/zfcp_diag.h b/drivers/s390/scsi/zfcp_diag.h
index 7ff8fb0bb735..cf2947cd8c8f 100644
--- a/drivers/s390/scsi/zfcp_diag.h
+++ b/drivers/s390/scsi/zfcp_diag.h
@@ -77,6 +77,7 @@ void zfcp_diag_update_xdata(struct zfcp_diag_header *const hdr,
  */
 typedef int (*zfcp_diag_update_buffer_func)(struct zfcp_adapter *const adapter);
 
+int zfcp_diag_update_config_data_buffer(struct zfcp_adapter *const adapter);
 int zfcp_diag_update_port_data_buffer(struct zfcp_adapter *const adapter);
 int zfcp_diag_update_buffer_limited(struct zfcp_adapter *const adapter,
 				    struct zfcp_diag_header *const hdr,
diff --git a/drivers/s390/scsi/zfcp_sysfs.c b/drivers/s390/scsi/zfcp_sysfs.c
index 376d76b9f337..ae8e9137f448 100644
--- a/drivers/s390/scsi/zfcp_sysfs.c
+++ b/drivers/s390/scsi/zfcp_sysfs.c
@@ -687,6 +687,11 @@ static ssize_t zfcp_sysfs_adapter_diag_b2b_credit_show(
 
 	diag_hdr = &adapter->diagnostics->config_data.header;
 
+	rc = zfcp_diag_update_buffer_limited(
+		adapter, diag_hdr, zfcp_diag_update_config_data_buffer);
+	if (rc != 0)
+		goto out;
+
 	spin_lock_irqsave(&diag_hdr->access_lock, flags);
 	/* nport_serv_param doesn't contain the ELS_Command code */
 	nsp = (struct fc_els_flogi *)((unsigned long)
-- 
2.21.0

