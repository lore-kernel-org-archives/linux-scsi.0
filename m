Received: from cstnet.cn (smtp25.cstnet.cn [159.226.251.25])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2384B40B6F9;
	Fri, 14 Aug 2026 09:29:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786699797; cv=none; b=IsIa5cax0ITQfzD7yQpbJ+G/4hl+zES4Z1YcoX8McN67Juj8/5K1/YxTnKzeldx9ZBEajUgT8/PeBHf1mSSwwHEcWd+O/iev5RdmT9uh1KdZq9R1h+5FWv7kbmi+0W1QX2C9Sju7kXDPfBmXGgpPSNtqQqFnF5IHcPqTJ/EtKUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786699797; c=relaxed/simple;
	bh=RjEBk/AFSe5ilhtsjLdJ72/P9G65mu5A5G4QI46ND1Y=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=CJ9BxqNbSv3K0UEfdHosuTnJPbhbCRkLhwIyQNGbWF9iOsV4ONO7MD/hBFiVqXuaPizOtjUgMhTpXJPfsX5sSfVVrmaGM5yYRBYXVUVOCky+2CkAxazot91A5A30RnrKfkk7++KCEMXYYeEVSZMWBgyp6aPMgYBN1sErNgFnKH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from DESKTOP-L0HPE2S.localdomain (unknown [36.110.52.2])
	by APP-05 (Coremail) with SMTP id zQCowAAXSEIE4H5qBdWvBQ--.46336S2;
	Fri, 14 Aug 2026 17:29:41 +0800 (CST)
From: Haotian Zhang <vulab@iscas.ac.cn>
To: don.brace@microchip.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: storagedev@microchip.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Haotian Zhang <vulab@iscas.ac.cn>
Subject: [PATCH] scsi: hpsa: fix divide-by-zero in hpsa_scsi_ioaccel_raid_map
Date: Fri, 14 Aug 2026 17:00:15 +0800
Message-ID: <20260814090015.10207-1-vulab@iscas.ac.cn>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:zQCowAAXSEIE4H5qBdWvBQ--.46336S2
X-Coremail-Antispam: 1UD129KBjvJXoW7KF18ZF45Jw4DWF45Zw4Dtwb_yoW8JF4DpF
	Z3uay7u34rurnIga1kXw17ZF1FkanaqFyxuay8G3y5uF90q34jvF4xGF93Wr95Krs5Jrn0
	vFZ8Ar1rWFyIvFUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUkC14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4j
	6r4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
	I7IYx2IY67AKxVWUtVWrXwAv7VC2z280aVAFwI0_Gr1j6F4UJwAm72CE4IkC6x0Yz7v_Jr
	0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7MxkF7I0En4kS14v2
	6r126r1DMxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrV
	AFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUAVWUtwCI
	c40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267
	AKxVWUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_
	Gr1lIxAIcVC2z280aVCY1x0267AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjfUO2NtDU
	UUU
X-CM-SenderInfo: pyxotu46lvutnvoduhdfq/1tbiCRQTA2p90DD94gABsk

hpsa_scsi_ioaccel_raid_map() divides by blocks_per_row, the product of
data_disks_per_row and strip_size, two controller-supplied RAID map
fields that are never validated.  If either field is zero, the
unguarded division raises a divide-by-zero exception on every I/O to an
offload-enabled logical volume.

Check blocks_per_row for zero as soon as it is computed.  If it is
zero, turn off ioaccel for the device and return IO_ACCEL_INELIGIBLE.

Fixes: 283b4a9b98b1 ("[SCSI] hpsa: add ioaccell mode 1 RAID offload support.")
Signed-off-by: Haotian Zhang <vulab@iscas.ac.cn>
---
 drivers/scsi/hpsa.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 3654b12c5d5a..fd1e07079a9c 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -5206,6 +5206,10 @@ static int hpsa_scsi_ioaccel_raid_map(struct ctlr_info *h,
 	/* calculate stripe information for the request */
 	blocks_per_row = le16_to_cpu(map->data_disks_per_row) *
 				le16_to_cpu(map->strip_size);
+	if (blocks_per_row == 0) {
+		hpsa_turn_off_ioaccel_for_device(dev);
+		return IO_ACCEL_INELIGIBLE;
+	}
 	strip_size = le16_to_cpu(map->strip_size);
 #if BITS_PER_LONG == 32
 	tmpdiv = first_block;
-- 
2.43.0

