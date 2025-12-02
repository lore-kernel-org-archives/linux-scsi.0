Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB5022FCC02
	for <linux-scsi@vger.kernel.org>; Tue,  2 Dec 2025 05:46:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764654371; cv=none; b=okvCdTqRx1rBG+s9iLdwLHtTWKx6oTHQ4jKiGK8IBaWcEoA5zFwIosNmJCvPxgXazQ4dcSnMZAeh6EN9kz7JLc3wT2CiSHXXUjClwFHKdROUGwxa9XQS+0pj88ZgmACB7O3ohP3qU0N4lAli65H+O7Cw603v45csz0j/+62ujrQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764654371; c=relaxed/simple;
	bh=/ntMZ0LMB/zMgNQZf378ErHUbDXoDbrDADTt73T8+Sw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=J/wvkKqwohk1GcJKh+0PZpIw+P00xZ2I+nH371Se1NpO5L2AW5bGNQ+xJgf9pmMXlbieuzWuxoWGnJuCQp8C4h54aPwhRJhkAcHFs7O9ejhT0+HXM+8+7NJsKxquYcxeK2D9pAXAPfhYn9hJXbCIZ4zEdK9qG6qtyu1426Ok5ZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=AeoIrI9F; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="AeoIrI9F"
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5B1Hkenp113816;
	Mon, 1 Dec 2025 21:46:07 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=W
	0QeisLjq3BWuRcaWKzZZLCqosIGkUu5aKemr2WesXE=; b=AeoIrI9Fc4yAP2IiE
	Rz528hhOyT7TqLw2DrrbnZ34Djle7CDrruzIl/UZgzX0qFcNEL19akDwFBZ2yH3V
	vpTW7w3op9YAiBOA+fjiXrRtaCJ+lVhqu8TWnvdscX2h9nu6Iggx3bdSPRoFgFRz
	YKeJfPtLR0xRrRDIxDv5k/sPjeU7TLJ0xsYcAvjwNicgBO9L0t1NgUH9vXO5S3ce
	d5qoe2EhT2UWuOs7IZgEjhef1O6lJZtTmo+4ihI+WjV6S43SEythFrhbxqdYaU6v
	jhhHqoZ1nZL+K06IazZFfoq1hn0gVafALaCF5GmTCycYgCxb8nIk0IGsUPS/dbZp
	cpHOg==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 4ar17nn81e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 01 Dec 2025 21:46:07 -0800 (PST)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 1 Dec 2025 21:46:20 -0800
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Mon, 1 Dec 2025 21:46:20 -0800
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id BA7715B6978;
	Mon,  1 Dec 2025 21:46:04 -0800 (PST)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-QLogic-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <sdeodhar@marvell.com>, <emilne@redhat.com>,
        <jmeneghi@redhat.com>
Subject: [PATCH 06/12] qla2xxx: Allow recovery for tape devices
Date: Tue, 2 Dec 2025 11:14:38 +0530
Message-ID: <20251202054444.1711778-7-njavali@marvell.com>
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
X-Proofpoint-GUID: IkfVGG_hk7w1tx5yULFcfefX3EpgLhcO
X-Authority-Analysis: v=2.4 cv=R+MO2NRX c=1 sm=1 tr=0 ts=692e7d1f cx=c_pps
 a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17
 a=wP3pNCr1ah4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=M5GUcnROAAAA:8 a=VwQbUJbxAAAA:8
 a=9c9XOHCOo3frZ98gKQ0A:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-ORIG-GUID: IkfVGG_hk7w1tx5yULFcfefX3EpgLhcO
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjAyMDA0MyBTYWx0ZWRfXwJbxhmjg3GWa
 fU7PwGoeCEhsRdAZ6pj5NfXlSUqHaRLHhHrAgz6RHV/I0StrWZi9XjdhuUSCVrTS4MKeRmoKzNi
 sY2RYliiTrbHEDed7XOJOVzbnrEprc7cdgwlyKQ66zbj3Tq+JssCaOnoyxL6sw4ucSlROVDop/W
 3ltBiJcIDPuNIbZ7sfERELyAen8ZrNhkDZx7mMQ75OODXRq1yRSAaGsRjdy368sqINmANfVZfgy
 tP3QoZQOA7g7u3tHhX/tdI5T7hiD6yPXmw8zQxmurxmhzULYkgLF7v/rQ8PglHCh+22CGuMgat5
 wbmxjCD2BMVJF7sECr5AjLHUtwkjxWw+cXFo1R8ww==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-28_08,2025-11-27_02,2025-10-01_01

From: Shreyas Deodhar <sdeodhar@marvell.com>

Tape device doesn't show up after RSCNs.
To fix this remove tape device specific checks
which allows recovery of tape devices.

Fixes: 44c57f205876 ("scsi: qla2xxx: Changes to support FCP2 Target")
Cc: stable@vger.kernel.org
Signed-off-by: Shreyas Deodhar<sdeodhar@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_gs.c   | 3 ---
 drivers/scsi/qla2xxx/qla_init.c | 9 ---------
 2 files changed, 12 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
index 51c7cea71f90..02a52c215797 100644
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -3266,9 +3266,6 @@ void qla_fab_scan_finish(scsi_qla_host_t *vha, srb_t *sp)
 			    atomic_read(&fcport->state) == FCS_ONLINE) ||
 				do_delete) {
 				if (fcport->loop_id != FC_NO_LOOP_ID) {
-					if (fcport->flags & FCF_FCP2_DEVICE)
-						continue;
-
 					ql_log(ql_log_warn, vha, 0x20f0,
 					       "%s %d %8phC post del sess\n",
 					       __func__, __LINE__,
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 6e73ef1abad8..0f0128835edb 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -1859,15 +1859,6 @@ void qla2x00_handle_rscn(scsi_qla_host_t *vha, struct event_arg *ea)
 	case RSCN_PORT_ADDR:
 		fcport = qla2x00_find_fcport_by_nportid(vha, &ea->id, 1);
 		if (fcport) {
-			if (ql2xfc2target &&
-			    fcport->flags & FCF_FCP2_DEVICE &&
-			    atomic_read(&fcport->state) == FCS_ONLINE) {
-				ql_dbg(ql_dbg_disc, vha, 0x2115,
-				       "Delaying session delete for FCP2 portid=%06x %8phC ",
-					fcport->d_id.b24, fcport->port_name);
-				return;
-			}
-
 			if (vha->hw->flags.edif_enabled && DBELL_ACTIVE(vha)) {
 				/*
 				 * On ipsec start by remote port, Target port
-- 
2.23.1

