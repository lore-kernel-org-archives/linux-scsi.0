Received: from zg8tmtyylji0my4xnjeumjiw.icoremail.net (zg8tmtyylji0my4xnjeumjiw.icoremail.net [162.243.161.220])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 018D32E7378;
	Fri, 11 Sep 2026 02:06:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=162.243.161.220
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789092421; cv=none; b=fBpqvxOpvEIUdTv2a48q1+gP56d/SMf4QE4tI41Z+f+MEyOxMIcI96y87RcTx7oviQDg/zIeSjhkRQmh8JPrj+W1fGaRkgI5g4T5VU8M+6mbD61SiRzllYp8uVbkwlOsJn1WXaFthuxs0+gq3bLlrp3nxodWSemd3Zv++nr8f5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789092421; c=relaxed/simple;
	bh=1dtU5TOUa1+dyx1hn5t0NaQeaDgdhBqRisH1DuW5npI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=CH6byATNzZZc49lZH+M+jTWpB2Y9Rk81ASaqL9Xym2Zgcj6K7c6xbHC8bClcq9RYro43IjaqYfVLSw2H1Nf+uwiqzW9u2QSh4kbUO6D7aRKZne5SK5Au0aaRqDacUDb/0UFfZXBxbU/CBs39//jaQYasX38fCAMTwG+m2ZjNb2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zju.edu.cn; spf=pass smtp.mailfrom=zju.edu.cn; arc=none smtp.client-ip=162.243.161.220
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zju.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zju.edu.cn
Received: from zju.edu.cn (unknown [10.98.66.117])
	by mtasvr (Coremail) with SMTP id _____wCHgD8zYqNqgokIAQ--.3500S3;
	Fri, 11 Sep 2026 10:06:44 +0800 (CST)
Received: from localhost.localdomain (unknown [10.98.66.117])
	by mail-app2 (Coremail) with SMTP id zC_KCgB3CtEyYqNquF5tBA--.35527S2;
	Fri, 11 Sep 2026 10:06:42 +0800 (CST)
From: Fan Wu <fanwu01@zju.edu.cn>
To: oliver@neukum.org,
	aliakc@web.de,
	lenehan@twibble.org
Cc: James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH v2] scsi: dc395x: sync the waiting_timer before freeing the host
Date: Fri, 11 Sep 2026 02:05:44 +0000
Message-Id: <20260911020544.42966-1-fanwu01@zju.edu.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:zC_KCgB3CtEyYqNquF5tBA--.35527S2
X-CM-SenderInfo: qrstjiaswqq6lmxovvfxof0/
X-CM-DELIVERINFO: =?B?Ss9SQwXKKxbFmtjJiESix3B1w3vZ3A9ovKVTomAyoQazvoRs/NHSP8GI2EvgeEEW7R
	sfncGSG+szpQCInt5Y8rbJUI2Ua2YcfOqAp+ssWdS7x5LHL3VMvLoD1QUFpGgVgVF9+ilW
	lzWXXeHfR2Um9GD+FCmp9E6mavGmQbzmcFsnzP86
X-Coremail-Antispam: 1Uk129KBj93XoW7uw4xAF13KF1ktr17JrWUAwc_yoW8KryDpa
	ykWw17KF1jqr47tw47Cr4kWFyrAws3JFWDKFW8Wa15uan3Gr1YyF98KFyjvFW7Aan5XFn7
	AF4kX3Z8Arn0krcCm3ZEXasCq-sJn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7ZEXa
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

Replace timer_delete() with timer_shutdown_sync() at the top of
adapter_uninit(), before the host-lock section: the timer is dequeued,
a running callback is waited for and rearming is blocked before the chip
is halted, so it cannot fire at all once the adapter has ceased to
function. Waiting outside the lock avoids the self-deadlock that would
result from syncing a callback blocked on the lock we still hold.

No shutdown is needed for selto_timer because it has no reachable armer
or callback.

This issue was found by an in-house static analysis tool.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Cc: Jamie Lenehan <lenehan@twibble.org>
Assisted-by: Codex:gpt-5.6
Signed-off-by: Fan Wu <fanwu01@zju.edu.cn>
---
v2:
  - Move timer_shutdown_sync() before adapter_uninit_chip(), as
    suggested by Oliver Neukum.
v1: https://lore.kernel.org/all/20260810055028.119525-1-fanwu01@zju.edu.cn/

 drivers/scsi/dc395x.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/dc395x.c b/drivers/scsi/dc395x.c
index 6183ce05d..fcd4c0029 100644
--- a/drivers/scsi/dc395x.c
+++ b/drivers/scsi/dc395x.c
@@ -3814,13 +3814,11 @@ static void adapter_uninit_chip(struct AdapterCtlBlk *acb)
 static void adapter_uninit(struct AdapterCtlBlk *acb)
 {
 	unsigned long flags;
-	DC395x_LOCK_IO(acb->scsi_host, flags);
 
-	/* remove timers */
-	if (timer_pending(&acb->waiting_timer))
-		timer_delete(&acb->waiting_timer);
-	if (timer_pending(&acb->selto_timer))
-		timer_delete(&acb->selto_timer);
+	/* Drain the self-rearming timer; must not run under host_lock. */
+	timer_shutdown_sync(&acb->waiting_timer);
+
+	DC395x_LOCK_IO(acb->scsi_host, flags);
 
 	adapter_uninit_chip(acb);
 	adapter_remove_and_free_all_devices(acb);
-- 
2.34.1

