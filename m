Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C06606FD3
	for <linux-scsi@vger.kernel.org>; Wed,  4 Sep 2024 01:27:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725413233; cv=none; b=jgZAS2F2QWSYJHtOcjJwJx5NXxnUKYutNoD8bEzg73x06aizPzzjW6X3wV+e557eGqMA2KC5GT5GHhQLtO6/WNCYy/wiM4vTdl2ZQH0QeG+uB39rGXIAoQwJ6AFSm7N3rhxrXJBYm41Yv0coFC3d9cp/n+yqW8iNXiPdU3D9AQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725413233; c=relaxed/simple;
	bh=QRGm+9k89rdGlTx7CxjlhJ2NMUSf3AsFdMLpcW6UdUM=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=VXlkjOfqRa6pePiViz1kxqBWzgzcMTH9+T9oNslInivuFfDPN0X0tgyOs8K8SS/yjhK3FEiWFIk1V2VCz8By0hu+iloUBi8Yd2GcPtJojxaY9M7gg7ZyJI3KT3PXKOxqJgdhRpFQn3MrAxiTqHGhViEM+iEVBn9cOWLLUHhkTRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.194])
	by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4Wz4Tw4NVkz69Yp;
	Wed,  4 Sep 2024 09:22:12 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (unknown [7.185.36.66])
	by mail.maildlp.com (Postfix) with ESMTPS id AFD8C1400FF;
	Wed,  4 Sep 2024 09:27:09 +0800 (CST)
Received: from huawei.com (10.90.53.73) by dggpeml500022.china.huawei.com
 (7.185.36.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Wed, 4 Sep
 2024 09:27:09 +0800
From: Hongbo Li <lihongbo22@huawei.com>
To: <James.Bottomley@HansenPartnership.com>, <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <lihongbo22@huawei.com>
Subject: [PATCH -next 0/3] Use sysfs_emit for reloading sysfs's .show
Date: Wed, 4 Sep 2024 09:35:37 +0800
Message-ID: <20240904013540.2026972-1-lihongbo22@huawei.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpeml500022.china.huawei.com (7.185.36.66)

Now as the latest Documentation/filesystems/sysfs.rst
suggested, show() should only use sysfs_emit() or
sysfs_emit_at() when formatting the value to be returned
to user space.

sysfs_emit validates assumptions made by sysfs and is the
correct mechanism to format data for sysfs. So we can do
these conversion.

Hongbo Li (3):
  scsi: pmcraid: change snprintf() to sysfs_emit()
  scsi: aacraid: Use sysfs_emit() to replace the sprintf()
  scsi: hptiop: Change snprintf() to sysfs_emit()

 drivers/scsi/aacraid/linit.c | 14 ++++++--------
 drivers/scsi/hptiop.c        |  4 ++--
 drivers/scsi/pmcraid.c       | 10 ++++------
 3 files changed, 12 insertions(+), 16 deletions(-)

-- 
2.34.1

