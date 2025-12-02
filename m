Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB5D52FBDED
	for <linux-scsi@vger.kernel.org>; Tue,  2 Dec 2025 05:45:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764654346; cv=none; b=Fn0fffdXpjnNYMyTxOLDzJFhl54/BdZmYJqIdQeWMP6rO0/paeu8ykc2WY9krOHflt2RICtWMCHoMPM3jUCXrMES/fbeO9HKdsYPMAvl2OOQMP90ghTJG9cMK8bo1szgfx+6j1QR5Ze/mlML+BanO95cbGMCEciZDMo1Fmm81q4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764654346; c=relaxed/simple;
	bh=e1t/xMGeR1muNuW5iYHLbvWXCXV8RMRqASLwtN8K3d0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=t9Iw9FhJh30WwfTL09KO/lpZy3F11/ekj0qfT1J7HI4y6WXLr37Vs///NV0pB54hcRFCIIM6vuvrjoFCbIkQYlxnpU4hX4E47M6u0DY3n8OKPoHTzRTXBiJ3srWdb4dNwtd/OE/rX5YjYXP13JYRyxPhRp6eqT2OKng/dOYkHOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=fLW68ubn; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="fLW68ubn"
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5B23NhnM1371971;
	Mon, 1 Dec 2025 21:45:35 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=G
	TNHoZIegU5II83AyXjfVTHly5mtyACRNydczEJEu48=; b=fLW68ubnP82p5Ji6I
	NN6jtxej/w6u+zzViwMEHgtdoZPovH2RLcq/lwKFM2rUOTlZb+iBT+KQubBHUOtv
	M2Tu6k2ILEhTeOesoZq48bfI4NtKyDjcz5GBf/qYF9DAddrgg1XSHsNxAzAeTe9u
	WGSP1ziG9UsK3YmXGOHuHv5TzdeLrzVl8Tc0r3WvK4rJM5RRybNyVpHLyL6Qwssc
	zia+11xE+QEa/zDvkvdn3D85aU9xwXtSul6ucP9G8rHx67LOAh2BUd7S50PwPswB
	bE9wXVeHB6vrjudbpD+TxSRwEriOrm4HzeNUa3aj5ACPZin5CNHLbdcyV5bFh6Z6
	fHI9w==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 4ar17nn80j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 01 Dec 2025 21:45:35 -0800 (PST)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 1 Dec 2025 21:45:48 -0800
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Mon, 1 Dec 2025 21:45:47 -0800
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 0D0765B6978;
	Mon,  1 Dec 2025 21:45:31 -0800 (PST)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-QLogic-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <sdeodhar@marvell.com>, <emilne@redhat.com>,
        <jmeneghi@redhat.com>
Subject: [PATCH 02/12] qla2xxx: Add support for 64G SFP speed
Date: Tue, 2 Dec 2025 11:14:34 +0530
Message-ID: <20251202054444.1711778-3-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20251202054444.1711778-1-njavali@marvell.com>
References: <20251202054444.1711778-1-njavali@marvell.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: 7KPU_kskF4DvCQsnjWXIUEQiv_BgHjJp
X-Authority-Analysis: v=2.4 cv=R+MO2NRX c=1 sm=1 tr=0 ts=692e7cff cx=c_pps
 a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17
 a=wP3pNCr1ah4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=M5GUcnROAAAA:8
 a=keNGaN2H7ZI07Q4sIjEA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-ORIG-GUID: 7KPU_kskF4DvCQsnjWXIUEQiv_BgHjJp
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjAyMDA0MyBTYWx0ZWRfXyXj/igRLa1XM
 QMbYWosC1e+LAgGZsmppSkXZM7oREEExIVynNlapk8UW4bCSWFuPi3friUZaYMNJacAHZEmaGnc
 k1n3SooQaMXZMwQJ0cFT0RZXbR/w76dgjuuDwYp1d3VWbPpF1PNS+QdtceuaDkCaSL09p5S+dfF
 PBSgaS8gkFhrWKCXhGDekmYWE3TxC1KHpKkWtNd/xXi1uGHWEoQeyPCSQoiiZr+lQhVsINqs/Nd
 EP2mK5TnAUrotG2t+aw7TMNm4GXlboZjuiIMaA4YiqSRkzi0Cqk7QL9X64jEXkhIHPyOJXkomtb
 Ro3MJpTeIHEgeUgx9wyhgyv01FUVaPCpxolSyCmAA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-28_08,2025-11-27_02,2025-10-01_01

From: Manish Rangankar <mrangankar@marvell.com>

Incorrect speed info is shown in driver logs for 64G SFP.
Add support for 64G SFP speed as per SFF-8472 specification.

Signed-off-by: Manish Rangankar <mrangankar@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
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

