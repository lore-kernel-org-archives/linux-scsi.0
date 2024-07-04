Received: from out30-118.freemail.mail.aliyun.com (out30-118.freemail.mail.aliyun.com [115.124.30.118])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D6BD1755B;
	Thu,  4 Jul 2024 03:14:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.118
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720062898; cv=none; b=IwV5j/e4a8aRv1HswYCDoIj5HdUQfDqZ43019gnD8eZtxT2RQZUFMu6+Kvlw+98ymcPHYRAYduPlg5kT2fNLhYWjryR4/F+rQRlZsuaL6T1xwJdyvjW9eOcZ9ei6AOwjEFSvZi5vGM5xHW2Qa3OkRo3AGL7fanj+iqtuWZcFNdk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720062898; c=relaxed/simple;
	bh=b/gHoHFvfnRitOnCPnbxz7q3Yi/4YiKr38RDiWGmXME=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=newsIh1dI4XLonMOYGFW0KXL547M3Lct4g0qzo1jhEqH/63ay2t/1VWra1k+AOQbz34RbXgYv10utIIW2IQgBjeAYVRiqe+LhA21SEmOinF15N/VTNNW5aZzX/ZC4f66r8KyNEabzuSFOJvBUzDXyVr5G+gssYB9GEynbLbp/x4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=SP+E4e9M; arc=none smtp.client-ip=115.124.30.118
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="SP+E4e9M"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1720062887; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=1qYRwDAjG14tepuD9YOlPlqvo6o8X3iseM2dxd+zflQ=;
	b=SP+E4e9M5qf8O/bmqdFfj/EXvu0LMj4zB/6nCBD1arTmvBSusu6fFTR0Lfw1By9/1kJv2HNvu3wtFRuUbB6mAKjo4+qmAvjBcBnLZcVOr/8Rdl3HIf1M3toSWHF9qEmEYFYTcTLZSmHrY6wZJn8BYDNJZyBfKmzKF3V2zeQXk08=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037067110;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0W9oz.yS_1720062878;
Received: from localhost(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0W9oz.yS_1720062878)
          by smtp.aliyun-inc.com;
          Thu, 04 Jul 2024 11:14:47 +0800
From: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To: James.Bottomley@HansenPartnership.com
Cc: martin.petersen@oracle.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
	Abaci Robot <abaci@linux.alibaba.com>
Subject: [PATCH -next v2] scsi: sd: Fix unsigned expression compared with zero in sd_spinup_disk()
Date: Thu,  4 Jul 2024 11:14:37 +0800
Message-Id: <20240704031437.33338-1-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 2.20.1.7.g153144c
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The return value from the call to scsi_execute_cmd() is int. However, the
return value is being assigned to an unsigned int variable 'the_result',
so making 'the_result' an int.

./drivers/scsi/sd.c:2333:6-16: WARNING: Unsigned expression compared with zero: the_result > 0.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Closes: https://bugzilla.openanolis.cn/show_bug.cgi?id=9463
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
Changes in v2:
  -Refine the title to make it more precise.

 drivers/scsi/sd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 979795dad62b..ade8c6cca295 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2396,7 +2396,7 @@ sd_spinup_disk(struct scsi_disk *sdkp)
 	static const u8 cmd[10] = { TEST_UNIT_READY };
 	unsigned long spintime_expire = 0;
 	int spintime, sense_valid = 0;
-	unsigned int the_result;
+	int the_result;
 	struct scsi_sense_hdr sshdr;
 	struct scsi_failure failure_defs[] = {
 		/* Do not retry Medium Not Present */
-- 
2.20.1.7.g153144c

