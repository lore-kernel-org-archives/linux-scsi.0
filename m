Received: from cstnet.cn (smtp25.cstnet.cn [159.226.251.25])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4D48599A36;
	Thu, 17 Sep 2026 14:36:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789655772; cv=none; b=VGYU+TgEcnWweiwGjV/5k12Z/lUpNnYQLhvDMPCRvR1vX4/IY3fIPza4Z4hRssThDEmCtv+tfrVaC1m0lZz6dIBUUSAvZ+ng+cNQGHBNGsecE9ldu1sAbJwHSo6tv7XDcuuFzZH8FHB5UqkK4iAP4MJJdBVJbGRRNqzZxzVfJtE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789655772; c=relaxed/simple;
	bh=dFdnrZSNB+siYIovvlXlOjkCDZhRhKUr9EKnMtOXYl0=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=nXVctlIDt8YX2nYZ3X2iF9dvOFdBfHzg4XG33bvJover03L+K7QcbDi0OsweqdlHRNbCSwCoL6wyfRePhaawecpksRC0YjxEYh0YOD86w2v3OZr70HQIPoALz56TdvH2jV8a0AzMKMh4is7Ess2Rv7A8CuZmFRWzMwUw+lOeAQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from dfae2b116770.home.arpa (unknown [36.110.52.2])
	by APP-05 (Coremail) with SMTP id zQCowAA3oz3S+qtqOZyCCA--.4829S2;
	Thu, 17 Sep 2026 22:36:02 +0800 (CST)
From: Wentao Liang <vulab@iscas.ac.cn>
To: James.Bottomley@HansenPartnership.com
Cc: James.Bottomley@SteelEye.com,
	hare@suse.com,
	linux-kernel@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com,
	Wentao Liang <vulab@iscas.ac.cn>,
	stable@vger.kernel.org
Subject: [PATCH] scsi: aic7xxx: Fix scsi_device reference leak in ahc_dump_target_state()
Date: Thu, 17 Sep 2026 14:36:02 +0000
Message-Id: <20260917143602.2157197-1-vulab@iscas.ac.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:zQCowAA3oz3S+qtqOZyCCA--.4829S2
X-Coremail-Antispam: 1UD129KBjvdXoW7XFy7KrW8Kr13ZF4DJrWxXrb_yoWfGwb_uw
	1S93s7WrWrGr1xKF1UAFsIvr9akr4DX34kC3WaqwsYyFWYqayxX34UWrWDJrnrAa1fA3WY
	q347JrWY9r17GjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbS8YjsxI4VWkCwAYFVCjjxCrM7CY07I20VC2zVCF04k26cxKx2IY
	s7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4
	kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_
	Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxV
	W0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv
	7VC0I7IYx2IY67AKxVWUtVWrXwAv7VC2z280aVAFwI0_Cr1j6rxdMcvjeVCFs4IE7xkEbV
	WUJVW8JwACjcxG0xvY0x0EwIxGrwACjI8F5VAI37AI020EjII2zVCS5cI20VAGYxC7MxkF
	7I0En4kS14v26r126r1DMxAIw28IcxkI7VAKI48JMxAIw28IcVCjz48v1sIEY20_Gr43Wr
	1UJr1l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8G
	jcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2I
	x0cI8IcVAFwI0_JFI_Gr1lIxAIcVC0I7IYx2IY6xkF7I0E14v26F4j6r4UJwCI42IY6xAI
	w20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Gr1j6F4UJwCI42IY6I8E87Iv6x
	kF7I0E14v26rxl6s0DYxBIdaVFxhVjvjDU0xZFpf9x07UMq2NUUUUU=
X-CM-SenderInfo: pyxotu46lvutnvoduhdfq/1tbiBgkNA2qr888RLwAAsC

ahc_dump_target_state() looks up each LUN with
scsi_device_lookup_by_target(), which returns the device with a
reference held, but the reference is never dropped. Put the device once
its state has been dumped.

Fixes: 9080063f523b ("[SCSI] aic7xxx: Remove slave_destroy")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
---
 drivers/scsi/aic7xxx/aic7xxx_proc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/aic7xxx/aic7xxx_proc.c b/drivers/scsi/aic7xxx/aic7xxx_proc.c
index 3b2ba7b4d61b..59d1bfe51351 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_proc.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_proc.c
@@ -165,6 +165,7 @@ ahc_dump_target_state(struct ahc_softc *ahc, struct seq_file *m,
 			continue;
 
 		ahc_dump_device_state(m, sdev);
+		scsi_device_put(sdev);
 	}
 }
 
-- 
2.34.1

