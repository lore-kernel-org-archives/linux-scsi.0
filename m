Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0D9B35E92B
	for <linux-scsi@vger.kernel.org>; Mon, 31 Aug 2026 17:58:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788199140; cv=none; b=kl5fFnRjl0e6rOIrOssC8hJxDz+wd5DMK4OCX1+INjAyrSqqS96VEU1QGCwWYV1ITvTJdViPNq6vTxKlXLlC2pBYF0IbGg9u4tto6IHKsgzeVIaMe4/suQWpLwF78OQb38YqRgj9KEBU5yC7AdtyoLLxqSLi3IGDG4go9lAy4uc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788199140; c=relaxed/simple;
	bh=fPrGZYmBaOdl5Nw+vhvdZpDTVYiG2dh8dN+nBnnVcHI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ISocaWL1C9R9exoGzpYDGHcOadIq5sxEI6aGEMzDInttkt4bQnrC2q7KCo5849vwm358sqnrsI8kHuHrCCxIhvrsbyaLCrsSADPojFrkNMa5Xlgr6+25OD/4Zei3p57ay8EsYPiEwoIhRVteiHqQp0Ozpu9FQyFaXhVBUqex36Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=a2xOsbBx; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="a2xOsbBx"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4hYcDx2N9xz1XM6JZ;
	Mon, 31 Aug 2026 17:58:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1788199122; x=1790791123; bh=M9O9H
	cPiybtfSRK9irwkl99HPfQCGzFykv7qjRSLsmQ=; b=a2xOsbBxYk9UHiQr4BYS4
	liDX1fiI+6LWVJ1Mx83xVLlCOohMgLBIumaoacgMs8faL/6MbEpPNeEprnabWbY+
	oLNUbKxZXr8kyWn1eFOSCr+0c5RnZbFREjV2kAF2suNZGHtidtW0EIWtX6grq0s+
	cA92Wur6aJqItyIOqhYC5+m202DShullN1UE0EeiQqnlRxeVVS2aNjP4v7HVZ1lw
	oqb3JNUznLsSlrcyo15I4+KxwVdAWGQ5+6Pob9gxVmff4ohDtQfhBfjeVE6mZm8x
	VpGHrI34lY74UojzVzMIvXzYrvWwJ6dnluyBau1s13IvBlSFaAem9dL5ULu421yP
	Q==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 8SFMTdiDP3LU; Mon, 31 Aug 2026 17:58:42 +0000 (UTC)
Received: from bvanassche.c.googlers.com.com (148.60.168.34.bc.googleusercontent.com [34.168.60.148])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4hYcDc2T8xz1XM0p5;
	Mon, 31 Aug 2026 17:58:39 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	John Garry <john.g.garry@oracle.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Subject: [PATCH v2 1/2] scsi: core: Add KUnit tests for scsi_logging.c
Date: Mon, 31 Aug 2026 10:58:18 -0700
Message-ID: <ae3eb010e5f6b4451c6e18cae3ae152d45fe2d95.1788198780.git.bvanassche@acm.org>
X-Mailer: git-send-email 2.55.0.897.gb25b4bd76c-goog
In-Reply-To: <cover.1788198780.git.bvanassche@acm.org>
References: <cover.1788198780.git.bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Add regression unit tests for the functions in drivers/scsi/scsi_logging.=
c
that call dev_printk().

Implement a macro redefinition approach where dev_printk() is intercepted
when CONFIG_SCSI_LOGGING_KUNIT_TEST is enabled, allowing the test suite t=
o
capture the emitted log levels, target device references, and formatted
log strings into a test buffer without side effects.

Add test cases covering:
 - sdev_prefix_printk() with and without device name prefix.
 - scmd_printk() with tag only, disk name and tag, and untagged commands.
 - scsi_print_command() with 6, 10, 16, and multi-line 32-byte CDBs,
   as well as vendor-specific and reserved opcodes.
 - scsi_print_sense_hdr() with standard, descriptor, and deferred formats=
.
 - __scsi_print_sense() with normalized sense data and raw hex dumps.
 - scsi_print_sense() with command-attached sense buffers.
 - scsi_print_result() with custom messages, default messages, unknown
   dispositions, and unknown hostbyte statuses.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/Kconfig             |   9 +
 drivers/scsi/scsi_logging.c      |  30 +++
 drivers/scsi/scsi_logging_test.c | 422 +++++++++++++++++++++++++++++++
 3 files changed, 461 insertions(+)
 create mode 100644 drivers/scsi/scsi_logging_test.c

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 4a2af0f702e1..8c2a44b55900 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -76,6 +76,15 @@ config SCSI_LIB_KUNIT_TEST
=20
 	  If unsure say N.
=20
+config SCSI_LOGGING_KUNIT_TEST
+	bool "KUnit tests for SCSI logging functions" if !KUNIT_ALL_TESTS
+	depends on SCSI && KUNIT=3Dy && SCSI_CONSTANTS
+	default KUNIT_ALL_TESTS
+	help
+	  Run SCSI Mid Layer's KUnit tests for scsi_logging.
+
+	  If unsure say N.
+
 comment "SCSI support type (disk, tape, CD-ROM)"
 	depends on SCSI
=20
diff --git a/drivers/scsi/scsi_logging.c b/drivers/scsi/scsi_logging.c
index 3cd0d3074085..3bff4dea4c6a 100644
--- a/drivers/scsi/scsi_logging.c
+++ b/drivers/scsi/scsi_logging.c
@@ -15,6 +15,32 @@
 #include <scsi/scsi_eh.h>
 #include <scsi/scsi_dbg.h>
=20
+#if IS_ENABLED(CONFIG_SCSI_LOGGING_KUNIT_TEST)
+static void (*scsi_logging_test_dev_printk)(const char *level,
+					    const struct device *dev,
+					    const char *fmt, va_list args);
+
+static void scsi_logging_dev_printk(const char *level, const struct devi=
ce *dev,
+				    const char *fmt, ...)
+{
+	va_list args;
+
+	va_start(args, fmt);
+	if (unlikely(scsi_logging_test_dev_printk)) {
+		scsi_logging_test_dev_printk(level, dev, fmt, args);
+	} else {
+		struct va_format vaf =3D { .fmt =3D fmt, .va =3D &args };
+
+		_dev_printk(level, dev, "%pV", &vaf);
+	}
+	va_end(args);
+}
+
+#undef dev_printk
+#define dev_printk(level, dev, fmt, ...) \
+	scsi_logging_dev_printk(level, dev, fmt, ##__VA_ARGS__)
+#endif
+
 static char *scsi_log_reserve_buffer(size_t *len)
 {
 	*len =3D 128;
@@ -436,3 +462,7 @@ void scsi_print_result(struct scsi_cmnd *cmd, const c=
har *msg, int disposition)
 	scsi_log_release_buffer(logbuf);
 }
 EXPORT_SYMBOL(scsi_print_result);
+
+#if IS_ENABLED(CONFIG_SCSI_LOGGING_KUNIT_TEST)
+#include "scsi_logging_test.c"
+#endif
diff --git a/drivers/scsi/scsi_logging_test.c b/drivers/scsi/scsi_logging=
_test.c
new file mode 100644
index 000000000000..1dcebc383052
--- /dev/null
+++ b/drivers/scsi/scsi_logging_test.c
@@ -0,0 +1,422 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * KUnit tests for scsi_logging.c.
+ *
+ * Copyright 2026 Google LLC
+ */
+#include <kunit/test.h>
+#include <linux/blkdev.h>
+#include <scsi/scsi.h>
+#include <scsi/scsi_cmnd.h>
+#include <scsi/scsi_dbg.h>
+#include <scsi/scsi_device.h>
+#include <scsi/scsi_eh.h>
+#include <scsi/scsi_proto.h>
+
+#define MAX_CAPTURED_LINES 16
+#define MAX_LINE_LEN 256
+
+struct captured_dev_printk {
+	const char *level;
+	const struct device *dev;
+	char msg[MAX_LINE_LEN];
+};
+
+static struct captured_dev_printk captured_logs[MAX_CAPTURED_LINES];
+static int captured_count;
+
+static void test_capture_dev_printk(const char *level, const struct devi=
ce *dev,
+				    const char *fmt, va_list args)
+{
+	if (captured_count < MAX_CAPTURED_LINES) {
+		captured_logs[captured_count].level =3D level;
+		captured_logs[captured_count].dev =3D dev;
+		vscnprintf(captured_logs[captured_count].msg,
+			   sizeof(captured_logs[captured_count].msg), fmt,
+			   args);
+		captured_count++;
+	}
+}
+
+static void scsi_logging_test_reset(void)
+{
+	captured_count =3D 0;
+	memset(captured_logs, 0, sizeof(captured_logs));
+}
+
+static int scsi_logging_test_init(struct kunit *test)
+{
+	scsi_logging_test_reset();
+	scsi_logging_test_dev_printk =3D test_capture_dev_printk;
+	return 0;
+}
+
+static void scsi_logging_test_exit(struct kunit *test)
+{
+	scsi_logging_test_dev_printk =3D NULL;
+}
+
+struct test_scsi_cmd {
+	struct request rq;
+	struct scsi_cmnd cmd;
+};
+
+struct test_fixture {
+	struct scsi_device *sdev;
+	struct gendisk *disk;
+	struct request_queue *q;
+	struct test_scsi_cmd *tscmd;
+};
+
+static struct test_fixture *scsi_logging_create_fixture(struct kunit *te=
st)
+{
+	struct test_fixture *tf =3D kunit_kzalloc(test, sizeof(*tf), GFP_KERNEL=
);
+
+	KUNIT_ASSERT_NOT_NULL(test, tf);
+
+	tf->sdev =3D kunit_kzalloc(test, sizeof(*tf->sdev), GFP_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test, tf->sdev);
+
+	tf->disk =3D kunit_kzalloc(test, sizeof(*tf->disk), GFP_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test, tf->disk);
+
+	tf->q =3D kunit_kzalloc(test, sizeof(*tf->q), GFP_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test, tf->q);
+
+	tf->tscmd =3D kunit_kzalloc(test, sizeof(*tf->tscmd), GFP_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test, tf->tscmd);
+
+	tf->q->disk =3D tf->disk;
+	tf->tscmd->cmd.device =3D tf->sdev;
+	strscpy(tf->disk->disk_name, "sda", sizeof(tf->disk->disk_name));
+
+	return tf;
+}
+
+static void test_sdev_prefix_printk(struct kunit *test)
+{
+	struct test_fixture *tf =3D scsi_logging_create_fixture(test);
+
+	/* NULL sdev should produce no output */
+	sdev_prefix_printk(KERN_INFO, NULL, "test", "should not print");
+	KUNIT_EXPECT_EQ(test, captured_count, 0);
+
+	/* Without name prefix */
+	sdev_prefix_printk(KERN_WARNING, tf->sdev, NULL, "warning %d", 42);
+	KUNIT_EXPECT_EQ(test, captured_count, 1);
+	KUNIT_EXPECT_STREQ(test, captured_logs[0].level, KERN_WARNING);
+	KUNIT_EXPECT_PTR_EQ(test, captured_logs[0].dev, &tf->sdev->sdev_gendev)=
;
+	KUNIT_EXPECT_STREQ(test, captured_logs[0].msg, "warning 42");
+
+	/* With name prefix */
+	scsi_logging_test_reset();
+	sdev_prefix_printk(KERN_ERR, tf->sdev, "adapter0", "error code %d", -5)=
;
+	KUNIT_EXPECT_EQ(test, captured_count, 1);
+	KUNIT_EXPECT_STREQ(test, captured_logs[0].level, KERN_ERR);
+	KUNIT_EXPECT_PTR_EQ(test, captured_logs[0].dev, &tf->sdev->sdev_gendev)=
;
+	KUNIT_EXPECT_STREQ(test, captured_logs[0].msg,
+			   "[adapter0] error code -5");
+}
+
+static void test_scmd_printk(struct kunit *test)
+{
+	struct test_fixture *tf =3D scsi_logging_create_fixture(test);
+
+	/* NULL scmd should produce no output */
+	scmd_printk(KERN_INFO, NULL, "should not print");
+	KUNIT_EXPECT_EQ(test, captured_count, 0);
+
+	/* scmd with tag but no disk name */
+	tf->tscmd->rq.q =3D NULL;
+	tf->tscmd->rq.tag =3D 5;
+	scmd_printk(KERN_INFO, &tf->tscmd->cmd, "test msg %d", 10);
+	KUNIT_EXPECT_EQ(test, captured_count, 1);
+	KUNIT_EXPECT_STREQ(test, captured_logs[0].level, KERN_INFO);
+	KUNIT_EXPECT_PTR_EQ(test, captured_logs[0].dev, &tf->sdev->sdev_gendev)=
;
+	KUNIT_EXPECT_STREQ(test, captured_logs[0].msg, "tag#5 test msg 10");
+
+	/* scmd with disk name and tag */
+	scsi_logging_test_reset();
+	tf->tscmd->rq.q =3D tf->q;
+	tf->tscmd->rq.tag =3D 12;
+	scmd_printk(KERN_ERR, &tf->tscmd->cmd, "failed status");
+	KUNIT_EXPECT_EQ(test, captured_count, 1);
+	KUNIT_EXPECT_STREQ(test, captured_logs[0].level, KERN_ERR);
+	KUNIT_EXPECT_STREQ(test, captured_logs[0].msg,
+			   "[sda] tag#12 failed status");
+
+	/* scmd with disk name but no tag (tag < 0) */
+	scsi_logging_test_reset();
+	tf->tscmd->rq.tag =3D -1;
+	scmd_printk(KERN_NOTICE, &tf->tscmd->cmd, "no tag notification");
+	KUNIT_EXPECT_EQ(test, captured_count, 1);
+	KUNIT_EXPECT_STREQ(test, captured_logs[0].msg,
+			   "[sda] no tag notification");
+}
+
+static void test_scsi_print_command(struct kunit *test)
+{
+	struct test_fixture *tf =3D scsi_logging_create_fixture(test);
+	static const unsigned char cdb6[6] =3D { 0x00, 0x00, 0x00,
+					       0x00, 0x00, 0x00 };
+	static const unsigned char cdb10[10] =3D { 0x28, 0x00, 0x00, 0x00, 0x00=
,
+						 0x00, 0x00, 0x00, 0x08, 0x00 };
+	static const unsigned char cdb16[16] =3D { 0x88, 0x00, 0x00, 0x00,
+						 0x00, 0x00, 0x00, 0x00,
+						 0x00, 0x00, 0x00, 0x00,
+						 0x00, 0x00, 0x08, 0x00 };
+	static const unsigned char cdb32[32] =3D {
+		0x7f, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x18,
+		0x00, 0x09, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+		0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+		0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x08, 0x00
+	};
+	static const unsigned char cdb_vendor[6] =3D { 0xc0, 0x00, 0x00,
+						     0x00, 0x00, 0x00 };
+	static const unsigned char cdb_reserved[6] =3D { 0x60, 0x00, 0x00,
+						       0x00, 0x00, 0x00 };
+
+	tf->tscmd->rq.q =3D tf->q;
+	tf->tscmd->rq.tag =3D 1;
+
+	/* 6-byte TEST UNIT READY */
+	memcpy(tf->tscmd->cmd.cmnd, cdb6, sizeof(cdb6));
+	tf->tscmd->cmd.cmd_len =3D sizeof(cdb6);
+	scsi_print_command(&tf->tscmd->cmd);
+	KUNIT_EXPECT_EQ(test, captured_count, 1);
+	KUNIT_EXPECT_STREQ(
+		test, captured_logs[0].msg,
+		"[sda] tag#1 CDB: Test Unit Ready 00 00 00 00 00 00");
+
+	/* 10-byte READ(10) */
+	scsi_logging_test_reset();
+	memcpy(tf->tscmd->cmd.cmnd, cdb10, sizeof(cdb10));
+	tf->tscmd->cmd.cmd_len =3D sizeof(cdb10);
+	scsi_print_command(&tf->tscmd->cmd);
+	KUNIT_EXPECT_EQ(test, captured_count, 1);
+	KUNIT_EXPECT_STREQ(
+		test, captured_logs[0].msg,
+		"[sda] tag#1 CDB: Read(10) 28 00 00 00 00 00 00 00 08 00");
+
+	/* 16-byte READ(16) */
+	scsi_logging_test_reset();
+	memcpy(tf->tscmd->cmd.cmnd, cdb16, sizeof(cdb16));
+	tf->tscmd->cmd.cmd_len =3D sizeof(cdb16);
+	scsi_print_command(&tf->tscmd->cmd);
+	KUNIT_EXPECT_EQ(test, captured_count, 1);
+	KUNIT_EXPECT_STREQ(
+		test, captured_logs[0].msg,
+		"[sda] tag#1 CDB: Read(16) 88 00 00 00 00 00 00 00 00 00 00 00 00 00 0=
8 00");
+
+	/* 32-byte CDB (CDB len > 16 generates multiple printk lines) */
+	scsi_logging_test_reset();
+	memcpy(tf->tscmd->cmd.cmnd, cdb32, sizeof(cdb32));
+	tf->tscmd->cmd.cmd_len =3D sizeof(cdb32);
+	scsi_print_command(&tf->tscmd->cmd);
+	KUNIT_EXPECT_EQ(test, captured_count, 3);
+	KUNIT_EXPECT_STREQ(test, captured_logs[0].msg,
+			   "[sda] tag#1 CDB: Read(32)\n");
+	KUNIT_EXPECT_STREQ(
+		test, captured_logs[1].msg,
+		"[sda] tag#1 CDB[00]: 7f 00 00 00 00 00 00 18 00 09 00 00 00 00 00 00"=
);
+	KUNIT_EXPECT_STREQ(
+		test, captured_logs[2].msg,
+		"[sda] tag#1 CDB[10]: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 08 00"=
);
+
+	/* Vendor-specific opcode */
+	scsi_logging_test_reset();
+	memcpy(tf->tscmd->cmd.cmnd, cdb_vendor, sizeof(cdb_vendor));
+	tf->tscmd->cmd.cmd_len =3D sizeof(cdb_vendor);
+	scsi_print_command(&tf->tscmd->cmd);
+	KUNIT_EXPECT_EQ(test, captured_count, 1);
+	KUNIT_EXPECT_STREQ(
+		test, captured_logs[0].msg,
+		"[sda] tag#1 CDB: opcode=3D0xc0 (vendor) c0 00 00 00 00 00");
+
+	/* Reserved opcode */
+	scsi_logging_test_reset();
+	memcpy(tf->tscmd->cmd.cmnd, cdb_reserved, sizeof(cdb_reserved));
+	tf->tscmd->cmd.cmd_len =3D sizeof(cdb_reserved);
+	scsi_print_command(&tf->tscmd->cmd);
+	KUNIT_EXPECT_EQ(test, captured_count, 1);
+	KUNIT_EXPECT_STREQ(
+		test, captured_logs[0].msg,
+		"[sda] tag#1 CDB: opcode=3D0x60 (reserved) 60 00 00 00 00 00");
+}
+
+static void test_scsi_print_sense_hdr(struct kunit *test)
+{
+	struct test_fixture *tf =3D scsi_logging_create_fixture(test);
+	struct scsi_sense_hdr sshdr =3D {
+		.response_code =3D 0x70,
+		.sense_key =3D ILLEGAL_REQUEST,
+		.asc =3D 0x20,
+		.ascq =3D 0x00,
+	};
+
+	scsi_print_sense_hdr(tf->sdev, "sda", &sshdr);
+	KUNIT_EXPECT_EQ(test, captured_count, 2);
+	KUNIT_EXPECT_STREQ(test, captured_logs[0].msg,
+			   "[sda] Sense Key : Illegal Request [current] ");
+	KUNIT_EXPECT_STREQ(test, captured_logs[1].msg,
+			   "[sda] Add. Sense: Invalid command operation code");
+
+	/* Deferred and descriptor format */
+	scsi_logging_test_reset();
+	sshdr.response_code =3D 0x73;
+	sshdr.sense_key =3D UNIT_ATTENTION;
+	sshdr.asc =3D 0x29;
+	sshdr.ascq =3D 0x00;
+	scsi_print_sense_hdr(tf->sdev, "sdb", &sshdr);
+	KUNIT_EXPECT_EQ(test, captured_count, 2);
+	KUNIT_EXPECT_STREQ(
+		test, captured_logs[0].msg,
+		"[sdb] Sense Key : Unit Attention [deferred] [descriptor] ");
+	KUNIT_EXPECT_STREQ(
+		test, captured_logs[1].msg,
+		"[sdb] Add. Sense: Power on, reset, or bus device reset occurred");
+
+	/* Additional sense: Invalid token operation, remote rod token creation=
 not supported */
+	scsi_logging_test_reset();
+	sshdr.response_code =3D 0x70;
+	sshdr.sense_key =3D ILLEGAL_REQUEST;
+	sshdr.asc =3D 0x23;
+	sshdr.ascq =3D 0x03;
+	scsi_print_sense_hdr(tf->sdev, "sdc", &sshdr);
+	KUNIT_EXPECT_EQ(test, captured_count, 2);
+	KUNIT_EXPECT_STREQ(
+		test, captured_logs[0].msg,
+		"[sdc] Sense Key : Illegal Request [current] ");
+	KUNIT_EXPECT_STREQ(
+		test, captured_logs[1].msg,
+		"[sdc] Add. Sense: Invalid token operation, remote rod token creation =
not supported");
+}
+
+static void test_scsi_print_sense_buffer(struct kunit *test)
+{
+	struct test_fixture *tf =3D scsi_logging_create_fixture(test);
+	unsigned char normalized_sense[18] =3D {
+		[0] =3D 0x70, [2] =3D NOT_READY, [7] =3D 10, [12] =3D 0x04, [13] =3D 0=
x01,
+	};
+	unsigned char raw_sense[16] =3D { 0 };
+
+	/* Normalized sense buffer */
+	__scsi_print_sense(tf->sdev, "sda", normalized_sense,
+			   sizeof(normalized_sense));
+	KUNIT_EXPECT_EQ(test, captured_count, 2);
+	KUNIT_EXPECT_STREQ(test, captured_logs[0].msg,
+			   "[sda] Sense Key : Not Ready [current] ");
+	KUNIT_EXPECT_STREQ(
+		test, captured_logs[1].msg,
+		"[sda] Add. Sense: Logical unit is in process of becoming ready");
+
+	/* Unnormalized / raw sense buffer dumped in hex */
+	scsi_logging_test_reset();
+	__scsi_print_sense(tf->sdev, "sda", raw_sense, sizeof(raw_sense));
+	KUNIT_EXPECT_EQ(test, captured_count, 1);
+	KUNIT_EXPECT_STREQ(
+		test, captured_logs[0].msg,
+		"[sda] 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00");
+}
+
+static void test_scsi_print_sense_cmd(struct kunit *test)
+{
+	struct test_fixture *tf =3D scsi_logging_create_fixture(test);
+	unsigned char *sense_buffer =3D
+		kunit_kzalloc(test, SCSI_SENSE_BUFFERSIZE, GFP_KERNEL);
+
+	KUNIT_ASSERT_NOT_NULL(test, sense_buffer);
+	sense_buffer[0] =3D 0x70;
+	sense_buffer[2] =3D UNIT_ATTENTION;
+	sense_buffer[7] =3D 10;
+	sense_buffer[12] =3D 0x28;
+	sense_buffer[13] =3D 0x00;
+
+	tf->tscmd->cmd.sense_buffer =3D sense_buffer;
+	tf->tscmd->rq.q =3D tf->q;
+	tf->tscmd->rq.tag =3D 3;
+
+	scsi_print_sense(&tf->tscmd->cmd);
+	KUNIT_EXPECT_EQ(test, captured_count, 2);
+	KUNIT_EXPECT_STREQ(test, captured_logs[0].msg,
+			   "[sda] tag#3 Sense Key : Unit Attention [current] ");
+	KUNIT_EXPECT_STREQ(
+		test, captured_logs[1].msg,
+		"[sda] tag#3 Add. Sense: Not ready to ready change, medium may have ch=
anged");
+}
+
+static void test_scsi_print_result(struct kunit *test)
+{
+	struct test_fixture *tf =3D scsi_logging_create_fixture(test);
+
+	tf->tscmd->rq.q =3D tf->q;
+	tf->tscmd->rq.tag =3D 4;
+	tf->tscmd->cmd.result =3D (DID_OK << 16) | SAM_STAT_CHECK_CONDITION;
+	tf->tscmd->cmd.jiffies_at_alloc =3D jiffies - 5 * HZ;
+
+	/* Result with message */
+	scsi_print_result(&tf->tscmd->cmd, "Failed command", FAILED);
+	KUNIT_EXPECT_EQ(test, captured_count, 1);
+	KUNIT_EXPECT_STREQ(
+		test, captured_logs[0].msg,
+		"[sda] tag#4 Failed command: FAILED Result: hostbyte=3DDID_OK driverby=
te=3DDRIVER_OK cmd_age=3D5s");
+
+	/* Result without message */
+	scsi_logging_test_reset();
+	scsi_print_result(&tf->tscmd->cmd, NULL, SUCCESS);
+	KUNIT_EXPECT_EQ(test, captured_count, 1);
+	KUNIT_EXPECT_STREQ(
+		test, captured_logs[0].msg,
+		"[sda] tag#4 SUCCESS Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_OK =
cmd_age=3D5s");
+
+	/* Result with DID_TRANSPORT_DISRUPTED hostbyte */
+	scsi_logging_test_reset();
+	tf->tscmd->cmd.result =3D (DID_TRANSPORT_DISRUPTED << 16) | SAM_STAT_CH=
ECK_CONDITION;
+	scsi_print_result(&tf->tscmd->cmd, "Transport disrupted", NEEDS_RETRY);
+	KUNIT_EXPECT_EQ(test, captured_count, 1);
+	KUNIT_EXPECT_STREQ(
+		test, captured_logs[0].msg,
+		"[sda] tag#4 Transport disrupted: NEEDS_RETRY Result: hostbyte=3DDID_T=
RANSPORT_DISRUPTED driverbyte=3DDRIVER_OK cmd_age=3D5s");
+
+	/* Result with hostbyte without known string */
+	scsi_logging_test_reset();
+	tf->tscmd->cmd.result =3D (0x1f << 16);
+	scsi_print_result(&tf->tscmd->cmd, "Unknown hostbyte", FAILED);
+	KUNIT_EXPECT_EQ(test, captured_count, 1);
+	KUNIT_EXPECT_STREQ(
+		test, captured_logs[0].msg,
+		"[sda] tag#4 Unknown hostbyte: FAILED Result: hostbyte=3D0x1f driverby=
te=3DDRIVER_OK cmd_age=3D5s");
+
+	/* Result with unknown disposition */
+	scsi_logging_test_reset();
+	tf->tscmd->cmd.result =3D (DID_OK << 16);
+	scsi_print_result(&tf->tscmd->cmd, "Unknown disp", 0x7f);
+	KUNIT_EXPECT_EQ(test, captured_count, 1);
+	KUNIT_EXPECT_STREQ(
+		test, captured_logs[0].msg,
+		"[sda] tag#4 Unknown disp: UNKNOWN(0x7f) Result: hostbyte=3DDID_OK dri=
verbyte=3DDRIVER_OK cmd_age=3D5s");
+}
+
+static struct kunit_case scsi_logging_test_cases[] =3D {
+	KUNIT_CASE(test_sdev_prefix_printk),
+	KUNIT_CASE(test_scmd_printk),
+	KUNIT_CASE(test_scsi_print_command),
+	KUNIT_CASE(test_scsi_print_sense_hdr),
+	KUNIT_CASE(test_scsi_print_sense_buffer),
+	KUNIT_CASE(test_scsi_print_sense_cmd),
+	KUNIT_CASE(test_scsi_print_result),
+	{}
+};
+
+static struct kunit_suite scsi_logging_test_suite =3D {
+	.name =3D "scsi_logging",
+	.init =3D scsi_logging_test_init,
+	.exit =3D scsi_logging_test_exit,
+	.test_cases =3D scsi_logging_test_cases,
+};
+
+kunit_test_suite(scsi_logging_test_suite);
+
+MODULE_DESCRIPTION("SCSI logging unit tests");
+MODULE_AUTHOR("Bart Van Assche");
+MODULE_LICENSE("GPL");
