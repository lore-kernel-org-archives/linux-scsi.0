Return-Path: <SRS0=/OAa=YS=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51D9ECA9EBC
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Oct 2019 16:13:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2352F2053B
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Oct 2019 16:13:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2505224AbfJYQNG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 25 Oct 2019 12:13:06 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:48892 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2505147AbfJYQNC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 25 Oct 2019 12:13:02 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x9PG8xND073490
        for <linux-scsi@vger.kernel.org>; Fri, 25 Oct 2019 12:13:01 -0400
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2vv20ap5n4-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Fri, 25 Oct 2019 12:13:01 -0400
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <bblock@linux.ibm.com>;
        Fri, 25 Oct 2019 17:12:59 +0100
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 25 Oct 2019 17:12:56 +0100
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x9PGCsPo58523666
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Oct 2019 16:12:54 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 51CDC11C05B;
        Fri, 25 Oct 2019 16:12:54 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 350F411C054;
        Fri, 25 Oct 2019 16:12:54 +0000 (GMT)
Received: from t480-pf1aa2c2 (unknown [9.152.212.148])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Fri, 25 Oct 2019 16:12:54 +0000 (GMT)
Received: from bblock by t480-pf1aa2c2 with local (Exim 4.92.3)
        (envelope-from <bblock@linux.ibm.com>)
        id 1iO2Cr-00074V-Uz; Fri, 25 Oct 2019 18:12:53 +0200
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
Subject: [PATCH v2 05/11] zfcp: introduce SysFS interface for diagnostics of local SFP transceiver
Date:   Fri, 25 Oct 2019 18:12:47 +0200
X-Mailer: git-send-email 2.21.0
In-Reply-To: <cover.1571934247.git.bblock@linux.ibm.com>
References: <cover.1571934247.git.bblock@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19102516-4275-0000-0000-00000377A272
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19102516-4276-0000-0000-0000388AD0E2
Message-Id: <1f9cce7c829c881e7d71a3f10c5b57f3dd84ab32.1572018132.git.bblock@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-10-25_08:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1910250148
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This adds an interface to read the diagnostics of the local SFP
transceiver of an FCP-Channel from userspace. This comes in the form of
new SysFS entries that are attached to the CCW device representing the
FCP device. Each type of data gets its own SysFS entry; the whole
collection of entries is pooled into a new child-directory of the CCW
device node: "diagnostics".

Adds SysFS entries for:
 * sfp_invalid:    boolean value evaluating to whether the following 5
                   fields are invalid; {0, 1}; 1 - invalid
 * temperature:    transceiver temp.; unit 1/256°C;
                   range [-128°C, +128°C]
 * vcc:            supply voltage; unit 100μV; range [0, 6.55V]
 * tx_bias:        transmitter laser bias current; unit 2μA;
                   range [0, 131mA]
 * tx_power:       coupled TX output power; unit 0.1μW; range [0, 6.5mW]
 * rx_power:       received optical power; unit 0.1μW; range [0, 6.5mW]

 * optical_port:   boolean value evaluating to whether the FCP-Channel has
                   an optical port; {0, 1}; 1 - optical
 * fec_active:     boolean value evaluating to whether 16G FEC is active;
                   {0, 1}; 1 - active
 * port_tx_type:   nibble describing the port type; {0, 1, 2, 3};
                   0 - unknown,             1 - short wave,
                   2 - long wave LC 1310nm, 3 - long wave LL 1550nm
 * connector_type: two bits describing the connector type; {0, 1};
                   0 - unknown,             1 - SFP+

This is only supported if the FCP-Channel in turn supports reporting the
SFP Diagnostic Data, otherwise read() on these new entries will return
EOPNOTSUPP (this affects only adapters older than FICON Express8S, on
Mainframe generations older than z14). Other possible errors for read()
include ENOLINK, ENODEV and ENOMEM.

With this patch the userspace-interface will only read data stored in
the corresponding "diagnostic buffer" (that was stored during completion
of an previous Exchange Port Data command). Implicit updating will
follow later in this series.

Reviewed-by: Steffen Maier <maier@linux.ibm.com>
Signed-off-by: Benjamin Block <bblock@linux.ibm.com>
---
 drivers/s390/scsi/zfcp_aux.c   |  4 ++
 drivers/s390/scsi/zfcp_diag.c  | 42 ++++++++++++++++++++
 drivers/s390/scsi/zfcp_diag.h  | 18 +++++++++
 drivers/s390/scsi/zfcp_ext.h   |  1 +
 drivers/s390/scsi/zfcp_sysfs.c | 71 ++++++++++++++++++++++++++++++++++
 5 files changed, 136 insertions(+)

diff --git a/drivers/s390/scsi/zfcp_aux.c b/drivers/s390/scsi/zfcp_aux.c
index a19189d7b3f3..09ec846fe01d 100644
--- a/drivers/s390/scsi/zfcp_aux.c
+++ b/drivers/s390/scsi/zfcp_aux.c
@@ -407,6 +407,9 @@ struct zfcp_adapter *zfcp_adapter_enqueue(struct ccw_device *ccw_device)
 			       &zfcp_sysfs_adapter_attrs))
 		goto failed;
 
+	if (zfcp_diag_sysfs_setup(adapter))
+		goto failed;
+
 	/* report size limit per scatter-gather segment */
 	adapter->ccw_device->dev.dma_parms = &adapter->dma_parms;
 
@@ -431,6 +434,7 @@ void zfcp_adapter_unregister(struct zfcp_adapter *adapter)
 
 	zfcp_fc_wka_ports_force_offline(adapter->gs);
 	zfcp_scsi_adapter_unregister(adapter);
+	zfcp_diag_sysfs_destroy(adapter);
 	sysfs_remove_group(&cdev->dev.kobj, &zfcp_sysfs_adapter_attrs);
 
 	zfcp_erp_thread_kill(adapter);
diff --git a/drivers/s390/scsi/zfcp_diag.c b/drivers/s390/scsi/zfcp_diag.c
index d7d2db85b32e..8df3ace6135d 100644
--- a/drivers/s390/scsi/zfcp_diag.c
+++ b/drivers/s390/scsi/zfcp_diag.c
@@ -10,6 +10,8 @@
 #include <linux/spinlock.h>
 #include <linux/jiffies.h>
 #include <linux/string.h>
+#include <linux/kernfs.h>
+#include <linux/sysfs.h>
 #include <linux/errno.h>
 #include <linux/slab.h>
 
@@ -77,6 +79,46 @@ void zfcp_diag_adapter_free(struct zfcp_adapter *const adapter)
 	adapter->diagnostics = NULL;
 }
 
+/**
+ * zfcp_diag_sysfs_setup() - Setup the sysfs-group for adapter-diagnostics.
+ * @adapter: target adapter to which the group should be added.
+ *
+ * Return: 0 on success; Something else otherwise (see sysfs_create_group()).
+ */
+int zfcp_diag_sysfs_setup(struct zfcp_adapter *const adapter)
+{
+	int rc = sysfs_create_group(&adapter->ccw_device->dev.kobj,
+				    &zfcp_sysfs_diag_attr_group);
+	if (rc == 0)
+		adapter->diagnostics->sysfs_established = 1;
+
+	return rc;
+}
+
+/**
+ * zfcp_diag_sysfs_destroy() - Remove the sysfs-group for adapter-diagnostics.
+ * @adapter: target adapter from which the group should be removed.
+ */
+void zfcp_diag_sysfs_destroy(struct zfcp_adapter *const adapter)
+{
+	if (adapter->diagnostics == NULL ||
+	    !adapter->diagnostics->sysfs_established)
+		return;
+
+	/*
+	 * We need this state-handling so we can prevent warnings being printed
+	 * on the kernel-console in case we have to abort a halfway done
+	 * zfcp_adapter_enqueue(), in which the sysfs-group was not yet
+	 * established. sysfs_remove_group() does this checking as well, but
+	 * still prints a warning in case we try to remove a group that has not
+	 * been established before
+	 */
+	adapter->diagnostics->sysfs_established = 0;
+	sysfs_remove_group(&adapter->ccw_device->dev.kobj,
+			   &zfcp_sysfs_diag_attr_group);
+}
+
+
 /**
  * zfcp_diag_update_xdata() - Update a diagnostics buffer.
  * @hdr: the meta data to update.
diff --git a/drivers/s390/scsi/zfcp_diag.h b/drivers/s390/scsi/zfcp_diag.h
index a3eb21cc201d..2deebccda17d 100644
--- a/drivers/s390/scsi/zfcp_diag.h
+++ b/drivers/s390/scsi/zfcp_diag.h
@@ -40,6 +40,8 @@ struct zfcp_diag_header {
 /**
  * struct zfcp_diag_adapter - central storage for all diagnostics concerning an
  *			      adapter.
+ * @sysfs_established: flag showing that the associated sysfs-group was created
+ *		       during run of zfcp_adapter_enqueue().
  * @port_data: data retrieved using exchange port data.
  * @port_data.header: header with metadata for the cache in @port_data.data.
  * @port_data.data: cached QTCB Bottom of command exchange port data.
@@ -48,6 +50,8 @@ struct zfcp_diag_header {
  * @config_data.data: cached QTCB Bottom of command exchange config data.
  */
 struct zfcp_diag_adapter {
+	u64	sysfs_established	:1;
+
 	struct {
 		struct zfcp_diag_header		header;
 		struct fsf_qtcb_bottom_port	data;
@@ -61,7 +65,21 @@ struct zfcp_diag_adapter {
 int zfcp_diag_adapter_setup(struct zfcp_adapter *const adapter);
 void zfcp_diag_adapter_free(struct zfcp_adapter *const adapter);
 
+int zfcp_diag_sysfs_setup(struct zfcp_adapter *const adapter);
+void zfcp_diag_sysfs_destroy(struct zfcp_adapter *const adapter);
+
 void zfcp_diag_update_xdata(struct zfcp_diag_header *const hdr,
 			    const void *const data, const bool incomplete);
 
+/**
+ * zfcp_diag_support_sfp() - Return %true if the @adapter supports reporting
+ *			     SFP Data.
+ * @adapter: adapter to test the availability of SFP Data reporting for.
+ */
+static inline bool
+zfcp_diag_support_sfp(const struct zfcp_adapter *const adapter)
+{
+	return !!(adapter->adapter_features & FSF_FEATURE_REPORT_SFP_DATA);
+}
+
 #endif /* ZFCP_DIAG_H */
diff --git a/drivers/s390/scsi/zfcp_ext.h b/drivers/s390/scsi/zfcp_ext.h
index 31e8a7240fd7..c8556787cfdc 100644
--- a/drivers/s390/scsi/zfcp_ext.h
+++ b/drivers/s390/scsi/zfcp_ext.h
@@ -167,6 +167,7 @@ extern const struct attribute_group *zfcp_port_attr_groups[];
 extern struct mutex zfcp_sysfs_port_units_mutex;
 extern struct device_attribute *zfcp_sysfs_sdev_attrs[];
 extern struct device_attribute *zfcp_sysfs_shost_attrs[];
+extern const struct attribute_group zfcp_sysfs_diag_attr_group;
 bool zfcp_sysfs_port_is_removing(const struct zfcp_port *const port);
 
 /* zfcp_unit.c */
diff --git a/drivers/s390/scsi/zfcp_sysfs.c b/drivers/s390/scsi/zfcp_sysfs.c
index 90d851d49410..6c0cea71ae5d 100644
--- a/drivers/s390/scsi/zfcp_sysfs.c
+++ b/drivers/s390/scsi/zfcp_sysfs.c
@@ -11,6 +11,7 @@
 #define pr_fmt(fmt) KMSG_COMPONENT ": " fmt
 
 #include <linux/slab.h>
+#include "zfcp_diag.h"
 #include "zfcp_ext.h"
 
 #define ZFCP_DEV_ATTR(_feat, _name, _mode, _show, _store) \
@@ -664,3 +665,73 @@ struct device_attribute *zfcp_sysfs_shost_attrs[] = {
 	&dev_attr_queue_full,
 	NULL
 };
+
+#define ZFCP_DEFINE_DIAG_SFP_ATTR(_name, _qtcb_member, _prtsize, _prtfmt)      \
+	static ssize_t zfcp_sysfs_adapter_diag_sfp_##_name##_show(	       \
+		struct device *dev, struct device_attribute *attr, char *buf)  \
+	{								       \
+		struct zfcp_adapter *const adapter =			       \
+			zfcp_ccw_adapter_by_cdev(to_ccwdev(dev));	       \
+		struct zfcp_diag_header *diag_hdr;			       \
+		ssize_t rc = -ENOLINK;					       \
+		unsigned long flags;					       \
+		unsigned int status;					       \
+									       \
+		if (!adapter)						       \
+			return -ENODEV;					       \
+									       \
+		status = atomic_read(&adapter->status);			       \
+		if (0 == (status & ZFCP_STATUS_COMMON_OPEN) ||		       \
+		    0 == (status & ZFCP_STATUS_COMMON_UNBLOCKED) ||	       \
+		    0 != (status & ZFCP_STATUS_COMMON_ERP_FAILED))	       \
+			goto out;					       \
+									       \
+		if (!zfcp_diag_support_sfp(adapter)) {			       \
+			rc = -EOPNOTSUPP;				       \
+			goto out;					       \
+		}							       \
+									       \
+		diag_hdr = &adapter->diagnostics->port_data.header;	       \
+									       \
+		spin_lock_irqsave(&diag_hdr->access_lock, flags);	       \
+		rc = scnprintf(						       \
+			buf, (_prtsize) + 2, _prtfmt "\n",		       \
+			adapter->diagnostics->port_data.data._qtcb_member);    \
+		spin_unlock_irqrestore(&diag_hdr->access_lock, flags);	       \
+									       \
+	out:								       \
+		zfcp_ccw_adapter_put(adapter);				       \
+		return rc;						       \
+	}								       \
+	static ZFCP_DEV_ATTR(adapter_diag_sfp, _name, 0400,		       \
+			     zfcp_sysfs_adapter_diag_sfp_##_name##_show, NULL)
+
+ZFCP_DEFINE_DIAG_SFP_ATTR(temperature, temperature, 5, "%hu");
+ZFCP_DEFINE_DIAG_SFP_ATTR(vcc, vcc, 5, "%hu");
+ZFCP_DEFINE_DIAG_SFP_ATTR(tx_bias, tx_bias, 5, "%hu");
+ZFCP_DEFINE_DIAG_SFP_ATTR(tx_power, tx_power, 5, "%hu");
+ZFCP_DEFINE_DIAG_SFP_ATTR(rx_power, rx_power, 5, "%hu");
+ZFCP_DEFINE_DIAG_SFP_ATTR(port_tx_type, sfp_flags.port_tx_type, 2, "%hu");
+ZFCP_DEFINE_DIAG_SFP_ATTR(optical_port, sfp_flags.optical_port, 1, "%hu");
+ZFCP_DEFINE_DIAG_SFP_ATTR(sfp_invalid, sfp_flags.sfp_invalid, 1, "%hu");
+ZFCP_DEFINE_DIAG_SFP_ATTR(connector_type, sfp_flags.connector_type, 1, "%hu");
+ZFCP_DEFINE_DIAG_SFP_ATTR(fec_active, sfp_flags.fec_active, 1, "%hu");
+
+static struct attribute *zfcp_sysfs_diag_attrs[] = {
+	&dev_attr_adapter_diag_sfp_temperature.attr,
+	&dev_attr_adapter_diag_sfp_vcc.attr,
+	&dev_attr_adapter_diag_sfp_tx_bias.attr,
+	&dev_attr_adapter_diag_sfp_tx_power.attr,
+	&dev_attr_adapter_diag_sfp_rx_power.attr,
+	&dev_attr_adapter_diag_sfp_port_tx_type.attr,
+	&dev_attr_adapter_diag_sfp_optical_port.attr,
+	&dev_attr_adapter_diag_sfp_sfp_invalid.attr,
+	&dev_attr_adapter_diag_sfp_connector_type.attr,
+	&dev_attr_adapter_diag_sfp_fec_active.attr,
+	NULL,
+};
+
+const struct attribute_group zfcp_sysfs_diag_attr_group = {
+	.name = "diagnostics",
+	.attrs = zfcp_sysfs_diag_attrs,
+};
-- 
2.21.0

