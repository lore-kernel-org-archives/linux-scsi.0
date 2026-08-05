Received: from azure-sdnproxy.icoremail.net (azure-sdnproxy.icoremail.net [13.75.44.102])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 63CA6185B48;
	Wed,  5 Aug 2026 01:33:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.75.44.102
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785893604; cv=none; b=W7Y7yuTEYKXquiBsa71fsPzwogQN7iZxu37wk8QAKF/a/28fX7NkLFIaEKumZQRFV4Lzq2RjvSuPXtFW+zIO01JG0/IQ38ixsCqOAGTks0PY+3pcAcMwwp+MkfNUD45o5rvPH5qvfo/KdUjalASBTDX4F8nHZ8bJpnTL2i70ecw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785893604; c=relaxed/simple;
	bh=vuQtUnNd5B28FH52rbKEWw0P4sYp+fJyhhv42v9nr00=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=u4nhBOezhL3W3o4heo0J+usYuvCzsxh4bi05Dx2V9q9VCUJffu1GtzG76gE2qs9LFv2TEPGYJ2tbjb2kOE8GRNq41NN0LAi2IoW+jakx+6h/C6dF+rNmxvfBV2PYCHPVDUmh+cHNf4uUV6RHT7jQhRC423yUtj9BnmpNK69I23c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zju.edu.cn; spf=pass smtp.mailfrom=zju.edu.cn; arc=none smtp.client-ip=13.75.44.102
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zju.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zju.edu.cn
Received: from zju.edu.cn (unknown [10.98.66.117])
	by mtasvr (Coremail) with SMTP id _____wCngX7RknJqtQBnAA--.15856S3;
	Wed, 05 Aug 2026 09:33:06 +0800 (CST)
Received: from localhost.localdomain (unknown [10.98.66.117])
	by mail-app3 (Coremail) with SMTP id zS_KCgAXLnDQknJq3y32Aw--.5050S2;
	Wed, 05 Aug 2026 09:33:04 +0800 (CST)
From: Fan Wu <fanwu01@zju.edu.cn>
To: linux-scsi@vger.kernel.org
Cc: varun@chelsio.com,
	martin.petersen@oracle.com,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Fan Wu <fanwu01@zju.edu.cn>
Subject: [PATCH] scsi: cxgbi: fix retry_timer use-after-free on adapter detach
Date: Wed,  5 Aug 2026 01:32:09 +0000
Message-Id: <20260805013209.418861-1-fanwu01@zju.edu.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:zS_KCgAXLnDQknJq3y32Aw--.5050S2
X-CM-SenderInfo: qrstjiaswqq6lmxovvfxof0/
X-CM-DELIVERINFO: =?B?1S3uTgXKKxbFmtjJiESix3B1w3vZ3A9ovKVTomAyoQazvoRs/NHSP8GI2EvgeEEW7R
	sfnZPoDCNGYdHSfuFmYJL54WMpcZFuujMJwCDvwaMcSqxBcX7/HWNWgOBaLn58eKGGfCQQ
	YHe2G4eddGfQIWZE4wk=
X-Coremail-Antispam: 1Uk129KBj93XoWxuFy5ZF4fKF48GFy8Jw1rKrX_yoWrAFy8pF
	4v93yfA3W8tFWjqr4kCw4q9FWavwnaq34UGF17A34a9asxWr1YgFW8GF17ZF13JFWrJr9r
	XF4qqry5CF4DArbCm3ZEXasCq-sJn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUU9Gb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AK
	xVW0oVCq3wAac4AC62xK8xCEY4vEwIxC4wAS0I0E0xvYzxvE52x082IY62kv0487Mc804V
	CY07AIYIkI8VC2zVCFFI0UMc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AK
	xVWUXVWUAwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48Icx
	kI7VAKI48JM4x0Y48IcxkI7VAKI48G6xCjnVAKz4kxMxAIw28IcxkI7VAKI48JMxC20s02
	6xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_Jr
	I_JrWlx4CE17CEb7AF67AKxVWUAVWUtwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v2
	6r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj4
	0_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8
	JrUvcSsGvfC2KfnxnUUI43ZEXa7IU8I_M3UUUUU==

An active-open connection may keep retry_timer armed because
cxgbi_sock_closed() returns early in CTP_ACTIVE_OPEN state.  On adapter
detach, the timer callback can then dereference csk->cdev after cdev has
been freed.

Set CTPF_OFFLOAD_DOWN under csk->lock during portmap cleanup, reject new
retry_timer arming, and make an already queued callback return without
dereferencing csk->cdev.  timer_delete_sync() then drains a pending or
running callback before the final cxgbi_sock_put().

This issue was found by an in-house static analysis tool.

Fixes: 7b36b6e03b0d ("[SCSI] cxgb4i v5: iscsi driver")
Cc: stable@vger.kernel.org
Assisted-by: Codex:gpt-5.6
Signed-off-by: Fan Wu <fanwu01@zju.edu.cn>
---
 drivers/scsi/cxgbi/cxgb3i/cxgb3i.c |  8 +++++++-
 drivers/scsi/cxgbi/cxgb4i/cxgb4i.c | 16 +++++++++++++---
 drivers/scsi/cxgbi/libcxgbi.c      |  1 +
 3 files changed, 21 insertions(+), 4 deletions(-)

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
index 4267662..3e80345 100644
--- a/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
+++ b/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
@@ -989,10 +989,10 @@ static void csk_act_open_retry_timer(struct timer_list *t)
 {
 	struct sk_buff *skb = NULL;
 	struct cxgbi_sock *csk = timer_container_of(csk, t, retry_timer);
-	struct cxgb4_lld_info *lldi = cxgbi_cdev_priv(csk->cdev);
+	struct cxgb4_lld_info *lldi;
 	void (*send_act_open_func)(struct cxgbi_sock *, struct sk_buff *,
 				   struct l2t_entry *);
-	int t4 = is_t4(lldi->adapter_type), size, size6;
+	int t4, size, size6;
 
 	log_debug(1 << CXGBI_DBG_TOE | 1 << CXGBI_DBG_SOCK,
 		"csk 0x%p,%u,0x%lx,%u.\n",
@@ -1001,6 +1001,15 @@ static void csk_act_open_retry_timer(struct timer_list *t)
 	cxgbi_sock_get(csk);
 	spin_lock_bh(&csk->lock);
 
+	if (cxgbi_sock_flag(csk, CTPF_OFFLOAD_DOWN)) {
+		spin_unlock_bh(&csk->lock);
+		cxgbi_sock_put(csk);
+		return;
+	}
+
+	lldi = cxgbi_cdev_priv(csk->cdev);
+	t4 = is_t4(lldi->adapter_type);
+
 	if (t4) {
 		size = sizeof(struct cpl_act_open_req);
 		size6 = sizeof(struct cpl_act_open_req6);
@@ -1075,7 +1084,8 @@ static void do_act_open_rpl(struct cxgbi_device *cdev, struct sk_buff *skb)
 	cxgbi_sock_get(csk);
 	spin_lock_bh(&csk->lock);
 
-	if (status == CPL_ERR_CONN_EXIST &&
+	if (!cxgbi_sock_flag(csk, CTPF_OFFLOAD_DOWN) &&
+	    status == CPL_ERR_CONN_EXIST &&
 	    csk->retry_timer.function != csk_act_open_retry_timer) {
 		csk->retry_timer.function = csk_act_open_retry_timer;
 		mod_timer(&csk->retry_timer, jiffies + HZ / 2);
diff --git a/drivers/scsi/cxgbi/libcxgbi.c b/drivers/scsi/cxgbi/libcxgbi.c
index ea9631b..76dd1e3 100644
--- a/drivers/scsi/cxgbi/libcxgbi.c
+++ b/drivers/scsi/cxgbi/libcxgbi.c
@@ -109,6 +109,7 @@ void cxgbi_device_portmap_cleanup(struct cxgbi_device *cdev)
 			cxgbi_sock_set_flag(csk, CTPF_OFFLOAD_DOWN);
 			cxgbi_sock_closed(csk);
 			spin_unlock_bh(&csk->lock);
+			timer_delete_sync(&csk->retry_timer);
 			cxgbi_sock_put(csk);
 		}
 	}
-- 
2.34.1

