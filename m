Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.5])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C5885287255;
	Tue, 19 Aug 2025 02:28:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755570509; cv=none; b=vDZoQMlDMyviolA1+W58KiXr3UxxDHXk70R3iAzlE4gJKfSQ1JWPzY+HYAaaDqNnYwN77gDhhCYHGDwQwDa74WEKQa+yy64mYFUAc4ToYy1RhYZSRtAWPoa1VTbWOrOsMM4m4uri5yqeBwT8gJ2KrmNoETnNBJDRdh1/M9o3LBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755570509; c=relaxed/simple;
	bh=b1qUQAM60cMYPl7V0ScUvR9LA9K1JoHvN22P5gTDwR0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ZM/DijsaDThcA7dc+W5X8R5Kya6nYJpS6rJfIpRNH5Vv7uD1NQjnbZJ3EJskqvgw6ff6I/duv2yoKnwDmgwv0BTqJahdAboPaMEYHi8yHjc/GDYFTMv+0qvWlg45ouOiOqtqfc4liTf8EUvi7SbZX7BKnLqHTMkgIb3hqm2lgHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=mtq4aona; arc=none smtp.client-ip=220.197.31.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="mtq4aona"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=Ev
	Tdpk/C0SrAV2N3VjzKTmAB7DE/+/AoiCYzOgohIRY=; b=mtq4aonaq+oxJVo6vM
	rQo9+7Fkns6hTmltFs55bjpZaAtw1S9romu0+UjryOcgTPPLcBpm1pmAG2Dn32ZY
	3m0iFERr8GjHrG24TXY1kStmikJ3SKiWbD0iT5ytoxGplix3ri5QomYtJy71gzfI
	tangbZ0tPm3DzPN9Ukqwboo/U=
Received: from neo-TianYi510Pro-15ICK.. (unknown [])
	by gzsmtp1 (Coremail) with SMTP id PCgvCgC3wvc94aNoBOexAg--.10428S2;
	Tue, 19 Aug 2025 10:28:16 +0800 (CST)
From: liuqiangneo@163.com
To: James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	liuqiang@kylinos.cn
Subject: [PATCH] scsi: aic94xx: remove self-assigned redundant code
Date: Tue, 19 Aug 2025 10:28:10 +0800
Message-ID: <20250819022811.14925-1-liuqiangneo@163.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PCgvCgC3wvc94aNoBOexAg--.10428S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrtryxGF4xtw4UCF48Ww4xtFb_yoWfGrc_Wr
	Wjvan7WryUJrs7Kw15Aa45Jr9Yva1xW3y8u3s0vr93A3WSvFW5Zw1DAF9rAw4kG3yYyFy7
	JrW8WF1Fkr1ktjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IU1oGQPUUUUU==
X-CM-SenderInfo: 5olx1xxdqj0vrr6rljoofrz/xtbBNQquYWij31I52QAAsW

From: Qiang Liu <liuqiang@kylinos.cn>

Assigning ssp_task.retry_count to itself has no effect

Signed-off-by: Qiang Liu <liuqiang@kylinos.cn>
---
 drivers/scsi/aic94xx/aic94xx_task.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/aic94xx/aic94xx_task.c b/drivers/scsi/aic94xx/aic94xx_task.c
index 4bfd03724ad6..b26a468ddc98 100644
--- a/drivers/scsi/aic94xx/aic94xx_task.c
+++ b/drivers/scsi/aic94xx/aic94xx_task.c
@@ -488,7 +488,6 @@ static int asd_build_ssp_ascb(struct asd_ascb *ascb, struct sas_task *task,
 	scb->ssp_task.conn_handle = cpu_to_le16(
 		(u16)(unsigned long)dev->lldd_dev);
 	scb->ssp_task.data_dir = data_dir_flags[task->data_dir];
-	scb->ssp_task.retry_count = scb->ssp_task.retry_count;
 
 	ascb->tasklet_complete = asd_task_tasklet_complete;
 
-- 
2.43.0

