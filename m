Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81870334692;
	Fri, 11 Sep 2026 05:48:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789105729; cv=none; b=utiUpIo2C2qvIDJf4EsOaKtY0KKx8Sy8ySD/PwukvegVY+b/D1jl3TyuQMfoUdQcfTf7XrMwAfGEyTyUctdK+k9prunUKpU6oBpVQLzogVqgUxnGirW1R/1Shq9wi/k5oc3AM4Bm3loUgaUzowNfHGBDTKwNScw8eJuneDvkV8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789105729; c=relaxed/simple;
	bh=1iAz/FwkFUfRNMCJJcssYt/Vbylm5hF7cCUjALnwLd4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k9Fvkrrwom2oxYa+hl9cr1gy4TVCGyVXKXQRKodE3jgBzp/tg3BX7z1ejlrjGLPkwTlb1ryeVpQvEt1NwsoCRNNvD7QllwidaB52dS9iQOUY8+YTNV0Era4bzyC8NceRSgDaPifW6dmwDSoFs+4ILOG4ICnTdBwZrsoBPDse9x8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=DGrgTMNS; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="DGrgTMNS"
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68B4VaUC3839771;
	Fri, 11 Sep 2026 05:48:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=EpCYtOxPZ2tUA2BZa
	rIXbS/bz+YQP/qiN7gN/t4xT2M=; b=DGrgTMNSb1WPgvpxhx8mpDjNHsJar39ao
	ZA+F+1hJ5WTW5yKTzCAHqPu5xjUUMkulJButuV0gdKADMeqs7LZmeHPK/lUPOj4o
	qwcNkjAYFA/TdROrVH5fat1HiXxnhumzSxfSM3DnN9NUZIGtZey0SqiyF75Stz/r
	qtICOHiWKxzhTitmtidHJ8RWax8xBtxUVedPLLWu+XySmXMUFvLWfAsKniSaJ1s7
	ps1KRXiCct7ZlXjqrwohnGPeJbJds8UKcHnMzVJv4kRqsxddICc34U14YfT7JzLE
	/r7fNrTt9i1jIW3h6o100NdZSE3OGgpJPdWHlHY73adWQ5QVddKxA==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gkd8q9g64-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 11 Sep 2026 05:48:39 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 68B4K2H11076021;
	Fri, 11 Sep 2026 05:48:38 GMT
Received: from smtprelay02.dal12v.mail.ibm.com ([172.16.1.4])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4gkvwk4j77-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 11 Sep 2026 05:48:38 +0000 (GMT)
Received: from smtpav02.dal12v.mail.ibm.com (smtpav02.dal12v.mail.ibm.com [10.241.53.101])
	by smtprelay02.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 68B5mbP15046974
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 11 Sep 2026 05:48:37 GMT
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6CB0E58051;
	Fri, 11 Sep 2026 05:48:37 +0000 (GMT)
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BF1F15805C;
	Fri, 11 Sep 2026 05:48:36 +0000 (GMT)
Received: from li-4c4c4544-0054-3910-8039-c3c04f423534.ibm.com.com (unknown [9.61.103.123])
	by smtpav02.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 11 Sep 2026 05:48:36 +0000 (GMT)
From: Tyrel Datwyler <tyreld@linux.ibm.com>
To: james.bottomley@hansenpartnership.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, brking@linux.ibm.com,
        davemarq@linux.ibm.com, Tyrel Datwyler <tyreld@linux.ibm.com>
Subject: [PATCH v10 1/9] scsi: ibmvfc: add basic FPIN support
Date: Thu, 10 Sep 2026 22:48:24 -0700
Message-ID: <20260911054832.1311668-2-tyreld@linux.ibm.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260911054832.1311668-1-tyreld@linux.ibm.com>
References: <20260911054832.1311668-1-tyreld@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: utan3yv07Yj6dE2FSaZNX_C8M-MYQiK_
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTExMDA3NCBTYWx0ZWRfX4OtMWUrTgc2G
 V+RLiAm8oC1Bc9K8n47P0w+/vuQyuasHIFOl8QhebXOmeD8Qsa4OurGkTfu7RW3yEiCGzKZRTwr
 DvHyBup3ZV7qk0R9k6RfGWb3h13TyaU=
X-Authority-Analysis: v=2.4 cv=E/dYNqdl c=1 sm=1 tr=0 ts=6aa39637 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=V8glGbnc2Ofi9Qvn3v5h:22 a=VnNF1IyMAAAA:8 a=spueyG-pivhLj-E1BzsA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTExMDA3NCBTYWx0ZWRfX4uVXL0PekHKt
 7rtPBUitSNNCi48s+Egf2ZcX3XycFCVudUY9T7wc9L6+3/jIm+Pfr7yJ4rnlf6mc7yzCyzjfDjP
 AktzvgWVJkL0VzVINAeshiS79IaYHHuEcS0/69gnvtiVG0i3eEg2G9M81w0o93SlaU3tVGT3PRN
 n/pt8Ydhp3vjm/Kq/Ex6zIIt5t1aMREkIy4IK4aufBLYwc39dYxPwX2SprVOIkYIbEhTDusLFYm
 HiOfTIItmtNI2SEC2g1/ZPbIFV73rZzrJ4SZqFw8A70inZFfzXljI+REig7pacq2gf3+n3nwlCB
 Nw1Nt7K5kpMnQeuoWa5Y0VM3rvo0afWS3Srh6QC1ElUVxG8Mh3hMYrzVJ8flZWFNUI/Sy3L3IKR
 lgO2VrBmUGex05LYKCIWrYCDRSSgKNcyLmO+cLNDcYChvUTpzLvnlUldb1H0k4ESP7hsCelVUl/
 tY/sry1IHRGWUo3Be7g==
X-Proofpoint-GUID: utan3yv07Yj6dE2FSaZNX_C8M-MYQiK_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-11_02,2026-09-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 suspectscore=0 spamscore=0 bulkscore=0 clxscore=1015
 impostorscore=0 phishscore=0 adultscore=0 lowpriorityscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609110074

From: Dave Marquardt <davemarq@linux.ibm.com>

Implement support for a basic level of Fabric Performance Impact
Notifications (FPIN) in the ibmvfc driver to enable monitoring of
fabric congestion and link integrity events.

Add async event handler for IBMVFC_AE_FPIN events that offloads FPIN
processing to a dedicated workqueue. Convert VIOS FPIN messages to
standard fc_els_fpin structures and pass them to fc_host_fpin_rcv() for
processing by the FC transport layer.

Introduce common FPIN conversion routines that will be reused for full
and extended FPIN support in subsequent patches. Add KUnit test
infrastructure to validate FPIN event handling and statistics updates.

Add ibmvfc_handle_async() support for IBMVFC_AE_FPIN events, a dedicated
workqueue for FPIN processing, FPIN message conversion to fc_els_fpin
format, handling of link congestion, port congestion, port cleared, port
degraded, and congestion cleared events, and a KUnit test module for
FPIN functionality.

Signed-off-by: Dave Marquardt <davemarq@linux.ibm.com>
[tyreld: add & operator to irqsave/restore calls]
[tyreld: check for valid fc or nvme port in ibmvfc_find_target]
[tyreld: remove kunit tests meant for later patchs]
Signed-off-by: Tyrel Datwyler <tyreld@linux.ibm.com>
---
 drivers/scsi/Kconfig                 |  10 +
 drivers/scsi/ibmvscsi/Makefile       |   1 +
 drivers/scsi/ibmvscsi/ibmvfc-core.c  | 297 ++++++++++++++++++++++++++-
 drivers/scsi/ibmvscsi/ibmvfc.h       |  17 ++
 drivers/scsi/ibmvscsi/ibmvfc_kunit.c | 148 +++++++++++++
 5 files changed, 468 insertions(+), 5 deletions(-)
 create mode 100644 drivers/scsi/ibmvscsi/ibmvfc_kunit.c

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 1eec66195cf4..320c37c4ab36 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -760,6 +760,16 @@ config SCSI_IBMVFC
 	  To compile this driver as a module, choose M here: the
 	  module will be called ibmvfc.
 
+config SCSI_IBMVFC_KUNIT_TEST
+	tristate "KUnit tests for the IBM POWER Virtual FC Client" if !KUNIT_ALL_TESTS
+	depends on SCSI_IBMVFC && KUNIT
+	default KUNIT_ALL_TESTS
+	help
+	  Compile IBM POWER Virtual FC client KUnit tests. These tests
+	  specifically test FPIN functionality. To compile this driver
+	  as a module, choose M here: the module will be called
+	  ibmvfc_kunit.
+
 config SCSI_IBMVFC_TRACE
 	bool "enable driver internal trace"
 	depends on SCSI_IBMVFC
diff --git a/drivers/scsi/ibmvscsi/Makefile b/drivers/scsi/ibmvscsi/Makefile
index 9408c7f4cdee..a227bc633f3a 100644
--- a/drivers/scsi/ibmvscsi/Makefile
+++ b/drivers/scsi/ibmvscsi/Makefile
@@ -3,3 +3,4 @@ ibmvfc-objs := ibmvfc-core.o ibmvfc-nvme.o
 
 obj-$(CONFIG_SCSI_IBMVSCSI)	+= ibmvscsi.o
 obj-$(CONFIG_SCSI_IBMVFC)	+= ibmvfc.o
+obj-$(CONFIG_SCSI_IBMVFC_KUNIT_TEST)	+= ibmvfc_kunit.o
diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/ibmvfc-core.c
index aa7ae81df41b..514fc87c1017 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
@@ -31,6 +31,9 @@
 #include <scsi/scsi_tcq.h>
 #include <scsi/scsi_transport_fc.h>
 #include <scsi/scsi_bsg_fc.h>
+#include <kunit/visibility.h>
+#include <scsi/fc/fc_els.h>
+#include <linux/overflow.h>
 #include "ibmvfc.h"
 
 static unsigned int init_timeout = IBMVFC_INIT_TIMEOUT;
@@ -1433,6 +1436,7 @@ void ibmvfc_release_tgt(struct kref *kref)
 	struct ibmvfc_target *tgt = container_of(kref, struct ibmvfc_target, kref);
 	mempool_free(tgt, tgt->vhost->tgt_pool);
 }
+EXPORT_SYMBOL_IF_KUNIT(ibmvfc_release_tgt);
 
 /**
  * ibmvfc_get_starget_node_name - Get SCSI target's node name
@@ -3213,6 +3217,7 @@ static const struct ibmvfc_async_desc ae_desc [] = {
 	{ "Halt",	IBMVFC_AE_HALT,		IBMVFC_DEFAULT_LOG_LEVEL },
 	{ "Resume",	IBMVFC_AE_RESUME,	IBMVFC_DEFAULT_LOG_LEVEL },
 	{ "Adapter Failed", IBMVFC_AE_ADAPTER_FAILED, IBMVFC_DEFAULT_LOG_LEVEL },
+	{ "FPIN",	IBMVFC_AE_FPIN,		IBMVFC_DEFAULT_LOG_LEVEL },
 };
 
 static const struct ibmvfc_async_desc unknown_ae = {
@@ -3261,16 +3266,259 @@ static const char *ibmvfc_get_link_state(enum ibmvfc_ae_link_state state)
 	return "";
 }
 
+#define IBMVFC_FPIN_CONGN_DESC_SZ (sizeof(struct fc_els_fpin) + sizeof(struct fc_fn_congn_desc))
+#define IBMVFC_FPIN_LI_DESC_SZ (sizeof(struct fc_els_fpin) + \
+				struct_size_t(struct fc_fn_li_desc, pname_list, 1))
+#define IBMVFC_FPIN_PEER_CONGN_DESC_SZ (sizeof(struct fc_els_fpin) + \
+					struct_size_t(struct fc_fn_peer_congn_desc, pname_list, 1))
+
+/**
+ * ibmvfc_fpin_size_helper(): compute fpin structure size based on fpin status
+ * @fpin_status: status value
+ *
+ * Return:
+ * 0: invalid fpin_status
+ * other: valid size
+ */
+static size_t ibmvfc_fpin_size_helper(u8 fpin_status)
+{
+	size_t size = 0;
+
+	switch (fpin_status) {
+	case IBMVFC_AE_FPIN_LINK_CONGESTED:
+	case IBMVFC_AE_FPIN_CONGESTION_CLEARED:
+		size = IBMVFC_FPIN_CONGN_DESC_SZ;
+		break;
+	case IBMVFC_AE_FPIN_PORT_CONGESTED:
+	case IBMVFC_AE_FPIN_PORT_CLEARED:
+		size = IBMVFC_FPIN_PEER_CONGN_DESC_SZ;
+		break;
+	case IBMVFC_AE_FPIN_PORT_DEGRADED:
+		size = IBMVFC_FPIN_LI_DESC_SZ;
+		break;
+	default:
+		break;
+	}
+
+	return size;
+}
+
+/**
+ * ibmvfc_common_fpin_to_desc(): allocate and populate a struct fc_els_fpin struct
+ * containing a descriptor.
+ *
+ * Allocate a struct fc_els_fpin containing a descriptor and populate
+ * based on data from *ibmvfc_fpin.
+ *
+ * Return:
+ * NULL     - unable to allocate structure
+ * non-NULL - pointer to populated struct fc_els_fpin
+ */
+static struct fc_els_fpin *
+ibmvfc_common_fpin_to_desc(u8 fpin_status, __be64 wwpn, __be16 type, __be16 modifier,
+			   __be32 threshold, __be32 event_count)
+{
+	struct fc_fn_peer_congn_desc *pdesc;
+	struct fc_fn_congn_desc *cdesc;
+	struct fc_fn_li_desc *ldesc;
+	struct fc_els_fpin *fpin;
+	size_t size;
+
+	size = ibmvfc_fpin_size_helper(fpin_status);
+	if (!size)
+		return NULL;
+
+	fpin = kzalloc(size, GFP_KERNEL);
+	if (!fpin)
+		return NULL;
+
+	fpin->fpin_cmd = ELS_FPIN;
+
+	switch (fpin_status) {
+	case IBMVFC_AE_FPIN_CONGESTION_CLEARED:
+	case IBMVFC_AE_FPIN_LINK_CONGESTED:
+		fpin->desc_len = cpu_to_be32(sizeof(struct fc_fn_congn_desc));
+		cdesc = (struct fc_fn_congn_desc *)fpin->fpin_desc;
+		cdesc->desc_tag = cpu_to_be32(ELS_DTAG_CONGESTION);
+		cdesc->desc_len = cpu_to_be32(FC_TLV_DESC_LENGTH_FROM_SZ(*cdesc));
+		cdesc->event_type = type;
+		cdesc->event_modifier = modifier;
+		cdesc->event_period = cpu_to_be32(IBMVFC_FPIN_DEFAULT_EVENT_PERIOD);
+		cdesc->severity = FPIN_CONGN_SEVERITY_WARNING;
+		break;
+	case IBMVFC_AE_FPIN_PORT_CONGESTED:
+	case IBMVFC_AE_FPIN_PORT_CLEARED:
+		fpin->desc_len =
+			cpu_to_be32(struct_size_t(struct fc_fn_peer_congn_desc, pname_list, 1));
+		pdesc = (struct fc_fn_peer_congn_desc *)fpin->fpin_desc;
+		pdesc->desc_tag = cpu_to_be32(ELS_DTAG_PEER_CONGEST);
+		pdesc->desc_len = cpu_to_be32(struct_size_t(struct fc_fn_peer_congn_desc,
+							    pname_list, 1) - FC_TLV_DESC_HDR_SZ);
+		pdesc->event_type = type;
+		pdesc->event_modifier = modifier;
+		pdesc->event_period = cpu_to_be32(IBMVFC_FPIN_DEFAULT_EVENT_PERIOD);
+		pdesc->attached_wwpn = wwpn;
+		pdesc->pname_count = cpu_to_be32(1);
+		pdesc->pname_list[0] = wwpn;
+		break;
+	case IBMVFC_AE_FPIN_PORT_DEGRADED:
+		fpin->desc_len = cpu_to_be32(struct_size_t(struct fc_fn_li_desc, pname_list, 1));
+		ldesc = (struct fc_fn_li_desc *)fpin->fpin_desc;
+		ldesc->desc_tag = cpu_to_be32(ELS_DTAG_LNK_INTEGRITY);
+		ldesc->desc_len = cpu_to_be32(struct_size_t(struct fc_fn_li_desc,
+							    pname_list, 1) - FC_TLV_DESC_HDR_SZ);
+		ldesc->event_type = type;
+		ldesc->event_modifier = modifier;
+		ldesc->event_threshold = threshold;
+		ldesc->event_count = event_count;
+		ldesc->attached_wwpn = wwpn;
+		ldesc->pname_count = cpu_to_be32(1);
+		ldesc->pname_list[0] = wwpn;
+		break;
+	default:
+		/* This should be caught above. */
+		kfree(fpin);
+		fpin = NULL;
+		break;
+	}
+
+	return fpin;
+}
+
+/**
+ * ibmvfc_basic_fpin_to_desc(): allocate and populate a struct fc_els_fpin struct
+ * containing a descriptor.
+ * @ibmvfc_fpin: Pointer to async crq
+ *
+ * Allocate a struct fc_els_fpin containing a descriptor and populate
+ * based on data from *ibmvfc_fpin.
+ *
+ * Return:
+ * NULL     - unable to allocate structure
+ * non-NULL - pointer to populated struct fc_els_fpin
+ */
+static struct fc_els_fpin *
+ibmvfc_basic_fpin_to_desc(struct ibmvfc_async_crq *crq, u64 wwpn)
+{
+	__be16 type;
+
+	switch (crq->fpin_status) {
+	case IBMVFC_AE_FPIN_LINK_CONGESTED:
+	case IBMVFC_AE_FPIN_PORT_CONGESTED:
+		type = cpu_to_be16(FPIN_CONGN_DEVICE_SPEC);
+		break;
+	case IBMVFC_AE_FPIN_PORT_CLEARED:
+	case IBMVFC_AE_FPIN_CONGESTION_CLEARED:
+		type = cpu_to_be16(FPIN_CONGN_CLEAR);
+		break;
+	case IBMVFC_AE_FPIN_PORT_DEGRADED:
+		type = cpu_to_be16(FPIN_LI_UNKNOWN);
+		break;
+	default:
+		return NULL;
+	}
+
+	return ibmvfc_common_fpin_to_desc(crq->fpin_status, cpu_to_be64(wwpn),
+					  type, cpu_to_be16(0),
+					  cpu_to_be32(IBMVFC_FPIN_DEFAULT_EVENT_THRESHOLD),
+					  cpu_to_be32(1));
+}
+
+/**
+ * ibmvfc_find_target - Search for a target in a target list
+ * @target_list: list head of targets to search
+ * @scsi_id: SCSI ID to match (0 to skip this check)
+ * @wwpn: WWPN to match (0 to skip this check)
+ * @node_name: Node name to match (0 to skip this check)
+ *
+ * Returns:
+ * Pointer to matching target, or NULL if not found
+ **/
+static struct ibmvfc_target *ibmvfc_find_target(struct list_head *target_list,
+						__be64 scsi_id, __be64 wwpn,
+						__be64 node_name)
+{
+	struct ibmvfc_target *tgt;
+
+	list_for_each_entry(tgt, target_list, queue) {
+		if (scsi_id && cpu_to_be64(tgt->scsi_id) != scsi_id)
+			continue;
+		if (wwpn && cpu_to_be64(tgt->ids.port_name) != wwpn)
+			continue;
+		if (node_name && cpu_to_be64(tgt->ids.node_name) != node_name)
+			continue;
+		if (!tgt->rport && !tgt->nvme_remote_port)
+			continue;
+		return tgt;
+	}
+
+	return NULL;
+}
+
+/**
+ * ibmvfc_process_async_work - Process IBMVFC_AE_FPIN async CRQ from work queue
+ * @work: pointer to work_struct
+ */
+static void ibmvfc_process_async_work(struct work_struct *work)
+{
+	struct ibmvfc_async_work *aw;
+	struct ibmvfc_async_crq *crq;
+	struct ibmvfc_target *tgt;
+	struct ibmvfc_host *vhost;
+	struct fc_els_fpin *fpin;
+	unsigned long flags;
+
+	aw = container_of_const(work, struct ibmvfc_async_work, async_work_s);
+	vhost = aw->vhost;
+	crq = &aw->crq;
+
+	if (!crq->scsi_id && !crq->wwpn && !crq->node_name)
+		goto free;
+
+	spin_lock_irqsave(&vhost->host->host_lock, flags);
+	tgt = ibmvfc_find_target(&vhost->scsi_scrqs.targets, crq->scsi_id,
+				 crq->wwpn, crq->node_name);
+	if (!tgt) {
+		/* Target not found in scsi_scrqs, search nvme_scrqs */
+		tgt = ibmvfc_find_target(&vhost->nvme_scrqs.targets,
+					 crq->scsi_id, crq->wwpn,
+					 crq->node_name);
+	}
+
+	if (tgt) {
+		kref_get(&tgt->kref);
+		spin_unlock_irqrestore(&vhost->host->host_lock, flags);
+	} else {
+		spin_unlock_irqrestore(&vhost->host->host_lock, flags);
+		dev_err_ratelimited(vhost->dev, "Invalid target for FPIN\n");
+		goto free;
+	}
+
+	fpin = ibmvfc_basic_fpin_to_desc(crq, tgt->wwpn);
+	if (fpin) {
+		fc_host_fpin_rcv(tgt->vhost->host,
+				 sizeof(*fpin) + be32_to_cpu(fpin->desc_len),
+				 (char *)fpin, 0);
+		kfree(fpin);
+	} else
+		dev_err_ratelimited(vhost->dev, "FPIN event received, unable to process\n");
+
+	kref_put(&tgt->kref, ibmvfc_release_tgt);
+ free:
+	kfree(aw);
+}
+
 /**
  * ibmvfc_handle_async - Handle an async event from the adapter
  * @crq:	crq to process
  * @vhost:	ibmvfc host struct
  *
  **/
-static void ibmvfc_handle_async(struct ibmvfc_async_crq *crq,
-				struct ibmvfc_host *vhost)
+VISIBLE_IF_KUNIT void ibmvfc_handle_async(struct ibmvfc_async_crq *crq,
+					  struct ibmvfc_host *vhost)
 {
 	const struct ibmvfc_async_desc *desc = ibmvfc_get_ae_desc(be64_to_cpu(crq->event));
+	struct ibmvfc_async_work *aw;
 	struct ibmvfc_target *tgt;
 
 	ibmvfc_log(vhost, desc->log_level, "%s event received. scsi_id: %llx, wwpn: %llx,"
@@ -3361,11 +3609,23 @@ static void ibmvfc_handle_async(struct ibmvfc_async_crq *crq,
 	case IBMVFC_AE_HALT:
 		ibmvfc_link_down(vhost, IBMVFC_HALTED);
 		break;
+	case IBMVFC_AE_FPIN:
+		aw = kzalloc(sizeof(struct ibmvfc_async_work), GFP_ATOMIC);
+		if (aw) {
+			INIT_WORK(&aw->async_work_s, ibmvfc_process_async_work);
+			aw->vhost = vhost;
+			aw->crq = *crq;
+			queue_work(vhost->fpin_workq, &aw->async_work_s);
+		} else
+			dev_err_ratelimited(vhost->dev,
+					    "can't offload async CRQ to work queue\n");
+		break;
 	default:
 		dev_err(vhost->dev, "Unknown async event received: %lld\n", crq->event);
 		break;
 	}
 }
+EXPORT_SYMBOL_IF_KUNIT(ibmvfc_handle_async);
 
 /**
  * ibmvfc_handle_crq - Handles and frees received events in the CRQ
@@ -6875,9 +7135,15 @@ static int ibmvfc_probe(struct vio_dev *vdev, const struct vio_device_id *id)
 	INIT_WORK(&vhost->rport_add_work_q, ibmvfc_rport_add_thread);
 	mutex_init(&vhost->passthru_mutex);
 
-	if ((rc = ibmvfc_alloc_mem(vhost)))
+	vhost->fpin_workq = alloc_workqueue("%s-fpin-workq-%u", WQ_UNBOUND, 0,
+						 IBMVFC_NAME, shost->host_no);
+	if (vhost->fpin_workq == NULL)
 		goto free_scsi_host;
 
+	rc = ibmvfc_alloc_mem(vhost);
+	if (rc)
+		goto free_workq;
+
 	vhost->work_thread = kthread_run(ibmvfc_work, vhost, "%s_%d", IBMVFC_NAME,
 					 shost->host_no);
 
@@ -6923,6 +7189,9 @@ static int ibmvfc_probe(struct vio_dev *vdev, const struct vio_device_id *id)
 	kthread_stop(vhost->work_thread);
 free_host_mem:
 	ibmvfc_free_mem(vhost);
+free_workq:
+	destroy_workqueue(vhost->fpin_workq);
+	vhost->fpin_workq = NULL;
 free_scsi_host:
 	scsi_host_put(shost);
 out:
@@ -6953,8 +7222,6 @@ static void ibmvfc_remove(struct vio_dev *vdev)
 	ibmvfc_wait_while_resetting(vhost);
 	kthread_stop(vhost->work_thread);
 	flush_work(&vhost->rport_add_work_q);
-	fc_remove_host(vhost->host);
-	scsi_remove_host(vhost->host);
 
 	spin_lock_irqsave(&vhost->host->host_lock, flags);
 	ibmvfc_purge_requests(vhost, DID_ERROR);
@@ -6963,6 +7230,10 @@ static void ibmvfc_remove(struct vio_dev *vdev)
 	ibmvfc_complete_purge(&purge);
 	ibmvfc_release_sub_crqs(vhost);
 	ibmvfc_release_crq_queue(vhost);
+	destroy_workqueue(vhost->fpin_workq);
+	vhost->fpin_workq = NULL;
+	fc_remove_host(vhost->host);
+	scsi_remove_host(vhost->host);
 
 	ibmvfc_free_mem(vhost);
 	spin_lock(&ibmvfc_driver_lock);
@@ -7115,5 +7386,21 @@ static void __exit ibmvfc_module_exit(void)
 	fc_release_transport(ibmvfc_transport_template);
 }
 
+#if IS_ENABLED(CONFIG_KUNIT)
+VISIBLE_IF_KUNIT struct ibmvfc_host *ibmvfc_get_first_vhost(void)
+{
+	struct ibmvfc_host *vhost = NULL;
+
+	spin_lock(&ibmvfc_driver_lock);
+	if (!list_empty(&ibmvfc_head))
+		vhost = list_first_entry(&ibmvfc_head, struct ibmvfc_host, queue);
+	if (vhost)
+		scsi_host_get(vhost->host);
+	spin_unlock(&ibmvfc_driver_lock);
+	return vhost;
+}
+EXPORT_SYMBOL_IF_KUNIT(ibmvfc_get_first_vhost);
+#endif
+
 module_init(ibmvfc_module_init);
 module_exit(ibmvfc_module_exit);
diff --git a/drivers/scsi/ibmvscsi/ibmvfc.h b/drivers/scsi/ibmvscsi/ibmvfc.h
index ca80ceffe53a..d7a30e7a4a28 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.h
+++ b/drivers/scsi/ibmvscsi/ibmvfc.h
@@ -750,8 +750,12 @@ enum ibmvfc_ae_fpin_status {
 	IBMVFC_AE_FPIN_PORT_CONGESTED	= 0x2,
 	IBMVFC_AE_FPIN_PORT_CLEARED	= 0x3,
 	IBMVFC_AE_FPIN_PORT_DEGRADED	= 0x4,
+	IBMVFC_AE_FPIN_CONGESTION_CLEARED	= 0x5,
 };
 
+#define IBMVFC_FPIN_DEFAULT_EVENT_PERIOD	(5*60*MSEC_PER_SEC) /* 5 minutes */
+#define IBMVFC_FPIN_DEFAULT_EVENT_THRESHOLD	(5*60*MSEC_PER_SEC/2) /* 2.5 minutes */
+
 struct ibmvfc_async_crq {
 	volatile u8 valid;
 	u8 link_state;
@@ -781,6 +785,12 @@ struct ibmvfc_async_sub_crq {
 	} id;
 } __packed __aligned(8);
 
+struct ibmvfc_async_work {
+	struct ibmvfc_host *vhost;
+	struct ibmvfc_async_crq crq;
+	struct work_struct async_work_s;
+};
+
 union ibmvfc_iu {
 	struct ibmvfc_mad_common mad_common;
 	struct ibmvfc_npiv_login_mad npiv_login;
@@ -1022,6 +1032,7 @@ struct ibmvfc_host {
 	wait_queue_head_t work_wait_q;
 	struct nvme_fc_local_port *nvme_local_port;
 	struct completion nvme_delete_done;
+	struct workqueue_struct *fpin_workq;
 };
 
 struct ibmvfc_event *__ibmvfc_get_event(struct ibmvfc_queue *queue, int reserved);
@@ -1088,4 +1099,10 @@ static inline struct ibmvfc_host *ibmvfc_channels_to_vhost(struct ibmvfc_channel
 #define ibmvfc_remove_trace_file(kobj, attr) do { } while (0)
 #endif
 
+#if IS_ENABLED(CONFIG_KUNIT)
+#include <kunit/visibility.h>
+VISIBLE_IF_KUNIT void ibmvfc_handle_async(struct ibmvfc_async_crq *crq, struct ibmvfc_host *vhost);
+VISIBLE_IF_KUNIT struct ibmvfc_host *ibmvfc_get_first_vhost(void);
+#endif
+
 #endif
diff --git a/drivers/scsi/ibmvscsi/ibmvfc_kunit.c b/drivers/scsi/ibmvscsi/ibmvfc_kunit.c
new file mode 100644
index 000000000000..67bd3922a49f
--- /dev/null
+++ b/drivers/scsi/ibmvscsi/ibmvfc_kunit.c
@@ -0,0 +1,148 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+#include <kunit/test.h>
+#include <kunit/visibility.h>
+#include <scsi/scsi_device.h>
+#include <scsi/scsi_transport_fc.h>
+#include <scsi/fc/fc_els.h>
+#include <linux/list.h>
+#include <linux/delay.h>
+#include "ibmvfc.h"
+
+MODULE_IMPORT_NS("EXPORTED_FOR_KUNIT_TESTING");
+
+/**
+ * ibmvfc_async_fpin_event_test - unit test for IBMVFC_AE_FPIN parts of
+ * ibmvfc_handle_async
+ * @test: pointer to kunit structure
+ *
+ * Tests
+ * - error returns from ibmvfc_handle_async
+ * - statistics updates
+ *
+ * Return: void
+ */
+static void ibmvfc_async_fpin_test(struct kunit *test)
+{
+	u64 post[IBMVFC_AE_FPIN_CONGESTION_CLEARED + 1];
+	u64 pre[IBMVFC_AE_FPIN_CONGESTION_CLEARED + 1];
+	struct ibmvfc_async_crq ae[IBMVFC_AE_FPIN_CONGESTION_CLEARED + 1];
+	enum ibmvfc_ae_fpin_status fs;
+	struct fc_host_attrs *fc_host;
+	struct ibmvfc_target *tgt;
+	struct ibmvfc_host *vhost;
+	struct fc_rport *rport;
+	unsigned long flags;
+
+	vhost = ibmvfc_get_first_vhost();
+	if (!vhost)
+		kunit_skip(test, "No ibmvfc devices available");
+
+	spin_lock_irqsave(&vhost->host->host_lock, flags);
+	if (vhost->scsi_scrqs.num_targets < 1) {
+		spin_unlock_irqrestore(&vhost->host->host_lock, flags);
+		scsi_host_put(vhost->host);
+		kunit_skip(test, "No targets");
+	}
+	tgt = list_first_entry(&vhost->scsi_scrqs.targets, struct ibmvfc_target, queue);
+	if (!tgt->rport) {
+		spin_unlock_irqrestore(&vhost->host->host_lock, flags);
+		scsi_host_put(vhost->host);
+		kunit_skip(test, "No rport");
+	}
+	rport = tgt->rport;
+	get_device(&rport->dev);
+	kref_get(&tgt->kref);
+	spin_unlock_irqrestore(&vhost->host->host_lock, flags);
+
+	fc_host = shost_to_fc_host(vhost->host);
+
+	pre[IBMVFC_AE_FPIN_LINK_CONGESTED] = READ_ONCE(fc_host->fpin_stats.cn_device_specific);
+	pre[IBMVFC_AE_FPIN_PORT_CONGESTED] = READ_ONCE(rport->fpin_stats.cn_device_specific);
+	pre[IBMVFC_AE_FPIN_PORT_CLEARED] = READ_ONCE(rport->fpin_stats.cn_clear);
+	pre[IBMVFC_AE_FPIN_PORT_DEGRADED] = READ_ONCE(rport->fpin_stats.li_failure_unknown);
+	pre[IBMVFC_AE_FPIN_CONGESTION_CLEARED] = READ_ONCE(fc_host->fpin_stats.cn_clear);
+
+	for (fs = IBMVFC_AE_FPIN_LINK_CONGESTED; fs <= IBMVFC_AE_FPIN_CONGESTION_CLEARED; fs++) {
+		ae[fs].valid = 0x80;
+		ae[fs].link_state = IBMVFC_AE_LS_LINK_UP;
+		ae[fs].fpin_status = fs;
+		ae[fs].event = cpu_to_be64(IBMVFC_AE_FPIN);
+		ae[fs].scsi_id = cpu_to_be64(tgt->scsi_id);
+		ae[fs].wwpn = cpu_to_be64(tgt->wwpn);
+		ae[fs].node_name = cpu_to_be64(tgt->ids.node_name);
+		ibmvfc_handle_async(&ae[fs], vhost);
+		ae[fs].valid = 0;
+		wmb(); /* ensure valid bit clear is visible before checking stats */
+	}
+	flush_workqueue(vhost->fpin_workq);
+
+	post[IBMVFC_AE_FPIN_LINK_CONGESTED] = READ_ONCE(fc_host->fpin_stats.cn_device_specific);
+	post[IBMVFC_AE_FPIN_PORT_CONGESTED] = READ_ONCE(rport->fpin_stats.cn_device_specific);
+	post[IBMVFC_AE_FPIN_PORT_CLEARED] = READ_ONCE(rport->fpin_stats.cn_clear);
+	post[IBMVFC_AE_FPIN_PORT_DEGRADED] = READ_ONCE(rport->fpin_stats.li_failure_unknown);
+	post[IBMVFC_AE_FPIN_CONGESTION_CLEARED] = READ_ONCE(fc_host->fpin_stats.cn_clear);
+
+	KUNIT_EXPECT_GE(test, post[IBMVFC_AE_FPIN_LINK_CONGESTED],
+			pre[IBMVFC_AE_FPIN_LINK_CONGESTED]+1);
+	KUNIT_EXPECT_GE(test, post[IBMVFC_AE_FPIN_PORT_CONGESTED],
+			pre[IBMVFC_AE_FPIN_PORT_CONGESTED]+1);
+	KUNIT_EXPECT_GE(test, post[IBMVFC_AE_FPIN_PORT_CLEARED],
+			pre[IBMVFC_AE_FPIN_PORT_CLEARED]+1);
+	KUNIT_EXPECT_GE(test, post[IBMVFC_AE_FPIN_PORT_DEGRADED],
+			pre[IBMVFC_AE_FPIN_PORT_DEGRADED]+1);
+	KUNIT_EXPECT_GE(test, post[IBMVFC_AE_FPIN_CONGESTION_CLEARED],
+			pre[IBMVFC_AE_FPIN_CONGESTION_CLEARED]+1);
+
+	/* bad path */
+	pre[IBMVFC_AE_FPIN_LINK_CONGESTED] = READ_ONCE(fc_host->fpin_stats.cn_device_specific);
+	pre[IBMVFC_AE_FPIN_PORT_CONGESTED] = READ_ONCE(rport->fpin_stats.cn_device_specific);
+	pre[IBMVFC_AE_FPIN_PORT_CLEARED] = READ_ONCE(rport->fpin_stats.cn_clear);
+	pre[IBMVFC_AE_FPIN_PORT_DEGRADED] = READ_ONCE(rport->fpin_stats.li_failure_unknown);
+	pre[IBMVFC_AE_FPIN_CONGESTION_CLEARED] = READ_ONCE(fc_host->fpin_stats.cn_clear);
+
+	ae[0].valid = 0x80;
+	ae[0].link_state = IBMVFC_AE_LS_LINK_UP;
+	ae[0].fpin_status = 0; /* bad value */
+	ae[0].event = cpu_to_be64(IBMVFC_AE_FPIN);
+	ae[0].scsi_id = cpu_to_be64(tgt->scsi_id);
+	ae[0].wwpn = cpu_to_be64(tgt->wwpn);
+	ae[0].node_name = cpu_to_be64(tgt->ids.node_name);
+	ibmvfc_handle_async(&ae[0], vhost);
+	ae[0].valid = 0;
+	wmb(); /* ensure valid bit clear is visible before checking stats */
+	flush_workqueue(vhost->fpin_workq);
+
+	post[IBMVFC_AE_FPIN_LINK_CONGESTED] = READ_ONCE(fc_host->fpin_stats.cn_device_specific);
+	post[IBMVFC_AE_FPIN_PORT_CONGESTED] = READ_ONCE(rport->fpin_stats.cn_device_specific);
+	post[IBMVFC_AE_FPIN_PORT_CLEARED] = READ_ONCE(rport->fpin_stats.cn_clear);
+	post[IBMVFC_AE_FPIN_PORT_DEGRADED] = READ_ONCE(rport->fpin_stats.li_failure_unknown);
+	post[IBMVFC_AE_FPIN_CONGESTION_CLEARED] = READ_ONCE(fc_host->fpin_stats.cn_clear);
+
+	KUNIT_EXPECT_EQ(test, pre[IBMVFC_AE_FPIN_LINK_CONGESTED],
+			post[IBMVFC_AE_FPIN_LINK_CONGESTED]);
+	KUNIT_EXPECT_EQ(test, pre[IBMVFC_AE_FPIN_PORT_CONGESTED],
+			post[IBMVFC_AE_FPIN_PORT_CONGESTED]);
+	KUNIT_EXPECT_EQ(test, pre[IBMVFC_AE_FPIN_PORT_CLEARED],
+			post[IBMVFC_AE_FPIN_PORT_CLEARED]);
+	KUNIT_EXPECT_EQ(test, pre[IBMVFC_AE_FPIN_PORT_DEGRADED],
+			post[IBMVFC_AE_FPIN_PORT_DEGRADED]);
+	KUNIT_EXPECT_EQ(test, pre[IBMVFC_AE_FPIN_CONGESTION_CLEARED],
+			post[IBMVFC_AE_FPIN_CONGESTION_CLEARED]);
+
+	kref_put(&tgt->kref, ibmvfc_release_tgt);
+}
+
+static struct kunit_case ibmvfc_fpin_test_cases[] = {
+	KUNIT_CASE(ibmvfc_async_fpin_test),
+	{},
+};
+
+static struct kunit_suite ibmvfc_fpin_test_suite = {
+	.name = "ibmvfc-fpin-test",
+	.test_cases = ibmvfc_fpin_test_cases,
+};
+kunit_test_init_section_suite(ibmvfc_fpin_test_suite);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Dave Marquardt <davemarq@linux.ibm.com>");
+MODULE_DESCRIPTION("Test module for IBM Virtual Fibre Channel Driver");
-- 
2.55.0

