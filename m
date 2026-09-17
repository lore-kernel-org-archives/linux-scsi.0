Received: from cstnet.cn (smtp25.cstnet.cn [159.226.251.25])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A9ED530E0A;
	Thu, 17 Sep 2026 15:00:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789657231; cv=none; b=JRMp8gxlzurqL741J/q0BsvSgd24Jhzy/z0Rjj5yyNWKOrM+GIZCNw91ll6iN8BHDToMpSy/SqR1b+3ki+WQAgPx7D94cD94YJceI2WQmCiOeghzGq1Six1p9PzScKeRBWXBUsmvmm9XrIrVeH+FHdvVNQCaTLaj6gObm8oFwXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789657231; c=relaxed/simple;
	bh=Th/6TB4Qbm5ZayDAkSjxruwnu8Y8IO8697Cx0Ptu9AM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=j4eB4WD9EvBGtiK3G0U7sHwZHKKhmw+zx9Pp8IzF6Qwz+jzxBn23HY0xaYV/E/gkABbmyAa8n8SSr29nXsqZgusfOxw3J667j7bKg3ZnNx4MacS3HTC2AKoQHVAXyoxoQSg2u5OwwFQLXJ6MUG5WYuW9+3c6cBjKXq6z1b3BQpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from dfae2b116770.home.arpa (unknown [36.110.52.2])
	by APP-05 (Coremail) with SMTP id zQCowADnVD9tAKxq+AyDCA--.5352S2;
	Thu, 17 Sep 2026 22:59:57 +0800 (CST)
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
Subject: [PATCH] scsi: mpi3mr: Fix tgtdev reference leak in mpi3mr_bsg_process_mpt_cmds()
Date: Thu, 17 Sep 2026 14:59:57 +0000
Message-Id: <20260917145957.2157923-1-vulab@iscas.ac.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:zQCowADnVD9tAKxq+AyDCA--.5352S2
X-Coremail-Antispam: 1UD129KBjvdXoWruF1kXFy7ur48Ww47JF4xZwb_yoWkAFbE93
	ZIyr47Cw1FgFsFy340kr1Yyr9Yya18Xryv9Fn7t3yfCF97ZFn7ZF15XrZxJrsrZa1xJw43
	Ar15Xr1ayw1xKjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbqkYjsxI4VWkCwAYFVCjjxCrM7CY07I20VC2zVCF04k26cxKx2IY
	s7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4
	kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_
	Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_JF0_Jw1lYx0Ex4A2jsIE14v26F4UJVW0owAm72CE4IkC6x0Yz7v_Jr
	0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0E0s8F02x267IIx4CEVc8vx2IErcIFxwACI402
	YVCY1x02628vn2kIc2xKxwCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x0EwIxGrwCF04
	k20xvE74AGY7Cv6cx26r48ZrWUJr1UMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8C
	rVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8Zw
	CIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x02
	67AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Gr
	1j6F4UJwCI42IY6I8E87Iv6xkF7I0E14v26rxl6s0DYxBIdaVFxhVjvjDU0xZFpf9x07UW
	CJPUUUUU=
X-CM-SenderInfo: pyxotu46lvutnvoduhdfq/1tbiBwcNA2qr9tgWiAAAs-

The reference taken by mpi3mr_get_tgtdev_by_handle() is only dropped
when tgtdev->starget and tgtdev->starget->hostdata are both valid, so
the reference is leaked when the SCSI target is being torn down and
starget has already been cleared.

Drop the reference unconditionally when the lookup succeeds.

Fixes: 506bc1a0d6ba ("scsi: mpi3mr: Add support for MPT commands")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
---
 drivers/scsi/mpi3mr/mpi3mr_app.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_app.c b/drivers/scsi/mpi3mr/mpi3mr_app.c
index 1353a8ff9c85..e491ab7496cc 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_app.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_app.c
@@ -2741,8 +2741,9 @@ static long mpi3mr_bsg_process_mpt_cmds(struct bsg_job *job)
 			stgt_priv = (struct mpi3mr_stgt_priv_data *)
 			    tgtdev->starget->hostdata;
 			atomic_inc(&stgt_priv->block_io);
-			mpi3mr_tgtdev_put(tgtdev);
 		}
+		if (tgtdev)
+			mpi3mr_tgtdev_put(tgtdev);
 	}
 
 	mrioc->bsg_cmds.state = MPI3MR_CMD_PENDING;
-- 
2.34.1

