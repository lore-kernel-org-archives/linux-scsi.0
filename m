Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBADF392814
	for <linux-scsi@vger.kernel.org>; Thu, 19 Mar 2026 06:58:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773903508; cv=none; b=hn60BiqspMQ/kEE24CaShNCLEe3Y1Wu+kahGGJ/tDGDlfButxQpi7PE9SXVr0KIDNFl4X6CD3DpmmmqWVgc53W7BJwiXVEAJgbos4MSEMW1Qo2N+pkWQMJ0m96Kd3EEmbmLcjXAgKwIkJcsVs+NlSi1JkghRe0SwIxz1DgCAZa8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773903508; c=relaxed/simple;
	bh=/Cg4niMGxDPQEuR90EFCitwoaXlaQyjwtocHXVtoAAc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=cGbrxNeK7K+UiYsUoUpG6qHYolDXhcYUb8HAOTAS6YuP+fDoAAmswSfVW1GvVFwg+NqAU0hmomLfeFbOf+hWGgxoFZLQBw403+PTda0p5qfpKKLr8uL7CvRGEYspUMQzBHC26CxZGrsyO3wMH3AKEsUH2s5e8tvHhAJM4A0xWno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=DqxprFvS; arc=none smtp.client-ip=117.135.210.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="DqxprFvS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=fH
	GFKmqPRZ+5Nq8LPdxnrvfDfySegfQvGLB1jP3kpk8=; b=DqxprFvSG0uAdx6bC6
	rrCB4jTFLEaRW7pKY+WT0/ncZ4yOzwIH76I9XPMHQXx3XUpu5uSCAnMhv3O3mUVA
	LnQerFuwGOgqxC5WhCt2ETykVo2n/icEq+dPY5YYZV+ZHMLn4A9UaPD6tliQspJQ
	w97S+x3EUlVLXPhCPEHg9sONA=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g1-2 (Coremail) with SMTP id _____wBXn+15nrtpls2UAA--.24337S2;
	Thu, 19 Mar 2026 14:58:03 +0800 (CST)
From: Yang Xiuwei <yangxiuwei@kylinos.cn>
To: James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org,
	Yang Xiuwei <yangxiuwei@kylinos.cn>
Subject: [PATCH] scsi: sd: fix missing put_disk() in sd_probe() error path
Date: Thu, 19 Mar 2026 14:57:59 +0800
Message-Id: <20260319065759.2413777-1-yangxiuwei@kylinos.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wBXn+15nrtpls2UAA--.24337S2
X-Coremail-Antispam: 1Uf129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
	VFW2AGmfu7bjvjm3AaLaJ3UbIYCTnIWIevJa73UjIFyTuYvjxUeUDXUUUUU
Sender: yangxiuwei2025@163.com
X-CM-SenderInfo: p1dqw55lxzvxisqskqqrwthudrp/xtbCwhsPn2m7nnsOvgAA3O

Call put_disk(gd) when device_add(&sdkp->disk_dev) fails in sd_probe()
to keep error-path cleanup balanced.

Signed-off-by: Yang Xiuwei <yangxiuwei@kylinos.cn>
---
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

