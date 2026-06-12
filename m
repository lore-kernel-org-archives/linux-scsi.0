Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CD7436655C
	for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2026 09:56:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781258208; cv=none; b=diWT3QiH7L7Xt42tDg7OIEV4Hh/TplCyfxkZ37DsVeY8UlT6jmzWAOthi8jAPvPrE7PUl0CFTNNisWr3AG28DMfxHjtkybNSHsUuelY08v5tE2xPS55Q4OZ0ae5E7ycQV1htJD51Ufk7odye3reZjijPERYK4d5M/alAq8TKY1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781258208; c=relaxed/simple;
	bh=SPp9lcmCW2vfMIieA2igL9Ud6a2h3vHb8+xC2HyZrts=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AulBYVBvNJkpUnuE3Z7CyaAWdX7A6RlpgPDqm8Uklayf/D/ga88G/kOAmGBCyclRi3eJTTq0bik3MA5YuCVbxHhMaX1KC028gTyW04PKiPydIKsE8pePTjTaBef+EJHaE5rSMJPbb1VHCKEBwCiWDqnrgEomNnNyUODw+4+156E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=Mcbyt7iN; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="Mcbyt7iN"
Received: from pps.filterd (m0431383.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65C39sG93783292;
	Fri, 12 Jun 2026 02:56:44 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=K
	wzpy3MC1U5BMxdQlOpJcQJXTDf8PtQ8wkgyHFbkZP4=; b=Mcbyt7iN/dSZcuXS2
	dbv/WExiJKawFe+Ry9ALp9GPWTmbU77NTi1qmOo62Wf+g8M0eUau3fadliLylHtr
	QMoC4fwDofpoL7u41f8u08pgvV9g/peFDwyHa8ODAa7ntylGxevpcuy8uscKq7TV
	GSIDwuNiwWyLkhhknET3bdZQF8bshnHJjJeWEPcVnwwHo7PMYqeZdcbaXMjpFZ14
	TYOq3JXjqz84noJN4RrUrwuqnJTamfj+NorKvbwMDqSJtpEHfb4IBKbGgIXDlz6/
	97tNfBd11uqjmi5jbi7gqFw6AQxaDJUTynpjIlyBa2cHsCbPcRu0xFKooDAV9F8j
	im2Kw==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 4er6r2hjma-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 12 Jun 2026 02:56:44 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 12 Jun 2026 02:56:43 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Fri, 12 Jun 2026 02:56:43 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 08E0F3F7040;
	Fri, 12 Jun 2026 02:56:40 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v2 53/60] scsi: qla2xxx: Bound VP index against VP_CTRL IOCB bitmap size
Date: Fri, 12 Jun 2026 15:23:26 +0530
Message-ID: <20260612095333.1666592-54-njavali@marvell.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjEyMDA5MCBTYWx0ZWRfX5Zr0CkyQZ8pJ
 RYIzLA0s5FS4gD3RHEVX6g/dNmcZe1o/kAaYZhTTij0btCgE7inj7kUBxoDVq6kfDFVBKXfyayg
 2fp7GJkNyjo5jHs1C7A5uF6aLZWs7O083oBFRsunD0IVc6KBprgcQmspVwAnunZLSOyKbZh3DTm
 R2eZWYTLp5WxfmfMheGJvG7C3KxDSPWpN2h0b9cM81XO3gBhg0tHPWf3IbBudfuQs4HJRCye9lJ
 aXiT/fSYO1RB7yiBpw6wqs35dV+Y+60QXU9V3zuH/XKkloubYy1ugYB1g7TyAa2g0yS9fg6ULnK
 1kk5AjtCGdfu+1or1Iwf2h2cXeYPgHpHZmcWGpPOvP1V5HFv8AFRCLeSEWP62yyrbW2NWgSbdTY
 WUTFVszCXTgS1GZh1i4dBw0LE/V5GZ6HieQkaVwXldL6YgSNiVzQPmfd/TqES3ZNaOt8b2eamuj
 lO3SErN/ES3p42E5XMQ==
X-Authority-Analysis: v=2.4 cv=GoByPE1C c=1 sm=1 tr=0 ts=6a2bd7dc cx=c_pps
 a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=qit2iCtTFQkLgVSMPQTB:22 a=VwQbUJbxAAAA:8 a=M5GUcnROAAAA:8
 a=LmotS8iUCfLPSoeuQIgA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjEyMDA5MCBTYWx0ZWRfXzdi96XoNuHe8
 N84/2MyR4N9rjuYJKyMp9GUMbWNlVltvGO2jVP3qUix37MX1r0rC0lDxoP9t39WsgzNyIbC3v67
 lA060fxRT0szFBoGKJoEy3Z33E8cQcM=
X-Proofpoint-GUID: 0Jm61w0Uvw5jHl0JV1tdgmZRUBkdR8ch
X-Proofpoint-ORIG-GUID: 0Jm61w0Uvw5jHl0JV1tdgmZRUBkdR8ch
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-12_01,2026-06-11_01,2025-10-01_01

The VP control IOCB selects its target virtual port by setting one bit
in vp_idx_map, a fixed 16-byte (128-bit) array in both
vp_ctrl_entry_24xx and vp_ctrl_entry_24xx_ext. qla25xx_ctrlvp_iocb()
computes map = (vp_index - 1) / 8 and writes vce->vp_idx_map[map]
without checking that map stays within the array.

max_npiv_vports is taken from firmware and only sanitized to a
MIN_MULTI_ID_FABRIC-aligned boundary, so it can legitimately be 191 or
255, and qla24xx_control_vp() only rejects vp_index >= max_npiv_vports.
A vp_index above 128 therefore yields map >= 16 and an out-of-bounds
write of up to 16 bytes past vp_idx_map, corrupting the trailing IOCB
fields (or the adjacent request-ring slot on the 64-byte layout).

Reject a vp_index that cannot be represented in the IOCB bitmap in
qla24xx_control_vp(), and add a defensive ARRAY_SIZE() guard in
qla25xx_ctrlvp_iocb() before the write. Adapters that report the usual
63 or 127 NPIV vports are unaffected.

Fixes: 2853192e154b ("scsi: qla2xxx: Use IOCB path to submit Control VP MBX command")
Cc: stable@vger.kernel.org
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_iocb.c | 6 ++++++
 drivers/scsi/qla2xxx/qla_mid.c  | 8 ++++++++
 2 files changed, 14 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index a103be30fddb..8b5a13823b3d 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -4068,6 +4068,12 @@ qla25xx_ctrlvp_iocb(srb_t *sp, void *pkt)
 	vce->entry_count = 1;
 	vce->command = cpu_to_le16(sp->u.iocb_cmd.u.ctrlvp.cmd);
 	vce->vp_count = cpu_to_le16(1);
+	if (map >= ARRAY_SIZE(vce->vp_idx_map)) {
+		ql_log(ql_log_warn, sp->vha, 0x307c,
+		       "ctrlvp: vp_index %u exceeds vp_idx_map capacity\n",
+		       sp->u.iocb_cmd.u.ctrlvp.vp_index);
+		return;
+	}
 	vce->vp_idx_map[map] |= 1 << pos;
 }
 
diff --git a/drivers/scsi/qla2xxx/qla_mid.c b/drivers/scsi/qla2xxx/qla_mid.c
index 7072af5b4217..b7d9c1a53f3c 100644
--- a/drivers/scsi/qla2xxx/qla_mid.c
+++ b/drivers/scsi/qla2xxx/qla_mid.c
@@ -987,6 +987,14 @@ int qla24xx_control_vp(scsi_qla_host_t *vha, int cmd)
 	if (vp_index == 0 || vp_index >= ha->max_npiv_vports)
 		return QLA_PARAMETER_ERROR;
 
+	/*
+	 * The VP_CTRL IOCB selects the target VP through a fixed 128-bit
+	 * (16-byte) vp_idx_map bitmap, so vp_index must fit within it even
+	 * if firmware advertises more NPIV vports.
+	 */
+	if (vp_index > sizeof_field(struct vp_ctrl_entry_24xx, vp_idx_map) * 8)
+		return QLA_PARAMETER_ERROR;
+
 	/* ref: INIT */
 	sp = qla2x00_get_sp(base_vha, NULL, GFP_KERNEL);
 	if (!sp)
-- 
2.47.3

