Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D7281E633C
	for <linux-scsi@vger.kernel.org>; Tue, 17 Dec 2024 10:58:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734433134; cv=none; b=oZ9W/R/jq0L4c0LNd21/XweOLv1YAI66srjfXCdRDVc5iq9ksk1Nx0V08czzDMBvtFCtswKhLiVBjGcBxVve9aunU3xrKojrirPvNQuSEj0wLtcNcOjEDsfWQfHL/eOkjbs6kyMnEb9P1HMyYfOOLkOcc1y8N6TYJLZv6JuCv+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734433134; c=relaxed/simple;
	bh=3OB44eyTbxaAXpNXVvxB3xTKoDXtUS0JRvqnqh/ThhE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=oASfRaj/iBVq7JQrVT5BS2lPObXxU5oaUv7HvW+KOEu6ertLJpDWYuRLqIB6RDexozHtSya5hZEC7ph+buLp7poh/Nz0Gnjl8diKzXwSta/5oajdVIKwkbwORW9qqC14DEAI1atgghVxwPvtrQ+NmVv4Lgx2BYuBddXFNfd44FI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=Vg+MQ6HB; arc=none smtp.client-ip=115.124.30.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="Vg+MQ6HB"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1734433126; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=d7IV8y6wRJmmWKUqGFfJ2cgCPVjXaDZQiKCDQ2JJTqU=;
	b=Vg+MQ6HBt+X+7l8+3uPCl9XI7Q52ua156a5KDTo48i3J3pngZvFAQbo92ygc3WTttHiYng5aqNqYFp5GOWTuDATjeVQi+GCZO9LN7QFk+8sJxrQabsWPRbiqnMTOQlnJJZ5c1E8faL0oKb1Csg4vrQtFCItap4DmtZAyeKReaUc=
Received: from localhost(mailfrom:kanie@linux.alibaba.com fp:SMTPD_---0WLiWqBt_1734433120 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 17 Dec 2024 18:58:45 +0800
From: Guixin Liu <kanie@linux.alibaba.com>
To: Alim Akhtar <alim.akhtar@samsung.com>,
	Avri Altman <avri.altman@wdc.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
Subject: [PATCH 0/2] fix some bsg related bugs
Date: Tue, 17 Dec 2024 18:58:38 +0800
Message-ID: <20241217105840.120081-1-kanie@linux.alibaba.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Guixin Liu (2):
  scsi: ufs: delete bsg_dev when setup bsg fail
  scsi: ufs: set bsg_queue to NULL after remove

 drivers/ufs/core/ufs_bsg.c | 2 ++
 1 file changed, 2 insertions(+)

-- 
2.43.0

