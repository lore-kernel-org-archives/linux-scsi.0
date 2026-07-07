Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8F64386429
	for <linux-scsi@vger.kernel.org>; Tue,  7 Jul 2026 05:58:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783403934; cv=none; b=laUQmZcUJrTlyQLP5xx7mM8t+XU8p7BB539Ozd09aWVtA8OjZw15FBneSx3/ZdOdwEyiTzGnVAKYFetkr5AqIJQTS0QEYIOmbI9MKF8oKeQ04m9SpzcIUTyATil+T6zsdpPQpqNilAZqQO4AwxOBXfFha43yHZXqOtVB6NGjxxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783403934; c=relaxed/simple;
	bh=e+/qGTkSK4pL05V4fKH8D5xHLyIHoZEO9s/rJNQ8KPc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PjJWgNI4zZ4as4QY8Dw8rr0ha2SkiB8t2nm/TaE9LS54blAvmfKGZpo00ctV3IOVf+AIiqL+3tAuFyf2okxEjyGwToWBdz7KTh8Ec1zaMRucNzOKHaff7y8exWx/zTalimSGIYeQsotXe03Z0SkPI9MbMiTIa3vkhQiLR0te5jA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=SxUeecPW; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="SxUeecPW"
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66748ZmP1656002;
	Mon, 6 Jul 2026 22:58:47 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=j
	y60rekgvPv72KgxU9Sz87gM4wRNYtBkZyIUDHZ2D9M=; b=SxUeecPW4cj0sAT1N
	1DOL2gwamOCHXW6LgZBgS9z0V8yVYnB3uIsXxD23fFZ5G3UJ7j9ovxlRTJHHlQMY
	bD2e50MUpzuVbJy05VDFGrHqx3/P9vOVYNp0RR1afuspkkNVGBgkiSWHGf7V1xJw
	Lh6ZaNrKrPoUFsIM9ODjPXgT8nGSj2ccc/Bx1sEvnb9kzJLFGPJ7MHmN1cpMYlNB
	HWE6TfgjKMSwWheM77BQmpUBCuKAsnGRPhaA5VmIZ+LeXmY+vt3+aHMDMMuZUV9u
	XihyN5lavVwyIFxUWHE3iT8g4ZeCyYV5VNNnSIGG3ypcOWlqEZN3TWGEOk0KuA5/
	KFFjg==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 4f71phqe4q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 Jul 2026 22:58:47 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 6 Jul 2026 22:58:46 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Mon, 6 Jul 2026 22:58:46 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 37FD23F7066;
	Mon,  6 Jul 2026 22:58:43 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v3 78/88] scsi: qla2xxx: Hold vport_slock for host map update in report ID acquisition
Date: Tue, 7 Jul 2026 11:24:25 +0530
Message-ID: <20260707055435.2680300-79-njavali@marvell.com>
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
X-Proofpoint-GUID: VQSTD3gdijpncdw0q6XNQcadUsTj806K
X-Authority-Analysis: v=2.4 cv=Hf4kiCE8 c=1 sm=1 tr=0 ts=6a4c9597 cx=c_pps
 a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=QXcCYyLzdtTjyudCfB6f:22 a=VwQbUJbxAAAA:8 a=1XWaLZrsAAAA:8 a=M5GUcnROAAAA:8
 a=4VLQQ0I0xb82km90f00A:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-ORIG-GUID: VQSTD3gdijpncdw0q6XNQcadUsTj806K
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzA3MDA1NCBTYWx0ZWRfX6O7Oh1mQK9Xy
 v+xHYx70RTwj3+1myC9cOlvryLA6vsZ8fDgB3xaXQISIzLXODDR6j6I5cl5VqzT75rO8mJ7dyzl
 3oK5iiJ20PW8mg8lcW48ZDfdtDTHzRE=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzA3MDA1NCBTYWx0ZWRfX5z8tRggifi9C
 kvrKjSQZsDxN09/OLGYK6+L86jKvmOOOMIX1oBT37Q0dS/p/bR+/4PI8zEs9hTaTFKGGApCbkYV
 PH8UavcWdr9ZUYmcc82NuFCJ+L1ih2ge5LIqxmLyXKOxyF1RpVCkYZKkv6h32Ny8ewwU8XVeR2f
 hFED4jzzJgdC+lXspMBSM7kk19YYrZ83zqGs/Vy+RsSVm0PvAlv8S5zNHVhfm7mTt0CtCzg9JUZ
 C872fcOGh82sP0SHZdNkZMwIF25pHkm5OoJmWc1j6mTzBaiLHQJmuniS5ZU4sYXf8lxoTfJWraM
 1JdiALeOD2pvJ1KOJud/ozyOvZydS+zNs6fEU6PxZaxIxndxPGJr+GHPIjNN3hMgN6P+Qlooujq
 u/MXJteaiPc1+ny/Wy53N0tlz2vPMm3GhtlT2vv6lrsKBnc/TqxdmDGLJ01lctB51SPpkvhqmGp
 HVNg3663kZDlGNcY8bQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-07_01,2026-07-06_02,2025-10-01_01

qla24xx_report_id_acquisition() format-1 handling drops vport_slock after
taking the vport reference and then calls qla_update_host_map() without
the lock. That reaches qla_update_vp_map(), which mutates the ha->host_map
btree via btree_insert32()/btree_update32()/btree_remove32() and is
documented to require vport_slock to be held by the caller. Running it
unlocked can race concurrent host_map updates and corrupt the btree.

The format-2 path in the same function already wraps its host_map update
(SET_AL_PA) in vport_slock; the format-1 path is the lone outlier.

Hold vport_slock across the format-1 qla_update_host_map() call to honor
the documented locking contract. The vref_count taken in the loop keeps
the vport valid, so this only adds the missing host_map serialization.

Fixes: 430eef03a763 ("scsi: qla2xxx: Relocate/rename vp map")
Cc: stable@vger.kernel.org
Reported-by: Sashiko <sashiko-dev@google.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_mbx.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index e88c3a989a51..39544deab576 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -4280,7 +4280,9 @@ qla24xx_report_id_acquisition(scsi_qla_host_t *vha, void *pkt)
 			if (!found)
 				return;
 
+			spin_lock_irqsave(&ha->vport_slock, flags);
 			qla_update_host_map(vp, id);
+			spin_unlock_irqrestore(&ha->vport_slock, flags);
 
 			/*
 			 * Cannot configure here as we are still sitting on the
-- 
2.47.3

