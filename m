Received: from cstnet.cn (smtp21.cstnet.cn [159.226.251.21])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2018239D6EC;
	Fri, 26 Jun 2026 16:14:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782490448; cv=none; b=uo01pXyeV6HhCCAh2LA1xwNxk0LE2IKQPyHtb6xOgD1Wurl5FiTHrkK9NCSkibDOjgkBgZbH9xukM1DphXeJpBjz5JmxO7FdLIpTl5sqRy08jscY5Q++yIyX0cg4puu8IVKVhflQGE+xzHVNDBQO9LfOQckxQHarHiMvcaZBriU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782490448; c=relaxed/simple;
	bh=2aX4giEZdlVXO12J1yUnHz4/HsPYtJ4yf4ZpxmIaBdo=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=MggU+kd6G8KFJbDyvsk5SbzwW4L0CgYm/tMmFsBbQBGW7WAF082yYPZ3/vZdSNTzUSQNHKyRWBo6Y5EU3QHpFzkD3PvuYh/W9AWFzUs5BIgqMdNd0d2hYz0zC1gbQfx5aM1iaKXdAe+DL7JP8YP94Lx1BTvlVf77nkDelS0Jips=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from localhost.localdomain (unknown [117.182.75.66])
	by APP-01 (Coremail) with SMTP id qwCowACXO9RLpT5qBqVtAw--.4863S2;
	Sat, 27 Jun 2026 00:14:03 +0800 (CST)
From: WenTao Liang <vulab@iscas.ac.cn>
To: James Bottomley <jejb@linux.ibm.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org
Cc: stable@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	WenTao Liang <vulab@iscas.ac.cn>
Subject: [PATCH] fix: scsi: srp_reconnect_rport: unbalanced   scsi_block_targets/scsi_target_unblock
Date: Sat, 27 Jun 2026 00:14:02 +0800
Message-Id: <20260626161402.55116-1-vulab@iscas.ac.cn>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qwCowACXO9RLpT5qBqVtAw--.4863S2
X-Coremail-Antispam: 1UD129KBjvJXoW7CryfZry7Xw4rtF1fXw43Jrb_yoW5Jr45pF
	9xGasF9rWkJrZ7u3Z8Cr45KryayayrWryUCF1fW34rCaykKry3JanrKFZFgFn5tFsFqFyD
	ZFsFvFyDGFW8JrJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUkG14x267AKxVWUJVW8JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26r4j6ryUM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4j
	6F4UM28EF7xvwVC2z280aVAFwI0_Gr0_Cr1l84ACjcxK6I8E87Iv6xkF7I0E14v26r4j6r
	4UJwAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
	I7IYx2IY67AKxVWUAVWUtwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
	4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCY1x0262kKe7AKxVWU
	AVWUtwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14
	v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1lIxkG
	c2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4U
	MIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JU6v38UUU
	UU=
X-CM-SenderInfo: pyxotu46lvutnvoduhdfq/1tbiBwUKA2o+ikVFzQAAsY

In srp_reconnect_rport(), scsi_block_targets() is called only when
rport->state is not FAIL_FAST and not LOST. However,
scsi_target_unblock() is called unconditionally on the success path and
on some error paths, causing an extra kref_put on sdev_gendev when block
was never called.

Introduce a 'blocked' flag to track whether scsi_block_targets() was
called, and only call scsi_target_unblock() when blocked is true.

Cc: stable@vger.kernel.org
Fixes: 09345f65058b ("[SCSI] add srp transport class")
Signed-off-by: WenTao Liang <vulab@iscas.ac.cn>
---
 drivers/scsi/scsi_transport_srp.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_transport_srp.c b/drivers/scsi/scsi_transport_srp.c
index d71ab5fdb758..b9f67e143b52 100644
--- a/drivers/scsi/scsi_transport_srp.c
+++ b/drivers/scsi/scsi_transport_srp.c
@@ -535,6 +535,7 @@ int srp_reconnect_rport(struct srp_rport *rport)
 	struct srp_internal *i = to_srp_internal(shost->transportt);
 	struct scsi_device *sdev;
 	int res;
+	bool blocked = false;
 
 	pr_debug("SCSI host %s\n", dev_name(&shost->shost_gendev));
 
@@ -549,6 +550,7 @@ int srp_reconnect_rport(struct srp_rport *rport)
 		 * treats SDEV_TRANSPORT_OFFLINE like SDEV_BLOCK.
 		 */
 		scsi_block_targets(shost, &shost->shost_gendev);
+		blocked = true;
 	res = rport->state != SRP_RPORT_LOST ? i->f->reconnect(rport) : -ENODEV;
 	pr_debug("%s (state %d): transport.reconnect() returned %d\n",
 		 dev_name(&shost->shost_gendev), rport->state, res);
@@ -558,7 +560,8 @@ int srp_reconnect_rport(struct srp_rport *rport)
 
 		rport->failed_reconnects = 0;
 		srp_rport_set_state(rport, SRP_RPORT_RUNNING);
-		scsi_target_unblock(&shost->shost_gendev, SDEV_RUNNING);
+		if (blocked)
+			scsi_target_unblock(&shost->shost_gendev, SDEV_RUNNING);
 		/*
 		 * If the SCSI error handler has offlined one or more devices,
 		 * invoking scsi_target_unblock() won't change the state of
@@ -579,7 +582,8 @@ int srp_reconnect_rport(struct srp_rport *rport)
 		__rport_fail_io_fast(rport);
 		__srp_start_tl_fail_timers(rport);
 	} else if (rport->state != SRP_RPORT_BLOCKED) {
-		scsi_target_unblock(&shost->shost_gendev,
+		if (blocked)
+			scsi_target_unblock(&shost->shost_gendev,
 				    SDEV_TRANSPORT_OFFLINE);
 	}
 	mutex_unlock(&rport->mutex);
-- 
2.39.5 (Apple Git-154)

