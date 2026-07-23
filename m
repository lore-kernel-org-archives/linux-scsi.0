Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1EB91F09A8;
	Thu, 23 Jul 2026 00:02:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784764937; cv=none; b=gjUMCtFTFdKoN2SAFe4PoY5rx2bO4K1wSscOdK3Mhg4pr+rI8ai/I21fS8oJgM+2k9Pm+GWRPqaOwLghOVaVECKEmY0OQ5MHtJnQFwaOrkZPbrPAKelkRWBRfuJt51F/8S2WOUNIMBH4GUdqE6p357+wMKR5wwm5gCtlaHsBIkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784764937; c=relaxed/simple;
	bh=ulEkcQ9TkuiQl9DO+x3sAN2usV7oas5mslN8eG/zUOA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C9tYzjMqJTyT8pplGW2V/o35vR3hZJtFMsKHogzPkJvfk8XIkmWnJ0J6Nbx8H/4jLJQVNDaef4OEVBdI3Wdyy0b14FFwiC5uMw0TY9ogNJt214k/3Pi036l1zgZp7Ej2HqKnn69QJZgg567h02Gj9sZTLjD7pQ49PPP5C+8Tgf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=nURIKGF2; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="nURIKGF2"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66MIBeQl704617;
	Thu, 23 Jul 2026 00:02:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=MCx2SKsdTvOPd257e
	JjO62OaAhnxhj5wgcZ1jWwH9XA=; b=nURIKGF2b6rI1BLJz9t5GGkaQddAtbjxv
	zOkQniaroyaUcevsVqa5Ax+P+IHXV/azjN5hCPYsKEoBtDKmvETI9cG3TQ7ZX7zk
	7IRpKLQZ/RQEMouEMNRHvr2oUj52mfCv4Aqdq09vVSfFRKPeRMkMlDSTC12A1MSi
	yYdBKy8sQjCBEnGkLdXtcQBpC+jM7Hw+iy8wkQaThglgmtnAz5FIFcfoQCJHVWYh
	1q6lg2TdVdczKwaDTDLodIZOgsmipwqdCSjjQ3vaepQ4rz45ueZZhgpAcdOO2E8v
	BI3Z+Fz6y51HvWbvFMc4fglrSv5P7iBc5Gcv+feqyscLKGx1HBmmw==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fg7abmyn0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 23 Jul 2026 00:02:01 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 66MNnt25021850;
	Thu, 23 Jul 2026 00:01:59 GMT
Received: from smtprelay07.dal12v.mail.ibm.com ([172.16.1.9])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4fgm6w9uj1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 23 Jul 2026 00:01:59 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (smtpav03.dal12v.mail.ibm.com [10.241.53.102])
	by smtprelay07.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 66N01wsp62259632
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 23 Jul 2026 00:01:58 GMT
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B5EE558063;
	Thu, 23 Jul 2026 00:01:58 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2356D58061;
	Thu, 23 Jul 2026 00:01:58 +0000 (GMT)
Received: from li-4c4c4544-0054-3910-8039-c3c04f423534.ibm.com.com (unknown [9.61.118.58])
	by smtpav03.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 23 Jul 2026 00:01:58 +0000 (GMT)
From: Tyrel Datwyler <tyreld@linux.ibm.com>
To: james.bottomley@hansenpartnership.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, brking@linux.ibm.com,
        davemarq@linux.ibm.com, Tyrel Datwyler <tyreld@linux.ibm.com>
Subject: [PATCH v2 07/33] ibmvfc: split NVMe support into separate source file and add transport stubs
Date: Wed, 22 Jul 2026 17:01:23 -0700
Message-ID: <20260723000149.969416-8-tyreld@linux.ibm.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260723000149.969416-1-tyreld@linux.ibm.com>
References: <20260723000149.969416-1-tyreld@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIyMDIzNCBTYWx0ZWRfX8V/IJaqbSqLw
 xMZnSs37XIOoAoXaiaNp5dF/43D39l5ARkjsnsFn9PYRhWzRnv1meu/sHNCxv9J62beLOTrgdS/
 fIQeLlQS5sdI3sEpk2ZCZi37jH5vUhKbFm5Bcy36MZJo6xswULCy1XGUivptsUoWGxJIb1T5zQd
 3lMhX2wD6N9MPQRMC7b9oeM5OrQ2RLxEUVpa+ukEEU6dk0acaeJGscAc5c99cAj/RTfiNOVkOpN
 lwLjqz8Vmohbg7h9VUjk9F+6esZpBmW+uE1mOIgdg92RkNEwfFf0vamPaDTLUOv5rMNvRpx6uZf
 k7M7HiQuMQtZq1TuRm5eQps5VUWKer9cIuTSpKngXbAOKEmoB9et5J56Xpk/EXZpS+tS1qyIxm5
 B6P4Wg1W0atbVMMLJPD0I4B+pdUSXsdZaLzPAFU7dnIJbNE8uUQ3ynR4CCSesY8923I6lsil4Pj
 6VEBnUkNRjiO888DqHA==
X-Authority-Analysis: v=2.4 cv=F7ZnsKhN c=1 sm=1 tr=0 ts=6a6159f9 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=iQ6ETzBq9ecOQQE5vZCe:22 a=VnNF1IyMAAAA:8 a=yJGABh1QRkCQoVjB2OEA:9
X-Proofpoint-ORIG-GUID: BHX69P6FTkIEuNN-5sCCStkaey8OTkBj
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIyMDIzNCBTYWx0ZWRfX2n7WXpH2WRcX
 Ns01HLerT4X9ota4ohv42rPuFbVarG0Zr819kcwDRblLWZa7k0xgXfsMTuqAGE3eE+tZ3hGk8lT
 VHCsBdRx70eUh/BNcm5L1Xbo2DnrrsY=
X-Proofpoint-GUID: BHX69P6FTkIEuNN-5sCCStkaey8OTkBj
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-22_05,2026-07-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 phishscore=0 bulkscore=0 clxscore=1015 priorityscore=1501
 impostorscore=0 lowpriorityscore=0 suspectscore=0 malwarescore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607220234

Rename ibmvfc.c to ibmvfc-core.c as first step in decoupling each
protocol from the core driver logic. Add ibmvfc-nvme.[ch] files, and
register an nvme_fc_port_template with empty callback stubs.

Add empty registration functions definitions for local and remote ports.

No functional NVMe/FC support is added yet.

Signed-off-by: Tyrel Datwyler <tyreld@linux.ibm.com>
---
 drivers/scsi/ibmvscsi/Makefile                |  2 +
 .../scsi/ibmvscsi/{ibmvfc.c => ibmvfc-core.c} | 19 +++-
 drivers/scsi/ibmvscsi/ibmvfc-nvme.c           | 97 +++++++++++++++++++
 drivers/scsi/ibmvscsi/ibmvfc-nvme.h           | 32 ++++++
 drivers/scsi/ibmvscsi/ibmvfc.h                | 10 +-
 5 files changed, 156 insertions(+), 4 deletions(-)
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
index 78b4ac201a49..56f4fb200a69 100644
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
index 000000000000..2ee1c64665d9
--- /dev/null
+++ b/drivers/scsi/ibmvscsi/ibmvfc-nvme.c
@@ -0,0 +1,97 @@
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
+	if (!IS_ENABLED(CONFIG_NVME_FC))
+		return 0;
+
+	return 0;
+}
+
+void ibmvfc_nvme_unregister_remoteport(struct ibmvfc_target *tgt)
+{
+	if (!IS_ENABLED(CONFIG_NVME_FC))
+		return;
+}
+
+int ibmvfc_nvme_register(struct ibmvfc_host *vhost)
+{
+	if (!IS_ENABLED(CONFIG_NVME_FC))
+		return 0;
+
+	return 0;
+}
+
+void ibmvfc_nvme_unregister(struct ibmvfc_host *vhost)
+{
+	if (!IS_ENABLED(CONFIG_NVME_FC))
+		return;
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
2.55.0

