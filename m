Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F4D41DB95E;
	Fri, 20 Mar 2026 01:58:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773971943; cv=none; b=VathG3PZyBFua4QEYftZPefSLkAW7Jd9qkrTj0je/xWofEugfDHuq5kcg8g5pfyH1uwj7Ry5vWeakxZxCtzLf5GlqkD/+/sB9A6dtF+Mfgf1qgy8gXPKIq6iUnhyExJHv2aSdTAGWsjK/wvbl9adXCsMar2I05dcwlW7iH2pWoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773971943; c=relaxed/simple;
	bh=q7BIV0f9uh9UO6U+lPe/81tyE64RSWoZSgt8NXkumSg=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=HwqRjSxQU4t+/wwPi3Q8QJ40QWdwktTI8vDkftcKB5aq8RhzOZk2RBqDL4C01hDAS9dVThlMeBxsEKb5lD0/fwLs7vtMTNSxo2u4nN7imLVH6EabcmK0hHlgtUE+yY/M7Bo5oIjXYJ7BOkoNYETufPdeFcJlLc0BCBoNswvMaaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=KQFdPjaJ; arc=none smtp.client-ip=220.197.31.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="KQFdPjaJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=fU
	3gFdWhksndp8ua90z3+ckJW7q7uK0NJ919E6T35Yk=; b=KQFdPjaJoN0MR8rTEi
	VmZGT0GlnG5z+LMorwPSmvOSqZFGh0GJkNUt0sDReI79KmZonqsJxAiy2P63x5WB
	bFRnidW5guK7/g2hVAzr9SXZNiNjiFMkxAHOAF17dMjg8HbTi5YQDgKFi8/kQPOV
	j75ChbX46etRrrGm1uTMlu2y8=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g0-1 (Coremail) with SMTP id _____wD333G6qbxpkTUqAQ--.53736S2;
	Fri, 20 Mar 2026 09:58:20 +0800 (CST)
From: Yang Xiuwei <yangxiuwei@kylinos.cn>
To: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Ming Lei <ming.lei@redhat.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Yang Xiuwei <yangxiuwei@kylinos.cn>,
	stable@vger.kernel.org
Subject: [PATCH v2] scsi: sd: fix missing put_disk() in sd_probe() error path
Date: Fri, 20 Mar 2026 09:58:17 +0800
Message-Id: <20260320015817.4080359-1-yangxiuwei@kylinos.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wD333G6qbxpkTUqAQ--.53736S2
X-Coremail-Antispam: 1Uf129KBjvdXoW7XFyktw15CF1ruF18Gw4kWFg_yoW3urg_Cw
	4jv3s7Xr4jyFn3twn3ur4avryv9rnFgrZYkrsYqF9ay39xXr90gFy5uFnYya18WrsIyr18
	X3Z0qwnYyw4DtjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IU1-txJUUUUU==
Sender: yangxiuwei2025@163.com
X-CM-SenderInfo: p1dqw55lxzvxisqskqqrwthudrp/xtbC6Rwjs2m8qbwjpAAA3i

Call put_disk(gd) when device_add(&sdkp->disk_dev) fails in sd_probe()
to keep error-path cleanup balanced.

The issue was found while studying the code.

Fixes: 265dfe8ebbab ("scsi: sd: Free scsi_disk device via put_device()")
Cc: stable@vger.kernel.org
Signed-off-by: Yang Xiuwei <yangxiuwei@kylinos.cn>
---
v2: Update commit message (add Fixes, Cc stable, and how the issue was found).

 drivers/scsi/sd.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 628a1d0a74ba..aba22060fcd5 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -4018,6 +4018,7 @@ static int sd_probe(struct scsi_device *sdp)
 	error = device_add(&sdkp->disk_dev);
 	if (error) {
 		put_device(&sdkp->disk_dev);
+		put_disk(gd);
 		goto out;
 	}
 
-- 
2.25.1

