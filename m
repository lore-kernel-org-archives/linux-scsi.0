Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=159.226.251.21
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793758423;
	b=oGUYBn7SZywufjzMYcaqOu00tMjE0ckDGKZ5Hrnm4q7LpIAf0l4K+wcs3QTwavrkzfX7
	 4Yk0swcjGLgZozmT4jOXjHYMTY20UL8RQTB6GQml57tvZ+Tt3ovwSlOzDzOr53LcDopNs
	 ffU1DcotQceJJ8TTHgc2yRvcMOjC+Im4n2XxtYm5Ex7p3D9WxfvjAF4nL1vyw929eVv/W
	 gXJHsXfEHukoZKz3xKcEGmo5aHzFywVQ4zVoEzi9yVgAYgnrJ24o0nG/NgfaBneRF6V7T
	 0fqZRz2eoGgI7avbVPe5DcKO7qeqmd+tsb5+L7UIZ2SdU3pOu4S/Q4+/FFnBENhOsNA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793758423;
	h=DMARC-Filter:Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding:X-CM-TRANSID:
	 X-Coremail-Antispam:X-Originating-IP:X-CM-SenderInfo;
	bh=AYwHYrBIsZYpT07WJAsRuVFvb+sLAwX69e5/YNYE4rM=;
	b=CAq8+q6Fngyscs5ZV+0gja2Cba2EdwGbGrx1SWthsnHzd4QT8JMIRJk3Vi4l86NcEdk+
	 63FDBBhT/ThQXlMaXEtYSbESK099D9iUXzw8FL46xuiUydRGL8i3MhB1fejaudsypP81q
	 d/5K23L6PIxpbOHYA2HdzIBIFXXwbOBqtGd+qN+gxcGzyw31oeR0nuYbasKPUER1k/MnV
	 dbl6ZZ6KHZBPGpl/ivoYqSHyKKgvNZb+CIWiUY3xBnPROIJVFFX5c8WaNxx4K6lcVwsis
	 T0/nS/PutL46gmXY+n/X67b8V2+ft4k1JJZJdyBuGiW8FFzKGLFb2Y1V1NyIWzCcZLw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=iscas.ac.cn;
	spf=pass smtp.mailfrom=iscas.ac.cn;
	arc=none smtp.remote-ip=159.226.251.21
Received: from cstnet.cn (smtp21.cstnet.cn [159.226.251.21])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46B78606A326
	for <linux-scsi@vger.kernel.org>; Wed,  4 Nov 2026 02:13:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 46B78606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from dfae2b116770.home.arpa (unknown [36.110.52.2])
	by APP-01 (Coremail) with SMTP id qwCowAAXQfvJlOpq8XI+AA--.27353S2;
	Wed, 04 Nov 2026 10:13:29 +0800 (CST)
From: Wentao Liang <vulab@iscas.ac.cn>
To: Hannes Reinecke <hare@suse.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org
Subject: [PATCH] scsi: aic79xx: fix a reference leak in ahd_dump_target_state
Date: Wed,  4 Nov 2026 02:13:38 +0000
Message-Id: <20261104021338.1467647-1-vulab@iscas.ac.cn>
X-Mailer: git-send-email 2.34.1
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qwCowAAXQfvJlOpq8XI+AA--.27353S2
X-Coremail-Antispam: 1UD129KBjvdXoWrKF45Cr1kXFyxAw47CrWxZwb_yoWDKrc_ur
	WS93s7Wry8Ga1xKry7ArsIva4fKFWqgw40y3WFqrsYyayFqFW0q3yUurZ8Cr1DZa1fAw1q
	q347trWF9r17WjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUb28YjsxI4VWkKwAYFVCjjxCrM7CY07I20VC2zVCF04k26cxKx2IY
	s7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4
	kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_
	Cr0_Gr1UM28EF7xvwVC2z280aVAFwI0_Cr1j6rxdM28EF7xvwVC2z280aVCY1x0267AKxV
	WxJr0_GcWle2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2Wl
	Yx0E2Ix0cI8IcVAFwI0_Jw0_WrylYx0Ex4A2jsIE14v26r4UJVWxJr1lOx8S6xCaFVCjc4
	AY6r1j6r4UM4x0Y48IcxkI7VAKI48JMxAIw28IcxkI7VAKI48JMxAIw28IcVCjz48v1sIE
	Y20_Gr43Wr1UJr1l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGw
	C20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIYrxkI7VAKI48J
	MIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMI
	IF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E
	87Iv6xkF7I0E14v26r1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x07be3ktUUUUU=
X-CM-SenderInfo: pyxotu46lvutnvoduhdfq/1tbiCRQBA2rqY-m2ugAAsJ

scsi_device_lookup_by_target() returns the device with an extra
reference that the caller has to drop with scsi_device_put().  The
procfs target dump never released it, so every read of the file leaked
one reference for each LUN that has an attached device, preventing the
scsi_device from ever being freed.

Drop the reference after the device state has been printed.

Fixes: f89d0a4e1d01 ("[SCSI] aic79xx: remove slave_destroy")
Cc: stable@vger.kernel.org
Assisted-by: DeepSeek-V4.1-Flash and OpenAI Codex
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
---
 drivers/scsi/aic7xxx/aic79xx_proc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/aic7xxx/aic79xx_proc.c b/drivers/scsi/aic7xxx/aic79xx_proc.c
index aa37838b78a6..da8f2afdf405 100644
--- a/drivers/scsi/aic7xxx/aic79xx_proc.c
+++ b/drivers/scsi/aic7xxx/aic79xx_proc.c
@@ -185,6 +185,7 @@ ahd_dump_target_state(struct ahd_softc *ahd, struct seq_file *m,
 			continue;
 
 		ahd_dump_device_state(m, dev);
+		scsi_device_put(dev);
 	}
 }
 
-- 
2.34.1

