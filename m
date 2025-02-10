Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 891342C9A
	for <linux-scsi@vger.kernel.org>; Mon, 10 Feb 2025 14:03:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739196224; cv=none; b=FqYeaiyINpDPNWG5okGG4BCYIOV731vrIrCaWzkq17/L4fWh6YeSHp++ezVx3CpY0eFI3WSB2Eey9DHq4PNfTpwFYZGYOTa0oNfKuR1Na6OjUDh1rdOawJ55eJpDhCg58ZgLPhYFts82mjpgikt/R2hf2qVlraQ3nn9OOPy4+R0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739196224; c=relaxed/simple;
	bh=MuQtOcke4hS/NtRT5UEdPP0OCJfqP6eejX2YfCYCjKU=;
	h=From:To:Subject:Date:Message-Id:MIME-Version; b=m/xlZVkQTQBeftdle+1M8dQCwldI0cYLrNONDaet/7T62oaeAIDquoiCkFUb8BFbctl26KX94uEj2/ZRn7Bc0jkpQGFfgnxRA4W3iF/Z/0FURJyrDUKdHuu/ntRCN/6d1vfMkGmXqPu+u3nxreJBOE3fubmKw+IZVZR4q4cDwQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4Ys5rc11Grz4f3kvm
	for <linux-scsi@vger.kernel.org>; Mon, 10 Feb 2025 22:03:12 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id C4D791A12F3
	for <linux-scsi@vger.kernel.org>; Mon, 10 Feb 2025 22:03:34 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.101.107])
	by APP4 (Coremail) with SMTP id gCh0CgBHq181B6pnuA7TDQ--.32340S4;
	Mon, 10 Feb 2025 22:03:34 +0800 (CST)
From: Ye Bin <yebin@huaweicloud.com>
To: jejb@linux.ibm.com,
	martin.petersen@oracle.com,
	linux-scsi@vger.kernel.org
Subject: [PATCH] scsi: core: clear driver private data when retry request
Date: Mon, 10 Feb 2025 22:03:33 +0800
Message-Id: <20250210140333.3899021-1-yebin@huaweicloud.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgBHq181B6pnuA7TDQ--.32340S4
X-Coremail-Antispam: 1UD129KBjvJXoWxAF4rWFW8Ar4fJF4rWr45Jrb_yoW5Gw1fpF
	W5J34jkr48GFW8u393XryUXFy5K393Zryjga43WwsxXFnYkrW0yF18AFy5XayfWr18Awnx
	JF4qqr9xWFZrAr7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUgGb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Cr0_Gr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I
	0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
	x7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
	0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Y
	z7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zV
	AF1VAY17CE14v26r1Y6r17MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4l
	IxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCw
	CI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnI
	WIevJa73UjIFyTuYvjxUzsqWUUUUU
X-CM-SenderInfo: p1hex046kxt4xhlfz01xgou0bp/

From: Ye Bin <yebin10@huawei.com>

After commit 1bad6c4a57ef
("scsi: zero per-cmd private driver data for each MQ I/O"),
xen-scsifront/virtio_scsi/snic driver remove code that zeroes
driver-private command data. If request do retry will lead to
driver-private command data remains. Before commit 464a00c9e0ad
("scsi: core: Kill DRIVER_SENSE") if virtio_scsi do capacity
expansion, first request may return UA then request will do retry,
as driver-private command data remains, request will return UA
again. As a result, the request keeps retrying, and the request
times out and fails.
So zeroes driver-private command data when request do retry.

Fixes: f7de50da1479 ("scsi: xen-scsifront: Remove code that zeroes driver-private command data")
Fixes: c2bb87318baa ("scsi: virtio_scsi: Remove code that zeroes driver-private command data")
Fixes: c3006a926468 ("scsi: snic: Remove code that zeroes driver-private command data")
Signed-off-by: Ye Bin <yebin10@huawei.com>
---
 drivers/scsi/scsi_lib.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index be0890e4e706..5b0c109c89bb 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1645,6 +1645,17 @@ static unsigned int scsi_mq_inline_sgl_size(struct Scsi_Host *shost)
 		sizeof(struct scatterlist);
 }
 
+static inline void scsi_clear_lld_private_data(struct scsi_cmnd *cmd,
+					       struct Scsi_Host *shost)
+{
+	/*
+	 * Only clear the driver-private command data if the LLD does not supply
+	 * a function to initialize that data.
+	 */
+	if (!shost->hostt->init_cmd_priv && shost->hostt->cmd_size)
+		memset(cmd + 1, 0, shost->hostt->cmd_size);
+}
+
 static blk_status_t scsi_prepare_cmd(struct request *req)
 {
 	struct scsi_cmnd *cmd = blk_mq_rq_to_pdu(req);
@@ -1669,12 +1680,7 @@ static blk_status_t scsi_prepare_cmd(struct request *req)
 	if (in_flight)
 		__set_bit(SCMD_STATE_INFLIGHT, &cmd->state);
 
-	/*
-	 * Only clear the driver-private command data if the LLD does not supply
-	 * a function to initialize that data.
-	 */
-	if (!shost->hostt->init_cmd_priv)
-		memset(cmd + 1, 0, shost->hostt->cmd_size);
+	scsi_clear_lld_private_data(cmd, shost);
 
 	cmd->prot_op = SCSI_PROT_NORMAL;
 	if (blk_rq_bytes(req))
@@ -1848,6 +1854,7 @@ static blk_status_t scsi_queue_rq(struct blk_mq_hw_ctx *hctx,
 			goto out_dec_host_busy;
 		req->rq_flags |= RQF_DONTPREP;
 	} else {
+		scsi_clear_lld_private_data(cmd, shost);
 		clear_bit(SCMD_STATE_COMPLETE, &cmd->state);
 	}
 
-- 
2.34.1

