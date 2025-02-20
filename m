Received: from szxga07-in.huawei.com (szxga07-in.huawei.com [45.249.212.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DABAC1F7076;
	Thu, 20 Feb 2025 13:05:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740056753; cv=none; b=fHq7tSpfwUY5i3NODAadDBoI71ZTYzR2mNtKiCpD0KCFrMKRZe9AhFQRkJwVsiKjBoiDr1yqjKg3Us7DAEP1p/M/ZR0gS07LESyANyxWniNeALsoU2fUOiV+sEkq2q1OQ8ctVY2qcl/0Okk2BRTNAP/rNjT+uLzRFZWI1GPjm2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740056753; c=relaxed/simple;
	bh=TKsi6dT6GDxZ+RCmUnzwwVuF71mkQGEKgzMFbsapWL4=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Vcm2BsbR0als5EZBdICzmOcCZG9V1Z24GNA8XdO0ryN38yjI8BmBYKGY8lGz5Bv9e57IzbwCZrnChT0HesFbNnxbibz0Xs03AHWRncZ9b31r8nyCJ9vK9vHTc9O/dm5JGJqzPKltPY48yC3CP5Q3ZDXNoYF+lrzfTNXi6VpfrXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.163])
	by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4YzD1C12Hzz1wn5C;
	Thu, 20 Feb 2025 21:01:51 +0800 (CST)
Received: from kwepemg100017.china.huawei.com (unknown [7.202.181.58])
	by mail.maildlp.com (Postfix) with ESMTPS id E409A180042;
	Thu, 20 Feb 2025 21:05:47 +0800 (CST)
Received: from localhost.huawei.com (10.90.30.45) by
 kwepemg100017.china.huawei.com (7.202.181.58) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 20 Feb 2025 21:05:47 +0800
From: Xingui Yang <yangxingui@huawei.com>
To: <john.garry@huawei.com>, <liyihang9@huawei.com>, <yanaijie@huawei.com>
CC: <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
	<linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linuxarm@huawei.com>, <prime.zeng@huawei.com>, <yangxingui@huawei.com>,
	<liuyonglong@huawei.com>, <kangfenglong@huawei.com>,
	<liyangyang20@huawei.com>, <f.fangjian@huawei.com>,
	<xiabing14@h-partners.com>
Subject: [PATCH v3 0/3] scsi: hisi_sas: Fixed IO error caused by port id not updated
Date: Thu, 20 Feb 2025 21:05:43 +0800
Message-ID: <20250220130546.2289555-1-yangxingui@huawei.com>
X-Mailer: git-send-email 2.33.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemg100017.china.huawei.com (7.202.181.58)

This series of patches is used to solve the problem that after the SATA
device port ID is changed, IO may be sent to the incorrect disk.

Changes from v2:
- Use asynchronous scheduling

Changes from v1:
- Fix "BUG: Atomic scheduling in clear_itct_v3_hw()"

Xingui Yang (3):
  scsi: hisi_sas: Enable force phy when SATA disk directly connected
  scsi: libsas: Move sas_put_device() to libsas.h
  scsi: hisi_sas: Fixed IO error caused by port id not updated

 drivers/scsi/hisi_sas/hisi_sas_main.c  | 51 ++++++++++++++++++++++++++
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c |  9 ++++-
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c | 14 ++++++-
 drivers/scsi/libsas/sas_discover.c     |  1 +
 drivers/scsi/libsas/sas_internal.h     |  6 ---
 include/scsi/libsas.h                  |  6 +++
 6 files changed, 77 insertions(+), 10 deletions(-)

-- 
2.33.0

