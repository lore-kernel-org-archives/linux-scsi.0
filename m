Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5AD83B813E;
	Mon, 22 Jun 2026 16:03:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782144197; cv=none; b=eqohcuT6ji8uRRCpI9W8IQ8PrPM7lxmF2eTF6Pzk3/Be8FphYdJ17gpFmPLaPs8dCT+25sQk3g0UUJX6HZgiJgyQ5uKdjUmN12bEEixlLOscSLdHrkzeqv4ORSrqOoYj2X/QH/C3WFXt6zgnlO1waof4km9gk07fKdWXCz12SfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782144197; c=relaxed/simple;
	bh=CjD+vGT37ZD2GNibib+XXmJ8o+rPm4uh2uzYx4RKyV4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=b8ILyP5DAsSNtBv7xke1Cqqjkx2d5QI67iFO2yVrAp5UdOsRNVjanlvIqH1IzYvPw8a5d46NLYqA1vpMgkaOY5P5p1191t3/8kYcAheqLYFWwAxvzfqiGaJdLVPp4aJd/7w+tsEWdHI8LvGEfonWmBmszOreU5tTyZ8IsvtRiwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=ErWPPGi3; arc=none smtp.client-ip=220.197.31.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="ErWPPGi3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=XK
	wfDLMQf7QmdYOFbWbMVo6rLQFVf1YCx9DHx24sjBo=; b=ErWPPGi3bpYvbhukTL
	C2rykH4seQUCHaYpt0VwEam5SVDnNO+NZzfhg3aJw1RPUUOO4/98r0lcIvqKLp9g
	PFz4no4RNsxVDOKwUhQTn3d8vE9pVFpdv8S2brHOZwvOyOU8F814u9U/e47jOlOl
	L0zov5NI1wEti6pNMvfxL4244=
Received: from localhost.localdomain (unknown [])
	by gzsmtp5 (Coremail) with SMTP id QCgvCgD33yYcXDlqcx0uDg--.62978S2;
	Tue, 23 Jun 2026 00:00:30 +0800 (CST)
From: Haoxiang Li <haoxiang_li2024@163.com>
To: James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	david.carroll@microsemi.com,
	justin.lindley@microsemi.com,
	scott.teel@microsemi.com
Cc: storagedev@microchip.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Haoxiang Li <haoxiang_li2024@163.com>,
	stable@vger.kernel.org
Subject: [PATCH] scsi: hpsa: fix DMA mapping leak on IOACCEL2 reset path
Date: Tue, 23 Jun 2026 00:00:28 +0800
Message-Id: <20260622160028.1240496-1-haoxiang_li2024@163.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:QCgvCgD33yYcXDlqcx0uDg--.62978S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrKF45Jr18XryxGrWrGrWxWFg_yoWDCrc_Wa
	4vvryIyr4kCFn2g3Z8JrWavFWav3WkXryS9F1Fqwn3Z345Zr4xZr1kZFsavr1kWF48Ar98
	X3Z09rWFkr48ZjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7sRRmFA3UUUUU==
X-CM-SenderInfo: xkdr5xpdqjszblsqjki6rwjhhfrp/xtbCxR4HdWo5XB7jMAAA3r

If phys_disk->in_reset is set, the function returns directly without
undoing the resources acquired for the command. Add the missing error
cleanup by unmapping the IOACCEL2 SG chain block when needed, unmapping
the SCSI command, and dropping the outstanding IOACCEL command count
before returning.

Fixes: c5dfd106414f ("scsi: hpsa: correct device resets")
Cc: stable@vger.kernel.org
Signed-off-by: Haoxiang Li <haoxiang_li2024@163.com>
---
 drivers/scsi/hpsa.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index a1b116cd4723..8edad1830abe 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -5017,6 +5017,10 @@ static int hpsa_scsi_ioaccel2_queue_command(struct ctlr_info *h,
 
 	if (phys_disk->in_reset) {
 		cmd->result = DID_RESET << 16;
+		atomic_dec(&phys_disk->ioaccel_cmds_out);
+		scsi_dma_unmap(cmd);
+		if (use_sg > h->ioaccel_maxsg)
+			hpsa_unmap_ioaccel2_sg_chain_block(h, cp);
 		return -1;
 	}
 
-- 
2.25.1

