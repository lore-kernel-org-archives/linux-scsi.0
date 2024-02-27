Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC38C8836
	for <linux-scsi@vger.kernel.org>; Tue, 27 Feb 2024 16:42:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709052128; cv=none; b=AJa0BDB0rQ3JpR1QsuO8HLBde6IQQsJtgFylvFt7ks2mipX1yyvWzP8MnHtPf5flaLuiWqlmUy804OLSXxskj+gAFKTDcpVuYpjn8F21lxRaT3/UwGJg9Q6vsJhJdD2gSNbV/GUosjS4vltaAw8gHS49l+KsGz8MiRZdmYULDvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709052128; c=relaxed/simple;
	bh=BbKbSzHfk9BrJB3cMW043QVtYFCqL7bhcIEU+GWZZTw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oXZok8hfTVaBQ5E9MLC1UuePIoH59Euahmr7OnrTi2C8HbPf03caEUktsWZ47A6cpGu6xf7XOzRKRZiLAJijdjMZ3dJpZB5/Gc2S+be/MtlIipzUmeOGb8icLbkmackx3705O7ygqF5OcvpWjFm2q/4oOc92XRLoNpGlenUUwuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=GmkMekaG; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="GmkMekaG"
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.17.1.24/8.17.1.24) with ESMTP id 41RFgU0H004861;
	Tue, 27 Feb 2024 08:42:04 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-transfer-encoding:content-type; s=
	pfpt0220; bh=62ycmwNVPNAkcvICQgQcTD6ARa9ofgITuNAXQKKc3Pc=; b=Gmk
	MekaG5co03t7+VrKIpQp/2otFvF8v7AGpxwjOpPqEezeF2Y3dcLDod0tbDx1GZkH
	JRPu8QM3JIokoNk2zxrXC6cH9cmG/amcQ5/ZhnjfZMTT1aSaXuD4fOeM5Uhux1YL
	X4Aaq5FQRaSWU5Puk34ClT4kQLb5bHp02Rrg6cEKnmpt5ELniaUzipuIYEdeNCpP
	hm59SbgPGkmjg6WwpsoysqViFTs6ZHAr4EPOGUZ3wNM/ifpV4CjKiLAx8yfT4Vj3
	qcPZw7+2a+8lH2SHN/UyR4ZHnBxct+4sDW7RdFLwaMDsfOYQ1/ZBfuzO9mYR+zCy
	K6axGbd+vDINCZ+e/Gg==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3whjm689hn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 27 Feb 2024 08:42:03 -0800 (PST)
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.1258.12; Tue, 27 Feb
 2024 08:42:02 -0800
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH02.marvell.com (10.69.176.39) with Microsoft SMTP Server (TLS) id
 15.0.1497.48; Tue, 27 Feb 2024 08:42:01 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1258.12 via Frontend
 Transport; Tue, 27 Feb 2024 08:42:01 -0800
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.187])
	by maili.marvell.com (Postfix) with ESMTP id 47B7A3F70A9;
	Tue, 27 Feb 2024 08:41:59 -0800 (PST)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-QLogic-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <sdeodhar@marvell.com>, <emilne@redhat.com>,
        <jmeneghi@redhat.com>
Subject: [PATCH v2 08/11] qla2xxx: Fix double free of fcport
Date: Tue, 27 Feb 2024 22:11:24 +0530
Message-ID: <20240227164127.36465-9-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20240227164127.36465-1-njavali@marvell.com>
References: <20240227164127.36465-1-njavali@marvell.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: Pdvi5-D33zwtnaF4V-3dov26HscjyIV2
X-Proofpoint-GUID: Pdvi5-D33zwtnaF4V-3dov26HscjyIV2
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-27_03,2024-02-27_01,2023-05-22_02

From: Saurav Kashyap <skashyap@marvell.com>

The server was crashing after LOGO because fcport was getting
freed twice.

 -----------[ cut here ]-----------
 kernel BUG at mm/slub.c:371!
 invalid opcode: 0000 1 SMP PTI
 CPU: 35 PID: 4610 Comm: bash Kdump: loaded Tainted: G OE --------- - - 4.18.0-425.3.1.el8.x86_64 #1
 Hardware name: HPE ProLiant DL360 Gen10/ProLiant DL360 Gen10, BIOS U32 09/03/2021
 RIP: 0010:set_freepointer.part.57+0x0/0x10
 RSP: 0018:ffffb07107027d90 EFLAGS: 00010246
 RAX: ffff9cb7e3150000 RBX: ffff9cb7e332b9c0 RCX: ffff9cb7e3150400
 RDX: 0000000000001f37 RSI: 0000000000000000 RDI: ffff9cb7c0005500
 RBP: fffff693448c5400 R08: 0000000080000000 R09: 0000000000000009
 R10: 0000000000000000 R11: 0000000000132af0 R12: ffff9cb7c0005500
 R13: ffff9cb7e3150000 R14: ffffffffc06990e0 R15: ffff9cb7ea85ea58
 FS: 00007ff6b79c2740(0000) GS:ffff9cb8f7ec0000(0000) knlGS:0000000000000000
 CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: 000055b426b7d700 CR3: 0000000169c18002 CR4: 00000000007706e0
 DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
 DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
 PKRU: 55555554
 Call Trace:
 kfree+0x238/0x250
 qla2x00_els_dcmd_sp_free+0x20/0x230 [qla2xxx]
 ? qla24xx_els_dcmd_iocb+0x607/0x690 [qla2xxx]
 qla2x00_issue_logo+0x28c/0x2a0 [qla2xxx]
 ? qla2x00_issue_logo+0x28c/0x2a0 [qla2xxx]
 ? kernfs_fop_write+0x11e/0x1a0

Remove one of the free call and add check for valid
fcport. Also use function qla2x00_free_fcport instead of kfree.

Cc: stable@vger.kernel.org
Signed-off-by: Saurav Kashyap <skashyap@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
---
 drivers/scsi/qla2xxx/qla_iocb.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index 892a27afb462..0b41e8a06602 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -2637,7 +2637,8 @@ static void qla2x00_els_dcmd_sp_free(srb_t *sp)
 {
 	struct srb_iocb *elsio = &sp->u.iocb_cmd;
 
-	kfree(sp->fcport);
+	if (sp->fcport)
+		qla2x00_free_fcport(sp->fcport);
 
 	if (elsio->u.els_logo.els_logo_pyld)
 		dma_free_coherent(&sp->vha->hw->pdev->dev, DMA_POOL_SIZE,
@@ -2750,6 +2751,7 @@ qla24xx_els_dcmd_iocb(scsi_qla_host_t *vha, int els_opcode,
 	if (!elsio->u.els_logo.els_logo_pyld) {
 		/* ref: INIT */
 		kref_put(&sp->cmd_kref, qla2x00_sp_release);
+		qla2x00_free_fcport(fcport);
 		return QLA_FUNCTION_FAILED;
 	}
 
@@ -2784,7 +2786,6 @@ qla24xx_els_dcmd_iocb(scsi_qla_host_t *vha, int els_opcode,
 	    fcport->d_id.b.area, fcport->d_id.b.al_pa);
 
 	wait_for_completion(&elsio->u.els_logo.comp);
-	qla2x00_free_fcport(fcport);
 
 	/* ref: INIT */
 	kref_put(&sp->cmd_kref, qla2x00_sp_release);
-- 
2.23.1

