Received: from mx0a-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27B5D386C3B
	for <linux-scsi@vger.kernel.org>; Tue,  7 Jul 2026 05:57:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783403839; cv=none; b=tqKuWOB1Tq9PWECi3qn9HZYcgnewLibtsAjckh1Zy5qSkrORHzjHcyyN15SDwuI3cPsJ7wTEZzuyhPixIZFwBT4Z171ApkeiQ1E6Wxzw/uLYuBqA6N7ilJPXnkKdjLgIwkRE8gBOjThHqVlCqJTAq2HdWWSAnP5+5SV9zRwNlWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783403839; c=relaxed/simple;
	bh=2g0OZbzyNlcbpl6670X4NvJXIlwPRy3To/9y5PdLKf0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XLX+urouxJ7/b8xcl6qoRZYYQowlt7o6pcc86xLx4aF6G3kvKJ76d24yLgOpzLr2ebkdKM/1i9loZW6XT0OIGP+g8TSCEuUvW5YNHyk/Mzc8CvlE/tBBgtFpAh4+ogNF0mo5i6FygW1xQOItQ92JlLmx6702e0fHlbX/kWtmPb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=jD9C8+Kt; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="jD9C8+Kt"
Received: from pps.filterd (m0431384.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66747XY0854243;
	Mon, 6 Jul 2026 22:57:15 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=O
	JPGqqbn5HindJKnJV9QtnYkoZD0K9Y87bszxDmyilI=; b=jD9C8+KtF+6dX7VBw
	LBDPFHpn8S653eiXAic78NbT8kCLagSe+V/AZe1YBId+q9vH7UhPoAfsTLOmFlPg
	VNMZ7FDDQrLGuMLOPll3jRYS0EeJA7ynaKibue1wSnr7iJG2x4ZB+yk86+uroJCZ
	vjhPIVy+TWZ2GGNvCvETcexkjSfICIQm3k0TZXTi2ialBPiHWDFXkVO6X1tZNwa0
	SuFnsLwj7yJH0icgXbJ1FpJh6dllMbnwzgMU7/XSs8nt5DwhUcK0W/PyRBdAtvFo
	mUqZIVxk6FJgfxfhKz2opBaKexBvqMaV8OJ0TM2tIeQp5P5lzW2rPC+qJKn2IqPO
	S77DA==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 4f8p2y0q5w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 Jul 2026 22:57:14 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 6 Jul 2026 22:57:14 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Mon, 6 Jul 2026 22:57:14 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 1AEAB3F7066;
	Mon,  6 Jul 2026 22:57:11 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v3 46/88] scsi: qla2xxx: edif: Fix NULL pointer deref in RX SA delete check
Date: Tue, 7 Jul 2026 11:23:53 +0530
Message-ID: <20260707055435.2680300-47-njavali@marvell.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzA3MDA1NCBTYWx0ZWRfXyQygzJeXdpLR
 0Q8g72FfbCAu1JoFf49nSrx8X8AgBVHO66xrCod4Gf3OGgJSRNwIz8h6Kf/cPO1tDo/c6RCsGau
 FfL3adswxbypE2K0zUy1qN/pAG6QOiyQlQVquBTPFaFSGMN/OwqSVuEXEV3iQKNlVFOWiVRjoYD
 CQjYLdSjPG+rToSp+te/+6X7zx/inhpBk/46EpxZqeqCljsxnvbzyNv9xlpO4mthd10DLxQMTEP
 Z5D5IUmWBJhZWh11lPMH7yDZipEdS4jYm4yXgfwWA+MZgyMkcY7JyXOF+elmHD41KAOietsjpc2
 e6yFQFr09H2HMp2wxGJO3lB/COqKfdAoFkFpBqOFoHigmj2RcmgeX+N+M0h1iIGTXcsK3MhmOfF
 2F9/E15yvznCWueWYcUquvWDrSdaRZ7pkLmWQFyy06FPEkSYuq2Zi7QpjU9ka2i/GoDexIqLkJW
 jau49biqsrbfOUlY9jA==
X-Authority-Analysis: v=2.4 cv=GoByPE1C c=1 sm=1 tr=0 ts=6a4c953a cx=c_pps
 a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=TtqV-g6YmW1Jfm2GSLaY:22 a=VwQbUJbxAAAA:8 a=M5GUcnROAAAA:8
 a=reP9pj-AO4Wx2xJZjeUA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzA3MDA1NCBTYWx0ZWRfX4UJ55Dlf7Fdf
 KkY3CwfExfjZKER9Ml4cPfsB9slNua0el/MJGMTcUo6DiHk5fZkkRPCxfVa6bGRA3PdmiUulW0R
 upZljzGwKyOphMbHIBMCp7SmTzGJ0as=
X-Proofpoint-ORIG-GUID: u7o7WlrXxJzk6qdMUOGmnbRNOqEEIlMR
X-Proofpoint-GUID: u7o7WlrXxJzk6qdMUOGmnbRNOqEEIlMR
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-07_01,2026-07-06_02,2025-10-01_01

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

