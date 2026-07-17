Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8BB113AA2D
	for <linux-scsi@vger.kernel.org>; Fri, 17 Jul 2026 15:31:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784302306; cv=none; b=k1ehKmYGrwSLxYSR9CvDj61eSb2gvi1TGg6KqTev3bDmZxCl/HqmjJC90f2LVVosGxBWtiw8B/OUT7Rp+VI2WEFGZdzYHreaReZqQx8XwkospeRAIp9b6r9xhp+KbOO8TrRQgOo2ahQ0ufyVzzJTWMHTzXIIlS0loYvhgG4hg1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784302306; c=relaxed/simple;
	bh=9/TAKVgzm1AtFSHb/L9/07g90/TFo7LBxWZIujTNLCg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fG8SH3iXdmNFaTwyQ6qiuV9M3oKIREswGiW9V0j6PvlstZhQ8IJ0wkSIVDhVJ4V4lxDLorMT3orv3WoBDt0Z5MDzkJm6glYxlmYShH1g0q4q4jtV7n0l940rm6xTqrRGzy0lkm9L3S7j8GqdkxpW0BDJmwQEaYQd3vqDIVWlBPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=jdxb5pco; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="jdxb5pco"
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66HE80Um094827;
	Fri, 17 Jul 2026 08:31:41 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=J
	S4dePk1fFXr+NnDpZf6+JFjFcfDyzMWNjJgHUHWSmI=; b=jdxb5pcoa5ZK5IAK6
	AfYEUqwxAZHWRE6ydVfEVFNJ8YlxdZnTVop+y5e4wtykRXCrofamHMuok+i+mdLg
	oBLq+gUkrDDCZLs0NATTZ1iz1q5Xt8UMa2aWjS67XHInHr5O6Lq0ICnxqxhqXF3z
	Rizge7zCvxDZYO97qJ6wMnlQRDSSCf50Qyu9ItsW4pgyPqqRqytbCCXjMJ7lVgKJ
	FICh+DXZieC+dcG5Wf73v5LMrFC95vs/KkkiqShRERydMOQwRVRmG9XquHyNUY9J
	OPTjmceP0K/GK+/yaq+UVMyl3sE5Mt5yIYgu1OIaqgChicKEH2DuwjBQ1VpDUspN
	5Iu5Q==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 4ffhg8rxjy-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 17 Jul 2026 08:31:40 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 17 Jul 2026 08:31:39 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Fri, 17 Jul 2026 08:31:39 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 278485B693B;
	Fri, 17 Jul 2026 08:31:36 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v5 53/56] scsi: qla2xxx: Zero dport diagnostics buffer to avoid info leak
Date: Fri, 17 Jul 2026 20:59:01 +0530
Message-ID: <20260717152904.3155730-54-njavali@marvell.com>
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
X-Proofpoint-GUID: AMLMEl_ULmmOEUkimBuZ31cyGM3zV5Xm
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzE3MDE1OCBTYWx0ZWRfX6QnALhFu4gR3
 KoTVQPKJ0tof8DpGRFUoVHY2VYhS0HyoQFBV/uQO46S2PFbQxyfO28RapNkwJvrUnDqPqe3hrNP
 rxAGg4Dtn1xqQyQJSSkdYdbp40CVCYc=
X-Authority-Analysis: v=2.4 cv=SpKgLvO0 c=1 sm=1 tr=0 ts=6a5a4adc cx=c_pps
 a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=EAYMVhzMl8SCOHhVQcBL:22 a=VwQbUJbxAAAA:8 a=M5GUcnROAAAA:8
 a=cZcaXCM-GTnW6IyOXjwA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzE3MDE1OCBTYWx0ZWRfX3zYuNP43oFDo
 HyHdeZ6lCLhR9/0CqVpMFulNh3uOaRqTyqxQA59QFVwbXXKy+jm2DcgBtUSqoOrSqpuqhHYA33Y
 f7ev1ai26o3pp/XgiviWOJmcZ/I9/fqi0x1+WAsk8yTLC9LIDBYgQwJylrKho7tT2JEKDAGPuaA
 34WRSKWn5LiOSgNdJzeXHgw4fcciS7kF0+NguVPFcSSYYHPI5fQNPkFSUrPz0N3m/GpCNji8kUd
 sKG2PB+cEP8h4jyuZAXZ88fRixwB8w24ZXevL7DtDrGcmgmkgO+WeYAlU2HWa/av+5GcbMTwrto
 weSWG6TTIt8EMbECOgo8HtkHb8rEKwlUbUNvaU/PWbsqnotrrmxlEgVGs7bF8ErUd5c3rGioYXE
 6hk641X5aek+rANkb92q1CTOzwgGvEnSziuUig4pJtHsGx7+i1wyBOSdLRNuFetT9P+i5rMCQYu
 ylGoTuF8nsJ+QrejKpQ==
X-Proofpoint-ORIG-GUID: AMLMEl_ULmmOEUkimBuZ31cyGM3zV5Xm
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-17_04,2026-07-17_01,2025-10-01_01

qla2x00_do_dport_diagnostics() allocates the qla_dport_diag response
buffer with kmalloc_obj() (non-zeroing) and, on success, copies the
full sizeof(*dd) back to user space via sg_copy_from_buffer(). The
inbound sg_copy_to_buffer() only fills as many bytes as the user
request payload provides, and qla26xx_dport_diagnostics() zeroes only
dd->buf. The options and unused[] fields are therefore copied out
uninitialized, leaking kernel heap contents to user space.

Allocate with kzalloc_obj(), matching qla2x00_do_dport_diagnostics_v2().

Fixes: ec89146215d1 ("qla2xxx: Add bsg interface to support D_Port Diagnostics.")
Cc: stable@vger.kernel.org
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
---
 drivers/scsi/qla2xxx/qla_bsg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.c
index 9ee56ccd52b0..3bf3a7b96eb5 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -2858,7 +2858,7 @@ qla2x00_do_dport_diagnostics(struct bsg_job *bsg_job)
 	    !IS_QLA28XX(vha->hw) && !IS_QLA29XX(vha->hw))
 		return -EPERM;
 
-	dd = kmalloc_obj(*dd);
+	dd = kzalloc_obj(*dd);
 	if (!dd) {
 		ql_log(ql_log_warn, vha, 0x70db,
 		    "Failed to allocate memory for dport.\n");
-- 
2.47.3

