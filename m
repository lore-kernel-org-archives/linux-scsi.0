Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 810CF2BE7A2;
	Sat, 16 Aug 2025 10:53:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755341601; cv=none; b=VscfhV71ggt0xLA6sRj2SjoSbMXi3bvgESMaO0R2AgY8ceER2JiMlws7/cJGankqeDxIw8YYq7iRvlOht/2wHbNPFYezbwmx9cer7Ai7GcVbxE2sw0Od8kEgzvgaxPNAuGkajdsdf9WtZihAt6qtb004oCpT8sOb1cJayj4bDhA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755341601; c=relaxed/simple;
	bh=lrOAE3gu6nriXl31eGKX6Pght1ci2EPDlzWVNOFvFIY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZqClXbewXqRXV2VNdda+gge3BERSJDO6YCsuj0LVh2MUcjYMJM0oxuRCmHIqK6DEUuK65333V3TNPeqwfGtd003bHJTTkL85LQW1oAyfYmMRF+41jrk+0l61vkfwLP8eQ9lNDckE1/g7/EV5xQf87KmAPiXWRq9jAtgVD1GIXYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Received: from mail.maildlp.com (unknown [172.19.162.254])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4c3wj85x3zz13NFN;
	Sat, 16 Aug 2025 18:49:48 +0800 (CST)
Received: from kwepemk500001.china.huawei.com (unknown [7.202.194.86])
	by mail.maildlp.com (Postfix) with ESMTPS id EE85B18048D;
	Sat, 16 Aug 2025 18:53:16 +0800 (CST)
Received: from localhost.localdomain (10.175.104.170) by
 kwepemk500001.china.huawei.com (7.202.194.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 16 Aug 2025 18:53:15 +0800
From: JiangJianJun <jiangjianjun3@huawei.com>
To: <James.Bottomley@HansenPartnership.com>, <martin.petersen@oracle.com>,
	<linux-scsi@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <hare@suse.de>, <bvanassche@acm.org>,
	<michael.christie@oracle.com>, <hch@infradead.org>, <haowenchao22@gmail.com>,
	<john.g.garry@oracle.com>, <hewenliang4@huawei.com>, <yangyun50@huawei.com>,
	<wuyifeng10@huawei.com>, <wubo40@huawei.com>, <yangxingui@h-partners.com>
Subject: [PATCH 13/14] scsi: virtio_scsi: enable LUN based error handlers
Date: Sat, 16 Aug 2025 19:24:16 +0800
Message-ID: <20250816112417.3581253-14-jiangjianjun3@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20250816112417.3581253-1-jiangjianjun3@huawei.com>
References: <20250816112417.3581253-1-jiangjianjun3@huawei.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 kwepemk500001.china.huawei.com (7.202.194.86)

From: JiangJianJun <jiangjianjun3@h-partners.com>

Enable the virtio_scsi driver to support LUN-based error handlers.
Since virtio_scsi does not define any further reset callbacks,
there is no need to fallback for further recover, so we have
disabled the fallback functionality.

Signed-off-by: JiangJianJun <jiangjianjun3@h-partners.com>
---
 drivers/scsi/virtio_scsi.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index 96a69edddbe5..3c525521351c 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -28,6 +28,7 @@
 #include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_tcq.h>
 #include <scsi/scsi_devinfo.h>
+#include <scsi/scsi_eh.h>
 #include <linux/seqlock.h>
 
 #include "sd.h"
@@ -801,6 +802,8 @@ static const struct scsi_host_template virtscsi_host_template = {
 	.eh_device_reset_handler = virtscsi_device_reset,
 	.eh_timed_out = virtscsi_eh_timed_out,
 	.sdev_init = virtscsi_device_alloc,
+	.sdev_setup_eh = scsi_device_setup_eh,
+	.sdev_clear_eh = scsi_device_clear_eh,
 
 	.dma_boundary = UINT_MAX,
 	.map_queues = virtscsi_map_queues,
-- 
2.33.0

