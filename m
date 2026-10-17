Received: from mail-m49201.qiye.163.com (mail-m49201.qiye.163.com [45.254.49.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA3F03812F4
	for <linux-scsi@vger.kernel.org>; Sat, 17 Oct 2026 01:36:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.254.49.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792201012; cv=none; b=tffhMDIzrXFudcL7Pagit3905rdFjDQGOVu5kXrrZ1k5E9hxdg7lgzVrB/WDTBLmZfVZww2cGg5OgaW71c9vLaEof0RCypvLOkwce7rGz58xpjdvXTK+gNOiV7S4yNdT5S3dgLA+HiKf4Ph5imvgXMg8Jwg+eQjAkUiY75LIX5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792201012; c=relaxed/simple;
	bh=grL2uJagHhCf4QF4AsAtetPFbzPIjW8QL81KEEFTU5I=;
	h=From:To:Cc:Subject:Date:Message-Id; b=lD6IzSH6xQDCcUWYJeahq1ob451vWDOqGUZWkqm8FardG97jHrGftZxSOA8BvNkp/uQ/KWWTdf6oaMBPtEDBRFqdoPYZX7iPlf2B0WtuIehal0hxewpQkbWNxMScGpEXansOrZjZvbvrVp5sbaCV/NA0DlZgyrHMcutTQLEKc+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rock-chips.com; spf=pass smtp.mailfrom=rock-chips.com; dkim=pass (1024-bit key) header.d=rock-chips.com header.i=@rock-chips.com header.b=I2uWPPbB; arc=none smtp.client-ip=45.254.49.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rock-chips.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rock-chips.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=rock-chips.com header.i=@rock-chips.com header.b="I2uWPPbB"
Received: from localhost.localdomain (unknown [61.154.14.86])
	by smtp.qiye.163.com (Hmail) with ESMTP id 515e2d1bb;
	Sat, 17 Oct 2026 09:21:21 +0800 (GMT+08:00)
From: Shawn Lin <shawn.lin@rock-chips.com>
To: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Bart Van Assche <bvanassche@acm.org>,
	Stanley Jhu <stanleyjhu@google.com>,
	linux-scsi@vger.kernel.org,
	Shawn Lin <shawn.lin@rock-chips.com>
Subject: [PATCH v2] scsi: ufs: core: Fix stale comment in ufshcd_mcq_config_nr_queues()
Date: Sat, 17 Oct 2026 09:21:09 +0800
Message-Id: <1792200069-141213-1-git-send-email-shawn.lin@rock-chips.com>
X-Mailer: git-send-email 2.7.4
X-HM-Tid: 0aa14772fcc403a4kunm3f7dac6e4f9548
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVkZSxgZVh5PTUpDTUoeTx9DQ1YVFA
	kWGhdVEwETFhoSFyQUDg9ZV1kYEgtZQVlNSlVKTk9VSk9VQ01ZV1kWGg8SFR0UWUFZT0tIVUpLSU
	9PT0hVSktLVUpCS0tZBg++
DKIM-Signature: a=rsa-sha256;
	b=I2uWPPbBjb1qhf1VA/PbuNYbhejnJNWaq3jikbabFADY70V1q2eCPPBARA+oGQOXfZctb2PFpUbO5l0v8/MukfqRFIj8eTnxYU9YDlvAnvTBOBF09wEiCBHCwqOgNbI6iz3R53kL6OoY1O66GGqPMiWxg/oANZBSmt7+NgBln9o=; c=relaxed/relaxed; s=default; d=rock-chips.com; v=1;
	bh=/MAQwcL+e1NylFCH7BFbmkYz1qxw7qa8K7xcSRCBsAk=;
	h=date:mime-version:subject:message-id:from;
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

The comment refers to "hba->dev_cmd_queue", but struct ufs_hba no longer
has such a member (it was removed when the dedicated hwq for device
commands was dropped). Reorder it to describe the actual requirement:
the queue is a host controller capability and it serves both non-polled
SCSI commands and UFS device management commands.

Signed-off-by: Shawn Lin <shawn.lin@rock-chips.com>
---

Changes in v2:
- address Bart's review comments

 drivers/ufs/core/ufs-mcq.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/ufs/core/ufs-mcq.c b/drivers/ufs/core/ufs-mcq.c
index df293b6..25e392f 100644
--- a/drivers/ufs/core/ufs-mcq.c
+++ b/drivers/ufs/core/ufs-mcq.c
@@ -183,8 +183,8 @@ static int ufshcd_mcq_config_nr_queues(struct ufs_hba *hba)
 	}
 
 	/*
-	 * Device should support at least one I/O queue to handle device
-	 * commands via hba->dev_cmd_queue.
+	 * At least one non-poll (HCTX_TYPE_DEFAULT) queue is required for
+	 * non-polled SCSI commands and UFS device management commands.
 	 */
 	if (hba_maxq == poll_queues) {
 		dev_err(hba->dev, "At least one non-poll queue required\n");
-- 
2.7.4

