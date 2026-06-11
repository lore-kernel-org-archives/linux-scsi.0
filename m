Received: from cstnet.cn (smtp81.cstnet.cn [159.226.251.81])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A90243B9D95;
	Thu, 11 Jun 2026 11:09:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781176175; cv=none; b=Kd4Yd0IpDp9/96YQpHxIVq5hz1jvXIkEP8jLYc0VJPgFW6JanuJu7IbgvOuHCcCIZltMO5smIVyBX4vd2gMOS4QnzjZ+owjSizBjUiLBdMNlPK5Ple/a1j1qN0qkwFYU7/lw5e+dl3uqmWE6LNG2z6qAxcG1nimo4d7dHBPM9rM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781176175; c=relaxed/simple;
	bh=r4yk5gLKbqPyq4I6SokKO0R2ZRD6eTlTtlo8Fqk1tPU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=PmYX/AgODm3CONzIpNzknLs1cGYX0snvcbVu+Pn6W/sb+cpyYw3augYUXdJWsfqzu6SwRcGxefPj273FSBD9PCqRx0zBuXbYh30/O+e/9Z3q0K0TBijKOTGhJ+pwn92GK8F67YwOaDpT04ePn9Z+UkjpUlmjxhR0Kpy6YaUYGZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from localhost.localdomain (unknown [117.182.75.76])
	by APP-03 (Coremail) with SMTP id rQCowACHp95hlypq_bldFA--.8073S2;
	Thu, 11 Jun 2026 19:09:23 +0800 (CST)
From: WenTao Liang <vulab@iscas.ac.cn>
To: njavali@marvell.com,
	GR-QLogic-Storage-Upstream@marvell.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	WenTao Liang <vulab@iscas.ac.cn>,
	stable@vger.kernel.org
Subject: [PATCH] scsi: qla2xxx: fix refcount leak in qla24xx_async_prli()
Date: Thu, 11 Jun 2026 19:09:19 +0800
Message-ID: <20260611110919.74911-1-vulab@iscas.ac.cn>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:rQCowACHp95hlypq_bldFA--.8073S2
X-Coremail-Antispam: 1UD129KBjvdXoW7XF4UGr4xuF1UCFW3tw4DCFg_yoWktrg_uF
	4UXryI9ryUursrW3WxurWfArWS9FZ7Xryvvw1jqrWfAry5u3W7Jr15uF9xXa4xt3yjvFZ8
	Gws7WrW8ZryUujkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbcAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
	A2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr0_
	Cr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_GcCE3s
	1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0
	cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8Jw
	ACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc7CjxVAaw2AFwI0_JF0_
	Jw1l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxV
	WUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI
	7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r
	1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI
	42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjfUYCJmUUUUU
X-CM-SenderInfo: pyxotu46lvutnvoduhdfq/1tbiBgsPA2oqhg409AAAsJ

When qla24xx_async_prli() fails to start an SP, it jumps to the
done_free_sp error path and releases only the command kref via
kref_put.  However, the vha reference count obtained earlier by
qla2x00_get_sp() through qla_vha_mark_busy() is never released on
this path, leading to a permanent leak of vha->vref_count.

Fix the leak by explicitly calling QLA_VHA_MARK_NOT_BUSY(vha) in
the error path before returning.

Cc: stable@vger.kernel.org
Fixes: a5d42f4cffa5 ("scsi: qla2xxx: Add FC-NVMe port discovery and PRLI handling")
Signed-off-by: WenTao Liang <vulab@iscas.ac.cn>
---
 drivers/scsi/qla2xxx/qla_init.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index e746c9274cde..8dd717dfcc14 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -1352,6 +1352,7 @@ qla24xx_async_prli(struct scsi_qla_host *vha, fc_port_t *fcport)
 done_free_sp:
 	/* ref: INIT */
 	kref_put(&sp->cmd_kref, qla2x00_sp_release);
+	QLA_VHA_MARK_NOT_BUSY(vha);
 	fcport->flags &= ~FCF_ASYNC_SENT;
 	return rval;
 }
-- 
2.50.1 (Apple Git-155)

