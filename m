Received: from cstnet.cn (smtp25.cstnet.cn [159.226.251.25])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D3D13F54CB;
	Wed,  1 Apr 2026 12:06:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775045169; cv=none; b=HyRqME0MJxiuHtDvpjPP++5cS764+TqmiwHJCLpK0/paMfFlZViqBCOK0kD+ACTYviXUDOlVkGpfqvHwTtBrHNa71W7LJ93H/VRGhXg/zVE/0TNw40Hisa4SosKskr1tNZjsMSMPmLrUUtxT99uzEVDf7m7NZ6k6+pc2K4eEWhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775045169; c=relaxed/simple;
	bh=IIIe9qJGMwk3vWx7B4b9baeRscWOdkdIRJcvaFXjhU4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YzzDzLXv9BmDq7mS7y3xMMCv4xpaFIuvok2fZ6GGcOtR4DzR4BMCaRn1c3vc4kdKxJ7G/EyyFfE2uyat6Bf6Cndw+w0lHKJZTlbAXhmVq0ziTYELzYzTTGGFXa+OEmzYuAYjpvvaNFdpoP/iGp2zYMP31LWIGgfIY3q8MQrus30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from localhost.localdomain (unknown [111.196.245.197])
	by APP-05 (Coremail) with SMTP id zQCowABX5wogCs1pKeEpDA--.36262S2;
	Wed, 01 Apr 2026 20:05:54 +0800 (CST)
From: Pengpeng Hou <pengpeng@iscas.ac.cn>
To: don.brace@microchip.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: kevin.barnett@pmcs.com,
	thenzl@redhat.com,
	scott.teel@pmcs.com,
	hare@Suse.de,
	storagedev@microchip.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	pengpeng@iscas.ac.cn
Subject: [PATCH v2] scsi: hpsa: enlarge controller and IRQ name buffers
Date: Wed,  1 Apr 2026 20:05:52 +0800
Message-ID: <20260401120552.78541-1-pengpeng@iscas.ac.cn>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260329030947.32427-1-pengpeng@iscas.ac.cn>
References: <20260329030947.32427-1-pengpeng@iscas.ac.cn>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:zQCowABX5wogCs1pKeEpDA--.36262S2
X-Coremail-Antispam: 1UD129KBjvJXoW7AFyxZr47Jw4kKF1DJw43Jrb_yoW8CrW5pF
	Zag34DCr47Ka12ka409a1UXFyfCas5Jry2k397J3yvvr1S9FyUXryxGFyrZFyv9r4Igr1j
	yFs8KayrWa47JrJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9j14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26r4j6ryUM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4j
	6F4UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s
	0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xII
	jxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr
	1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7M4IIrI8v6xkF7I0E8cxa
	n2IY04v7MxkF7I0En4kS14v26r1q6r43MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4
	AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE
	17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMI
	IF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4l
	IxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvf
	C2KfnxnUUI43ZEXa7VUbGQ6JUUUUU==
X-CM-SenderInfo: pshqw1xhqjqxpvfd2hldfou0/

hpsa formats the controller name into h->devname[8] and derives
interrupt names from it in h->intrname[][16]. Once host_no reaches four
digits, "hpsa%d" no longer fits in devname, and the derived IRQ names
can then overrun the interrupt-name buffers as well.

The previous fix switched these builders to bounded formatting, but that
would truncate user-visible controller and IRQ names. Keep the existing
names intact instead by enlarging the fixed buffers to cover the current
formatted strings.

Fixes: 2946e82bdd76 ("hpsa: use scsi host_no as hpsa controller number")
Fixes: 8b47004a5512 ("hpsa: add interrupt number to /proc/interrupts interrupt name")
Acked-by: Don Brace <don.brace@microchip.com>
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
---
v2:
- enlarge the fixed buffers instead of truncating the formatted names
- drop the mixed formatting-only changes

 drivers/scsi/hpsa.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/hpsa.h b/drivers/scsi/hpsa.h
index 99b0750850b2..bf33868a63d9 100644
--- a/drivers/scsi/hpsa.h
+++ b/drivers/scsi/hpsa.h
@@ -164,7 +164,7 @@ struct bmic_controller_parameters {
 struct ctlr_info {
 	unsigned int *reply_map;
 	int	ctlr;
-	char	devname[8];
+	char	devname[16];
 	char    *product_name;
 	struct pci_dev *pdev;
 	u32	board_id;
@@ -255,7 +255,7 @@ struct ctlr_info {
 	int remove_in_progress;
 	/* Address of h->q[x] is passed to intr handler to know which queue */
 	u8 q[MAX_REPLY_QUEUES];
-	char intrname[MAX_REPLY_QUEUES][16];	/* "hpsa0-msix00" names */
+	char intrname[MAX_REPLY_QUEUES][32];	/* controller and IRQ names */
 	u32 TMFSupportFlags; /* cache what task mgmt funcs are supported. */
 #define HPSATMF_BITS_SUPPORTED  (1 << 0)
 #define HPSATMF_PHYS_LUN_RESET  (1 << 1)
-- 
2.50.1 (Apple Git-155)

