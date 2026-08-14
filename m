Received: from zg8tmtyylji0my4xnjeumjiw.icoremail.net (zg8tmtyylji0my4xnjeumjiw.icoremail.net [162.243.161.220])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD2A223BD02;
	Fri, 14 Aug 2026 02:10:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=162.243.161.220
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786673464; cv=none; b=HhKgNP9MHNSlMASn+0C8sJ/tnYd7Hi5pyQ8/sOgMIqBQ7IO4pLJVEnUARzIHaRByTZmXfvXEyUbXeVFKfzLYnsS06jd/TFed5eZWA6fgSCoEza0R26bwAgCyrLZiORzHSrU+1SPQEWBVf/oRNf2c9ZcmVPvaY+0CzK4RAHNvSUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786673464; c=relaxed/simple;
	bh=3Fcf6Kx0n306uMDTAxjH61GxKV+jR6QAUhr9Zs+KTx0=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Cnzu0rCyVoMCRnGG206MB3HY82DF6UmUO/firOe0VapBXgmgaa7nVoK1gGebplLidwhRJocHmTy+bXXs85WWE/rHhm7xS6qtnd/FEx3ivbKPbKkNPmXENKjVf9m6wH4iyqJ5FO2DDFsspigNmDLj4SQHfWoI+81Q7ZKLdnYPKoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zju.edu.cn; spf=pass smtp.mailfrom=zju.edu.cn; arc=none smtp.client-ip=162.243.161.220
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zju.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zju.edu.cn
Received: from zju.edu.cn (unknown [10.98.66.117])
	by mtasvr (Coremail) with SMTP id _____wD3SGQkeX5qOD6QAA--.8685S3;
	Fri, 14 Aug 2026 10:10:45 +0800 (CST)
Received: from localhost.localdomain (unknown [10.98.66.117])
	by mail-app1 (Coremail) with SMTP id yy_KCgDXSKIkeX5qGuzaAw--.55549S2;
	Fri, 14 Aug 2026 10:10:44 +0800 (CST)
From: Fan Wu <fanwu01@zju.edu.cn>
To: linux-scsi@vger.kernel.org
Cc: varun@chelsio.com,
	martin.petersen@oracle.com,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Fan Wu <fanwu01@zju.edu.cn>
Subject: [PATCH v2] scsi: cxgbi: fix retry_timer use-after-free on adapter detach
Date: Fri, 14 Aug 2026 02:09:48 +0000
Message-Id: <20260814020948.197655-1-fanwu01@zju.edu.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:yy_KCgDXSKIkeX5qGuzaAw--.55549S2
X-CM-SenderInfo: qrstjiaswqq6lmxovvfxof0/
X-CM-DELIVERINFO: =?B?DEWopAXKKxbFmtjJiESix3B1w3vZ3A9ovKVTomAyoQazvoRs/NHSP8GI2EvgeEEW7R
	sfnVCjTgEH9dVomQuWcozCBBFPB19UtwVM6LbsmbjyGLlxpf0qPgx1VJ3/cQBwzrd4LoEX
	WyNzUKMzi2S6GFbcj6ap9E6mavGmQbzmcFsnzP86
X-Coremail-Antispam: 1Uk129KBj93XoWxuFy5ZF4fKF48GFy8JF1xCrX_yoWrAF1rpr
	4v9rWfA3W8XFWjqr1kCw4q9rWavwnaq34UGFyUA34a9a9xWryYgFW8GF42vF13JFWrJ3sr
	XF4Dtry5AF4DArbCm3ZEXasCq-sJn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUU9lb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AK
	xVW0oVCq3wAac4AC62xK8xCEY4vEwIxC4wAS0I0E0xvYzxvE52x082IY62kv0487Mc804V
	CY07AIYIkI8VC2zVCFFI0UMc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AK
	xVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48Icx
	kI7VAKI48JM4x0Y48IcxkI7VAKI48G6xCjnVAKz4kxMxAIw28IcxkI7VAKI48JMxC20s02
	6xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_Jr
	I_JrWlx4CE17CEb7AF67AKxVWUAVWUtwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v2
	6r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw20EY4v20xvaj4
	0_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVWUJVW8
	JbIYCTnIWIevJa73UjIFyTuYvjxU2LIDUUUUU

An active-open connection may keep retry_timer armed because
cxgbi_sock_closed() returns early in CTP_ACTIVE_OPEN state.  On adapter
detach, the timer callback can then dereference csk->cdev after cdev has
been freed.

Set CTPF_OFFLOAD_DOWN under csk->lock during portmap cleanup, reject new
retry_timer arming, and make an already queued callback a no-op while
offload is down.  A connection still in CTP_ACTIVE_OPEN is pushed through
cxgbi_sock_fail_act_open() so that its ATID, L2T entry, port mapping, and
final reference are released while cdev is still valid, rather than left
for the now-disabled retry timer.  timer_delete_sync() then drains a
pending or running callback before the final cxgbi_sock_put().

This issue was found by an in-house static analysis tool.

Fixes: 7b36b6e03b0d ("[SCSI] cxgb4i v5: iscsi driver")
Cc: stable@vger.kernel.org
Assisted-by: Codex:gpt-5.6
Signed-off-by: Fan Wu <fanwu01@zju.edu.cn>
---
Changes in v2:
 - drop the lldi/t4 deref-move in csk_act_open_retry_timer(): csk->cdev is
   always valid when the callback runs (timer_delete_sync drains before the
   cdev free), per Varun Prakash.

 drivers/scsi/cxgbi/cxgb3i/cxgb3i.c | 8 +++++++-
 drivers/scsi/cxgbi/cxgb4i/cxgb4i.c | 9 ++++++++-
 drivers/scsi/cxgbi/libcxgbi.c      | 6 +++++-
 3 files changed, 20 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c b/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c
index 69de965..f61f280 100644
--- a/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c
+++ b/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c
@@ -556,6 +556,11 @@ static void act_open_retry_timer(struct timer_list *t)
 
 	cxgbi_sock_get(csk);
 	spin_lock_bh(&csk->lock);
+	if (cxgbi_sock_flag(csk, CTPF_OFFLOAD_DOWN)) {
+		spin_unlock_bh(&csk->lock);
+		cxgbi_sock_put(csk);
+		return;
+	}
 	skb = alloc_wr(sizeof(struct cpl_act_open_req), 0, GFP_ATOMIC);
 	if (!skb)
 		cxgbi_sock_fail_act_open(csk, -ENOMEM);
@@ -585,7 +590,8 @@ static int do_act_open_rpl(struct t3cdev *tdev, struct sk_buff *skb, void *ctx)
 
 	cxgbi_sock_get(csk);
 	spin_lock_bh(&csk->lock);
-	if (rpl->status == CPL_ERR_CONN_EXIST &&
+	if (!cxgbi_sock_flag(csk, CTPF_OFFLOAD_DOWN) &&
+	    rpl->status == CPL_ERR_CONN_EXIST &&
 	    csk->retry_timer.function != act_open_retry_timer) {
 		csk->retry_timer.function = act_open_retry_timer;
 		mod_timer(&csk->retry_timer, jiffies + HZ / 2);
diff --git a/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c b/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
index 4267662..7c9b465 100644
--- a/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
+++ b/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
@@ -1001,6 +1001,12 @@ static void csk_act_open_retry_timer(struct timer_list *t)
 	cxgbi_sock_get(csk);
 	spin_lock_bh(&csk->lock);
 
+	if (cxgbi_sock_flag(csk, CTPF_OFFLOAD_DOWN)) {
+		spin_unlock_bh(&csk->lock);
+		cxgbi_sock_put(csk);
+		return;
+	}
+
 	if (t4) {
 		size = sizeof(struct cpl_act_open_req);
 		size6 = sizeof(struct cpl_act_open_req6);
@@ -1075,7 +1081,8 @@ static void do_act_open_rpl(struct cxgbi_device *cdev, struct sk_buff *skb)
 	cxgbi_sock_get(csk);
 	spin_lock_bh(&csk->lock);
 
-	if (status == CPL_ERR_CONN_EXIST &&
+	if (!cxgbi_sock_flag(csk, CTPF_OFFLOAD_DOWN) &&
+	    status == CPL_ERR_CONN_EXIST &&
 	    csk->retry_timer.function != csk_act_open_retry_timer) {
 		csk->retry_timer.function = csk_act_open_retry_timer;
 		mod_timer(&csk->retry_timer, jiffies + HZ / 2);
diff --git a/drivers/scsi/cxgbi/libcxgbi.c b/drivers/scsi/cxgbi/libcxgbi.c
index ea9631b..131d4f0 100644
--- a/drivers/scsi/cxgbi/libcxgbi.c
+++ b/drivers/scsi/cxgbi/libcxgbi.c
@@ -107,8 +107,12 @@ void cxgbi_device_portmap_cleanup(struct cxgbi_device *cdev)
 				csk, cdev);
 			spin_lock_bh(&csk->lock);
 			cxgbi_sock_set_flag(csk, CTPF_OFFLOAD_DOWN);
-			cxgbi_sock_closed(csk);
+			if (csk->state == CTP_ACTIVE_OPEN)
+				cxgbi_sock_fail_act_open(csk, -ENODEV);
+			else
+				cxgbi_sock_closed(csk);
 			spin_unlock_bh(&csk->lock);
+			timer_delete_sync(&csk->retry_timer);
 			cxgbi_sock_put(csk);
 		}
 	}
-- 
2.34.1

