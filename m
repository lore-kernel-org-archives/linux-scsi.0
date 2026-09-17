Received: from cstnet.cn (smtp25.cstnet.cn [159.226.251.25])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86DE045BE3;
	Thu, 17 Sep 2026 15:18:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789658328; cv=none; b=uyvmfN16uZlOpZusbqV6DPivQuNHeTLp5M9VjXkPiEA8FRGkvCqpPIXE7DeEHGsQB1ZM1KzxYNyha2LskSxs8CAhQzxRpe8HczFtq28QY2Jf9gjuWto75vHx4l7Fg/Okj4CtaYBzwDtkyeBEB2LOYlc5YcASfhPmKJnCRq8xAyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789658328; c=relaxed/simple;
	bh=jPFR28v535VHgmUsZ2xAjS5/Sf1zVqdsI8NvQfGMpvg=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=YSkZt4PTAcvIvyVq7nViMFrbflKggje+qIAuvNes2jqo9868WdfJnfWrAAq4OIdukqm3rLduTQeMzVm0B9Nyn0hQ1zrIaox+x6U4IC5CqUqLQnZgNHeJ0JpSyxVROLFHntvFmRioXdjstN2ZUQjYn4rVKbOTR9e6UoRf0BjJnzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from dfae2b116770.home.arpa (unknown [36.110.52.2])
	by APP-05 (Coremail) with SMTP id zQCowABHtD7EBKxq5GKDCA--.5596S2;
	Thu, 17 Sep 2026 23:18:28 +0800 (CST)
From: Wentao Liang <vulab@iscas.ac.cn>
To: James.Bottomley@HansenPartnership.com
Cc: hare@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com,
	Wentao Liang <vulab@iscas.ac.cn>,
	stable@vger.kernel.org
Subject: [PATCH] scsi: myrs: Fix scsi_device reference leak in myrs_log_event()
Date: Thu, 17 Sep 2026 15:18:28 +0000
Message-Id: <20260917151828.2158730-1-vulab@iscas.ac.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:zQCowABHtD7EBKxq5GKDCA--.5596S2
X-Coremail-Antispam: 1UD129KBjvdXoWrtw4UurW7GF48tF47AryxZrb_yoWfuwc_Wr
	4Fvr9rXFyUCF92k34xtrnrAr9a93ZrW3yrCw1ktr93CFW8XFyIvr45ZrZ0v3y7Ww48Aa4Y
	gw1DAF4Fyw17WjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbS8YjsxI4VWkKwAYFVCjjxCrM7CY07I20VC2zVCF04k26cxKx2IY
	s7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4
	kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_
	Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxV
	W0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv
	7VC0I7IYx2IY67AKxVWUtVWrXwAv7VC2z280aVAFwI0_Cr1j6rxdMcvjeVCFs4IE7xkEbV
	WUJVW8JwACjcxG0xvY0x0EwIxGrwACjI8F5VAI37AI020EjII2zVCS5cI20VAGYxC7MxkF
	7I0En4kS14v26r126r1DMxAIw28IcxkI7VAKI48JMxAIw28IcVCjz48v1sIEY20_Gr43Wr
	1UJr1l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8G
	jcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE2I
	x0cI8IcVAFwI0_JFI_Gr1lIxAIcVC0I7IYx2IY6xkF7I0E14v26F4j6r4UJwCI42IY6xAI
	w20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Gr1j6F4UJwCI42IY6I8E87Iv6x
	kF7I0E14v26rxl6s0DYxBIdaVFxhVjvjDU0xZFpf9x07b818PUUUUU=
X-CM-SenderInfo: pyxotu46lvutnvoduhdfq/1tbiBwENA2qr9tghpAAAsi

scsi_device_lookup() returns a scsi_device with an extra reference
that the caller has to drop with scsi_device_put(). The physical device
event handler never releases it, so the scsi_device reference is leaked
for every physical device event reported by the controller.

Drop the reference after the device state has been updated.

Fixes: 77266186397c ("scsi: myrs: Add Mylex RAID controller (SCSI interface)")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
---
 drivers/scsi/myrs.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/myrs.c b/drivers/scsi/myrs.c
index afd68225221a..79ee3a352524 100644
--- a/drivers/scsi/myrs.c
+++ b/drivers/scsi/myrs.c
@@ -875,6 +875,8 @@ static void myrs_log_event(struct myrs_hba *cs, struct myrs_event *ev)
 				break;
 			}
 		}
+		if (sdev)
+			scsi_device_put(sdev);
 		break;
 	case 'L':
 		shost_printk(KERN_INFO, shost,
-- 
2.34.1

