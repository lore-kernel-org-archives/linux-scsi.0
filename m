Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B0C7175A94;
	Mon, 30 Mar 2026 01:50:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774835451; cv=none; b=JvzYrUwl0sYkkOQA0K+NIt3YDYBN9Q+2xGoMH+b+o1Fn9+7eRpSRvkgEhsrqpG+ACwb2LNq7QPGWkObgycJoB5Xx5KwiD6cAvMbHG1c1D1SwOd8knt/fsy8eNxYx7Fla4BhUQHFHppMziPjeQ7nA+F7K0eUKYDX2N3PIWH8qqBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774835451; c=relaxed/simple;
	bh=ixolLrzbUpURqHptEtvef9b4lOdNhT+Rdvm7+Wzk7oI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=H9fGqnnpVxIvYfwYputrgCl2vZotg9vtxHblmhI7H3fVKJU4f6c3ZchzEKtbQoGwOW5wP3P2FyQ97ChSU9IJS+BfvoZKxeFZyynBNhXOQAheTzU9uaqAyCiyYH4xe+WZWmFvxgcTCJhBO9p+PIbiIR8Q4ZO+HcBgUeGz68zaehw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=d5nwJ4ET; arc=none smtp.client-ip=117.135.210.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="d5nwJ4ET"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=NE
	ibGSjdedDB2R09UgpFcazFFhoARzqkN4HerJmT4qc=; b=d5nwJ4ETho8JxC7O5k
	DZjech+vSWq+RCUoQjp88dhvQ7nEJDuSBUGNVAtSt54eRvlEspNUonPkWkfIJ9TK
	VKlE4dEMfcRt4Lv7qzROffSECnQIEbKCFyKMeFlXMwvED5M/rHmujhGlZjYDPeqt
	g4kotpPI7GK4rQ7iEm25bkt3I=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g0-0 (Coremail) with SMTP id _____wBXIKzC1slpl0wrCA--.20436S2;
	Mon, 30 Mar 2026 09:49:56 +0800 (CST)
From: Yang Xiuwei <yangxiuwei@kylinos.cn>
To: James Bottomley <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Ming Lei <ming.lei@redhat.com>,
	Bart Van Assche <bvanassche@acm.org>,
	John Garry <john.g.garry@oracle.com>,
	stable@vger.kernel.org,
	Yang Xiuwei <yangxiuwei@kylinos.cn>
Subject: [PATCH v3] scsi: sd: fix missing put_disk() when device_add(&disk_dev) fails
Date: Mon, 30 Mar 2026 09:49:52 +0800
Message-Id: <20260330014952.152776-1-yangxiuwei@kylinos.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wBXIKzC1slpl0wrCA--.20436S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrury5KF48tFWDAFW3KF1DAwb_yoWDurX_Cw
	1jvwn7Xr4UAr1xtF1fGr4avrWvgrnFgrWrur48tF93A3yYgr9IvFykCw1Yy3W8WwsFvF18
	Xwn0vw4kJw4UJjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IU189NPUUUUU==
Sender: yangxiuwei2025@163.com
X-CM-SenderInfo: p1dqw55lxzvxisqskqqrwthudrp/xtbCwgSzRGnJ1sSd2QAA3H

If device_add(&sdkp->disk_dev) fails, put_device() runs
scsi_disk_release(), which frees the scsi_disk but leaves the gendisk
referenced. The device_add_disk() error path in sd_probe() calls
put_disk(gd); call put_disk(gd) here to mirror that cleanup.

Fixes: 265dfe8ebbab ("scsi: sd: Free scsi_disk device via put_device()")
Cc: stable@vger.kernel.org
Reviewed-by: John Garry <john.g.garry@oracle.com>
Signed-off-by: Yang Xiuwei <yangxiuwei@kylinos.cn>
---
v2: Add Fixes: and Cc: stable; add a short note on how the issue was found.
v3: Commit message and subject refined per review; add Reviewed-by from John Garry.

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

