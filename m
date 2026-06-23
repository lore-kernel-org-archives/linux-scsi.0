Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 431AC2D7DEF
	for <linux-scsi@vger.kernel.org>; Tue, 23 Jun 2026 10:03:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782209007; cv=none; b=OGUpMvfhoSlrmmKZSo/YVUhFSlWohk5mE8koyRGDQRMSIKQXXZ02HqSqfPxc4kULi9jFuk4+K6+i5m1I1Z0RU4u5KxXzGfdg8UyxtEFgxD3Sm3XOQ4tAc/rThcjZxqnWDqO2tCz8MilXhIWI+zmKCUhRFAC8LjEKywaTbObUNJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782209007; c=relaxed/simple;
	bh=OKb87YFMWhN3W/b5wbcO7Y8YdTyIHhwybBkxrAQNTOM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=SK8uyo3MkYcjAP95RJR6R25YLnDN4gKSaopRRwp8vcseLspgjwjWu1TTqb6oYLll7/RllWUED5NsHtEMzPSyX88ZwrSRKGAB4O+FY0xgd/npXnV1ceiT1MOz5K2b7UMzASiEJuCAol8q77uMU0ugSTIu0KlEK979kOcKzM4nzH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=dMUuvTV2; arc=none smtp.client-ip=220.197.31.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="dMUuvTV2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=p8
	ZiRZi6uQgz4G0kGxbRoM0WhSC1RI3+xFl6+93Fr+E=; b=dMUuvTV2tuZ0Mkc5Wl
	1BQI4IeVPPJw3phrDUXofwkISK6z0jpDZu/9esWSA/NMhA/hWh0tdRCH126Hy0Ez
	Nkd2vwWR0p/vvd8UEAyau7bCWfSteN05P7UT3+vj/2fYhM2wmt3aSoHD60R3+5xY
	n2SlAsKy2R1eoAnHNctKbsnrM=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g0-1 (Coremail) with SMTP id _____wAntXCaWTpqUiV6FA--.20165S5;
	Tue, 23 Jun 2026 18:02:07 +0800 (CST)
From: Yang Xiuwei <yangxiuwei@kylinos.cn>
To: martin.petersen@oracle.com,
	James.Bottomley@HansenPartnership.com
Cc: hare@suse.de,
	tom.leiming@gmail.com,
	p.raghav@samsung.com,
	dlemoal@kernel.org,
	sw.prabhu6@gmail.com,
	linux-scsi@vger.kernel.org,
	Yang Xiuwei <yangxiuwei@kylinos.cn>
Subject: [PATCH v1 3/4] scsi: sd: fix special_vec mempool leak when scsi_alloc_sgtables() fails
Date: Tue, 23 Jun 2026 18:01:58 +0800
Message-Id: <20260623100159.4018066-4-yangxiuwei@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260623100159.4018066-1-yangxiuwei@kylinos.cn>
References: <20260623100159.4018066-1-yangxiuwei@kylinos.cn>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wAntXCaWTpqUiV6FA--.20165S5
X-Coremail-Antispam: 1Uf129KBjvJXoWxury8uryDGw1ktFyUXr4Dtwb_yoWrCrW3pF
	WUZ3yay3yUXF4093s8ArZ5C3W5tr4IvrW7JFWag3yrur1ktrZ09F17Ja4FvFyrWr97AF18
	Jan2kF15uF4DA3JanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jk5r7UUUUU=
Sender: yangxiuwei2025@163.com
X-CM-SenderInfo: p1dqw55lxzvxisqskqqrwthudrp/xtbC6h+mN2o6WZ8+VwAA3b

sd_set_special_bvec() allocates a special payload page for UNMAP and
WRITE SAME commands.  If scsi_alloc_sgtables() fails afterward in
sd_setup_unmap_cmnd() or sd_setup_write_same{10,16}_cmnd(), the SCSI
midlayer does not call uninit_command() because RQF_DONTPREP is not
set yet, leaking the page.

Call sd_uninit_command() on error, and clear RQF_SPECIAL_PAYLOAD after
freeing the page.

Signed-off-by: Yang Xiuwei <yangxiuwei@kylinos.cn>
---
 drivers/scsi/sd.c | 47 ++++++++++++++++++++++++++++++-----------------
 1 file changed, 30 insertions(+), 17 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index b096ea237f14..6f05e7683df6 100644
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

