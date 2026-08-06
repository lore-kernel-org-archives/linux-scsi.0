Received: from mail-m155101.qiye.163.com (mail-m155101.qiye.163.com [101.71.155.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42E7B392C2C;
	Thu,  6 Aug 2026 06:07:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=101.71.155.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785996440; cv=none; b=JQz8OYQMz3wM6we7DgRASQK5Jw7Oz7HmExZhytkR0Nqf48rcxpLb4vd3qIKQRZAoAlKmoYOAQ6QTLkfugu7AX1m4AuLO7sbB2oha3F+bgC5cJp5IEH9mW49viOlFXncv+75PzuuOc03MCUXdyqKzAp5fho9lXvCDJyN4anJrCYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785996440; c=relaxed/simple;
	bh=hyPQtiHro7wxbRPeXTXPYqRSLQbn+uE3ClaCeaHtJVs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=qua7OzKHZGWYj9YgFfVS7BOs99kN8sn8a5tdud2HeANrX2vxglQ5HuJRwGU9ZcrsAhUTZ84xn+tfNY1fUjK96CSbP0hT2WaKoDBN2+E0ikbvltB9TaUwdtfYwhv28dHH+YI+33wMw/zENIRNGsClGHtwoKocmKBqbqhzrUzvCLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn; spf=pass smtp.mailfrom=seu.edu.cn; dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b=WElJtQBL; arc=none smtp.client-ip=101.71.155.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b="WElJtQBL"
Received: from LAPTOP-99KJFSET (unknown [36.153.54.46])
	by smtp.qiye.163.com (Hmail) with ESMTP id 48fb94a39;
	Thu, 6 Aug 2026 14:07:11 +0800 (GMT+08:00)
From: Hongyan Xu <getshell@seu.edu.cn>
To: Hannes Reinecke <hare@kernel.org>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	jianhao.xu@seu.edu.cn,
	Hongyan Xu <getshell@seu.edu.cn>
Subject: [PATCH] scsi: myrb: quiesce the SCSI host before controller teardown
Date: Thu,  6 Aug 2026 14:06:58 +0800
Message-ID: <20260806060659.1852-1-getshell@seu.edu.cn>
X-Mailer: git-send-email 2.50.1.windows.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0a9fd5aec11603a1kunm3e92b3632893b2
X-HM-MType: 10
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVlCTU1DVhodHhlOGUMdSEJISlYeHw
	5VEwETFhoSFyQUDg9ZV1kYEgtZQVlITVVKTkhVTk9VT01ZV1kWGg8SFR0UWUFZT0tIVUpLSEpPSE
	xVSktLVUpCS0tZBg++
DKIM-Signature: a=rsa-sha256;
	b=WElJtQBLEE5tROFTnnmLCg3zCvFHBs53a+T0SWpHsG226lHeIIYKzgBJqQwARPks/SxapFWs3U71NTKSMveo1+psYegbWs7WGvN/or+G6ScxB6UegMC2XOHzHOQWLJTd5wl5nKY3toa82lrqBRgtSAAxtw9vUJCyv3MZlcanPIk=; s=default; c=relaxed/relaxed; d=seu.edu.cn; v=1;
	bh=wjjPyxuElG9dN2jTOZKl+YpGlEq6FiIH3VlGJADeS44=;
	h=date:mime-version:subject:message-id:from;

myrb_remove() tears down the controller resources and drops the host
reference without first removing the SCSI host. The registered host can
therefore continue to dispatch queuecommand callbacks that use the
controller MMIO mappings and DMA pools after teardown. The monitor work is
also canceled only after the MMIO mappings have been released.

Remove the SCSI host before issuing the final controller command. Then stop
the monitor and destroy its pools before unmapping the hardware and
dropping the host reference.

Fixes: 081ff398c56c ("scsi: myrb: Add Mylex RAID controller (block interface)")
Cc: stable@vger.kernel.org
Signed-off-by: Hongyan Xu <getshell@seu.edu.cn>
---
 drivers/scsi/myrb.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/myrb.c b/drivers/scsi/myrb.c
index 3678b66310ed..adb2fadf9146 100644
--- a/drivers/scsi/myrb.c
+++ b/drivers/scsi/myrb.c
@@ -3496,9 +3496,10 @@ static void myrb_remove(struct pci_dev *pdev)
 	struct myrb_hba *cb = pci_get_drvdata(pdev);
 
 	shost_printk(KERN_NOTICE, cb->host, "Flushing Cache...");
+	scsi_remove_host(cb->host);
 	myrb_exec_type3(cb, MYRB_CMD_FLUSH, 0);
-	myrb_cleanup(cb);
 	myrb_destroy_mempools(cb);
+	myrb_cleanup(cb);
 }
 
 
-- 
2.50.1.windows.1

