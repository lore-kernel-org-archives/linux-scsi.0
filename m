Received: from canpmsgout11.his.huawei.com (canpmsgout11.his.huawei.com [113.46.200.226])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E9D51862A;
	Mon,  2 Mar 2026 06:51:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.226
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772434312; cv=none; b=MmHZloK718/4zwFgNo15B4Vwc3prIcMQQluMu3CRdAXdbl1D8b6RO+RYpPKCQ6TqkNIiFxXfRYh1hYWzCgBMZg+HFCab78zbk4MQrwi8Qfg5as9+EPZq3sLQwIFyFQMjRfqV6BungxkIllXzf72WyTkGsYg7CmGxySCkpio+hh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772434312; c=relaxed/simple;
	bh=FfnGczqU/SwcPbEJaFDVOch6xgwDxdxUebM5yOi7jcQ=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=ZFig+j6qrDJuprsiBa7DxPyNy/tyD4+T9FZPwCpSy2j+FxwSv4FSRwykzIFR6XFLxvh68z5FzuhdKEl+cwX1AXaWI0V5ifQAhI+X1JellRh782RMjdI08XnPyQ9TTDGehV7uCGerB+7jtxE+Y5CIPdB5Lyiq1D2+CBMEONYcI18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b=Fc12wP0B; arc=none smtp.client-ip=113.46.200.226
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b="Fc12wP0B"
dkim-signature: v=1; a=rsa-sha256; d=h-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=p+VuLr4mlSyPNlfHDq1NugtnyxgrFdT9iU9DHzdTKk0=;
	b=Fc12wP0B7nGGgIYiEF0yG5OyI95+ZMfNDwfQBNWfgm5nZH4GI4UUOz+R++NP4ldv6uhNAlV5G
	7LbjEfT2/R9tSmgGrDZXfZiLAhgbTvPb3S4tXYXcw6EmPb7rTW0hJGiuHIjOs7pmXL6rOJlnyi1
	bPEScUQcQG8jV6uOs0p+92o=
Received: from mail.maildlp.com (unknown [172.19.162.92])
	by canpmsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4fPTxW6nR7zKm67;
	Mon,  2 Mar 2026 14:46:55 +0800 (CST)
Received: from kwepemj100018.china.huawei.com (unknown [7.202.194.12])
	by mail.maildlp.com (Postfix) with ESMTPS id 627EE40562;
	Mon,  2 Mar 2026 14:51:46 +0800 (CST)
Received: from localhost.huawei.com (10.90.31.46) by
 kwepemj100018.china.huawei.com (7.202.194.12) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.36; Mon, 2 Mar 2026 14:51:45 +0800
From: Xingui Yang <yangxingui@huawei.com>
To: <martin.petersen@oracle.com>, <James.Bottomley@HansenPartnership.com>
CC: <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<yangxingui@huawei.com>, <linuxarm@huawei.com>, <prime.zeng@huawei.com>,
	<liyihang9@huawei.com>, <liuyonglong@huawei.com>, <kangfenglong@huawei.com>
Subject: [PATCH 0/2] Clean up the hisi_sas driver source code
Date: Mon, 2 Mar 2026 14:51:33 +0800
Message-ID: <20260302065135.841653-1-yangxingui@huawei.com>
X-Mailer: git-send-email 2.33.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 kwepemj100018.china.huawei.com (7.202.194.12)

This series mainly consists of some minor cleanups, printing format issue
and risk of overflow in bitwise logical. No functional changes overall.

Yihang Li (2):
  scsi: hisi_sas: Correct the printing format issues
  scsi: hisi_sas: Fixed the risk of overflow in bitwise logical
    operations

 drivers/scsi/hisi_sas/hisi_sas_main.c  |  2 +-
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 12 ++++++------
 2 files changed, 7 insertions(+), 7 deletions(-)

-- 
2.33.0

