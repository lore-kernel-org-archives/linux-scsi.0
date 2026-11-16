Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.137
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794788303;
	b=yHDGjGIt2KD8oULy62r/VAs9QQSuMwgOhqrHO6zaL8VwW/T/3etYl575rkhcShgr2ABW
	 lG6UZJBzB4RM5muC1fuGcSOY4QJ1gyLmqvGH1ZkREzU6f4QnEpLnwuD3eMMV4+C/G1xwx
	 cIDSw1bGuy49OTjIjdfZuw3HpUiZyetpITPzUw/eWTDiuJRSV5KZcuDf6wY9L41cI1/az
	 JaDJP2AjumnNp4Lej8zAHEM/2byqTxWADSux8ajEZDg40JjYOfSQ5GxEX5j1FknyZTy1m
	 RZafbNJEKnyoaoPULSuqWP4nJiD0NqTdfneoMYppNQi6S6iHlqI8gLA4iEPGKFQJTpQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794788303;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:References:
	 In-Reply-To:To:Cc:X-Mailer;
	bh=vY6z2cIllQDioTtc7UC0YCLjJ2aTdxeOyhkDPIyOAUM=;
	b=DwXvYmuhyu44cmA4nCCwZgy9bqeSHV4JrilqGc7unYn5JLQES9OvOjfyHZS1PAy/uaoS
	 yfhfMHu8Fspvuq8Jcowb8AMw80zwe+Ofx+kcLPklsbgxvCYsONI7/Es+dWB2VxlcAahdW
	 ejT/c0/TE83bb/e114mhjrZvJOgZpKVZ/2NhKPBA7lHMccVWv6wrljAdOJm321EzYnBcj
	 NRXuSTn3TwUxSCf298BXW2xjaADteSMurUOFhX2wQTMzZN0SzsirCE35o5Urbdb6XDSzO
	 oM1krbURGIh8GmH0RJ0Aqj52R7zzpAathsRjn2eH4n+Away4FnEe4BcRWGZiL3jzYWA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=P7NjNivw;
	arc=none smtp.remote-ip=95.215.58.137
Received: from mta1.migadu.com (out-137.mta1.migadu.com [95.215.58.137])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BB88606A329
	for <linux-scsi@vger.kernel.org>; Mon, 16 Nov 2026 00:18:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9BB88606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=P7NjNivw
X-Envelope-To: linux-scsi@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=6Nv8UWpmLw9m3I+ksZHVThGmPv5YDowjl6D1MWKnEk0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794788300; v=1; x=1795393100;
 b=P7NjNivwYseS5dgipzjnuNA+dbzsd39J+c/OqTXhW14tgXQLpwWcyfsFjy5ye3KY6x6VTigs
 VCsJuEWFD+NLHAX87wrqyxUW96DUGcRVfVQRhSTA0EgyMMwQkleWTI09WkKbbOpMi5Wejo453za
 nCVfHCoRQW+D44S9tps1Mb58=
X-Envelope-To: linux-scsi@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id f214be4e90a1219b;
	Mon, 16 Nov 2026 00:18:20 +0000
X-Mizu-Trace-ID: f214be4e90a1219b
X-Migadu-Flow: FLOW_OUT
From: Qiliang Yuan <qiliang.yuan@linux.dev>
Date: Sun, 15 Nov 2026 19:17:54 -0500
Subject: [PATCH RFC 01/18] scsi: target: uring: Introduce an io_uring based
 user backstore
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261115-feat-target-core-uring-v1-1-28cdc137eac6@linux.dev>
References: <20261115-feat-target-core-uring-v1-0-28cdc137eac6@linux.dev>
In-Reply-To: <20261115-feat-target-core-uring-v1-0-28cdc137eac6@linux.dev>
To: "Martin K. Petersen" <mkp@kernel.org>, Shuah Khan <shuah@kernel.org>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, 
 target-devel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 linux-doc@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, 
 io-uring@vger.kernel.org, Mike Christie <michael.christie@oracle.com>, 
 Bodo Stroesser <bostroesser@gmail.com>, Ming Lei <tom.leiming@gmail.com>, 
 Qiliang Yuan <qiliang.yuan@linux.dev>
X-Mailer: b4 0.13.0

TCM/USER lets a userspace process serve the commands of a LIO device,
which is how distributed storage is exported over iSCSI or vhost-scsi.

All commands of a TCM/USER device go through one command ring under one
mutex, so throughput does not scale with the number of submitters. The
data of each command is copied into and out of a shared data area, and
the server has to parse every SCSI CDB itself.

Start a new backstore, target_core_uring, that will hand block commands
to the server through io_uring commands on several queues. Register the
backstore and let configfs create devices with a size and a block size.
Let the core emulate the SCSI commands through sbc_parse_cdb(), and fail
reads and writes until a server can pick them up.

Signed-off-by: Qiliang Yuan <qiliang.yuan@linux.dev>
---
 drivers/target/Kconfig             |  10 ++
 drivers/target/Makefile            |   1 +
 drivers/target/target_core_uring.c | 214 +++++++++++++++++++++++++++++++++++++
 3 files changed, 225 insertions(+)

diff --git a/drivers/target/Kconfig b/drivers/target/Kconfig
index 92641d39126a3..545a1d4cf37e5 100644
--- a/drivers/target/Kconfig
+++ b/drivers/target/Kconfig
@@ -43,6 +43,16 @@ config TCM_USER2
 	process to handle requests. This is version 2 of the ABI; version 1
 	is obsolete.
 
+config TCM_URING
+	tristate "TCM/URING Subsystem Plugin for Linux"
+	depends on IO_URING
+	help
+	  Say Y here to enable the TCM/URING subsystem plugin, which lets a
+	  userspace server handle the block commands of a device through
+	  io_uring commands. Unlike TCM/USER, the kernel emulates the SCSI
+	  commands and the server only reads, writes, flushes and unmaps
+	  blocks, on several queues and without copying data twice.
+
 source "drivers/target/loopback/Kconfig"
 source "drivers/target/tcm_fc/Kconfig"
 source "drivers/target/iscsi/Kconfig"
diff --git a/drivers/target/Makefile b/drivers/target/Makefile
index 431b84abfb94e..f9d81430f4b5b 100644
--- a/drivers/target/Makefile
+++ b/drivers/target/Makefile
@@ -24,6 +24,7 @@ obj-$(CONFIG_TCM_IBLOCK)	+= target_core_iblock.o
 obj-$(CONFIG_TCM_FILEIO)	+= target_core_file.o
 obj-$(CONFIG_TCM_PSCSI)		+= target_core_pscsi.o
 obj-$(CONFIG_TCM_USER2)		+= target_core_user.o
+obj-$(CONFIG_TCM_URING)		+= target_core_uring.o
 
 # Fabric modules
 obj-$(CONFIG_LOOPBACK_TARGET)	+= loopback/
diff --git a/drivers/target/target_core_uring.c b/drivers/target/target_core_uring.c
new file mode 100644
index 0000000000000..13981e608a85c
--- /dev/null
+++ b/drivers/target/target_core_uring.c
@@ -0,0 +1,214 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * LIO backstore that hands block commands to a userspace server through
+ * io_uring commands.
+ */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/module.h>
+#include <linux/parser.h>
+#include <linux/slab.h>
+#include <target/target_core_base.h>
+#include <target/target_core_backend.h>
+
+#define TCMUR_VERSION		"1.0"
+#define TCMUR_MAX_IO_SIZE	(4U << 20)
+#define TCMUR_DEF_BLOCK_SIZE	512
+
+struct tcmur_dev {
+	struct se_device	se_dev;
+
+	u64			dev_size;
+	u32			block_size;
+};
+
+static struct tcmur_dev *TCMUR_DEV(struct se_device *dev)
+{
+	return container_of(dev, struct tcmur_dev, se_dev);
+}
+
+static sense_reason_t tcmur_execute_rw(struct se_cmd *se_cmd,
+				       struct scatterlist *sgl, u32 sgl_nents,
+				       enum dma_data_direction dir)
+{
+	/* Fail the commands until a server can pick them up */
+	return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
+}
+
+static void tcmur_dev_call_rcu(struct rcu_head *p)
+{
+	struct se_device *dev = container_of(p, struct se_device, rcu_head);
+
+	kfree(TCMUR_DEV(dev));
+}
+
+static int tcmur_attach_hba(struct se_hba *hba, u32 host_id)
+{
+	return 0;
+}
+
+static void tcmur_detach_hba(struct se_hba *hba)
+{
+}
+
+static struct se_device *tcmur_alloc_device(struct se_hba *hba,
+					    const char *name)
+{
+	struct tcmur_dev *udev;
+
+	udev = kzalloc_obj(*udev);
+	if (!udev)
+		return NULL;
+
+	udev->block_size = TCMUR_DEF_BLOCK_SIZE;
+
+	return &udev->se_dev;
+}
+
+static int tcmur_configure_device(struct se_device *dev)
+{
+	struct tcmur_dev *udev = TCMUR_DEV(dev);
+
+	if (!udev->dev_size || (udev->dev_size & (udev->block_size - 1))) {
+		pr_err("dev_size must be a multiple of the block size\n");
+		return -EINVAL;
+	}
+
+	dev->dev_attrib.hw_block_size = udev->block_size;
+	dev->dev_attrib.hw_max_sectors = TCMUR_MAX_IO_SIZE / udev->block_size;
+	dev->dev_attrib.is_nonrot = 1;
+
+	return 0;
+}
+
+static void tcmur_destroy_device(struct se_device *dev)
+{
+}
+
+static void tcmur_free_device(struct se_device *dev)
+{
+	call_rcu(&dev->rcu_head, tcmur_dev_call_rcu);
+}
+
+enum {
+	Opt_dev_size, Opt_block_size, Opt_err,
+};
+
+static const match_table_t tcmur_tokens = {
+	{ Opt_dev_size,		"dev_size=%s" },
+	{ Opt_block_size,	"block_size=%u" },
+	{ Opt_err,		NULL }
+};
+
+static ssize_t tcmur_set_configfs_dev_params(struct se_device *dev,
+					     const char *page, ssize_t count)
+{
+	struct tcmur_dev *udev = TCMUR_DEV(dev);
+	substring_t args[MAX_OPT_ARGS];
+	char *orig, *ptr, *opts;
+	int ret = 0, token, val;
+	u64 size;
+
+	if (target_dev_configured(dev))
+		return -EBUSY;
+
+	opts = kstrdup(page, GFP_KERNEL);
+	if (!opts)
+		return -ENOMEM;
+	orig = opts;
+
+	while (!ret && (ptr = strsep(&opts, ",\n")) != NULL) {
+		if (!*ptr)
+			continue;
+
+		token = match_token(ptr, tcmur_tokens, args);
+		if (token == Opt_dev_size) {
+			ret = match_u64(&args[0], &size);
+			if (!ret)
+				udev->dev_size = size;
+			continue;
+		}
+		if (token == Opt_err || match_int(&args[0], &val) || val < 0) {
+			ret = -EINVAL;
+			break;
+		}
+
+		switch (token) {
+		case Opt_block_size:
+			if (val < 512 || val > PAGE_SIZE || !is_power_of_2(val))
+				ret = -EINVAL;
+			else
+				udev->block_size = val;
+			break;
+		}
+	}
+
+	kfree(orig);
+	return ret ? ret : count;
+}
+
+static ssize_t tcmur_show_configfs_dev_params(struct se_device *dev, char *b)
+{
+	struct tcmur_dev *udev = TCMUR_DEV(dev);
+	ssize_t bl = 0;
+
+	bl += sprintf(b + bl, "Size: %llu Block size: %u", udev->dev_size,
+		      udev->block_size);
+	bl += sprintf(b + bl, "\n");
+	return bl;
+}
+
+static sector_t tcmur_get_blocks(struct se_device *dev)
+{
+	struct tcmur_dev *udev = TCMUR_DEV(dev);
+
+	return div_u64(udev->dev_size, dev->dev_attrib.block_size) - 1;
+}
+
+static struct exec_cmd_ops tcmur_exec_cmd_ops = {
+	.execute_rw		= tcmur_execute_rw,
+};
+
+static sense_reason_t tcmur_parse_cdb(struct se_cmd *se_cmd)
+{
+	return sbc_parse_cdb(se_cmd, &tcmur_exec_cmd_ops);
+}
+
+static const struct target_backend_ops tcmur_ops = {
+	.name			= "uring",
+	.inquiry_prod		= "URING",
+	.inquiry_rev		= TCMUR_VERSION,
+	.owner			= THIS_MODULE,
+	.attach_hba		= tcmur_attach_hba,
+	.detach_hba		= tcmur_detach_hba,
+	.alloc_device		= tcmur_alloc_device,
+	.configure_device	= tcmur_configure_device,
+	.destroy_device		= tcmur_destroy_device,
+	.free_device		= tcmur_free_device,
+	.parse_cdb		= tcmur_parse_cdb,
+	.set_configfs_dev_params = tcmur_set_configfs_dev_params,
+	.show_configfs_dev_params = tcmur_show_configfs_dev_params,
+	.get_device_type	= sbc_get_device_type,
+	.get_blocks		= tcmur_get_blocks,
+	.tb_dev_attrib_attrs	= sbc_attrib_attrs,
+};
+
+static int __init tcmur_module_init(void)
+{
+	return transport_backend_register(&tcmur_ops);
+}
+
+static void __exit tcmur_module_exit(void)
+{
+	target_backend_unregister(&tcmur_ops);
+	/* Wait for the devices that tcmur_free_device() frees with RCU */
+	rcu_barrier();
+}
+
+module_init(tcmur_module_init);
+module_exit(tcmur_module_exit);
+
+MODULE_DESCRIPTION("TCM io_uring subsystem plugin");
+MODULE_AUTHOR("Qiliang Yuan <qiliang.yuan@linux.dev>");
+MODULE_LICENSE("GPL");

-- 
2.43.0

