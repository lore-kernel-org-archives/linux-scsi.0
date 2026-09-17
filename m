Received: from cstnet.cn (smtp25.cstnet.cn [159.226.251.25])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54645358D27;
	Thu, 17 Sep 2026 15:14:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789658105; cv=none; b=IwzrzkF7ZSU/v9Oe2VS01twlo82EEfhEpy13O4w/DqXvq/vHdv6LfTU8cZWEwQlKHNTaCy6xyBU/FIp9IQdKOV0uUYpQDBhTicdZ/s5qN528NViXeIcoXXxyquVo4EMBl7yUNQNz88c2Qb4Ufhl7q9WlJoTVw3oS4+79H0xWBOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789658105; c=relaxed/simple;
	bh=WKd5hbr4XXWA3Mv8v+VhhZjKFugRnWpZAUIpvdZ+LH0=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=tFMrcdBRyY205l2JAL7ysDHO9VK+BAJetS+c58Kmf39oeQhEX15rhEnRKBbKiGcSEkYcwTC9Q8lQHBXBdnKvDa3AvpuE5C/w4j7zen5DpWI8jHbUptJ4vdLVMFq88Rrik/YvLI1Uzj88FuF+OPltqUiWVRyEBv5VogzOHsLm1U0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from dfae2b116770.home.arpa (unknown [36.110.52.2])
	by APP-05 (Coremail) with SMTP id zQCowACnFD_iA6xqs1GDCA--.5505S2;
	Thu, 17 Sep 2026 23:14:42 +0800 (CST)
From: Wentao Liang <vulab@iscas.ac.cn>
To: James.Bottomley@HansenPartnership.com
Cc: MPT-FusionLinux.pdl@broadcom.com,
	linux-kernel@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com,
	ranjan.kumar@broadcom.com,
	sathya.prakash@broadcom.com,
	sreekanth.reddy@broadcom.com,
	suganath-prabu.subramani@broadcom.com,
	Wentao Liang <vulab@iscas.ac.cn>,
	stable@vger.kernel.org
Subject: [PATCH] scsi: mpt3sas: Fix sas_device reference leak in _scsih_update_vphys_after_reset()
Date: Thu, 17 Sep 2026 15:14:42 +0000
Message-Id: <20260917151442.2158565-1-vulab@iscas.ac.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:zQCowACnFD_iA6xqs1GDCA--.5505S2
X-Coremail-Antispam: 1UD129KBjvdXoW7XFW8Jr4rWFy3Xw1rWF4Durg_yoWkKFb_ua
	1Ivr97X348KFn5J3WrKry7Zr12vrsFq34kuFsYvFs2kw1jvrZ8XFs7Gwn0yrsrW3yvv3yU
	Gw1DX393ury8GjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbgxYjsxI4VWkCwAYFVCjjxCrM7CY07I20VC2zVCF04k26cxKx2IY
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
	07UZSdgUUUUU=
X-CM-SenderInfo: pyxotu46lvutnvoduhdfq/1tbiCRQNA2qr9LYlBgAAsz

mpt3sas_get_sdev_by_addr() takes a reference on the sas device, but the
new hba_port pointer is merely stored in sas_device->port, so the
reference is never released. The sas device is thus leaked every time
a vSES device moves to another Port ID after a reset.

Drop the extra reference once the port pointer has been updated.

Fixes: ffa381d6373b ("scsi: mpt3sas: Handle vSES vphy object during HBA reset")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
---
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index c841fe1706c7..550a5e4fec10 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -6415,8 +6415,10 @@ _scsih_update_vphys_after_reset(struct MPT3SAS_ADAPTER *ioc)
 					    &mport->vphys_list);
 					sas_device = mpt3sas_get_sdev_by_addr(
 					    ioc, attached_sas_addr, port);
-					if (sas_device)
+					if (sas_device) {
 						sas_device->port = mport;
+						sas_device_put(sas_device);
+					}
 				}
 				/*
 				 * Earlier while updating the hba_port table,
-- 
2.34.1

