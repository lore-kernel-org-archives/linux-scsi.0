Received: from canpmsgout09.his.huawei.com (canpmsgout09.his.huawei.com [113.46.200.224])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3C0B3E5EFE;
	Mon, 19 Oct 2026 12:56:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.224
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792414575; cv=none; b=dEbEolbkNZ+zRXkVccMINXWi/AnxIJ21hjArL9jyDN+OYNtmWgudjioiAg8butPredNJmG6BTe3/WBPixdi9xwARaa7VCAaOGhH3vLx29Y5xbMq0CqVGbv5pMlmLAKQ0u6qLmqrKfhhJXhRgUbTxz4n5MNTd+85YbquUaKfG1e0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792414575; c=relaxed/simple;
	bh=crk7VfoalPA0gtTg/lNvIHd10uvXsJGx07qKigugTU4=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=fCbq4VQUHBR4J09ehIwt2ClkMsEm5pExrd1ehOyXUKhctKTiiA+YFy7zKiq1/sUTiBdb7W0sbUl0t35zTeSsKCciXm10Wo2rf6uVYyY/Y1zkT/FDLSf2aolZ4l9EjtHqTLGw1y1NBGZMwEBP5dJpYQN6F4fnoxW+GavtAh2NEFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=AE5aVXDS; arc=none smtp.client-ip=113.46.200.224
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="AE5aVXDS"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=t+37Qq5NohTHS3WvQuxMQxd4B6klHpzbe2eEyFRDLAA=;
	b=AE5aVXDSQG/dx5rEjVjvfgp/i3L8e49ATnmOygUJEnYLivycOhQh5YroRWE7znAWg0ONqBoDq
	VpvteGlJxPKiFNBnz/EYs3TI0RZ9V3TrZ0CXfvFUhGeCYl2y1loTMUpp6+gnai3+d3/pUJHE10i
	8u+srmUKYOESVHo2wgC6ids=
Received: from mail.maildlp.com (unknown [172.19.163.163])
	by canpmsgout09.his.huawei.com (SkyGuard) with ESMTPS id 4j7Zxv0JSnz1cyTX;
	Mon, 19 Oct 2026 20:44:51 +0800 (CST)
Received: from kwepemf100017.china.huawei.com (unknown [7.202.181.16])
	by mail.maildlp.com (Postfix) with ESMTPS id 95D414057A;
	Mon, 19 Oct 2026 20:56:09 +0800 (CST)
Received: from localhost.localdomain (10.50.85.155) by
 kwepemf100017.china.huawei.com (7.202.181.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Mon, 19 Oct 2026 20:56:08 +0800
From: Zizhi Wo <wozizhi@huawei.com>
To: <njavali@marvell.com>, <GR-QLogic-Storage-Upstream@marvell.com>,
	<James.Bottomley@HansenPartnership.com>, <mkp@kernel.org>,
	<linux-scsi@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <yangerkun@huawei.com>,
	<chengzhihao1@huawei.com>, <wozizhi@huawei.com>
Subject: [PATCH] scsi: qla2xxx: Fix BSG vendor overlays missed by request_len validation
Date: Mon, 19 Oct 2026 20:48:56 +0800
Message-ID: <20261019124856.1495867-1-wozizhi@huawei.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 kwepemf100017.china.huawei.com (7.202.181.16)

Commit 4cf38dd94657 ("scsi: qla2xxx: Validate BSG request_len before
reading vendor_cmd[]") added a central check in
qla2x00_process_vendor_specific() and per-handler checks for the
vendor_cmd[] accesses, but it missed two handlers that compute the same
request offset with pointer arithmetic:

	ql84_mgmt  = (void *)bsg_request + sizeof(struct fc_bsg_request);
	port_param = (void *)bsg_request + sizeof(struct fc_bsg_request);

qla84xx_mgmt_cmd() overlays struct qla_bsg_a84_mgmt at offset 20 and reads
mgmt.mgmtp at offset 24 and mgmt.len at offset 36. The structure is 20
bytes long, so the handler needs request_len >= 40, while the central check
only guarantees 24 bytes (sizeof(struct fc_bsg_request) + sizeof(u32)).
qla24xx_iidma() has the same problem with struct qla_port_param.

Validate the full overlay structure in both handlers.

Fixes: 01e0e15c8b3b ("scsi: don't use fc_bsg_job::request and fc_bsg_job::reply directly")
Signed-off-by: Zizhi Wo <wozizhi@huawei.com>
---
 drivers/scsi/qla2xxx/qla_bsg.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.c
index ab559048dbb8..e86ab83300b5 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -1159,10 +1159,14 @@ qla84xx_mgmt_cmd(struct bsg_job *bsg_job)
 		ql_log(ql_log_warn, vha, 0x703a,
 		    "Not 84xx, exiting.\n");
 		return -EINVAL;
 	}
 
+	if (bsg_job->request_len <
+	    sizeof(struct fc_bsg_request) + sizeof(struct qla_bsg_a84_mgmt))
+		return -EINVAL;
+
 	mn = dma_pool_zalloc(ha->s_dma_pool, GFP_KERNEL, &mn_dma);
 	if (!mn) {
 		ql_log(ql_log_warn, vha, 0x703c,
 		    "DMA alloc failed for fw buffer.\n");
 		return -ENOMEM;
@@ -1351,10 +1355,14 @@ qla24xx_iidma(struct bsg_job *bsg_job)
 	if (!IS_IIDMA_CAPABLE(vha->hw)) {
 		ql_log(ql_log_info, vha, 0x7046, "iiDMA not supported.\n");
 		return -EINVAL;
 	}
 
+	if (bsg_job->request_len <
+	    sizeof(struct fc_bsg_request) + sizeof(struct qla_port_param))
+		return -EINVAL;
+
 	port_param = (void *)bsg_request + sizeof(struct fc_bsg_request);
 	if (port_param->fc_scsi_addr.dest_type != EXT_DEF_TYPE_WWPN) {
 		ql_log(ql_log_warn, vha, 0x7048,
 		    "Invalid destination type.\n");
 		return -EINVAL;
-- 
2.52.0

