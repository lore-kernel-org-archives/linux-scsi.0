Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CF791519B5;
	Fri, 14 Mar 2025 01:10:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741914625; cv=none; b=gJ/7yI6AoYwGFmMW6Mo8Lnsppw7f/ZRCR7dSdS1KRXB+f4vZoJ1JeK5DJD7MfVUc0P0V8GFFR9klsoluqi2EIqQbBxdixh3Pd75cP+44jynAMX6w0S1AGuF+o7vU1N5tSmA8SduahggnRD7Zrk0Elmzv4AM2Y0frXo80PM9Au8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741914625; c=relaxed/simple;
	bh=iTWeO/0L3NSvusXc+Ug/fjUBrTnenMPdKn+kG1amEKU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=R1UbUw1b/Wz6E2R8tJBUkh+/YHtwgp8PTlM0XEKIRWLhjFuSGVp/XdMNAAgvvBfcn8N/p8G0S+dVWrZa3q2INzF0Gm7cyiDjgkKkajODItNKXUJh4ZQ+xqKFe+arbTrzKtPZ7A7MwmZIX5KHRkIKLB+Tm82iYXKp/ETLbza54h0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.112])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4ZDR8720Vsz1R6bW;
	Fri, 14 Mar 2025 09:08:39 +0800 (CST)
Received: from dggpemf500016.china.huawei.com (unknown [7.185.36.197])
	by mail.maildlp.com (Postfix) with ESMTPS id 2ABE71402CA;
	Fri, 14 Mar 2025 09:10:21 +0800 (CST)
Received: from localhost.localdomain (10.175.101.6) by
 dggpemf500016.china.huawei.com (7.185.36.197) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 14 Mar 2025 09:10:20 +0800
From: JiangJianJun <jiangjianjun3@huawei.com>
To: <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
	<linux-scsi@vger.kernel.org>
CC: <hare@suse.de>, <linux-kernel@vger.kernel.org>, <lixiaokeng@huawei.com>,
	<jiangjianjun3@huawei.com>, <hewenliang4@huawei.com>,
	<yangkunlin7@huawei.com>
Subject: [RFC PATCH v3 18/19] scsi: virtio_scsi: Add param to control LUN based error handle
Date: Fri, 14 Mar 2025 09:29:26 +0800
Message-ID: <20250314012927.150860-19-jiangjianjun3@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20250314012927.150860-1-jiangjianjun3@huawei.com>
References: <20250314012927.150860-1-jiangjianjun3@huawei.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpemf500016.china.huawei.com (7.185.36.197)

From: Wenchao Hao <haowenchao2@huawei.com>

Add new param lun_eh to control if enable LUN based error handler, since
virtio_scsi did not define other further reset callbacks, it is not
necessary to fallback to further recover any more, so set the LUN
error handler with fallback set to 0.

Signed-off-by: Wenchao Hao <haowenchao2@huawei.com>
---
 drivers/scsi/virtio_scsi.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index 21ce3e940192..99276ad0e441 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -28,6 +28,7 @@
 #include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_tcq.h>
 #include <scsi/scsi_devinfo.h>
+#include <scsi/scsi_eh.h>
 #include <linux/seqlock.h>
 
 #include "sd.h"
@@ -41,6 +42,10 @@ module_param(virtscsi_poll_queues, uint, 0644);
 MODULE_PARM_DESC(virtscsi_poll_queues,
 		 "The number of dedicated virtqueues for polling I/O");
 
+static bool lun_eh;
+module_param(lun_eh, bool, 0444);
+MODULE_PARM_DESC(lun_eh, "LUN based error handle (def=0)");
+
 /* Command queue element */
 struct virtio_scsi_cmd {
 	struct scsi_cmnd *sc;
@@ -682,9 +687,18 @@ static int virtscsi_device_alloc(struct scsi_device *sdevice)
 	 */
 	sdevice->sdev_bflags = BLIST_TRY_VPD_PAGES;
 
+	if (lun_eh)
+		return scsi_device_setup_eh(sdevice, 0);
+
 	return 0;
 }
 
+static void virtscsi_device_destroy(struct scsi_device *sdevice)
+{
+	if (lun_eh)
+		return scsi_device_clear_eh(sdevice);
+}
+
 
 /**
  * virtscsi_change_queue_depth() - Change a virtscsi target's queue depth
@@ -801,7 +815,7 @@ static const struct scsi_host_template virtscsi_host_template = {
 	.eh_device_reset_handler = virtscsi_device_reset,
 	.eh_timed_out = virtscsi_eh_timed_out,
 	.sdev_init = virtscsi_device_alloc,
-
+	.sdev_destroy = virtscsi_device_destroy,
 	.dma_boundary = UINT_MAX,
 	.map_queues = virtscsi_map_queues,
 	.track_queue_depth = 1,
-- 
2.33.0

