Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E56721D00A
	for <linux-scsi@vger.kernel.org>; Fri, 17 Jul 2026 15:30:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784302241; cv=none; b=ouiZBjrwvVX6o9ZWJPdgchxdWtuUdm7CXVtXDb+cJzCVkHlq2IEOVaUupGV5E0EyHivClHvmV0eJF5lEjipH32RFhtdFGRECtXdRWp+BwcISjnkyFhYf9RYbf3w36au2ngG5eJCOrwqcvjH7pqISDFt/emkPlgSgeI1uV/reORQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784302241; c=relaxed/simple;
	bh=n/wEagbmwG2ios+K3ckb3b/vMipOgFCV+Lfvvh7F7RQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MVGIKkkOf6oVy0CIlswK2zlUdktRaUINvPBEG/2KAcf2RhB40PjOrdxq8IgFis1WIUh3Pkbfr0WHZX4AXr97eYLOIYBgTCDp5GoNRntkIyOk+I4o3zEOjnbI9mguZZql99seOUR8MPMkAp2WOV5wj6rtBO8UU30JMlO3eTlQlzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=Q5OYmJrx; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="Q5OYmJrx"
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66HE6FG4113617;
	Fri, 17 Jul 2026 08:30:37 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=5
	3dQAi6LPy3BxXVF66X0rNCPogGdJcntFGTvfRALHLQ=; b=Q5OYmJrxgzV83S+yk
	JOblkLrQqNPzHFd0CU4/SFxjtB/kh/OjN1G5uLzcCIegOHG235nPmQCG+3jl0lOA
	K4xIFYeaUE3DzmN75I4Cm4ZRMbtklJJQH9j/+Y6afy0/3dEOY8qVfx6s+Ig4dTf5
	komv8qlkIpxvAxGEMkItGmg5BrzcGh+XrBvNWnwTtRxlhcocQKL0MbUNlx/yEZQp
	SzDV3kndE+NZ9Qi8ZdTbvwi6Y9iM0pIUj4bPqH3TSo8y/yoeOvi0+ph/h26nW117
	N/nqXzMF0nURyyDQ1lQE3DzUcXidVptaYI8fbJgLRTYcDnx5nHw58yN1J2mg2oiv
	5PDvA==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 4fetcbn17c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 17 Jul 2026 08:30:37 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 17 Jul 2026 08:30:36 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Fri, 17 Jul 2026 08:30:36 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 016435B693B;
	Fri, 17 Jul 2026 08:30:33 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v5 30/56] scsi: qla2xxx: Add size check for ELS status entry layout on 29xx
Date: Fri, 17 Jul 2026 20:58:38 +0530
Message-ID: <20260717152904.3155730-31-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20260717152904.3155730-1-njavali@marvell.com>
References: <20260717152904.3155730-1-njavali@marvell.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: fmEzpOllnLA-Dus25um_rM1ki7NxDnii
X-Authority-Analysis: v=2.4 cv=Y7jIdBeN c=1 sm=1 tr=0 ts=6a5a4a9d cx=c_pps
 a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=QXcCYyLzdtTjyudCfB6f:22 a=M5GUcnROAAAA:8 a=VwQbUJbxAAAA:8
 a=usBOGR8KzlEXNHoOUIAA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzE3MDE1OCBTYWx0ZWRfX7L9jqZREl6h8
 I2ZQxxdpcxMjm62ygA0eAkjw+M8GLmaz4rHTZGaGWZ+512ICPTOIxKQ+oEUMU2kZlhlylFyVSHR
 tVqBnrB8pAU+Z8Na5Chjhkp5+clrz0E=
X-Proofpoint-GUID: fmEzpOllnLA-Dus25um_rM1ki7NxDnii
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzE3MDE1OCBTYWx0ZWRfX0hlWWdkwsrJY
 NKB3xGZcbtGSDy+3jlw3OH+4LwLq9qMw+E8wHDqJIzOKq7fDxhHThCwUDmv4rzI0uRovi1KFKTa
 9eXi1+pVMYRemlxrb1MUtk2XHQ14RVH3cQL+Q5zuOchWJ/spLOSFb3zKz/Nr5/pOlFwt6mmnX0s
 l//qPsTmojHkA8JeHmavAjM210fPSXtIYLSt1jEjeMuLpfVkpVDQhY3dlKxuQD2HCux/S8eDhWa
 pkRpeb2AE1VW0g56XJiWTjyGgHtj3yAJtrFfVuPRkUfHCyABOuIgUkEvPvLJBi0J73/kfzBYqMN
 +4uJULz/OyUAQyJeS/XwUiGtHFKMYKf4coL8esS2rksWWKh1RDaygohWRGcdyL3rjjE/9OEQ4q4
 7/r7BqacKmmw5V96ny93xWGdkckwzZGih6qZ4n8EgSnnJplqLu1Yhe5xeLE5EfP8Ij30bWJ7ZyF
 wD5vVEFNTaPsE6VoxIg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-17_04,2026-07-17_01,2025-10-01_01

Add a BUILD_BUG_ON in qla2x00_module_init() to validate that struct
els_sts_entry_24xx_ext is 128 bytes, matching the 29xx firmware IOCB
size.

The extended layout (29xx) overlays the base els_sts_entry_24xx for
every field read in qla24xx_els_ct_entry(): comp_status,
total_byte_count, error_subcode_1/2, d_id[], s_id[], and
control_flags all sit at byte-identical offsets in both structs.  Only
vp_index/sof_type at offset 14-15 differs (bit-packed differently in
the ext variant), but that field is write-only on the issue path and
never read in this completion handler.

Add a docblock at the top of qla24xx_els_ct_entry() documenting this
layout property.  Improve a few log messages for clarity.

Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
---
 drivers/scsi/qla2xxx/qla_isr.c | 31 +++++++++++++++++++++++--------
 drivers/scsi/qla2xxx/qla_os.c  |  1 +
 2 files changed, 24 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 404dcb24b688..14b774f25b97 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -2359,6 +2359,22 @@ static void
 qla24xx_els_ct_entry(scsi_qla_host_t *v, struct req_que *req,
 		     void *pkt, int iocb_type)
 {
+	/*
+	 * els_sts_entry_24xx_ext (29xx) overlays els_sts_entry_24xx for every
+	 * field touched in this completion handler: comp_status (offset 8),
+	 * total_byte_count (32), error_subcode_1 (36), error_subcode_2 (40),
+	 * d_id[]/s_id[] (24..29), control_flags (30) all sit at byte-identical
+	 * offsets in both layouts (only vp_index/sof_type at offset 14-15 are
+	 * bit-packed differently, and that field is write-only on the issue
+	 * path -- we never read it here). All reads in this function are
+	 * therefore stride-agnostic and go through a single struct
+	 * els_sts_entry_24xx * view; the trailing reserved_4[] of the extended
+	 * layout is irrelevant on completion.
+	 *
+	 * Likewise els_entry_24xx_ext overlays els_entry_24xx through
+	 * control_flags (offset 30), so the SRB_ELS_CMD_HST_NOLOGIN ctl_flags
+	 * read below also goes through the 24xx view.
+	 */
 	struct sts_entry_24xx *sts24 = pkt;
 	struct els_sts_entry_24xx *ese = (struct els_sts_entry_24xx *)pkt;
 	const char func[] = "ELS_CT_IOCB";
@@ -2400,7 +2416,7 @@ qla24xx_els_ct_entry(scsi_qla_host_t *v, struct req_que *req,
 				(struct qla_bsg_auth_els_request *)bsg_job->request;
 
 			ql_dbg(ql_dbg_user, vha, 0x700f,
-			     "%s %s. portid=%02x%02x%02x status %x xchg %x bsg ptr %p\n",
+			     "%s %s complete portid=%02x%02x%02x status %x xchg %x bsg ptr %p\n",
 			     __func__, sc_to_str(p->e.sub_cmd),
 			     e->d_id[2], e->d_id[1], e->d_id[0],
 			     comp_status, p->e.extra_rx_xchg_address, bsg_job);
@@ -2461,14 +2477,15 @@ qla24xx_els_ct_entry(scsi_qla_host_t *v, struct req_que *req,
 		} else {
 			if (comp_status == CS_DATA_UNDERRUN) {
 				res =  DID_OK << 16;
-				els->u.els_plogi.len = cpu_to_le16(le32_to_cpu(
-					ese->total_byte_count));
+				els->u.els_plogi.len = cpu_to_le16(
+					le32_to_cpu(ese->total_byte_count));
 
 				if (sp->remap.remapped &&
 				    ((u8 *)sp->remap.rsp.buf)[0] == ELS_LS_ACC) {
 					ql_dbg(ql_dbg_user, vha, 0x503f,
 					    "%s IOCB Done LS_ACC %02x%02x%02x -> %02x%02x%02x",
-					    __func__, e->s_id[0], e->s_id[2], e->s_id[1],
+					    __func__,
+					    e->s_id[0], e->s_id[2], e->s_id[1],
 					    e->d_id[2], e->d_id[1], e->d_id[0]);
 					logit = 0;
 				}
@@ -2496,8 +2513,7 @@ qla24xx_els_ct_entry(scsi_qla_host_t *v, struct req_que *req,
 					ql_dbg(ql_dbg_user, vha, 0x503f,
 					    "subcode 1=0x%x subcode 2=0x%x bytes=0x%x %02x%02x%02x -> %02x%02x%02x\n",
 					    fw_status[1], fw_status[2],
-					    le32_to_cpu(((struct els_sts_entry_24xx *)
-						pkt)->total_byte_count),
+					    le32_to_cpu(ese->total_byte_count),
 					    e->s_id[0], e->s_id[2], e->s_id[1],
 					    e->d_id[2], e->d_id[1], e->d_id[0]);
 				}
@@ -2514,8 +2530,7 @@ qla24xx_els_ct_entry(scsi_qla_host_t *v, struct req_que *req,
 				ql_log(ql_log_info, vha, 0x503f,
 				    "subcode 1=0x%x subcode 2=0x%x bytes=0x%x %02x%02x%02x -> %02x%02x%02x\n",
 				    fw_status[1], fw_status[2],
-				    le32_to_cpu(((struct els_sts_entry_24xx *)
-				    pkt)->total_byte_count),
+				    le32_to_cpu(ese->total_byte_count),
 				    e->s_id[0], e->s_id[2], e->s_id[1],
 				    e->d_id[2], e->d_id[1], e->d_id[0]);
 			}
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 74bf203f8d9f..81f3731ee384 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -8386,6 +8386,7 @@ qla2x00_module_init(void)
 	BUILD_BUG_ON(sizeof(struct els_entry_24xx) != 64);
 	BUILD_BUG_ON(sizeof(struct els_entry_24xx_ext) != 128);
 	BUILD_BUG_ON(sizeof(struct els_sts_entry_24xx) != 64);
+	BUILD_BUG_ON(sizeof(struct els_sts_entry_24xx_ext) != 128);
 	BUILD_BUG_ON(sizeof(struct fxdisc_entry_fx00) != 64);
 	BUILD_BUG_ON(sizeof(struct imm_ntfy_from_isp) != 64);
 	BUILD_BUG_ON(sizeof(struct init_cb_24xx) != 128);
-- 
2.47.3

