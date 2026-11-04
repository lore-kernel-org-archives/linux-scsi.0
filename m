Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=159.226.251.21
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793758424;
	b=hMm39ItiOLue9sTFf+aRwHu47ufVYwvO9q88HovB+Hp8u0JlpTXUInPgqgQTv82Cb/h5
	 IVhsnPKa5d/NWIe0HGYONIcv1fTbGdfndTd4jL+JHT7jtwHXZzkZF+/AwA4H4AQT0jL/f
	 nbeQFRcyOA1cADC3Y8Ey7XM2jb72xwt5eJCDpFpBp/zNe2QE+U20+WBQU4ts80YhHtMhl
	 qkmydshX8qGlT4M2CZGLBmsfzl7maWEDSHtTDx1MG8WKbARkkTBXgkR/SvpbOJ+xN8UFa
	 m6DpNZm7Qr+DvljSHSw6BscFSMDIY+chXw1ISI2qAXDZ1iYDRybi8I6ZCMa6vcBvG4g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793758424;
	h=DMARC-Filter:Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding:X-CM-TRANSID:
	 X-Coremail-Antispam:X-Originating-IP:X-CM-SenderInfo;
	bh=cU2ztCEkK7eciCdeBzochELPGRQWWC4u1uuDJRrNPJw=;
	b=DhocRHA5MUX3tDEka6jLPSOWSpB4J9EKG0K6LBC3yOfkpC1Jjf27VBtPTkmyuIHvuTSc
	 pWwuWMHPV4jeeERSfrm9o6rKPS7j5VAntH//GF7HN/AbpbyKW+DLXmQd+7p/HE39LfOXd
	 jdv4dCR8orXJPQmAaOrp/BLjYB14Yna0zW4A1Dx/m2YszOCYrIYpCLeLwfwZOrdcGQiTB
	 Hb3JXOW91Oj5tCEFeielEqXL9hObPsauthyv7kSLL5h0Tm8EaGyx0ERnvCuwycK+3+tot
	 wiaEcagwx7beoDUCdZ6rQ/oUCAN8jtqeLEyhOoJYIaTqwpEfwYtaCRrLCW8l8sBpxwA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=iscas.ac.cn;
	spf=pass smtp.mailfrom=iscas.ac.cn;
	arc=none smtp.remote-ip=159.226.251.21
Received: from cstnet.cn (smtp21.cstnet.cn [159.226.251.21])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24C80606A31B
	for <linux-scsi@vger.kernel.org>; Wed,  4 Nov 2026 02:13:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 24C80606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from dfae2b116770.home.arpa (unknown [36.110.52.2])
	by APP-01 (Coremail) with SMTP id qwCowADH7vjPlOpqMHM+AA--.9510S2;
	Wed, 04 Nov 2026 10:13:35 +0800 (CST)
From: Wentao Liang <vulab@iscas.ac.cn>
To: Hannes Reinecke <hare@suse.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org
Subject: [PATCH] scsi: aic7xxx: fix a reference leak in ahc_dump_target_state
Date: Wed,  4 Nov 2026 02:13:44 +0000
Message-Id: <20261104021344.1467675-1-vulab@iscas.ac.cn>
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
X-CM-TRANSID:qwCowADH7vjPlOpqMHM+AA--.9510S2
X-Coremail-Antispam: 1UD129KBjvdXoWrKF45Cr1kXFyxAw47CrWxZwb_yoWDKrX_u3
	4S9397Wry8GF4Ikry7AFsIv3sakF4qq3y0k3WSqrsYyrW0qFWUXa1UurWDJrnrZa1fArn0
	q342yrWY9r12gjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
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
X-CM-SenderInfo: pyxotu46lvutnvoduhdfq/1tbiDAEBA2rqY+S4nAAAss

scsi_device_lookup_by_target() returns the device with an extra
reference that the caller has to drop with scsi_device_put().  The
procfs target dump never released it, so every read of the file leaked
one reference for each LUN that has an attached device, preventing the
scsi_device from ever being freed.

Drop the reference after the device state has been printed.

Fixes: 9080063f523b ("[SCSI] aic7xxx: Remove slave_destroy")
Cc: stable@vger.kernel.org
Assisted-by: DeepSeek-V4.1-Flash and OpenAI Codex
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

