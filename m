Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E90482D7DEF
	for <linux-scsi@vger.kernel.org>; Tue, 23 Jun 2026 10:02:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782208966; cv=none; b=o+FzRDp39drsBdhgbrMWZUN3wt7P2T9jmvR92vWlT5FG41OEKsEsXmZ+20gEpGSllvs0dMT/aDK9LTSOg4Or3fzwg516QEn4LoN+ZWPp1hLLv8NGs6OsUQSt/+w1omQ99M0YNSpCaA2V5kyVE2tniHenUl1VL7zhxDCBk6IH4U8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782208966; c=relaxed/simple;
	bh=Io5JroLQDTpd8+NJd9T//DiaBnmcPaHgKzDeOQTTdBw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=aBAIyNursjoVuQrVs+Vqpx1/2x6AQvVZ2qiQ3TvaCSghnJw6vroryZOUh9KXWA7BT8XmcrFZlgxDPfqm+yXx3lAMUPZGtaod4W36J+HWDy/9Fp5v399HHJWdJZTVoWUZt76BaPi2dY8+RZArrkHDLtSVZJuLLAAFbVRJrHBwI5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=LieeMFXG; arc=none smtp.client-ip=220.197.31.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="LieeMFXG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=9d
	MGFFlM/VbKYpFk6P8CWjd6H8GtHSF6qm5cx5Ee0+s=; b=LieeMFXGGeYonEu1uH
	LIr8EwvRTi8601oEtQ4FYeh22V+5xRTa9SEnEoGFwMTBpren57V8V0aMHC2anXDk
	21wfAAZzOJ0PKZJ9i+mTxtQ85dgFXeIalop1H5DBCw+GBMZtkd/oaAPbsrdmxYxX
	i7OpVeSKJZUrgYebitxHCJfh8=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g0-1 (Coremail) with SMTP id _____wAntXCaWTpqUiV6FA--.20165S3;
	Tue, 23 Jun 2026 18:02:04 +0800 (CST)
From: Yang Xiuwei <yangxiuwei@kylinos.cn>
To: martin.petersen@oracle.com,
	James.Bottomley@HansenPartnership.com
Cc: hare@suse.de,
	tom.leiming@gmail.com,
	p.raghav@samsung.com,
	dlemoal@kernel.org,
	sw.prabhu6@gmail.com,
	linux-scsi@vger.kernel.org,
	Yang Xiuwei <yangxiuwei@kylinos.cn>
Subject: [PATCH v1 1/4] scsi: sd: fix error handling in sd_probe() after large pool creation failure
Date: Tue, 23 Jun 2026 18:01:56 +0800
Message-Id: <20260623100159.4018066-2-yangxiuwei@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260623100159.4018066-1-yangxiuwei@kylinos.cn>
References: <20260623100159.4018066-1-yangxiuwei@kylinos.cn>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wAntXCaWTpqUiV6FA--.20165S3
X-Coremail-Antispam: 1Uf129KBjvdXoWrZF4xJF4UZw1DXw45Ar1UZFb_yoWfWFX_ur
	4I9397Wr1Ykr4xG3ZFkw1Yvry0vrsagr48ur4rtF95J3y2q39avFW0vrn8Ca1UW3y7ur1r
	Aw1jvr1Syw4kGjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IU0YsjUUUUUU==
Sender: yangxiuwei2025@163.com
X-CM-SenderInfo: p1dqw55lxzvxisqskqqrwthudrp/xtbCwh2mN2o6WZ3k2AAA3m

After device_add(&sdkp->disk_dev) succeeds, sd_large_pool_create()
failure must unregister disk_dev and let scsi_disk_release() free
sdkp. Going through out_free_index kfree()s an already registered
device and leaks the sysfs entry.

Fixes: 7179e626b76e ("scsi: sd: Enable sector size > PAGE_SIZE in SCSI sd driver")
Signed-off-by: Yang Xiuwei <yangxiuwei@kylinos.cn>
---
 drivers/scsi/sd.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 599e75f33334..d18693d390b2 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -4089,7 +4089,9 @@ static int sd_probe(struct scsi_device *sdp)
 	if (sdp->sector_size > PAGE_SIZE) {
 		if (sd_large_pool_create()) {
 			error = -ENOMEM;
-			goto out_free_index;
+			device_unregister(&sdkp->disk_dev);
+			put_disk(gd);
+			goto out;
 		}
 	}
 
-- 
2.25.1

