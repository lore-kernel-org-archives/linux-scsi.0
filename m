Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2694C4332D
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Mar 2021 00:31:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AA2CA60C3E
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Mar 2021 00:31:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377071AbhCDAb1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Mar 2021 19:31:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348597AbhCCN4R (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Mar 2021 08:56:17 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C29C6C0617A7
        for <linux-scsi@vger.kernel.org>; Wed,  3 Mar 2021 05:55:04 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id l12so23777044wry.2
        for <linux-scsi@vger.kernel.org>; Wed, 03 Mar 2021 05:55:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=aKhicD2UVcMDm5lK1Pq3TMyG5fu0FbWM9t04Rq8hGto=;
        b=XHHwLU1T/a//9Raf3vwCDjPBWaFDLZJvjv20JlCErT7HUGU0tJpyMzEuuIBW2X501f
         1scVeo/XlCtSKwMVIVDkthFPSi0DXpggbGEOBJJZ8k3d3+gwyunjOGEj5IuWa7Mk9Ecz
         /8ppOsxBFqmEE5eoge2ynak/MHzT6tO2Y92rHGQ6du8s8U2d0jKgXknaiDNkOygifD+e
         z9ZUi/7GbqxsaEXaq8nppxpCDHS8ecX9ON3fckTHILm/EqCcMvAtZ3pQLqeSF4tvOf2g
         SJxiak04NNIgdt45aE/tZxBGdrzS86KVxl+HHEoyQbf1D+VxoZlTQGIxnLTgeGuDy+K2
         YcSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aKhicD2UVcMDm5lK1Pq3TMyG5fu0FbWM9t04Rq8hGto=;
        b=rX57ZFrbUPbFqXLX0ceUSlyyTm7Wg7QcpkCY2lLUzhsQRGSlQPYZw6jhvO5YVOUXye
         gmt3t52wwooc/7MNpfTanaDZqoFRkzwZf9Eu/M7yaeusdUcMmFhXvtABLZoa9+Y0029i
         HbWXYtK7tfKOeDbYgtN333xCN1gKKULFPSyl0QlfYNt1G/eFaljXOKkufUnIae5zZcjt
         ZZ1b8e2OsOXVpqwhSe5noPZC7xBNFpEgM1FTQ7Jw07l3l1RfwOBZgr0gNV9q0h3FqFg+
         GYnEr7kIlaQo5fWeV627Ds8BeVz8rMGTZeEcgawI+GWVFeMVJaQ1opLaLSe7PDaK/fsJ
         dXJA==
X-Gm-Message-State: AOAM533j2fqvC5NwmQ8rx6cs/9fe5YbnAwudLBa62noPv3H/4Gv+1WWg
        C8Q5p/kU804uyimMJ+4WaqTshg==
X-Google-Smtp-Source: ABdhPJy0lZDVFRb97Pvu74TNTT2LLZ5U4Ih/Xev4AlKIfFfbgZb6wmFCAguYaJvM2nYhZAwdbKhHkA==
X-Received: by 2002:adf:8b5c:: with SMTP id v28mr26790300wra.272.1614779703367;
        Wed, 03 Mar 2021 05:55:03 -0800 (PST)
Received: from zen.linaroharston ([51.148.130.216])
        by smtp.gmail.com with ESMTPSA id j12sm4332801wrx.59.2021.03.03.05.55.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Mar 2021 05:55:01 -0800 (PST)
Received: from zen.lan (localhost [127.0.0.1])
        by zen.linaroharston (Postfix) with ESMTP id B81FF1FF8F;
        Wed,  3 Mar 2021 13:55:00 +0000 (GMT)
From:   =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To:     linux-kernel@vger.kernel.org
Cc:     maxim.uvarov@linaro.org, joakim.bech@linaro.org,
        ilias.apalodimas@linaro.org, arnd@linaro.org,
        ruchika.gupta@linaro.org, tomas.winkler@intel.com,
        yang.huang@intel.com, bing.zhu@intel.com,
        Matti.Moell@opensynergy.com, hmo@opensynergy.com,
        linux-mmc@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-nvme@vger.kernel.org,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        Alexander Usyskin <alexander.usyskin@intel.com>
Subject: [RFC PATCH  3/5] tools rpmb: add RPBM access tool
Date:   Wed,  3 Mar 2021 13:54:58 +0000
Message-Id: <20210303135500.24673-4-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210303135500.24673-1-alex.bennee@linaro.org>
References: <20210303135500.24673-1-alex.bennee@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Add simple RPMB host testing tool. It can be used to program key,
write and read data block, and retrieve write counter.

[AJB: the principle differences are a simpler ioctl API which doesn't
need to do the low level frame construction itself. It also uses the
kernel keychain API for managing the keys]

Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
Cc: Tomas Winkler <tomas.winkler@intel.com>
Cc: Alexander Usyskin <alexander.usyskin@intel.com>
---
 MAINTAINERS           |   1 +
 tools/Makefile        |  14 +-
 tools/rpmb/.gitignore |   2 +
 tools/rpmb/Makefile   |  41 +++
 tools/rpmb/rpmb.c     | 649 ++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 702 insertions(+), 5 deletions(-)
 create mode 100644 tools/rpmb/.gitignore
 create mode 100644 tools/rpmb/Makefile
 create mode 100644 tools/rpmb/rpmb.c

diff --git a/MAINTAINERS b/MAINTAINERS
index c60b41b6e6bd..8b0768b16eae 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -15376,6 +15376,7 @@ S:	Supported
 F:	drivers/char/rpmb/*
 F:	include/uapi/linux/rpmb.h
 F:	include/linux/rpmb.h
+F:	tools/rpmb/
 
 RTL2830 MEDIA DRIVER
 M:	Antti Palosaari <crope@iki.fi>
diff --git a/tools/Makefile b/tools/Makefile
index 85af6ebbce91..916ab8f8cefc 100644
--- a/tools/Makefile
+++ b/tools/Makefile
@@ -27,6 +27,7 @@ help:
 	@echo '  objtool                - an ELF object analysis tool'
 	@echo '  pci                    - PCI tools'
 	@echo '  perf                   - Linux performance measurement and analysis tool'
+	@echo '  rpmb                   - Replay protected memory block access tool'
 	@echo '  selftests              - various kernel selftests'
 	@echo '  bootconfig             - boot config tool'
 	@echo '  spi                    - spi tools'
@@ -64,7 +65,7 @@ acpi: FORCE
 cpupower: FORCE
 	$(call descend,power/$@)
 
-cgroup firewire hv guest bootconfig spi usb virtio vm bpf iio gpio objtool leds wmi pci firmware debugging: FORCE
+cgroup firewire hv guest bootconfig rpmb spi usb virtio vm bpf iio gpio objtool leds wmi pci firmware debugging: FORCE
 	$(call descend,$@)
 
 bpf/%: FORCE
@@ -100,7 +101,7 @@ kvm_stat: FORCE
 	$(call descend,kvm/$@)
 
 all: acpi cgroup cpupower gpio hv firewire liblockdep \
-		perf selftests bootconfig spi turbostat usb \
+		perf rpmb selftests bootconfig spi turbostat usb \
 		virtio vm bpf x86_energy_perf_policy \
 		tmon freefall iio objtool kvm_stat wmi \
 		pci debugging
@@ -111,7 +112,7 @@ acpi_install:
 cpupower_install:
 	$(call descend,power/$(@:_install=),install)
 
-cgroup_install firewire_install gpio_install hv_install iio_install perf_install bootconfig_install spi_install usb_install virtio_install vm_install bpf_install objtool_install wmi_install pci_install debugging_install:
+cgroup_install firewire_install gpio_install hv_install iio_install rpmb_install perf_install bootconfig_install spi_install usb_install virtio_install vm_install bpf_install objtool_install wmi_install pci_install debugging_install:
 	$(call descend,$(@:_install=),install)
 
 liblockdep_install:
@@ -134,7 +135,7 @@ kvm_stat_install:
 
 install: acpi_install cgroup_install cpupower_install gpio_install \
 		hv_install firewire_install iio_install liblockdep_install \
-		perf_install selftests_install turbostat_install usb_install \
+		perf_install rpmb_install selftests_install turbostat_install usb_install \
 		virtio_install vm_install bpf_install x86_energy_perf_policy_install \
 		tmon_install freefall_install objtool_install kvm_stat_install \
 		wmi_install pci_install debugging_install intel-speed-select_install
@@ -164,6 +165,9 @@ perf_clean:
 	$(Q)mkdir -p $(PERF_O) .
 	$(Q)$(MAKE) --no-print-directory -C perf O=$(PERF_O) subdir= clean
 
+rpmb_clean:
+	$(call descend,$(@:_clean=),clean)
+
 selftests_clean:
 	$(call descend,testing/$(@:_clean=),clean)
 
@@ -180,7 +184,7 @@ build_clean:
 	$(call descend,build,clean)
 
 clean: acpi_clean cgroup_clean cpupower_clean hv_clean firewire_clean \
-		perf_clean selftests_clean turbostat_clean bootconfig_clean spi_clean usb_clean virtio_clean \
+		perf_clean rpmb_clean selftests_clean turbostat_clean bootconfig_clean spi_clean usb_clean virtio_clean \
 		vm_clean bpf_clean iio_clean x86_energy_perf_policy_clean tmon_clean \
 		freefall_clean build_clean libbpf_clean libsubcmd_clean liblockdep_clean \
 		gpio_clean objtool_clean leds_clean wmi_clean pci_clean firmware_clean debugging_clean \
diff --git a/tools/rpmb/.gitignore b/tools/rpmb/.gitignore
new file mode 100644
index 000000000000..218f680548e6
--- /dev/null
+++ b/tools/rpmb/.gitignore
@@ -0,0 +1,2 @@
+*.o
+rpmb
diff --git a/tools/rpmb/Makefile b/tools/rpmb/Makefile
new file mode 100644
index 000000000000..3d49a94ffb66
--- /dev/null
+++ b/tools/rpmb/Makefile
@@ -0,0 +1,41 @@
+# SPDX-License-Identifier: GPL-2.0
+include ../scripts/Makefile.include
+
+CC ?= $(CROSS_COMPILE)gcc
+LD ?= $(CROSS_COMPILE)ld
+PKG_CONFIG = $(CROSS_COMPILE)pkg-config
+
+ifeq ($(srctree),)
+srctree := $(patsubst %/,%,$(dir $(shell pwd)))
+srctree := $(patsubst %/,%,$(dir $(srctree)))
+#$(info Determined 'srctree' to be $(srctree))
+endif
+
+INSTALL = install
+prefix ?= /usr/local
+bindir = $(prefix)/bin
+
+
+CFLAGS += $(HOSTCFLAGS)
+CFLAGS += -D__EXPORTED_HEADERS__
+CFLAGS += -Wall -Wextra -ggdb
+ifdef RPMB_STATIC
+LDFLAGS += -pthread -static -Wl,-u,pthread_mutex_unlock
+CFLAGS +=  -pthread -static
+PKG_STATIC = --static
+endif
+CFLAGS += -I$(srctree)/include/uapi -I$(srctree)/include
+LDLIBS += $(shell $(PKG_CONFIG) --libs $(PKG_STATIC) libkeyutils)
+
+prog := rpmb
+
+all : $(prog)
+
+$(prog): rpmb.o
+
+clean :
+	$(RM) $(prog) *.o
+
+install: $(prog)
+	$(INSTALL) -m755 -d $(DESTDIR)$(bindir)
+	$(INSTALL) $(prog) $(DESTDIR)$(bindir)
diff --git a/tools/rpmb/rpmb.c b/tools/rpmb/rpmb.c
new file mode 100644
index 000000000000..d5b85af14f94
--- /dev/null
+++ b/tools/rpmb/rpmb.c
@@ -0,0 +1,649 @@
+// SPDX-License-Identifier: BSD-3-Clause
+/*
+ * Copyright (C) 2016-2019 Intel Corp. All rights reserved
+ * Copyright (C) 2021 Linaro Ltd
+ */
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/ioctl.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <keyutils.h>
+#include <dirent.h>
+#include <sys/stat.h>
+#include <unistd.h>
+#include <fcntl.h>
+#include <libgen.h>
+#include <limits.h>
+#include <ctype.h>
+#include <errno.h>
+#include <stdint.h>
+#include <stdbool.h>
+
+#include "linux/rpmb.h"
+
+#define RPMB_KEY_SIZE 32
+#define RPMB_MAC_SIZE 32
+#define RPMB_NONCE_SIZE 16
+
+#define min(a,b)			\
+	({ __typeof__ (a) _a = (a);	\
+	   __typeof__ (b) _b = (b);	\
+		_a < _b ? _a : _b; })
+
+
+static bool verbose;
+#define rpmb_dbg(fmt, ARGS...) do {                     \
+	if (verbose)                                    \
+		fprintf(stderr, "rpmb: " fmt, ##ARGS);  \
+} while (0)
+
+#define rpmb_msg(fmt, ARGS...) \
+	fprintf(stderr, "rpmb: " fmt, ##ARGS)
+
+#define rpmb_err(fmt, ARGS...) \
+	fprintf(stderr, "rpmb: error: " fmt, ##ARGS)
+
+static int open_dev_file(const char *devfile, struct rpmb_ioc_cap_cmd *cap)
+{
+	struct rpmb_ioc_ver_cmd ver;
+	int fd;
+	int ret;
+
+	fd = open(devfile, O_RDWR);
+	if (fd < 0)
+		rpmb_err("Cannot open: %s: %s.\n", devfile, strerror(errno));
+
+	ret = ioctl(fd, RPMB_IOC_VER_CMD, &ver);
+	if (ret < 0) {
+		rpmb_err("ioctl failure %d: %s.\n", ret, strerror(errno));
+		goto err;
+	}
+
+	printf("RPMB API Version %X\n", ver.api_version);
+
+	ret = ioctl(fd, RPMB_IOC_CAP_CMD, cap);
+	if (ret < 0) {
+		rpmb_err("ioctl failure %d: %s.\n", ret, strerror(errno));
+		goto err;
+	}
+
+	rpmb_dbg("RPMB rpmb_target = %hd\n", cap->target);
+	rpmb_dbg("RPMB capacity    = %hd\n", cap->capacity);
+	rpmb_dbg("RPMB block_size  = %hd\n", cap->block_size);
+	rpmb_dbg("RPMB wr_cnt_max  = %hd\n", cap->wr_cnt_max);
+	rpmb_dbg("RPMB rd_cnt_max  = %hd\n", cap->rd_cnt_max);
+	rpmb_dbg("RPMB auth_method = %hd\n", cap->auth_method);
+
+	return fd;
+err:
+	close(fd);
+	return -1;
+}
+
+static int open_rd_file(const char *datafile, const char *type)
+{
+	int fd;
+
+	if (!strcmp(datafile, "-"))
+		fd = STDIN_FILENO;
+	else
+		fd = open(datafile, O_RDONLY);
+
+	if (fd < 0)
+		rpmb_err("Cannot open %s: %s: %s.\n",
+			 type, datafile, strerror(errno));
+
+	return fd;
+}
+
+static int open_wr_file(const char *datafile, const char *type)
+{
+	int fd;
+
+	if (!strcmp(datafile, "-"))
+		fd = STDOUT_FILENO;
+	else
+		fd = open(datafile, O_WRONLY | O_CREAT | O_APPEND, 0600);
+	if (fd < 0)
+		rpmb_err("Cannot open %s: %s: %s.\n",
+			 type, datafile, strerror(errno));
+	return fd;
+}
+
+static void close_fd(int fd)
+{
+	if (fd > 0 && fd != STDIN_FILENO && fd != STDOUT_FILENO)
+		close(fd);
+}
+
+/* need to just cast out 'const' in write(2) */
+typedef ssize_t (*rwfunc_t)(int fd, void *buf, size_t count);
+/* blocking rw wrapper */
+static ssize_t rw(rwfunc_t func, int fd, unsigned char *buf, size_t size)
+{
+	ssize_t ntotal = 0, n;
+	char *_buf = (char *)buf;
+
+	do {
+		n = func(fd, _buf + ntotal, size - ntotal);
+		if (n == -1 && errno != EINTR) {
+			ntotal = -1;
+			break;
+		} else if (n > 0) {
+			ntotal += n;
+		}
+	} while (n != 0 && (size_t)ntotal != size);
+
+	return ntotal;
+}
+
+static ssize_t read_file(int fd, unsigned char *data, size_t size)
+{
+	ssize_t ret;
+
+	ret = rw(read, fd, data, size);
+	if (ret < 0) {
+		rpmb_err("cannot read file: %s\n.", strerror(errno));
+	} else if ((size_t)ret != size) {
+		rpmb_err("read %zd but must be %zu bytes length.\n", ret, size);
+		ret = -EINVAL;
+	}
+
+	return ret;
+}
+
+static ssize_t write_file(int fd, unsigned char *data, size_t size)
+{
+	ssize_t ret;
+
+	ret = rw((rwfunc_t)write, fd, data, size);
+	if (ret < 0) {
+		rpmb_err("cannot read file: %s.\n", strerror(errno));
+	} else if ((size_t)ret != size) {
+		rpmb_err("data is %zd but must be %zu bytes length.\n",
+			 ret, size);
+		ret = -EINVAL;
+	}
+	return ret;
+}
+
+static int op_get_info(int nargs, char *argv[])
+{
+	int dev_fd;
+	struct rpmb_ioc_cap_cmd cap;
+
+	if (nargs != 1)
+		return -EINVAL;
+
+	memset(&cap, 0, sizeof(cap));
+	dev_fd = open_dev_file(argv[0], &cap);
+	if (dev_fd < 0)
+		return -errno;
+	argv++;
+
+	printf("RPMB rpmb_target = %hd\n", cap.target);
+	printf("RPMB capacity    = %hd\n", cap.capacity);
+	printf("RPMB block_size  = %hd\n", cap.block_size);
+	printf("RPMB wr_cnt_max  = %hd\n", cap.wr_cnt_max);
+	printf("RPMB rd_cnt_max  = %hd\n", cap.rd_cnt_max);
+	printf("RPMB auth_method = %hd\n", cap.auth_method);
+
+	close(dev_fd);
+
+	return 0;
+}
+
+static int op_rpmb_add_key(int nargs, char *argv[])
+{
+	int key_fd, ret = -EINVAL;
+	unsigned char key_data[RPMB_KEY_SIZE];
+	key_serial_t key;
+
+	if (nargs != 1)
+		return -EINVAL;
+
+	key_fd = open_rd_file(argv[0], "key file");
+	if (key_fd < 0) {
+		perror("opening key file");
+		return ret;
+	}
+
+	if (read_file(key_fd, key_data, RPMB_KEY_SIZE) != RPMB_KEY_SIZE)
+	{
+		perror("reading key file");
+		return ret;
+	}
+
+	key = add_key("user", "RPMB MAC", key_data, RPMB_KEY_SIZE,
+		      KEY_SPEC_SESSION_KEYRING);
+
+	if (key == -1) {
+		perror("add_key");
+		return ret;
+	}
+
+	printf("Key ID is %jx\n", (uintmax_t) key);
+
+	return 0;
+}
+
+static key_serial_t get_key(char *keyid) {
+	key_serial_t key = -1;
+
+	if (keyid) {
+		if (sscanf(keyid, "%jx", (uintmax_t *) &key) != 1)
+			perror("reading keyid");
+	} else {
+		key = request_key("user", "RPMB MAC", NULL,
+				  KEY_SPEC_SESSION_KEYRING);
+	}
+	return key;
+}
+
+static int op_rpmb_program_key(int nargs, char *argv[])
+{
+	int ret, fd = -1;
+	key_serial_t key;
+	struct rpmb_ioc_cap_cmd cap;
+
+	ret = -EINVAL;
+	if (nargs < 1 || nargs > 2)
+		return ret;
+
+	fd = open_dev_file(argv[0], &cap);
+	if (fd < 0) {
+		perror("opening RPMB device");
+		return ret;
+	}
+	argv++;
+
+	key = get_key(nargs == 2 ? argv[0] : NULL);
+	if (key == -1)
+		goto out;
+
+	ret = ioctl(fd, RPMB_IOC_PKEY_CMD, &key);
+	if (ret < 0) {
+		rpmb_err("pkey ioctl failure %d: %s.\n", ret, strerror(errno));
+	}
+
+out:
+	close_fd(fd);
+	return ret;
+}
+
+
+static int op_rpmb_get_write_counter(int nargs, char **argv)
+{
+	int ret, fd = -1;
+	unsigned int counter;
+	struct rpmb_ioc_cap_cmd cap;
+
+	ret = -EINVAL;
+	if (nargs != 1)
+		return ret;
+
+	fd = open_dev_file(argv[0], &cap);
+	if (fd < 0) {
+		perror("opening RPMB device");
+		return ret;
+	}
+
+	ret = ioctl(fd, RPMB_IOC_COUNTER_CMD, &counter);
+	if (ret < 0) {
+		rpmb_err("counter ioctl failure %d: %s.\n", ret, strerror(errno));
+	}
+
+	printf("Counter value is: %ud\n", counter);
+
+	close_fd(fd);
+	return ret;
+}
+
+static int op_rpmb_read_blocks(int nargs, char **argv)
+{
+	int ret, data_fd, fd = -1;
+	struct rpmb_ioc_cap_cmd cap;
+	unsigned long numarg;
+	uint16_t addr, blocks_cnt;
+
+	ret = -EINVAL;
+	if (nargs != 4)
+		return ret;
+
+	fd = open_dev_file(argv[0], &cap);
+	if (fd < 0) {
+		perror("opening RPMB device");
+		return ret;
+	}
+	argv++;
+
+	errno = 0;
+	numarg = strtoul(argv[0], NULL, 0);
+	if (errno || numarg > USHRT_MAX) {
+		rpmb_err("wrong block address\n");
+		goto out;
+	}
+	addr = (uint16_t)numarg;
+	argv++;
+
+	errno = 0;
+	numarg = strtoul(argv[0], NULL, 0);
+	if (errno || numarg > USHRT_MAX) {
+		rpmb_err("wrong blocks count\n");
+		goto out;
+	}
+	blocks_cnt = (uint16_t)numarg;
+	argv++;
+
+	if (blocks_cnt == 0) {
+		rpmb_err("wrong blocks count\n");
+		goto out;
+	}
+
+	data_fd = open_wr_file(argv[0], "output data");
+	if (data_fd < 0)
+		goto out;
+	argv++;
+
+	while (blocks_cnt > 0) {
+		int to_copy = min(blocks_cnt, cap.rd_cnt_max);
+		int length = to_copy * 256;
+		void *data = malloc(length);
+		struct rpmb_ioc_blocks_cmd cmd;
+		if (!data) {
+			ret = ENOMEM;
+			goto out;
+		}
+		cmd.addr = addr;
+		cmd.count = to_copy;
+		cmd.data = data;
+
+		ret = ioctl(fd, RPMB_IOC_RBLOCKS_CMD, &cmd);
+		if (ret < 0) {
+			rpmb_err("rblocks ioctl failure %d: %s.\n", ret,
+				 strerror(errno));
+			goto out;
+		}
+
+		ret = write_file(data_fd, data, length);
+		if (ret < 0) {
+			perror("writing data");
+			goto out;
+		}
+
+		free(data);
+		addr += to_copy;
+		blocks_cnt -= to_copy;
+	}
+
+	ret = 0;
+out:
+	close_fd(fd);
+	close_fd(data_fd);
+
+	return ret;
+}
+
+static int op_rpmb_write_blocks(int nargs, char **argv)
+{
+	int ret, data_fd, fd = -1;
+	struct rpmb_ioc_cap_cmd cap;
+	unsigned long numarg;
+	uint16_t addr, blocks_cnt;
+	key_serial_t key;
+
+	ret = -EINVAL;
+	if (nargs < 4 || nargs > 5)
+		return ret;
+
+	fd = open_dev_file(argv[0], &cap);
+	if (fd < 0) {
+		perror("opening RPMB device");
+		return ret;
+	}
+	argv++;
+
+	errno = 0;
+	numarg = strtoul(argv[0], NULL, 0);
+	if (errno || numarg > USHRT_MAX) {
+		rpmb_err("wrong block address\n");
+		goto out;
+	}
+	addr = (uint16_t)numarg;
+	argv++;
+
+	errno = 0;
+	numarg = strtoul(argv[0], NULL, 0);
+	if (errno || numarg > USHRT_MAX) {
+		rpmb_err("wrong blocks count\n");
+		goto out;
+	}
+	blocks_cnt = (uint16_t)numarg;
+	argv++;
+
+	if (blocks_cnt == 0) {
+		rpmb_err("wrong blocks count\n");
+		goto out;
+	}
+
+	data_fd = open_wr_file(argv[0], "input data");
+	if (data_fd < 0)
+		goto out;
+	argv++;
+
+	key = get_key(nargs == 5 ? argv[0] : NULL);
+	if (key == -1)
+		goto out;
+
+	while (blocks_cnt > 0) {
+		int to_copy = min(blocks_cnt, cap.wr_cnt_max);
+		int length = to_copy * 256;
+		void *data = malloc(length);
+		struct rpmb_ioc_blocks_cmd cmd;
+		if (!data) {
+			ret = ENOMEM;
+			goto out;
+		}
+		cmd.key =
+		cmd.addr = addr;
+		cmd.count = to_copy;
+		cmd.data = data;
+
+		ret = read_file(data_fd, data, length);
+		if (ret < 0) {
+			perror("reading data");
+			goto out;
+		}
+
+		ret = ioctl(fd, RPMB_IOC_WBLOCKS_CMD, &cmd);
+		if (ret < 0) {
+			rpmb_err("wblocks ioctl failure %d: %s.\n", ret,
+				 strerror(errno));
+			goto out;
+		}
+
+		free(data);
+		addr += to_copy;
+		blocks_cnt -= to_copy;
+	}
+
+	ret = 0;
+out:
+	close_fd(fd);
+	close_fd(data_fd);
+
+	return ret;
+}
+
+typedef int (*rpmb_op)(int argc, char *argv[]);
+
+struct rpmb_cmd {
+	const char *op_name;
+	rpmb_op     op;
+	const char  *usage; /* usage title */
+	const char  *help;  /* help */
+};
+
+static const struct rpmb_cmd cmds[] = {
+	{
+		"get-info",
+		op_get_info,
+		"<RPMB_DEVICE>",
+		"    Get RPMB device info\n",
+	},
+	{
+		"add-key",
+		op_rpmb_add_key,
+		"<KEY_FILE>",
+		"    Load a 32 byte KEY_FILE into the session keyring.\n"
+		"    Returns a KEYID to use in future transactions.",
+	},
+	{
+		"program-key",
+		op_rpmb_program_key,
+		"<RPMB_DEVICE> <KEYID>",
+		"    Program authentication KEYID\n"
+		"    NOTE: This is a one-time programmable irreversible change.\n",
+	},
+	{
+		"write-counter",
+		op_rpmb_get_write_counter,
+		"<RPMB_DEVICE>",
+		"    Rertrive write counter value from the <RPMB_DEVICE> to stdout.\n"
+	},
+	{
+		"write-blocks",
+		op_rpmb_write_blocks,
+		"<RPMB_DEVICE> <address> <block_count> <DATA_FILE> <KEYID>",
+		"    <block count> of 256 bytes will be written from the DATA_FILE\n"
+		"    to the <RPMB_DEVICE> at block offset <address>.\n"
+		"    When DATA_FILE is -, read from standard input.\n",
+	},
+	{
+		"read-blocks",
+		op_rpmb_read_blocks,
+		"<RPMB_DEVICE> <address> <blocks count> <OUTPUT_FILE>",
+		"    <block count> of 256 bytes will be read from <RPMB_DEVICE>\n"
+		"    to the OUTPUT_FILE\n"
+		"    When OUTPUT_FILE is -, write to standard output\n",
+	},
+
+	{ NULL, NULL, NULL, NULL }
+};
+
+static void help(const char *prog, const struct rpmb_cmd *cmd)
+{
+	printf("%s %s %s\n", prog, cmd->op_name, cmd->usage);
+	printf("%s\n", cmd->help);
+}
+
+static void usage(const char *prog)
+{
+	int i;
+
+	printf("\n");
+	printf("Usage: %s [-v] <command> <args>\n\n", prog);
+	for (i = 0; cmds[i].op_name; i++)
+		printf("       %s %s %s\n",
+		       prog, cmds[i].op_name, cmds[i].usage);
+
+	printf("\n");
+	printf("      %s -v/--verbose: runs in verbose mode\n", prog);
+	printf("      %s help : shows this help\n", prog);
+	printf("      %s help <command>: shows detailed help\n", prog);
+}
+
+static bool call_for_help(const char *arg)
+{
+	return !strcmp(arg, "help") ||
+	       !strcmp(arg, "-h")   ||
+	       !strcmp(arg, "--help");
+}
+
+static bool parse_verbose(const char *arg)
+{
+	return !strcmp(arg, "-v") ||
+	       !strcmp(arg, "--verbose");
+}
+
+static const
+struct rpmb_cmd *parse_args(const char *prog, int *_argc, char **_argv[])
+{
+	int i;
+	int argc = *_argc;
+	char **argv =  *_argv;
+	const struct rpmb_cmd *cmd = NULL;
+	bool need_help = false;
+
+	argc--; argv++;
+
+	if (argc == 0)
+		goto out;
+
+	if (call_for_help(argv[0])) {
+		argc--; argv++;
+		if (argc == 0)
+			goto out;
+
+		need_help = true;
+	}
+
+	if (parse_verbose(argv[0])) {
+		argc--; argv++;
+		if (argc == 0)
+			goto out;
+
+		verbose = true;
+	}
+
+	for (i = 0; cmds[i].op_name; i++) {
+		if (!strncmp(argv[0], cmds[i].op_name,
+			     strlen(cmds[i].op_name))) {
+			cmd = &cmds[i];
+			argc--; argv++;
+			break;
+		}
+	}
+
+	if (!cmd)
+		goto out;
+
+	if (need_help || (argc > 0 && call_for_help(argv[0]))) {
+		help(prog, cmd);
+		argc--; argv++;
+		return NULL;
+	}
+
+out:
+	*_argc = argc;
+	*_argv = argv;
+
+	if (!cmd)
+		usage(prog);
+
+	return cmd;
+}
+
+int main(int argc, char *argv[])
+{
+	const char *prog = basename(argv[0]);
+	const struct rpmb_cmd *cmd;
+	int ret;
+
+	cmd = parse_args(prog, &argc, &argv);
+	if (!cmd)
+		exit(EXIT_SUCCESS);
+
+	ret = cmd->op(argc, argv);
+	if (ret == -EINVAL)
+		help(prog, cmd);
+
+	if (ret) {
+		exit(EXIT_FAILURE);
+	}
+
+	exit(EXIT_SUCCESS);
+}
-- 
2.20.1

