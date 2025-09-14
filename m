Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7B6A1C5496;
	Sun, 14 Sep 2025 10:11:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757844686; cv=none; b=e3ZhyarjwyRegpQhJ2tQB75QDOHicBdcnUe9EJqFS+VAXl4vpJOrq1p6KSfDHLa/R4dIbPhmrPaMJZ8e0WSCpXdB38vy0hap7HVBWAJsC8ug+RCklVA9WxSUl9WPpuYHlfRIDnjQIOSmWp/yeWsGuXq8/ZTyuSPFtyPPytTYQg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757844686; c=relaxed/simple;
	bh=onoab6PpBgIgGqMZ5cSo33JVzJIuK0Xb7SYU04LrUSA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ECGlFQrkXZA2jeNBwHOPS/jZCALWxORCBZIrOgs6Whkf6gB5tPxUpWBiE1J+mGOsiHSaDzASRJxzYIJeePsMfreMi+JK8DmiHF+Q3djW/yEIhti9T3JsBuXSJCZ/H0nzPCGThvHw9R6Xren+DB7q9sHE+E9S7FNFKE13zxspUL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Received: from mail.maildlp.com (unknown [172.19.162.112])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4cPkN16CTKz2Cg5J;
	Sun, 14 Sep 2025 18:06:41 +0800 (CST)
Received: from kwepemk500001.china.huawei.com (unknown [7.202.194.86])
	by mail.maildlp.com (Postfix) with ESMTPS id DBED6140145;
	Sun, 14 Sep 2025 18:11:15 +0800 (CST)
Received: from localhost.localdomain (10.175.104.170) by
 kwepemk500001.china.huawei.com (7.202.194.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sun, 14 Sep 2025 18:11:15 +0800
From: JiangJianJun <jiangjianjun3@huawei.com>
To: <James.Bottomley@HansenPartnership.com>, <martin.petersen@oracle.com>,
	<linux-scsi@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <hare@suse.de>, <dlemoal@kernel.org>,
	<hewenliang4@huawei.com>, <yangyun50@huawei.com>, <wuyifeng10@huawei.com>,
	<yangxingui@h-partners.com>
Subject: [RFC PATCH v4 0/9] scsi: scsi_error: Introduce new error handle mechanism
Date: Sun, 14 Sep 2025 18:41:36 +0800
Message-ID: <20250914104145.2239901-1-jiangjianjun3@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <17230842-0a7a-403e-abc7-a15e3aa5d424@suse.de>
References: <17230842-0a7a-403e-abc7-a15e3aa5d424@suse.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemk500001.china.huawei.com (7.202.194.86)

> Additionally: TARGET RESET TMF is dead, and has been removed from SAM
> since several years. It really is not worthwhile implementing.

Hannes suggested removing the faulty handler on the target, so I revised
a version and submitted it as a proposal.

> Also, was this all tested with libata and libsas attached devices as well ?
> They all depend on scsi EH.

And I removed the settings for iscsi_tcp and virtio_scsi, maybe that
adding this proposal to specific drivers before the plan is finalized is
not appropriate. Keep the setting of scsi_debug for test the solution.

The introduction can be simplified as follows: This tmf only blocks IO
on the current device and does not interfere with IO or tmf on other
devices. 


JiangJianJun (1):
  scsi: scsi_debug: Add params for configuring the error handler

Wenchao Hao (8):
  scsi: scsi_error: Define framework for LUN based error handle
  scsi: scsi_error: Move complete variable eh_action from shost to
    sdevice
  scsi: scsi_error: Check if to do reset in scsi_try_xxx_reset
  scsi: scsi_error: Add helper scsi_eh_sdev_stu to do START_UNIT
  scsi: scsi_error: Add helper scsi_eh_sdev_reset to do lun reset
  scsi: scsi_error: Add flags to mark error handle steps has done
  scsi: scsi_error: Add helper to handle scsi device's error command
    list
  scsi: scsi_error: Add a general LUN based error handler

 drivers/scsi/scsi_debug.c  |  15 +-
 drivers/scsi/scsi_error.c  | 422 ++++++++++++++++++++++++++++++++-----
 drivers/scsi/scsi_lib.c    |   7 +
 drivers/scsi/scsi_priv.h   |   8 +
 drivers/scsi/scsi_scan.c   |   7 +
 drivers/scsi/scsi_sysfs.c  |   2 +
 include/scsi/scsi_device.h |  49 +++++
 include/scsi/scsi_eh.h     |   4 +
 include/scsi/scsi_host.h   |  18 +-
 9 files changed, 476 insertions(+), 56 deletions(-)

-- 
2.33.0

