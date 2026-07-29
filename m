Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADF3C48CD6A
	for <linux-scsi@vger.kernel.org>; Wed, 29 Jul 2026 15:18:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785338339; cv=none; b=oz83N9woKD8mP1z+nL/1ddmwgOCjE54Ktm6mo2YTWQs6XtItCpG10WEy++3rG32ofX9vTY7nVoNjymwUFlwkpdXW3xKeW32sPGaNgb4zBLx/d+P4gwukb5c3M2oYsoJgNAild7EfYVIO4C46KM0QGOWKJWGQYPde/phCK1A22MY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785338339; c=relaxed/simple;
	bh=3ow+z/6wWglw+4fKnAnBMtsKFn8RcF3l466MOWhj7Xc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=pC13wDzZzKhpUcYPFJB/iSboWA636HNJc4XcaHf4gMbXLPI+eehwD3MZbyjUgMd9KhTg0BUwsxYbtM74ra6/IQD4H3UvYuT2UdxlARovWswhAOayXsvQxZrFrRw+oadgs+6/ISl9oZHR8gKybnFS/m/SA5zPrBmAJlZKoBToS5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=bJMD31RO; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="bJMD31RO"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66TDTP4f3322474;
	Wed, 29 Jul 2026 15:18:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2025-04-25; bh=EZuVMkwmCddOuoyh
	9wFheRl7enhYQzcSqGw7Mo44OBo=; b=bJMD31ROeV2YuF78JFT6U+zXiDOHysK3
	5SDERbOt4PANMhqnFUYRainbj7JgOJvHQxeUkJdlvLR75qIJujS5JhQhjFecPPcU
	lq/nWeakT06F/CEzvkC82nObQnmrjY29S31N290pfNT5mLZVvsZ1Pt4scHLF2btL
	PPDkS3aOMxuXDn1Ja7E2TWd8Ram6Fw7qtYUT7TrhB82uOta2gVOBWGYkjx5y/z9T
	iq8smUpq4+Jh3gTXutvwPQP7d9Oki+e0ijNWwG1TXNst+zmSWzMr4FSZ8MUUHHcM
	3f3aLBHqX2h+37PxF/oASwo4ImEnLMr/exAYPrVQbSRHbWDHbv/liA==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fmr0165vx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 29 Jul 2026 15:18:51 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66TFFIsT026999;
	Wed, 29 Jul 2026 15:18:51 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4fqjwu2h9m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 29 Jul 2026 15:18:51 +0000 (GMT)
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.1.12) with ESMTP id 66TFIosV040651;
	Wed, 29 Jul 2026 15:18:50 GMT
Received: from labops-common-sca-01.us.oracle.com (labops-common-sca-01.us.oracle.com [10.132.26.161])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 4fqjwu2h61-1;
	Wed, 29 Jul 2026 15:18:50 +0000 (GMT)
From: Dai Ngo <dai.ngo@oracle.com>
To: james.smart@broadcom.com, dick.kennedy@broadcom.com
Cc: linux-scsi@vger.kernel.org, dai.ngo@oracle.com
Subject: [PATCH 1/1] scsi: lpfc: Clear rport association before unregistering it
Date: Wed, 29 Jul 2026 08:18:33 -0700
Message-ID: <20260729151836.568056-1-dai.ngo@oracle.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-29_06,2026-07-29_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 mlxlogscore=999 spamscore=0 adultscore=0 malwarescore=0 lowpriorityscore=0
 phishscore=0 suspectscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2607290123
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI5MDEyMyBTYWx0ZWRfX9E7Qu2b8i7Ys
 o7n9hVPM8uFUP3xWRy3Zl1BRNApBPMLZ04itfID+0V3n4dJlcQ7OwUjj0XWL8wXJt4uH/T/AvTX
 Mbg3Sfv+XjA7xM/Hg01Pb9effTHBmM3F2KCAf5s50tOdTqwXLa7w
X-Proofpoint-GUID: -_ZYXdTwUAE7iuLyk3GLCbHD29YdjGM9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI5MDEyMyBTYWx0ZWRfX8WJ1vIPNucw5
 EJ9nobyL71RY8Vnh2uZRAgxnjgd49vyR3/9TfKgazTIhq4NE0fSx35i/TZKtP+5WwWjAY0S9bw9
 zRIdv1KehgZmnsSuE3YC1z7BQTOtkHNJ/AB4WSQtKRZ9rRM81mXgIVNh7zZphm5x90NpVVVEvL/
 uNv3YqdLz9Wr4cLIpBVVX4dW+09aJWIIhRjoZQ1KR4y2KAXsZwO+nNCPE75m+RUJi1/Yx7zA9g2
 9Jc28Gjkj9r3zwj/4aekKRDG08JvUvYf1tVvsXlCTqhyWUchE39+uNCC3ULYZ+msa7zGkeij9NY
 tp/AdmC0TI3aMfNdyPJ7HQqzA40HOkUEQrF+V4mrxygLFvAj5Dp78JsJeFAcZM0WB1ReVLMS57r
 cAOwsbJFMCBUxQ1bBGyft0PF/28jiBt0OqYWffsN31pbl5Y6GkA4IV+fvGQ6MNxC391uln+tpZh
 dlEw78VzvyjMSc6j04g==
X-Authority-Analysis: v=2.4 cv=KL1qylFo c=1 sm=1 tr=0 ts=6a6a19db b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x0eKOSpe3m1H3M0S9YoZ:22 a=yPCof4ZbAAAA:8
 a=Kl3EdFICxbgDYbn0s98A:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=WmVTiCyuxqgg3mnwYu6p:22
X-Proofpoint-ORIG-GUID: -_ZYXdTwUAE7iuLyk3GLCbHD29YdjGM9

System crashed when a Fibre Channel cable is removed from an
Emulex/Broadcom lpfc HBA.

The crash occurs after the lpfc Link Down event, after dm-multipath
fails paths, and when the FC remote ports time out and are removed.

[ 3214.903257] lpfc 0000:c1:00.0: 0:1305 Link Down Event x2 received Data: x2 x20 x200110 x0
[ 3225.070299] sd 19:0:5:254: rejecting I/O to offline device
[ 3225.070330] I/O error, dev sdm, sector 532480 op 0x0:(READ) flags 0x4200 phys_seg 16 prio class 2
[ 3225.070355] device-mapper: multipath: 252:10: Failing path 8:192.
...
[ 3245.037613]  rport-19:0-1: blocked FC remote port time out: removing rport
[ 3245.037651]  rport-19:0-0: blocked FC remote port time out: removing rport
[ 3245.549614]  rport-19:0-3: blocked FC remote port time out: removing rport
[ 3245.549632]  rport-19:0-2: blocked FC remote port time out: removing rport
[ 3245.550290] Oops: general protection fault, probably for non-canonical address 0x400d7115d1923c7a: 0000 [#1] PREEMPT SMP NOPTI
[ 3245.550309] CPU: 6 UID: 0 PID: 355 Comm: kworker/6:1 Kdump: loaded Not tainted 6.12.0-203.76.7.5.el9uek.x86_64 #2
[ 3245.550338] Workqueue: fc_wq_19 fc_rport_final_delete [scsi_transport_fc]
[ 3245.550360] RIP: 0010:lpfc_dev_loss_tmo_callbk+0x58/0x48d [lpfc]

Call trace:

lpfc_dev_loss_tmo_callbk+0x58/0x48d [lpfc]
fc_rport_final_delete+0xeb/0x1b0 [scsi_transport_fc]
process_one_work+0x174/0x31a
worker_thread+0x191/0x300
kthread+0xcf/0x100
ret_from_fork+0x31/0x50
ret_from_fork_asm+0x1a/0x30

The crash happened at this statement in lpfc_dev_loss_tmo_callbk():

phba  = vport->phba;

and vport has an invalid address, 0x400d7115d1923c7a.

The crash happened because rport->dd_data->pnode still pointed to an
ndlp, but that ndlp was no longer valid. If ndlp->vport is
0x400d7115d1923c7a, that is much more consistent with a stale/reused
ndlp object than with a valid node whose vport was separately freed. The
node pointer itself can still be canonical because it points into memory
that used to be an lpfc_nodelist; its contents are what became invalid.

This patch fixes the problem by detaching the node from the SCSI
remote port before calling fc_remote_port_delete(). Clear rdata->pnode,
ndlp->rport, and the SCSI transport registration flag while holding
ndlp->lock.

This prevents stale rport-to-node references and keeps the node’s
transport state consistent during remote-port teardown.

Assisted-by: Codex:gpt-5
Signed-off-by: Dai Ngo <dai.ngo@oracle.com>
---
 drivers/scsi/lpfc/lpfc_hbadisc.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index ecc9d6bcda32..f0329bb89e9a 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -4564,6 +4564,8 @@ lpfc_unregister_remote_port(struct lpfc_nodelist *ndlp)
 {
 	struct fc_rport *rport = ndlp->rport;
 	struct lpfc_vport *vport = ndlp->vport;
+	struct lpfc_rport_data *rdata;
+	unsigned long iflags;
 
 	if (vport->cfg_enable_fc4_type == LPFC_ENABLE_NVME)
 		return;
@@ -4578,6 +4580,14 @@ lpfc_unregister_remote_port(struct lpfc_nodelist *ndlp)
 			 ndlp->nlp_DID, rport, ndlp->fc4_xpt_flags,
 			 kref_read(&ndlp->kref));
 
+	rdata = rport->dd_data;
+	spin_lock_irqsave(&ndlp->lock, iflags);
+	if (rdata && rdata->pnode == ndlp)
+		rdata->pnode = NULL;
+	ndlp->rport = NULL;
+	ndlp->fc4_xpt_flags &= ~SCSI_XPT_REGD;
+	spin_unlock_irqrestore(&ndlp->lock, iflags);
+
 	fc_remote_port_delete(rport);
 	lpfc_nlp_put(ndlp);
 }
-- 
2.47.3

