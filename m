From: Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 1/8] rpmb: add Replay Protected Memory Block (RPMB) subsystem
Date: Sun,  3 Apr 2016 12:42:45 +0300
Message-ID: <1459676572-29921-2-git-send-email-tomas.winkler@intel.com>
References: <1459676572-29921-1-git-send-email-tomas.winkler@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1459676572-29921-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: gregkh@linuxfoundation.org, Ulf Hansson <ulf.hansson@linaro.org>, Adrian Hunter <adrian.hunter@intel.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Vinayak Holikatti <vinholikatti@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>, Yaniv Gardi <ygardi@codeaurora.org>, Joao Pinto <Joao.Pinto@synopsys.com>, linux-mmc@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Tomas Winkler <tomas.winkler@intel.com>, Alexander Usyskin <alexander.usyskin@intel.com>
List-Id: linux-scsi@vger.kernel.org

Few storage technology such is EMMC, UFS, and NVMe support RPMB hardware
partition with common protocol and frame layout.
The RPMB partition cannot be accessed via standard block layer, but by a
set of specific commands: WRITE, READ, GET_WRITE_COUNTER, and PROGRAM_KEY.
Such a partition provides authenticated and replay protected access,
hence suitable as a secure storage.

The RPMB layer aims to provide in-kernel API for Trusted Execution
Environment (TEE) devices that are capable to securely compute block
frame signature. A TEE driver can claim rpmb interface, for example,
via  class_interface_register ().

A storage device registers its RPMB hardware (emmc) partition or
RPMB W-LUN (ufs) with the RPMB layer providing an implementation
for send_rpmb_req() handler.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
---
 MAINTAINERS                |   7 +
 drivers/char/Kconfig       |   2 +
 drivers/char/Makefile      |   1 +
 drivers/char/rpmb/Kconfig  |   8 ++
 drivers/char/rpmb/Makefile |   4 +
 drivers/char/rpmb/core.c   | 337 +++++++++++++++++++++++++++++++++++++++++++++
 include/linux/rpmb.h       | 200 +++++++++++++++++++++++++++
 7 files changed, 559 insertions(+)
 create mode 100644 drivers/char/rpmb/Kconfig
 create mode 100644 drivers/char/rpmb/Makefile
 create mode 100644 drivers/char/rpmb/core.c
 create mode 100644 include/linux/rpmb.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 16ccda4d8054..d1d7b7ffedab 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -9424,6 +9424,13 @@ F:	include/net/rose.h
 F:	include/uapi/linux/rose.h
 F:	net/rose/
 
+RPMB SUBSYSTEM
+M:	Tomas Winkler <tomas.winkler@intel.com>
+L:	linux-kernel@vger.kernel.org
+S:	Supported
+F:	drivers/char/rpmb/*
+F:	include/linux/rpmb.h
+
 RTL2830 MEDIA DRIVER
 M:	Antti Palosaari <crope@iki.fi>
 L:	linux-media@vger.kernel.org
diff --git a/drivers/char/Kconfig b/drivers/char/Kconfig
index 3ec0766ed5e9..b5970f965fa7 100644
--- a/drivers/char/Kconfig
+++ b/drivers/char/Kconfig
@@ -604,5 +604,7 @@ config TILE_SROM
 
 source "drivers/char/xillybus/Kconfig"
 
+source "drivers/char/rpmb/Kconfig"
+
 endmenu
 
diff --git a/drivers/char/Makefile b/drivers/char/Makefile
index d8a7579300d2..1a5e43c1a9a6 100644
--- a/drivers/char/Makefile
+++ b/drivers/char/Makefile
@@ -60,3 +60,4 @@ js-rtc-y = rtc.o
 
 obj-$(CONFIG_TILE_SROM)		+= tile-srom.o
 obj-$(CONFIG_XILLYBUS)		+= xillybus/
+obj-$(CONFIG_RPMB)		+= rpmb/
diff --git a/drivers/char/rpmb/Kconfig b/drivers/char/rpmb/Kconfig
new file mode 100644
index 000000000000..c5e6e909efce
--- /dev/null
+++ b/drivers/char/rpmb/Kconfig
@@ -0,0 +1,8 @@
+config RPMB
+	tristate "RPMB partition interface"
+	help
+	  Unified RPMB partition interface for eMMC and UFS.
+	  Provides interface for in kernel security controllers to
+	  access RPMB partition.
+
+	  If unsure, select N.
diff --git a/drivers/char/rpmb/Makefile b/drivers/char/rpmb/Makefile
new file mode 100644
index 000000000000..812b3ed264c0
--- /dev/null
+++ b/drivers/char/rpmb/Makefile
@@ -0,0 +1,4 @@
+obj-$(CONFIG_RPMB) += rpmb.o
+rpmb-objs += core.o
+
+ccflags-y += -D__CHECK_ENDIAN__
diff --git a/drivers/char/rpmb/core.c b/drivers/char/rpmb/core.c
new file mode 100644
index 000000000000..c9ea30aca6be
--- /dev/null
+++ b/drivers/char/rpmb/core.c
@@ -0,0 +1,337 @@
+/*
+ * Copyright (C) 2015-2016 Intel Corp. All rights reserved
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 of the License.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
+ * General Public License for more details.
+ */
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/mutex.h>
+#include <linux/list.h>
+#include <linux/device.h>
+#include <linux/slab.h>
+
+#include <linux/rpmb.h>
+
+static DEFINE_IDA(rpmb_ida);
+
+/**
+ * rpmb_dev_get - increase rpmb device ref counter
+ *
+ * @rdev: rpmb device
+ */
+struct rpmb_dev *rpmb_dev_get(struct rpmb_dev *rdev)
+{
+	return get_device(&rdev->dev) ? rdev : NULL;
+}
+EXPORT_SYMBOL_GPL(rpmb_dev_get);
+
+/**
+ * rpmb_dev_put - decrease rpmb device ref counter
+ *
+ * @rdev: rpmb device
+ */
+void rpmb_dev_put(struct rpmb_dev *rdev)
+{
+	put_device(&rdev->dev);
+}
+EXPORT_SYMBOL_GPL(rpmb_dev_put);
+
+static int rpmb_request_verify(struct rpmb_dev *rdev, struct rpmb_data *rpmbd)
+{
+	u16 req_type, block_count;
+
+	if (rpmbd->in_frames == NULL  || rpmbd->out_frames == NULL ||
+	    rpmbd->in_frames_cnt == 0 || rpmbd->out_frames_cnt == 0)
+		return -EINVAL;
+
+	req_type = be16_to_cpu(rpmbd->in_frames[0].req_resp);
+	block_count = be16_to_cpu(rpmbd->in_frames[0].block_count);
+
+	if (rpmbd->req_type != req_type) {
+		dev_err(&rdev->dev, "rpmb req type doesn't match 0x%04X = 0x%04X\n",
+			req_type, rpmbd->req_type);
+		return -EINVAL;
+	}
+
+	switch (req_type) {
+	case RPMB_PROGRAM_KEY:
+		dev_dbg(&rdev->dev, "rpmb program key = 0x%1x blk = %d\n",
+			req_type, block_count);
+		break;
+	case RPMB_GET_WRITE_COUNTER:
+		dev_dbg(&rdev->dev, "rpmb get write counter = 0x%1x blk = %d\n",
+			req_type, block_count);
+
+		break;
+	case RPMB_WRITE_DATA:
+		dev_dbg(&rdev->dev, "rpmb write data = 0x%1x blk = %d\n",
+			req_type, block_count);
+
+		if (rdev->ops->reliable_wr_cnt &&
+		    block_count > rdev->ops->reliable_wr_cnt) {
+			dev_err(&rdev->dev, "rpmb write data: block count %u > reliable wr count %u\n",
+				block_count, rdev->ops->reliable_wr_cnt);
+			return -EINVAL;
+		}
+
+		if (block_count > rpmbd->in_frames_cnt) {
+			dev_err(&rdev->dev, "rpmb write data: block count %u > in frame count %u\n",
+				block_count, rpmbd->in_frames_cnt);
+			return -EINVAL;
+		}
+		break;
+	case RPMB_READ_DATA:
+		dev_dbg(&rdev->dev, "rpmb read data = 0x%1x blk = %d\n",
+			req_type, block_count);
+
+		if (block_count > rpmbd->out_frames_cnt) {
+			dev_err(&rdev->dev, "rpmb read data: block count %u > out frame count %u\n",
+				block_count, rpmbd->in_frames_cnt);
+			return -EINVAL;
+		}
+		break;
+	case RPMB_RESULT_READ:
+		/* Internal command not supported */
+		dev_err(&rdev->dev, "NOTSUPPORTED rpmb resut read = 0x%1x blk = %d\n",
+			req_type, block_count);
+		return -EOPNOTSUPP;
+
+	default:
+		dev_err(&rdev->dev, "Error rpmb invalid command = 0x%1x blk = %d\n",
+			req_type, block_count);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+/**
+ * rpmb_send_req - send rpmb request
+ *
+ * @rdev: rpmb device
+ * @data: rpmb request data
+ *
+ * Return: 0 on success
+ *         -EINVAL on wrong parameters
+ *         -EOPNOTSUPP if device doesn't support the requested operation
+ *         < 0 if the operation fails
+ */
+int rpmb_send_req(struct rpmb_dev *rdev, struct rpmb_data *data)
+{
+	int err;
+
+	if (!rdev || !data)
+		return -EINVAL;
+
+	err = rpmb_request_verify(rdev, data);
+	if (err)
+		return err;
+
+	mutex_lock(&rdev->lock);
+	if (rdev->ops && rdev->ops->send_rpmb_req)
+		err = rdev->ops->send_rpmb_req(rdev->dev.parent, data);
+	else
+		err = -EOPNOTSUPP;
+	mutex_unlock(&rdev->lock);
+	return err;
+}
+EXPORT_SYMBOL_GPL(rpmb_send_req);
+
+static void rpmb_dev_release(struct device *dev)
+{
+	struct rpmb_dev *rdev = to_rpmb_dev(dev);
+
+	ida_simple_remove(&rpmb_ida, rdev->id);
+	kfree(rdev);
+}
+
+struct class rpmb_class = {
+	.name = "rpmb",
+	.owner = THIS_MODULE,
+	.dev_release = rpmb_dev_release,
+};
+EXPORT_SYMBOL(rpmb_class);
+
+/**
+ * rpmb_dev_find_device - return first matching rpmb device
+ *
+ * @data: data for the match function
+ * @match: the matching function
+ *
+ * Return: matching rpmb device or NULL on failure
+ */
+struct rpmb_dev *rpmb_dev_find_device(void *data,
+			int (*match)(struct device *dev, const void *data))
+{
+	struct device *dev;
+
+	dev = class_find_device(&rpmb_class, NULL, data, match);
+
+	return dev ? to_rpmb_dev(dev) : NULL;
+}
+EXPORT_SYMBOL_GPL(rpmb_dev_find_device);
+
+static int match_by_type(struct device *dev, const void *data)
+{
+	struct rpmb_dev *rdev = to_rpmb_dev(dev);
+	enum rpmb_type *type = (enum rpmb_type *)data;
+
+	return (*type == RPMB_TYPE_ANY || rdev->ops->type == *type);
+}
+
+/**
+ * rpmb_dev_get_by_type - return first registered rpmb device
+ *      with matching type.
+ *      If run with RPMB_TYPE_ANY the first an probably only
+ *      device is returned
+ *
+ * @type: rpbm underlying device type
+ *
+ * Return: matching rpmb device or NULL/ERR_PTR on failure
+ */
+struct rpmb_dev *rpmb_dev_get_by_type(enum rpmb_type type)
+{
+	if (type > RPMB_TYPE_MAX)
+		return ERR_PTR(-EINVAL);
+
+	return rpmb_dev_find_device(&type, match_by_type);
+}
+EXPORT_SYMBOL_GPL(rpmb_dev_get_by_type);
+
+static int match_by_parent(struct device *dev, const void *data)
+{
+	const struct device *parent = data;
+
+	return (parent && dev->parent == parent);
+}
+
+/**
+ * rpmb_dev_find_by_device - retrieve rpmb device from the parent device
+ *
+ * @parent: parent device of the rpmb device
+ *
+ * Return: NULL if there is no rpmb device associated with the parent device
+ */
+struct rpmb_dev *rpmb_dev_find_by_device(struct device *parent)
+{
+	if (!parent)
+		return NULL;
+
+	return rpmb_dev_find_device(parent, match_by_parent);
+}
+EXPORT_SYMBOL_GPL(rpmb_dev_find_by_device);
+
+/**
+ * rpmb_dev_unregister - unregister RPMB partition from the RPMB subsystem
+ *
+ * @dev: parent device of the rpmb device
+ */
+int rpmb_dev_unregister(struct device *dev)
+{
+	struct rpmb_dev *rdev;
+
+	if (!dev)
+		return -EINVAL;
+
+	rdev = rpmb_dev_find_by_device(dev);
+	if (!rdev) {
+		dev_warn(dev, "no disk found %s\n", dev_name(dev->parent));
+		return -ENODEV;
+	}
+
+	rpmb_dev_put(rdev);
+
+	mutex_lock(&rdev->lock);
+	device_del(&rdev->dev);
+	mutex_unlock(&rdev->lock);
+
+	rpmb_dev_put(rdev);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(rpmb_dev_unregister);
+
+
+/**
+ * rpmb_dev_register - register RPMB partition with the RPMB subsystem
+ *
+ * @dev: storage device of the rpmb device
+ * @ops: device specific operations
+ */
+struct rpmb_dev *rpmb_dev_register(struct device *dev,
+				   const struct rpmb_ops *ops)
+{
+	struct rpmb_dev *rdev;
+	int id;
+	int ret;
+
+	if (!dev || !ops)
+		return ERR_PTR(-EINVAL);
+
+	if (!ops->send_rpmb_req)
+		return ERR_PTR(-EINVAL);
+
+	if (ops->type == RPMB_TYPE_ANY || ops->type > RPMB_TYPE_MAX)
+		return ERR_PTR(-EINVAL);
+
+	rdev = kzalloc(sizeof(struct rpmb_dev), GFP_KERNEL);
+	if (!rdev)
+		return ERR_PTR(-ENOMEM);
+
+	id = ida_simple_get(&rpmb_ida, 0, 0, GFP_KERNEL);
+	if (id < 0) {
+		ret = id;
+		goto exit;
+	}
+
+	mutex_init(&rdev->lock);
+	rdev->ops = ops;
+	rdev->id = id;
+
+	dev_set_name(&rdev->dev, "rpmb%d", id);
+	rdev->dev.class = &rpmb_class;
+	rdev->dev.parent = dev;
+	ret = device_register(&rdev->dev);
+	if (ret)
+		goto exit;
+
+	dev_dbg(&rdev->dev, "registered disk\n");
+
+	return rdev;
+
+exit:
+	if (id >= 0)
+		ida_simple_remove(&rpmb_ida, id);
+	kfree(rdev);
+	return ERR_PTR(ret);
+}
+EXPORT_SYMBOL_GPL(rpmb_dev_register);
+
+static int __init rpmb_init(void)
+{
+	ida_init(&rpmb_ida);
+	class_register(&rpmb_class);
+	return 0;
+}
+
+static void __exit rpmb_exit(void)
+{
+	class_unregister(&rpmb_class);
+	ida_destroy(&rpmb_ida);
+}
+
+subsys_initcall(rpmb_init);
+module_exit(rpmb_exit);
+
+MODULE_AUTHOR("Intel Corporation");
+MODULE_DESCRIPTION("RPMB class");
+MODULE_LICENSE("GPL");
diff --git a/include/linux/rpmb.h b/include/linux/rpmb.h
new file mode 100644
index 000000000000..2c1e259f1a04
--- /dev/null
+++ b/include/linux/rpmb.h
@@ -0,0 +1,200 @@
+/*
+ * Copyright (C) 2015-2016 Intel Corp. All rights reserved
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 of the License.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
+ * General Public License for more details.
+ */
+#ifndef __RPMB_H__
+#define __RPMB_H__
+
+#include <linux/types.h>
+#include <linux/device.h>
+#include <linux/kref.h>
+
+/**
+ * struct rpmb_frame - rpmb frame as defined by specs
+ *
+ * @stuff        : stuff bytes
+ * @key_mac      : The authentication key or the message authentication
+ *                 code (MAC) depending on the request/response type.
+ *                 The MAC will be delivered in the last (or the only)
+ *                 block of data.
+ * @data         : Data to be written or read by signed access.
+ * @nonce        : Random number generated by the host for the requests
+ *                 and copied to the response by the RPMB engine.
+ * @write_counter: Counter value for the total amount of the successful
+ *                 authenticated data write requests made by the host.
+ * @addr         : Address of the data to be programmed to or read
+ *                 from the RPMB. Address is the serial number of
+ *                 the accessed block (half sector 256B).
+ * @block_count  : Number of blocks (half sectors, 256B) requested to be
+ *                 read/programmed.
+ * @result       : Includes information about the status of the write counter
+ *                 (valid, expired) and result of the access made to the RPMB.
+ * @req_resp     : Defines the type of request and response to/from the memory.
+ */
+struct rpmb_frame {
+	u8     stuff[196];
+	u8     key_mac[32];
+	u8     data[256];
+	u8     nonce[16];
+	__be32 write_counter;
+	__be16 addr;
+	__be16 block_count;
+	__be16 result;
+	__be16 req_resp;
+} __packed;
+
+#define RPMB_PROGRAM_KEY       0x1    /* Program RPMB Authentication Key */
+#define RPMB_GET_WRITE_COUNTER 0x2    /* Read RPMB write counter */
+#define RPMB_WRITE_DATA        0x3    /* Write data to RPMB partition */
+#define RPMB_READ_DATA         0x4    /* Read data from RPMB partition */
+#define RPMB_RESULT_READ       0x5    /* Read result request  (Internal) */
+
+#define RPMB_REQ2RESP(_OP) ((_OP) << 8)
+#define RPMB_RESP2REQ(_OP) ((_OP) >> 8)
+
+/**
+ * enum rpmb_op_result - rpmb operation results
+ *
+ * @RPMB_ERR_OK      : operation successful
+ * @RPMB_ERR_GENERAL : general failure
+ * @RPMB_ERR_AUTH    : mac doesn't match or ac calculation failure
+ * @RPMB_ERR_COUNTER : counter doesn't match or counter increment failure
+ * @RPMB_ERR_ADDRESS : address out of range or wrong address alignment
+ * @RPMB_ERR_WRITE   : data, counter, or result write failure
+ * @RPMB_ERR_READ    : data, counter, or result read failure
+ * @RPMB_ERR_NO_KEY  : authentication key not yet programmed
+ *
+ * @RPMB_ERR_COUNTER_EXPIRED:  counter expired
+ */
+enum rpmb_op_result {
+	RPMB_ERR_OK      = 0x0000,
+	RPMB_ERR_GENERAL = 0x0001,
+	RPMB_ERR_AUTH    = 0x0002,
+	RPMB_ERR_COUNTER = 0x0003,
+	RPMB_ERR_ADDRESS = 0x0004,
+	RPMB_ERR_WRITE   = 0x0005,
+	RPMB_ERR_READ    = 0x0006,
+	RPMB_ERR_NO_KEY  = 0x0007,
+
+	RPMB_ERR_COUNTER_EXPIRED = 0x0080
+};
+
+/**
+ * enum rpmb_type - type of underlaying storage technology
+ *
+ * @RPMB_TYPE_ANY   : any type used for search only
+ * @RPMB_TYPE_EMMC  : emmc (JESD84-B50.1)
+ * @RPMB_TYPE_UFS   : UFS (JESD220)
+ * @RPMB_TYPE_MAX   : upper sentinel
+ */
+enum rpmb_type {
+	RPMB_TYPE_ANY = 0,
+	RPMB_TYPE_EMMC,
+	RPMB_TYPE_UFS,
+	RPMB_TYPE_MAX = RPMB_TYPE_UFS
+};
+
+extern struct class rpmb_class;
+
+/**
+ * struct rpmb_data - rpmb data be transmitted in RPMB request
+ *
+ * @in_frames     :  list of input frames
+ * @out_frames    :  list of result frames
+ * @in_frames_cnt :  count of the input frames
+ * @out_frames_cnt:  count of the output frames
+ * @req_type      :  request type (program key, read, write, write counter)
+ */
+struct rpmb_data {
+	struct rpmb_frame *in_frames;
+	struct rpmb_frame *out_frames;
+	u32 in_frames_cnt;
+	u32 out_frames_cnt;
+	u16 req_type;
+};
+
+/**
+ * struct rpmb_ops - RPMB ops to be implemented by underlaying block device
+ *
+ * @send_rpmb_req  : send RPMB request to RPBM partition backed by the disk
+ * @type           : block device type
+ * @dev_id         : unique device identifier
+ * @dev_id_len     : unique device identifier length
+ * @reliable_wr_cnt: number of sectors that can be written in one access
+ */
+struct rpmb_ops {
+	int (*send_rpmb_req)(struct device *dev, struct rpmb_data *req);
+	enum rpmb_type type;
+	const u8 *dev_id;
+	size_t dev_id_len;
+	u16 reliable_wr_cnt;
+};
+
+/**
+ * struct rpmb_dev - device which can support RPMB partition
+ *
+ * @lock       : lock
+ * @dev        : device
+ * @id         : device id
+ * @ops        : operation exported by block layer
+ */
+struct rpmb_dev {
+	struct mutex lock;
+	struct device dev;
+	int    id;
+	const struct rpmb_ops *ops;
+};
+
+#define to_rpmb_dev(x) container_of((x), struct rpmb_dev, dev)
+
+#if IS_ENABLED(CONFIG_RPMB)
+struct rpmb_dev *rpmb_dev_get(struct rpmb_dev *rdev);
+void rpmb_dev_put(struct rpmb_dev *rdev);
+struct rpmb_dev *rpmb_dev_find_by_device(struct device *parent);
+struct rpmb_dev *rpmb_dev_get_by_type(enum rpmb_type type);
+struct rpmb_dev *rpmb_dev_register(struct device *dev,
+				   const struct rpmb_ops *ops);
+struct rpmb_dev *rpmb_dev_find_device(void *data,
+			int (*match)(struct device *dev, const void *data));
+int rpmb_dev_unregister(struct device *dev);
+int rpmb_send_req(struct rpmb_dev *rdev, struct rpmb_data *data);
+
+#else
+static inline struct rpmb_dev *rpmb_dev_get(struct rpmb_dev *rdev)
+{
+	return NULL;
+}
+static inline void rpmb_dev_put(struct rpmb_dev *rdev) { }
+static inline struct rpmb_dev *rpmb_dev_find_by_device(struct device *parent)
+{
+	return NULL;
+}
+static inline
+struct rpmb_dev *rpmb_dev_get_by_type(enum rpmb_type type)
+{
+	return NULL;
+}
+static inline struct rpmb_dev *
+rpmb_dev_register(struct device *dev, const struct rpmb_ops *ops)
+{
+	return NULL;
+}
+static inline int rpmb_dev_unregister(struct device *dev)
+{
+	return 0;
+}
+static inline int rpmb_send_req(struct rpmb_dev *rdev, struct rpmb_data *data)
+{
+	return 0;
+}
+#endif /* CONFIG_RPMB */
+
+#endif /* __RPMB_H__ */
-- 
2.4.3
