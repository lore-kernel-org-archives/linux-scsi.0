Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A6CF27466A
	for <linux-scsi@vger.kernel.org>; Tue,  7 Jul 2026 05:58:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783403940; cv=none; b=e2unl3Ge88nS+XXbcK/T8zNAWxjQtk4zGykDJbI5YaczNuSG4UZJCUxEPP8rsDUlIkf9OIF+8QJeHG/VGpnLNhAbp3zsNgu/xp8mQCKVuI5tVP0aw040Uhk5nOUnDNd83sXQm+yyRLTEI86tU1kDjlKdLqcVhqwQ0NUzoIiKxPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783403940; c=relaxed/simple;
	bh=d1fciftdum4+XjSWRkZZd8+X+m9m1Aod0v9RzfJd5tQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NU6+XXEWopt7NrJoYnXrNm3wwVrIUkovQZlVXV/Yn7Qk0injGc6PHHqqDGYIhszQOnlzpvFWdpjmLZlO3qjJ/Bn0qr+kIMPmZyzYVjT9e4P4HgH01lowunOenJOEd1KFyC5T0HlcAULA19BH2FIzy9VvNSf3lhr9ANjACJc5PoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=KblJjAcX; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="KblJjAcX"
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 667493u11620032;
	Mon, 6 Jul 2026 22:58:56 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pfpt0220; bh=A
	8avJp7pBCTLs3ByDqenG/Se9e35y0SiSYVcs10lRFk=; b=KblJjAcXaFq9o9Qsb
	t8uMDzna5HueGMHputk9ncQ/B/tTa90T4tIY338T+oC00ZeIFnJy6sdTUh9izxQX
	IKtrspUu9iGDtvyfvLxiat/cjm72kkK9lXLG5u6h4c3iy14HqQk24cTsnHw0UMUf
	mutdkM5iRXViMraQM7u7+ahQNXQEc2vpEpAJySPutJkcN7sfLJmpHXiIpZXi/3yE
	mCND6FSOsXUnn/v4nZOa0RQij+3tj8UTFgX3coJSrS3+ZplyXndIc0HVM9LC7Oun
	UxIs7I9Dfms505JXvVz+oRhm2+EphcjfACxZC1mlaNhildgvjtwXSCz73p8c4Jm6
	cq9bg==
Received: from dc5-exch05.marvell.com ([199.233.59.128])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 4f8p31gqpv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 Jul 2026 22:58:55 -0700 (PDT)
Received: from DC5-EXCH05.marvell.com (10.69.176.209) by
 DC5-EXCH05.marvell.com (10.69.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 6 Jul 2026 22:58:55 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH05.marvell.com
 (10.69.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Mon, 6 Jul 2026 22:58:55 -0700
Received: from stgdev-a5u16.punelab.marvell.com (stgdev-a5u16.punelab.marvell.com [10.31.33.164])
	by maili.marvell.com (Postfix) with ESMTP id BDACE3F7066;
	Mon,  6 Jul 2026 22:58:52 -0700 (PDT)
From: Nilesh Javali <njavali@marvell.com>
To: <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <GR-FC-Storage-Upstream@marvell.com>,
        <agurumurthy@marvell.com>, <emilne@redhat.com>, <jmeneghi@redhat.com>,
        <hare@suse.com>
Subject: [PATCH v3 81/88] scsi: qla2xxx: Unlink NVMe unsol ctx before freeing on LS reject error
Date: Tue, 7 Jul 2026 11:24:28 +0530
Message-ID: <20260707055435.2680300-82-njavali@marvell.com>
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
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzA3MDA1NCBTYWx0ZWRfX0AfiHykSqZRA
 +PPKV+Ywmx8BToHATPF2CmG6/ubUknmqaXMBgw/1fvcNog4pAzT4u7FmzmhxmJpOK2Tc+M445jG
 b+/KY/O32mAjolZApufUIKpYlt6pBJU=
X-Proofpoint-GUID: kZjQzLIoOEx2BnC95b8qXkBk_2bqop6A
X-Proofpoint-ORIG-GUID: kZjQzLIoOEx2BnC95b8qXkBk_2bqop6A
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzA3MDA1NCBTYWx0ZWRfX2FxliCSppL2n
 BPilTXzkFNPA6hxq5iZUzWXVaaQAeeVfIx4fbhwtnLzNKceDOkQx7j99NST0SrBG2HQsbAqDyQu
 +e68o0DnG7gzSyVWm5hfxQ9xtJ+qpwtSkvOop509BPwU9zqoMKMuQ8Ed1h3V3Zs/8V6M8HXBrO3
 NnlxIMMpF16FnzvQkiCwkkwZ9a/CzA0vq+1OrKeUMx6iBAaPZyin45qHhRm3+MLTErFyzHRvzWW
 STCl2v3eezgem5dI2klzXg57dy2R4dTW2WmHYXWzxE49BM7X4rh14N+Fv4P4kL9RjETzVUMsOuB
 s1jD+/6H0TfjupxVGJmmKD5Cd6ca2vKSsasq/FfJxFik4CW03uOwGgJECywIWkrd++t8cIvg203
 UZNOP5SGGfZTZh3Usc9FE38IElnKzlqePeRTvAfpO4QOygtHIlrojpSlAf229yGellqnbgOjzrg
 uqmyD2O5if/5tlzEXCw==
X-Authority-Analysis: v=2.4 cv=c5ubhx9l c=1 sm=1 tr=0 ts=6a4c959f cx=c_pps
 a=rEv8fa4AjpPjGxpoe8rlIQ==:117 a=rEv8fa4AjpPjGxpoe8rlIQ==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=l0iWHRpgs5sLHlkKQ1IR:22
 a=EAYMVhzMl8SCOHhVQcBL:22 a=VwQbUJbxAAAA:8 a=1XWaLZrsAAAA:8 a=M5GUcnROAAAA:8
 a=kZ7mmqgNj_isLyQNFCwA:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-07_01,2026-07-06_02,2025-10-01_01

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

