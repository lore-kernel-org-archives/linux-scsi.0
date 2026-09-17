Received: from cstnet.cn (smtp25.cstnet.cn [159.226.251.25])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C39AD3911C0;
	Thu, 17 Sep 2026 15:07:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789657658; cv=none; b=PMJoQk5vhgCjkAdOssIkogpWlg7Md1juAFl8k68DOatSVjnSHO6ZadzqPAlezIKKSdyPc/d4BGJx6ZzRtH2TC6FSdG7lsVo+/YAfB5qiq/jrTj3Xss9rV7ZC7xLXrcOjZ6DE/mNfpTtmWR+vlttVTbKjCGdSTiV/DXf6pMCzZI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789657658; c=relaxed/simple;
	bh=nVi8Bt23rW1WGkWNx3+yn0J6CrseQb2yYwjUPKZ3GM4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Rvj1EuyvkgKRvr9KDkgK6K1czb1oc2KmrFlLUSc3ijNm/oRwusayGwy2hLS/ByK0NAJ48i6inBfN0BcBAZLccn5WaLNwZn/4+5MTB/1xuLU2EiBeC7nrmVVvP+dB43iE/inHtWhAG5YY+pp2/VIF1L8DnC92EK5xJMwZjeoI17I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from dfae2b116770.home.arpa (unknown [36.110.52.2])
	by APP-05 (Coremail) with SMTP id zQCowAAHKkMmAqxqji6DCA--.45935S2;
	Thu, 17 Sep 2026 23:07:18 +0800 (CST)
From: Wentao Liang <vulab@iscas.ac.cn>
To: James.Bottomley@HansenPartnership.com
Cc: himanshu.madhani@oracle.com,
	kashyap.desai@broadcom.com,
	linux-kernel@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com,
	mpi3mr-linuxdrv.pdl@broadcom.com,
	sathya.prakash@broadcom.com,
	sreekanth.reddy@broadcom.com,
	sumit.saxena@broadcom.com,
	Wentao Liang <vulab@iscas.ac.cn>,
	stable@vger.kernel.org
Subject: [PATCH] scsi: mpi3mr: Fix tgt_dev reference leak in mpi3mr_target_alloc()
Date: Thu, 17 Sep 2026 15:07:18 +0000
Message-Id: <20260917150718.2158250-1-vulab@iscas.ac.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:zQCowAAHKkMmAqxqji6DCA--.45935S2
X-Coremail-Antispam: 1UD129KBjvJXoWxJrWUWF1Dtw45Jr45JFyftFb_yoW8ArWDp3
	9rJas0yrZ0grWftr4rtF98W3Waga4UKry5Ka1xGw1vk3WYkFyIkFyUKry2vFy0yF97Xr1r
	XF4UJFy8Z3yUG3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUPqb7Iv0xC_Kw4lb4IE77IF4wAFc2x0x2IEx4CE42xK8VAvwI8I
	cIk0rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2
	AK021l84ACjcxK6xIIjxv20xvE14v26ryj6F1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v2
	6F4j6r4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxV
	W0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv
	7VC0I7IYx2IY67AKxVWUAVWUtwAv7VC2z280aVAFwI0_Cr1j6rxdMcvjeVCFs4IE7xkEbV
	WUJVW8JwACjcxG0xvY0x0EwIxGrwACjI8F5VAI37AI020EjII2zVCS5cI20VAGYxC7M4II
	rI8v6xkF7I0E8cxan2IY04v7MxkF7I0En4kS14v26r1q6r43MxAIw28IcxkI7VAKI48JMx
	AIw28IcVCjz48v1sIEY20_Gr43Wr1UJr1l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAq
	x4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r
	43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF
	7I0E14v26F4j6r4UJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI
	0_Gr1j6F4UJwCI42IY6I8E87Iv6xkF7I0E14v26rxl6s0DYxBIdaVFxhVjvjDU0xZFpf9x
	07bb5rxUUUUU=
X-CM-SenderInfo: pyxotu46lvutnvoduhdfq/1tbiDAANA2qr9nAczwAAsW

The target device reference taken by __mpi3mr_get_tgtdev_by_perst_id()
and __mpi3mr_get_tgtdev_by_addr_and_rphy() is handed over to
scsi_tgt_priv_data->tgt_dev on the success path. When the target is
hidden or does not match the expected device type, the function returns
-ENXIO without dropping that reference, so it is leaked.

Drop the reference on both error paths.

Fixes: 626665e9c38d ("scsi: mpi3mr: Get target object based on rphy")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
---
 drivers/scsi/mpi3mr/mpi3mr_os.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index 5ff5720f2491..3d75ae422354 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -4965,8 +4965,11 @@ static int mpi3mr_target_alloc(struct scsi_target *starget)
 			scsi_tgt_priv_data->wslen = tgt_dev->wslen;
 			if (tgt_dev->dev_type == MPI3_DEVICE_DEVFORM_VD)
 				scsi_tgt_priv_data->throttle_group = tgt_dev->dev_spec.vd_inf.tg;
-		} else
+		} else {
+			if (tgt_dev)
+				mpi3mr_tgtdev_put(tgt_dev);
 			retval = -ENXIO;
+		}
 	} else if (mrioc->sas_transport_enabled && !starget->channel) {
 		rphy = dev_to_rphy(starget->dev.parent);
 		tgt_dev = __mpi3mr_get_tgtdev_by_addr_and_rphy(mrioc,
@@ -4983,8 +4986,11 @@ static int mpi3mr_target_alloc(struct scsi_target *starget)
 			tgt_dev->starget = starget;
 			atomic_set(&scsi_tgt_priv_data->block_io, 0);
 			retval = 0;
-		} else
+		} else {
+			if (tgt_dev)
+				mpi3mr_tgtdev_put(tgt_dev);
 			retval = -ENXIO;
+		}
 	}
 	spin_unlock_irqrestore(&mrioc->tgtdev_lock, flags);
 
-- 
2.34.1

