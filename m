Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4888314F70
	for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2026 05:06:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784783180; cv=none; b=ONqXNirjCusBocdv56tpGHN4hNjY2/h0Ev9K0TTZKOTtSmIIGswikCIWhKFNPuR44l8kKp5VkogaaftKzX3ABt+QcNPdH73X/O+5PFxeFZ87QQJiJ1Dm5iVeyrFb1UEnkvdQGHj+80evR9MPpiFiSKp28ufI38RxYQfX6vJzn/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784783180; c=relaxed/simple;
	bh=eB9WP/wZa7W8e7GsWn57ny0lFbXTYL8w9EeakWCn+BA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iM9MHEedGDS9QUfPi/zOup7zVa9SlZnmmQ4NHyQ2h925qgee/qWdCnhmSLbAsa7dCwigvmU2AYeoSqSnj1+KTsnh+uzQJgUkvKuxF3HWgkFfO2peOrpDLxUE2RTm/mhzshpbqSBx9vFBOo0fxo8mOr9y/mLJf6wel3FRj/fthC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=jwREqYzW; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="jwREqYzW"
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66N4vlkG2441570;
	Wed, 22 Jul 2026 22:06:15 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=s
	fLoo/z9F6OeKGMx+MoQlIdc+XDzT5UUKELEdGDxIuI=; b=jwREqYzWvU0++2rJz
	tfBG/gbhNO8EA/OGtqP/f3Sf+jXwYiZzVDiogGZCRw2sKuQj2kbaCCGvZfCSHVDT
	1Na6VSK3eHU4YWgAxE9/QtDLIKVdKsJ1AMTalDI+Xr8H+2Z1mbPiubzhLQe0KXlZ
	mfxOsrEmvzKyC6SJMv5NOvjBerW+BZ+zpzaE9s9gXLuc/O5OkEvQXd1yk4BTvNIW
	oY7GbguoZKDFQdRHx4edNcn9PoICTmFC5aMJgCM+1JSIUqPnr69y5YZXwix1Xdb1
	kegRBKwn0NzdAAVIyRfctCQs82Gt2q4fuN+macwy4JXFJ2knt4yo1dJ6yd5yFmkY
	nhj2A==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 4fk7jkrm2x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 22 Jul 2026 22:06:14 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 22 Jul 2026 22:06:13 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Wed, 22 Jul 2026 22:06:13 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 11AE15C68E6;
	Wed, 22 Jul 2026 22:06:10 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v6 36/56] scsi: qla2xxx: Add build-time size check for VP config IOCB layout
Date: Thu, 23 Jul 2026 10:33:53 +0530
Message-ID: <20260723050413.3897522-37-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20260723050413.3897522-1-njavali@marvell.com>
References: <20260723050413.3897522-1-njavali@marvell.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIzMDA0OSBTYWx0ZWRfX+UObBj/Jsj1w
 6QzEZ+IkfEcYcvMSjd0GBdyr8CafUbsbIyx99MdbLXvvbIFrN8ksZQP6rPPpIv2wwUerTd+agGr
 zsLIOCctnN6LOjfZaR54vA4FFThOxynUkq5rsRIxcur9AIy7wEPM4/og+bCWO3CQ8Q9YFpE+0Gs
 biM2FqzaxyW3yrs44KKuSOsXYpm4QUuMV6Myog3CZGFybIF+emh5TpXtaUDBRfyeNWPpkQ/Ealn
 hhpsMc0cZvGZAcSgGU+uXu9YCdfKiFAeHXLYsfQ2r0JxS7n8cYkP/MXR0ThIlikKo5mQpjLggz2
 DUdMmNqR+vvief9JSPO33/hOJ2PiYjfVAQd113AehfdtWsB5tYwj5kANeL4AVE8fNV9s6aLxVvm
 bTgbojVJnb3y2KT1jCCy9IOw9W+2jhP02s53cLoFEHzAe4W5734bgw8brkuo9hBR3pQr/haex5O
 WI84+X+ohFTqCzTOiaw==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIzMDA0OSBTYWx0ZWRfX3CSdmLccu8xN
 gWkzw/qix7818Q+w1i7N7xfliQRBIrHVzd519jKSULbpqIkLkmDtaLLe9K73fDoXFMTr36wWT0+
 GBF6+Sg4vydYR7nupWgK8yRkisOCty8=
X-Proofpoint-GUID: _qlbCtlxRDQUyAdRcrNH-Jck3mOvmKio
X-Proofpoint-ORIG-GUID: _qlbCtlxRDQUyAdRcrNH-Jck3mOvmKio
X-Authority-Analysis: v=2.4 cv=Zrzd7d7G c=1 sm=1 tr=0 ts=6a61a146 cx=c_pps
 a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=EAYMVhzMl8SCOHhVQcBL:22 a=M5GUcnROAAAA:8 a=VwQbUJbxAAAA:8
 a=QdJASnsuDdI3Qm7nM90A:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-23_02,2026-07-22_02,2025-10-01_01

Add a BUILD_BUG_ON for struct vp_config_entry_24xx_ext to verify its
128-byte size at compile time alongside the existing 64-byte check for
struct vp_config_entry_24xx.

Document in qla24xx_modify_vp_config() that the ext variant overlays
the base 24xx layout for the first 64 bytes (all fields this helper
reads and writes), so the IOCB can be built through a single struct
vp_config_entry_24xx pointer regardless of the adapter's IOCB stride.

Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
---
 drivers/scsi/qla2xxx/qla_mbx.c | 8 +++++++-
 drivers/scsi/qla2xxx/qla_os.c  | 1 +
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 0d7aa6fce007..3ebda35dd584 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -4364,6 +4364,13 @@ qla24xx_modify_vp_config(scsi_qla_host_t *vha)
 		return QLA_MEMORY_ALLOC_FAILED;
 	}
 
+	/*
+	 * vp_config_entry_24xx_ext overlays vp_config_entry_24xx for the
+	 * full 64-byte 24xx layout (the ext variant merely appends fields
+	 * at offset 64+ which this helper never touches), so the IOCB is
+	 * built and inspected through a single struct vp_config_entry_24xx
+	 * pointer regardless of adapter stride.
+	 */
 	vpmod->entry_type = VP_CONFIG_IOCB_TYPE;
 	vpmod->entry_count = 1;
 	vpmod->command = VCT_COMMAND_MOD_ENABLE_VPS;
@@ -4392,7 +4399,6 @@ qla24xx_modify_vp_config(scsi_qla_host_t *vha)
 		    le16_to_cpu(vpmod->comp_status));
 		rval = QLA_FUNCTION_FAILED;
 	} else {
-		/* EMPTY */
 		ql_dbg(ql_dbg_mbx + ql_dbg_verbose, vha, 0x10c0,
 		    "Done %s.\n", __func__);
 		fc_vport_set_state(vha->fc_vport, FC_VPORT_INITIALIZING);
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index ad070c0bf7db..8e5d49abead4 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -8436,6 +8436,7 @@ qla2x00_module_init(void)
 	BUILD_BUG_ON(sizeof(struct verify_chip_rsp_84xx) != 52);
 	BUILD_BUG_ON(sizeof(struct vf_evfp_entry_24xx) != 56);
 	BUILD_BUG_ON(sizeof(struct vp_config_entry_24xx) != 64);
+	BUILD_BUG_ON(sizeof(struct vp_config_entry_24xx_ext) != 128);
 	BUILD_BUG_ON(sizeof(struct vp_ctrl_entry_24xx) != 64);
 	BUILD_BUG_ON(sizeof(struct vp_ctrl_entry_24xx_ext) != 128);
 	BUILD_BUG_ON(sizeof(struct vp_rpt_id_entry_24xx) != 64);
-- 
2.47.3

