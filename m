Received: from zg8tmja2lje4os43os4xodqa.icoremail.net (zg8tmja2lje4os43os4xodqa.icoremail.net [206.189.79.184])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 341FC36212C;
	Mon, 10 Aug 2026 05:51:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=206.189.79.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786341094; cv=none; b=YUcZbwEjNyVJ3+eH6CC/4NNgtHzTMCox2tQWXxakWcbwCr6i6yEOflpMdGkA4Iq+h0KAfz7pIneuI/iaRAJw28M1acD3LISyHHwx00sYExbCz2sL2gvNavreOOb63wGO3M8nI5da+6e0+FDLljK2oRIHbYmuBVgWgXh8BBFvUyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786341094; c=relaxed/simple;
	bh=sqMvHD90TLMozFbzzw4PP+UuKP9eQERepXtf8rWM1vc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=WSFqn5/ljs4wZKgt2v133u0BHsequzXHmlDbSCuwGr8x4MjByJ0fABlNsx/JiWgMsjkhHeKuzULh7RM50lwku5UO8pwXJpsVHBZfaZSUwHt8Y1SwywWrafWh/05hYKsyepPK9YtrkwdX9DE5rgN771sKgUQHa0aJxt7VBQTwh04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zju.edu.cn; spf=pass smtp.mailfrom=zju.edu.cn; arc=none smtp.client-ip=206.189.79.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zju.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zju.edu.cn
Received: from zju.edu.cn (unknown [10.98.66.117])
	by mtasvr (Coremail) with SMTP id _____wD3_y_cZnlqRXN+AA--.33690S3;
	Mon, 10 Aug 2026 13:51:25 +0800 (CST)
Received: from localhost.localdomain (unknown [10.98.66.117])
	by mail-app3 (Coremail) with SMTP id zS_KCgBXb3HbZnlq5q0tBA--.42268S2;
	Mon, 10 Aug 2026 13:51:24 +0800 (CST)
From: Fan Wu <fanwu01@zju.edu.cn>
To: Oliver Neukum <oliver@neukum.org>,
	Ali Akcaagac <aliakc@web.de>,
	Jamie Lenehan <lenehan@twibble.org>
Cc: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH] scsi: dc395x: sync the waiting_timer before freeing the host
Date: Mon, 10 Aug 2026 05:50:28 +0000
Message-Id: <20260810055028.119525-1-fanwu01@zju.edu.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:zS_KCgBXb3HbZnlq5q0tBA--.42268S2
X-CM-SenderInfo: qrstjiaswqq6lmxovvfxof0/
X-CM-DELIVERINFO: =?B?/B3A8QXKKxbFmtjJiESix3B1w3vZ3A9ovKVTomAyoQazvoRs/NHSP8GI2EvgeEEW7R
	sfnZPoDCNGYdHSfuFmYJL54WM5adWvqgWZ9GpCNvi6cFw1ZBqU+PqqA7yfZZxp4pA7+kq4
	Y9WhF078IYKEnNodepup9E6mavGmQbzmcFsnzP86
X-Coremail-Antispam: 1Uk129KBj93XoW7uw4xAF13KF1ktr1rZr4xuFX_yoW8ur4fpa
	y8Ww12kr1jqr42kw4xGws7XFyrZan3JrWDGFW8Ka1YvFs3JryayF9xKF9FvFWaya93JF47
	AFn0q3W5Arn8CrbCm3ZEXasCq-sJn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUU9lb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AK
	xVW0oVCq3wAac4AC62xK8xCEY4vEwIxC4wAS0I0E0xvYzxvE52x082IY62kv0487Mc804V
	CY07AIYIkI8VC2zVCFFI0UMc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AK
	xVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48Icx
	kI7VAKI48JM4x0Y48IcxkI7VAKI48G6xCjnVAKz4kxMxAIw28IcxkI7VAKI48JMxC20s02
	6xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_Jr
	I_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v2
	6r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw20EY4v20xvaj4
	0_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVWUJVW8
	JbIYCTnIWIevJa73UjIFyTuYvjxU7gAwDUUUU

The waiting_timer callback re-arms itself and takes the host lock.
adapter_uninit() currently stops it with timer_delete(), which does not
wait for a callback already running on another CPU. The final
scsi_host_put() that frees the host (and the host lock the callback
dereferences) runs right after adapter_uninit(), so a concurrent or just
re-armed callback can fire after the free, leaving a potential
use-after-free window.

Replace timer_delete() with timer_shutdown_sync() and move it after
free_irq(), outside the host-lock section. This waits for a running
callback and prevents it from re-arming, while avoiding the self-deadlock
that would result from syncing a callback blocked on the lock we still
hold.

selto_timer is left untouched; it has no reachable armer or callback.

This issue was found by an in-house static analysis tool.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Cc: Jamie Lenehan <lenehan@twibble.org>
Assisted-by: Codex:gpt-5.6
Signed-off-by: Fan Wu <fanwu01@zju.edu.cn>
---
 drivers/scsi/dc395x.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/dc395x.c b/drivers/scsi/dc395x.c
index 6183ce05d..3e85d422c 100644
--- a/drivers/scsi/dc395x.c
+++ b/drivers/scsi/dc395x.c
@@ -3816,18 +3816,14 @@ static void adapter_uninit(struct AdapterCtlBlk *acb)
 	unsigned long flags;
 	DC395x_LOCK_IO(acb->scsi_host, flags);
 
-	/* remove timers */
-	if (timer_pending(&acb->waiting_timer))
-		timer_delete(&acb->waiting_timer);
-	if (timer_pending(&acb->selto_timer))
-		timer_delete(&acb->selto_timer);
-
 	adapter_uninit_chip(acb);
 	adapter_remove_and_free_all_devices(acb);
 	DC395x_UNLOCK_IO(acb->scsi_host, flags);
 
 	if (acb->irq_level)
 		free_irq(acb->irq_level, acb);
+	/* waiting_timer self-rearms and takes host_lock: sync outside lock. */
+	timer_shutdown_sync(&acb->waiting_timer);
 	if (acb->io_port_base)
 		release_region(acb->io_port_base, acb->io_port_len);
 

