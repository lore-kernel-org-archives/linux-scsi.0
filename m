From: Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH v7 11/11] char: rpmb: Document Replay Protected Memory Block (RPMB) subsystem
Date: Mon,  7 Nov 2016 21:53:14 +0200
Message-ID: <1478548394-8184-12-git-send-email-tomas.winkler@intel.com>
References: <1478548394-8184-1-git-send-email-tomas.winkler@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1478548394-8184-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Ulf Hansson <ulf.hansson@linaro.org>, Adrian Hunter <adrian.hunter@intel.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Vinayak Holikatti <vinholikatti@gmail.com>, Andy Lutomirski <luto@kernel.org>, =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>, Michael Ryleev <gmar@google.com>, Joao Pinto <Joao.Pinto@synopsys.com>, Christoph Hellwig <hch@lst.de>, Yaniv Gardi <ygardi@codeaurora.org>
Cc: Avri Altman <avri.altman@gmail.com>, linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org, linux-scsi@vger.kernel.org, linux-doc@vger.kernel.org, Tomas Winkler <tomas.winkler@intel.com>
List-Id: linux-scsi@vger.kernel.org

Add rpmb documentatin in sphinx format.

V7: new in the series

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 Documentation/index.rst                  |   1 +
 Documentation/rpmb/conf.py               |   5 ++
 Documentation/rpmb/index.rst             |  18 ++++++
 Documentation/rpmb/introduction.rst      | 102 +++++++++++++++++++++++++++++++
 Documentation/rpmb/rpmb-tool.rst         |  19 ++++++
 Documentation/rpmb/simulation-device.rst |  19 ++++++
 MAINTAINERS                              |   1 +
 7 files changed, 165 insertions(+)
 create mode 100644 Documentation/rpmb/conf.py
 create mode 100644 Documentation/rpmb/index.rst
 create mode 100644 Documentation/rpmb/introduction.rst
 create mode 100644 Documentation/rpmb/rpmb-tool.rst
 create mode 100644 Documentation/rpmb/simulation-device.rst

diff --git a/Documentation/index.rst b/Documentation/index.rst
index c53d089455a4..56dd46e9359c 100644
--- a/Documentation/index.rst
+++ b/Documentation/index.rst
@@ -18,6 +18,7 @@ Contents:
    media/index
    gpu/index
    80211/index
+   rpmb/index
 
 Indices and tables
 ==================
diff --git a/Documentation/rpmb/conf.py b/Documentation/rpmb/conf.py
new file mode 100644
index 000000000000..20c7c275ef4a
--- /dev/null
+++ b/Documentation/rpmb/conf.py
@@ -0,0 +1,5 @@
+# -*- coding: utf-8; mode: python -*-
+
+project = "Linux 802.11 Driver Developer's Guide"
+
+tags.add("subproject")
diff --git a/Documentation/rpmb/index.rst b/Documentation/rpmb/index.rst
new file mode 100644
index 000000000000..876a2603e4b5
--- /dev/null
+++ b/Documentation/rpmb/index.rst
@@ -0,0 +1,18 @@
+.. -*- coding: utf-8; mode: rst -*-
+
+==============================================
+Replay Protected Memory Block (RPMB) subsystem
+==============================================
+
+.. toctree::
+
+   introduction
+   simulation-device.rst
+   rpmb-tool.rst
+
+.. only::  subproject
+
+   Indices
+   =======
+
+   * :ref:`genindex`
diff --git a/Documentation/rpmb/introduction.rst b/Documentation/rpmb/introduction.rst
new file mode 100644
index 000000000000..f4ded7d18e55
--- /dev/null
+++ b/Documentation/rpmb/introduction.rst
@@ -0,0 +1,102 @@
+.. -*- coding: utf-8; mode: rst -*-
+
+=============
+Introduction:
+=============
+
+Few storage technologies such is EMMC, UFS, and NVMe support RPMB
+hardware partition with common protocol and frame layout.
+The RPMB partition `cannot` be accessed via standard block layer,
+but by a set of specific commands:
+
+WRITE, READ, GET_WRITE_COUNTER, and PROGRAM_KEY.
+
+The commands and the data are embedded within :c:type:`rpmb_frame <rpmb_frame>`.
+
+An RPMB partition provides authenticated and replay protected access,
+hence it is suitable as a secure storage.
+
+In-kernel API
+-------------
+The RPMB layer aims to provide in-kernel API for Trusted Execution
+Environment (TEE) devices that are capable to securely compute the block
+frame signature. In case a TEE device wish to store a replay protected
+data, it creates an RPMB frame with requested data and computes HMAC of
+the frame, then it requests the storage device via RPMB layer to store
+the data.
+
+The layer provides two APIs, for :c:func:`rpmb_req_cmd()` for issuing one of RPMB
+specific commands and :c:func:`rpmb_seq_cmd()` for issuing of raw RPMB protocol
+frames, which is close to the functionality provided by emmc multi ioctl
+interface.
+
+.. c:function:: int rpmb_cmd_req(struct rpmb_dev *rdev, struct rpmb_data *data);
+
+.. c:function:: int rpmb_cmd_seq(struct rpmb_dev *rdev, struct rpmb_cmd *cmds, u32 ncmds);
+
+
+A TEE driver can claim the RPMB interface, for example, via
+:c:func:`class_interface_register`:
+
+.. code-block:: c
+
+        struct class_interface tee_rpmb_intf = {
+                .class      = &rpmb_class;
+                .add_dev    = rpmb_add_device;
+                .remove_dev = rpmb_remove_device;
+        }
+        class_interface_register(&tee_rpmb_intf);
+
+
+RPMB device registeration
+----------------------------
+
+A storage device registers its RPMB hardware (eMMC) partition or RPMB
+W-LUN (UFS) with the RPMB layer :c:func:`rpmb_dev_register` providing
+an implementation for :c:func:`rpmb_seq_cmd()` handler. The interface
+enables sending sequence of RPMB standard frames.
+
+.. code-block:: c
+
+        struct rpmb_ops mmc_rpmb_dev_ops = {
+                .cmd_seq = mmc_blk_rpmb_cmd_seq,
+                .type = RPMB_TYPE_EMMC,
+                ...
+        }
+        rpmb_dev_register(disk_to_dev(part_md->disk), &mmc_rpmb_dev_ops);
+
+
+User space API
+--------------
+
+A parallel user space API is provided via /dev/rpmbX character
+device with two IOCTL commands.
+Simplified one, ``RPMB_IOC_REQ_CMD``, were read result cycles is performed
+by the framework on behalf the user and second, ``RPMB_IOC_SEQ_CMD`` where
+the whole RPMB sequence, including ``RESULT_READ`` is supplied by the caller.
+The latter is intended for easier adjusting of the applications that
+use ``MMC_IOC_MULTI_CMD`` ioctl, such as
+https://android.googlesource.com/trusty/app/storage/
+
+.. code-block:: c
+
+        struct rpmb_ioc_req_cmd ireq;
+        int ret;
+
+        ireq.req_type = RPMB_WRITE_DATA;
+        rpmb_ioc_cmd_set(ireq.icmd, RPMB_F_WRITE, frames_in, cnt_in);
+        rpmb_ioc_cmd_set(ireq.ocmd, 0, frames_out, cnt_out);
+
+        ret = ioctl(fd, RPMB_IOC_REQ_CMD, &ireq);
+
+
+API
+---
+.. kernel-doc:: include/linux/rpmb.h
+
+.. kernel-doc:: drivers/char/rpmb/core.c
+
+.. kernel-doc:: include/uapi/linux/rpmb.h
+
+.. kernel-doc:: drivers/char/rpmb/cdev.c
+
diff --git a/Documentation/rpmb/rpmb-tool.rst b/Documentation/rpmb/rpmb-tool.rst
new file mode 100644
index 000000000000..148eb0df4750
--- /dev/null
+++ b/Documentation/rpmb/rpmb-tool.rst
@@ -0,0 +1,19 @@
+==========
+RPMB Tool
+==========
+
+There is a sample rpmb tool under tools/rpmb/ directory that exercises
+the RPMB devices via RPMB character devices interface (/dev/rpmbX)
+
+.. code-block:: none
+
+        rpmb [-v] [-r|-s] <command> <args>
+
+        rpmb program-key [-<RPMB_DEVICE> <KEY_FILE>
+        rpmb write-counter <RPMB_DEVICE> [KEY_FILE]
+        rpmb write-blocks <RPMB_DEVICE> <address> <block_count> <DATA_FILE> <KEY_FILE>
+        rpmb read-blocks <RPMB_DEVICE> <address> <blocks count> <OUTPUT_FILE> [KEY_FILE]
+
+        rpmb -v/--verbose:  runs in verbose mode
+        rpmb -s/--sequence: use RPMB_IOC_SEQ_CMD
+        rpmb -r/--request:  use RPMB_IOC_REQ_CMD
diff --git a/Documentation/rpmb/simulation-device.rst b/Documentation/rpmb/simulation-device.rst
new file mode 100644
index 000000000000..9192a78a71d4
--- /dev/null
+++ b/Documentation/rpmb/simulation-device.rst
@@ -0,0 +1,19 @@
+======================
+RPMB Simulation Device
+======================
+
+RPMB partition simulation device is a virtual device that
+provides simulation of the RPMB protocol and uses kernel memory
+as storage.
+
+This driver cannot promise any real security, it is suitable for testing
+of the RPMB subsystem it self and mostly it was found useful for testing of
+RPMB applications prior to RPMB key provisioning/programming as
+The RPMB key programming can be performed only once in the life time
+of the storage device.
+
+Implementation:
+---------------
+
+.. kernel-doc:: drivers/char/rpmb/rpmb_sim.c
+
diff --git a/MAINTAINERS b/MAINTAINERS
index d9bca5134c7f..fa6f8017a05c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -10292,6 +10292,7 @@ F:	drivers/char/rpmb/*
 F:	include/uapi/linux/rpmb.h
 F:	include/linux/rpmb.h
 F:	Documentation/ABI/testing/sysfs-class-rpmb
+F:	Documentation/rpmb.rst
 F:	tools/rpmb/
 
 RTL2830 MEDIA DRIVER
-- 
2.7.4
