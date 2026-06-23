Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36F8F386566;
	Tue, 23 Jun 2026 01:30:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782178256; cv=none; b=ASL+Fe9Z35ehfwW/3fSj0/JfjLUbWolSyCloGPQjCHTeqRJ+0weJazDU/qvF9ngvJHfft1CXsrQebSFHi/VUEu+I9ShGEPRhHMO+Qp2J2fhdG6UzyeRvZZ3HVLLlbUSxtOZVgNr+e8XVpSfX4FhJsl+o91UHWFFMlE0jdqQjCmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782178256; c=relaxed/simple;
	bh=yr18dWNNAE5p3acYad8NVRjCHbxRkno7tzyygfiucFI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HYk5zpsktq9pWRS2/3CX1V0kXtFbST6I+B/1N/XuYxJh5ZAvDoNy1xjO9ovR8jO0QezMqS/FrNGQ4I4JmqSY+tvFImY+iHJtvuXy7Apcan+0BOcCnhiDePsFytm9c5Snm5U63tcKBTrWEMfhOhr1J2fgeDGY3pafBF4qABrr4eI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=W5rA46oN; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="W5rA46oN"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65N0nCqY310031;
	Tue, 23 Jun 2026 01:30:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=/u+OvQ2JmOaOrT5iE
	tXk6TzfZkOHp+xJTmRWkM4cjA0=; b=W5rA46oNfgqOFtpQb0MLdqMmoMQDRz6xp
	XkdK7Gcy591QYavawcuF4SbLPQDi25uPoZ2WsXhd7bo3ikL+sQsr8voKZoVDpsK6
	X2dm3rIy3DwIgQKuherWd1aaj0ErU0GT0av39YOJWkmyZitQOmUCsSD3S0uzjAVO
	HMLKlNPXSEBAnvZ6CvDOSZUv5aX/OhpZvznDrE9TfKuQ8EQ0kIJTvSJ3mMZtrshc
	aLrl2SVolzT9omZi7Mybp9nRCJaGnAgzzMBkrZkQqov0hdVO7LGZtyrZyh4bhTZa
	OzvXarhA/YHgr/kqefIxpMRQsW8IosEZ3gZE17jFLKF3Hvv3PGRBQ==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4ewg9hmbu9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 23 Jun 2026 01:30:43 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 65N1JoJV018411;
	Tue, 23 Jun 2026 01:30:42 GMT
Received: from smtprelay06.wdc07v.mail.ibm.com ([172.16.1.73])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4ex7vygn2y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 23 Jun 2026 01:30:42 +0000 (GMT)
Received: from smtpav04.dal12v.mail.ibm.com (smtpav04.dal12v.mail.ibm.com [10.241.53.103])
	by smtprelay06.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 65N1UeYT19530246
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 23 Jun 2026 01:30:40 GMT
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4BBC358066;
	Tue, 23 Jun 2026 01:30:40 +0000 (GMT)
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B903B58065;
	Tue, 23 Jun 2026 01:30:39 +0000 (GMT)
Received: from li-4c4c4544-0054-3910-8039-c3c04f423534.ibm.com.com (unknown [9.61.188.206])
	by smtpav04.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 23 Jun 2026 01:30:39 +0000 (GMT)
From: Tyrel Datwyler <tyreld@linux.ibm.com>
To: james.bottomley@hansenpartnership.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, brking@linux.ibm.com,
        davemarq@linux.ibm.com, Tyrel Datwyler <tyreld@linux.ibm.com>
Subject: [PATCH 03/29] ibmvfc: split NVMe support into separate source file and add transport stubs
Date: Mon, 22 Jun 2026 18:30:09 -0700
Message-ID: <20260623013035.3436640-4-tyreld@linux.ibm.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260623013035.3436640-1-tyreld@linux.ibm.com>
References: <20260623013035.3436640-1-tyreld@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: tfqL26JnJOEX3eeLtQoc5wdIJA3HnMGn
X-Proofpoint-GUID: tfqL26JnJOEX3eeLtQoc5wdIJA3HnMGn
X-Authority-Analysis: v=2.4 cv=Y4XIdBeN c=1 sm=1 tr=0 ts=6a39e1c3 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=VnNF1IyMAAAA:8 a=JOin0LfSZetdA_WGo5gA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjIzMDAwOCBTYWx0ZWRfX8Ewd/pUu6BzD
 I8l/cM2JvbvBbmo8M3iiC78ERRv4U2Fv/AZm156t1kNpuXR+ex7vTQZbPOOdbCOvOhKZEsdMNWy
 ggGq8ZCLhqvipMj2Laf8sAJ1fi/X924guTWG3jREF/UbTEiupLffxWXb0Yar63zLJqkR1zBrFMR
 XN3dnZWfKpGf/rx84hoZxuwHee4Ppvbx1llKMziqaT281N9UDvay5SWnueI+9YIBsaiISMB+EmX
 vB+6TNaL90ucZBPDAaEiG85TffpW/Dq0XCD0fV4jWBEtf144/x0/d5noTrA/wjzbVEgsrRFF348
 7mbNEjYYJrzYS5LuE5QjwBbguxIi+vfXrEQ+LamaakJSWh/NNGkpUCw8loMoEOxgMl3xIO6S2TC
 rgKa+RUlQ3tSXpgKec0pogbxxMpA2zMwD8QKM+ffH79GgO32T48jTvFiC0dJOlC+kfDC8xf8Uf/
 Re3sbCbi7HxXrOycYbQ==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjIzMDAwOCBTYWx0ZWRfX1kvf1CMfef+X
 GkqfB6JhJcGdhgiufsW3VpctbV4U98NZZHzlayePv9JO7+Mdm4sHpsbw/q+5TQRT6qDM/1i35t9
 CyBkbNA+opHM7m+4kwe/ix8Vpzk8QNo=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-23_01,2026-06-22_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 priorityscore=1501 malwarescore=0 lowpriorityscore=0 spamscore=0
 clxscore=1015 suspectscore=0 impostorscore=0 phishscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2606230008

Rename ibmvfc.c to ibmvfc-core.c as first step in decoupling each
protocol from the core driver logic. Add ibmvfc-nvme.[ch] files, and
register an nvme_fc_port_template with empty callback stubs.

Add empty registration functions definitions for local and remote ports.

No functional NVMe/FC support is added yet.

Signed-off-by: Tyrel Datwyler <tyreld@linux.ibm.com>
---
 drivers/scsi/ibmvscsi/Makefile                |  2 +
 .../scsi/ibmvscsi/{ibmvfc.c => ibmvfc-core.c} | 19 +++-
 drivers/scsi/ibmvscsi/ibmvfc-nvme.c           | 87 +++++++++++++++++++
 drivers/scsi/ibmvscsi/ibmvfc-nvme.h           | 32 +++++++
 drivers/scsi/ibmvscsi/ibmvfc.h                | 10 ++-
 5 files changed, 146 insertions(+), 4 deletions(-)
 rename drivers/scsi/ibmvscsi/{ibmvfc.c => ibmvfc-core.c} (99%)
 create mode 100644 drivers/scsi/ibmvscsi/ibmvfc-nvme.c
 create mode 100644 drivers/scsi/ibmvscsi/ibmvfc-nvme.h

diff --git a/drivers/scsi/ibmvscsi/Makefile b/drivers/scsi/ibmvscsi/Makefile
index 5eb1cb1a0028..9408c7f4cdee 100644
--- a/drivers/scsi/ibmvscsi/Makefile
+++ b/drivers/scsi/ibmvscsi/Makefile
@@ -1,3 +1,5 @@
 # SPDX-License-Identifier: GPL-2.0-only
+ibmvfc-objs := ibmvfc-core.o ibmvfc-nvme.o
+
 obj-$(CONFIG_SCSI_IBMVSCSI)	+= ibmvscsi.o
 obj-$(CONFIG_SCSI_IBMVFC)	+= ibmvfc.o
diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc-core.c
similarity index 99%
rename from drivers/scsi/ibmvscsi/ibmvfc.c
rename to drivers/scsi/ibmvscsi/ibmvfc-core.c
index 912901436442..4e45d23221d6 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
@@ -1,10 +1,11 @@
-// SPDX-License-Identifier: GPL-2.0-or-later
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+
 /*
  * ibmvfc.c -- driver for IBM Power Virtual Fibre Channel Adapter
  *
  * Written By: Brian King <brking@linux.vnet.ibm.com>, IBM Corporation
  *
- * Copyright (C) IBM Corporation, 2008
+ * Copyright (C) IBM Corporation, 2008-2026
  */
 
 #include <linux/module.h>
@@ -46,6 +47,9 @@ static unsigned int cls3_error = IBMVFC_CLS3_ERROR;
 static unsigned int mq_enabled = IBMVFC_MQ;
 static unsigned int nr_scsi_hw_queues = IBMVFC_SCSI_HW_QUEUES;
 static unsigned int nr_scsi_channels = IBMVFC_SCSI_CHANNELS;
+static unsigned int nvme_enabled = IBMVFC_NVME;
+static unsigned int nr_nvme_hw_queues = IBMVFC_NVME_HW_QUEUES;
+static unsigned int nr_nvme_channels = IBMVFC_NVME_CHANNELS;
 static unsigned int mig_channels_only = IBMVFC_MIG_NO_SUB_TO_CRQ;
 static unsigned int mig_no_less_channels = IBMVFC_MIG_NO_N_TO_M;
 
@@ -74,6 +78,16 @@ module_param_named(mig_no_less_channels, mig_no_less_channels, uint, S_IRUGO);
 MODULE_PARM_DESC(mig_no_less_channels, "Prevent migration to system with less channels. "
 		 "[Default=" __stringify(IBMVFC_MIG_NO_N_TO_M) "]");
 
+module_param_named(nvme, nvme_enabled, uint, S_IRUGO);
+MODULE_PARM_DESC(nvme, "Enable NVMe over FC support. "
+		 "[Default=" __stringify(IBMVFC_NVME) "]");
+module_param_named(nvme_host_queues, nr_nvme_hw_queues, uint, S_IRUGO);
+MODULE_PARM_DESC(nvme_host_queues, "Number of NVMeoF Host submission queues. "
+		 "[Default=" __stringify(IBMVFC_NVME_HW_QUEUES) "]");
+module_param_named(nvme_hw_channels, nr_nvme_channels, uint, S_IRUGO);
+MODULE_PARM_DESC(nvme_hw_channels, "Number of hw NVMeoF channels to request. "
+		 "[Default=" __stringify(IBMVFC_NVME_CHANNELS) "]");
+
 module_param_named(init_timeout, init_timeout, uint, S_IRUGO | S_IWUSR);
 MODULE_PARM_DESC(init_timeout, "Initialization timeout in seconds. "
 		 "[Default=" __stringify(IBMVFC_INIT_TIMEOUT) "]");
@@ -468,6 +482,7 @@ static const struct {
 	{ IBMVFC_FABRIC_BUSY, "fabric busy" },
 	{ IBMVFC_PORT_BUSY, "port busy" },
 	{ IBMVFC_BASIC_REJECT, "basic reject" },
+	{ IBMVFC_FC4_LS_REJECT, "fc4 ls reject" },
 };
 
 static const char *unknown_fc_type = "unknown fc type";
diff --git a/drivers/scsi/ibmvscsi/ibmvfc-nvme.c b/drivers/scsi/ibmvscsi/ibmvfc-nvme.c
new file mode 100644
index 000000000000..4a66cde8a8d2
--- /dev/null
+++ b/drivers/scsi/ibmvscsi/ibmvfc-nvme.c
@@ -0,0 +1,87 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+
+/*
+ * ibmvfc-nvme.c -- IBM Power Virtual Fibre Channel NVMeoF HBA driver
+ *
+ * Written By: Tyrel Datwyler <tyreld@linux.ibm.com>, IBM Corporation
+ *
+ * Copyright (C) IBM Corporation, 2026
+ */
+
+#include <scsi/scsi_transport_fc.h>
+
+#include "ibmvfc-nvme.h"
+
+static void ibmvfc_nvme_localport_delete(struct nvme_fc_local_port *lport)
+{
+}
+
+static void ibmvfc_nvme_remoteport_delete(struct nvme_fc_remote_port *rport)
+{
+}
+
+static int ibmvfc_nvme_ls_req(struct nvme_fc_local_port *lport,
+			      struct nvme_fc_remote_port *rport,
+			      struct nvmefc_ls_req *ls_req)
+{
+	return 0;
+}
+
+static void ibmvfc_nvme_ls_abort(struct nvme_fc_local_port *lport,
+				struct nvme_fc_remote_port *rport,
+				struct nvmefc_ls_req *ls_abort)
+{
+}
+
+static int ibmvfc_nvme_fcp_io(struct nvme_fc_local_port *lport,
+			      struct nvme_fc_remote_port *rport,
+			      void *hw_queue_handle,
+			      struct nvmefc_fcp_req *fcp_req)
+{
+	return 0;
+}
+
+static void ibmvfc_nvme_fcp_abort(struct nvme_fc_local_port *lport,
+				  struct nvme_fc_remote_port *rport,
+				  void *hw_queue_handle,
+				  struct nvmefc_fcp_req *abort_req)
+{
+}
+
+static struct nvme_fc_port_template ibmvfc_nvme_fc_transport = {
+	.localport_delete	= ibmvfc_nvme_localport_delete,
+	.remoteport_delete	= ibmvfc_nvme_remoteport_delete,
+	.create_queue		= NULL,
+	.delete_queue		= NULL,
+	.ls_req			= ibmvfc_nvme_ls_req,
+	.ls_abort		= ibmvfc_nvme_ls_abort,
+	.fcp_io			= ibmvfc_nvme_fcp_io,
+	.fcp_abort		= ibmvfc_nvme_fcp_abort,
+	.map_queues		= NULL,
+	.max_hw_queues		= IBMVFC_NVME_HW_QUEUES,
+	.max_sgl_segments	= 1024,
+	.max_dif_sgl_segments	= 64,
+	.dma_boundary		= 0xFFFFFFFF,
+	.local_priv_sz		= sizeof(struct ibmvfc_host *),
+	.remote_priv_sz		= sizeof(struct ibmvfc_target *),
+	.lsrqst_priv_sz		= sizeof(struct ibmvfc_event *),
+	.fcprqst_priv_sz	= sizeof(struct ibmvfc_event *),
+};
+
+int ibmvfc_nvme_register_remoteport(struct ibmvfc_target *tgt)
+{
+	return 0;
+}
+
+void ibmvfc_nvme_unregister_remoteport(struct ibmvfc_target *tgt)
+{
+}
+
+int ibmvfc_nvme_register(struct ibmvfc_host *vhost)
+{
+	return 0;
+}
+
+void ibmvfc_nvme_unregister(struct ibmvfc_host *vhost)
+{
+}
diff --git a/drivers/scsi/ibmvscsi/ibmvfc-nvme.h b/drivers/scsi/ibmvscsi/ibmvfc-nvme.h
new file mode 100644
index 000000000000..97e267871df2
--- /dev/null
+++ b/drivers/scsi/ibmvscsi/ibmvfc-nvme.h
@@ -0,0 +1,32 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+
+/*
+ * ibmvfc-nvme.h -- IBM Power Virtual Fibre Channel NVMeoF HBA driver
+ *
+ * Written By: Tyrel Datwyler <tyreld@linux.ibm.com>, IBM Corporation
+ *
+ * Copyright (C) IBM Corporation, 2026
+ */
+
+#ifndef _IBMVFC_NVME_H
+#define _IBMVFC_NVME_H
+
+#include <uapi/scsi/fc/fc_fs.h>
+#include <uapi/scsi/fc/fc_els.h>
+#include <linux/nvme-fc-driver.h>
+
+#include "ibmvfc.h"
+
+#define IBMVFC_NVME		0
+#define IBMVFC_NVME_HW_QUEUES	8
+#define IBMVFC_MAX_NVME_QUEUES	16
+#define IBMVFC_NVME_CHANNELS	8
+
+struct ibmvfc_host;
+struct ibmvfc_target;
+
+int ibmvfc_nvme_register_remoteport(struct ibmvfc_target *tgt);
+void ibmvfc_nvme_unregister_remoteport(struct ibmvfc_target *tgt);
+int ibmvfc_nvme_register(struct ibmvfc_host *vhost);
+void ibmvfc_nvme_unregister(struct ibmvfc_host *vhost);
+#endif
diff --git a/drivers/scsi/ibmvscsi/ibmvfc.h b/drivers/scsi/ibmvscsi/ibmvfc.h
index f8a2bf92da41..f137b61ce422 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.h
+++ b/drivers/scsi/ibmvscsi/ibmvfc.h
@@ -1,22 +1,27 @@
 /* SPDX-License-Identifier: GPL-2.0-or-later */
+
 /*
  * ibmvfc.h -- driver for IBM Power Virtual Fibre Channel Adapter
  *
  * Written By: Brian King <brking@linux.vnet.ibm.com>, IBM Corporation
  *
- * Copyright (C) IBM Corporation, 2008
+ * Copyright (C) IBM Corporation, 2008-2026
  */
 
 #ifndef _IBMVFC_H
 #define _IBMVFC_H
 
+#include <linux/interrupt.h>
 #include <linux/list.h>
 #include <linux/types.h>
+#include <scsi/scsi_device.h>
 #include <scsi/viosrp.h>
 #include <linux/nvme.h>
 #include <linux/nvme-fc.h>
 
-#define IBMVFC_NAME	"ibmvfc"
+#include "ibmvfc-nvme.h"
+
+#define IBMVFC_NAME			"ibmvfc"
 #define IBMVFC_DRIVER_VERSION		"1.0.11"
 #define IBMVFC_DRIVER_DATE		"(April 12, 2013)"
 
@@ -984,6 +989,7 @@ struct ibmvfc_host {
 	unsigned int mq_enabled:1;
 	unsigned int using_channels:1;
 	unsigned int do_enquiry:1;
+	unsigned int nvme_enabled:1;
 	unsigned int aborting_passthru:1;
 	unsigned int scan_complete:1;
 	int scan_timeout;
-- 
2.54.0

