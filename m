Received: from canpmsgout01.his.huawei.com (canpmsgout01.his.huawei.com [113.46.200.216])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7682428C5B1;
	Sat, 29 Aug 2026 03:29:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.216
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787974151; cv=none; b=ELMZksn5zGCZf8CWXyHyRHUTW+6G6Cu/67Mk0dgboQ7dqK1MqZNkuM2xuki8Lg2ThEizSgkA1nfroxfli2Zic3kp5rtENGN8DkSkcjEA1cafLInoxUrvci5boqUC2UFZSnrdDDlURxWOi/Uk/foIHGAGztIePysY+N52JkP/rwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787974151; c=relaxed/simple;
	bh=KwkK8cU5QfKv5Y5baY6lT89wgvB/W4KfbKr0CjbEo0s=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=ELjk+RCSuXwkkvLx0GI3OAYNpbxiK/RX6cbqAyO52EFVnn/4fg+oIa/Qzcks3I7LXUB0xeq4N4vG6nottPXTvLFxhV3EgF1KY2K5PA36weKtLjZRf2AE57Nbd3oldTbIaJQcTNPquiAJuAXfQfvSfuy5lpCwTM3bHc/ehCGWf3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b=k+gxqgXI; arc=none smtp.client-ip=113.46.200.216
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b="k+gxqgXI"
dkim-signature: v=1; a=rsa-sha256; d=h-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=4RjJh6+5NERjfyZioh3kfWvuLkaix8EqlEaDu0C46dw=;
	b=k+gxqgXIjehSyjBVePgBkDnytA+sKgpG0NLkFUGC0XCH3//PfQXPnY3qeyF7Hf/6ZJiA5Pfkj
	xpiAiMuHUKtr5icHA4Y86igg5iCjt69ZA/GGYhPFmZtPSSoKn7An1rVUyaMFmTrcOl7GEuFQmR/
	+rWy9YRqA1GdCGA2wApnKI4=
Received: from mail.maildlp.com (unknown [172.19.162.197])
	by canpmsgout01.his.huawei.com (SkyGuard) with ESMTPS id 4hX0n408HPz1T4JN;
	Sat, 29 Aug 2026 11:17:44 +0800 (CST)
Received: from kwepemp100002.china.huawei.com (unknown [7.202.195.234])
	by mail.maildlp.com (Postfix) with ESMTPS id 817D34057D;
	Sat, 29 Aug 2026 11:28:59 +0800 (CST)
Received: from kwepemp500015.china.huawei.com (7.202.195.9) by
 kwepemp100002.china.huawei.com (7.202.195.234) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Sat, 29 Aug 2026 11:28:59 +0800
Received: from localhost.localdomain (10.50.163.32) by
 kwepemp500015.china.huawei.com (7.202.195.9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Sat, 29 Aug 2026 11:28:58 +0800
From: Xingui Yang <yangxingui@huawei.com>
To: <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
	<john.g.garry@oracle.com>, <yanaijie@huawei.com>
CC: <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linuxarm@huawei.com>, <yangxingui@huawei.com>, <liuyonglong@huawei.com>,
	<kangfenglong@huawei.com>
Subject: [PATCH 0/3] scsi: hisi_sas: Some Misc fixes
Date: Sat, 29 Aug 2026 11:28:55 +0800
Message-ID: <20260829032858.1661019-1-yangxingui@huawei.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemp500015.china.huawei.com (7.202.195.9)

This series contains three independent fixes for the hisi_sas driver.

Patch 1 fixes incorrect delay values introduced by a previous
magic-number cleanup commit. Three delay sites were changed to use
a single macro (value 100) which did not match their original values,
causing increased boot and shutdown time.

Patch 2 clears stale PHY error counts on phyup so that error detection
is not misled by intermediate errors generated during link
establishment.

Patch 3 fixes spinup failures of directly-attached SAS HDDs that power
up in the Active_Wait state and wait for a NOTIFY(ENABLE SPINUP)
primitive before becoming ready: parse the sense data in the slot
completion path and send the primitive from deferred work.

Xingui Yang (3):
  scsi: hisi_sas: Fix incorrect delay values from magic-number cleanup
  scsi: hisi_sas: Clear PHY error counts on phyup
  scsi: hisi_sas: Fix spinup failure for SAS SSP devices in Active_Wait
    state

 drivers/scsi/hisi_sas/hisi_sas.h       |  3 ++
 drivers/scsi/hisi_sas/hisi_sas_main.c  | 38 +++++++++++++++++++++++
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c |  3 ++
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c |  3 ++
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 42 +++++++++++++++++++-------
 5 files changed, 78 insertions(+), 11 deletions(-)

-- 
2.43.0

