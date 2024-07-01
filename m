Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE74D84A30;
	Mon,  1 Jul 2024 09:06:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719824777; cv=none; b=H5CuSUISplx6NyMcgSgOinZhb5r69DC9OPbNEDjKARATGeh6qjm9JWfi81h3RlpXQfT19du2cc29IJKCGCNqGWJ5uS69P0jMpQOFHhkaw+rVny8wYMFPj7AxQY7xnZNv3gUZ+pfNKf0uFr+6HDgVpF5WWw+Q36XJ2HDlgdw6VX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719824777; c=relaxed/simple;
	bh=lHTxC+saNwomHSdQ9/N0PF0JUGiXX9fKozXCfNEoZtY=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=RvVjJzm+HlkDO77wdrNUOE6u7pnzo7kEkPLbge8PUAmz2nJuHEAvdXU6Boxcww3jJhkVJ6qJwBmoChageSZbhdY9ds5BGMbXb+j51QtkCNHyR0XFyCNZd7JD7/+E0Eq8YH/Vqsl39NjZIGgHN4yexYTH38dyV0LEtEui2ZBb4Yo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=j1DEXGds; arc=none smtp.client-ip=115.124.30.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="j1DEXGds"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1719824772; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=3lCDxI9hX7IFUfqrckpaMfqXdk5NsVJ2mROyHOZx4/s=;
	b=j1DEXGdsJCI01MQKkT7MjYKBDuIhb8z5CVRYTLKAxraILJjxmCcErz/IZzaBA30t5DToD/kmvQj3ot2/o9pZ9ZkteIojHI8B3gLO5kGvtfCpD2JHP7Vki6EGHCdwFJW50HTly0pvKc3b62SiRGEq9UirpQ43LwuajwWIrdTtNcI=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033023225041;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0W9cYQiW_1719824764;
Received: from localhost(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0W9cYQiW_1719824764)
          by smtp.aliyun-inc.com;
          Mon, 01 Jul 2024 17:06:11 +0800
From: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To: James.Bottomley@HansenPartnership.com
Cc: martin.petersen@oracle.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
	Abaci Robot <abaci@linux.alibaba.com>
Subject: [PATCH] scsi: sd: Fix unsigned expression compared with zero
Date: Mon,  1 Jul 2024 17:06:03 +0800
Message-Id: <20240701090603.127783-1-jiapeng.chong@linux.alibaba.com>
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

