Received: from mx0a-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B486D258CE5
	for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2026 09:54:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781258073; cv=none; b=RdxFkM6jrciHhJWyymnFqJW9GGJ0jrvjqfCCf9aj5mcILI+FaihX3mUKv3omnJSm9ySWnPNZ928/YRGPj5SNsbim3oulrkkHCjwYVNzWwimF7IEYdXgdSLHAL+BEx+AVs2Du4xEltd2Kv63RgQWZ/XxBkgMqwyBdBL+vnu1XlUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781258073; c=relaxed/simple;
	bh=tnHAmd3kqls6qI4tRGKyKyrx5bzm5HsdMzO0GSeBP2w=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kwhKdzX4lJbUNIfsV9UA8kHylz5rNsPX85pVTMfcOiytr92EFdJKCBEhKUt4LL8M/I6h0hz9s4eP13JsnQLFtXsNk0qitCqcL4Yl60HBXfM4vXb6MTpR7e8QvBvnYReprMbDpVmfnTWgB4c2RSdL+dUn2pRSk5tY6N9r2KGYPNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=QVpLK1j2; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="QVpLK1j2"
Received: from pps.filterd (m0431384.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65C38x5R3678669;
	Fri, 12 Jun 2026 02:54:29 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=k
	hBfTrV2jsoXocD4jDTGQDy6DRGQNdh8NmrHIFzn2PM=; b=QVpLK1j2/LreMMnQs
	sWHt+QcS1sMATK705HZwzXwvseVLhCxXkks/vrUWLtTDp3itMiBIjZSy5Y8RSrEx
	Jj9fUOhcBnYAmh8OqUvOjVEyf5pQfjwUVN10Esjo3FVTvFeTdPHzySXjkbkbpLhp
	RyorGBOc1GadcaN8prfXOt7Oud0KICUai6JZ9TESHQC4Hr+z3S+5eQDdWzBerD4k
	Gl//RQWOV7LRfNldaUoteMX4N9+WJwnkLqZ0uwykGkLHzAnx/gmG3IVyPFsrfeeT
	HDIN2Tg75COquO2BLfaNZVeH4szEBtuAokzXPad5yKIzec5m/0+KRH20PYnGhsCm
	5/VjQ==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 4er9qn92ge-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 12 Jun 2026 02:54:29 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 12 Jun 2026 02:54:28 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Fri, 12 Jun 2026 02:54:28 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 3E0933F7040;
	Fri, 12 Jun 2026 02:54:25 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v2 11/60] scsi: qla2xxx: Remove duplicate flash memo block definitions
Date: Fri, 12 Jun 2026 15:22:44 +0530
Message-ID: <20260612095333.1666592-12-njavali@marvell.com>
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
X-Proofpoint-ORIG-GUID: HT3yiSnACr7n0TlvBNl1qayl6XKN9Z7w
X-Authority-Analysis: v=2.4 cv=Y9HIdBeN c=1 sm=1 tr=0 ts=6a2bd755 cx=c_pps
 a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=TtqV-g6YmW1Jfm2GSLaY:22 a=M5GUcnROAAAA:8 a=kL93aq-EMttsvyrpbMAA:9
 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjEyMDA4OSBTYWx0ZWRfXz6UFd2lFN9VX
 Btqxs5tyljEWEPlCyQuhAbMRP6jiwvMV9gXF9fUjG/reZudU7dXhNHbWcJRv4LvVQVSOUCKcSTa
 mMlnDZncluZNhqaQjMHmXGqQAYb2pKQ=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjEyMDA4OSBTYWx0ZWRfX3Y6WHGowm7tD
 d73+QsxbxbHosLDt2n0ptBpX6WjFONmdnc4+Ae0jq3o2PnTV4CpmzKrz7u/TesXx6QbRemz1ybl
 6nI53BNp7nk+zx6gxRofjVmOh2NZ4nDRbj3m1U6kePXEvO6Txf4qR7jyr495St32oj6g5FSdfvt
 O43wFHykbTCC55qgHuSX3VCc6hFUc8pEdw7+abOqM+MIRpIW5nKgEe55ooj1IXKSeHoFb3CIWIb
 EwBF698kv/z3FCA0mBwQOR8vW4x8vnqFxtr78ZhVl3GgAJZ9gh6OsGo1cO/tsmhj4yCrBaEaBKU
 tAMycsg1u9Pidr4g4+3i/NyaLkRXrMuDKTy1DRoVpTe5hXxdrbzfUL3DQ1rzgFVZeTSFV8MpZrX
 c3UqOtHa0QWTBefPnZWvk7aeqF9FMVfWVGXM4H2RhNHeKymkD401Mm/BtsyZUmRZNQyuV5Bwlr1
 yXFXB0LNfPj95z01W+A==
X-Proofpoint-GUID: HT3yiSnACr7n0TlvBNl1qayl6XKN9Z7w
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-12_01,2026-06-11_01,2025-10-01_01

From: Anil Gurumurthy <agurumurthy@marvell.com>

The qla_flash_memo_block and related structures in qla_fw29.h
duplicate definitions already present elsewhere.  Remove the
duplicates to avoid divergence and build warnings.

Signed-off-by: Anil Gurumurthy <agurumurthy@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_fw29.h | 39 ---------------------------------
 1 file changed, 39 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_fw29.h b/drivers/scsi/qla2xxx/qla_fw29.h
index e294b3f033db..efe1c60bee81 100644
--- a/drivers/scsi/qla2xxx/qla_fw29.h
+++ b/drivers/scsi/qla2xxx/qla_fw29.h
@@ -683,43 +683,4 @@ struct vp_rpt_id_entry_24xx_ext {
 		} f2;
 	} u;
 };
-
-struct qla_fmb_version {
-	uint8_t major;
-	uint8_t minor;
-	uint8_t sub;
-	uint8_t build;
-};
-
-struct qla_fmb_upd_time {
-	uint16_t year;
-	uint8_t  month;
-	uint8_t  day;
-
-	uint8_t  hour;
-	uint8_t  minute;
-	uint8_t  second;
-	uint8_t  reserved;
-};
-
-struct qla_flash_memo_block {
-	int32_t  signature;	/* "FMBS" */
-#define QLFC_FMB_SIG 0x464D4253
-	uint32_t length;
-	uint32_t version;
-#define QLFC_FMB_VERSION 3
-	uint32_t checksum;
-	struct qla_fmb_version ffv_ver;
-	struct qla_fmb_version mbi_ver;
-	struct  {    /* offset 0x18: MBI package build time: YYYYMMDD */
-		uint16_t year;
-		uint8_t  month;
-		uint8_t  day;
-		uint8_t  reserve[4];
-	} bld_time;
-	uint8_t tool_id[4];
-	struct qla_fmb_upd_time upd_time;	/* offset 0x24: flash update time stamp */
-	struct qla_fmb_version  tool_version;	/* offset 0x2C: FW/tool version */
-};
-
 #endif
-- 
2.47.3

