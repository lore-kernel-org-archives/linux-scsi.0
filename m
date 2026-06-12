Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACFBE258CE5
	for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2026 09:55:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781258144; cv=none; b=Xb9iy3zHIVu3DJxdwHg7CeeQvvl2WYvJkhXmbSCMeaug9ps1dBNnqksnbT6Tt7Nzw0wAb9JORqLUKZoymcyJehBZBeNYESw4EGQ0sfBoFAaFVkDE1p/93r6inFUZ5zGsjmjnd/4cA1lrN1Xos7f2kbwKldfLdpF7iLMzIdohts8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781258144; c=relaxed/simple;
	bh=3+67VCR2V1jAI8b9Y9vhS+8RhaVu0Aiwm+Sj9zC71mk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VnXnOI7Li5CSjZ1Yf4BQbfoAXl2xoZqRIeCbjIOzIIz0wD4TEcrM3+5twxsCYXWxX19ALDmphbdVdR4VUlsoBZk79OTvwzwVv650+LEAWe93gppNHDXxT5w5DunZnglHHse/2EGd8S4z7vsmxZVHN99Wvhh3cP7EuDkjRh8v0E8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=K47zBUrc; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="K47zBUrc"
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65C3AaKg071283;
	Fri, 12 Jun 2026 02:55:40 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=q
	OEA7hWu5GJFGHhMcei6fegCWmTxKiRwNxy3JhSlkak=; b=K47zBUrc/vUCSYvZZ
	T9vgXpoeO3Palr13XwrGKuISOkmWVJ1eEkBc35ZoCiQcLP75Gkdh+l12otHqB7f5
	14hR4EzRe7o6HsB2f0ZZCJ/GYwZPd1WLojbCCmnqW/GZRlM+9wQwGWi8F9NxYeLe
	/RXzBOPE+lEau0WdcPkCnClBoSUNPDtcrgNvLQ9hVCyWMMAW3zYwbhyjUktKI2FZ
	GEDNcByh9uUpIl6pN5jKgnlXGMhXD8D6sSKprzdk9RxuZN/vw0TcsGTkvDhuctLS
	jrYj12YTRBYPYarSPq2fgJbvKOFMuOaeFQvaddTe6E/pKCRG+EQhwV+B9A0dzEsp
	DBvKA==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 4eqe5vxrp7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 12 Jun 2026 02:55:39 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 12 Jun 2026 02:55:38 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Fri, 12 Jun 2026 02:55:38 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 1A4A43F7040;
	Fri, 12 Jun 2026 02:55:35 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v2 33/60] scsi: qla2xxx: Add size check for ELS status entry layout on 29xx
Date: Fri, 12 Jun 2026 15:23:06 +0530
Message-ID: <20260612095333.1666592-34-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20260612095333.1666592-1-njavali@marvell.com>
References: <20260612095333.1666592-1-njavali@marvell.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjEyMDA4OSBTYWx0ZWRfXz1Ha3Kzp4nkx
 /msip9UZS1LYEwUpmyPk2poQOwmywMUwZ8rCR5ynfpAiVQ4tfNyfeZ588t7G9J5w5ndHTLCLS1w
 fO9eHVjjdg6s3DvZnKtgQ5EiQR1PBKo=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjEyMDA4OSBTYWx0ZWRfX0/3LMIeNRfwD
 1/M0K4Q+Lbk8TgDRUYBVBL3iHP4ko9CupID9Uhhsjyv6QJuAGpazp8OV2Ggjl3biEsAGSq9aTRW
 oETbkvUKlfWvoE2/0e75YYYKgZ2IHn/wdZ2joOgCu+SlJ1Uc/NMq1tOOZAxdldColIST07CW0k8
 hASEsD2bO0TOGnojptuTuzqx9SiUhzMk5qDFTmxa5JZSq4MYWRVZc//JLHTPhjQYzXjpTuqS8wp
 PPjD4rTfrKKFVZzZ+v8pLywlukOpbqWDYMudgLnYPuNwPtAvc4M9qZiTcT5RL6uSNBzoG4+a0Mm
 Q6BOSRKv8uF6rX1yEAZu2Totf1Ln271yhqnAGGMv19NKzL0wEoogUKEeP6sYVQtMGuVtaf1Yuwd
 /Z2ZEvUsj70+3wfXqE2/a3SZUAc0F+hwmtkslBqqF/oU/Q4jzb4f8HvBw3wWphDMg70JbxaSSDN
 qwe6MLqLBcl8yrc+glg==
X-Authority-Analysis: v=2.4 cv=UPDt2ify c=1 sm=1 tr=0 ts=6a2bd79b cx=c_pps
 a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=EAYMVhzMl8SCOHhVQcBL:22 a=M5GUcnROAAAA:8 a=usBOGR8KzlEXNHoOUIAA:9
 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-ORIG-GUID: swqcDnnB7gUhgVpNepk0kPHckW2mP6dV
X-Proofpoint-GUID: swqcDnnB7gUhgVpNepk0kPHckW2mP6dV
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-12_01,2026-06-11_01,2025-10-01_01

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
---
 drivers/scsi/qla2xxx/qla_isr.c | 31 +++++++++++++++++++++++--------
 drivers/scsi/qla2xxx/qla_os.c  |  1 +
 2 files changed, 24 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 6ee16ee644d4..173b37b03d61 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -2411,6 +2411,22 @@ static void
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
@@ -2452,7 +2468,7 @@ qla24xx_els_ct_entry(scsi_qla_host_t *v, struct req_que *req,
 				(struct qla_bsg_auth_els_request *)bsg_job->request;
 
 			ql_dbg(ql_dbg_user, vha, 0x700f,
-			     "%s %s. portid=%02x%02x%02x status %x xchg %x bsg ptr %p\n",
+			     "%s %s complete portid=%02x%02x%02x status %x xchg %x bsg ptr %p\n",
 			     __func__, sc_to_str(p->e.sub_cmd),
 			     e->d_id[2], e->d_id[1], e->d_id[0],
 			     comp_status, p->e.extra_rx_xchg_address, bsg_job);
@@ -2513,14 +2529,15 @@ qla24xx_els_ct_entry(scsi_qla_host_t *v, struct req_que *req,
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
@@ -2548,8 +2565,7 @@ qla24xx_els_ct_entry(scsi_qla_host_t *v, struct req_que *req,
 					ql_dbg(ql_dbg_user, vha, 0x503f,
 					    "subcode 1=0x%x subcode 2=0x%x bytes=0x%x %02x%02x%02x -> %02x%02x%02x\n",
 					    fw_status[1], fw_status[2],
-					    le32_to_cpu(((struct els_sts_entry_24xx *)
-						pkt)->total_byte_count),
+					    le32_to_cpu(ese->total_byte_count),
 					    e->s_id[0], e->s_id[2], e->s_id[1],
 					    e->d_id[2], e->d_id[1], e->d_id[0]);
 				}
@@ -2566,8 +2582,7 @@ qla24xx_els_ct_entry(scsi_qla_host_t *v, struct req_que *req,
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
index d748be56c0be..6ce29157a72c 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -8385,6 +8385,7 @@ qla2x00_module_init(void)
 	BUILD_BUG_ON(sizeof(struct els_entry_24xx) != 64);
 	BUILD_BUG_ON(sizeof(struct els_entry_24xx_ext) != 128);
 	BUILD_BUG_ON(sizeof(struct els_sts_entry_24xx) != 64);
+	BUILD_BUG_ON(sizeof(struct els_sts_entry_24xx_ext) != 128);
 	BUILD_BUG_ON(sizeof(struct fxdisc_entry_fx00) != 64);
 	BUILD_BUG_ON(sizeof(struct imm_ntfy_from_isp) != 64);
 	BUILD_BUG_ON(sizeof(struct init_cb_24xx) != 128);
-- 
2.47.3

