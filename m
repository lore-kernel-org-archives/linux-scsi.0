Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E973FC433ED
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Apr 2021 17:08:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B61BF61168
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Apr 2021 17:08:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233673AbhDNRIk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Apr 2021 13:08:40 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:18038 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232744AbhDNRIf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 14 Apr 2021 13:08:35 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13EH3wAj177894;
        Wed, 14 Apr 2021 13:08:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : sender; s=pp1;
 bh=izKPCvtyevFxyN6PvbzqCnt5tJIYMMg6qsaby2QPcuE=;
 b=eQKgOb1TCeIGQuml8MDl6rR/cSh6sIza2w7biUxzjyqJkrquaRK4LMbFXq5pQOta2gCY
 1jIvZ+kcOg4M29xP6fDLhaF8As7a/ROtRLx3KrJ08Aj49wKv/nQLNMVXiu9JaklYDRcp
 lNYqVIJ548hb33TLK7hWA/ucPUBIgpXT2IMNJr5D5Rwug3SexaJL0xOy1M/DDc09r9fA
 xGRhcMJBJjOnCo0uDnTMHPp2CAKIpkeOk3hknoWfC29e/xFSBthsKNnca48tHu9rtY0U
 kYxESJEtBck+ZZ7IwfeatDi20YOGb2bPQD9j4+LB3J7PYgiyo4VRQZiDSye0l9IXYKGI GQ== 
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37x13uptba-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 14 Apr 2021 13:08:10 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 13EH2YLd007946;
        Wed, 14 Apr 2021 17:08:08 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma04ams.nl.ibm.com with ESMTP id 37u3n8ue41-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 14 Apr 2021 17:08:07 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 13EH7h9E17039670
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Apr 2021 17:07:43 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 016DAA4D72;
        Wed, 14 Apr 2021 17:08:05 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DE38AA4D70;
        Wed, 14 Apr 2021 17:08:04 +0000 (GMT)
Received: from t480-pf1aa2c2.fritz.box (unknown [9.145.18.252])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Wed, 14 Apr 2021 17:08:04 +0000 (GMT)
Received: from bblock by t480-pf1aa2c2.fritz.box with local (Exim 4.94)
        (envelope-from <bblock@linux.ibm.com>)
        id 1lWizk-002b2y-Cz; Wed, 14 Apr 2021 19:08:04 +0200
From:   Benjamin Block <bblock@linux.ibm.com>
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Julian Wiedmann <jwi@linux.ibm.com>,
        Benjamin Block <bblock@linux.ibm.com>,
        Steffen Maier <maier@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Fedor Loshakov <loshakov@linux.ibm.com>,
        Sumangala Bannur Subraya <bsuma@linux.ibm.com>,
        linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [PATCH 4/6] zfcp: clean up sysfs code for SFP diagnostics
Date:   Wed, 14 Apr 2021 19:08:02 +0200
Message-Id: <37a97537f675d643006271f37723c346189b6eec.1618417667.git.bblock@linux.ibm.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <cover.1618417667.git.bblock@linux.ibm.com>
References: <cover.1618417667.git.bblock@linux.ibm.com>
MIME-Version: 1.0
Organization: IBM Deutschland Research & Development GmbH, Vorsitz. AufsR. Gregor Pillen, Geschaeftsfuehrung Dirk Wittkopp, Sitz der Gesellschaft Boeblingen, Registergericht AmtsG Stuttgart, HRB 243294
Content-Transfer-Encoding: 8bit
Sender: Benjamin Block <bblock@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 0Z71caPqjNSgbP2004hY90qII8WmFAiH
X-Proofpoint-ORIG-GUID: 0Z71caPqjNSgbP2004hY90qII8WmFAiH
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-14_10:2021-04-14,2021-04-14 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 impostorscore=0
 suspectscore=0 phishscore=0 malwarescore=0 lowpriorityscore=0 adultscore=0
 mlxscore=0 spamscore=0 priorityscore=1501 clxscore=1015 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104140111
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Julian Wiedmann <jwi@linux.ibm.com>

The error path from zfcp_adapter_enqueue() no longer attempts to remove
the diagnostics attributes if they haven't been created yet.

So remove the manual 'sysfs_established' guard for this case, and use
device_add_groups() to add all adapter-related sysfs attributes
in one go.

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
Reviewed-by: Benjamin Block <bblock@linux.ibm.com>
Reviewed-by: Steffen Maier <maier@linux.ibm.com>
Signed-off-by: Benjamin Block <bblock@linux.ibm.com>
---
 drivers/s390/scsi/zfcp_aux.c   | 14 ++++--------
 drivers/s390/scsi/zfcp_diag.c  | 42 ----------------------------------
 drivers/s390/scsi/zfcp_diag.h  |  7 ------
 drivers/s390/scsi/zfcp_ext.h   |  4 ++--
 drivers/s390/scsi/zfcp_sysfs.c | 10 ++++++--
 5 files changed, 14 insertions(+), 63 deletions(-)

diff --git a/drivers/s390/scsi/zfcp_aux.c b/drivers/s390/scsi/zfcp_aux.c
index abad77694e72..fd2f1c31bd21 100644
--- a/drivers/s390/scsi/zfcp_aux.c
+++ b/drivers/s390/scsi/zfcp_aux.c
@@ -413,12 +413,8 @@ struct zfcp_adapter *zfcp_adapter_enqueue(struct ccw_device *ccw_device)
 
 	dev_set_drvdata(&ccw_device->dev, adapter);
 
-	if (sysfs_create_group(&ccw_device->dev.kobj,
-			       &zfcp_sysfs_adapter_attrs))
-		goto failed;
-
-	if (zfcp_diag_sysfs_setup(adapter))
-		goto err_diag_sysfs;
+	if (device_add_groups(&ccw_device->dev, zfcp_sysfs_adapter_attr_groups))
+		goto err_sysfs;
 
 	/* report size limit per scatter-gather segment */
 	adapter->ccw_device->dev.dma_parms = &adapter->dma_parms;
@@ -427,8 +423,7 @@ struct zfcp_adapter *zfcp_adapter_enqueue(struct ccw_device *ccw_device)
 
 	return adapter;
 
-err_diag_sysfs:
-	sysfs_remove_group(&ccw_device->dev.kobj, &zfcp_sysfs_adapter_attrs);
+err_sysfs:
 failed:
 	/* TODO: make this more fine-granular */
 	cancel_delayed_work_sync(&adapter->scan_work);
@@ -460,8 +455,7 @@ void zfcp_adapter_unregister(struct zfcp_adapter *adapter)
 
 	zfcp_fc_wka_ports_force_offline(adapter->gs);
 	zfcp_scsi_adapter_unregister(adapter);
-	zfcp_diag_sysfs_destroy(adapter);
-	sysfs_remove_group(&cdev->dev.kobj, &zfcp_sysfs_adapter_attrs);
+	device_remove_groups(&cdev->dev, zfcp_sysfs_adapter_attr_groups);
 
 	zfcp_erp_thread_kill(adapter);
 	zfcp_dbf_adapter_unregister(adapter);
diff --git a/drivers/s390/scsi/zfcp_diag.c b/drivers/s390/scsi/zfcp_diag.c
index 67a8f4e57db1..4d2d89d9c15a 100644
--- a/drivers/s390/scsi/zfcp_diag.c
+++ b/drivers/s390/scsi/zfcp_diag.c
@@ -10,8 +10,6 @@
 #include <linux/spinlock.h>
 #include <linux/jiffies.h>
 #include <linux/string.h>
-#include <linux/kernfs.h>
-#include <linux/sysfs.h>
 #include <linux/errno.h>
 #include <linux/slab.h>
 
@@ -79,46 +77,6 @@ void zfcp_diag_adapter_free(struct zfcp_adapter *const adapter)
 	adapter->diagnostics = NULL;
 }
 
-/**
- * zfcp_diag_sysfs_setup() - Setup the sysfs-group for adapter-diagnostics.
- * @adapter: target adapter to which the group should be added.
- *
- * Return: 0 on success; Something else otherwise (see sysfs_create_group()).
- */
-int zfcp_diag_sysfs_setup(struct zfcp_adapter *const adapter)
-{
-	int rc = sysfs_create_group(&adapter->ccw_device->dev.kobj,
-				    &zfcp_sysfs_diag_attr_group);
-	if (rc == 0)
-		adapter->diagnostics->sysfs_established = 1;
-
-	return rc;
-}
-
-/**
- * zfcp_diag_sysfs_destroy() - Remove the sysfs-group for adapter-diagnostics.
- * @adapter: target adapter from which the group should be removed.
- */
-void zfcp_diag_sysfs_destroy(struct zfcp_adapter *const adapter)
-{
-	if (adapter->diagnostics == NULL ||
-	    !adapter->diagnostics->sysfs_established)
-		return;
-
-	/*
-	 * We need this state-handling so we can prevent warnings being printed
-	 * on the kernel-console in case we have to abort a halfway done
-	 * zfcp_adapter_enqueue(), in which the sysfs-group was not yet
-	 * established. sysfs_remove_group() does this checking as well, but
-	 * still prints a warning in case we try to remove a group that has not
-	 * been established before
-	 */
-	adapter->diagnostics->sysfs_established = 0;
-	sysfs_remove_group(&adapter->ccw_device->dev.kobj,
-			   &zfcp_sysfs_diag_attr_group);
-}
-
-
 /**
  * zfcp_diag_update_xdata() - Update a diagnostics buffer.
  * @hdr: the meta data to update.
diff --git a/drivers/s390/scsi/zfcp_diag.h b/drivers/s390/scsi/zfcp_diag.h
index 3852367f15f6..da55133da8fe 100644
--- a/drivers/s390/scsi/zfcp_diag.h
+++ b/drivers/s390/scsi/zfcp_diag.h
@@ -40,8 +40,6 @@ struct zfcp_diag_header {
 /**
  * struct zfcp_diag_adapter - central storage for all diagnostics concerning an
  *			      adapter.
- * @sysfs_established: flag showing that the associated sysfs-group was created
- *		       during run of zfcp_adapter_enqueue().
  * @max_age: maximum age of data in diagnostic buffers before they need to be
  *	     refreshed (in ms).
  * @port_data: data retrieved using exchange port data.
@@ -52,8 +50,6 @@ struct zfcp_diag_header {
  * @config_data.data: cached QTCB Bottom of command exchange config data.
  */
 struct zfcp_diag_adapter {
-	u64	sysfs_established	:1;
-
 	unsigned long	max_age;
 
 	struct zfcp_diag_adapter_port_data {
@@ -69,9 +65,6 @@ struct zfcp_diag_adapter {
 int zfcp_diag_adapter_setup(struct zfcp_adapter *const adapter);
 void zfcp_diag_adapter_free(struct zfcp_adapter *const adapter);
 
-int zfcp_diag_sysfs_setup(struct zfcp_adapter *const adapter);
-void zfcp_diag_sysfs_destroy(struct zfcp_adapter *const adapter);
-
 void zfcp_diag_update_xdata(struct zfcp_diag_header *const hdr,
 			    const void *const data, const bool incomplete);
 
diff --git a/drivers/s390/scsi/zfcp_ext.h b/drivers/s390/scsi/zfcp_ext.h
index 58879213f225..6bc96d70254d 100644
--- a/drivers/s390/scsi/zfcp_ext.h
+++ b/drivers/s390/scsi/zfcp_ext.h
@@ -11,6 +11,7 @@
 #define ZFCP_EXT_H
 
 #include <linux/types.h>
+#include <linux/sysfs.h>
 #include <scsi/fc/fc_els.h>
 #include "zfcp_def.h"
 #include "zfcp_fc.h"
@@ -179,13 +180,12 @@ extern void zfcp_scsi_shost_update_port_data(
 	const struct fsf_qtcb_bottom_port *const bottom);
 
 /* zfcp_sysfs.c */
+extern const struct attribute_group *zfcp_sysfs_adapter_attr_groups[];
 extern const struct attribute_group *zfcp_unit_attr_groups[];
-extern struct attribute_group zfcp_sysfs_adapter_attrs;
 extern const struct attribute_group *zfcp_port_attr_groups[];
 extern struct mutex zfcp_sysfs_port_units_mutex;
 extern struct device_attribute *zfcp_sysfs_sdev_attrs[];
 extern struct device_attribute *zfcp_sysfs_shost_attrs[];
-extern const struct attribute_group zfcp_sysfs_diag_attr_group;
 bool zfcp_sysfs_port_is_removing(const struct zfcp_port *const port);
 
 /* zfcp_unit.c */
diff --git a/drivers/s390/scsi/zfcp_sysfs.c b/drivers/s390/scsi/zfcp_sysfs.c
index 8d9662e8b717..f76946dcbd59 100644
--- a/drivers/s390/scsi/zfcp_sysfs.c
+++ b/drivers/s390/scsi/zfcp_sysfs.c
@@ -435,7 +435,7 @@ static struct attribute *zfcp_adapter_attrs[] = {
 	NULL
 };
 
-struct attribute_group zfcp_sysfs_adapter_attrs = {
+static const struct attribute_group zfcp_sysfs_adapter_attr_group = {
 	.attrs = zfcp_adapter_attrs,
 };
 
@@ -906,7 +906,13 @@ static struct attribute *zfcp_sysfs_diag_attrs[] = {
 	NULL,
 };
 
-const struct attribute_group zfcp_sysfs_diag_attr_group = {
+static const struct attribute_group zfcp_sysfs_diag_attr_group = {
 	.name = "diagnostics",
 	.attrs = zfcp_sysfs_diag_attrs,
 };
+
+const struct attribute_group *zfcp_sysfs_adapter_attr_groups[] = {
+	&zfcp_sysfs_adapter_attr_group,
+	&zfcp_sysfs_diag_attr_group,
+	NULL,
+};
-- 
2.30.2

