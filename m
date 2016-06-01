From: Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH v4 4/8] char: rpmb: provide user space interface
Date: Wed,  1 Jun 2016 17:41:28 -0400
Message-ID: <1464817292-5407-5-git-send-email-tomas.winkler@intel.com>
References: <1464817292-5407-1-git-send-email-tomas.winkler@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1464817292-5407-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Ulf Hansson <ulf.hansson@linaro.org>, Adrian Hunter <adrian.hunter@intel.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Vinayak Holikatti <vinholikatti@gmail.com>, Andy Lutomirski <luto@kernel.org>, =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>, Michael Ryleev <gmar@google.com>, Joao Pinto <Joao.Pinto@synopsys.com>, Christoph Hellwig <hch@lst.de>, Yaniv Gardi <ygardi@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org, linux-scsi@vger.kernel.org, Tomas Winkler <tomas.winkler@intel.com>
List-Id: linux-scsi@vger.kernel.org

The user space API is achieved via single synchronous IOCTL.
The request is submitted in in_frames_ptr pointer and received
in out_frames_ptr.

V2: use memdup_user
V3: commit message fix
V4: resend

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 Documentation/ioctl/ioctl-number.txt |   1 +
 MAINTAINERS                          |   1 +
 drivers/char/rpmb/Kconfig            |   7 ++
 drivers/char/rpmb/Makefile           |   1 +
 drivers/char/rpmb/cdev.c             | 207 +++++++++++++++++++++++++++++++++++
 drivers/char/rpmb/core.c             |   9 +-
 drivers/char/rpmb/rpmb-cdev.h        |  31 ++++++
 include/linux/rpmb.h                 |  78 ++-----------
 include/uapi/linux/rpmb.h            | 120 ++++++++++++++++++++
 9 files changed, 384 insertions(+), 71 deletions(-)
 create mode 100644 drivers/char/rpmb/cdev.c
 create mode 100644 drivers/char/rpmb/rpmb-cdev.h
 create mode 100644 include/uapi/linux/rpmb.h

diff --git a/Documentation/ioctl/ioctl-number.txt b/Documentation/ioctl/ioctl-number.txt
index 9369d3b0f09a..51a514befa48 100644
--- a/Documentation/ioctl/ioctl-number.txt
+++ b/Documentation/ioctl/ioctl-number.txt
@@ -320,6 +320,7 @@ Code  Seq#(hex)	Include File		Comments
 0xB1	00-1F	PPPoX			<mailto:mostrows@styx.uwaterloo.ca>
 0xB3	00	linux/mmc/ioctl.h
 0xB4	00-0F	linux/gpio.h		<mailto:linux-gpio@vger.kernel.org>
+0xB5	00	linux/uapi/linux/rpmb.h <mailto:linux-mei@linux.intel.com>
 0xC0	00-0F	linux/usb/iowarrior.h
 0xCA	00-0F	uapi/misc/cxl.h
 0xCA	80-8F	uapi/scsi/cxlflash_ioctl.h
diff --git a/MAINTAINERS b/MAINTAINERS
index b4228dd58e06..bf806f2d3e19 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -9696,6 +9696,7 @@ M:	Tomas Winkler <tomas.winkler@intel.com>
 L:	linux-kernel@vger.kernel.org
 S:	Supported
 F:	drivers/char/rpmb/*
+F:	include/uapi/linux/rpmb.h
 F:	include/linux/rpmb.h
 F:	Documentation/ABI/testing/sysfs-class-rpmb
 
diff --git a/drivers/char/rpmb/Kconfig b/drivers/char/rpmb/Kconfig
index c5e6e909efce..6794be9fcc5e 100644
--- a/drivers/char/rpmb/Kconfig
+++ b/drivers/char/rpmb/Kconfig
@@ -6,3 +6,10 @@ config RPMB
 	  access RPMB partition.
 
 	  If unsure, select N.
+
+config RPMB_INTF_DEV
+	bool "RPMB character device interface /dev/rpmbN"
+	depends on RPMB
+	help
+	  Say yes here if you want to access RPMB from user space
+	  via character device interface /dev/rpmb%d
diff --git a/drivers/char/rpmb/Makefile b/drivers/char/rpmb/Makefile
index 812b3ed264c0..b5dc087b1299 100644
--- a/drivers/char/rpmb/Makefile
+++ b/drivers/char/rpmb/Makefile
@@ -1,4 +1,5 @@
 obj-$(CONFIG_RPMB) += rpmb.o
 rpmb-objs += core.o
+rpmb-$(CONFIG_RPMB_INTF_DEV) += cdev.o
 
 ccflags-y += -D__CHECK_ENDIAN__
diff --git a/drivers/char/rpmb/cdev.c b/drivers/char/rpmb/cdev.c
new file mode 100644
index 000000000000..67e94943d3e3
--- /dev/null
+++ b/drivers/char/rpmb/cdev.c
@@ -0,0 +1,207 @@
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
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/module.h>
+#include <linux/fs.h>
+#include <linux/uaccess.h>
+#include <linux/compat.h>
+#include <linux/slab.h>
+#include <linux/rpmb.h>
+
+#include "rpmb-cdev.h"
+
+static dev_t rpmb_devt;
+#define RPMB_MAX_DEVS  MINORMASK
+
+#define RPMB_DEV_OPEN    0  /** single open bit (position) */
+
+/**
+ * rpmb_open - the open function
+ *
+ * @inode: pointer to inode structure
+ * @file: pointer to file structure
+ *
+ * Return: 0 on success, <0 on error
+ */
+static int rpmb_open(struct inode *inode, struct file *file)
+{
+	struct rpmb_dev *rdev;
+
+	rdev = container_of(inode->i_cdev, struct rpmb_dev, cdev);
+	if (!rdev)
+		return -ENODEV;
+
+	/* the rpmb is single open! */
+	if (test_and_set_bit(RPMB_DEV_OPEN, &rdev->status))
+		return -EBUSY;
+
+	mutex_lock(&rdev->lock);
+
+	file->private_data = rdev;
+
+	mutex_unlock(&rdev->lock);
+
+	return nonseekable_open(inode, file);
+}
+
+static int rpmb_release(struct inode *inode, struct file *file)
+{
+	struct rpmb_dev *rdev = file->private_data;
+
+	clear_bit(RPMB_DEV_OPEN, &rdev->status);
+
+	return 0;
+}
+
+/*
+ * FIMXE: will be exported by the kernel in future version
+ * helper to convert user pointers passed inside __aligned_u64 fields
+ */
+static void __user *u64_to_ptr(__u64 val)
+{
+	return (void __user *) (unsigned long) val;
+}
+
+static int rpmb_ioctl_cmd(struct rpmb_dev *rdev,
+			  struct rpmb_ioc_cmd __user *ptr)
+{
+	struct rpmb_ioc_cmd cmd;
+	struct rpmb_data rpmbd;
+	struct rpmb_frame *in_frames = NULL;
+	struct rpmb_frame *out_frames = NULL;
+	size_t in_sz, out_sz;
+	int ret;
+
+	if (copy_from_user(&cmd, ptr, sizeof(cmd)))
+		return -EFAULT;
+
+	if (cmd.in_frames_count == 0 || cmd.out_frames_count == 0)
+		return -EINVAL;
+
+	in_sz = sizeof(struct rpmb_frame) * cmd.in_frames_count;
+	in_frames = memdup_user(u64_to_ptr(cmd.in_frames_ptr), in_sz);
+	if (IS_ERR(in_frames)) {
+		ret = PTR_ERR(in_frames);
+		in_frames = NULL;
+		goto out;
+	}
+
+	out_sz = sizeof(struct rpmb_frame) * cmd.out_frames_count;
+	out_frames = kmalloc(out_sz, GFP_KERNEL);
+	if (!out_frames) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	rpmbd.req_type = cmd.req;
+	rpmbd.in_frames = in_frames;
+	rpmbd.out_frames = out_frames;
+	rpmbd.in_frames_cnt = cmd.in_frames_count;
+	rpmbd.out_frames_cnt = cmd.out_frames_count;
+
+	ret  = rpmb_send_req(rdev, &rpmbd);
+	if (ret) {
+		dev_err(&rdev->dev, "Failed to process request = %d.\n", ret);
+		goto out;
+	}
+
+	if (copy_to_user(u64_to_ptr(cmd.out_frames_ptr), out_frames, out_sz)) {
+		ret = -EFAULT;
+		goto out;
+	}
+
+	if (copy_to_user(ptr, &cmd, sizeof(cmd))) {
+		ret = -EFAULT;
+		goto out;
+	}
+out:
+	kfree(in_frames);
+	kfree(out_frames);
+	return ret;
+}
+
+static long rpmb_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+{
+	struct rpmb_dev *rdev = file->private_data;
+	struct rpmb_ioc_cmd __user *req = (void __user *)arg;
+
+	if (cmd != RPMB_IOC_REQ) {
+		dev_err(&rdev->dev, "unsupported ioctl 0x%x.\n", cmd);
+		return -ENOIOCTLCMD;
+	}
+
+	return rpmb_ioctl_cmd(rdev, req);
+}
+
+#ifdef CONFIG_COMPAT
+static long compat_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+{
+	struct rpmb_dev *rdev = file->private_data;
+	struct rpmb_ioc_cmd __user *req = (void __user *)compat_ptr(arg);
+
+	if (cmd != RPMB_IOC_REQ) {
+		dev_err(&rdev->dev, "unsupported ioctl 0x%x.\n", cmd);
+		return -ENOIOCTLCMD;
+	}
+
+	return rpmb_ioctl_cmd(rdev, req);
+}
+#endif /* CONFIG_COMPAT */
+
+static const struct file_operations rpmb_fops = {
+	.open           = rpmb_open,
+	.release        = rpmb_release,
+	.unlocked_ioctl = rpmb_ioctl,
+#ifdef CONFIG_COMPAT
+	.compat_ioctl   = compat_ioctl,
+#endif
+	.owner          = THIS_MODULE,
+	.llseek         = noop_llseek,
+};
+
+void rpmb_cdev_prepare(struct rpmb_dev *rdev)
+{
+	rdev->dev.devt = MKDEV(MAJOR(rpmb_devt), rdev->id);
+	rdev->cdev.owner = THIS_MODULE;
+	cdev_init(&rdev->cdev, &rpmb_fops);
+}
+
+void rpmb_cdev_add(struct rpmb_dev *rdev)
+{
+	cdev_add(&rdev->cdev, rdev->dev.devt, 1);
+}
+
+void rpmb_cdev_del(struct rpmb_dev *rdev)
+{
+	if (rdev->dev.devt)
+		cdev_del(&rdev->cdev);
+}
+
+int __init rpmb_cdev_init(void)
+{
+	int ret;
+
+	ret = alloc_chrdev_region(&rpmb_devt, 0, RPMB_MAX_DEVS, "rpmb");
+	if (ret < 0)
+		pr_err("unable to allocate char dev region\n");
+
+	return ret;
+}
+
+void __exit rpmb_cdev_exit(void)
+{
+	if (rpmb_devt)
+		unregister_chrdev_region(rpmb_devt, RPMB_MAX_DEVS);
+}
diff --git a/drivers/char/rpmb/core.c b/drivers/char/rpmb/core.c
index fb401331d345..ce875d773ee4 100644
--- a/drivers/char/rpmb/core.c
+++ b/drivers/char/rpmb/core.c
@@ -20,6 +20,7 @@
 #include <linux/slab.h>
 
 #include <linux/rpmb.h>
+#include "rpmb-cdev.h"
 
 static DEFINE_IDA(rpmb_ida);
 
@@ -313,6 +314,7 @@ int rpmb_dev_unregister(struct device *dev)
 	rpmb_dev_put(rdev);
 
 	mutex_lock(&rdev->lock);
+	rpmb_cdev_del(rdev);
 	device_del(&rdev->dev);
 	mutex_unlock(&rdev->lock);
 
@@ -364,10 +366,14 @@ struct rpmb_dev *rpmb_dev_register(struct device *dev,
 	rdev->dev.parent = dev;
 	rdev->dev.groups = rpmb_attr_groups;
 
+	rpmb_cdev_prepare(rdev);
+
 	ret = device_register(&rdev->dev);
 	if (ret)
 		goto exit;
 
+	rpmb_cdev_add(rdev);
+
 	dev_dbg(&rdev->dev, "registered disk\n");
 
 	return rdev;
@@ -384,11 +390,12 @@ static int __init rpmb_init(void)
 {
 	ida_init(&rpmb_ida);
 	class_register(&rpmb_class);
-	return 0;
+	return rpmb_cdev_init();
 }
 
 static void __exit rpmb_exit(void)
 {
+	rpmb_cdev_exit();
 	class_unregister(&rpmb_class);
 	ida_destroy(&rpmb_ida);
 }
diff --git a/drivers/char/rpmb/rpmb-cdev.h b/drivers/char/rpmb/rpmb-cdev.h
new file mode 100644
index 000000000000..d20e0f16f1a1
--- /dev/null
+++ b/drivers/char/rpmb/rpmb-cdev.h
@@ -0,0 +1,31 @@
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
+
+#ifdef CONFIG_RPMB_INTF_DEV
+int __init rpmb_cdev_init(void);
+void __exit rpmb_cdev_exit(void);
+void rpmb_cdev_prepare(struct rpmb_dev *rdev);
+void rpmb_cdev_add(struct rpmb_dev *rdev);
+void rpmb_cdev_del(struct rpmb_dev *rdev);
+
+#else
+static inline int __init rpmb_cdev_init(void)
+{
+	return 0;
+}
+static inline void __exit rpmb_cdev_exit(void) {}
+static inline void rpmb_cdev_prepare(struct rpmb_dev *rdev) {}
+static inline void rpmb_cdev_add(struct rpmb_dev *rdev) {}
+static inline void rpmb_cdev_del(struct rpmb_dev *rdev) {}
+#endif /* CONFIG_RPMB_INTF_DEV */
diff --git a/include/linux/rpmb.h b/include/linux/rpmb.h
index 2c1e259f1a04..446c6639d275 100644
--- a/include/linux/rpmb.h
+++ b/include/linux/rpmb.h
@@ -15,79 +15,11 @@
 
 #include <linux/types.h>
 #include <linux/device.h>
+#include <linux/cdev.h>
+#include <uapi/linux/rpmb.h>
 #include <linux/kref.h>
 
 /**
- * struct rpmb_frame - rpmb frame as defined by specs
- *
- * @stuff        : stuff bytes
- * @key_mac      : The authentication key or the message authentication
- *                 code (MAC) depending on the request/response type.
- *                 The MAC will be delivered in the last (or the only)
- *                 block of data.
- * @data         : Data to be written or read by signed access.
- * @nonce        : Random number generated by the host for the requests
- *                 and copied to the response by the RPMB engine.
- * @write_counter: Counter value for the total amount of the successful
- *                 authenticated data write requests made by the host.
- * @addr         : Address of the data to be programmed to or read
- *                 from the RPMB. Address is the serial number of
- *                 the accessed block (half sector 256B).
- * @block_count  : Number of blocks (half sectors, 256B) requested to be
- *                 read/programmed.
- * @result       : Includes information about the status of the write counter
- *                 (valid, expired) and result of the access made to the RPMB.
- * @req_resp     : Defines the type of request and response to/from the memory.
- */
-struct rpmb_frame {
-	u8     stuff[196];
-	u8     key_mac[32];
-	u8     data[256];
-	u8     nonce[16];
-	__be32 write_counter;
-	__be16 addr;
-	__be16 block_count;
-	__be16 result;
-	__be16 req_resp;
-} __packed;
-
-#define RPMB_PROGRAM_KEY       0x1    /* Program RPMB Authentication Key */
-#define RPMB_GET_WRITE_COUNTER 0x2    /* Read RPMB write counter */
-#define RPMB_WRITE_DATA        0x3    /* Write data to RPMB partition */
-#define RPMB_READ_DATA         0x4    /* Read data from RPMB partition */
-#define RPMB_RESULT_READ       0x5    /* Read result request  (Internal) */
-
-#define RPMB_REQ2RESP(_OP) ((_OP) << 8)
-#define RPMB_RESP2REQ(_OP) ((_OP) >> 8)
-
-/**
- * enum rpmb_op_result - rpmb operation results
- *
- * @RPMB_ERR_OK      : operation successful
- * @RPMB_ERR_GENERAL : general failure
- * @RPMB_ERR_AUTH    : mac doesn't match or ac calculation failure
- * @RPMB_ERR_COUNTER : counter doesn't match or counter increment failure
- * @RPMB_ERR_ADDRESS : address out of range or wrong address alignment
- * @RPMB_ERR_WRITE   : data, counter, or result write failure
- * @RPMB_ERR_READ    : data, counter, or result read failure
- * @RPMB_ERR_NO_KEY  : authentication key not yet programmed
- *
- * @RPMB_ERR_COUNTER_EXPIRED:  counter expired
- */
-enum rpmb_op_result {
-	RPMB_ERR_OK      = 0x0000,
-	RPMB_ERR_GENERAL = 0x0001,
-	RPMB_ERR_AUTH    = 0x0002,
-	RPMB_ERR_COUNTER = 0x0003,
-	RPMB_ERR_ADDRESS = 0x0004,
-	RPMB_ERR_WRITE   = 0x0005,
-	RPMB_ERR_READ    = 0x0006,
-	RPMB_ERR_NO_KEY  = 0x0007,
-
-	RPMB_ERR_COUNTER_EXPIRED = 0x0080
-};
-
-/**
  * enum rpmb_type - type of underlaying storage technology
  *
  * @RPMB_TYPE_ANY   : any type used for search only
@@ -144,12 +76,18 @@ struct rpmb_ops {
  * @lock       : lock
  * @dev        : device
  * @id         : device id
+ * @cdev       : character dev
+ * @status     : device status
  * @ops        : operation exported by block layer
  */
 struct rpmb_dev {
 	struct mutex lock;
 	struct device dev;
 	int    id;
+#ifdef CONFIG_RPMB_INTF_DEV
+	struct cdev cdev;
+	unsigned long status;
+#endif /* CONFIG_RPMB_INTF_DEV */
 	const struct rpmb_ops *ops;
 };
 
diff --git a/include/uapi/linux/rpmb.h b/include/uapi/linux/rpmb.h
new file mode 100644
index 000000000000..55aa92e11280
--- /dev/null
+++ b/include/uapi/linux/rpmb.h
@@ -0,0 +1,120 @@
+/*
+ * Copyright (C) 2015-2016, Intel Corp.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License version
+ * 2 as published by the Free Software Foundation;
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef _UAPI_LINUX_RPMB_H_
+#define _UAPI_LINUX_RPMB_H_
+
+#include <linux/types.h>
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
+	__u8   stuff[196];
+	__u8   key_mac[32];
+	__u8   data[256];
+	__u8   nonce[16];
+	__be32 write_counter;
+	__be16 addr;
+	__be16 block_count;
+	__be16 result;
+	__be16 req_resp;
+} __attribute__((packed));
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
+/* length of the part of the frame used for HMAC computation */
+#define hmac_data_len \
+	(sizeof(struct rpmb_frame) - offsetof(struct rpmb_frame, data))
+
+/**
+ * enum rpmb_op_result - rpmb operation results
+ *
+ * @RPMB_ERR_OK:       operation successful
+ * @RPMB_ERR_GENERAL:  general failure
+ * @RPMB_ERR_AUTH:     mac doesn't match or ac calculation failure
+ * @RPMB_ERR_COUNTER:  counter doesn't match or counter increment failure
+ * @RPMB_ERR_ADDRESS:  address out of range or wrong address alignment
+ * @RPMB_ERR_WRITE:    data, counter, or result write failure
+ * @RPMB_ERR_READ:     data, counter, or result read failure
+ * @RPMB_ERR_NO_KEY:   authentication key not yet programmed
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
+ * struct rpmb_ioc_cmd - rpmb operation request command
+ *
+ * @req:                request type:  must match the in frame req_resp
+ *                          program key
+ *                          get write counter
+ *                          write/read data
+ * @in_frames_count:    number of in frames
+ * @out_frames_count:   number of out frames
+ * @in_frames_ptr:      a pointer to the input frames buffer
+ * @out_frames_ptr:     a pointer to output frames buffer
+ */
+struct rpmb_ioc_cmd {
+	__u32  req;
+	__u32  in_frames_count;
+	__u32  out_frames_count;
+	__aligned_u64 in_frames_ptr;
+	__aligned_u64 out_frames_ptr;
+};
+
+#define rpmb_ioc_cmd_set_in_frames(_ic, _ptr) \
+	(_ic).in_frames_ptr = (__aligned_u64)(intptr_t)(_ptr)
+#define rpmb_ioc_cmd_set_out_frames(_ic, _ptr) \
+	(_ic).out_frames_ptr = (__aligned_u64)(intptr_t)(_ptr)
+
+#define RPMB_IOC_REQ _IOWR(0xB5, 1, struct rpmb_ioc_cmd)
+
+#endif /* _UAPI_LINUX_RPMB_H_ */
-- 
2.5.5
