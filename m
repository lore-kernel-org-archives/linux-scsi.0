Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B8AA4337B8A;
	Wed,  5 Nov 2025 19:26:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762370775; cv=none; b=WqRgG184IyXL+nyrCAAhjo8ZgCX267y1k9LxAS37N1os2qwMxM7vGtb+b21oeGX5Yl1KO99DDHTIbe76tVh/SYjE5zIrUgpPIt6F4KBVGmA1NQvHQ1ax2+4u+hrXI4+Jy7mfZImA/So9RBX4++eY9Ln7fGjhmZPMBMFjJKUdwk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762370775; c=relaxed/simple;
	bh=DnMeviyIHL9MNXlXL17dpbvtIa98MhYHZjzTmzW0aWM=;
	h=From:To:Cc:Subject:Date:Message-Id; b=N5exhn0WduHQFjedX+2/SUvyKc00AdGw0uDwYeMXxcxi5l8Jhj1oiPsoA0S9at9CgYdmkybirUgB9qgR2lJqpjxiad/7MBGJdNK7WXQ5U+7x40X/ftmrWRBXjDh1TSrVCSjMusdqxWVi0XNbbebe8fTWAto3fmNxmEz4dN+6MZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=szZ7VTo5; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="szZ7VTo5"
Received: by linux.microsoft.com (Postfix, from userid 1216)
	id 4BA64211D8C4; Wed,  5 Nov 2025 11:26:08 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 4BA64211D8C4
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1762370768;
	bh=2lFtOpeRZk2+ajTE+dUyUaLdWRZFLKksVcvXucUYrk4=;
	h=From:To:Cc:Subject:Date:From;
	b=szZ7VTo5KvM5Pifk8KaY1RBndcR76cZc5QQASavvx0Q9gE337vW+MVoj1SGOg2al4
	 1sor2OPtFMt17oAuAN03GMvcWsP7NhPZd8YXwpq+Y6q+aiaEUzvdcOJF7WzhRFsFDs
	 yEQngRPdmZ6jR4QQ0cUneWuFokrj9vxL3c4n39FQ=
From: Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>
To: linux-kernel@vger.kernel.org
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
	Guixin Liu <kanie@linux.alibaba.com>,
	Nicholas Bellinger <nab@linux-iscsi.org>,
	Sheng Yang <sheng@yasker.org>,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	Allen Pais <apais@linux.microsoft.com>,
	Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>,
	stable@vger.kernel.org
Subject: [PATCH] scsi: target: tcm_loop: fix segfault in tcm_loop_tpg_address_show()
Date: Wed,  5 Nov 2025 11:25:46 -0800
Message-Id: <1762370746-6304-1-git-send-email-hamzamahfooz@linux.microsoft.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

If the allocation of tl_hba->sh fails in tcm_loop_driver_probe() and we
attempt to dereference it in tcm_loop_tpg_address_show() we will get a
segfault, see below for an example. So, check tl_hba->sh before
dereferencing it.

  Unable to allocate struct scsi_host
  BUG: kernel NULL pointer dereference, address: 0000000000000194
  #PF: supervisor read access in kernel mode
  #PF: error_code(0x0000) - not-present page
  PGD 0 P4D 0
  Oops: 0000 [#1] PREEMPT SMP NOPTI
  CPU: 1 PID: 8356 Comm: tokio-runtime-w Not tainted 6.6.104.2-4.azl3 #1
  Hardware name: Microsoft Corporation Virtual Machine/Virtual Machine, BIOS Hyper-V UEFI Release v4.1 09/28/2024
  RIP: 0010:tcm_loop_tpg_address_show+0x2e/0x50 [tcm_loop]
...
  Call Trace:
   <TASK>
   configfs_read_iter+0x12d/0x1d0 [configfs]
   vfs_read+0x1b5/0x300
   ksys_read+0x6f/0xf0
...

Cc: stable@vger.kernel.org
Fixes: 2628b352c3d4 ("tcm_loop: Show address of tpg in configfs")
Signed-off-by: Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>
---
 drivers/target/loopback/tcm_loop.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback/tcm_loop.c
index c7b7da629741..01a8e349dc4d 100644
--- a/drivers/target/loopback/tcm_loop.c
+++ b/drivers/target/loopback/tcm_loop.c
@@ -894,6 +894,9 @@ static ssize_t tcm_loop_tpg_address_show(struct config_item *item,
 			struct tcm_loop_tpg, tl_se_tpg);
 	struct tcm_loop_hba *tl_hba = tl_tpg->tl_hba;
 
+	if (!tl_hba->sh)
+		return -ENODEV;
+
 	return snprintf(page, PAGE_SIZE, "%d:0:%d\n",
 			tl_hba->sh->host_no, tl_tpg->tl_tpgt);
 }
-- 
2.49.0

