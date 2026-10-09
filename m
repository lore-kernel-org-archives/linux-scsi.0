Received: from canpmsgout06.his.huawei.com (canpmsgout06.his.huawei.com [113.46.200.221])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF34A3A0B05;
	Fri,  9 Oct 2026 03:32:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.221
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791516775; cv=none; b=BK8BFUQ42aTXc4Rl6hHDtjjrGR9pEP8DZeBlU0qyq7DeqZWtIwHGLUXV8YZzxHXYwJA2MlBl15JX+tpfTnXkfvjMH74k/sKtHSScMZT7yDDeW6upP0bLJCKFu68ROgxkBCimpunar85LBjyCEsIGDWEh4ojpd8l4cOa5sLlzuAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791516775; c=relaxed/simple;
	bh=WcZQU69ZGNBYfjKfBg1pDiB3Me7wuZvLbnTBTm6pnEA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ff7pP6JDfLingXyivMAvhBsgmtB1Ha/2N6XWrl06+gmHKpv+NAlCrYM3uSdp8kPlA5/amSm2IPky9iVlrdyw74eEht1+4BsWjfFejW72+jXKkx8XRqV2HOnSCbGUSQwEpWfFrsWwr1YcM5lK4iWhI6KQ/jJMD+dGAmwvpoSoY4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b=OXbu9Bnl; arc=none smtp.client-ip=113.46.200.221
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b="OXbu9Bnl"
dkim-signature: v=1; a=rsa-sha256; d=h-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=E2+tj8Vnd8tDlvmtptR+TYRE/znCMN47/n7S4CnB6CA=;
	b=OXbu9Bnl3eH04Fse50v1o2fXjCBvqB49o+4WtU7Zk18mo1vWzKCrROsbCxS0B6Lt8UTFGkMPI
	34ovWjxwuNrBHDVoQK3mjWgtkCvm4Xfq47yUwzSOHfw/4NKdT/7Dbl7VEENw5J8gzs8b9FHdHlT
	VJ/24/VIqszYNJrh1N0NFrQ=
Received: from mail.maildlp.com (unknown [172.19.162.223])
	by canpmsgout06.his.huawei.com (SkyGuard) with ESMTPS id 4j1BvM24DxzRhRS;
	Fri,  9 Oct 2026 11:20:31 +0800 (CST)
Received: from kwepemp500011.china.huawei.com (unknown [7.202.195.138])
	by mail.maildlp.com (Postfix) with ESMTPS id 929CF40575;
	Fri,  9 Oct 2026 11:32:42 +0800 (CST)
Received: from kwepemp500015.china.huawei.com (7.202.195.9) by
 kwepemp500011.china.huawei.com (7.202.195.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Fri, 9 Oct 2026 11:32:42 +0800
Received: from localhost.localdomain (10.50.163.32) by
 kwepemp500015.china.huawei.com (7.202.195.9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Fri, 9 Oct 2026 11:32:41 +0800
From: Xingui Yang <yangxingui@huawei.com>
To: <mkp@kernel.org>, <jejb@linux.ibm.com>, <john.garry@linux.dev>,
	<yanaijie@huawei.com>
CC: <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linuxarm@huawei.com>, <yangxingui@huawei.com>, <liuyonglong@huawei.com>,
	<kangfenglong@huawei.com>
Subject: [PATCH v3 1/4] scsi: libsas: Fix out-of-bounds memcpy in sas_ssp_task_response()
Date: Fri, 9 Oct 2026 11:32:35 +0800
Message-ID: <20261009033238.1076098-2-yangxingui@huawei.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261009033238.1076098-1-yangxingui@huawei.com>
References: <20261009033238.1076098-1-yangxingui@huawei.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemp500015.china.huawei.com (7.202.195.9)

The min_t(int, ...) clamp of the device-provided sense_data_len
turns negative for values >= 0x80000000 and is then used as the
memcpy() length, reading and writing out of bounds. Compare as u32
instead. Well-formed responses are unaffected.

Fixes: 366ca51f30de ("[SCSI] libsas: abstract STP task status into a function")
Signed-off-by: Xingui Yang <yangxingui@huawei.com>
---
 drivers/scsi/libsas/sas_task.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/libsas/sas_task.c b/drivers/scsi/libsas/sas_task.c
index e9d291007817..2080e5836179 100644
--- a/drivers/scsi/libsas/sas_task.c
+++ b/drivers/scsi/libsas/sas_task.c
@@ -25,7 +25,7 @@ void sas_ssp_task_response(struct device *dev, struct sas_task *task,
 	case SAS_DATAPRES_SENSE_DATA:
 		tstat->stat = SAS_SAM_STAT_CHECK_CONDITION;
 		tstat->buf_valid_size =
-			min_t(int, SAS_STATUS_BUF_SIZE,
+			min_t(u32, SAS_STATUS_BUF_SIZE,
 			      be32_to_cpu(iu->sense_data_len));
 		memcpy(tstat->buf, iu->sense_data, tstat->buf_valid_size);
 
-- 
2.43.0

