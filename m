Return-Path: <SRS0=tebG=45=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1664C10DCE
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Mar 2020 17:51:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 99EEE206B1
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Mar 2020 17:51:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726442AbgCLRvW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 12 Mar 2020 13:51:22 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:16788 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726127AbgCLRvW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 12 Mar 2020 13:51:22 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02CHnsrk033954
        for <linux-scsi@vger.kernel.org>; Thu, 12 Mar 2020 13:51:19 -0400
Received: from e06smtp05.uk.ibm.com (e06smtp05.uk.ibm.com [195.75.94.101])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2yqss8863g-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Thu, 12 Mar 2020 13:51:17 -0400
Received: from localhost
        by e06smtp05.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <maier@linux.ibm.com>;
        Thu, 12 Mar 2020 17:45:27 -0000
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp05.uk.ibm.com (192.168.101.135) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 12 Mar 2020 17:45:26 -0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 02CHjO3859965580
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Mar 2020 17:45:24 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 879B95204F;
        Thu, 12 Mar 2020 17:45:24 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 3EA3F5204E;
        Thu, 12 Mar 2020 17:45:24 +0000 (GMT)
From:   Steffen Maier <maier@linux.ibm.com>
To:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org,
        Benjamin Block <bblock@linux.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Steffen Maier <maier@linux.ibm.com>,
        Jens Remus <jremus@linux.ibm.com>
Subject: [PATCH 06/10] zfcp: report FC Endpoint Security in sysfs
Date:   Thu, 12 Mar 2020 18:45:01 +0100
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200312174505.51294-1-maier@linux.ibm.com>
References: <20200312174505.51294-1-maier@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 20031217-0020-0000-0000-000003B35DD1
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20031217-0021-0000-0000-0000220BB2DD
Message-Id: <20200312174505.51294-7-maier@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-12_12:2020-03-11,2020-03-12 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 phishscore=0
 suspectscore=0 priorityscore=1501 clxscore=1015 spamscore=0 adultscore=0
 impostorscore=0 mlxlogscore=999 lowpriorityscore=0 mlxscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2003120091
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Jens Remus <jremus@linux.ibm.com>

Add an interface to read Fibre Channel Endpoint Security information of
FCP channels and their connections to FC remote ports. It comes in the
form of new sysfs attributes that are attached to the CCW device
representing the FCP device and its zfcp port objects.

The read-only sysfs attribute "fc_security" of a CCW device representing
a FCP device shows the FC Endpoint Security capabilities of the device.
Possible values are: "unknown", "unsupported", "none", or a comma-
separated list of one or more mnemonics and/or one hexadecimal value
representing the supported FC Endpoint Security:

  Authentication: Authentication supported
  Encryption    : Encryption supported

The read-only sysfs attribute "fc_security" of a zfcp port object shows
the FC Endpoint Security used on the connection between its parent FCP
device and the FC remote port. Possible values are: "unknown",
"unsupported", "none", or a mnemonic or hexadecimal value representing
the FC Endpoint Security used:

  Authentication: Connection has been authenticated
  Encryption    : Connection is encrypted

Both sysfs attributes may return hexadecimal values instead of
mnemonics, if the mnemonic lookup table does not contain an entry for
the FC Endpoint Security reported by the FCP device.

Signed-off-by: Jens Remus <jremus@linux.ibm.com>
Reviewed-by: Fedor Loshakov <loshakov@linux.ibm.com>
Reviewed-by: Steffen Maier <maier@linux.ibm.com>
Reviewed-by: Benjamin Block <bblock@linux.ibm.com>
Signed-off-by: Steffen Maier <maier@linux.ibm.com>
---
 drivers/s390/scsi/zfcp_def.h   |  4 +-
 drivers/s390/scsi/zfcp_ext.h   |  9 +++-
 drivers/s390/scsi/zfcp_fsf.c   | 79 ++++++++++++++++++++++++++++++++++
 drivers/s390/scsi/zfcp_fsf.h   | 14 ++++--
 drivers/s390/scsi/zfcp_sysfs.c | 70 +++++++++++++++++++++++++++++-
 5 files changed, 170 insertions(+), 6 deletions(-)

diff --git a/drivers/s390/scsi/zfcp_def.h b/drivers/s390/scsi/zfcp_def.h
index 8cc0eefe4ccc..861ddc1ef2a9 100644
--- a/drivers/s390/scsi/zfcp_def.h
+++ b/drivers/s390/scsi/zfcp_def.h
@@ -4,7 +4,7 @@
  *
  * Global definitions for the zfcp device driver.
  *
- * Copyright IBM Corp. 2002, 2018
+ * Copyright IBM Corp. 2002, 2020
  */
 
 #ifndef ZFCP_DEF_H
@@ -158,6 +158,7 @@ struct zfcp_adapter {
 	u32			adapter_features;  /* FCP channel features */
 	u32			connection_features; /* host connection features */
         u32			hardware_version;  /* of FCP channel */
+	u32			fc_security_algorithms; /* of FCP channel */
 	u16			timer_ticks;       /* time int for a tick */
 	struct Scsi_Host	*scsi_host;	   /* Pointer to mid-layer */
 	struct list_head	port_list;	   /* remote port list */
@@ -218,6 +219,7 @@ struct zfcp_port {
         atomic_t               erp_counter;
 	u32                    maxframe_size;
 	u32                    supported_classes;
+	u32                    connection_info;
 	struct work_struct     gid_pn_work;
 	struct work_struct     test_link_work;
 	struct work_struct     rport_work;
diff --git a/drivers/s390/scsi/zfcp_ext.h b/drivers/s390/scsi/zfcp_ext.h
index c8556787cfdc..ee82fb540db3 100644
--- a/drivers/s390/scsi/zfcp_ext.h
+++ b/drivers/s390/scsi/zfcp_ext.h
@@ -4,7 +4,7 @@
  *
  * External function declarations.
  *
- * Copyright IBM Corp. 2002, 2018
+ * Copyright IBM Corp. 2002, 2020
  */
 
 #ifndef ZFCP_EXT_H
@@ -135,6 +135,13 @@ extern struct zfcp_fsf_req *zfcp_fsf_fcp_task_mgmt(struct scsi_device *sdev,
 						   u8 tm_flags);
 extern struct zfcp_fsf_req *zfcp_fsf_abort_fcp_cmnd(struct scsi_cmnd *);
 extern void zfcp_fsf_reqid_check(struct zfcp_qdio *, int);
+enum zfcp_fsf_print_fmt {
+	ZFCP_FSF_PRINT_FMT_LIST,
+	ZFCP_FSF_PRINT_FMT_SINGLEITEM,
+};
+extern ssize_t zfcp_fsf_scnprint_fc_security(char *buf, size_t size,
+					     u32 fc_security,
+					     enum zfcp_fsf_print_fmt fmt);
 
 /* zfcp_qdio.c */
 extern int zfcp_qdio_setup(struct zfcp_adapter *);
diff --git a/drivers/s390/scsi/zfcp_fsf.c b/drivers/s390/scsi/zfcp_fsf.c
index c3aa0546364a..068cb94beb58 100644
--- a/drivers/s390/scsi/zfcp_fsf.c
+++ b/drivers/s390/scsi/zfcp_fsf.c
@@ -664,6 +664,76 @@ static void zfcp_fsf_exchange_config_data_handler(struct zfcp_fsf_req *req)
 	}
 }
 
+/*
+ * Mapping of FC Endpoint Security flag masks to mnemonics
+ */
+static const struct {
+	u32	mask;
+	char	*name;
+} zfcp_fsf_fc_security_mnemonics[] = {
+	{ FSF_FC_SECURITY_AUTH,		"Authentication" },
+	{ FSF_FC_SECURITY_ENC_FCSP2 |
+	  FSF_FC_SECURITY_ENC_ERAS,	"Encryption" },
+};
+
+/**
+ * zfcp_fsf_scnprint_fc_security() - translate FC Endpoint Security flags into
+ *                                   mnemonics and place in a buffer
+ * @buf        : the buffer to place the translated FC Endpoint Security flag(s)
+ *               into
+ * @size       : the size of the buffer, including the trailing null space
+ * @fc_security: one or more FC Endpoint Security flags, or zero
+ * @fmt        : specifies whether a list or a single item is to be put into the
+ *               buffer
+ *
+ * The Fibre Channel (FC) Endpoint Security flags are translated into mnemonics.
+ * If the FC Endpoint Security flags are zero "none" is placed into the buffer.
+ *
+ * With ZFCP_FSF_PRINT_FMT_LIST the mnemonics are placed as a list separated by
+ * a comma followed by a space into the buffer. If one or more FC Endpoint
+ * Security flags cannot be translated into a mnemonic, as they are undefined
+ * in zfcp_fsf_fc_security_mnemonics, their bitwise ORed value in hexadecimal
+ * representation is placed into the buffer.
+ *
+ * With ZFCP_FSF_PRINT_FMT_SINGLEITEM only one single mnemonic is placed into
+ * the buffer. If the FC Endpoint Security flag cannot be translated, as it is
+ * undefined in zfcp_fsf_fc_security_mnemonics, its value in hexadecimal
+ * representation is placed into the buffer. If more than one FC Endpoint
+ * Security flag was specified, their value in hexadecimal representation is
+ * placed into the buffer.
+ *
+ * Return: The number of characters written into buf not including the trailing
+ *         '\0'. If size is == 0 the function returns 0.
+ */
+ssize_t zfcp_fsf_scnprint_fc_security(char *buf, size_t size, u32 fc_security,
+				      enum zfcp_fsf_print_fmt fmt)
+{
+	const char *prefix = "";
+	ssize_t len = 0;
+	int i;
+
+	if (fc_security == 0)
+		return scnprintf(buf, size, "none");
+	if (fmt == ZFCP_FSF_PRINT_FMT_SINGLEITEM && hweight32(fc_security) != 1)
+		return scnprintf(buf, size, "0x%08x", fc_security);
+
+	for (i = 0; i < ARRAY_SIZE(zfcp_fsf_fc_security_mnemonics); i++) {
+		if (!(fc_security & zfcp_fsf_fc_security_mnemonics[i].mask))
+			continue;
+
+		len += scnprintf(buf + len, size - len, "%s%s", prefix,
+				 zfcp_fsf_fc_security_mnemonics[i].name);
+		prefix = ", ";
+		fc_security &= ~zfcp_fsf_fc_security_mnemonics[i].mask;
+	}
+
+	if (fc_security != 0)
+		len += scnprintf(buf + len, size - len, "%s0x%08x",
+				 prefix, fc_security);
+
+	return len;
+}
+
 static void zfcp_fsf_exchange_port_evaluate(struct zfcp_fsf_req *req)
 {
 	struct zfcp_adapter *adapter = req->adapter;
@@ -681,6 +751,11 @@ static void zfcp_fsf_exchange_port_evaluate(struct zfcp_fsf_req *req)
 	       FC_FC4_LIST_SIZE);
 	memcpy(fc_host_active_fc4s(shost), bottom->active_fc4_types,
 	       FC_FC4_LIST_SIZE);
+	if (adapter->adapter_features & FSF_FEATURE_FC_SECURITY)
+		adapter->fc_security_algorithms =
+			bottom->fc_security_algorithms;
+	else
+		adapter->fc_security_algorithms = 0;
 }
 
 static void zfcp_fsf_exchange_port_data_handler(struct zfcp_fsf_req *req)
@@ -1533,6 +1608,10 @@ static void zfcp_fsf_open_port_handler(struct zfcp_fsf_req *req)
 		break;
 	case FSF_GOOD:
 		port->handle = header->port_handle;
+		if (adapter->adapter_features & FSF_FEATURE_FC_SECURITY)
+			port->connection_info = bottom->connection_info;
+		else
+			port->connection_info = 0;
 		atomic_or(ZFCP_STATUS_COMMON_OPEN |
 				ZFCP_STATUS_PORT_PHYS_OPEN, &port->status);
 		atomic_andnot(ZFCP_STATUS_COMMON_ACCESS_BOXED,
diff --git a/drivers/s390/scsi/zfcp_fsf.h b/drivers/s390/scsi/zfcp_fsf.h
index 2b1e4da1944f..66de1708973d 100644
--- a/drivers/s390/scsi/zfcp_fsf.h
+++ b/drivers/s390/scsi/zfcp_fsf.h
@@ -4,7 +4,7 @@
  *
  * Interface to the FSF support functions.
  *
- * Copyright IBM Corp. 2002, 2018
+ * Copyright IBM Corp. 2002, 2020
  */
 
 #ifndef FSF_H
@@ -165,6 +165,7 @@
 #define FSF_FEATURE_MEASUREMENT_DATA		0x00000200
 #define FSF_FEATURE_REQUEST_SFP_DATA		0x00000200
 #define FSF_FEATURE_REPORT_SFP_DATA		0x00000800
+#define FSF_FEATURE_FC_SECURITY			0x00001000
 #define FSF_FEATURE_DIF_PROT_TYPE1		0x00010000
 #define FSF_FEATURE_DIX_PROT_TCPIP		0x00020000
 
@@ -174,6 +175,11 @@
 /* option */
 #define FSF_OPEN_LUN_SUPPRESS_BOXING		0x00000001
 
+/* FC security algorithms */
+#define FSF_FC_SECURITY_AUTH			0x00000001
+#define FSF_FC_SECURITY_ENC_FCSP2		0x00000002
+#define FSF_FC_SECURITY_ENC_ERAS		0x00000004
+
 struct fsf_queue_designator {
 	u8  cssid;
 	u8  chpid;
@@ -338,7 +344,8 @@ struct fsf_qtcb_bottom_support {
 	u8  res3[3];
 	u8  timeout;
         u32 lun_access_info;
-        u8  res4[180];
+	u32 connection_info;
+	u8  res4[176];
 	u32 els1_length;
 	u32 els2_length;
 	u32 req_buf_length;
@@ -426,7 +433,8 @@ struct fsf_qtcb_bottom_port {
 			u16 port_tx_type	:4;
 		};
 	} sfp_flags;
-	u8 res3[240];
+	u32 fc_security_algorithms;
+	u8 res3[236];
 } __attribute__ ((packed));
 
 union fsf_qtcb_bottom {
diff --git a/drivers/s390/scsi/zfcp_sysfs.c b/drivers/s390/scsi/zfcp_sysfs.c
index 494b9fe9cc94..45d53166d0d1 100644
--- a/drivers/s390/scsi/zfcp_sysfs.c
+++ b/drivers/s390/scsi/zfcp_sysfs.c
@@ -4,7 +4,7 @@
  *
  * sysfs attributes.
  *
- * Copyright IBM Corp. 2008, 2010
+ * Copyright IBM Corp. 2008, 2020
  */
 
 #define KMSG_COMPONENT "zfcp"
@@ -370,6 +370,42 @@ static ZFCP_DEV_ATTR(adapter, diag_max_age, 0644,
 		     zfcp_sysfs_adapter_diag_max_age_show,
 		     zfcp_sysfs_adapter_diag_max_age_store);
 
+static ssize_t zfcp_sysfs_adapter_fc_security_show(
+	struct device *dev, struct device_attribute *attr, char *buf)
+{
+	struct ccw_device *cdev = to_ccwdev(dev);
+	struct zfcp_adapter *adapter = zfcp_ccw_adapter_by_cdev(cdev);
+	unsigned int status;
+	int i;
+
+	if (!adapter)
+		return -ENODEV;
+
+	/*
+	 * Adapter status COMMON_OPEN implies xconf data and xport data
+	 * was done. Adapter FC Endpoint Security capability remains
+	 * unchanged in case of COMMON_ERP_FAILED (e.g. due to local link
+	 * down).
+	 */
+	status = atomic_read(&adapter->status);
+	if (0 == (status & ZFCP_STATUS_COMMON_OPEN))
+		i = sprintf(buf, "unknown\n");
+	else if (!(adapter->adapter_features & FSF_FEATURE_FC_SECURITY))
+		i = sprintf(buf, "unsupported\n");
+	else {
+		i = zfcp_fsf_scnprint_fc_security(
+			buf, PAGE_SIZE - 1, adapter->fc_security_algorithms,
+			ZFCP_FSF_PRINT_FMT_LIST);
+		i += scnprintf(buf + i, PAGE_SIZE - i, "\n");
+	}
+
+	zfcp_ccw_adapter_put(adapter);
+	return i;
+}
+static ZFCP_DEV_ATTR(adapter, fc_security, S_IRUGO,
+		     zfcp_sysfs_adapter_fc_security_show,
+		     NULL);
+
 static struct attribute *zfcp_adapter_attrs[] = {
 	&dev_attr_adapter_failed.attr,
 	&dev_attr_adapter_in_recovery.attr,
@@ -383,6 +419,7 @@ static struct attribute *zfcp_adapter_attrs[] = {
 	&dev_attr_adapter_status.attr,
 	&dev_attr_adapter_hardware_version.attr,
 	&dev_attr_adapter_diag_max_age.attr,
+	&dev_attr_adapter_fc_security.attr,
 	NULL
 };
 
@@ -426,6 +463,36 @@ static ssize_t zfcp_sysfs_unit_remove_store(struct device *dev,
 }
 static DEVICE_ATTR(unit_remove, S_IWUSR, NULL, zfcp_sysfs_unit_remove_store);
 
+static ssize_t zfcp_sysfs_port_fc_security_show(struct device *dev,
+						struct device_attribute *attr,
+						char *buf)
+{
+	struct zfcp_port *port = container_of(dev, struct zfcp_port, dev);
+	struct zfcp_adapter *adapter = port->adapter;
+	unsigned int status = atomic_read(&port->status);
+	int i;
+
+	if (0 == (status & ZFCP_STATUS_COMMON_OPEN) ||
+	    0 == (status & ZFCP_STATUS_COMMON_UNBLOCKED) ||
+	    0 == (status & ZFCP_STATUS_PORT_PHYS_OPEN) ||
+	    0 != (status & ZFCP_STATUS_COMMON_ERP_FAILED) ||
+	    0 != (status & ZFCP_STATUS_COMMON_ACCESS_BOXED))
+		i = sprintf(buf, "unknown\n");
+	else if (!(adapter->adapter_features & FSF_FEATURE_FC_SECURITY))
+		i = sprintf(buf, "unsupported\n");
+	else {
+		i = zfcp_fsf_scnprint_fc_security(
+			buf, PAGE_SIZE - 1, port->connection_info,
+			ZFCP_FSF_PRINT_FMT_SINGLEITEM);
+		i += scnprintf(buf + i, PAGE_SIZE - i, "\n");
+	}
+
+	return i;
+}
+static ZFCP_DEV_ATTR(port, fc_security, S_IRUGO,
+		     zfcp_sysfs_port_fc_security_show,
+		     NULL);
+
 static struct attribute *zfcp_port_attrs[] = {
 	&dev_attr_unit_add.attr,
 	&dev_attr_unit_remove.attr,
@@ -433,6 +500,7 @@ static struct attribute *zfcp_port_attrs[] = {
 	&dev_attr_port_in_recovery.attr,
 	&dev_attr_port_status.attr,
 	&dev_attr_port_access_denied.attr,
+	&dev_attr_port_fc_security.attr,
 	NULL
 };
 static struct attribute_group zfcp_port_attr_group = {
-- 
2.17.1

