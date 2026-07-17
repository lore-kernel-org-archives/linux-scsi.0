Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 259F33AC00
	for <linux-scsi@vger.kernel.org>; Fri, 17 Jul 2026 15:30:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784302260; cv=none; b=Cwa8xFeR21Tso8BBv9XhR4xM7JqG/i3gaUr0AyLWMh4f62OZdlxgtZVCEU+IBIDr6OtEp5WMX/sWcHemr72SNMb0Nh9W4TLYJcCUhVNPgqEpZnKqjJmIHGOOrzV7d2OI2dFms9AeY2KDVLRGHpvbBxp84gmZBW2GqIw9vFgt/To=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784302260; c=relaxed/simple;
	bh=eB9WP/wZa7W8e7GsWn57ny0lFbXTYL8w9EeakWCn+BA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bXvLh4so4ygT8vnWpsl/f98WpGqD/e1LW8w1ZD8krb93EgksZEbrsbo2YRkmixnCaUtqfa1daCdW8bAdgjO75tjFxeeeODhCMzB2iQaPYuCdTqGKOJWymbnnqZNkpXC8VQBr9T/p4a00g6JFhQ57be34YmGETCPjJ+FIOH72OfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=TzXfGYLJ; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="TzXfGYLJ"
Received: from pps.filterd (m0431383.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66HE4Ut82774305;
	Fri, 17 Jul 2026 08:30:54 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=s
	fLoo/z9F6OeKGMx+MoQlIdc+XDzT5UUKELEdGDxIuI=; b=TzXfGYLJhTiykqz/C
	bU4xRKPFWjf6n5UgsqXfkz0dfJ7+FgWCwMBMJMqNjLHc9Fhcwl66qsIPW5iSvL/a
	Fz9MLDLLbSOlSwvSVi6xVSHqIuX8lOSjd55sEQBhz6afxMAghBXaFoRPNVdL/LBW
	gE7IFQKGAWZKvE6t0aVi4Ojbq7VLwPc03m5oOg3nrebF18vOvr6ihlemkCusbWKl
	oF57UVhRSekDZipDbrMdSACpxaBRjZugaP9QVt8M72M6kThlNYoBeSLBR2q/kVS5
	XjuRO/U6IwsAiR1t3/BtVJzgHy1PbYtqq1eK8d845O2zY40s9jvA6DML1XBsflQs
	jhBbw==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 4ffm6p0hex-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 17 Jul 2026 08:30:54 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 17 Jul 2026 08:30:52 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Fri, 17 Jul 2026 08:30:52 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 981875B693B;
	Fri, 17 Jul 2026 08:30:50 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v5 36/56] scsi: qla2xxx: Add build-time size check for VP config IOCB layout
Date: Fri, 17 Jul 2026 20:58:44 +0530
Message-ID: <20260717152904.3155730-37-njavali@marvell.com>
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
X-Proofpoint-GUID: rHL7fFHnar67q67TTrGfFHS2dJroBJ7H
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzE3MDE1OCBTYWx0ZWRfX7MN6me1hqGdE
 TZ8pDByiY7XKHC42L5agVw3v8+wa0bWBnZtulfAoPw2zAw/V2th0voloZ9FiNmTEsbN21FrONbw
 1FmGe66rYmrG3LOz02swdM/xEaxg5Xk=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzE3MDE1OCBTYWx0ZWRfXw906FV+722xL
 FO6ZfpagjuW/XDpNJ+An7lbAxw0B3ZJyqsBr2XzGLk3lcyoN4YAAQVVcwlMRDCa3MxUSqaPlSae
 JcOzDK41FMl/BikYa/30n46RxHJ0SaWMCrz0D77MrQfvCeFqMHT+yTv7vi14SU0MjVrVKt/KHSd
 daKY8u6cVP9XfPBeLpqhgCYh5E3FFpjM36KYryOstc4DLOfJ2jOsm/N3mVM9No9sWJJZwGRj8Ut
 DclCN0ASuBm+/nw1ijfWOmnrQ3fkk7XXZGkuqp2wL3tFm3NJniXmJG5ujrGsgX9/nep/3Anw1mi
 fpfbHj9bcLB+OS3gChPXkyOewhzUxwHuzPMruZA60YXGb3ARYPSpIKJ6Amp6znoFlZ+TmkX9kyk
 O/e0ckFFbIEmBAaec5zbBJVTN+5B49QkAoIXstadDtjuUT4zZD/iefLGAUce8tUBoZfdPmDpIQO
 j5nvTkei9tr4YpvzDcw==
X-Authority-Analysis: v=2.4 cv=Wa88rUhX c=1 sm=1 tr=0 ts=6a5a4aae cx=c_pps
 a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=qit2iCtTFQkLgVSMPQTB:22 a=M5GUcnROAAAA:8 a=VwQbUJbxAAAA:8
 a=QdJASnsuDdI3Qm7nM90A:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-ORIG-GUID: rHL7fFHnar67q67TTrGfFHS2dJroBJ7H
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-17_04,2026-07-17_01,2025-10-01_01

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

