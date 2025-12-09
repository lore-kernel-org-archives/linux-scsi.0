Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A28812F9C3D;
	Tue,  9 Dec 2025 09:41:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765273281; cv=none; b=DukKJpc6kLz+686F1loJLC5Q0X2MfrAiLUzfdm3tWhk+Q6mvXzWVZOy/UNdp36sdz7GFEtEiddH7AYfCP5ca0r4+VNtQDXV3F+lPNK9Cjt753ZCT65uwB/khiKSkBd+z0Opi8qnDM6lLD307gRqtaEy+i/XmnvbNQbTzxxfXyOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765273281; c=relaxed/simple;
	bh=Vm90kye16LJk72BgGUaZyGqMpsqhC9dBv7WxKjrVrjQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=JI/bi3zZlji1RBeKxxyKxzZlZhCjmoqm0iy05lkmaj8F5fMR7+gduYQnp+IMcgGmPH/g3+itRErLzOtY82ONSQjmKrSpHzg/aUA0GlNHSqDmMRYqOP0gaFpotDYLQV4nnT4qqHQavZ3B83NX4z6hobAYX3k94VuIXnbwiDB6QYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=Tu1ze+JL; arc=none smtp.client-ip=220.197.31.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="Tu1ze+JL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=5a
	65mO8Jnx7OcreNfyBaVRPjfvjZw9uzSDgqibPIXnw=; b=Tu1ze+JLR9jismZ/lo
	GLIo5Axi3RZHFMexKiLSpKIB7s87yuXIkdsrMQgvLNoRI/U2801nnDmsltOrTOrZ
	g74YW6KYTe4b9ltiKKsKF4Iaryj/UYuvhUgyd3lkMScGXlKJ103tPCvZnLB1jifa
	mKoSplO+yvoILHoVw68SQPooI=
Received: from hello.company.local (unknown [])
	by gzsmtp5 (Coremail) with SMTP id QCgvCgD3f32i7jdpXqDrGw--.123S2;
	Tue, 09 Dec 2025 17:40:52 +0800 (CST)
From: Liang Jie <buaajxlj@163.com>
To: Nilesh Javali <njavali@marvell.com>,
	GR-QLogic-Storage-Upstream@marvell.com (maintainer:QLOGIC QLA2XXX FC-SCSI DRIVER),
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org (open list:QLOGIC QLA2XXX FC-SCSI DRIVER),
	linux-kernel@vger.kernel.org (open list)
Cc: liangjie@lixiang.com
Subject: [PATCH] scsi: qla2xxx: refactor qla2x00_free_queues()
Date: Tue,  9 Dec 2025 17:40:43 +0800
Message-Id: <20251209094043.109194-1-buaajxlj@163.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:QCgvCgD3f32i7jdpXqDrGw--.123S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxAr1DZryUWFykWrW8Cr15Jwb_yoW5Xw15pF
	y8JrySya18JFWUC3y3tw48Wr9xKF4xK3y2krWxJas8tw1UZr90vr18AF93ZaykZrWkAr1x
	JF4Dtr9xKrsrJFUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jFFALUUUUU=
X-CM-SenderInfo: pexdtyx0omqiywtou0bp/1tbioAEfIGk36B1bewAAsV

From: Liang Jie <liangjie@lixiang.com>

qla2x00_free_queues() contains two nearly identical loops for
freeing request and response queues while temporarily dropping
ha->hardware_lock. Factor these loops into helpers to reduce
code duplication and improve readability.

While touching the function, rely on kfree(NULL) being a no-op
and drop redundant NULL checks before kfree().

No functional change intended.

Signed-off-by: Liang Jie <liangjie@lixiang.com>
---
 drivers/scsi/qla2xxx/qla_os.c | 43 +++++++++++++++++++++++------------
 1 file changed, 28 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 5ffd94586652..71140835511a 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -532,25 +532,15 @@ static void qla2x00_free_rsp_que(struct qla_hw_data *ha, struct rsp_que *rsp)
 	kfree(rsp);
 }
 
-static void qla2x00_free_queues(struct qla_hw_data *ha)
+static void qla2x00_free_req_queues(struct qla_hw_data *ha)
 {
-	struct req_que *req;
-	struct rsp_que *rsp;
-	int cnt;
 	unsigned long flags;
+	int cnt;
 
-	if (ha->queue_pair_map) {
-		kfree(ha->queue_pair_map);
-		ha->queue_pair_map = NULL;
-	}
-	if (ha->base_qpair) {
-		kfree(ha->base_qpair);
-		ha->base_qpair = NULL;
-	}
-
-	qla_mapq_free_qp_cpu_map(ha);
 	spin_lock_irqsave(&ha->hardware_lock, flags);
 	for (cnt = 0; cnt < ha->max_req_queues; cnt++) {
+		struct req_que *req;
+
 		if (!test_bit(cnt, ha->req_qid_map))
 			continue;
 
@@ -566,16 +556,24 @@ static void qla2x00_free_queues(struct qla_hw_data *ha)
 
 	kfree(ha->req_q_map);
 	ha->req_q_map = NULL;
+}
 
+static void qla2x00_free_rsp_queues(struct qla_hw_data *ha)
+{
+	unsigned long flags;
+	int cnt;
 
 	spin_lock_irqsave(&ha->hardware_lock, flags);
 	for (cnt = 0; cnt < ha->max_rsp_queues; cnt++) {
+		struct rsp_que *rsp;
+
 		if (!test_bit(cnt, ha->rsp_qid_map))
 			continue;
 
 		rsp = ha->rsp_q_map[cnt];
 		clear_bit(cnt, ha->rsp_qid_map);
-		ha->rsp_q_map[cnt] =  NULL;
+		ha->rsp_q_map[cnt] = NULL;
+
 		spin_unlock_irqrestore(&ha->hardware_lock, flags);
 		qla2x00_free_rsp_que(ha, rsp);
 		spin_lock_irqsave(&ha->hardware_lock, flags);
@@ -586,6 +584,21 @@ static void qla2x00_free_queues(struct qla_hw_data *ha)
 	ha->rsp_q_map = NULL;
 }
 
+static void qla2x00_free_queues(struct qla_hw_data *ha)
+{
+
+	kfree(ha->queue_pair_map);
+	ha->queue_pair_map = NULL;
+
+	kfree(ha->base_qpair);
+	ha->base_qpair = NULL;
+
+	qla_mapq_free_qp_cpu_map(ha);
+
+	qla2x00_free_req_queues(ha);
+	qla2x00_free_rsp_queues(ha);
+}
+
 static char *
 qla2x00_pci_info_str(struct scsi_qla_host *vha, char *str, size_t str_len)
 {
-- 
2.25.1

