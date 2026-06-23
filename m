Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB76935A39F;
	Tue, 23 Jun 2026 01:30:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782178250; cv=none; b=pixSAVQxy56paKik82a1m15Vk9f8lj7NYjQ1XmTpVGmFbSWq/waUAiHcP4r63APnhG6I5RsqzeA5m0J/bgC5+IRhai5M+Hh0Mk+L+h446VdkUDO3lo+zD6nwxa4XcPx72N42YrY1u+7T4srzC8mHL9y1oBBD/hMSY0DLFAJxoj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782178250; c=relaxed/simple;
	bh=QxOH6QDoRwrzHgdAm52V1j0dCUOUIIHRJctHMPzRqls=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YdMI4lxedQNOKvMgWBmUVl4zxXsXoBi4i4kyePAUaJ5og4lxWa8oMdqHySUElh27iDDuGOJqtG1pzEuvMMwILQhCqxxRkIWgwydUqQjO96jsOpOuslk0KqmwxDZS0NAnOF5It2HbcbpQRAkVRCuL0JeGpBepz1sxI7jRGvAjWmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=q5vmBKgJ; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="q5vmBKgJ"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65N0mSSO408386;
	Tue, 23 Jun 2026 01:30:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=6GEhFxN/kzBXYj4lb
	rABW/QWN1v5qqXhSe1JKrJuxso=; b=q5vmBKgJHCGnBs4qzUI2yJjrRw3E9jqOL
	2XbuNyJMnWHrmkXRvb2euzPtQl+BpWsyYGGYXM8ehpFEHQVCdm7CBrkpy54F5ajf
	NILDlioaEmxo0yASaFUjdlJqcJu8lwWc4QMbUH4CkeZ+JyAMPUXBIjQjZz5PSAdd
	ZWdlRq4M4uvYrv0lmS0q+RtF8LqR8hIkhouKgK3s5vdShy09rf9YdEehCzbYgsyT
	pEI5tniSSJdQLD+/AvqxIyxHmTHuXK7hOPYZvMMvOve4c88DedaV7RUZ4cperp34
	C6d3GLzK4+a9Ceb6+rkgN5nYCeFx4Az49HF0EptqVw49aGUVCCq8A==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4ewjc3c4qm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 23 Jun 2026 01:30:42 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 65N1JgqS005243;
	Tue, 23 Jun 2026 01:30:41 GMT
Received: from smtprelay05.wdc07v.mail.ibm.com ([172.16.1.72])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4ex5jw92hu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 23 Jun 2026 01:30:41 +0000 (GMT)
Received: from smtpav04.dal12v.mail.ibm.com (smtpav04.dal12v.mail.ibm.com [10.241.53.103])
	by smtprelay05.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 65N1UdF351446254
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 23 Jun 2026 01:30:40 GMT
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9DD755805A;
	Tue, 23 Jun 2026 01:30:39 +0000 (GMT)
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 076BA58062;
	Tue, 23 Jun 2026 01:30:39 +0000 (GMT)
Received: from li-4c4c4544-0054-3910-8039-c3c04f423534.ibm.com.com (unknown [9.61.188.206])
	by smtpav04.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 23 Jun 2026 01:30:38 +0000 (GMT)
From: Tyrel Datwyler <tyreld@linux.ibm.com>
To: james.bottomley@hansenpartnership.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, brking@linux.ibm.com,
        davemarq@linux.ibm.com, Tyrel Datwyler <tyreld@linux.ibm.com>
Subject: [PATCH 02/29] ibmvfc: add NVMe/FC protocol interface definitions
Date: Mon, 22 Jun 2026 18:30:08 -0700
Message-ID: <20260623013035.3436640-3-tyreld@linux.ibm.com>
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
X-Authority-Analysis: v=2.4 cv=X4Ni7mTe c=1 sm=1 tr=0 ts=6a39e1c2 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=iQ6ETzBq9ecOQQE5vZCe:22 a=VnNF1IyMAAAA:8 a=JmYX4WQfQ2vWtGjAzx0A:9
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjIzMDAwOCBTYWx0ZWRfX5MiwdgolbGup
 Tvim2FmGPej4BANoQY70hzfmwhI9o9TGwdS2pZGp+Kt5AVlP3TX+wChcw7LmMy+nC2O4996hIv1
 0+5/01JNWFgXXGfPe2lms3OwiiFAmGo=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjIzMDAwOCBTYWx0ZWRfXzrQ1joDI39wQ
 u1AxjqQdQyUmidOHDgOFI1oD17WYVAkF3ZrVMQkOpVsRk+CSh0Eb36WM33pb9MXNaAFlR3QXWk4
 TpSpfjUyRkKhldvWYp5ExH8DgAHqggzn8u8UzrskdCzfQIOWk9/sab8dE8N20AEPXn80H6RdHFV
 UnyMYLe6F9IqZMO8XbW3U+gpVnc11v0YGJuZ4GKdhp8C6vmOdDrRZuNHtkkBYDSJiW+g8BjpHkc
 vojtn6/uNmm1VkLAY/Ps54U1dBhlwDahzq4THr8DMFVMVWtN3EKfarBcgS+5WSiEERcGWlh2LLe
 lU+Z5taN6ZNlaraxJSJRbH2PrP6rDLL9HYjWY93i1dYVldr3Y4IbJCPT9v4on+nFMBR6MwEmjeW
 6BI+/LdZRjQLyZW7CQX7QN+BhMvrPkr7r0oTpKKUXs7xln2zF07wAzuMElbCtZ/ldx66BsGSs6S
 1R14b2E+pPKaWqhPzyw==
X-Proofpoint-ORIG-GUID: AemgYJ2isapdo-1WMgNupkjAD0LXZlqN
X-Proofpoint-GUID: AemgYJ2isapdo-1WMgNupkjAD0LXZlqN
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-23_01,2026-06-22_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 bulkscore=0 suspectscore=0 spamscore=0 priorityscore=1501
 impostorscore=0 malwarescore=0 clxscore=1015 adultscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2606230008

Add the protocol definitions for client-VIOS interface updates needed to
support NVMe/FC over the ibmvfc NPIV transport.

Extend the ibmvfc interface with:

- NVMe/FC-specific capability bits and opcodes
- protocol-specific channel and queue definitions
- updated channel enquiry/setup fields for NVMe queues
- v3 command layout support for protocol-specific payloads

These changes provide the common header and interface plumbing needed by
later patches that add NVMe/FC login, discovery, remote-port handling,
and I/O submission.

Signed-off-by: Tyrel Datwyler <tyreld@linux.ibm.com>
---
 drivers/scsi/ibmvscsi/ibmvfc.h | 153 +++++++++++++++++++++++++--------
 1 file changed, 119 insertions(+), 34 deletions(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc.h b/drivers/scsi/ibmvscsi/ibmvfc.h
index 0e259e9d2e9b..f8a2bf92da41 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.h
+++ b/drivers/scsi/ibmvscsi/ibmvfc.h
@@ -13,6 +13,8 @@
 #include <linux/list.h>
 #include <linux/types.h>
 #include <scsi/viosrp.h>
+#include <linux/nvme.h>
+#include <linux/nvme-fc.h>
 
 #define IBMVFC_NAME	"ibmvfc"
 #define IBMVFC_DRIVER_VERSION		"1.0.11"
@@ -92,6 +94,7 @@ enum ibmvfc_cmd_status_flags {
 	IBMVFC_FC_SCSI_ERROR		= 0x0008,
 	IBMVFC_HW_EVENT_LOGGED		= 0x0010,
 	IBMVFC_VIOS_LOGGED		= 0x0020,
+	IBMVFC_FC_NVME_STATUS		= 0x0040,
 };
 
 enum ibmvfc_fabric_mapped_errors {
@@ -124,20 +127,37 @@ enum ibmvfc_vios_errors {
 	IBMVFC_COMMAND_FAILED			= 0x8000,
 };
 
+enum ibmvfc_fc_nvme_errors {
+	IBMVFC_NVMS_VALID_ERSP		= 0x0001,
+	IBMVFC_NVMS_VALID_NODMA_CQE	= 0x0002,
+};
+
 enum ibmvfc_mad_types {
 	IBMVFC_NPIV_LOGIN		= 0x0001,
-	IBMVFC_DISC_TARGETS	= 0x0002,
+	IBMVFC_DISC_TARGETS		= 0x0002,
+	IBMVFC_DISC_NVMF_TARGETS	= 0x0003,
 	IBMVFC_PORT_LOGIN		= 0x0004,
-	IBMVFC_PROCESS_LOGIN	= 0x0008,
-	IBMVFC_QUERY_TARGET	= 0x0010,
+	IBMVFC_NVMF_PORT_LOGIN		= 0x0005,
+	IBMVFC_PROCESS_LOGIN		= 0x0008,
+	IBMVFC_NVMF_PROCESS_LOGIN	= 0x0009,
+	IBMVFC_QUERY_TARGET		= 0x0010,
+	IBMVFC_NVMF_QUERY_TARGET	= 0x0011,
 	IBMVFC_MOVE_LOGIN		= 0x0020,
-	IBMVFC_IMPLICIT_LOGOUT	= 0x0040,
-	IBMVFC_PASSTHRU		= 0x0200,
-	IBMVFC_TMF_MAD		= 0x0100,
-	IBMVFC_NPIV_LOGOUT	= 0x0800,
-	IBMVFC_CHANNEL_ENQUIRY	= 0x1000,
-	IBMVFC_CHANNEL_SETUP	= 0x2000,
-	IBMVFC_CONNECTION_INFO	= 0x4000,
+	IBMVFC_NVMF_MOVE_LOGIN		= 0x0021,
+	IBMVFC_IMPLICIT_LOGOUT		= 0x0040,
+	IBMVFC_NVMF_IMPLICIT_LOGOUT	= 0x0041,
+	IBMVFC_RNID			= 0x0080,
+	IBMVFC_NVMF_RNID		= 0x0081,
+	IBMVFC_TMF_MAD			= 0x0100,
+	IBMVFC_NVMF_TMF_MAD		= 0x0101,
+	IBMVFC_PASSTHRU			= 0x0200,
+	IBMVFC_NVMF_PASSTHRU		= 0x0201,
+	IBMVFC_NPIV_LOGOUT		= 0x0800,
+	IBMVFC_CHANNEL_ENQUIRY		= 0x1000,
+	IBMVFC_CHANNEL_SETUP		= 0x2000,
+	IBMVFC_CONNECTION_INFO		= 0x4000,
+	IBMVFC_FABRIC_LOGIN		= 0x8000,
+	IBMVFC_NVMF_FABRIC_LOGIN	= 0x8001,
 };
 
 struct ibmvfc_mad_common {
@@ -175,11 +195,16 @@ struct ibmvfc_npiv_login {
 #define IBMVFC_FLUSH_ON_HALT		0x02
 	__be32 max_cmds;
 	__be64 capabilities;
-#define IBMVFC_CAN_MIGRATE		0x01
-#define IBMVFC_CAN_USE_CHANNELS		0x02
-#define IBMVFC_CAN_HANDLE_FPIN		0x04
-#define IBMVFC_CAN_USE_MAD_VERSION	0x08
-#define IBMVFC_CAN_SEND_VF_WWPN		0x10
+#define IBMVFC_CAN_MIGRATE		0x001
+#define IBMVFC_CAN_USE_CHANNELS		0x002
+#define IBMVFC_CAN_HANDLE_FPIN		0x004
+#define IBMVFC_CAN_USE_MAD_VERSION	0x008
+#define IBMVFC_CAN_SEND_VF_WWPN		0x010
+#define IBMVFC_YES_NVMEOF		0x020
+#define IBMVFC_YES_SCSI			0x040
+#define IBMVFC_CAN_USE_WWPN_ALL		0x080
+#define IBMVFC_USE_ASYNC_SUBQ		0x100
+#define IBMVFC_CAN_USE_NOOP_CMD		0x200
 	__be64 node_name;
 	struct srp_direct_buf async;
 	u8 partition_name[IBMVFC_MAX_NAME];
@@ -219,13 +244,18 @@ struct ibmvfc_npiv_login_resp {
 	__be16 error;
 	__be32 flags;
 #define IBMVFC_NATIVE_FC		0x01
-	__be32 reserved;
+	__be32 possible_nports;
 	__be64 capabilities;
-#define IBMVFC_CAN_FLUSH_ON_HALT	0x08
-#define IBMVFC_CAN_SUPPRESS_ABTS	0x10
-#define IBMVFC_MAD_VERSION_CAP		0x20
-#define IBMVFC_HANDLE_VF_WWPN		0x40
-#define IBMVFC_CAN_SUPPORT_CHANNELS	0x80
+#define IBMVFC_CAN_FLUSH_ON_HALT	0x0008
+#define IBMVFC_CAN_SUPPRESS_ABTS	0x0010
+#define IBMVFC_MAD_VERSION_CAP		0x0020
+#define IBMVFC_HANDLE_VF_WWPN		0x0040
+#define IBMVFC_CAN_SUPPORT_CHANNELS	0x0080
+#define IBMVFC_SUPPORT_NVMEOF		0x0100
+#define IBMVFC_SUPPORT_SCSI		0x0200
+#define IBMVFC_SUPPORT_WWPN_ALL		0x0400
+#define IBMVFC_ASYNC_SUBQ		0x0800
+#define IBMVFC_SUPPORT_NOOP_CMD		0x1000
 	__be32 max_cmds;
 	__be32 scsi_id_sz;
 	__be64 max_dma_len;
@@ -238,7 +268,7 @@ struct ibmvfc_npiv_login_resp {
 	u8 port_loc_code[IBMVFC_MAX_NAME];
 	u8 drc_name[IBMVFC_MAX_NAME];
 	struct ibmvfc_service_parms service_parms;
-	__be64 reserved2;
+	__be64 reserved;
 } __packed __aligned(8);
 
 union ibmvfc_npiv_login_data {
@@ -246,6 +276,17 @@ union ibmvfc_npiv_login_data {
 	struct ibmvfc_npiv_login_resp resp;
 } __packed __aligned(8);
 
+struct ibmvfc_fabric_login_mad {
+	struct ibmvfc_mad_common common;
+	__be64 flags;
+	__be64 capabilities;
+	__be64 nport_id;
+	__be16 status;
+	__be16 error;
+	__be32 reserved;
+	__be64 reserved2[16];
+} __packed __aligned(8);
+
 struct ibmvfc_discover_targets_entry {
 	__be32 scsi_id;
 	__be32 pad;
@@ -287,6 +328,7 @@ enum ibmvfc_fc_type {
 	IBMVFC_FABRIC_BUSY	= 0x04,
 	IBMVFC_PORT_BUSY		= 0x05,
 	IBMVFC_BASIC_REJECT	= 0x06,
+	IBMVFC_FC4_LS_REJECT	= 0x07,
 };
 
 enum ibmvfc_gs_explain {
@@ -377,20 +419,27 @@ struct ibmvfc_query_tgt {
 struct ibmvfc_implicit_logout {
 	struct ibmvfc_mad_common common;
 	__be64 old_scsi_id;
-	__be64 reserved[2];
+	__be64 reserved[8];
+	__be64 target_wwpn;
 } __packed __aligned(8);
 
 struct ibmvfc_tmf {
 	struct ibmvfc_mad_common common;
 	__be64 scsi_id;
-	struct scsi_lun lun;
+	union {
+		struct scsi_lun lun;
+		__be64 assoc_id;
+	};
 	__be32 flags;
-#define IBMVFC_TMF_ABORT_TASK		0x02
-#define IBMVFC_TMF_ABORT_TASK_SET	0x04
-#define IBMVFC_TMF_LUN_RESET		0x10
-#define IBMVFC_TMF_TGT_RESET		0x20
-#define IBMVFC_TMF_LUA_VALID		0x40
-#define IBMVFC_TMF_SUPPRESS_ABTS	0x80
+#define IBMVFC_TMF_ABORT_TASK		0x002
+#define IBMVFC_TMF_ABORT_TASK_SET	0x004
+#define IBMVFC_TMF_LUN_RESET		0x010
+#define IBMVFC_TMF_TGT_RESET		0x020
+#define IBMVFC_TMF_LUA_VALID		0x040
+#define IBMVFC_TMF_SUPPRESS_ABTS	0x080
+#define IBMVFC_TMF_NVMF_ASSOC		0x100
+#define IBMVFC_TMF_NVMF_TARGET		0x200
+#define IBMVFC_TMF_BITMASK_VALID	0x400
 	__be32 cancel_key;
 	__be32 my_cancel_key;
 	__be32 pad;
@@ -446,6 +495,8 @@ enum ibmvfc_cmd_flags {
 	IBMVFC_WRITE		= 0x0008,
 	IBMVFC_TMF			= 0x0080,
 	IBMVFC_CLASS_3_ERR	= 0x0100,
+	IBMVFC_NVMEOF_PROTOCOL	= 0x0200,
+	IBMVFC_NVMF_SLER	= 0x0400,
 };
 
 enum ibmvfc_fc_task_attr {
@@ -493,7 +544,7 @@ struct ibmvfc_cmd {
 	__be64 tgt_scsi_id;
 	__be64 tag;
 	__be64 target_wwpn;
-	__be64 reserved3;
+	__be64 assoc_id;
 	union {
 		struct {
 			struct ibmvfc_fcp_cmd_iu iu;
@@ -504,6 +555,15 @@ struct ibmvfc_cmd {
 			struct ibmvfc_fcp_cmd_iu iu;
 			struct ibmvfc_fcp_rsp rsp;
 		} v2;
+		struct {
+			__be64 reserved5[4];
+			struct ibmvfc_fcp_cmd_iu iu;
+			struct ibmvfc_fcp_rsp rsp;
+		} v3scsi;
+		struct {
+			__be64 reserved[4];
+			struct nvme_fc_cmd_iu iu;
+		} v3nvme;
 	};
 } __packed __aligned(8);
 
@@ -522,6 +582,9 @@ struct ibmvfc_passthru_iu {
 	__be32 flags;
 #define IBMVFC_FC_ELS		0x01
 #define IBMVFC_FC_CT_IU		0x02
+#define IBMVFC_PT_PRLI		0x04
+#define IBMVFC_FC4_LS_OTH	0x08
+#define IBMVFC_FC4_LS_DSC_CTRL	0x10
 	__be32 cancel_key;
 #define IBMVFC_PASSTHRU_CANCEL_KEY	0x80000000
 #define IBMVFC_INTERNAL_CANCEL_KEY	0x80000001
@@ -559,7 +622,7 @@ struct ibmvfc_channel_setup_mad {
 	struct srp_direct_buf buffer;
 } __packed __aligned(8);
 
-#define IBMVFC_MAX_CHANNELS	502
+#define IBMVFC_MAX_CHANNELS	501
 
 struct ibmvfc_channel_setup {
 	__be32 flags;
@@ -574,6 +637,7 @@ struct ibmvfc_channel_setup {
 	struct srp_direct_buf buffer;
 	__be64 reserved2[5];
 	__be64 channel_handles[IBMVFC_MAX_CHANNELS];
+	__be64 async_sub_crq_handle;
 } __packed __aligned(8);
 
 struct ibmvfc_connection_info {
@@ -620,7 +684,8 @@ struct ibmvfc_trace_entry {
 
 enum ibmvfc_crq_formats {
 	IBMVFC_CMD_FORMAT		= 0x01,
-	IBMVFC_ASYNC_EVENT	= 0x02,
+	IBMVFC_ASYNC_EVENT		= 0x02,
+	IBMVFC_NOOP			= 0x03,
 	IBMVFC_MAD_FORMAT		= 0x04,
 };
 
@@ -639,6 +704,9 @@ enum ibmvfc_async_event {
 	IBMVFC_AE_RESUME			= 0x0800,
 	IBMVFC_AE_ADAPTER_FAILED	= 0x1000,
 	IBMVFC_AE_FPIN			= 0x2000,
+	IBMVFC_NVME_DISCONNECT		= 0x4000,
+	IBMVFC_NVMEOF_PROTO_AVAIL	= 0x40000000,
+	IBMVFC_SCSI_PROTO_AVAIL		= 0x80000000,
 };
 
 struct ibmvfc_async_desc {
@@ -683,13 +751,30 @@ struct ibmvfc_async_crq {
 	volatile __be64 scsi_id;
 	volatile __be64 wwpn;
 	volatile __be64 node_name;
-	__be64 reserved;
+	__be64 assoc_id;
+} __packed __aligned(8);
+
+struct ibmvfc_async_sub_crq {
+	volatile u8 valid;
+	u8 flags;
+#define IBMVFC_ASYNC_ID_IS_ASSOC_ID	0x01
+	u8 link_state;
+	u8 fpin_status;
+	__be16 event;
+	__be16 pad;
+	__be64 wwpn;
+	__be64 nport_id;
+	union {
+		__be64 node_name;
+		__be64 assoc_id;
+	} id;
 } __packed __aligned(8);
 
 union ibmvfc_iu {
 	struct ibmvfc_mad_common mad_common;
 	struct ibmvfc_npiv_login_mad npiv_login;
 	struct ibmvfc_npiv_logout_mad npiv_logout;
+	struct ibmvfc_fabric_login_mad fabric_login;
 	struct ibmvfc_discover_targets discover_targets;
 	struct ibmvfc_port_login plogi;
 	struct ibmvfc_process_login prli;
-- 
2.54.0

