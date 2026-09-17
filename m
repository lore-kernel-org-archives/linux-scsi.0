Received: from cstnet.cn (smtp25.cstnet.cn [159.226.251.25])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D346C49738C;
	Thu, 17 Sep 2026 15:08:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789657729; cv=none; b=iQYFMpGVsI7oaDc88w6NvMvZbwbRT4NtbQx+nMfz0O1p1N2YIevr2RtJFZCAKeLPJicwfK+ovnPrui1pFl+oJRHq/hyFLF33ByQwpnU/ZdwRLxAQEu5ipvexO1a3imx2NTMaUm69xOdBME6asvNtfZof9tuFmatycixSX69kkBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789657729; c=relaxed/simple;
	bh=HL6Zyrvk/Y/WyDqiJ48ToVnwB/+jTB5/lG8lYnw0P+0=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=h+Rf+XojE8NUc1feIvA4ak+zx8d8+gFTUJUVVprMlGmGeCPiL3LMdcC7QYPB5s6UBu2PsEiK5R2pQHotBVsrcy3Dpt91xu62o6TDja3rFqfXEK2xCfcOcIQTCKZ82l2cHnkCEq+/xqdRynPHc1bSOleufyjGAdKtKZqrsm8c1YY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from dfae2b116770.home.arpa (unknown [36.110.52.2])
	by APP-05 (Coremail) with SMTP id zQCowABHtD5zAqxqHDWDCA--.5410S2;
	Thu, 17 Sep 2026 23:08:36 +0800 (CST)
From: Wentao Liang <vulab@iscas.ac.cn>
To: James.Bottomley@HansenPartnership.com
Cc: kashyap.desai@broadcom.com,
	linux-kernel@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com,
	mpi3mr-linuxdrv.pdl@broadcom.com,
	ranjan.kumar@broadcom.com,
	sathya.prakash@broadcom.com,
	sreekanth.reddy@broadcom.com,
	sumit.saxena@broadcom.com,
	Wentao Liang <vulab@iscas.ac.cn>,
	stable@vger.kernel.org
Subject: [PATCH] scsi: mpi3mr: Fix tgtdev reference leak in mpi3mr_get_port_id_by_rphy()
Date: Thu, 17 Sep 2026 15:08:35 +0000
Message-Id: <20260917150835.2158315-1-vulab@iscas.ac.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:zQCowABHtD5zAqxqHDWDCA--.5410S2
X-Coremail-Antispam: 1UD129KBjvJXoW7uF1DKrWxurW5tryDJr4kXrb_yoW8Gw1rpF
	s7Wa45ArZ8WFWxAr4kGF45XFWa9a4xJ3y3Gay0kwnY9a1FkFW3AryYgryqvF10yFZ7XFy8
	Zr47XF9rZw4Ut3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUmmb7Iv0xC_Kw4lb4IE77IF4wAFc2x0x2IEx4CE42xK8VAvwI8I
	cIk0rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2
	AK021l84ACjcxK6xIIjxv20xvE14v26ryj6F1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v2
	6F4j6r4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxV
	W0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv
	7VC0I7IYx2IY67AKxVWUtVWrXwAv7VC2z280aVAFwI0_Cr1j6rxdMcvjeVCFs4IE7xkEbV
	WUJVW8JwACjcxG0xvY0x0EwIxGrwACjI8F5VAI37AI020EjII2zVCS5cI20VAGYxC7M4II
	rI8v6xkF7I0E8cxan2IY04v7MxkF7I0En4kS14v26r1q6r43MxAIw28IcxkI7VAKI48JMx
	AIw28IcVCjz48v1sIEY20_Gr43Wr1UJr1l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1l4IxYO2xF
	xVAFwI0_Jrv_JF1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWw
	C2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_JFI_
	Gr1lIxAIcVC0I7IYx2IY6xkF7I0E14v26F4j6r4UJwCI42IY6xAIw20EY4v20xvaj40_Jr
	0_JF4lIxAIcVC2z280aVAFwI0_Gr1j6F4UJwCI42IY6I8E87Iv6xkF7I0E14v26rxl6s0D
	YxBIdaVFxhVjvjDU0xZFpf9x07bbXocUUUUU=
X-CM-SenderInfo: pyxotu46lvutnvoduhdfq/1tbiDAENA2qr9nAdrwAAs2

__mpi3mr_get_tgtdev_by_addr_and_rphy() takes a reference on the target
device, but it is only dropped when the device has a valid hba_port.
When the hba_port has already been cleared because the device is gone,
the function returns without releasing the reference and the target
device is leaked.

Release the reference whenever the lookup succeeds.

Fixes: 8e45183978d6 ("scsi: mpi3mr: Bad drive in topology results kernel crash")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
---
 drivers/scsi/mpi3mr/mpi3mr_transport.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_transport.c b/drivers/scsi/mpi3mr/mpi3mr_transport.c
index 240f67a8e2e3..a95c9352e859 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_transport.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_transport.c
@@ -2499,11 +2499,11 @@ static u8 mpi3mr_get_port_id_by_rphy(struct mpi3mr_ioc *mrioc, struct sas_rphy *
 
 		tgtdev = __mpi3mr_get_tgtdev_by_addr_and_rphy(mrioc,
 			    rphy->identify.sas_address, rphy);
-		if (tgtdev && tgtdev->dev_spec.sas_sata_inf.hba_port) {
+		if (tgtdev && tgtdev->dev_spec.sas_sata_inf.hba_port)
 			port_id =
 				tgtdev->dev_spec.sas_sata_inf.hba_port->port_id;
+		if (tgtdev)
 			mpi3mr_tgtdev_put(tgtdev);
-		}
 		spin_unlock_irqrestore(&mrioc->tgtdev_lock, flags);
 	}
 	return port_id;
-- 
2.34.1

