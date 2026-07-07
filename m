Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F32AE27466A
	for <linux-scsi@vger.kernel.org>; Tue,  7 Jul 2026 05:59:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.156.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783403943; cv=none; b=GXvE7flYemkGJqF5EWiHT9GMtHDXwqws640Fk1YmRJKc0G+KyXUxRvIQO5iSV/aMZD+gnx4Y1SH4NIILO9APApD6KNQZArF8OxJYHzGifWCqfxKYyg02IfuzMKp30jH8FNiePCrHdf/52lxwrSPA8lExKei/JU9ZVHf6pHYDR1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783403943; c=relaxed/simple;
	bh=YBVlbPhpjP3m66ZiHhpKhuP+a7lb+6TWr+xdnfT23Zs=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Q5q1DgbZJmuXgYJQdSeuKGDi+2rYUZnLmokLUMgoDov+vYGGVaNtn42Wi5d0deCNHwVFFCs6yx7Jx0qdPLNPqG+ZMgQ83QoLGPnkK2lBEu0WkIepHeg3SuA68ZGJBvhMkX++EUj1D5wW7IBRon0wRh+effeXD2kVYuAzK2hpYMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=kuqAn4p9; arc=none smtp.client-ip=67.231.156.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="kuqAn4p9"
Received: from pps.filterd (m0431383.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 667483u2872835;
	Mon, 6 Jul 2026 22:58:59 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=I
	db0heSIK8UpMx82hhs8X3gwLauQP9v+k6K6xiksFu0=; b=kuqAn4p98oeLna5rZ
	iRFb8hapxeFZqMjTrGUwFF9sPpMrKrn4qXecXKKRSt3+d6m+y9NFqBmADjSo4yBr
	MPCEk1SnD73GSPt8j0SYeusFF3RD/jwCXb76tiJHf1XAzm+BI2JHnV7GkD+gnfuD
	kIfd01ns4raqsjV8lok6+lqWQSRiAsBsdLWB9oFa0vTnED4a5j6U5EU1U/VDkn/b
	CU7z2RISKbqACFYKs0l+qoiAYrMSk69eCPPXwK02eouLos3CSLe/5aVfaSoVV+uM
	DQcLG1LTuvDyLCFRVuusZGCA8hXZqqOYxKTShmEsR3l5zqRwEuMkmRzGppSQ7Ryl
	njSmQ==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 4f8f9waacb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 Jul 2026 22:58:59 -0700 (PDT)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 6 Jul 2026 22:58:58 -0700
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Mon, 6 Jul 2026 22:58:58 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id B17823F7066;
	Mon,  6 Jul 2026 22:58:55 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v3 82/88] scsi: qla2xxx: Serialize NVMe unsol ctx list with a per-fcport lock
Date: Tue, 7 Jul 2026 11:24:29 +0530
Message-ID: <20260707055435.2680300-83-njavali@marvell.com>
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
X-Proofpoint-ORIG-GUID: JfPECk7pCwCiDxTrmiuU8T3qFZce4eOB
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzA3MDA1NCBTYWx0ZWRfX1EA13PBp1tLg
 KEPx/HqFluvyb18LZnj+1gtwYoZWLLwVDtEe68AGmQlaJYAddNsMfOlmikz5tJbk11wcUx6pA5s
 c+9TaVCglxjjTaaU65P8BeUOdheVEFYabmHGhofZNWztqe4d6uCxohwVsce4z6n9wihCh6nYadB
 09EDkjr5lDHvshkaqftwSv1UP/t9g+lNepSMkaYyhuYik3MrO1LPybEXqy8u3KKZFuqwvA0EIDz
 PfjGuyfx8trBarM4lXb5zs0WhE/QtIcO8eewOY925BcfUT694ie14qrLmFAs3+IyqbyyJZuQlQ9
 /ZufY4i1eH9KgiHvzWmosEkcoOEKfrqSkwthuPH11UYBVs8PZghpVK8xEAdHUhYxwn6//arPQPY
 2gms+573Pp8VKAN6+4bgSZ+wDqfIsMHCuQsjQf0g/NqoRg7mACRF1E+a6EtQD005v6Gzgu6virt
 wIsJmh2LsqNy9akiDJw==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzA3MDA1NCBTYWx0ZWRfX6zfAws2NUReq
 giK+iI27H8K92RLTAdvj1pxJNZYEqXDXgYshq2+ql/ARYGewo3g09w+MXw8pi6zK7Xu3pWY7VpY
 D69nQrQcpgeqEaOtIQ4pFuTqFRgQImI=
X-Proofpoint-GUID: JfPECk7pCwCiDxTrmiuU8T3qFZce4eOB
X-Authority-Analysis: v=2.4 cv=SY/HsPRu c=1 sm=1 tr=0 ts=6a4c95a3 cx=c_pps
 a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=qit2iCtTFQkLgVSMPQTB:22 a=VwQbUJbxAAAA:8 a=1XWaLZrsAAAA:8 a=M5GUcnROAAAA:8
 a=1Jr0xraKtnFNJvKpV0wA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-07_01,2026-07-06_02,2025-10-01_01

The fcport->unsol_ctx_head list is modified from several contexts without
a common lock. Entries are added in qla2xxx_process_purls_iocb() from the
response queue ISR (under the qpair qp_lock), while they are removed from
qla2xxx_process_purls_pkt() (DPC/purex worker), qla_nvme_xmt_ls_rsp()
(NVMe-FC transport callback) and qla_nvme_release_lsrsp_cmd_kref() (SRB
completion). The qpair qp_lock cannot serialize this per-fcport list since
multiqueue adapters add entries through different qpairs, so a concurrent
add and delete (or two concurrent deletes) can corrupt the list pointers.

Introduce a dedicated per-fcport spinlock, unsol_ctx_lock, initialized in
qla2x00_alloc_fcport(), and take it around every list_add_tail()/list_del()
on unsol_ctx_head. The add nests under the existing qp_lock; no delete path
takes qp_lock, so the lock order is consistent and deadlock free.

Fixes: 875386b98857 ("scsi: qla2xxx: Add Unsolicited LS Request and Response Support for NVMe")
Cc: stable@vger.kernel.org
Reported-by: Sashiko <sashiko-dev@google.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_def.h  | 2 ++
 drivers/scsi/qla2xxx/qla_init.c | 1 +
 drivers/scsi/qla2xxx/qla_nvme.c | 9 +++++++++
 3 files changed, 12 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index bb4305f6a364..afbd056148bd 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -2645,6 +2645,8 @@ typedef struct fc_port {
 	struct list_head list;
 	struct scsi_qla_host *vha;
 	struct list_head unsol_ctx_head;
+	/* Serializes unsol_ctx_head against ISR, DPC and NVMe transport. */
+	spinlock_t unsol_ctx_lock;
 
 	unsigned int conf_compl_supported:1;
 	unsigned int deleted:2;
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index d935fe5e5316..751388c5e3fe 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -5703,6 +5703,7 @@ qla2x00_alloc_fcport(scsi_qla_host_t *vha, gfp_t flags)
 	INIT_LIST_HEAD(&fcport->gnl_entry);
 	INIT_LIST_HEAD(&fcport->list);
 	INIT_LIST_HEAD(&fcport->unsol_ctx_head);
+	spin_lock_init(&fcport->unsol_ctx_lock);
 
 	INIT_LIST_HEAD(&fcport->sess_cmd_list);
 	spin_lock_init(&fcport->sess_cmd_lock);
diff --git a/drivers/scsi/qla2xxx/qla_nvme.c b/drivers/scsi/qla2xxx/qla_nvme.c
index 36b742f73abf..beccece1e7d9 100644
--- a/drivers/scsi/qla2xxx/qla_nvme.c
+++ b/drivers/scsi/qla2xxx/qla_nvme.c
@@ -257,7 +257,9 @@ static void qla_nvme_release_lsrsp_cmd_kref(struct kref *kref)
 
 	fd_rsp = uctx->fd_rsp;
 
+	spin_lock_irqsave(&uctx->fcport->unsol_ctx_lock, flags);
 	list_del(&uctx->elem);
+	spin_unlock_irqrestore(&uctx->fcport->unsol_ctx_lock, flags);
 
 	fd_rsp->done(fd_rsp);
 	kfree(uctx);
@@ -446,7 +448,9 @@ static int qla_nvme_xmt_ls_rsp(struct nvme_fc_local_port *lport,
 		qla_nvme_ls_reject_iocb(vha, ha->base_qpair, &a, true);
 		spin_unlock_irqrestore(ha->base_qpair->qp_lock_ptr, flags);
 	}
+	spin_lock_irqsave(&uctx->fcport->unsol_ctx_lock, flags);
 	list_del(&uctx->elem);
+	spin_unlock_irqrestore(&uctx->fcport->unsol_ctx_lock, flags);
 	kfree(uctx);
 	return rval;
 }
@@ -1332,7 +1336,9 @@ qla2xxx_process_purls_pkt(struct scsi_qla_host *vha, struct purex_item *item)
 			spin_unlock_irqrestore(vha->hw->base_qpair->qp_lock_ptr,
 					       flags);
 		}
+		spin_lock_irqsave(&uctx->fcport->unsol_ctx_lock, flags);
 		list_del(&uctx->elem);
+		spin_unlock_irqrestore(&uctx->fcport->unsol_ctx_lock, flags);
 		kfree(uctx);
 	}
 }
@@ -1374,6 +1380,7 @@ void qla2xxx_process_purls_iocb(void **pkt, struct rsp_que **rsp)
 	struct purex_item *item;
 	port_id_t d_id = {0};
 	port_id_t id = {0};
+	unsigned long flags;
 	u8 *opcode;
 	bool xmt_reject = false;
 
@@ -1439,7 +1446,9 @@ void qla2xxx_process_purls_iocb(void **pkt, struct rsp_que **rsp)
 	uctx->ox_id = p->ox_id;
 	qla_rport->uctx = uctx;
 	INIT_LIST_HEAD(&uctx->elem);
+	spin_lock_irqsave(&fcport->unsol_ctx_lock, flags);
 	list_add_tail(&uctx->elem, &fcport->unsol_ctx_head);
+	spin_unlock_irqrestore(&fcport->unsol_ctx_lock, flags);
 	item->purls_context = (void *)uctx;
 
 	ql_dbg(ql_dbg_unsol, vha, 0x2121,
-- 
2.47.3

