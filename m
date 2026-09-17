Received: from cstnet.cn (smtp25.cstnet.cn [159.226.251.25])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE89C4D4876;
	Thu, 17 Sep 2026 15:21:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789658498; cv=none; b=mYKOtU0cRvqBvtZeDqnulxC0GGCJURTTetDUUmeSesxD7IaPVZ6y8bJZoKt4p7FwJNN0NH/3W7dfQXX4Snp9+Bv6jwcaPikhI7K6HkIuJYK5qnVNr9WlFoz4CKYfqMTkq7LhSH2DPQb4Jw9XTpZxq7jnag92xgIFd/u6AujJWhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789658498; c=relaxed/simple;
	bh=RYV7HFAVRXdmPMRYMY4FxY232zrON1v+knz7Z3599QQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=FSMZlg5iPBhMNRMfEDpU0J3rPbea8ewmr0xrQE2dDRIWZ3hlD+Levu1SxoVxxWT2ez63rHbmBNQj2PRiQoQwxNVsk/okeFOMfNQhnN55mfC6L/acr7jfJL+wdHjflH7rjSt5Cxg054FipVGWmfvJy4KFouIIsmmvTHnK3YRwBHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from dfae2b116770.home.arpa (unknown [36.110.52.2])
	by APP-05 (Coremail) with SMTP id zQCowABn0TtwBaxqlG6DCA--.5660S2;
	Thu, 17 Sep 2026 23:21:20 +0800 (CST)
From: Wentao Liang <vulab@iscas.ac.cn>
To: GR-QLogic-Storage-Upstream@marvell.com
Cc: James.Bottomley@HansenPartnership.com,
	andrewv@marvell.com,
	hmadhani@marvell.com,
	linux-kernel@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com,
	njavali@marvell.com,
	Wentao Liang <vulab@iscas.ac.cn>,
	stable@vger.kernel.org
Subject: [PATCH] scsi: qla2xxx: Fix cs84xx reference leak in qla2x00_initialize_adapter()
Date: Thu, 17 Sep 2026 15:21:20 +0000
Message-Id: <20260917152120.2158829-1-vulab@iscas.ac.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:zQCowABn0TtwBaxqlG6DCA--.5660S2
X-Coremail-Antispam: 1UD129KBjvdXoW7JFWruFWUCFyktryUAryDtrb_yoWkKFbEgF
	4UW34Igr1UuFs29w1Iqr13A392ya1kXw109w4Fy343CrWfW3W7Xrn0g39xua4xur40yFWD
	Cw4ruryFvw129jkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbgxYjsxI4VWkKwAYFVCjjxCrM7CY07I20VC2zVCF04k26cxKx2IY
	s7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4
	kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_
	Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxV
	W0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv
	7VC0I7IYx2IY67AKxVWUtVWrXwAv7VC2z280aVAFwI0_Cr1j6rxdMcvjeVCFs4IE7xkEbV
	WUJVW8JwACjcxG0xvY0x0EwIxGrwACjI8F5VAI37AI020EjII2zVCS5cI20VAGYxC7M4II
	rI8v6xkF7I0E8cxan2IY04v7MxkF7I0En4kS14v26r1q6r43MxAIw28IcxkI7VAKI48JMx
	AIw28IcVCjz48v1sIEY20_Gr43Wr1UJr1l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAq
	x4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r
	43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_JFI_Gr1lIxAIcVC0I7IYx2IY6xkF
	7I0E14v26F4j6r4UJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI
	0_Gr1j6F4UJwCI42IY6I8E87Iv6xkF7I0E14v26rxl6s0DYxBIdaVFxhVjvjDU0xZFpf9x
	07bbXocUUUUU=
X-CM-SenderInfo: pyxotu46lvutnvoduhdfq/1tbiDAINA2qr9nAjRAABsh

qla84xx_get_chip() takes a reference on the shared 84xx chip state, but
the early return taken when qla2x00_init_rings() fails does not release
it. The reference is only dropped on the 84xx init failure and on
driver removal, which never runs after a failed probe, so the chip
state is leaked.

Drop the reference before returning on this error path.

Fixes: 26a77799195f ("scsi: qla2xxx: Correct error handling during initialization failures")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
---
 drivers/scsi/qla2xxx/qla_init.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index e746c9274cde..b5bffe561735 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -2853,8 +2853,11 @@ qla2x00_initialize_adapter(scsi_qla_host_t *vha)
 		rval = qla2x00_init_rings(vha);
 
 	/* No point in continuing if firmware initialization failed. */
-	if (rval != QLA_SUCCESS)
+	if (rval != QLA_SUCCESS) {
+		if (IS_QLA84XX(ha))
+			qla84xx_put_chip(vha);
 		return rval;
+	}
 
 	ha->flags.chip_reset_done = 1;
 
-- 
2.34.1

