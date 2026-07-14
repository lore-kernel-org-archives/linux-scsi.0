Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2C1C3E5EEE
	for <linux-scsi@vger.kernel.org>; Tue, 14 Jul 2026 09:56:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784022990; cv=none; b=QAcu3DFwY5kRnTmRNUjMgUmGFWAcQ/SnTZUuXWkW7KdeYlaki9q3SFxe7711gYF7rBd6wbvAn2SF2J9Kd3SUro2wvi0Nc0jIQE8cH66sWg8HCcl6CenCSTyQZyZRajdK6rQ/xjx+Lr6SuQTu+NC3nC/OK4MUIwT0BeIkuIn1GcM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784022990; c=relaxed/simple;
	bh=2g0OZbzyNlcbpl6670X4NvJXIlwPRy3To/9y5PdLKf0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZDVz3qROj9Dauungd9O6p4LrsfQ/wVH2r/l6zmGr9Sy8WovqbtvYHzzsro5HRHPQwGoQxjN4TFvrzJ73yep8qlxj8gSQK2U9n5vZWWxJAnXFpWDXLIF80HEF4wvJnPJecnewHHLkz8X3gvw4eXRyWKeQtROyr7ME5iPr/hXhplU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=IjwWn+Je; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="IjwWn+Je"
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66E6Ukr33693372;
	Tue, 14 Jul 2026 02:56:26 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=O
	JPGqqbn5HindJKnJV9QtnYkoZD0K9Y87bszxDmyilI=; b=IjwWn+Jeve1zDEzgG
	fX5MiTI33e31nCa+ejYcThG04VFy6cJZkJWKb4/jglYDCLcx4z2hoqYru4WKc/Ha
	i7iCh7QngUYxRq/OgXwH5ANBS3e97YFd6AXZJPs6OGSSsYWvUqwi+jpMNlX9Wdn5
	/bWeo9/um7r71Gt6a7S2pXiBFdXKGEBz+xFjOWaiDpnUfqZqRTLgB5jfkjpbMDGB
	3nes0qZhqr7ZPV/E9XZt1hM2Wq8mM8MV2hcq3oCJaktiI6HwIlYn6h/zSbOG5Hzt
	mmN+VPQdA+2hxlFalpU4COHvtdCWL4+QiA0v+O0tofLr75dGpFXBlJzlZpqAE7D1
	esBWQ==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 4fbnbey8wr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 14 Jul 2026 02:56:26 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 14 Jul 2026 02:56:25 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Tue, 14 Jul 2026 02:56:25 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 04DA85E6867;
	Tue, 14 Jul 2026 02:56:22 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v4 46/56] scsi: qla2xxx: edif: Fix NULL pointer deref in RX SA delete check
Date: Tue, 14 Jul 2026 15:23:43 +0530
Message-ID: <20260714095353.289460-47-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20260714095353.289460-1-njavali@marvell.com>
References: <20260714095353.289460-1-njavali@marvell.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: _7aESip7yjuz1mRYF8bdV8Q3nBM_VMJO
X-Authority-Analysis: v=2.4 cv=WOdPmHsR c=1 sm=1 tr=0 ts=6a5607ca cx=c_pps
 a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=QXcCYyLzdtTjyudCfB6f:22 a=VwQbUJbxAAAA:8 a=M5GUcnROAAAA:8
 a=reP9pj-AO4Wx2xJZjeUA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-ORIG-GUID: _7aESip7yjuz1mRYF8bdV8Q3nBM_VMJO
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzE0MDEwMyBTYWx0ZWRfX7/Tk6/NElPcf
 9QfnGZAwec+oYHAKTJw24y2GFjmvLE5aQHPcca6COo09l3XVFOdNvw7txKMgUvwq6lLN8oXOGwq
 MAlrh8mzcsRyZsiFzo2ooCfyqUrrCVE=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzE0MDEwMyBTYWx0ZWRfX3SajVGIfkXY4
 T0hSn/ooJCRtK2Ozw3gfwEqeqRd8bC4E5ajrNzU/s9s5ykIEIMFfToPsJxYF8zP0EK/cJFXN+nE
 uVPAO6daa6iI6uKSPxi7hiGmR8TLu5uR9s4XfL0NeGsKQgQ2e6A2kQJDJ0edVVn60Wd7WsDYTeb
 Y9RiOi8kJea/bblGzHj3U3DJFq0qmm3xKdzLqdBFD2Buz80bG6LMn23U/242YezMIdn6+3Tn4lc
 PJPhh/eauyLF71VIjs/v8bN3WjrMGVvPIJOWmw875f4eC7m+MqBklPWbQYPXwq+aWnj65PIdF9o
 IlkXh7Tqcya57vbDD5+UVKHvlLLz9ZgiU0kB0A2F7DVANKG7bvLQqf7uvgNsneDp8/LZF6L9JLK
 VUEZrgEtzL4fDpZdHDY0mivTogkEI/kPF5d1cEMjapxMX0zlmrg4sqn+STKaZkmilx/u2qgvF4v
 Kp9DkX87eeA9+vKd94g==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-14_02,2026-07-10_01,2025-10-01_01

qla_chk_edif_rx_sa_delete_pending() obtains the SCSI command via
GET_CMD_SP(sp) and immediately dereferences cmd->sc_data_direction.
That command pointer can be NULL: the firmware may post a status
completion for a command that has already been returned or aborted.
The caller qla2x00_status_entry() acknowledges this on the very same
status path, re-fetching GET_CMD_SP(sp) and bailing out with the
"Command already returned" message when it is NULL -- but that check
runs only after qla_chk_edif_rx_sa_delete_pending() has already
dereferenced the pointer, so a NULL cmd crashes the kernel in
interrupt context.

Return early when cmd is NULL, before touching cmd->sc_data_direction.

Fixes: dd30706e73b7 ("scsi: qla2xxx: edif: Add key update")
Cc: stable@vger.kernel.org
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
---
 drivers/scsi/qla2xxx/qla_edif.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_edif.c b/drivers/scsi/qla2xxx/qla_edif.c
index ade1d8178573..bfa520f936a2 100644
--- a/drivers/scsi/qla2xxx/qla_edif.c
+++ b/drivers/scsi/qla2xxx/qla_edif.c
@@ -3540,6 +3540,9 @@ void qla_chk_edif_rx_sa_delete_pending(scsi_qla_host_t *vha,
 	uint32_t handle;
 	uint16_t sa_index;
 
+	if (!cmd)
+		return;
+
 	handle = (uint32_t)LSW(sts24->handle);
 
 	/* find out if this status iosb is for a scsi read */
-- 
2.47.3

