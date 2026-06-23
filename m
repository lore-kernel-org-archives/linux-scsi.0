Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2CA02288D5
	for <linux-scsi@vger.kernel.org>; Tue, 23 Jun 2026 10:03:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782209004; cv=none; b=YEV9RK74buksZe6+d3K43cHcIpOOdvS3HSONLpr22MWOCBNHSdAfw8T4hf0gxtMXPRldG1Gtyst/07LfnAGiOWQrhPxwtEbGd+tkkCV9ay+7evYDsRss1Nnl/DMt4C78jpUsg1YvAe8e/Ic+rqeLpf+SWTBebyRomsZ0+hm7N00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782209004; c=relaxed/simple;
	bh=Sv4hfZnHYbRz4iOwkJwzG9DibbAGMWmDMwV+1Xi1olQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=tMDvOVWDZ+0KhE4u1FqcSv15RjFLa+GJQMHaKPSQmIFPLxn7iNG3Hl6dwKdgP/4XFGNjK7kalcn6dqlBQ10Globyz48HDih28E5G4VVgmHt01P7FEZWOOEdZJ0uGL6fGdxS75Z5LeF6OElyssLANNPp2F4ydoXLDsh1r3j90fvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=DWRUlTTo; arc=none smtp.client-ip=220.197.31.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="DWRUlTTo"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=zr
	8rSh6IE5MJF3btMAIdKeyaUQfyZwaphnWgQelHE0o=; b=DWRUlTTovJPVZb9Bvt
	Yeet9PlZxprmjdAULgAYl7NhrxGKgUjuVY7XTaUP0ihNkx9aLNJuhUCAQPcOy2Dc
	0TpZHyyYN7c1AHWO7Dek5XajniO6nytWh4iVf8apUfq9uR05Q66VRX5CCBjUWws7
	AXeT7NZx3WCjz7mbI985GTxSA=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g0-1 (Coremail) with SMTP id _____wAntXCaWTpqUiV6FA--.20165S4;
	Tue, 23 Jun 2026 18:02:06 +0800 (CST)
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
Subject: [PATCH v1 2/4] scsi: sd: unify sd_probe() error cleanup through out_put
Date: Tue, 23 Jun 2026 18:01:57 +0800
Message-Id: <20260623100159.4018066-3-yangxiuwei@kylinos.cn>
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
X-CM-TRANSID:_____wAntXCaWTpqUiV6FA--.20165S4
X-Coremail-Antispam: 1Uf129KBjvJXoW7ZF1UJF18CF43Kw4kJr13urg_yoW8GF1DpF
	4kXas0yrW0vF40kr15AaykXa45Ka4S93yxWFWUGw1a9wnYy39Yg39akFyUXFn7JFWrAFWU
	JF1UK3WDCF48Kr7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07j4zuAUUUUU=
Sender: yangxiuwei2025@163.com
X-CM-SenderInfo: p1dqw55lxzvxisqskqqrwthudrp/xtbC6R6mN2o6WZ4m1QAA3C

After put_device() or device_unregister() has released sdkp through
scsi_disk_release(), set sdkp to NULL and fall through to out_put so
put_disk() and kfree() are handled in one place.

Suggested-by: Ming Lei <tom.leiming@gmail.com>
Signed-off-by: Yang Xiuwei <yangxiuwei@kylinos.cn>
---
 drivers/scsi/sd.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index d18693d390b2..b096ea237f14 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -4060,8 +4060,8 @@ static int sd_probe(struct scsi_device *sdp)
 	error = device_add(&sdkp->disk_dev);
 	if (error) {
 		put_device(&sdkp->disk_dev);
-		put_disk(gd);
-		goto out;
+		sdkp = NULL;
+		goto out_put;
 	}
 
 	dev_set_drvdata(dev, sdkp);
@@ -4090,8 +4090,8 @@ static int sd_probe(struct scsi_device *sdp)
 		if (sd_large_pool_create()) {
 			error = -ENOMEM;
 			device_unregister(&sdkp->disk_dev);
-			put_disk(gd);
-			goto out;
+			sdkp = NULL;
+			goto out_put;
 		}
 	}
 
@@ -4109,11 +4109,11 @@ static int sd_probe(struct scsi_device *sdp)
 
 	error = device_add_disk(dev, gd, NULL);
 	if (error) {
-		device_unregister(&sdkp->disk_dev);
-		put_disk(gd);
 		if (sdp->sector_size > PAGE_SIZE)
 			sd_large_pool_destroy();
-		goto out;
+		device_unregister(&sdkp->disk_dev);
+		sdkp = NULL;
+		goto out_put;
 	}
 
 	if (sdkp->security) {
-- 
2.25.1

