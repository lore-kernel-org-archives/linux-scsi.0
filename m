Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0313E2CCB9
	for <linux-scsi@vger.kernel.org>; Thu, 30 Jul 2026 16:00:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427215; cv=none; b=pjRTl/TCw/UEN2V6bumRyosie5xhr5AlyaeNgMWsrkQtmxv7WSnuCsncE18pm38Sy2g7uZoRvby4nlq+y5CxFXpcqd/PgpZBC4vWq/2ODPocYZAkrvOExzS6lkwuxemmt3MolFmK6QUct4d5JVE5fZ5aZxR+SeTRmHLylH8tpuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427215; c=relaxed/simple;
	bh=e+/qGTkSK4pL05V4fKH8D5xHLyIHoZEO9s/rJNQ8KPc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=O/0n59e2el6ttQnWHxNUCeP/90AGw+JYtBritXEMuSnLt7xMPQZrfl/pYezl43qYnJwrnlDUN/0obhDsguhIdBXykvvqUHOZljg/FaGLarPJdPf4wGqlSfmLAKtV7SeeURJkr563nd2IolSp6gjZi+jjSqD3VrwUOHTGyHPFIZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=gpTnbTwQ; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="gpTnbTwQ"
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66UFWI7K1321632;
	Thu, 30 Jul 2026 09:00:07 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=j
	y60rekgvPv72KgxU9Sz87gM4wRNYtBkZyIUDHZ2D9M=; b=gpTnbTwQqPhxxc7ca
	z7rD8y93NiPcML5+44At7QJNdka1YVVeF3HjtvkcJwbu4Jy5Y/n0lbUFxQRfBxHj
	t3y8l06jQ/NgBpOHL6oqEIUFMKfM0WpsXSZh8m/Abqk6de9pc/2dNJh+od3YKGVo
	bEv79Ry250wE0Hy5nf4E+aWW4JQm2YLz+P6+RIWFtZAZb675WhuMhvggprHhttU1
	mZFxxRqFokN/abvjm3iFXLHxy1CS+0sNXAULvoY2s7nvQi9NYzDRjDXNqEM6NbVt
	TNgQxNjo3/RUqW2vcuNqqkcEtA0Absg/dGF8jbc1M9QImNk8WewFSKeqydU0xzaT
	latQw==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 4fqu7ktqkb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 30 Jul 2026 09:00:07 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 30 Jul 2026 09:00:07 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Thu, 30 Jul 2026 09:00:07 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id 752893F7052;
	Thu, 30 Jul 2026 09:00:04 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH 23/33] scsi: qla2xxx: Hold vport_slock for host map update in report ID acquisition
Date: Thu, 30 Jul 2026 21:28:28 +0530
Message-ID: <20260730155838.2119230-24-njavali@marvell.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20260730155838.2119230-1-njavali@marvell.com>
References: <20260730155838.2119230-1-njavali@marvell.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: fBDyhAxofwoFG3twAUQqp1H7PheCsvE8
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzMwMDEyMSBTYWx0ZWRfXxo7xz4XUC7px
 ZDFk6kCmCJZKccxPNI5IUapMLiLEAOf63LjkNvPlrnttJI2cDKKrMzejUaAmuOHOBHdewlrbesY
 HHSDd0WRw8PWbvS4EOw2dCeTYqWXEKc=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzMwMDEyMSBTYWx0ZWRfX4jqEcxVlmPmU
 Vnlgr7//VwN5c79e/LSLFGna/UK6bjihAsS05QSdn5++t3jRd8SmBDTl2Mzj15/ihmCQG0lpCXz
 JKgQW+XK7S3qsTjbLNxOUGxlluFpU76vmTy1UuRaI9BdIsLs1FR/a4ZjdIZp6f7IZmSsYCj2Y6E
 8/ASsKfpMqwHir2ukQnp6JYFjmUnCKGBQhd6tVEQjNoOrMPrpzdTLMm/z2C5N0YFfvvPeswe5up
 4dcfHIln8sHeVdKegsOsWRG7Ku3UHOHuy92RMevM3SgLoVAuGjMOIlydBhmTAmq6U8KfGo3TI6V
 eC2ddkQpHZ1xH6zAtjGu9yW5+H9FT6+BpprSyyFgCqg1oA0IN10h/gP0YZR6hrfBnAkQriOjsya
 hyhTJNmN/DMGS+z3sT7rMINw4D6M3mBe0zfuDVbxpgSxmDldlLO6nTfuyhEZKdCIsU6EuUiSJAM
 2fdceNIq4RJj/bzt8FQ==
X-Proofpoint-ORIG-GUID: fBDyhAxofwoFG3twAUQqp1H7PheCsvE8
X-Authority-Analysis: v=2.4 cv=TrnWQjXh c=1 sm=1 tr=0 ts=6a6b7507 cx=c_pps
 a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=EAYMVhzMl8SCOHhVQcBL:22 a=VwQbUJbxAAAA:8 a=1XWaLZrsAAAA:8 a=M5GUcnROAAAA:8
 a=4VLQQ0I0xb82km90f00A:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-30_04,2026-07-30_01,2025-10-01_01

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

