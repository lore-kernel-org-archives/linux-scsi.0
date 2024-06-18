Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 852B61741F2
	for <linux-scsi@vger.kernel.org>; Tue, 18 Jun 2024 13:38:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718717884; cv=none; b=dwleoQ1EW0Qfms2KYM/ujlSmrCid3mV0OrcV1omCjoxBoOLgJOr2jRe2yGQ6AgE9CYpqXsqShmOas4QOte3zgMars09Oly4B1qPTq/BJXTUQfTOw86gve6fwHK96tmf9TDl0YOnoSj+GC5feSKtejkzqP39+mrHUnAjD4Vsz5Dg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718717884; c=relaxed/simple;
	bh=HfY5HUkKTgC5IL6IR/T5jVqcVYNa7Ar+qlFV00FNK0E=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PzKDUvYARpMSDFPnveL90nOoUyj/P1Dpqpr9fhoZ8XELSPxBUrD6mbwqOMoVoVvzpI/qfBWj9K1crAQuiLc1cZFRTalz/8pbzdZKlYyT1Lv+VDHI8z0PjIa2D5lzjvfhcyLhTGdjnPdNQ6hDq5XMJBGxU5Dq5XoUn+D/LUxhTD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=ItH+zXSv; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="ItH+zXSv"
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45IBiHKL016978;
	Tue, 18 Jun 2024 06:37:59 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=P
	FC/u13t0RocuaFVna+KssiEzPSJX2qqAUqoFKvsdPs=; b=ItH+zXSv9VcISPl+T
	Biyc9VpZqJYOpRr3QYYFLXZR3eEZ8iVMnLkWXYfsNzX4oi2MaRdtZrzsoL0pXnVW
	uuUlbnG5i1zbVAs9XN4M/jbmHhkbzCDB5EO5zlE43jOSbNZCKcxPGKjmDyty4xWA
	ICsWT0Y/ohsE+SNIlFDQmB10s5OyDyle/UsbHWGBcwSK0OGbqoAUHAKAMYhjHy9O
	N9dpqk2sDdBczdzhKd9O4/6PoWMIKUhfl2RG/rCx75FL7Duufd30a34eD4wuQZ+j
	asXYuTgT2vhMp2stQOshf2E/rEtHyIniUcJ30OCqegdn/pYl/ogjRMei2Q3o/vL3
	Ln4lg==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3yu0nwt3mu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 18 Jun 2024 06:37:59 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Tue, 18 Jun 2024 06:37:58 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.4 via Frontend
 Transport; Tue, 18 Jun 2024 06:37:58 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.187])
	by maili.marvell.com (Postfix) with ESMTP id 739813F706D;
	Tue, 18 Jun 2024 06:37:56 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-QLogic-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <sdeodhar@marvell.com>, <emilne@redhat.com>,
        <jmeneghi@redhat.com>
Subject: [PATCH 02/11] qla2xxx: validate nvme_local_port correctly
Date: Tue, 18 Jun 2024 19:07:30 +0530
Message-ID: <20240618133739.35456-3-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20240618133739.35456-1-njavali@marvell.com>
References: <20240618133739.35456-1-njavali@marvell.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: coiJXHt5BZH5WvA6an1RoX7GnVjfIR83
X-Proofpoint-ORIG-GUID: coiJXHt5BZH5WvA6an1RoX7GnVjfIR83
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-18_02,2024-06-17_01,2024-05-17_01

The driver load failed with error message,

qla2xxx [0000:04:00.0]-ffff:0: register_localport failed: ret=ffffffef

and with a kernel crash,

	BUG: unable to handle kernel NULL pointer dereference at 0000000000000070
	Workqueue: events_unbound qla_register_fcport_fn [qla2xxx]
	RIP: 0010:nvme_fc_register_remoteport+0x16/0x430 [nvme_fc]
	RSP: 0018:ffffaaa040eb3d98 EFLAGS: 00010282
	RAX: 0000000000000000 RBX: ffff9dfb46b78c00 RCX: 0000000000000000
	RDX: ffff9dfb46b78da8 RSI: ffffaaa040eb3e08 RDI: 0000000000000000
	RBP: ffff9dfb612a0a58 R08: ffffffffaf1d6270 R09: 3a34303a30303030
	R10: 34303a303030305b R11: 2078787832616c71 R12: ffff9dfb46b78dd4
	R13: ffff9dfb46b78c24 R14: ffff9dfb41525300 R15: ffff9dfb46b78da8
	FS:  0000000000000000(0000) GS:ffff9dfc67c00000(0000) knlGS:0000000000000000
	CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
	CR2: 0000000000000070 CR3: 000000018da10004 CR4: 00000000000206f0
	Call Trace:
	qla_nvme_register_remote+0xeb/0x1f0 [qla2xxx]
	? qla2x00_dfs_create_rport+0x231/0x270 [qla2xxx]
	qla2x00_update_fcport+0x2a1/0x3c0 [qla2xxx]
	qla_register_fcport_fn+0x54/0xc0 [qla2xxx]

Exit the qla_nvme_register_remote function when
qla_nvme_register_hba fails and correctly validate
nvme_local_port.

Cc: stable@vger.kernel.org
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_nvme.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_nvme.c b/drivers/scsi/qla2xxx/qla_nvme.c
index a8ddf356e662..8f4cc136a9c9 100644
--- a/drivers/scsi/qla2xxx/qla_nvme.c
+++ b/drivers/scsi/qla2xxx/qla_nvme.c
@@ -49,7 +49,10 @@ int qla_nvme_register_remote(struct scsi_qla_host *vha, struct fc_port *fcport)
 		return 0;
 	}
 
-	if (!vha->nvme_local_port && qla_nvme_register_hba(vha))
+	if (qla_nvme_register_hba(vha))
+		return 0;
+
+	if (!vha->nvme_local_port)
 		return 0;
 
 	if (!(fcport->nvme_prli_service_param &
-- 
2.23.1

