Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC56E2BEC39;
	Sat, 16 Aug 2025 10:53:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755341602; cv=none; b=uXf28osGiSYUEjZoZKCT48n1DBbU8Ve9hTvuVkMHvDYvRco4AP4k4rOAUz1oSdraeetrOSeDPs6uNx4R+Qxx4JhtgttjO9mp+LHKccPFOm3DxfcSPs83CNm3RQIMhbQHFC5RJC1kMlsrtQ96qWN/TH9KlZVzJssNDLHVCGx9030=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755341602; c=relaxed/simple;
	bh=6FAPIP5FkbuIRoAUBawSKb4AJYRef3OuI3wUeKdsop4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RRosJ2A0HGvTWiuGX1t3ru/ixp8G6rAiOZd1zDBcaBCYrMoAyLX11dnr9C9mSjkoHQWyVHFNBjENbOAXnbK4HSwTJQN7DJhPXSclVZ4ZwHYZn23cKvxPxNuIl4XllmvLGLXycGPTMzEqejmyaVkvRX3ER6zTVALzuByJcashITg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Received: from mail.maildlp.com (unknown [172.19.163.252])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4c3wn75S70zvX7s;
	Sat, 16 Aug 2025 18:53:15 +0800 (CST)
Received: from kwepemk500001.china.huawei.com (unknown [7.202.194.86])
	by mail.maildlp.com (Postfix) with ESMTPS id BDF9C180B5A;
	Sat, 16 Aug 2025 18:53:17 +0800 (CST)
Received: from localhost.localdomain (10.175.104.170) by
 kwepemk500001.china.huawei.com (7.202.194.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 16 Aug 2025 18:53:16 +0800
From: JiangJianJun <jiangjianjun3@huawei.com>
To: <James.Bottomley@HansenPartnership.com>, <martin.petersen@oracle.com>,
	<linux-scsi@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <hare@suse.de>, <bvanassche@acm.org>,
	<michael.christie@oracle.com>, <hch@infradead.org>, <haowenchao22@gmail.com>,
	<john.g.garry@oracle.com>, <hewenliang4@huawei.com>, <yangyun50@huawei.com>,
	<wuyifeng10@huawei.com>, <wubo40@huawei.com>, <yangxingui@h-partners.com>
Subject: [PATCH 14/14] scsi: iscsi_tcp: enable LUN-based and target-based error handlers
Date: Sat, 16 Aug 2025 19:24:17 +0800
Message-ID: <20250816112417.3581253-15-jiangjianjun3@huawei.com>
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

The iSCSI TCP driver now supports resetting LUNs or targets,
allowing us to enable LUN-based error handlers and enable them
to fall back to target-based error handlers.

Signed-off-by: JiangJianJun <jiangjianjun3@h-partners.com>
---
 drivers/scsi/iscsi_tcp.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index 7b4fe0e6afb2..328e76219b1c 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -33,6 +33,7 @@
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_host.h>
 #include <scsi/scsi.h>
+#include <scsi/scsi_eh.h>
 #include <scsi/scsi_transport_iscsi.h>
 #include <trace/events/iscsi.h>
 #include <trace/events/sock.h>
@@ -1040,6 +1041,9 @@ static const struct scsi_host_template iscsi_sw_tcp_sht = {
 	.eh_target_reset_handler = iscsi_eh_recover_target,
 	.dma_boundary		= PAGE_SIZE - 1,
 	.sdev_configure		= iscsi_sw_tcp_sdev_configure,
+	.sdev_setup_eh		= scsi_device_setup_eh,
+	.sdev_clear_eh		= scsi_device_clear_eh,
+	.sdev_eh_fallback	= 1,
 	.proc_name		= "iscsi_tcp",
 	.this_id		= -1,
 	.track_queue_depth	= 1,
-- 
2.33.0

