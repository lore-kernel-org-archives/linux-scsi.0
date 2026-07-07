Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20E2F3803D9
	for <linux-scsi@vger.kernel.org>; Tue,  7 Jul 2026 03:04:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783393455; cv=none; b=YCmvS1vdirk9lbHeSsqFOY5zczdnomyKNdv380wVAV9uFh22KaY16OBxNA5zENEbhbcE48qZOubNUVzLsIWib/GLboAwY6bOxdOGe93n5lrBhpqoU2Wc7zPxssE77lI1KDH2IDMAdXKpOHKu/AXQBneHbtw0jGEexwmVKdEjecA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783393455; c=relaxed/simple;
	bh=B5q5E3AJt6EtJsUDDXTOadrJgwejKUp7BM/ejsJSUG8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=AWrojM79SSb5JfLbUq9RBLwVujhLWupviJ1iElYpr+JXkw1GeY4nNtaXZzjkP8321i+kjyWQ5GNf026+LKWAupgpNKgy/1MxYJVJ3NkdIe43bsig/d2rasQ312lTgw1d3jN/yb54tcBl54dO9GSPCUlaISi9zJgpsnzN3sAqr3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=dzdxpZ9h; arc=none smtp.client-ip=220.197.31.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="dzdxpZ9h"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=GB
	ySsxjj9dMe8wuTccpUuu3M6BPGJgny/+B1v0qZB5Q=; b=dzdxpZ9h9ZKmzHPKuG
	tMIkGdmxBlstS33+vZaddyQ9E5nwJf3RUHVR/k5DZjCv3rES9PVeS6G5Jb4SShRE
	bzO3VW0PWq5CW+kFy9z5fppCKdz61FFir20cCQm2SoNqNlqo6WsrI/ZUtgtmsw6x
	pfIB6+IGupwg8PUSnQr1TO1NU=
Received: from localhost.localdomain (unknown [])
	by gzsmtp5 (Coremail) with SMTP id QCgvCgD3HB2HbExqrYb5Fw--.30099S4;
	Tue, 07 Jul 2026 11:03:40 +0800 (CST)
From: Yang Xiuwei <yangxiuwei@kylinos.cn>
To: James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: dlemoal@kernel.org,
	linux-scsi@vger.kernel.org,
	Yang Xiuwei <yangxiuwei@kylinos.cn>
Subject: [PATCH v2 2/3] scsi: sd: fix special_vec mempool leak when scsi_alloc_sgtables() fails
Date: Tue,  7 Jul 2026 11:03:32 +0800
Message-Id: <20260707030333.22245-3-yangxiuwei@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260707030333.22245-1-yangxiuwei@kylinos.cn>
References: <20260707030333.22245-1-yangxiuwei@kylinos.cn>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:QCgvCgD3HB2HbExqrYb5Fw--.30099S4
X-Coremail-Antispam: 1Uf129KBjvJXoWxury8uryDGw1ktFyUJFyftFb_yoWrZrW8pF
	WUZ3yayw4UXF4093s8ArWrC3W5tr4IvrW7JFWag3yrur1ktrZ09F17Ja4FvF1rWr97JF18
	Jan2kF15uFs8A3JanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jvjgcUUUUU=
Sender: yangxiuwei2025@163.com
X-CM-SenderInfo: p1dqw55lxzvxisqskqqrwthudrp/xtbCwgzrfGpMbIwEdAAA3v

sd_set_special_bvec() allocates a special payload page for UNMAP and
WRITE SAME commands. If scsi_alloc_sgtables() fails afterward in
sd_setup_unmap_cmnd() or sd_setup_write_same{10,16}_cmnd(), the SCSI
midlayer does not call uninit_command() because RQF_DONTPREP is not
set yet, leaking the page.

Call sd_uninit_command() on error, and clear RQF_SPECIAL_PAYLOAD after
freeing the page.

Fixes: 81d926e8b552 ("sd: split sd_setup_discard_cmnd")
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Yang Xiuwei <yangxiuwei@kylinos.cn>
---
 drivers/scsi/sd.c | 47 ++++++++++++++++++++++++++++++-----------------
 1 file changed, 30 insertions(+), 17 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index d18693d390b2..8fed1cda9ac8 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -958,6 +958,21 @@ static unsigned char sd_setup_protect_cmnd(struct scsi_cmnd *scmd,
 	return protect;
 }
 
+static void sd_uninit_command(struct scsi_cmnd *cmd)
+{
+	struct request *rq = scsi_cmd_to_rq(cmd);
+	struct scsi_device *sdp = cmd->device;
+
+	if (!(rq->rq_flags & RQF_SPECIAL_PAYLOAD))
+		return;
+
+	if (sdp->sector_size > PAGE_SIZE)
+		mempool_free(rq->special_vec.bv_page, sd_large_page_pool);
+	else
+		mempool_free(rq->special_vec.bv_page, sd_page_pool);
+	rq->rq_flags &= ~RQF_SPECIAL_PAYLOAD;
+}
+
 static void *sd_set_special_bvec(struct scsi_cmnd *cmd, unsigned int data_len)
 {
 	struct page *page;
@@ -990,6 +1005,7 @@ static blk_status_t sd_setup_unmap_cmnd(struct scsi_cmnd *cmd)
 	u32 nr_blocks = sectors_to_logical(sdp, blk_rq_sectors(rq));
 	unsigned int data_len = 24;
 	char *buf;
+	blk_status_t ret;
 
 	buf = sd_set_special_bvec(cmd, data_len);
 	if (!buf)
@@ -1008,7 +1024,10 @@ static blk_status_t sd_setup_unmap_cmnd(struct scsi_cmnd *cmd)
 	cmd->transfersize = data_len;
 	rq->timeout = SD_TIMEOUT;
 
-	return scsi_alloc_sgtables(cmd);
+	ret = scsi_alloc_sgtables(cmd);
+	if (ret != BLK_STS_OK)
+		sd_uninit_command(cmd);
+	return ret;
 }
 
 static void sd_config_atomic(struct scsi_disk *sdkp, struct queue_limits *lim)
@@ -1079,6 +1098,7 @@ static blk_status_t sd_setup_write_same16_cmnd(struct scsi_cmnd *cmd,
 	u64 lba = sectors_to_logical(sdp, blk_rq_pos(rq));
 	u32 nr_blocks = sectors_to_logical(sdp, blk_rq_sectors(rq));
 	u32 data_len = sdp->sector_size;
+	blk_status_t ret;
 
 	if (!sd_set_special_bvec(cmd, data_len))
 		return BLK_STS_RESOURCE;
@@ -1094,7 +1114,10 @@ static blk_status_t sd_setup_write_same16_cmnd(struct scsi_cmnd *cmd,
 	cmd->transfersize = data_len;
 	rq->timeout = unmap ? SD_TIMEOUT : SD_WRITE_SAME_TIMEOUT;
 
-	return scsi_alloc_sgtables(cmd);
+	ret = scsi_alloc_sgtables(cmd);
+	if (ret != BLK_STS_OK)
+		sd_uninit_command(cmd);
+	return ret;
 }
 
 static blk_status_t sd_setup_write_same10_cmnd(struct scsi_cmnd *cmd,
@@ -1106,6 +1129,7 @@ static blk_status_t sd_setup_write_same10_cmnd(struct scsi_cmnd *cmd,
 	u64 lba = sectors_to_logical(sdp, blk_rq_pos(rq));
 	u32 nr_blocks = sectors_to_logical(sdp, blk_rq_sectors(rq));
 	u32 data_len = sdp->sector_size;
+	blk_status_t ret;
 
 	if (!sd_set_special_bvec(cmd, data_len))
 		return BLK_STS_RESOURCE;
@@ -1121,7 +1145,10 @@ static blk_status_t sd_setup_write_same10_cmnd(struct scsi_cmnd *cmd,
 	cmd->transfersize = data_len;
 	rq->timeout = unmap ? SD_TIMEOUT : SD_WRITE_SAME_TIMEOUT;
 
-	return scsi_alloc_sgtables(cmd);
+	ret = scsi_alloc_sgtables(cmd);
+	if (ret != BLK_STS_OK)
+		sd_uninit_command(cmd);
+	return ret;
 }
 
 static blk_status_t sd_setup_write_zeroes_cmnd(struct scsi_cmnd *cmd)
@@ -1550,20 +1577,6 @@ static blk_status_t sd_init_command(struct scsi_cmnd *cmd)
 	}
 }
 
-static void sd_uninit_command(struct scsi_cmnd *SCpnt)
-{
-	struct request *rq = scsi_cmd_to_rq(SCpnt);
-	struct scsi_device *sdp = SCpnt->device;
-	unsigned sector_size = sdp->sector_size;
-
-	if (rq->rq_flags & RQF_SPECIAL_PAYLOAD) {
-		if (sector_size > PAGE_SIZE)
-			mempool_free(rq->special_vec.bv_page, sd_large_page_pool);
-		else
-			mempool_free(rq->special_vec.bv_page, sd_page_pool);
-	}
-}
-
 static bool sd_need_revalidate(struct gendisk *disk, struct scsi_disk *sdkp)
 {
 	if (sdkp->device->removable || sdkp->write_prot) {
-- 
2.25.1

