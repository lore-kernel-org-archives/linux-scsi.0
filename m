Received: from cstnet.cn (smtp25.cstnet.cn [159.226.251.25])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2343A59B690;
	Thu, 17 Sep 2026 14:45:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789656364; cv=none; b=W6rm9zjntqwmsNxjzgExkctJbViLmoJPJAbddtHxnkWln9+vAhMuDGkoBTIpIfku6SVWtNh9TAcIERw612c/2Y4MVGp7frLx8JgsZ2MH2eGyDhrMnRMcu37icfGj5bwx79upE7DXIYE1ZkoKkJYLjXGl309BXJJDTzVAtp+UhnQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789656364; c=relaxed/simple;
	bh=AZYYmhBC/w3RO0SZ+OmhD/2TH6fxqkHiEGeTAsW/xhc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=iAE8NE5BI/leLepjv3lkJkdkO0KlSSRxNw6EQlNm5+remS38ov+8FdqdyIkfh4i0a0RJw5c8pSci5dQhLwRTZsnaPu6uRinjlfkWEQvKJoy/tCg7B+4QlJJTeFv2eF5H8+6/ZCxgeuuCodbR/T7UJFpOAYtgyJ0sVyJbDmk55m4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from dfae2b116770.home.arpa (unknown [36.110.52.2])
	by APP-05 (Coremail) with SMTP id zQCowACnFD8X_atqxcmCCA--.4993S2;
	Thu, 17 Sep 2026 22:45:43 +0800 (CST)
From: Wentao Liang <vulab@iscas.ac.cn>
To: James.Bottomley@HansenPartnership.com
Cc: jsmart2021@gmail.com,
	justin.tee@broadcom.com,
	linux-kernel@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com,
	paul.ely@broadcom.com,
	Wentao Liang <vulab@iscas.ac.cn>,
	stable@vger.kernel.org
Subject: [PATCH] scsi: lpfc: Fix ndlp reference leak in lpfc_nlp_reg_node()
Date: Thu, 17 Sep 2026 14:45:43 +0000
Message-Id: <20260917144543.2157614-1-vulab@iscas.ac.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:zQCowACnFD8X_atqxcmCCA--.4993S2
X-Coremail-Antispam: 1UD129KBjvJXoW7ArWrtw45KF17tF1kuFyrtFb_yoW8GFW3pa
	yfGay5A3s5tay0kF47AF4UXF90ka4xJrZ7Cayxta4Fgr4xGry7Jr48uFWjqFyDGFW09rW7
	tFn8KFZ8WF48Z3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUBFb7Iv0xC_KF4lb4IE77IF4wAFc2x0x2IEx4CE42xK8VAvwI8I
	cIk0rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2
	AK021l84ACjcxK6xIIjxv20xvE14v26ryj6F1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v2
	6F4j6r4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxV
	W0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv
	7VC0I7IYx2IY67AKxVWUtVWrXwAv7VC2z280aVAFwI0_Cr1j6rxdMcvjeVCFs4IE7xkEbV
	WUJVW8JwACjcxG0xvY0x0EwIxGrwACjI8F5VAI37AI020EjII2zVCS5cI20VAGYxC7MxkF
	7I0En4kS14v26r1q6r43MxAIw28IcxkI7VAKI48JMxAIw28IcVCjz48v1sIEY20_Gr43Wr
	1UJr1l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8G
	jcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2I
	x0cI8IcVAFwI0_JFI_Gr1lIxAIcVC0I7IYx2IY6xkF7I0E14v26F4j6r4UJwCI42IY6xAI
	w20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Gr1j6F4UJwCI42IY6I8E87Iv6x
	kF7I0E14v26rxl6s0DYxBIdaVFxhVjvjDU0xZFpf9x07UZSdgUUUUU=
X-CM-SenderInfo: pyxotu46lvutnvoduhdfq/1tbiBwYNA2qr9tgORwAAsp

In the NVMET case the driver takes a node reference in
lpfc_nlp_reg_node() because the target does not register rports, but
lpfc_nlp_unreg_node() only releases that reference when the
NVME_XPT_REGD flag is set, and the NVMET path never sets it, so the
reference is leaked until the node is torn down.

Set NVME_XPT_REGD when the reference is taken so the existing put in
lpfc_nlp_unreg_node() balances it.

Fixes: 0614568361b0 ("scsi: lpfc: Delay unregistering from transport until GIDFT or ADISC completes")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
---
 drivers/scsi/lpfc/lpfc_hbadisc.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index f3a85f6c796e..9e920eaff9ef 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -4664,9 +4664,15 @@ lpfc_nlp_reg_node(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 			}
 		} else {
 			/* Just take an NDLP ref count since the
-			 * target does not register rports.
+			 * target does not register rports. Mark it as
+			 * an NVME transport ref so that
+			 * lpfc_nlp_unreg_node() releases it.
 			 */
 			lpfc_nlp_get(ndlp);
+
+			spin_lock_irqsave(&ndlp->lock, iflags);
+			ndlp->fc4_xpt_flags |= NVME_XPT_REGD;
+			spin_unlock_irqrestore(&ndlp->lock, iflags);
 		}
 	}
 }
-- 
2.34.1

