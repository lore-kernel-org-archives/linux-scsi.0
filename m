Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4ABC2CCB9
	for <linux-scsi@vger.kernel.org>; Thu, 30 Jul 2026 16:00:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427221; cv=none; b=pFmZ4HBeIe5BO+H2/RmR9QXMgPwzxxONh0uguqdj1BNc+D6SSaOAWjUoSmi1g+42d298pxz0CNyWGetnq7qX6DZ5aYzJlwRuiQ7Ecc1cdrAgQbz8dINTGunkJBs0mCIyqFU/ecI9JIHV2I13VTbGriG8GJzEMkwNoKncQXHWXc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427221; c=relaxed/simple;
	bh=d1fciftdum4+XjSWRkZZd8+X+m9m1Aod0v9RzfJd5tQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jgn6jgxRGnSy1TRMVVxQC8iv/nsnRXIa3qW89zCQgSbGW8B94aLPU2iDhrn7vOm+YerNEY7NjshZOKA+s8ahEnOZTjbBko40t626sr9PCfMHiS4K0syHTrvYOWUmKk3C6vJ5dzOKxjMr9CigiFxsHmwEAYrAGokI804XBwat9uw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=Is0hDj7d; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="Is0hDj7d"
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66UFV0n21299540;
	Thu, 30 Jul 2026 09:00:16 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=A
	8avJp7pBCTLs3ByDqenG/Se9e35y0SiSYVcs10lRFk=; b=Is0hDj7dv+Qh5/Kw1
	BTS0hlzwSzaoRbmjdQ5LmNBLqXuo/dtqdD5WIiPrJ7eseN39fOb4/SV+4YsGxYao
	UhHEWjjNV6/GAHht7wWysrOnkxqX74kvPGgubclTrRMsun9x2mzy0rwEBP2TAEUS
	phd5CEfBaMLQrPhYA6dFIdJ0HUakxS5LukNROjOBpo824tovVaD+Jp+1rqIdCCkE
	Gt5Z6RCF540+1elrhFbiPBzkAIxNyein5KlOars0bVk7M+xKqc2NUZM9yzoztmrJ
	k2a/G7048XlYbLJ1/JPONT8yh+EExUiXQnt7LrPdbBpJxTQDrhnb0wTYDAcpX5vg
	37JgA==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 4fq0f08ccg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 30 Jul 2026 09:00:15 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 30 Jul 2026 09:00:15 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Thu, 30 Jul 2026 09:00:15 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id B414E5B6953;
	Thu, 30 Jul 2026 09:00:12 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH 26/33] scsi: qla2xxx: Unlink NVMe unsol ctx before freeing on LS reject error
Date: Thu, 30 Jul 2026 21:28:31 +0530
Message-ID: <20260730155838.2119230-27-njavali@marvell.com>
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
X-Proofpoint-ORIG-GUID: YaFQSESjVFQ__wCqcziKPULisj7YiRNU
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzMwMDEyMSBTYWx0ZWRfX75ciUvtFH5y8
 Fwi5etcUdeZ18zZ+ZYyTaSCPyguzVonHarq7K7Bfln7Rtlsd8VoOD4hCiRfFP7SGsd0v+2hGxWQ
 eoEy0VS8tz8VtsHSTTUGqZIz45XKWXQizDwKcyAzKIuW/c9+c1Vpw0cf9so7DvCEF4Axrf/1vaW
 NKzahZskjnj4RNZVQG5Vwshx90yM/udIF/qZamtOt6ijfBzBtkzD68yS2TCQPrAZXmgDaHDCK6N
 kBsaTWkBIHjx1C4hTpjHL5lVnZcLTYqBlUq9n1kbBRNieFxjMt2Rxrx0vQWAqlz4sNA+UD69MIY
 jW9XdjCIOqtvRF+LxqIWNEXi6JtSSava1SxSOlLAX67HKwONkAn4UH1KKR5Z8CnkJAMhpUT/gSx
 maX0jmv/hDckDarcJS/EZvhQYWOrof4Y2x58MRKTIRH7mXxUDN1zAsHrwVjpJTGu+5VxiNta5qQ
 Pi9QV/FINkL/uksdcrA==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzMwMDEyMSBTYWx0ZWRfX2KKj/L9WNat+
 mYRAGItht5bPei33QC7lrK3DT+0zBcoYBmEgG4EGcqDWM+8V5rMwuzZ1AnkqvJgTC4d4RQXxvYR
 C5PV2945PqMxDJxVVXlvk+csuA7BMJE=
X-Authority-Analysis: v=2.4 cv=NOLlPU6g c=1 sm=1 tr=0 ts=6a6b750f cx=c_pps
 a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=QXcCYyLzdtTjyudCfB6f:22 a=VwQbUJbxAAAA:8 a=1XWaLZrsAAAA:8 a=M5GUcnROAAAA:8
 a=kZ7mmqgNj_isLyQNFCwA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-GUID: YaFQSESjVFQ__wCqcziKPULisj7YiRNU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-30_04,2026-07-30_01,2025-10-01_01

qla_nvme_xmt_ls_rsp() obtains uctx, which was linked into
fcport->unsol_ctx_head by qla2xxx_process_purls_iocb() and is still linked
when the NVMe transport calls back to transmit the LS response. On the
error (out:) path the function frees uctx with kfree() but never removes
it from the list. This leaves a freed node in fcport->unsol_ctx_head: the
next list_add_tail() for that fcport writes through the freed node, and a
subsequent list_del() can corrupt the list or panic.

Unlink uctx with list_del() before kfree() on the error path, matching the
other free sites in qla_nvme_release_lsrsp_cmd_kref() and
qla2xxx_process_purls_pkt(). qla2x00_rel_sp() in the failure path only
returns the SRB to its pool and does not invoke sp->put_fn, so the out:
path is the sole free and uctx is always still linked there.

Fixes: 875386b98857 ("scsi: qla2xxx: Add Unsolicited LS Request and Response Support for NVMe")
Cc: stable@vger.kernel.org
Reported-by: Sashiko <sashiko-dev@google.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_nvme.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/qla2xxx/qla_nvme.c b/drivers/scsi/qla2xxx/qla_nvme.c
index 28a04e0ff660..36b742f73abf 100644
--- a/drivers/scsi/qla2xxx/qla_nvme.c
+++ b/drivers/scsi/qla2xxx/qla_nvme.c
@@ -446,6 +446,7 @@ static int qla_nvme_xmt_ls_rsp(struct nvme_fc_local_port *lport,
 		qla_nvme_ls_reject_iocb(vha, ha->base_qpair, &a, true);
 		spin_unlock_irqrestore(ha->base_qpair->qp_lock_ptr, flags);
 	}
+	list_del(&uctx->elem);
 	kfree(uctx);
 	return rval;
 }
-- 
2.47.3

