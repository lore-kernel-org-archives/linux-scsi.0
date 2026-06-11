Received: from cstnet.cn (smtp81.cstnet.cn [159.226.251.81])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8B3F349CFD;
	Thu, 11 Jun 2026 06:41:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781160073; cv=none; b=Ke6z6uQZjc8abwXtHn49Hd8wyInN5/rUSodeuuT5tkV39d9fZTE0ST93Z4iT45Nt3sV15vpv1khvf9SrK9qtyCT7QwO9+3WpOBXtNAXNclpvdQO9qZz2juIGwC4b3WP5EjlSdXysFn7ZHtF3KR4CrP2FDPArVL6257XZLZGbLIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781160073; c=relaxed/simple;
	bh=50lJLGZmrBZeK3yQ37YckRkxQSVXxLtcS8G0nBDtokU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=sG8gqJCxMRJV6oeQhEqkMTZ+Ng/lcYBj/H80Efp5QRDHwkE/NJQIifmg4HFCLinEB6BMPb8CrVQPRAm1EbBMoZ1rK3UqJLKrxGfgRceTtFMhYAkCXCPDdX177Hz6jhzBiNemakk4oIC0J4CLnQwRQo/Qw1wPoMjrb2gk6GXhxV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from localhost.localdomain (unknown [117.182.75.76])
	by APP-03 (Coremail) with SMTP id rQCowAC31dx+WCpq2xZZFA--.13226S2;
	Thu, 11 Jun 2026 14:41:04 +0800 (CST)
From: WenTao Liang <vulab@iscas.ac.cn>
To: linuxdrivers@attotech.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	WenTao Liang <vulab@iscas.ac.cn>,
	stable@vger.kernel.org
Subject: [PATCH] scsi: esas2r: fix refcount leak in esas2r_resume()
Date: Thu, 11 Jun 2026 14:41:00 +0800
Message-ID: <20260611064100.65731-1-vulab@iscas.ac.cn>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:rQCowAC31dx+WCpq2xZZFA--.13226S2
X-Coremail-Antispam: 1UD129KBjvJXoWxJrWDXw17Cry5Xr1DuF4xXrb_yoW8CrWkpF
	WFkw1v9F18AayxJw4UCr1YvryrXayUGFyfurW8u397u3Z8JFWrXr1IqFyjyFykKrykX3s8
	tFsYq3s8Wa4DJF7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUkK14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26ryj6F1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVWxJr0_GcWl84ACjcxK6I8E87Iv6xkF7I0E14v26r
	xl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj
	6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr
	0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7MxkF7I0En4kS14v2
	6r126r1DMxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrV
	AFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUAVWUtwCI
	c40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267
	AKxVWUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_
	Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7VUbSfO7
	UUUUU==
X-CM-SenderInfo: pyxotu46lvutnvoduhdfq/1tbiBgsPA2oqQMk8QAABs1

In esas2r_resume(), the function unconditionally calls
esas2r_disable_chip_interrupts() which increments the adapter's
dis_ints_cnt atomic counter. The counter is supposed to be
decremented by esas2r_enable_chip_interrupts(), but this only
happens on the success path when AF2_IRQ_CLAIMED is set. If
esas2r_power_up() fails or AF2_IRQ_CLAIMED is not set, the
function returns via error_exit without calling
esas2r_enable_chip_interrupts(), leaving the counter permanently
incremented. This refcount leak means the next disable/enable
cycle will not properly unmask interrupts (counter goes 1->2 on
disable, 2->1 on enable, never reaching 0), breaking interrupt
operation.

Fix it by calling esas2r_enable_chip_interrupts() before jumping
to error_exit on both error paths.

Cc: stable@vger.kernel.org
Fixes: 26780d9e12ed ("[SCSI] esas2r: ATTO Technology ExpressSAS 6G SAS/SATA RAID Adapter Driver")
Signed-off-by: WenTao Liang <vulab@iscas.ac.cn>
---
 drivers/scsi/esas2r/esas2r_init.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/esas2r/esas2r_init.c b/drivers/scsi/esas2r/esas2r_init.c
index 0a35f1953768..727ddcebec9f 100644
--- a/drivers/scsi/esas2r/esas2r_init.c
+++ b/drivers/scsi/esas2r/esas2r_init.c
@@ -683,6 +683,7 @@ static int __maybe_unused esas2r_resume(struct device *dev)
 	if (!esas2r_power_up(a, true)) {
 		esas2r_debug("yikes, esas2r_power_up failed");
 		rez = -ENOMEM;
+		esas2r_enable_chip_interrupts(a);
 		goto error_exit;
 	}
 
@@ -699,6 +700,7 @@ static int __maybe_unused esas2r_resume(struct device *dev)
 		esas2r_debug("yikes, unable to claim IRQ");
 		esas2r_log(ESAS2R_LOG_CRIT, "could not re-claim IRQ!");
 		rez = -ENOMEM;
+		esas2r_enable_chip_interrupts(a);
 		goto error_exit;
 	}
 
-- 
2.50.1 (Apple Git-155)

