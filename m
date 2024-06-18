Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82139199B0;
	Tue, 18 Jun 2024 07:44:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.110
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718696680; cv=none; b=nZVJtEiAP0StJMHUdBkXm/tYNIDhhDkt2S969CvK1cSUulj8VwZrXzoq6SlA7ZvpGIamAvBm9YNGDGQ6p4rgbFyDwc8On94die45wk8MFQDDJRQ9O+CrFkbouzAul2BlYteTkznrwZNNh/563qFqiFFHUaMCkl1H+TUqJNJ4kCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718696680; c=relaxed/simple;
	bh=mVgU9l3ssXBCKl+L8OKT5S/qcig22kETQEUfkY4SGlE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=LbgmMjTOiGbM3MHe+r47hRqonnVt6fY2/Y1yQJv2oeVoi7p1xaNLeEN0Z+WKnKzB4Kvbd766QcWPofj88USupxaLTvTDDDYnQUBTekJs7mfq67xMr4JEAEdczB8vArATVPQwLpFF4m3uqayhdNvk5bbPablFXlHMd+NIJQK4aEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=iXUtjvos; arc=none smtp.client-ip=115.124.30.110
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="iXUtjvos"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1718696674; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=zJbcWWfueqXUtA+KBou0jijEhlAukONtUiICTRfCdWM=;
	b=iXUtjvosyXo+8PjgNl8++pLrruoK1sAiaGMPdG3kFtB7enw2fTysYbZocNgSqdLw4TKT4k6/FYC8ApTzSaM1T0dTyae2/qvDmFeiPcuXz227MyGJQ39UaeC9GOc0we2UyazSiAQwzgqZSG+/p/6xau2fF5n0yuKv5DE7Ry9Yb6s=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045046011;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0W8jSXV-_1718696667;
Received: from localhost(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0W8jSXV-_1718696667)
          by smtp.aliyun-inc.com;
          Tue, 18 Jun 2024 15:44:33 +0800
From: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To: john.g.garry@oracle.com
Cc: yanaijie@huawei.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
	Abaci Robot <abaci@linux.alibaba.com>
Subject: [PATCH] scsi: libsas: Use str_plural() in _sas_resume_ha()
Date: Tue, 18 Jun 2024 15:44:26 +0800
Message-Id: <20240618074426.97217-1-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 2.20.1.7.g153144c
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use existing str_plural() function rather than duplicating its
implementation.

./drivers/scsi/libsas/sas_init.c:426:7-8: opportunity for str_plural(i).

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Closes: https://bugzilla.openanolis.cn/show_bug.cgi?id=9351
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
 drivers/scsi/libsas/sas_init.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/libsas/sas_init.c b/drivers/scsi/libsas/sas_init.c
index 9c8cc723170d..67017c03d4da 100644
--- a/drivers/scsi/libsas/sas_init.c
+++ b/drivers/scsi/libsas/sas_init.c
@@ -422,8 +422,8 @@ static void _sas_resume_ha(struct sas_ha_struct *ha, bool drain)
 	 */
 	i = phys_suspended(ha);
 	if (i)
-		dev_info(ha->dev, "waiting up to 25 seconds for %d phy%s to resume\n",
-			 i, i > 1 ? "s" : "");
+		dev_info(ha->dev, "waiting up to 25 seconds for %d phy%s to resume\n", i,
+			 str_plural(i));
 	wait_event_timeout(ha->eh_wait_q, phys_suspended(ha) == 0, tmo);
 	for (i = 0; i < ha->num_phys; i++) {
 		struct asd_sas_phy *phy = ha->sas_phy[i];
-- 
2.20.1.7.g153144c

