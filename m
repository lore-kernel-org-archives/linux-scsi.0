Received: from mx0a-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7A7030C353
	for <linux-scsi@vger.kernel.org>; Wed, 10 Dec 2025 10:16:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765361794; cv=none; b=WZ6YFH1Zl7rPzeyNP6RBYB9TEQyiO5LGNuqWYMv6ZrO/rizsAQ/khzuKkSRoaNc8ucHtTdUUMbrL2vHNoTIE8CV4hdgVjGaTzL6y3S7ehgvoubUBUNd3hdH0V/HTFFle93SN0nv4fx194ckkEyD1Xq3aNw/uJn32wsWrUMP1d4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765361794; c=relaxed/simple;
	bh=WjF5UFnCdBXQqr5wdTcZfz0KIQYiGxadexBrhh6Nf58=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Xuu0R/LxU1CyhjK3J/dqwD6+HpUnkrpbKX/JzkvSc4ouC5iSnTONGM5BKrcOBSk57GP/3nUBOXzWpXgtzWv90+AHkerDa0/PmDQCEEtkLylkiTL1CFCtS/YXwCp886ko0/M2+dbH5OsPuoHvoDNVMbETfO9CQcm5WLxVJE797w0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=fail smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=IIWINkw1; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="IIWINkw1"
Received: from pps.filterd (m0431384.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BA4agL13664270;
	Wed, 10 Dec 2025 02:16:24 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=+
	Sr2KdeUAbko6nRU6FhmG9am7DNxSZguNPh3fMoR/w8=; b=IIWINkw1WJrnlTLC0
	nwPzlc+DA7xZca90p2k6JIsC+7wg1kiggUWb9L00c7At6mZdGNlp5JCze/OmewgU
	F+lmyvfjsU3hVK+9zDulP58/KyrBOVsbbKbVvgtHPugvxVGwbRjWo91E2c0sqP8v
	op06vyY5V7CoSGB8fvikRTRP9zNL7W5oBh+I1ti9OccAfxkXnXSFU1gvc1M9Fna4
	07ukkZNjH7AA6gHkVBJbahYOHvLhEEtSHCJC4s/dfhWId9lxH47+HldeXrpEh0dJ
	D4Y4jQVTtpF5DVfTW4jnVqhG0dG5dDOTsCjU6wgHcTyV4FUDnbm0zU4QWm7ZB9Wc
	BIMfQ==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 4ax8ckg5y7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 10 Dec 2025 02:16:24 -0800 (PST)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 10 Dec 2025 02:16:36 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Wed, 10 Dec 2025 02:16:36 -0800
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 546F23F709D;
	Wed, 10 Dec 2025 02:16:21 -0800 (PST)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-QLogic-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <sdeodhar@marvell.com>, <emilne@redhat.com>,
        <jmeneghi@redhat.com>
Subject: [PATCH v3 02/12] qla2xxx: Add support for 64G SFP speed
Date: Wed, 10 Dec 2025 15:45:54 +0530
Message-ID: <20251210101604.431868-3-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20251210101604.431868-1-njavali@marvell.com>
References: <20251210101604.431868-1-njavali@marvell.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Authority-Analysis: v=2.4 cv=W8c1lBWk c=1 sm=1 tr=0 ts=69394878 cx=c_pps
 a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17
 a=wP3pNCr1ah4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=M5GUcnROAAAA:8 a=pGLkceISAAAA:8
 a=keNGaN2H7ZI07Q4sIjEA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjEwMDA4NSBTYWx0ZWRfXzcWnAsf3KKei
 Ee8MMcmnv+WZuMffIVEquRzAWsrXJh0OioZhPjhc8IfyIfLZnf0PxSoaw/qTeOkUbYGY+f6En6w
 P6Y0xLOGFUDnQjqwt+4CqUHVTJoPsB04FMhONsUw3MXaetGrXs3uqozwDrskP5zVqEQboUwLyf0
 0V3feTLJcOih9UZfPUw1n2ZxQ9G9naNtDuF8M+5dumpm16AGpd2REtisdUBSP9kXaWJQRbMAuTm
 Vg243Wm8XrF3KVfsqpi9AVF4iZqIKJ6FnMg92B7+nxe7MsWg8bFv0JREth8p9ABXJcmOx+Y7ql6
 eHmqNYsaaI4S4TaUlSHxyYbp++/Vi1lYsQnnw29Qw2+GQ4g8k3hcc/oh2NeXJr+lrjLQgzuYLUT
 3u0Gjl0jQPv2gVtsM8cqgxaLgHiliQ==
X-Proofpoint-ORIG-GUID: g9QC0HPIZ0PaUrgIV6jqAQPIJAbe9nzS
X-Proofpoint-GUID: g9QC0HPIZ0PaUrgIV6jqAQPIJAbe9nzS
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-09_05,2025-12-09_03,2025-10-01_01

From: Manish Rangankar <mrangankar@marvell.com>

Incorrect speed info is shown in driver logs for 64G SFP.
Add support for 64G SFP speed as per SFF-8472 specification.

Signed-off-by: Manish Rangankar <mrangankar@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Himanshu Madhani <hmadhani2024@gmail.com>
---
 drivers/scsi/qla2xxx/qla_def.h  | 6 ++++--
 drivers/scsi/qla2xxx/qla_init.c | 4 +++-
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index cb95b7b12051..34c6e3f06a5b 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -5369,7 +5369,7 @@ struct edif_sa_index_entry {
 	struct list_head next;
 };
 
-/* Refer to SNIA SFF 8247 */
+/* Refer to SNIA SFF 8472 */
 struct sff_8247_a0 {
 	u8 txid;	/* transceiver id */
 	u8 ext_txid;
@@ -5413,6 +5413,7 @@ struct sff_8247_a0 {
 #define FC_SP_32 BIT_3
 #define FC_SP_2  BIT_2
 #define FC_SP_1  BIT_0
+#define FC_SPEED_2	BIT_1
 	u8 fc_sp_cc10;
 	u8 encode;
 	u8 bitrate;
@@ -5431,7 +5432,8 @@ struct sff_8247_a0 {
 	u8 vendor_pn[SFF_PART_NAME_LEN];	/* part number */
 	u8 vendor_rev[4];
 	u8 wavelength[2];
-	u8 resv;
+#define FC_SP_64	BIT_0
+	u8 fiber_channel_speed2;
 	u8 cc_base;
 	u8 options[2];	/* offset 64 */
 	u8 br_max;
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 66eeee84be05..b83029b55a05 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -4075,9 +4075,11 @@ static void qla2xxx_print_sfp_info(struct scsi_qla_host *vha)
 	int leftover, len;
 
 	ql_dbg(ql_dbg_init, vha, 0x015a,
-	    "SFP: %.*s -> %.*s ->%s%s%s%s%s%s\n",
+	    "SFP: %.*s -> %.*s ->%s%s%s%s%s%s%s\n",
 	    (int)sizeof(a0->vendor_name), a0->vendor_name,
 	    (int)sizeof(a0->vendor_pn), a0->vendor_pn,
+	    a0->fc_sp_cc10 & FC_SP_2 ? a0->fiber_channel_speed2  &  FC_SP_64 ?
+					" 64G" : "" : "",
 	    a0->fc_sp_cc10 & FC_SP_32 ? " 32G" : "",
 	    a0->fc_sp_cc10 & FC_SP_16 ? " 16G" : "",
 	    a0->fc_sp_cc10 & FC_SP_8  ?  " 8G" : "",
-- 
2.23.1

