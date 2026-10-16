Received: from mail-m127174.xmail.ntesmail.com (mail-m127174.xmail.ntesmail.com [115.236.127.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C81C9369208
	for <linux-scsi@vger.kernel.org>; Fri, 16 Oct 2026 06:44:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.236.127.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792133080; cv=none; b=B43yW0tBZ/sf7CeBzjhkaGGveM50utHGH1Oat/Qr66Shw4qwhiCII/uVX72pQshvxaEpXvI8crKIGdTkjH/Mwq05gZmUnToociLWPr0t0VJbPt6InDLlv3esWsAhb2hOiXtJzo57xyHs2X9E4I+WEPAtQ+UKqMs6zPyY1YoGCAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792133080; c=relaxed/simple;
	bh=OpTb5ZrV4O1WfgJmHckF0Y+kv6zsta7xdyjIaBbwj3c=;
	h=From:To:Cc:Subject:Date:Message-Id; b=gwhAUJOJxndT6BQcPpCs6gPYXGgGfsFcdvNed0bdGKuf7EhvLaTEe7Hj/fHk/EtJ5fEEykOaPnkgjcw8GsU7mKsKc/9vQ83P1ncYM4duEIkUmYuBHnaw3cjYEEiTFMfUKnGrb0BBh4LvY3IQCoxbXlNdG11oyxzQoRqxzqpeNEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rock-chips.com; spf=pass smtp.mailfrom=rock-chips.com; dkim=pass (1024-bit key) header.d=rock-chips.com header.i=@rock-chips.com header.b=eHTsZLxV; arc=none smtp.client-ip=115.236.127.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rock-chips.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rock-chips.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=rock-chips.com header.i=@rock-chips.com header.b="eHTsZLxV"
Received: from localhost.localdomain (unknown [58.22.7.114])
	by smtp.qiye.163.com (Hmail) with ESMTP id 51467c7a8;
	Fri, 16 Oct 2026 14:44:26 +0800 (GMT+08:00)
From: Shawn Lin <shawn.lin@rock-chips.com>
To: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Bart Van Assche <bvanassche@acm.org>,
	linux-scsi@vger.kernel.org,
	Shawn Lin <shawn.lin@rock-chips.com>
Subject: [PATCH] scsi: ufs: core: Fix stale comment in ufshcd_mcq_config_nr_queues()
Date: Fri, 16 Oct 2026 14:44:13 +0800
Message-Id: <1792133053-143069-1-git-send-email-shawn.lin@rock-chips.com>
X-Mailer: git-send-email 2.7.4
X-HM-Tid: 0aa143746be503a4kunm27f1569e47df80
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFDSUNOT01LS0k3V1kYFggdWUFKV1ktWUFJV1kPCRoVCBIfWUFZQ0JMTFYeQx8aGk9KQ0
	xMSUNWFRQJFhoXVRMBExYaEhckFA4PWVdZGBILWUFZTkNVSUlVTFVKSk9ZV1kWGg8SFR0UWUFZT0
	tIVUpLSU9PT0hVSktLVUpCS0tZBg++
DKIM-Signature: a=rsa-sha256;
	b=eHTsZLxVnOWId991uaIuY3TFwYXDIATbvwfCqesLXP9X40LItYOfqrUabxPE+7idVOsAwrGwsdJJv9rUJ3dHUAdhWa2ZM71Bs5zJ7fPCVRLLfXjP83IiuyeWhtv2DtK1lpbxy3Bss+XLswlLfLTibEh8OG4HU1Rb5MEFVDW1LhY=; c=relaxed/relaxed; s=default; d=rock-chips.com; v=1;
	bh=2lf1DsMcldSamdD0mKwe7Po9TrsK+cajrAJDFOgiKHY=;
	h=date:mime-version:subject:message-id:from;
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

The comment refers to "hba->dev_cmd_queue", but struct ufs_hba no longer
has such a member (it was removed when the dedicated hwq for device
commands was dropped). Device commands still need a non-poll I/O queue to
be handled, so drop the stale member reference and just say so.

Fixes: 08b12cda6c44 ("scsi: ufs: core: Switch to scsi_get_internal_cmd()")
Signed-off-by: Shawn Lin <shawn.lin@rock-chips.com>
---

 drivers/ufs/core/ufs-mcq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufs-mcq.c b/drivers/ufs/core/ufs-mcq.c
index df293b6..15401e1 100644
--- a/drivers/ufs/core/ufs-mcq.c
+++ b/drivers/ufs/core/ufs-mcq.c
@@ -184,7 +184,7 @@ static int ufshcd_mcq_config_nr_queues(struct ufs_hba *hba)
 
 	/*
 	 * Device should support at least one I/O queue to handle device
-	 * commands via hba->dev_cmd_queue.
+	 * commands, which cannot be handled by a poll queue.
 	 */
 	if (hba_maxq == poll_queues) {
 		dev_err(hba->dev, "At least one non-poll queue required\n");
-- 
2.7.4

