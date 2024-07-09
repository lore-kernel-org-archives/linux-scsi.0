Received: from out30-112.freemail.mail.aliyun.com (out30-112.freemail.mail.aliyun.com [115.124.30.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AC35156653;
	Tue,  9 Jul 2024 09:40:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.112
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720518009; cv=none; b=Jg77rEiCLt0uZfBMNg3sWC2L+0KoO4mWT7cmvPthHYqhOgx4M+WtY8iKoUEPIMXTjN4RYfIrtb3CDvtMyIXXsqb4c0X6F2CMk0/uM/9yS8p4kKK6e8bT+7btpYGLRxvzB9l5AKD2fW4edMGp/loVUOA5KdeW4RKCEA+I/r6kmvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720518009; c=relaxed/simple;
	bh=gQ7kC5SGovZDvSADjUTJZ6Fcw7+9Z/764TPVWo8xpwg=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=F/5HC1GEFgCxSYnEn1e8b1QNQDXPluWmtDbeL6OYmsaKX3ESNMgT4NQxt0sJnomZa1JIyi5A6Q9wrIik8IjxgRwKCLvKXyjZL0w8bLgxHA126rzD/yPVBnIVpXZlVE2H6SOKaluhKeilZ2LVF3f42yb0fXKAj60M9UAw0mwI9es=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=G7F7WjWe; arc=none smtp.client-ip=115.124.30.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="G7F7WjWe"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1720517997; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=ze6TTXQFJsy3uKftoLUHbYsxNvRLtcLf0BpbQzfmY4s=;
	b=G7F7WjWeM2JlDOSSBA4fkD0Uu9Y6S0wJlfIfwnNJN3r12/Ii77EY65FR+ZIPDZ+cFbZUxHWYMVH5ZYlt7gaplZ9oFKp23MZ6qeQHtsS6GSOOFc/dK9Cq7JO0j/8J1lYqDoNswRv/HsdLPeI/kaC8B1PEd0VOGVOWels5APqlhqI=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037067109;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0WABZZFV_1720517989;
Received: from localhost(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0WABZZFV_1720517989)
          by smtp.aliyun-inc.com;
          Tue, 09 Jul 2024 17:39:57 +0800
From: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To: James.Bottomley@HansenPartnership.com
Cc: martin.petersen@oracle.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
	stable@vger.kernel.org,
	Abaci Robot <abaci@linux.alibaba.com>
Subject: [PATCH -next v3] scsi: sd: Fix an incorrect type in 'sd_spinup_disk()'
Date: Tue,  9 Jul 2024 17:39:48 +0800
Message-Id: <20240709093948.9617-1-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 2.20.1.7.g153144c
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The return value from the call to scsi_execute_cmd() is int. In the
'else if' branch of the function scsi_execute_cmd, it will return -EINVAL.
But the type of "the_result" is "unsigned int", causing the error code to
reverse. Modify the type of "the_result" to solve this problem.

The code featuring the_result as the return value of the function
scsi_execute_cmd is as follows:

the_result = scsi_execute_cmd(sdkp->device, cmd, REQ_OP_DRV_IN, NULL, 0,
			      SD_TIMEOUT, sdkp->max_retries, &exec_args);
if (the_result > 0) {
...
}

./drivers/scsi/sd.c:2333:6-16: WARNING: Unsigned expression compared
with zero: the_result > 0.

Fixes: c1acf38cd11e ("scsi: sd: Have midlayer retry sd_spinup_disk() errors")
Cc: stable@vger.kernel.org
Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Closes: https://bugzilla.openanolis.cn/show_bug.cgi?id=9463
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
Changes in v3:
  -Amend the commit message, Add "Fixes:" and "Cc: stable" tags.

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

