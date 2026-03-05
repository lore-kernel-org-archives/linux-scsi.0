Received: from mx0a-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5925537AA65
	for <linux-scsi@vger.kernel.org>; Thu,  5 Mar 2026 09:33:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772703229; cv=none; b=dHDSVaQsvUWCc3XIXkFZsrnZb5F0aDuJH5U7d72ap8YcLBEVgyX6jPsMDK5m/sQJp3W3Wsf5YxzuqzeMatKVSWQ6ACPUKgpKnul+8du5k61FXHKi42hD+kPq36/ONl/6/6TzJhqrMDjUt+S2ro5TFwvGGl9ZeeBhHfrRnMbq3Y4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772703229; c=relaxed/simple;
	bh=3L/EvArsIXWfUBTpj9Rec/SCQv4fdBsDiGGjEAG5W1I=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=cdGu/agRqePgLh/hL9WttFRh9gcBlzupjB9JRXWTEMWcndj5MUlUltKXXt1g8PD/6pit8dLKSkh8OGNPVmoi77GQxQ87vN5edsC/cbiHNigTKRQ8zeUXHqNHnegEmJp/DeTqutYjpgrfVchyt5fYsiGFUoB/67v6paIKH2XZ5hA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=acrSty8q; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="acrSty8q"
Received: from pps.filterd (m0431384.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 624NUK7R2339702;
	Thu, 5 Mar 2026 01:33:46 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=pfpt0220; bh=uLqBllMjcFsvAQ2uj42ToPL
	YrZFBRVPQGal/tBp35eY=; b=acrSty8qR5ReY3/+9DMBgXZmxT3vrdYTmL1F6Mt
	NYVUBrCMDh/sQl1s6RJF9wH3uTmHjICzGyMxwQ1gWy7Xdlc83SWU/6V+vFBY8lSz
	Wr6K8PyVzm+9h9LrJwr71RBrpt7e4KiV/gSFjnO/pb77KyNZOcIn8BA7X4EFz4XN
	x324nT5VL/wJkP/xTjLpmMqFfYdVecb0udv+FDxxYfRchvkHGY2msNr0f5TX77uk
	keVGT1cTJ670JgYv0F5+BcoATARV3zrAOcV1EkJd00qeoM1cUgMTwoLS8RCoFw9Z
	E6og+9L/as+0QpPkRBsXMCGWlak+ZUZXol7v8CZQq7vGX9w==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 4cp6pgcmwh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 05 Mar 2026 01:33:45 -0800 (PST)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 5 Mar 2026 01:33:44 -0800
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Thu, 5 Mar 2026 01:33:44 -0800
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 1EF3B5B694D;
	Thu,  5 Mar 2026 01:33:41 -0800 (PST)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-QLogic-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>
Subject: [PATCH] qla2xxx: Add support to report MPI FW state
Date: Thu, 5 Mar 2026 15:03:37 +0530
Message-ID: <20260305093337.2007205-1-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: W9itz-Vtt-iirzcGU7M4nTDdn1KtGbEK
X-Proofpoint-ORIG-GUID: W9itz-Vtt-iirzcGU7M4nTDdn1KtGbEK
X-Authority-Analysis: v=2.4 cv=O8c0fR9W c=1 sm=1 tr=0 ts=69a94df9 cx=c_pps
 a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17
 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=TtqV-g6YmW1Jfm2GSLaY:22 a=M5GUcnROAAAA:8 a=apXIt3AJMygvaqUh-h4A:9
 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzA1MDA3NiBTYWx0ZWRfXxJVKLJMZQFWO
 yhrpxINDCi7f7Qoaa+6mLW8v6thTUw5O9bPzcx5xaTf+9N8D4k0bj9hhVXGY2tt2Q+Z3gx1N8p1
 DSpQEe4F40NZQqc/Gjgc8y6thHGaKQ6uvqIV8U/SdhZq+i9XhhytqCwLM1EDhpWZZWi4msDF3/w
 gyCsECNQp45tZxBXNfB039Z91+khDeUR7RPrKzoee0zZIkwbvLyf4KWyJXQQJAmW2eQwQliKHC2
 HF2/tG2FY2iT1OTKhxD8BAjQkyoad/ZAJ8Zy48oiVL7Rq3cRzynJh/oYVzV2RzslPu+4JeJYka4
 gBxihab4MsTw4HgzPSDC9MdBMINso1QmKh9A0kNORAxSXcNWeGqyrEraBSZLwQJGLQ/1Fr47+Zc
 8E2gadRlQrf6g80fE/Glmdn3U0+TrkfSmG8dp/XBl8bBkUmYiAPzaEKZ0VYFSIT05xMAqZUpySS
 tL59RQ5XwK7MBGJrlVQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-05_02,2026-03-04_01,2025-10-01_01

MPI firmware state was returned as 0.
Get MPI FW state to proceed with flash
image validation.

A new sysfs node 'mpi_fw_state' is added to report MPI
firmware state:
    /sys/class/scsi_host/hostXX/mpi_fw_state

Fixes: d74181ca110e ("scsi: qla2xxx: Add bsg interface to support firmware img validation")
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_attr.c | 62 ++++++++++++++++++++++++++++++++-
 drivers/scsi/qla2xxx/qla_init.c |  2 +-
 drivers/scsi/qla2xxx/qla_mbx.c  |  9 +++++
 3 files changed, 71 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
index 2e584a8bf66b..6a05ce195aa0 100644
--- a/drivers/scsi/qla2xxx/qla_attr.c
+++ b/drivers/scsi/qla2xxx/qla_attr.c
@@ -1638,7 +1638,7 @@ qla2x00_fw_state_show(struct device *dev, struct device_attribute *attr,
 {
 	scsi_qla_host_t *vha = shost_priv(class_to_shost(dev));
 	int rval = QLA_FUNCTION_FAILED;
-	uint16_t state[6];
+	uint16_t state[16];
 	uint32_t pstate;
 
 	if (IS_QLAFX00(vha->hw)) {
@@ -2402,6 +2402,63 @@ qla2x00_dport_diagnostics_show(struct device *dev,
 	    vha->dport_data[0], vha->dport_data[1],
 	    vha->dport_data[2], vha->dport_data[3]);
 }
+
+static ssize_t
+qla2x00_mpi_fw_state_show(struct device *dev, struct device_attribute *attr,
+			  char *buf)
+{
+	scsi_qla_host_t *vha = shost_priv(class_to_shost(dev));
+	int rval = QLA_FUNCTION_FAILED;
+	u16 state[16];
+	u16 mpi_state;
+	struct qla_hw_data *ha = vha->hw;
+
+	if (!(IS_QLA27XX(ha) || IS_QLA28XX(ha)))
+		return scnprintf(buf, PAGE_SIZE,
+				"MPI state reporting is not supported for this HBA.\n");
+
+	memset(state, 0, sizeof(state));
+
+	mutex_lock(&vha->hw->optrom_mutex);
+	if (qla2x00_chip_is_down(vha)) {
+		mutex_unlock(&vha->hw->optrom_mutex);
+		ql_dbg(ql_dbg_user, vha, 0x70df,
+		       "ISP reset is in progress, failing mpi_fw_state.\n");
+		return -EBUSY;
+	} else if (vha->hw->flags.eeh_busy) {
+		mutex_unlock(&vha->hw->optrom_mutex);
+		ql_dbg(ql_dbg_user, vha, 0x70ea,
+		       "HBA in PCI error state, failing mpi_fw_state.\n");
+		return -EBUSY;
+	}
+
+	rval = qla2x00_get_firmware_state(vha, state);
+	mutex_unlock(&vha->hw->optrom_mutex);
+	if (rval != QLA_SUCCESS) {
+		ql_dbg(ql_dbg_user, vha, 0x70eb,
+		       "MB Command to retrieve MPI state failed (%d), failing mpi_fw_state.\n",
+				rval);
+		return -EIO;
+	}
+
+	mpi_state = state[11];
+
+	if (!(mpi_state & BIT_15))
+		return scnprintf(buf, PAGE_SIZE,
+				 "MPI firmware state reporting is not supported by this firmware. (0x%02x)\n",
+				mpi_state);
+
+	if (!(mpi_state & BIT_8))
+		return scnprintf(buf, PAGE_SIZE,
+				 "MPI firmware is disabled. (0x%02x)\n",
+				mpi_state);
+
+	return scnprintf(buf, PAGE_SIZE,
+			 "MPI firmware is enabled, state is %s. (0x%02x)\n",
+			 mpi_state & BIT_9 ? "active" : "inactive",
+			 mpi_state);
+}
+
 static DEVICE_ATTR(dport_diagnostics, 0444,
 	   qla2x00_dport_diagnostics_show, NULL);
 
@@ -2469,6 +2526,8 @@ static DEVICE_ATTR(port_speed, 0644, qla2x00_port_speed_show,
     qla2x00_port_speed_store);
 static DEVICE_ATTR(port_no, 0444, qla2x00_port_no_show, NULL);
 static DEVICE_ATTR(fw_attr, 0444, qla2x00_fw_attr_show, NULL);
+static DEVICE_ATTR(mpi_fw_state, 0444, qla2x00_mpi_fw_state_show, NULL);
+
 
 static struct attribute *qla2x00_host_attrs[] = {
 	&dev_attr_driver_version.attr.attr,
@@ -2517,6 +2576,7 @@ static struct attribute *qla2x00_host_attrs[] = {
 	&dev_attr_qlini_mode.attr,
 	&dev_attr_ql2xiniexchg.attr,
 	&dev_attr_ql2xexchoffld.attr,
+	&dev_attr_mpi_fw_state.attr,
 	NULL,
 };
 
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 730c42b1a7b9..e746c9274cde 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -4914,7 +4914,7 @@ qla2x00_fw_ready(scsi_qla_host_t *vha)
 	unsigned long	wtime, mtime, cs84xx_time;
 	uint16_t	min_wait;	/* Minimum wait time if loop is down */
 	uint16_t	wait_time;	/* Wait time if loop is coming ready */
-	uint16_t	state[6];
+	uint16_t	state[16];
 	struct qla_hw_data *ha = vha->hw;
 
 	if (IS_QLAFX00(vha->hw))
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 0d598be6f3ea..44e310f1a370 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -2268,6 +2268,13 @@ qla2x00_get_firmware_state(scsi_qla_host_t *vha, uint16_t *states)
 		mcp->in_mb = MBX_6|MBX_5|MBX_4|MBX_3|MBX_2|MBX_1|MBX_0;
 	else
 		mcp->in_mb = MBX_1|MBX_0;
+
+	if (IS_QLA27XX(ha) || IS_QLA28XX(ha)) {
+		mcp->mb[12] = 0;
+		mcp->out_mb |= MBX_12;
+		mcp->in_mb |= MBX_12;
+	}
+
 	mcp->tov = MBX_TOV_SECONDS;
 	mcp->flags = 0;
 	rval = qla2x00_mailbox_command(vha, mcp);
@@ -2280,6 +2287,8 @@ qla2x00_get_firmware_state(scsi_qla_host_t *vha, uint16_t *states)
 		states[3] = mcp->mb[4];
 		states[4] = mcp->mb[5];
 		states[5] = mcp->mb[6];  /* DPORT status */
+		if (IS_QLA27XX(ha) || IS_QLA28XX(ha))
+			states[11] = mcp->mb[12]; /* MPI state. */
 	}
 
 	if (rval != QLA_SUCCESS) {
-- 
2.23.1

