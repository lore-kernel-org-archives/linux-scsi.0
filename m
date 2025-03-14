Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2835154C04;
	Fri, 14 Mar 2025 01:10:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741914625; cv=none; b=dgyhcC3LJK6H13Z47dOsG4IWVK7U/iRdEpoCKqgGvdKGZfZjbNcDBRhKmlziGY9Y8fQ+uE3q3cpVJ0K5Bp2WUuF07uWtwbUdmjTBef5p0Yp8gOujT6BLR3zeb9Tgqci/sE0wC86CS7l4pw7Iodz9CDdpR8st/mZmFm0fQRbyjFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741914625; c=relaxed/simple;
	bh=31cApgEEPr/vjgh4U3S1W4MvPj8aH5QcHE7QBy2M1Ak=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UnVAo2mswrh4vrXKYkR2L0IhCD8r+ZlX1Iv2U6GOQYbcuOEQgESxzteWqlMcTd1KS30CBU5vhBYbJHij+b+HaKoVAw9GnHTpUTCEEzAGInG4yvr0Jn6i02qyXGk/WR0xabnUYXXdIKZPbjLo2Aw8fSvt+IRP02Ywcv8fydian00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.163])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4ZDR521Tfjz1ltZq;
	Fri, 14 Mar 2025 09:05:58 +0800 (CST)
Received: from dggpemf500016.china.huawei.com (unknown [7.185.36.197])
	by mail.maildlp.com (Postfix) with ESMTPS id A351B180069;
	Fri, 14 Mar 2025 09:10:21 +0800 (CST)
Received: from localhost.localdomain (10.175.101.6) by
 dggpemf500016.china.huawei.com (7.185.36.197) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 14 Mar 2025 09:10:21 +0800
From: JiangJianJun <jiangjianjun3@huawei.com>
To: <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
	<linux-scsi@vger.kernel.org>
CC: <hare@suse.de>, <linux-kernel@vger.kernel.org>, <lixiaokeng@huawei.com>,
	<jiangjianjun3@huawei.com>, <hewenliang4@huawei.com>,
	<yangkunlin7@huawei.com>
Subject: [RFC PATCH v3 19/19] scsi: iscsi_tcp: Add param to control LUN based error handle
Date: Fri, 14 Mar 2025 09:29:27 +0800
Message-ID: <20250314012927.150860-20-jiangjianjun3@huawei.com>
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

Add new param lun_eh to control if enable LUN based error handler,
since iscsi_tcp defined callback eh_target_reset, so make it
fallback to further recover when LUN based recovery can not recover
all error commands.

Signed-off-by: Wenchao Hao <haowenchao2@huawei.com>
---
 drivers/scsi/iscsi_tcp.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index e81f60985193..6212d88a4259 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -35,6 +35,7 @@
 #include <scsi/scsi_host.h>
 #include <scsi/scsi.h>
 #include <scsi/scsi_transport_iscsi.h>
+#include <scsi/scsi_eh.h>
 #include <trace/events/iscsi.h>
 #include <trace/events/sock.h>
 
@@ -63,6 +64,10 @@ module_param_named(debug_iscsi_tcp, iscsi_sw_tcp_dbg, int,
 MODULE_PARM_DESC(debug_iscsi_tcp, "Turn on debugging for iscsi_tcp module "
 		 "Set to 1 to turn on, and zero to turn off. Default is off.");
 
+static bool iscsi_sw_tcp_lun_eh;
+module_param_named(lun_eh, iscsi_sw_tcp_lun_eh, bool, 0444);
+MODULE_PARM_DESC(lun_eh, "LUN based error handle (def=0)");
+
 #define ISCSI_SW_TCP_DBG(_conn, dbg_fmt, arg...)		\
 	do {							\
 		if (iscsi_sw_tcp_dbg)				\
@@ -1069,6 +1074,19 @@ static int iscsi_sw_tcp_sdev_configure(struct scsi_device *sdev,
 	return 0;
 }
 
+static int iscsi_sw_tcp_sdev_alloc(struct scsi_device *sdev)
+{
+	if (iscsi_sw_tcp_lun_eh)
+		return scsi_device_setup_eh(sdev, 1);
+	return 0;
+}
+
+static void iscsi_sw_tcp_sdev_destroy(struct scsi_device *sdev)
+{
+	if (iscsi_sw_tcp_lun_eh)
+		return scsi_device_clear_eh(sdev);
+}
+
 static const struct scsi_host_template iscsi_sw_tcp_sht = {
 	.module			= THIS_MODULE,
 	.name			= "iSCSI Initiator over TCP/IP",
@@ -1084,6 +1102,8 @@ static const struct scsi_host_template iscsi_sw_tcp_sht = {
 	.eh_target_reset_handler = iscsi_eh_recover_target,
 	.dma_boundary		= PAGE_SIZE - 1,
 	.sdev_configure		= iscsi_sw_tcp_sdev_configure,
+	.sdev_init			= iscsi_sw_tcp_sdev_alloc,
+	.sdev_destroy		= iscsi_sw_tcp_sdev_destroy,
 	.proc_name		= "iscsi_tcp",
 	.this_id		= -1,
 	.track_queue_depth	= 1,
-- 
2.33.0

