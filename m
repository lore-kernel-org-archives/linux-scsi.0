Return-Path: <SRS0=/OAa=YS=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FF8ACA9EBE
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Oct 2019 16:13:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D7B542053B
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Oct 2019 16:13:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2505203AbfJYQND (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 25 Oct 2019 12:13:03 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:50924 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2505164AbfJYQND (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 25 Oct 2019 12:13:03 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x9PG91an110300
        for <linux-scsi@vger.kernel.org>; Fri, 25 Oct 2019 12:13:02 -0400
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2vv1repdmd-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Fri, 25 Oct 2019 12:13:01 -0400
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <bblock@linux.ibm.com>;
        Fri, 25 Oct 2019 17:12:59 +0100
Received: from b06cxnps3075.portsmouth.uk.ibm.com (9.149.109.195)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 25 Oct 2019 17:12:56 +0100
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x9PGCs8K62914574
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Oct 2019 16:12:54 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3E8AC11C058;
        Fri, 25 Oct 2019 16:12:54 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2926B11C050;
        Fri, 25 Oct 2019 16:12:54 +0000 (GMT)
Received: from t480-pf1aa2c2 (unknown [9.152.212.148])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Fri, 25 Oct 2019 16:12:54 +0000 (GMT)
Received: from bblock by t480-pf1aa2c2 with local (Exim 4.92.3)
        (envelope-from <bblock@linux.ibm.com>)
        id 1iO2Cr-00074A-So; Fri, 25 Oct 2019 18:12:53 +0200
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
Subject: [PATCH v2 02/11] zfcp: diagnostics buffer caching and use for exchange port data
Date:   Fri, 25 Oct 2019 18:12:44 +0200
X-Mailer: git-send-email 2.21.0
In-Reply-To: <cover.1571934247.git.bblock@linux.ibm.com>
References: <cover.1571934247.git.bblock@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19102516-0016-0000-0000-000002BD97D5
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19102516-0017-0000-0000-0000331EE282
Message-Id: <054ca020ce0a53dc0d9176428bea373898944e6a.1572018130.git.bblock@linux.ibm.com>
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

The FCP channel exposes two central interfaces to receive information
about the local FCP-Adapter/-Port: Exchange Port and Exchange Config
Data. Using these commands can negatively impact the adapter if we allow
them to be sent at a very high rate.

The later parts of this patchset will introduce new user-interfaces to
receive more diagnostics from the adapter. To prevent any negative
impact from using those, this patch adds a simple caching-mechanism that
will prevent a malicious/faulty userspace-application from generating an
abnormal high amount of Exchange Port/Config Data traffic.

Relevant diagnostic data that is received via Exchange Config/Port Data
is cached in buffers associated with the corresponding adapter-struct.
Each buffer is associated with a timestamp that signals how old the data
is, and, added via a following patch in this series, lets
userspace-interfaces determine when the data is too old and needs to be
updated.

Buffer-updates are made during the normal response path of the
corresponding command. With this patch only the output of the Exchange
Port Data command is captured.

Reviewed-by: Steffen Maier <maier@linux.ibm.com>
Signed-off-by: Benjamin Block <bblock@linux.ibm.com>
---
 drivers/s390/scsi/Makefile    |  2 +-
 drivers/s390/scsi/zfcp_aux.c  |  8 ++-
 drivers/s390/scsi/zfcp_def.h  |  3 +-
 drivers/s390/scsi/zfcp_diag.c | 93 +++++++++++++++++++++++++++++++++++
 drivers/s390/scsi/zfcp_diag.h | 60 ++++++++++++++++++++++
 drivers/s390/scsi/zfcp_fsf.c  | 12 +++++
 6 files changed, 175 insertions(+), 3 deletions(-)
 create mode 100644 drivers/s390/scsi/zfcp_diag.c
 create mode 100644 drivers/s390/scsi/zfcp_diag.h

diff --git a/drivers/s390/scsi/Makefile b/drivers/s390/scsi/Makefile
index 9dda431ec8f3..352056eb0dd1 100644
--- a/drivers/s390/scsi/Makefile
+++ b/drivers/s390/scsi/Makefile
@@ -5,6 +5,6 @@
 
 zfcp-objs := zfcp_aux.o zfcp_ccw.o zfcp_dbf.o zfcp_erp.o \
 	     zfcp_fc.o zfcp_fsf.o zfcp_qdio.o zfcp_scsi.o zfcp_sysfs.o \
-	     zfcp_unit.o
+	     zfcp_unit.o zfcp_diag.o
 
 obj-$(CONFIG_ZFCP) += zfcp.o
diff --git a/drivers/s390/scsi/zfcp_aux.c b/drivers/s390/scsi/zfcp_aux.c
index e390f8c6d5f3..a19189d7b3f3 100644
--- a/drivers/s390/scsi/zfcp_aux.c
+++ b/drivers/s390/scsi/zfcp_aux.c
@@ -4,7 +4,7 @@
  *
  * Module interface and handling of zfcp data structures.
  *
- * Copyright IBM Corp. 2002, 2017
+ * Copyright IBM Corp. 2002, 2018
  */
 
 /*
@@ -25,6 +25,7 @@
  *            Martin Petermann
  *            Sven Schuetz
  *            Steffen Maier
+ *	      Benjamin Block
  */
 
 #define KMSG_COMPONENT "zfcp"
@@ -36,6 +37,7 @@
 #include "zfcp_ext.h"
 #include "zfcp_fc.h"
 #include "zfcp_reqlist.h"
+#include "zfcp_diag.h"
 
 #define ZFCP_BUS_ID_SIZE	20
 
@@ -356,6 +358,9 @@ struct zfcp_adapter *zfcp_adapter_enqueue(struct ccw_device *ccw_device)
 
 	adapter->erp_action.adapter = adapter;
 
+	if (zfcp_diag_adapter_setup(adapter))
+		goto failed;
+
 	if (zfcp_qdio_setup(adapter))
 		goto failed;
 
@@ -449,6 +454,7 @@ void zfcp_adapter_release(struct kref *ref)
 	dev_set_drvdata(&adapter->ccw_device->dev, NULL);
 	zfcp_fc_gs_destroy(adapter);
 	zfcp_free_low_mem_buffers(adapter);
+	zfcp_diag_adapter_free(adapter);
 	kfree(adapter->req_list);
 	kfree(adapter->fc_stats);
 	kfree(adapter->stats_reset_data);
diff --git a/drivers/s390/scsi/zfcp_def.h b/drivers/s390/scsi/zfcp_def.h
index f5acdb67442e..8cc0eefe4ccc 100644
--- a/drivers/s390/scsi/zfcp_def.h
+++ b/drivers/s390/scsi/zfcp_def.h
@@ -4,7 +4,7 @@
  *
  * Global definitions for the zfcp device driver.
  *
- * Copyright IBM Corp. 2002, 2017
+ * Copyright IBM Corp. 2002, 2018
  */
 
 #ifndef ZFCP_DEF_H
@@ -198,6 +198,7 @@ struct zfcp_adapter {
 	struct device_dma_parameters dma_parms;
 	struct zfcp_fc_events events;
 	unsigned long		next_port_scan;
+	struct zfcp_diag_adapter	*diagnostics;
 };
 
 struct zfcp_port {
diff --git a/drivers/s390/scsi/zfcp_diag.c b/drivers/s390/scsi/zfcp_diag.c
new file mode 100644
index 000000000000..fa1b25f3ec3c
--- /dev/null
+++ b/drivers/s390/scsi/zfcp_diag.c
@@ -0,0 +1,93 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * zfcp device driver
+ *
+ * Functions to handle diagnostics.
+ *
+ * Copyright IBM Corp. 2018
+ */
+
+#include <linux/spinlock.h>
+#include <linux/jiffies.h>
+#include <linux/string.h>
+#include <linux/errno.h>
+#include <linux/slab.h>
+
+#include "zfcp_diag.h"
+#include "zfcp_ext.h"
+#include "zfcp_def.h"
+
+/* Max age of data in a diagnostics buffer before it needs a refresh (in ms). */
+#define ZFCP_DIAG_MAX_AGE (5 * 1000)
+
+/**
+ * zfcp_diag_adapter_setup() - Setup storage for adapter diagnostics.
+ * @adapter: the adapter to setup diagnostics for.
+ *
+ * Creates the data-structures to store the diagnostics for an adapter. This
+ * overwrites whatever was stored before at &zfcp_adapter->diagnostics!
+ *
+ * Return:
+ * * 0	     - Everyting is OK
+ * * -ENOMEM - Could not allocate all/parts of the data-structures;
+ *	       &zfcp_adapter->diagnostics remains unchanged
+ */
+int zfcp_diag_adapter_setup(struct zfcp_adapter *const adapter)
+{
+	struct zfcp_diag_adapter *diag;
+	struct zfcp_diag_header *hdr;
+
+	diag = kzalloc(sizeof(*diag), GFP_KERNEL);
+	if (diag == NULL)
+		return -ENOMEM;
+
+	/* setup header for port_data */
+	hdr = &diag->port_data.header;
+
+	spin_lock_init(&hdr->access_lock);
+	hdr->buffer = &diag->port_data.data;
+	hdr->buffer_size = sizeof(diag->port_data.data);
+	/* set the timestamp so that the first test on age will always fail */
+	hdr->timestamp = jiffies - msecs_to_jiffies(ZFCP_DIAG_MAX_AGE);
+
+	adapter->diagnostics = diag;
+	return 0;
+}
+
+/**
+ * zfcp_diag_adapter_free() - Frees all adapter diagnostics allocations.
+ * @adapter: the adapter whose diagnostic structures should be freed.
+ *
+ * Frees all data-structures in the given adapter that store diagnostics
+ * information. Can savely be called with partially setup diagnostics.
+ */
+void zfcp_diag_adapter_free(struct zfcp_adapter *const adapter)
+{
+	kfree(adapter->diagnostics);
+	adapter->diagnostics = NULL;
+}
+
+/**
+ * zfcp_diag_update_xdata() - Update a diagnostics buffer.
+ * @hdr: the meta data to update.
+ * @data: data to use for the update.
+ * @incomplete: flag stating whether the data in @data is incomplete.
+ */
+void zfcp_diag_update_xdata(struct zfcp_diag_header *const hdr,
+			    const void *const data, const bool incomplete)
+{
+	const unsigned long capture_timestamp = jiffies;
+	unsigned long flags;
+
+	spin_lock_irqsave(&hdr->access_lock, flags);
+
+	/* make sure we never go into the past with an update */
+	if (!time_after_eq(capture_timestamp, hdr->timestamp))
+		goto out;
+
+	hdr->timestamp = capture_timestamp;
+	hdr->incomplete = incomplete;
+	memcpy(hdr->buffer, data, hdr->buffer_size);
+out:
+	spin_unlock_irqrestore(&hdr->access_lock, flags);
+}
diff --git a/drivers/s390/scsi/zfcp_diag.h b/drivers/s390/scsi/zfcp_diag.h
new file mode 100644
index 000000000000..2a933326b6e4
--- /dev/null
+++ b/drivers/s390/scsi/zfcp_diag.h
@@ -0,0 +1,60 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * zfcp device driver
+ *
+ * Definitions for handling diagnostics in the the zfcp device driver.
+ *
+ * Copyright IBM Corp. 2018
+ */
+
+#ifndef ZFCP_DIAG_H
+#define ZFCP_DIAG_H
+
+#include <linux/spinlock.h>
+
+#include "zfcp_fsf.h"
+#include "zfcp_def.h"
+
+/**
+ * struct zfcp_diag_header - general part of a diagnostic buffer.
+ * @access_lock: lock protecting all the data in this buffer.
+ * @updating: flag showing that an update for this buffer is currently running.
+ * @incomplete: flag showing that the data in @buffer is incomplete.
+ * @timestamp: time in jiffies when the data of this buffer was last captured.
+ * @buffer: implementation-depending data of this buffer
+ * @buffer_size: size of @buffer
+ */
+struct zfcp_diag_header {
+	spinlock_t	access_lock;
+
+	/* Flags */
+	u64		updating	:1;
+	u64		incomplete	:1;
+
+	unsigned long	timestamp;
+
+	void		*buffer;
+	size_t		buffer_size;
+};
+
+/**
+ * struct zfcp_diag_adapter - central storage for all diagnostics concerning an
+ *			      adapter.
+ * @port_data: data retrieved using exchange port data.
+ * @port_data.header: header with metadata for the cache in @port_data.data.
+ * @port_data.data: cached QTCB Bottom of command exchange port data.
+ */
+struct zfcp_diag_adapter {
+	struct {
+		struct zfcp_diag_header		header;
+		struct fsf_qtcb_bottom_port	data;
+	} port_data;
+};
+
+int zfcp_diag_adapter_setup(struct zfcp_adapter *const adapter);
+void zfcp_diag_adapter_free(struct zfcp_adapter *const adapter);
+
+void zfcp_diag_update_xdata(struct zfcp_diag_header *const hdr,
+			    const void *const data, const bool incomplete);
+
+#endif /* ZFCP_DIAG_H */
diff --git a/drivers/s390/scsi/zfcp_fsf.c b/drivers/s390/scsi/zfcp_fsf.c
index d8f0e446fe13..883bbfd67a62 100644
--- a/drivers/s390/scsi/zfcp_fsf.c
+++ b/drivers/s390/scsi/zfcp_fsf.c
@@ -11,6 +11,7 @@
 #define pr_fmt(fmt) KMSG_COMPONENT ": " fmt
 
 #include <linux/blktrace_api.h>
+#include <linux/jiffies.h>
 #include <linux/types.h>
 #include <linux/slab.h>
 #include <scsi/fc/fc_els.h>
@@ -19,6 +20,7 @@
 #include "zfcp_dbf.h"
 #include "zfcp_qdio.h"
 #include "zfcp_reqlist.h"
+#include "zfcp_diag.h"
 
 /* timeout for FSF requests sent during scsi_eh: abort or FCP TMF */
 #define ZFCP_FSF_SCSI_ER_TIMEOUT (10*HZ)
@@ -655,16 +657,26 @@ static void zfcp_fsf_exchange_port_evaluate(struct zfcp_fsf_req *req)
 
 static void zfcp_fsf_exchange_port_data_handler(struct zfcp_fsf_req *req)
 {
+	struct zfcp_diag_header *const diag_hdr =
+		&req->adapter->diagnostics->port_data.header;
 	struct fsf_qtcb *qtcb = req->qtcb;
+	struct fsf_qtcb_bottom_port *bottom = &qtcb->bottom.port;
 
 	if (req->status & ZFCP_STATUS_FSFREQ_ERROR)
 		return;
 
 	switch (qtcb->header.fsf_status) {
 	case FSF_GOOD:
+		/*
+		 * usually we wait with an update till the cache is too old,
+		 * but because we have the data available, update it anyway
+		 */
+		zfcp_diag_update_xdata(diag_hdr, bottom, false);
+
 		zfcp_fsf_exchange_port_evaluate(req);
 		break;
 	case FSF_EXCHANGE_CONFIG_DATA_INCOMPLETE:
+		zfcp_diag_update_xdata(diag_hdr, bottom, true);
 		req->status |= ZFCP_STATUS_FSFREQ_XDATAINCOMPLETE;
 
 		zfcp_fsf_exchange_port_evaluate(req);
-- 
2.21.0

