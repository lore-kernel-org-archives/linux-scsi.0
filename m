Received: from mx0a-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF29A202C48
	for <linux-scsi@vger.kernel.org>; Tue,  7 Jul 2026 05:56:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783403810; cv=none; b=bynafHS5Hdl/qKg3kbYUKuuJ9CE2iTGt/flaJewVDMU3WmUAq0mStT8mS6gFfauXkOLlLtb/ZoklInMWTt48w3NzCTizBqjS+KMjVTm7TFbZoWmuuzPj9M7ocdOMUIWuEArzrprSqSa/HZm9SKUdjgEUbp3MhDFuczoqEgRuEu0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783403810; c=relaxed/simple;
	bh=eB9WP/wZa7W8e7GsWn57ny0lFbXTYL8w9EeakWCn+BA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EU1W+4ruQ7i/t2CKyYIIj9zzdtChV8KXo+cnadxQpRwWxaX1qtJR+2TGUDlBtLF1eVphmsDn0AJDaLBHAGkTfKjN+h2T/pDHMYg5aNIPlouTNcVjZsB0IymOEE7v9ktfti01zRFeKEZX4OykY7erOaWQr1HR7kyIjgvtabB4VJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=TcQrvPxi; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="TcQrvPxi"
Received: from pps.filterd (m0431384.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66747doN854287;
	Mon, 6 Jul 2026 22:56:45 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=s
	fLoo/z9F6OeKGMx+MoQlIdc+XDzT5UUKELEdGDxIuI=; b=TcQrvPxiJJUglo66j
	po26U2fVb9oP4qnrWxkwRz/dxrgycl8BpRuxRxMs8912o8ENkt48awluZ0Pfo3gF
	Q5MjBaXYF1zS6tRBQZXGgjdGPQZ7Is4CPSshv6qqIYBFjcGZR9jLdlYm3TSHZl2Z
	Q0eEPY7+3WQplQtMLqqhDqZZhls7mVq0MEm9nxbmFubqkPJ7JeZ8ygdeOOuAaFTp
	so6EUyOx1Hgl7ftBopE1TIOLlfPb7XnR6fCIYYt/kUmBp9PYOk47mBdLaAoik8i7
	TGZeTuMU5/wRskIs//ZI4HXIVF6cLko99fReLUuWVWDovjHpEiPoBN1AsdW8fjLj
	o/hfg==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 4f8p2y0q4h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 Jul 2026 22:56:45 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 6 Jul 2026 22:56:44 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Mon, 6 Jul 2026 22:56:44 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 5DA273F7066;
	Mon,  6 Jul 2026 22:56:42 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v3 36/88] scsi: qla2xxx: Add build-time size check for VP config IOCB layout
Date: Tue, 7 Jul 2026 11:23:43 +0530
Message-ID: <20260707055435.2680300-37-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20260707055435.2680300-1-njavali@marvell.com>
References: <20260707055435.2680300-1-njavali@marvell.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzA3MDA1NCBTYWx0ZWRfXwLiW4gmKcY9F
 ndPNgzNaeevUC84fUKXT7FtH50o4sVMJpvFhPEnkfnuYrR7Jzguy+j0HJOx7w7ror7tHJpQ3NR4
 yQuMR0CZpU1keAOjPtqH8t95YWZAVI+68ohfIM6YNY3aqlL6x9RHwLFcdzqVQ5vnywYrfimU4Kh
 flRggGT7On0U1tUWibivo93qIOyKARiMRg0Sxng/d9fXsBzETCBspO8MhXBO88u652kF02xJK/8
 T0fZAs7wwgViZF/7VCtlsCQa2LnG+z1ph7PxYjqJDr3AIgmomzRJnX0xziWjESrORA+ipwJp1BG
 HZA9R/8JI+YuOB2LnMnArcaaw44Qe47pNI6YSF72fVSeL9hvxIzHPCvBivbGGT9vV6RYEMXfBq7
 4dj1iH4pO5NoexQ0MLihZfRiTnGSs38A+SKdc6wscmPXl3T5CNEClFvz7YyQ3QX5P0P5Xw2sIW7
 WcwCnO6Y8Gzb7NwHQHQ==
X-Authority-Analysis: v=2.4 cv=GoByPE1C c=1 sm=1 tr=0 ts=6a4c951d cx=c_pps
 a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=TtqV-g6YmW1Jfm2GSLaY:22 a=M5GUcnROAAAA:8 a=VwQbUJbxAAAA:8
 a=QdJASnsuDdI3Qm7nM90A:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzA3MDA1NCBTYWx0ZWRfX6BVje30e0jU2
 nBl51fFBLoeCiRZFtWmGp0Ivu6VJSPY3Qc7smyoWthSpBJ8pMbjevfuWzi5MNWnukfZ2cBkIH8b
 RUdB4XJb8HzqJBjRNXVjJAc6rZhoiVk=
X-Proofpoint-ORIG-GUID: caLfVK7shHtveDJO-D8m1Oy1DEtzAFPg
X-Proofpoint-GUID: caLfVK7shHtveDJO-D8m1Oy1DEtzAFPg
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-07_01,2026-07-06_02,2025-10-01_01

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

