Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42C673D092F;
	Fri, 11 Sep 2026 02:08:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789092520; cv=none; b=puY9THfFZHAOqSy6C3xD2C7u3glTBr6u5qtqiEhDONaa4zvA7LjvRavMmFMBxYWCIYa0baFkc8FN8nh2hIKiDvlw2ZAXs2kb3BlghHKBH4K+ysuGQdQkHxRbEw8VHK0c9ySuAtJOnbs8IXYj5j8TE0OvnteDc909zbK6K+1B9K8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789092520; c=relaxed/simple;
	bh=5LOu4/B2zSincTRkEZB40hJcCZVDzmy98SLnQHrDSek=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JyyWSCbacAHet6MDUiDrcMjSbi6RhId4OPLglgY+vbz/boC+4vcqRyl6MFKFamxj1jYmVYEDmKIKIg4iFavOdzD0Bdp0B0479W+G8UyQq5ZQaWlASrFAeCR6zRdu7AQWk36AfBWTgeBvv+sNGqVs6eucMyQSCcf1oXsjuok2ZW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=ZDmB9t8G; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="ZDmB9t8G"
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68B12ND2348194;
	Fri, 11 Sep 2026 02:08:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=0eZmCs6e8jccDUIO0
	UDJby2+Kk0tdSJFcMWqsUD0w+I=; b=ZDmB9t8GXQbzpMyNi0fdySS4fL15mtNfe
	rM9MBSMYXui0GqB1TNW5O0jnc6B8Zx74g/fS77VlR/HR/O0VjFMbhWs5Vid5AplA
	SWo8zeDudgb+qoEjMlM1qJSSbqnYGGjBriZYS+fkPPVxdHzPhU1xAgNrJJnHQetu
	wQpQg8npyW+3aaGGvXKJsXCmgXesaRoR0UR+S4PmWs5aCpVhBMYTpdnutvq9RkXk
	4pfpGXy5N3m7IoKTJ+Ss29HpkpOlBpWChjszuMzXiyW1KMOSmums0KMuOUWbe6R/
	0tz+N3FJvpsORcG24NT3nreEsxAw+djUOpmgY+YbcfxSOAwKvF7fQ==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gkd8t0p5t-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 11 Sep 2026 02:08:27 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 68B154cv919383;
	Fri, 11 Sep 2026 02:08:26 GMT
Received: from smtprelay07.wdc07v.mail.ibm.com ([172.16.1.74])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4gkvmhkvf9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 11 Sep 2026 02:08:26 +0000 (GMT)
Received: from smtpav04.dal12v.mail.ibm.com (smtpav04.dal12v.mail.ibm.com [10.241.53.103])
	by smtprelay07.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 68B28OBv14942888
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 11 Sep 2026 02:08:25 GMT
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 992565805A;
	Fri, 11 Sep 2026 02:08:24 +0000 (GMT)
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id F0D8E58056;
	Fri, 11 Sep 2026 02:08:23 +0000 (GMT)
Received: from li-4c4c4544-0054-3910-8039-c3c04f423534.ibm.com.com (unknown [9.61.103.123])
	by smtpav04.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 11 Sep 2026 02:08:23 +0000 (GMT)
From: Tyrel Datwyler <tyreld@linux.ibm.com>
To: james.bottomley@hansenpartnership.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, brking@linux.ibm.com,
        davemarq@linux.ibm.com, Tyrel Datwyler <tyreld@linux.ibm.com>
Subject: [PATCH v9 9/9] scsi: ibmvfc: handle extended FPIN events
Date: Thu, 10 Sep 2026 19:08:15 -0700
Message-ID: <20260911020817.1033789-9-tyreld@linux.ibm.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909-ibmvfc-fpin-support-v8-0-b27183b055af@linux.ibm.com>
References: <20260909-ibmvfc-fpin-support-v8-0-b27183b055af@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTExMDAyNCBTYWx0ZWRfX7H/Rq9odZ+uZ
 uTKuskcCMZsj2XLLfShjicVmUBXzjZU02qMit2w8XzxsRMkXeKRqZqneuloX4Eszi4TOJEeXVZt
 Zg6oljOvfOiCHPrtA+V6oxDBxInHISo=
X-Proofpoint-ORIG-GUID: w4J5e4RjoariHqfcd3CRyHSp3U5nEVvR
X-Proofpoint-GUID: w4J5e4RjoariHqfcd3CRyHSp3U5nEVvR
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTExMDAyNCBTYWx0ZWRfX1bkscfGMnEIk
 VzqM7bKUZzURZB8jjhnMc/nCgmdL2y8b/8yv29imgqCh+c0wtrmx67jZAbmYLnLR9Cq9h0hYy1B
 DRZ/l1sKOGkM9/r2gyt1IW4D9HZMCWgVNFuPHTJKPjxYD7vsrNfiifFrDxtHqpQIB4rvLGvQOP6
 xYdMW4tT9U0xErWQngM3Kiv2TRirrolEhcOvZTVTV5PUz12rMtuA6CljDDSYdQWQAprXCRwv8NP
 4vutIE5BJRVzou49C+mzqbSnvI3JylOlY16ZWcw7Vqjm5VS+41H+l5WrMLSGtgZFwHsOWT6EYGB
 7oycQ6zyLA6InLDRfQd7CuKJViMXY+miuMq2ET7rpvxpzXghm/6gWDXHsid8tzKVwy4ypMCYB0Y
 EvBQ/Ew3BkSmxbMq79RKvhMq/bdso5ZeAfd/+XaXRjdP+woCc71YkCEV1SIyJ1+a660FRRMILk+
 kF+VVmW8FH10ZP41ylA==
X-Authority-Analysis: v=2.4 cv=PIGaavqC c=1 sm=1 tr=0 ts=6aa3629b cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=RzCfie-kr_QcCd8fBx8p:22 a=VnNF1IyMAAAA:8 a=YunXX2DFvQEblV2KXBkA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-11_01,2026-09-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 priorityscore=1501 bulkscore=0 adultscore=0 suspectscore=0
 lowpriorityscore=0 impostorscore=0 clxscore=1015 spamscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609110024

From: Dave Marquardt <davemarq@linux.ibm.com>

Implement support for extended FPIN messages received via the
asynchronous sub-queue, completing full FPIN functionality.

Extended FPIN messages provide more detailed information about fabric
events compared to basic FPIN messages, including specific event types,
modifiers, thresholds, and event counts.

Add ibmvfc_ext_fpin_to_desc() to convert extended FPIN messages from
async sub-queue format to fc_els_fpin structures with complete descriptor
information. Update ibmvfc_process_async_work() and ibmvfc_handle_async()
to zero node_name and dispatch to ibmvfc_ext_fpin_to_desc() when the
IBMVFC_ASYNC_IS_FPIN_EXT flag is set.

Set the IBMVFC_CAN_HANDLE_FPIN_EXT capability bit during login to inform
VIOS that the client can process extended FPIN messages. Also add the
IBMVFC_SUPPORT_FPIN_EXT response capability bit definition used to gate
extended FPIN processing.

Add KUnit tests to exercise extended FPIN event handling across all
FPIN status and event type combinations.

struct ibmvfc_async_subq_fpin uses volatile on its valid and wwpn fields,
consistent with the existing ibmvfc_crq, ibmvfc_async_crq, and
ibmvfc_async_sub_crq structs in ibmvfc.h, all of which mark their
hardware-owned ring-buffer fields volatile to prevent the compiler from
caching or eliminating reads of memory written directly by the VIOS.

Signed-off-by: Dave Marquardt <davemarq@linux.ibm.com>
Acked-by: Tyrel Datwyler <tyreld@linux.ibm.com>
---
 drivers/scsi/ibmvscsi/ibmvfc-core.c  |  67 ++++++++++++-
 drivers/scsi/ibmvscsi/ibmvfc.h       |  30 ++++++
 drivers/scsi/ibmvscsi/ibmvfc_kunit.c | 135 +++++++++++++++++++++++++++
 3 files changed, 228 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/ibmvfc-core.c
index 6eb299989724..bd10c3fd5ccf 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
@@ -1593,6 +1593,7 @@ static void ibmvfc_set_login_info(struct ibmvfc_host *vhost)
 		login_info->capabilities |= cpu_to_be64(IBMVFC_USE_ASYNC_SUBQ);
 		login_info->capabilities |= cpu_to_be64(IBMVFC_CAN_HANDLE_FPIN);
 		login_info->capabilities |= cpu_to_be64(IBMVFC_YES_SCSI);
+		login_info->capabilities |= cpu_to_be64(IBMVFC_CAN_HANDLE_FPIN_EXT);
 		if (vhost->nvme_enabled) {
 			login_info->capabilities |= cpu_to_be64(IBMVFC_YES_NVMEOF);
 			login_info->capabilities |= cpu_to_be64(IBMVFC_CAN_USE_WWPN_ALL);
@@ -3473,6 +3474,41 @@ ibmvfc_full_fpin_to_desc(struct ibmvfc_async_sub_crq *ibmvfc_fpin)
 					  cpu_to_be32(1));
 }
 
+/**
+ * ibmvfc_ext_fpin_to_desc(): allocate and populate a struct fc_els_fpin struct
+ * containing a descriptor.
+ * @ibmvfc_fpin: Pointer to async subq FPIN data
+ *
+ * Allocate a struct fc_els_fpin containing a descriptor and populate
+ * based on data from *ibmvfc_fpin.
+ *
+ * Return:
+ * NULL     - unable to allocate structure
+ * non-NULL - pointer to populated struct fc_els_fpin
+ */
+static struct fc_els_fpin *
+ibmvfc_ext_fpin_to_desc(struct ibmvfc_async_subq_fpin *ibmvfc_fpin)
+{
+	u8 flags = ibmvfc_fpin->fpin_data.flags;
+	__be32 threshold = cpu_to_be32(IBMVFC_FPIN_DEFAULT_EVENT_THRESHOLD);
+	__be16 modifier = 0;
+	__be32 count = cpu_to_be32(1);
+	__be16 type = 0;
+
+	if (flags & IBMVFC_FPIN_EVENT_TYPE_VALID)
+		type = ibmvfc_fpin->fpin_data.event_type;
+	if (flags & IBMVFC_FPIN_MODIFIER_VALID)
+		modifier = ibmvfc_fpin->fpin_data.event_type_modifier;
+	if (flags & IBMVFC_FPIN_THRESHOLD_VALID)
+		threshold = ibmvfc_fpin->fpin_data.event_threshold;
+	if (flags & IBMVFC_FPIN_EVENT_COUNT_VALID)
+		count = ibmvfc_fpin->fpin_data.event_data.event_count;
+
+	return ibmvfc_common_fpin_to_desc(ibmvfc_fpin->fpin_status,
+					  ibmvfc_fpin->wwpn, type,
+					  modifier, threshold, count);
+}
+
 /**
  * ibmvfc_find_target - Search for a target in a target list
  * @target_list: list head of targets to search
@@ -3511,6 +3547,7 @@ static struct ibmvfc_target *ibmvfc_find_target(struct list_head *target_list,
 static void ibmvfc_process_async_work(struct work_struct *work)
 {
 	struct ibmvfc_async_sub_crq *subq = NULL;
+	struct ibmvfc_async_subq_fpin *sqfpin;
 	struct ibmvfc_async_work *aw;
 	struct ibmvfc_async_crq *crq = NULL;
 	struct ibmvfc_target *tgt;
@@ -3527,7 +3564,10 @@ static void ibmvfc_process_async_work(struct work_struct *work)
 		subq = &aw->event.subq;
 		scsi_id = 0;
 		wwpn = subq->wwpn;
-		node_name = (subq->flags & IBMVFC_ASYNC_ID_IS_ASSOC_ID) ? 0 : subq->id.node_name;
+		if (subq->flags & (IBMVFC_ASYNC_IS_FPIN_EXT | IBMVFC_ASYNC_ID_IS_ASSOC_ID))
+			node_name = 0;
+		else
+			node_name = subq->id.node_name;
 	} else {
 		crq = &aw->event.async_crq;
 		scsi_id = crq->scsi_id;
@@ -3556,8 +3596,24 @@ static void ibmvfc_process_async_work(struct work_struct *work)
 
 	if (crq)
 		fpin = ibmvfc_basic_fpin_to_desc(crq, tgt->wwpn);
-	else
-		fpin = ibmvfc_full_fpin_to_desc(subq);
+	else {
+		static_assert(sizeof(struct ibmvfc_async_subq_fpin) ==
+			      sizeof(struct ibmvfc_async_sub_crq));
+		static_assert(offsetof(struct ibmvfc_async_subq_fpin, fpin_data) ==
+			      offsetof(struct ibmvfc_async_sub_crq, nport_id));
+		sqfpin = (struct ibmvfc_async_subq_fpin *)subq;
+		if ((subq->flags & IBMVFC_ASYNC_IS_FPIN_EXT) == 0) {
+			fpin = ibmvfc_full_fpin_to_desc(subq);
+		} else if (!(sqfpin->fpin_data.flags & IBMVFC_FPIN_EVENT_TYPE_VALID)) {
+			dev_err_ratelimited(vhost->dev,
+					    "Invalid extended FPIN event received\n");
+		} else if (!ibmvfc_check_caps(vhost, IBMVFC_SUPPORT_FPIN_EXT)) {
+			dev_err_ratelimited(vhost->dev,
+					    "Unexpected extended FPIN event received\n");
+		} else {
+			fpin = ibmvfc_ext_fpin_to_desc(sqfpin);
+		}
+	}
 
 	if (fpin) {
 		fc_host_fpin_rcv(tgt->vhost->host,
@@ -3599,7 +3655,10 @@ VISIBLE_IF_KUNIT void ibmvfc_handle_async(struct ibmvfc_async_crq_event *ae,
 		link_state = subq->link_state;
 		scsi_id = 0;
 		wwpn = subq->wwpn;
-		node_name = subq->flags & IBMVFC_ASYNC_ID_IS_ASSOC_ID ? 0 : subq->id.node_name;
+		if (subq->flags & (IBMVFC_ASYNC_IS_FPIN_EXT | IBMVFC_ASYNC_ID_IS_ASSOC_ID))
+			node_name = 0;
+		else
+			node_name = subq->id.node_name;
 	} else {
 		async_crq = &ae->async_crq;
 		event = be64_to_cpu(async_crq->event);
diff --git a/drivers/scsi/ibmvscsi/ibmvfc.h b/drivers/scsi/ibmvscsi/ibmvfc.h
index 6fce7a4922bb..20933af59d48 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.h
+++ b/drivers/scsi/ibmvscsi/ibmvfc.h
@@ -210,6 +210,7 @@ struct ibmvfc_npiv_login {
 #define IBMVFC_CAN_USE_WWPN_ALL		0x080
 #define IBMVFC_USE_ASYNC_SUBQ		0x100
 #define IBMVFC_CAN_USE_NOOP_CMD		0x200
+#define IBMVFC_CAN_HANDLE_FPIN_EXT	0x800
 	__be64 node_name;
 	struct srp_direct_buf async;
 	u8 partition_name[IBMVFC_MAX_NAME];
@@ -261,6 +262,7 @@ struct ibmvfc_npiv_login_resp {
 #define IBMVFC_SUPPORT_WWPN_ALL		0x0400
 #define IBMVFC_ASYNC_SUBQ		0x0800
 #define IBMVFC_SUPPORT_NOOP_CMD		0x1000
+#define IBMVFC_SUPPORT_FPIN_EXT		0x2000
 	__be32 max_cmds;
 	__be32 scsi_id_sz;
 	__be64 max_dma_len;
@@ -786,6 +788,34 @@ struct ibmvfc_async_sub_crq {
 	} id;
 } __packed __aligned(8);
 
+struct ibmvfc_fpin_data {
+#define IBMVFC_FPIN_EVENT_TYPE_VALID	0x01
+#define IBMVFC_FPIN_MODIFIER_VALID	0x02
+#define IBMVFC_FPIN_THRESHOLD_VALID	0x04
+#define IBMVFC_FPIN_SEVERITY_VALID	0x08
+#define IBMVFC_FPIN_EVENT_COUNT_VALID	0x10
+	u8 flags;
+	u8 reserved[3];
+	__be16 event_type;
+	__be16 event_type_modifier;
+	__be32 event_threshold;
+	union {
+		u8 severity;
+		__be32 event_count;
+	} event_data;
+} __packed __aligned(8);
+
+struct ibmvfc_async_subq_fpin {
+	volatile u8 valid;
+	u8 flags;
+	u8 link_state;
+	u8 fpin_status;
+	__be16 event;
+	__be16 pad;
+	volatile __be64 wwpn;
+	struct ibmvfc_fpin_data fpin_data;
+} __packed __aligned(8);
+
 enum ibmvfc_async_crq_type {
 	IBMVFC_ASYNC_CRQ_MAIN = 0,
 	IBMVFC_ASYNC_CRQ_SUB,
diff --git a/drivers/scsi/ibmvscsi/ibmvfc_kunit.c b/drivers/scsi/ibmvscsi/ibmvfc_kunit.c
index 7aaed4f64f26..80e7f8e0fd70 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc_kunit.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc_kunit.c
@@ -3,6 +3,7 @@
 #include <kunit/visibility.h>
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_transport_fc.h>
+#include <scsi/fc/fc_els.h>
 #include <linux/list.h>
 #include <linux/delay.h>
 #include "ibmvfc.h"
@@ -256,9 +257,143 @@ static void ibmvfc_full_fpin_test(struct kunit *test)
 	scsi_host_put(vhost->host);
 }
 
+#define IBMVFC_TEST_FPIN_EXT(fs, ev, stat, crq) {				\
+	struct ibmvfc_async_crq_event ae = { .type = IBMVFC_ASYNC_CRQ_SUB };	\
+	(crq).valid = 0x80;							\
+	(crq).flags = IBMVFC_ASYNC_IS_FPIN_EXT;					\
+	(crq).link_state = IBMVFC_AE_LS_LINK_UP;				\
+	(crq).fpin_status = (fs);						\
+	(crq).event = cpu_to_be16(IBMVFC_AE_FPIN);				\
+	(crq).wwpn = cpu_to_be64(tgt->wwpn);					\
+	(crq).fpin_data.flags = IBMVFC_FPIN_EVENT_TYPE_VALID;			\
+	(crq).fpin_data.event_type = cpu_to_be16((ev));				\
+	ae.subq = *(struct ibmvfc_async_sub_crq *)&(crq);			\
+	pre = READ_ONCE(rport->fpin_stats.stat);				\
+	ibmvfc_handle_async(&ae, vhost);					\
+	flush_workqueue(vhost->fpin_workq);					\
+	post = READ_ONCE(rport->fpin_stats.stat);				\
+}
+
+/**
+ * ibmvfc_extended_fpin_test - unit test for extended FPIN events
+ * @test: pointer to kunit structure
+ *
+ * Note: This test exercises extended FPIN code paths but does not check
+ * that statistics are correctly updated.
+ *
+ * Return: void
+ */
+static void ibmvfc_extended_fpin_test(struct kunit *test)
+{
+	enum ibmvfc_ae_fpin_status fs;
+	struct ibmvfc_async_subq_fpin crq[IBMVFC_AE_FPIN_CONGESTION_CLEARED+1] = {};
+	struct ibmvfc_async_subq_fpin
+		crqcn[IBMVFC_AE_FPIN_PORT_CONGESTED][FPIN_CONGN_DEVICE_SPEC+1] = {};
+	struct ibmvfc_async_subq_fpin crqportdg[FPIN_LI_DEVICE_SPEC+1] = {};
+	struct ibmvfc_target *tgt;
+	struct ibmvfc_host *vhost;
+	struct fc_rport *rport;
+	LIST_HEAD(evt_doneq);
+	unsigned long flags;
+	u64 pre, post;
+
+	vhost = ibmvfc_get_first_vhost();
+	if (!vhost)
+		kunit_skip(test, "No ibmvfc devices available");
+
+	spin_lock_irqsave(vhost->host->host_lock, flags);
+	if (vhost->scsi_scrqs.num_targets < 1) {
+		spin_unlock_irqrestore(vhost->host->host_lock, flags);
+		scsi_host_put(vhost->host);
+		kunit_skip(test, "No targets");
+	}
+	tgt = list_first_entry(&vhost->scsi_scrqs.targets, struct ibmvfc_target, queue);
+	if (!tgt->rport) {
+		spin_unlock_irqrestore(vhost->host->host_lock, flags);
+		scsi_host_put(vhost->host);
+		kunit_skip(test, "No rport");
+	}
+	rport = tgt->rport;
+	get_device(&rport->dev);
+	kref_get(&tgt->kref);
+	spin_unlock_irqrestore(vhost->host->host_lock, flags);
+
+	for (fs = IBMVFC_AE_FPIN_LINK_CONGESTED; fs <= IBMVFC_AE_FPIN_CONGESTION_CLEARED; fs++) {
+		switch (fs) {
+		case IBMVFC_AE_FPIN_PORT_CLEARED:
+		case IBMVFC_AE_FPIN_CONGESTION_CLEARED: {
+			struct ibmvfc_async_crq_event ae = { .type = IBMVFC_ASYNC_CRQ_SUB };
+
+			crq[fs].valid = 0x80;
+			crq[fs].flags = IBMVFC_ASYNC_IS_FPIN_EXT;
+			crq[fs].link_state = IBMVFC_AE_LS_LINK_UP;
+			crq[fs].fpin_status = fs;
+			crq[fs].event = cpu_to_be16(IBMVFC_AE_FPIN);
+			crq[fs].wwpn = cpu_to_be64(tgt->wwpn);
+			crq[fs].fpin_data.flags = IBMVFC_FPIN_EVENT_TYPE_VALID;
+			crq[fs].fpin_data.event_type = cpu_to_be16(FPIN_CONGN_CLEAR);
+			ae.subq = *(struct ibmvfc_async_sub_crq *)&crq[fs];
+			pre = READ_ONCE(rport->fpin_stats.cn_clear);
+			ibmvfc_handle_async(&ae, vhost);
+			flush_workqueue(vhost->fpin_workq);
+			post = READ_ONCE(rport->fpin_stats.cn_clear);
+			break;
+		}
+		case IBMVFC_AE_FPIN_LINK_CONGESTED:
+		case IBMVFC_AE_FPIN_PORT_CONGESTED:
+			IBMVFC_TEST_FPIN_EXT(fs, FPIN_CONGN_CLEAR, cn_clear,
+					     crqcn[fs-1][FPIN_CONGN_CLEAR]);
+			IBMVFC_TEST_FPIN_EXT(fs, FPIN_CONGN_LOST_CREDIT,
+					     cn_lost_credit,
+					     crqcn[fs-1][FPIN_CONGN_LOST_CREDIT]);
+			IBMVFC_TEST_FPIN_EXT(fs, FPIN_CONGN_CREDIT_STALL,
+					     cn_credit_stall,
+					     crqcn[fs-1][FPIN_CONGN_CREDIT_STALL]);
+			IBMVFC_TEST_FPIN_EXT(fs, FPIN_CONGN_OVERSUBSCRIPTION,
+					     cn_oversubscription,
+					     crqcn[fs-1][FPIN_CONGN_OVERSUBSCRIPTION]);
+			IBMVFC_TEST_FPIN_EXT(fs, FPIN_CONGN_DEVICE_SPEC,
+					     cn_device_specific,
+					     crqcn[fs-1][FPIN_CONGN_DEVICE_SPEC]);
+			break;
+		case IBMVFC_AE_FPIN_PORT_DEGRADED:
+			IBMVFC_TEST_FPIN_EXT(fs, FPIN_LI_UNKNOWN,
+					     li_failure_unknown,
+					     crqportdg[FPIN_LI_UNKNOWN]);
+			IBMVFC_TEST_FPIN_EXT(fs, FPIN_LI_LINK_FAILURE,
+					     li_link_failure_count,
+					     crqportdg[FPIN_LI_LINK_FAILURE]);
+			IBMVFC_TEST_FPIN_EXT(fs, FPIN_LI_LOSS_OF_SYNC,
+					     li_loss_of_sync_count,
+					     crqportdg[FPIN_LI_LOSS_OF_SYNC]);
+			IBMVFC_TEST_FPIN_EXT(fs, FPIN_LI_LOSS_OF_SIG,
+					     li_loss_of_signals_count,
+					     crqportdg[FPIN_LI_LOSS_OF_SIG]);
+			IBMVFC_TEST_FPIN_EXT(fs, FPIN_LI_PRIM_SEQ_ERR,
+					     li_prim_seq_err_count,
+					     crqportdg[FPIN_LI_PRIM_SEQ_ERR]);
+			IBMVFC_TEST_FPIN_EXT(fs, FPIN_LI_INVALID_TX_WD,
+					     li_invalid_tx_word_count,
+					     crqportdg[FPIN_LI_INVALID_TX_WD]);
+			IBMVFC_TEST_FPIN_EXT(fs, FPIN_LI_INVALID_CRC,
+					     li_invalid_crc_count,
+					     crqportdg[FPIN_LI_INVALID_CRC]);
+			IBMVFC_TEST_FPIN_EXT(fs, FPIN_LI_DEVICE_SPEC,
+					     li_device_specific,
+					     crqportdg[FPIN_LI_DEVICE_SPEC]);
+			break;
+		}
+	}
+
+	put_device(&rport->dev);
+	kref_put(&tgt->kref, ibmvfc_release_tgt);
+	scsi_host_put(vhost->host);
+}
+
 static struct kunit_case ibmvfc_fpin_test_cases[] = {
 	KUNIT_CASE(ibmvfc_async_fpin_test),
 	KUNIT_CASE(ibmvfc_full_fpin_test),
+	KUNIT_CASE(ibmvfc_extended_fpin_test),
 	{},
 };
 
-- 
2.55.0

