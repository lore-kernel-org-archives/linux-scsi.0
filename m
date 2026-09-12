Received: from mail-m49197.qiye.163.com (mail-m49197.qiye.163.com [45.254.49.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AAFF2D8382;
	Sat, 12 Sep 2026 07:48:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.254.49.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789199294; cv=none; b=T/dOAgX0RNoU+dw8W3SA4+xbbSzXf0Qv+gGo2OALMlWeIdg/CIATYpBgF+O6Bama/iJlMY2KwEIBLpZPITllf5wt4SIBA4DVxBep5loT+heAOetcq9lVx1ZEtLaKY6axpJGOd2L68cl8XdMSrWhXEGq7pg5szF8aOVAo4sEKxFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789199294; c=relaxed/simple;
	bh=g+thXLaVzZeLKjj7wi7oagUK+H7sISWDAQKOPEGzHy0=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Ac8BrxQfW1UC2qY4KtWEWermGUy9nk0SLG1NKO1dn1e+Bm0AoUuNKY5H0I0MiRBeqQdaLw1EIfFxX4LFhNbYRkW5ip3tvk/0DDy5A5H1y2QmwV/8iHVZ5JdhXEyaJof1ccG3ACLgozjee6HAFk3+MtbRMihLGhVKw/sDbge8aV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=tju.edu.cn; spf=pass smtp.mailfrom=tju.edu.cn; dkim=pass (1024-bit key) header.d=tju.edu.cn header.i=@tju.edu.cn header.b=liQu4yD7; arc=none smtp.client-ip=45.254.49.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=tju.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tju.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=tju.edu.cn header.i=@tju.edu.cn header.b="liQu4yD7"
Received: from tju.edu.cn (gy-adaptive-ssl-proxy-1-entmail-virt204.gy.ntes [183.242.150.9])
	by smtp.qiye.163.com (Hmail) with ESMTP id 4d8263c19;
	Sat, 12 Sep 2026 15:47:54 +0800 (GMT+08:00)
From: Yibo Tan <lhfff@tju.edu.cn>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Cc: Wenchao Hao <haowenchao2@huawei.com>,
	Douglas Gilbert <dgilbert@interlog.com>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH v1] scsi: scsi_debug: Drain RCU callbacks before module exit
Date: Sat, 12 Sep 2026 15:47:37 +0800
Message-Id: <20260912074737.972055-1-lhfff@tju.edu.cn>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0aa0949650ab03a1kunmba0e1024207ae7
X-HM-MType: 10
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVlCTRpJVkMfSh4ZSkhDHxgdSVYeHw
	5VEwETFhoSFyQUDg9ZV1kYEgtZQVlKQ0hVSU9JVUpOS1VCWVdZFhoPEhUdFFlBWU9LSFVKS0lPT0
	9LVUpLS1VLWQY+
DKIM-Signature: a=rsa-sha256;
	b=liQu4yD7kKD/BFGg0wmr9vOjOc7ARkgsxlP+Wws7kR9jUtqNpqO5hDsXwpSMwDVYKRnKc2ywJkOMBlOXCACq11dARzu+lfBIATh4HKCW07/KbEkwTEsVHpaKPD4ZYXTKGLu8/mB1vWe2PARouBr5GYnx8/vpyFlVOjc1AsYYHVU=; c=relaxed/relaxed; s=default; d=tju.edu.cn; v=1;
	bh=0HcXmb4vP4kcSsXp8HlCncD4DDQeBwH68MBh/XEiDwc=;
	h=date:mime-version:subject:message-id:from;

Replacing or removing a debugfs error-injection rule queues
sdebug_err_free() through call_rcu(). Device teardown also queues this
callback for every remaining rule. The callback resides in scsi_debug
module text, but scsi_debug_exit() does not wait for queued callbacks
before returning.

With lazy, offloaded RCU callbacks enabled, two runs replaced the same
error-injection rule 16 times and successfully unloaded scsi_debug.
Eleven seconds later rcuop/0 executed at the former module text base plus
0x1f0, the exact ELF offset of sdebug_err_free(), and hit the module
unload poison.

Call rcu_barrier() after teardown has stopped future callback submissions
so that all queued callbacks finish before the module text is released.
Two runs with the fix completed the 30-second post-unload observation
without an Oops, KASAN report, warning or panic.

The tested scsi_debug.c is byte-identical to the file in current mainline
and the current SCSI for-next branch.

A source reproducer, kernel configuration, complete serial logs and the
vulnerable/fixed result table are available at:

https://github.com/kimaiden1984-boop/linux-kernel-poc-collections/tree/main/cases/scsi-debug-rcu-callback-after-unload

Fixes: a9996d722b11 ("scsi: scsi_debug: Add interface to manage error injection for a single device")
Cc: stable@vger.kernel.org
Assisted-by: Codex:GPT-5
Signed-off-by: Yibo Tan <lhfff@tju.edu.cn>
---
 drivers/scsi/scsi_debug.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 3346562275f8..2fdb1cbe470b 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -8676,6 +8676,7 @@ static void __exit scsi_debug_exit(void)
 	sdebug_erase_all_stores(false);
 	xa_destroy(per_store_ap);
 	debugfs_remove(sdebug_debugfs_root);
+	rcu_barrier();
 }
 
 device_initcall(scsi_debug_init);
-- 
2.39.5

