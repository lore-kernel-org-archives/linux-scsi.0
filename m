Received: from cstnet.cn (smtp25.cstnet.cn [159.226.251.25])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C10B48489E;
	Thu, 17 Sep 2026 15:01:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789657294; cv=none; b=GSDYy+V/JVNWI1A9ewn+16b5HgRe+lk98Zfat4UTf6hebTtxX3IIQJWnWQXPo6eLtpd3B0cj2LTTbGAYrNpSv/RdFLkwi6kQf9KTQeMHmB0jT4Ih9GzJ3gwtkA9Q3+2RPlnT3GINnIPZa5ZCslRjo+L3Xq4N1E7sjG8sNX+B33s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789657294; c=relaxed/simple;
	bh=s9Eq3Fh7UYfJqyZWXfEu3SIGux5mTjuCCKy608Kk1jE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=M3JlJ+ifEfjEF/2MmCGGhKa+HHZvcULqazWtVv7rLOF6e1qai/3FkxvvjfA83SWlmhx6TqnaaD2QVT33iWOo2sN0iVqpgJngx1qyBJkI1ybiTffn4cZOTcZBCx3/6PU+q0KdoVmwtAkukC4mArJj6vMT0SyeihG8xlrfnw0sdBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from dfae2b116770.home.arpa (unknown [36.110.52.2])
	by APP-05 (Coremail) with SMTP id zQCowADHMTyyAKxqoRKDCA--.5279S2;
	Thu, 17 Sep 2026 23:01:06 +0800 (CST)
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
Subject: [PATCH] scsi: mpi3mr: Fix tgtdev reference leak in mpi3mr_dev_rmhs_send_tm()
Date: Thu, 17 Sep 2026 15:01:06 +0000
Message-Id: <20260917150106.2157994-1-vulab@iscas.ac.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:zQCowADHMTyyAKxqoRKDCA--.5279S2
X-Coremail-Antispam: 1UD129KBjvdXoWrZr4xXF17KFyUXF1fWry8Zrb_yoWkZFb_uF
	s0vr97J34FgF4UJr4UCr13ZF9Ivw1UXrZ29Fnrtw4xCr9xXFyxXr1UXr1UZr47Za1rJr13
	Aw1UZryaqr17WjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbqkYjsxI4VWkKwAYFVCjjxCrM7CY07I20VC2zVCF04k26cxKx2IY
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
	1j6F4UJwCI42IY6I8E87Iv6xkF7I0E14v26rxl6s0DYxBIdaVFxhVjvjDU0xZFpf9x07bb
	5rxUUUUU=
X-CM-SenderInfo: pyxotu46lvutnvoduhdfq/1tbiBwUNA2qr9tgXlwAAsj

__mpi3mr_get_tgtdev_by_handle() takes a reference on the target device,
but mpi3mr_dev_rmhs_send_tm() never drops it on any of its return paths.
The completion callbacks only track the device handle, so the reference
is leaked for every device removal handshake.

Release the reference once the device state has been updated.

Fixes: 3f1254ed01d0 ("scsi: mpi3mr: Successive VD delete and add causes FW fault")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
---
 drivers/scsi/mpi3mr/mpi3mr_os.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index 402d1f35d214..8a2575171e1f 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -2520,6 +2520,8 @@ static void mpi3mr_dev_rmhs_send_tm(struct mpi3mr_ioc *mrioc, u16 handle,
 	if (tgtdev && (iou_rc == MPI3_CTRL_OP_REMOVE_DEVICE))
 		tgtdev->state = MPI3MR_DEV_REMOVE_HS_STARTED;
 	spin_unlock_irqrestore(&mrioc->tgtdev_lock, flags);
+	if (tgtdev)
+		mpi3mr_tgtdev_put(tgtdev);
 
 	if (drv_cmd)
 		goto issue_cmd;
-- 
2.34.1

