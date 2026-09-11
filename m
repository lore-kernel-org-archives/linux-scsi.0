Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C23353DC4C9;
	Fri, 11 Sep 2026 02:19:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789093172; cv=none; b=c6AOj1ikIhsq6G0OMWdXbP3V4YIP1/13qdqBjgnvcxjIV+2IJg1zuzkT0m8V5n8gdDFwV3p8hGncp2wW1cSCQzwcDc+IP/NCf0I5aG1ZXWUr25Kbc5QxmKBWLFyUjOsl3OeJuYxUcROmsdy4FplyByvdSoMpu+bJza00dAbdvEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789093172; c=relaxed/simple;
	bh=ahRHlM3DTKx8h4H/ECpW9lKJd2sr/sQxGlo1M8lVhvk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XbxNSU8Epn92iTr4GkJHGGPWujKMashES6z3OlAcAX5sWA5HhVZXXgy5ZaLt4OcmPgPNBPVLeIEzN/S3zoAaeu30yFEyPyd0fjGqit+VZuw1KPy/FBk7aXSnF5rimkYJfH+EOny9Ykye/foRROqNwIXWc0c+/M2EpZdwxXaHeco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=GJ+Isc0z; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="GJ+Isc0z"
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68B12I1g2632214;
	Fri, 11 Sep 2026 02:19:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=QgVNL82TfKgV9OoNi
	ZgUlYNgTH8HJrVrAm0w/XuFu38=; b=GJ+Isc0ziXtEo3N00JI/4qv+wSkvSIrvb
	yDGoY0OdyDFecARkHujxU5D65guMY2jos9xzHPvFrKZ1lCBO53RNnif5P7lZ8+Gf
	/RDeumov5bIcJYl12ZKkp07ukDHXVIr5Z/gZd5aWuIFdjpz08Ywj3oeOJzzwGlUE
	iJAXPEBujDahgw+9z8yO9UmrXXi0pEJuZYO7jilseesm5nGkPX8+DZomfTKbZ0Ww
	4/3y5x0NbmAQT8OdivqTfDXsBt6BmVgNHxH3vMSL3HypsDv+qIV8gyzBNbUZe/2j
	hQL4i/dhBtJzEfYzT4PYZ3v1LhHQcbbwKxMf0MWZ3jSywMw/Yulqw==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gkd8n8sbx-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 11 Sep 2026 02:19:18 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 68B154xM919376;
	Fri, 11 Sep 2026 02:19:18 GMT
Received: from smtprelay05.dal12v.mail.ibm.com ([172.16.1.7])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4gkvmhkwf4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 11 Sep 2026 02:19:18 +0000 (GMT)
Received: from smtpav01.wdc07v.mail.ibm.com (smtpav01.wdc07v.mail.ibm.com [10.39.53.228])
	by smtprelay05.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 68B2JHDV31523330
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 11 Sep 2026 02:19:17 GMT
Received: from smtpav01.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0A3575804B;
	Fri, 11 Sep 2026 02:19:17 +0000 (GMT)
Received: from smtpav01.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 14E4258065;
	Fri, 11 Sep 2026 02:19:16 +0000 (GMT)
Received: from li-4c4c4544-0054-3910-8039-c3c04f423534.ibm.com.com (unknown [9.61.103.123])
	by smtpav01.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 11 Sep 2026 02:19:15 +0000 (GMT)
From: Tyrel Datwyler <tyreld@linux.ibm.com>
To: james.bottomley@hansenpartnership.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, brking@linux.ibm.com,
        davemarq@linux.ibm.com, Tyrel Datwyler <tyreld@linux.ibm.com>
Subject: [PATCH v9 4/9] scsi: ibmvfc: extend async event handlers for async sub-CRQ events
Date: Thu, 10 Sep 2026 19:19:04 -0700
Message-ID: <20260911021910.1038128-5-tyreld@linux.ibm.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260911021910.1038128-1-tyreld@linux.ibm.com>
References: <20260911021910.1038128-1-tyreld@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=NMVAaE6g c=1 sm=1 tr=0 ts=6aa36527 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=uAbxVGIbfxUO_5tXvNgY:22 a=VnNF1IyMAAAA:8 a=ATO0ceFIgLGo4LxwFAgA:9
X-Proofpoint-GUID: B6wpwu1WZAO48hmyWSzcmsl_a9TvUEqj
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTExMDAyNCBTYWx0ZWRfX2W1tlposqB6H
 IO703gMPkbO27+ZKgidgw8NMOwlyZg8XOBxNBjkYmqZW1jn/aWtLItDtmWTFH3vI0EJnvNvwoD7
 AORYkbL6MeBZ/1kUjHHSd+bKS+yawzW8OZdvu0U6QtG08zw6fFRyEAlZDwykTuOb7TRfmRvuVnF
 ZfGjIWOl6uLl9USBD+MSwp3fffIjgyo/af51K24+QFSXPoWrADnFayia5/7R6MThdL4pIc1JKqw
 F4W+Ux2wVQ9vtkuw9joa2dfi3CEAxz2a5jn/wP0P4FqCSuORb9OABIBlxvtO960RfoSFz+IRiP+
 Ex15ptb7EVJQSvTtsbVEsh+0JOyHIFC6VjZLHnfvGTn/IA9IvnfItVz8rw9/ReUHJ9AOzjBb8ES
 qRHgLJPSVspogDdxwjXxAXxCPw4JAwaODJRIwk1Ivkh1pjdJ/27LW0zHsqWLyUyPS1RZzapnFio
 koiof6vQzS61QN+Eftw==
X-Proofpoint-ORIG-GUID: B6wpwu1WZAO48hmyWSzcmsl_a9TvUEqj
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTExMDAyNCBTYWx0ZWRfX33U7mWuR9Yft
 wUBjQ4rv2rFKd/LcpC3q0iBasdBt2RwqaWOfiyrJufzkhnu/oI52er3T2qzcXmiGKt1aXij3Kde
 fplQYI3f+K5DBT8q0Fu06vSVbplw8eg=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-11_01,2026-09-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 bulkscore=0 clxscore=1015 malwarescore=0 lowpriorityscore=0
 priorityscore=1501 adultscore=0 suspectscore=0 impostorscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609110024

From: Dave Marquardt <davemarq@linux.ibm.com>

Refactor async event handling to support both traditional async CRQs and
new asynchronous sub-queue CRQs.

Introduce struct ibmvfc_async_crq_event, a tagged union that wraps
either an ibmvfc_async_crq (main CRQ) or an ibmvfc_async_sub_crq
(async sub-CRQ), with an enum ibmvfc_async_crq_type discriminator.
Replace the ibmvfc_async_work bare union and is_subq bool with a
single event field of this type.

Modify ibmvfc_handle_async() to accept a struct ibmvfc_async_crq_event *
instead of a void * plus a bool flag. Update ibmvfc_process_async_work()
to dispatch based on event.type.

Add ibmvfc_full_fpin_to_desc() to convert full FPIN messages from async
sub-queue format to fc_els_fpin structures. Update FPIN processing logic
to extract WWPN, node_name, and scsi_id from the appropriate union member
based on event type.

Update KUnit tests to use struct ibmvfc_async_crq_event arrays at call
sites.

Signed-off-by: Dave Marquardt <davemarq@linux.ibm.com>
Acked-by: Tyrel Datwyler <tyreld@linux.ibm.com>
---
 drivers/scsi/ibmvscsi/ibmvfc-core.c  | 162 +++++++++++++++++++++------
 drivers/scsi/ibmvscsi/ibmvfc.h       |  18 ++-
 drivers/scsi/ibmvscsi/ibmvfc_kunit.c | 135 ----------------------
 3 files changed, 141 insertions(+), 174 deletions(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/ibmvfc-core.c
index 6b2eb82ceb98..daec81f48857 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
@@ -3426,6 +3426,45 @@ ibmvfc_basic_fpin_to_desc(struct ibmvfc_async_crq *crq, u64 wwpn)
 					  cpu_to_be32(1));
 }
 
+/**
+ * ibmvfc_full_fpin_to_desc(): allocate and populate a struct fc_els_fpin struct
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
+ibmvfc_full_fpin_to_desc(struct ibmvfc_async_sub_crq *ibmvfc_fpin)
+{
+	__be16 type;
+
+	switch (ibmvfc_fpin->fpin_status) {
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
+	return ibmvfc_common_fpin_to_desc(ibmvfc_fpin->fpin_status, ibmvfc_fpin->wwpn,
+					  type, cpu_to_be16(0),
+					  cpu_to_be32(IBMVFC_FPIN_DEFAULT_EVENT_THRESHOLD),
+					  cpu_to_be32(1));
+}
+
 /**
  * ibmvfc_find_target - Search for a target in a target list
  * @target_list: list head of targets to search
@@ -3463,28 +3502,39 @@ static struct ibmvfc_target *ibmvfc_find_target(struct list_head *target_list,
  */
 static void ibmvfc_process_async_work(struct work_struct *work)
 {
+	struct ibmvfc_async_sub_crq *subq = NULL;
 	struct ibmvfc_async_work *aw;
-	struct ibmvfc_async_crq *crq;
+	struct ibmvfc_async_crq *crq = NULL;
 	struct ibmvfc_target *tgt;
 	struct ibmvfc_host *vhost;
-	struct fc_els_fpin *fpin;
+	struct fc_els_fpin *fpin = NULL;
 	unsigned long flags;
+	__be64 node_name;
+	__be64 scsi_id;
+	__be64 wwpn;
 
 	aw = container_of_const(work, struct ibmvfc_async_work, async_work_s);
 	vhost = aw->vhost;
-	crq = &aw->crq;
+	if (aw->event.type == IBMVFC_ASYNC_CRQ_SUB) {
+		subq = &aw->event.subq;
+		scsi_id = 0;
+		wwpn = subq->wwpn;
+		node_name = (subq->flags & IBMVFC_ASYNC_ID_IS_ASSOC_ID) ? 0 : subq->id.node_name;
+	} else {
+		crq = &aw->event.async_crq;
+		scsi_id = crq->scsi_id;
+		wwpn = crq->wwpn;
+		node_name = crq->node_name;
+	}
 
-	if (!crq->scsi_id && !crq->wwpn && !crq->node_name)
+	if (!scsi_id && !wwpn && !node_name)
 		goto free;
 
 	spin_lock_irqsave(vhost->host->host_lock, flags);
-	tgt = ibmvfc_find_target(&vhost->scsi_scrqs.targets, crq->scsi_id,
-				 crq->wwpn, crq->node_name);
+	tgt = ibmvfc_find_target(&vhost->scsi_scrqs.targets, scsi_id, wwpn, node_name);
 	if (!tgt) {
 		/* Target not found in scsi_scrqs, search nvme_scrqs */
-		tgt = ibmvfc_find_target(&vhost->nvme_scrqs.targets,
-					 crq->scsi_id, crq->wwpn,
-					 crq->node_name);
+		tgt = ibmvfc_find_target(&vhost->nvme_scrqs.targets, scsi_id, wwpn, node_name);
 	}
 
 	if (tgt) {
@@ -3496,7 +3546,11 @@ static void ibmvfc_process_async_work(struct work_struct *work)
 		goto free;
 	}
 
-	fpin = ibmvfc_basic_fpin_to_desc(crq, tgt->wwpn);
+	if (crq)
+		fpin = ibmvfc_basic_fpin_to_desc(crq, tgt->wwpn);
+	else
+		fpin = ibmvfc_full_fpin_to_desc(subq);
+
 	if (fpin) {
 		fc_host_fpin_rcv(tgt->vhost->host,
 				 sizeof(*fpin) + be32_to_cpu(fpin->desc_len),
@@ -3512,25 +3566,51 @@ static void ibmvfc_process_async_work(struct work_struct *work)
 
 /**
  * ibmvfc_handle_async - Handle an async event from the adapter
- * @crq:	crq to process
+ * @ae:		tagged union wrapping either an ibmvfc_async_crq (main CRQ) or an
+ *		ibmvfc_async_sub_crq (async sub-CRQ); the type field identifies which
  * @vhost:	ibmvfc host struct
  *
  **/
-VISIBLE_IF_KUNIT void ibmvfc_handle_async(struct ibmvfc_async_crq *crq,
+VISIBLE_IF_KUNIT void ibmvfc_handle_async(struct ibmvfc_async_crq_event *ae,
 					  struct ibmvfc_host *vhost)
 {
-	const struct ibmvfc_async_desc *desc = ibmvfc_get_ae_desc(be64_to_cpu(crq->event));
+	struct ibmvfc_async_crq *async_crq = NULL;
+	struct ibmvfc_async_sub_crq *subq = NULL;
+	const struct ibmvfc_async_desc *desc;
 	struct ibmvfc_async_work *aw;
 	struct ibmvfc_target *tgt;
-
-	ibmvfc_log(vhost, desc->log_level, "%s event received. scsi_id: %llx, wwpn: %llx,"
-		   " node_name: %llx%s\n", desc->desc, be64_to_cpu(crq->scsi_id),
-		   be64_to_cpu(crq->wwpn), be64_to_cpu(crq->node_name),
-		   ibmvfc_get_link_state(crq->link_state));
-
-	switch (be64_to_cpu(crq->event)) {
+	__be64 node_name;
+	__be64 scsi_id;
+	u8 link_state;
+	__be64 wwpn;
+	u64 event;
+
+	if (ae->type == IBMVFC_ASYNC_CRQ_SUB) {
+		subq = &ae->subq;
+		event = be16_to_cpu(subq->event);
+		link_state = subq->link_state;
+		scsi_id = 0;
+		wwpn = subq->wwpn;
+		node_name = subq->flags & IBMVFC_ASYNC_ID_IS_ASSOC_ID ? 0 : subq->id.node_name;
+	} else {
+		async_crq = &ae->async_crq;
+		event = be64_to_cpu(async_crq->event);
+		link_state = async_crq->link_state;
+		scsi_id = async_crq->scsi_id;
+		wwpn = async_crq->wwpn;
+		node_name = async_crq->node_name;
+	}
+
+	desc = ibmvfc_get_ae_desc(event);
+	ibmvfc_log(vhost, desc->log_level,
+		   "%s event received. scsi_id: %llx, wwpn: %llx, node_name: %llx, event %llx%s\n",
+		   desc->desc, be64_to_cpu(scsi_id),
+		   be64_to_cpu(wwpn), be64_to_cpu(node_name), event,
+		   ibmvfc_get_link_state(link_state));
+
+	switch (event) {
 	case IBMVFC_AE_RESUME:
-		switch (crq->link_state) {
+		switch (link_state) {
 		case IBMVFC_AE_LS_LINK_DOWN:
 			ibmvfc_link_down(vhost, IBMVFC_LINK_DOWN);
 			break;
@@ -3569,33 +3649,33 @@ VISIBLE_IF_KUNIT void ibmvfc_handle_async(struct ibmvfc_async_crq *crq,
 	case IBMVFC_AE_ELS_PRLO:
 	case IBMVFC_AE_ELS_PLOGI:
 		list_for_each_entry(tgt, &vhost->scsi_scrqs.targets, queue) {
-			if (!crq->scsi_id && !crq->wwpn && !crq->node_name)
+			if (!scsi_id && !wwpn && !node_name)
 				break;
-			if (crq->scsi_id && cpu_to_be64(tgt->scsi_id) != crq->scsi_id)
+			if (scsi_id && cpu_to_be64(tgt->scsi_id) != scsi_id)
 				continue;
-			if (crq->wwpn && cpu_to_be64(tgt->ids.port_name) != crq->wwpn)
+			if (wwpn && cpu_to_be64(tgt->ids.port_name) != wwpn)
 				continue;
-			if (crq->node_name && cpu_to_be64(tgt->ids.node_name) != crq->node_name)
+			if (node_name && cpu_to_be64(tgt->ids.node_name) != node_name)
 				continue;
-			if (tgt->need_login && be64_to_cpu(crq->event) == IBMVFC_AE_ELS_LOGO)
+			if (tgt->need_login && event == IBMVFC_AE_ELS_LOGO)
 				tgt->logo_rcvd = 1;
-			if (!tgt->need_login || be64_to_cpu(crq->event) == IBMVFC_AE_ELS_PLOGI) {
+			if (!tgt->need_login || event == IBMVFC_AE_ELS_PLOGI) {
 				ibmvfc_del_tgt(tgt);
 				ibmvfc_reinit_host(vhost);
 			}
 		}
 		list_for_each_entry(tgt, &vhost->nvme_scrqs.targets, queue) {
-			if (!crq->scsi_id && !crq->wwpn && !crq->node_name)
+			if (!scsi_id && !wwpn && !node_name)
 				break;
-			if (crq->scsi_id && cpu_to_be64(tgt->scsi_id) != crq->scsi_id)
+			if (scsi_id && cpu_to_be64(tgt->scsi_id) != scsi_id)
 				continue;
-			if (crq->wwpn && cpu_to_be64(tgt->ids.port_name) != crq->wwpn)
+			if (wwpn && cpu_to_be64(tgt->ids.port_name) != wwpn)
 				continue;
-			if (crq->node_name && cpu_to_be64(tgt->ids.node_name) != crq->node_name)
+			if (node_name && cpu_to_be64(tgt->ids.node_name) != node_name)
 				continue;
-			if (tgt->need_login && be64_to_cpu(crq->event) == IBMVFC_AE_ELS_LOGO)
+			if (tgt->need_login && event == IBMVFC_AE_ELS_LOGO)
 				tgt->logo_rcvd = 1;
-			if (!tgt->need_login || be64_to_cpu(crq->event) == IBMVFC_AE_ELS_PLOGI) {
+			if (!tgt->need_login || event == IBMVFC_AE_ELS_PLOGI) {
 				ibmvfc_del_tgt(tgt);
 				ibmvfc_reinit_host(vhost);
 			}
@@ -3618,14 +3698,14 @@ VISIBLE_IF_KUNIT void ibmvfc_handle_async(struct ibmvfc_async_crq *crq,
 		if (aw) {
 			INIT_WORK(&aw->async_work_s, ibmvfc_process_async_work);
 			aw->vhost = vhost;
-			aw->crq = *crq;
+			aw->event = *ae;
 			queue_work(vhost->fpin_workq, &aw->async_work_s);
 		} else
 			dev_err_ratelimited(vhost->dev,
 					    "can't offload async CRQ to work queue\n");
 		break;
 	default:
-		dev_err(vhost->dev, "Unknown async event received: %lld\n", crq->event);
+		dev_err(vhost->dev, "Unknown async event received: %llu\n", event);
 		break;
 	}
 }
@@ -4166,7 +4246,11 @@ static void ibmvfc_tasklet(void *data)
 	while (!done) {
 		/* Pull all the valid messages off the async CRQ */
 		while ((async = ibmvfc_next_async_crq(vhost)) != NULL) {
-			ibmvfc_handle_async(async, vhost);
+			struct ibmvfc_async_crq_event ae = {
+				.type = IBMVFC_ASYNC_CRQ_MAIN,
+				.async_crq = *async,
+			};
+			ibmvfc_handle_async(&ae, vhost);
 			async->valid = 0;
 			wmb();
 		}
@@ -4180,8 +4264,12 @@ static void ibmvfc_tasklet(void *data)
 
 		vio_enable_interrupts(vdev);
 		if ((async = ibmvfc_next_async_crq(vhost)) != NULL) {
+			struct ibmvfc_async_crq_event ae = {
+				.type = IBMVFC_ASYNC_CRQ_MAIN,
+				.async_crq = *async,
+			};
 			vio_disable_interrupts(vdev);
-			ibmvfc_handle_async(async, vhost);
+			ibmvfc_handle_async(&ae, vhost);
 			async->valid = 0;
 			wmb();
 		} else if ((crq = ibmvfc_next_crq(vhost)) != NULL) {
diff --git a/drivers/scsi/ibmvscsi/ibmvfc.h b/drivers/scsi/ibmvscsi/ibmvfc.h
index a8a063d99564..6fce7a4922bb 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.h
+++ b/drivers/scsi/ibmvscsi/ibmvfc.h
@@ -786,9 +786,22 @@ struct ibmvfc_async_sub_crq {
 	} id;
 } __packed __aligned(8);
 
+enum ibmvfc_async_crq_type {
+	IBMVFC_ASYNC_CRQ_MAIN = 0,
+	IBMVFC_ASYNC_CRQ_SUB,
+};
+
+struct ibmvfc_async_crq_event {
+	enum ibmvfc_async_crq_type type;
+	union {
+		struct ibmvfc_async_crq async_crq;
+		struct ibmvfc_async_sub_crq subq;
+	};
+};
+
 struct ibmvfc_async_work {
 	struct ibmvfc_host *vhost;
-	struct ibmvfc_async_crq crq;
+	struct ibmvfc_async_crq_event event;
 	struct work_struct async_work_s;
 };
 
@@ -1103,7 +1116,8 @@ static inline struct ibmvfc_host *ibmvfc_channels_to_vhost(struct ibmvfc_channel
 
 #if IS_ENABLED(CONFIG_KUNIT)
 #include <kunit/visibility.h>
-VISIBLE_IF_KUNIT void ibmvfc_handle_async(struct ibmvfc_async_crq *crq, struct ibmvfc_host *vhost);
+VISIBLE_IF_KUNIT void ibmvfc_handle_async(struct ibmvfc_async_crq_event *event,
+					  struct ibmvfc_host *vhost);
 VISIBLE_IF_KUNIT struct ibmvfc_host *ibmvfc_get_first_vhost(void);
 #endif
 
diff --git a/drivers/scsi/ibmvscsi/ibmvfc_kunit.c b/drivers/scsi/ibmvscsi/ibmvfc_kunit.c
index 80e7f8e0fd70..7aaed4f64f26 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc_kunit.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc_kunit.c
@@ -3,7 +3,6 @@
 #include <kunit/visibility.h>
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_transport_fc.h>
-#include <scsi/fc/fc_els.h>
 #include <linux/list.h>
 #include <linux/delay.h>
 #include "ibmvfc.h"
@@ -257,143 +256,9 @@ static void ibmvfc_full_fpin_test(struct kunit *test)
 	scsi_host_put(vhost->host);
 }
 
-#define IBMVFC_TEST_FPIN_EXT(fs, ev, stat, crq) {				\
-	struct ibmvfc_async_crq_event ae = { .type = IBMVFC_ASYNC_CRQ_SUB };	\
-	(crq).valid = 0x80;							\
-	(crq).flags = IBMVFC_ASYNC_IS_FPIN_EXT;					\
-	(crq).link_state = IBMVFC_AE_LS_LINK_UP;				\
-	(crq).fpin_status = (fs);						\
-	(crq).event = cpu_to_be16(IBMVFC_AE_FPIN);				\
-	(crq).wwpn = cpu_to_be64(tgt->wwpn);					\
-	(crq).fpin_data.flags = IBMVFC_FPIN_EVENT_TYPE_VALID;			\
-	(crq).fpin_data.event_type = cpu_to_be16((ev));				\
-	ae.subq = *(struct ibmvfc_async_sub_crq *)&(crq);			\
-	pre = READ_ONCE(rport->fpin_stats.stat);				\
-	ibmvfc_handle_async(&ae, vhost);					\
-	flush_workqueue(vhost->fpin_workq);					\
-	post = READ_ONCE(rport->fpin_stats.stat);				\
-}
-
-/**
- * ibmvfc_extended_fpin_test - unit test for extended FPIN events
- * @test: pointer to kunit structure
- *
- * Note: This test exercises extended FPIN code paths but does not check
- * that statistics are correctly updated.
- *
- * Return: void
- */
-static void ibmvfc_extended_fpin_test(struct kunit *test)
-{
-	enum ibmvfc_ae_fpin_status fs;
-	struct ibmvfc_async_subq_fpin crq[IBMVFC_AE_FPIN_CONGESTION_CLEARED+1] = {};
-	struct ibmvfc_async_subq_fpin
-		crqcn[IBMVFC_AE_FPIN_PORT_CONGESTED][FPIN_CONGN_DEVICE_SPEC+1] = {};
-	struct ibmvfc_async_subq_fpin crqportdg[FPIN_LI_DEVICE_SPEC+1] = {};
-	struct ibmvfc_target *tgt;
-	struct ibmvfc_host *vhost;
-	struct fc_rport *rport;
-	LIST_HEAD(evt_doneq);
-	unsigned long flags;
-	u64 pre, post;
-
-	vhost = ibmvfc_get_first_vhost();
-	if (!vhost)
-		kunit_skip(test, "No ibmvfc devices available");
-
-	spin_lock_irqsave(vhost->host->host_lock, flags);
-	if (vhost->scsi_scrqs.num_targets < 1) {
-		spin_unlock_irqrestore(vhost->host->host_lock, flags);
-		scsi_host_put(vhost->host);
-		kunit_skip(test, "No targets");
-	}
-	tgt = list_first_entry(&vhost->scsi_scrqs.targets, struct ibmvfc_target, queue);
-	if (!tgt->rport) {
-		spin_unlock_irqrestore(vhost->host->host_lock, flags);
-		scsi_host_put(vhost->host);
-		kunit_skip(test, "No rport");
-	}
-	rport = tgt->rport;
-	get_device(&rport->dev);
-	kref_get(&tgt->kref);
-	spin_unlock_irqrestore(vhost->host->host_lock, flags);
-
-	for (fs = IBMVFC_AE_FPIN_LINK_CONGESTED; fs <= IBMVFC_AE_FPIN_CONGESTION_CLEARED; fs++) {
-		switch (fs) {
-		case IBMVFC_AE_FPIN_PORT_CLEARED:
-		case IBMVFC_AE_FPIN_CONGESTION_CLEARED: {
-			struct ibmvfc_async_crq_event ae = { .type = IBMVFC_ASYNC_CRQ_SUB };
-
-			crq[fs].valid = 0x80;
-			crq[fs].flags = IBMVFC_ASYNC_IS_FPIN_EXT;
-			crq[fs].link_state = IBMVFC_AE_LS_LINK_UP;
-			crq[fs].fpin_status = fs;
-			crq[fs].event = cpu_to_be16(IBMVFC_AE_FPIN);
-			crq[fs].wwpn = cpu_to_be64(tgt->wwpn);
-			crq[fs].fpin_data.flags = IBMVFC_FPIN_EVENT_TYPE_VALID;
-			crq[fs].fpin_data.event_type = cpu_to_be16(FPIN_CONGN_CLEAR);
-			ae.subq = *(struct ibmvfc_async_sub_crq *)&crq[fs];
-			pre = READ_ONCE(rport->fpin_stats.cn_clear);
-			ibmvfc_handle_async(&ae, vhost);
-			flush_workqueue(vhost->fpin_workq);
-			post = READ_ONCE(rport->fpin_stats.cn_clear);
-			break;
-		}
-		case IBMVFC_AE_FPIN_LINK_CONGESTED:
-		case IBMVFC_AE_FPIN_PORT_CONGESTED:
-			IBMVFC_TEST_FPIN_EXT(fs, FPIN_CONGN_CLEAR, cn_clear,
-					     crqcn[fs-1][FPIN_CONGN_CLEAR]);
-			IBMVFC_TEST_FPIN_EXT(fs, FPIN_CONGN_LOST_CREDIT,
-					     cn_lost_credit,
-					     crqcn[fs-1][FPIN_CONGN_LOST_CREDIT]);
-			IBMVFC_TEST_FPIN_EXT(fs, FPIN_CONGN_CREDIT_STALL,
-					     cn_credit_stall,
-					     crqcn[fs-1][FPIN_CONGN_CREDIT_STALL]);
-			IBMVFC_TEST_FPIN_EXT(fs, FPIN_CONGN_OVERSUBSCRIPTION,
-					     cn_oversubscription,
-					     crqcn[fs-1][FPIN_CONGN_OVERSUBSCRIPTION]);
-			IBMVFC_TEST_FPIN_EXT(fs, FPIN_CONGN_DEVICE_SPEC,
-					     cn_device_specific,
-					     crqcn[fs-1][FPIN_CONGN_DEVICE_SPEC]);
-			break;
-		case IBMVFC_AE_FPIN_PORT_DEGRADED:
-			IBMVFC_TEST_FPIN_EXT(fs, FPIN_LI_UNKNOWN,
-					     li_failure_unknown,
-					     crqportdg[FPIN_LI_UNKNOWN]);
-			IBMVFC_TEST_FPIN_EXT(fs, FPIN_LI_LINK_FAILURE,
-					     li_link_failure_count,
-					     crqportdg[FPIN_LI_LINK_FAILURE]);
-			IBMVFC_TEST_FPIN_EXT(fs, FPIN_LI_LOSS_OF_SYNC,
-					     li_loss_of_sync_count,
-					     crqportdg[FPIN_LI_LOSS_OF_SYNC]);
-			IBMVFC_TEST_FPIN_EXT(fs, FPIN_LI_LOSS_OF_SIG,
-					     li_loss_of_signals_count,
-					     crqportdg[FPIN_LI_LOSS_OF_SIG]);
-			IBMVFC_TEST_FPIN_EXT(fs, FPIN_LI_PRIM_SEQ_ERR,
-					     li_prim_seq_err_count,
-					     crqportdg[FPIN_LI_PRIM_SEQ_ERR]);
-			IBMVFC_TEST_FPIN_EXT(fs, FPIN_LI_INVALID_TX_WD,
-					     li_invalid_tx_word_count,
-					     crqportdg[FPIN_LI_INVALID_TX_WD]);
-			IBMVFC_TEST_FPIN_EXT(fs, FPIN_LI_INVALID_CRC,
-					     li_invalid_crc_count,
-					     crqportdg[FPIN_LI_INVALID_CRC]);
-			IBMVFC_TEST_FPIN_EXT(fs, FPIN_LI_DEVICE_SPEC,
-					     li_device_specific,
-					     crqportdg[FPIN_LI_DEVICE_SPEC]);
-			break;
-		}
-	}
-
-	put_device(&rport->dev);
-	kref_put(&tgt->kref, ibmvfc_release_tgt);
-	scsi_host_put(vhost->host);
-}
-
 static struct kunit_case ibmvfc_fpin_test_cases[] = {
 	KUNIT_CASE(ibmvfc_async_fpin_test),
 	KUNIT_CASE(ibmvfc_full_fpin_test),
-	KUNIT_CASE(ibmvfc_extended_fpin_test),
 	{},
 };
 
-- 
2.55.0

