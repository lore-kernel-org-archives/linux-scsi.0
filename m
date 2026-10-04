Received: from mail-dl1-f54.google.com (mail-dl1-f54.google.com [74.125.82.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27A9A3D47CF
	for <linux-scsi@vger.kernel.org>; Sun,  4 Oct 2026 03:41:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791085310; cv=none; b=etcgKYcunPWq2L8QyAAhjiyCgObQHmSTo70T6hx0uU246ZEU0J1kpNEIm/OFDwRiR2hD+WpLW4xZdGTZCs3UdUYJgq9AD5TkKzs5MYjuAJW9dUBnA8ud4hcPkO7U9wdQuIrd+HZ0g5H5PB+AIR154DQhR26GewXYnr/mttPU9A4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791085310; c=relaxed/simple;
	bh=mzxcZ53zpwxGD8Jl7jtmd75Mcmema/h6ytsD4rYOEmY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HWg/zurdWQS8dtxsrJPdjKYC6EpbupReJUrMJDKloMwWL2XBR4o7204ME9s+CE4Uk+ka53fl/cUfCF2Cn8SnW12MKJvyecDb9qv6JQ7om3HYPFeFEb2mVMu4v2LLUHghmMuv6O8DE8ODG2WkM+34v5xOdRa7OQAEEx9R6gx30/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=trailofbits.com; spf=pass smtp.mailfrom=trailofbits.com; dkim=pass (2048-bit key) header.d=trailofbits.com header.i=@trailofbits.com header.b=e2r3r9MI; arc=none smtp.client-ip=74.125.82.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=trailofbits.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=trailofbits.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=trailofbits.com header.i=@trailofbits.com header.b="e2r3r9MI"
Received: by mail-dl1-f54.google.com with SMTP id a92af1059eb24-1571616ecefso3162c88.1
        for <linux-scsi@vger.kernel.org>; Sat, 03 Oct 2026 20:41:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=trailofbits.com; s=google; t=1791085307; x=1791690107; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=8mi/hJecW1BLhmyrE67W4OVYhCaZsBfUJxq/8gDiNrY=;
        b=e2r3r9MINUekUtkWTG6wfGa/tYQE8ZEaufyx6IdFHEwzPUQKC9C1XHQmWs9UFbVDV8
         BDm2jXok5s0u7UQ4Pz+SlOkeSjarlJQZRWtLKhI2gAwC2Bm96Epoh8VLQnPgPhZLYEKK
         T7+eEIYXsDEIaeO7ua2eEx40xbvg/eWvb7pHFnQvy7d7RbsvSODibWANiBc8Zzfo7N18
         +vA8jZR/xSpFZYE7fsjHuACxYRF6k1Da/LboOrRwvSE7ZbFfz5jDvWUjzz0/CyC6d1SI
         v4UZ//YmDosg9PIQ0HVpVZ4YCB3BFm8N7dGt0kR9R3Wprtxnd1NiIgrdB44yEMkb9DqU
         n5CA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791085307; x=1791690107;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=8mi/hJecW1BLhmyrE67W4OVYhCaZsBfUJxq/8gDiNrY=;
        b=bxk9sq0KtOUHFZXITNSZ31cy2DRvN3IdCx6iFL2mg8fs/8YO/MMOJRLLHVidcg6K+l
         mdY3umJRUQU8BWekFbLqHvkfL4b9vTVzWLPbRJbvd/8Z3ec9vkA7Cyq2UmbPNvRtyvqQ
         n5xWVQCM9IO5VrlRwpN7hTCMkLmIsXXGlCYHU46fCPx4lLMKPhOVtxvPdl+ieNxiii2r
         mM+whZfmAU08uTVZXE+SPBt+IAaU0Xyu84U/aJrv10j1vHz1Ui7Pr3+0zdf9KCDxwSGR
         PAaCnWhtfmDvMoAr9eHRGTA1xFSSjUrJleQKwmlf6qmCkYJtnJbCGO0ya91Wj1snugL6
         +Xow==
X-Forwarded-Encrypted: i=1; AKwUvBzUSAofVZms1sEUv76h66teH+nrDl93a0Zg0eSfEgEBr1H1L+lm8o+6aYGNVjDZnDkhKHDrF3VCf1hh@vger.kernel.org
X-Gm-Message-State: AFuF++nGr5yVhRpfSDIBm/v7hihqxhvY0ooHaLgnUkHsSqZfuIsQ+Y25
	MmvkyLoYaDCEpjB8awG8V6XGLqKXMW9pZamw9M2+g+Qjxo/opgVvA8lXW2IdErD4TSQ=
X-Gm-Gg: AYBFou0ILIG0XtB4bTd3N16NZVxW7WJeNUTqhCNGQOAed/j5uT8qKjnM0ysowMSO+ru
	BGuM5103j6TgDbCgTB/0F7W9fMXQVRBGqelUnw1MbQoQcmc7j/jOxYqNI9PTp+DnhTRdoDWknS8
	3E5FgHGkIIb9b+SfujYMcdQDWcsRLkIlg3q1tUzyanwmv4hoz2WvYoMDXVn/o345IeNwElu8dMW
	ShNddsFW2z2X6c7QIC2nzM67PnffWvmuQQccW48WTCk0WYxtHFbdWTT8N90yBLpUuKXnMLmSAde
	ORtyY/EslBDwyzZuwNLkprL1gLBt47DfnfTujVhDEyOotCMYRQjrPN1dvUGZ81UQeYIumOVdv4U
	9QNqUIRabC8n0XeeflyZfg8SBu5hHRj+iVJo2wlWDODwMv6G8c12ZYIgQx2ChhIrDL3mwiK7XKK
	S0wCEo70nZ/tCM1L9mAw8Kv0U7pYMgZ47g967QFAXZSeeg41kKV0yryamFH85aIfx795EtIK/tC
	bM4ypiwx+7AVIAwy725psn5vTdq9XtX48kQ/IuWPRfrhUPsbvLnaVT6GIxtVpkv3fY4TxM=
X-Received: by 2002:a05:7022:f417:b0:144:eb3f:563a with SMTP id a92af1059eb24-14dd129c260mr15162113c88.15.1791085307012;
        Sat, 03 Oct 2026 20:41:47 -0700 (PDT)
Received: from localhost.localdomain ([2603:8001:5f01:8bab:a817:e330:2fc8:fa47])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-351272d5103sm1113260eec.27.2026.10.03.20.41.46
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 03 Oct 2026 20:41:46 -0700 (PDT)
From: Artem Dinaburg <artem@trailofbits.com>
To: Justin Tee <justin.tee@broadcom.com>,
	Paul Ely <paul.ely@broadcom.com>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	James Smart <James.Smart@Emulex.Com>,
	James Bottomley <James.Bottomley@SteelEye.com>,
	"Martin K . Petersen" <mkp@kernel.org>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Artem Dinaburg <artem@trailofbits.com>
Subject: [RFC PATCH 3/3] scsi: lpfc: Add KUnit tests for mailbox wait ownership
Date: Sat,  3 Oct 2026 23:41:44 -0400
Message-ID: <72eb0bf397cb0cd72a0fbc75a05f0be93c65bfaa.1790968549.git.artem@trailofbits.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <cover.1790968549.git.artem@trailofbits.com>
References: <cover.1790968549.git.artem@trailofbits.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Exercise synchronous mailbox ownership without LPFC hardware by
replacing the mailbox issue callback and tracking one mailbox through a
one-element mempool.

Cover completion before timeout with both accepted issue returns
(MBX_SUCCESS and MBX_BUSY), normal late completion, immediate
submission failure, and the stale-callback interleaving where the
completion dispatcher saved the wake callback before the waiter timed
out. The stale-callback test fails without the wake handler change
because the mailbox is not returned to the pool.

Also run lpfc_get_sfp_info_wait() on SLI-4 against a KUnit device with
a real DMA pool, counting released mbufs through the mbuf safety pool.
Cover a successful A0/A2 dump, an issue failure on either page, and a
timeout on the A0 page followed by the current or a stale late
completion. The issue failure cases fail without the SFP fix: the
mailbox and its mbuf are leaked, and an A2 issue failure is reported as
success.

The fake issue callback never starts a command, so these tests check
mailbox ownership, not an SFP transaction or a timeout on an adapter.

Assisted-by: LLM
Signed-off-by: Artem Dinaburg <artem@trailofbits.com>
---
 drivers/scsi/Kconfig                 |  16 ++
 drivers/scsi/lpfc/.kunitconfig       |   9 +
 drivers/scsi/lpfc/Makefile           |   2 +
 drivers/scsi/lpfc/tests/mbox_kunit.c | 362 +++++++++++++++++++++++++++
 4 files changed, 389 insertions(+)
 create mode 100644 drivers/scsi/lpfc/.kunitconfig
 create mode 100644 drivers/scsi/lpfc/tests/mbox_kunit.c

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 1eec66195..72f2a9da3 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -1163,6 +1163,22 @@ config SCSI_LPFC_DEBUG_FS
 	  This makes debugging information from the lpfc driver
 	  available via the debugfs filesystem.
 
+config LPFC_MBOX_KUNIT_TEST
+	bool "KUnit tests for LPFC mailbox ownership" if !KUNIT_ALL_TESTS
+	depends on KUNIT=y && SCSI_LPFC=y
+	default KUNIT_ALL_TESTS
+	help
+	  Build KUnit tests for synchronous LPFC mailbox wait and completion
+	  ownership, including the SFP page dump. The tests use a fake issue
+	  callback and a one-element memory pool, so they do not require an
+	  LPFC adapter. They are built into LPFC to exercise its non-exported
+	  mailbox callbacks.
+
+	  For more information on KUnit and unit tests in general, please refer
+	  to the KUnit documentation in Documentation/dev-tools/kunit/.
+
+	  If unsure, say N.
+
 source "drivers/scsi/elx/Kconfig"
 
 config SCSI_SIM710
diff --git a/drivers/scsi/lpfc/.kunitconfig b/drivers/scsi/lpfc/.kunitconfig
new file mode 100644
index 000000000..3fa4ad272
--- /dev/null
+++ b/drivers/scsi/lpfc/.kunitconfig
@@ -0,0 +1,9 @@
+CONFIG_KUNIT=y
+CONFIG_NET=y
+CONFIG_PCI=y
+CONFIG_SCSI=y
+CONFIG_SCSI_LOWLEVEL=y
+CONFIG_SCSI_FC_ATTRS=y
+CONFIG_CPU_FREQ=y
+CONFIG_SCSI_LPFC=y
+CONFIG_LPFC_MBOX_KUNIT_TEST=y
diff --git a/drivers/scsi/lpfc/Makefile b/drivers/scsi/lpfc/Makefile
index bbd1faf41..d2b1f0990 100644
--- a/drivers/scsi/lpfc/Makefile
+++ b/drivers/scsi/lpfc/Makefile
@@ -34,3 +34,5 @@ lpfc-objs := lpfc_mem.o lpfc_sli.o lpfc_ct.o lpfc_els.o \
 	lpfc_hbadisc.o	lpfc_init.o lpfc_mbox.o lpfc_nportdisc.o   \
 	lpfc_scsi.o lpfc_attr.o lpfc_vport.o lpfc_debugfs.o lpfc_bsg.o \
 	lpfc_nvme.o lpfc_nvmet.o lpfc_vmid.o
+
+lpfc-$(CONFIG_LPFC_MBOX_KUNIT_TEST) += tests/mbox_kunit.o
diff --git a/drivers/scsi/lpfc/tests/mbox_kunit.c b/drivers/scsi/lpfc/tests/mbox_kunit.c
new file mode 100644
index 000000000..2bdc2d5fc
--- /dev/null
+++ b/drivers/scsi/lpfc/tests/mbox_kunit.c
@@ -0,0 +1,362 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <kunit/device.h>
+#include <kunit/test.h>
+#include <linux/dma-mapping.h>
+#include <linux/dmapool.h>
+#include <linux/mempool.h>
+#include <linux/pci.h>
+
+#include <scsi/scsi.h>
+#include <scsi/scsi_transport_fc.h>
+
+#include "lpfc_hw4.h"
+#include "lpfc_hw.h"
+#include "lpfc_sli.h"
+#include "lpfc_sli4.h"
+#include "lpfc_nl.h"
+#include "lpfc_disc.h"
+#include "lpfc.h"
+#include "lpfc_scsi.h"
+#include "lpfc_crtn.h"
+
+enum lpfc_mbox_issue_mode {
+	LPFC_MBOX_TEST_CAPTURE,
+	LPFC_MBOX_TEST_COMPLETE,
+	LPFC_MBOX_TEST_EXPIRE,
+};
+
+struct lpfc_mbox_test {
+	struct lpfc_hba phba;
+	struct lpfc_vport pport;
+	LPFC_MBOXQ_t storage;
+	mempool_t pool;
+	struct lpfc_dmabuf mbuf_slots[2];
+	LPFC_MBOXQ_t *mbox;
+	void (*captured_cmpl)(struct lpfc_hba *phba, LPFC_MBOXQ_t *mbox);
+	enum lpfc_mbox_issue_mode mode;
+	int issue_result;
+	unsigned int good_issues;
+	bool storage_allocated;
+	unsigned int excess_frees;
+};
+
+static void *lpfc_mbox_test_alloc(gfp_t gfp_mask, void *pool_data)
+{
+	struct lpfc_mbox_test *ctx = pool_data;
+
+	(void)gfp_mask;
+	if (ctx->storage_allocated)
+		return NULL;
+
+	ctx->storage_allocated = true;
+	return &ctx->storage;
+}
+
+static void lpfc_mbox_test_free(void *element, void *pool_data)
+{
+	struct lpfc_mbox_test *ctx = pool_data;
+
+	(void)element;
+	ctx->excess_frees++;
+}
+
+static int lpfc_mbox_test_issue(struct lpfc_hba *phba, LPFC_MBOXQ_t *mbox,
+				uint32_t flag)
+{
+	struct lpfc_mbox_test *ctx;
+
+	(void)flag;
+	ctx = container_of(phba, struct lpfc_mbox_test, phba);
+	ctx->captured_cmpl = mbox->mbox_cmpl;
+	if (ctx->good_issues) {
+		ctx->good_issues--;
+		ctx->captured_cmpl(phba, mbox);
+		return MBX_SUCCESS;
+	}
+
+	if (ctx->mode == LPFC_MBOX_TEST_COMPLETE)
+		ctx->captured_cmpl(phba, mbox);
+	else if (ctx->mode == LPFC_MBOX_TEST_EXPIRE)
+		/* End the wait without completing the command. */
+		complete(mbox->ctx_u.mbox_wait);
+
+	return ctx->issue_result;
+}
+
+static LPFC_MBOXQ_t *lpfc_mbox_test_take_from_pool(struct kunit *test)
+{
+	struct lpfc_mbox_test *ctx = test->priv;
+	LPFC_MBOXQ_t *mbox;
+
+	mbox = mempool_alloc_preallocated(&ctx->pool);
+	KUNIT_EXPECT_PTR_EQ(test, mbox, &ctx->storage);
+	return mbox;
+}
+
+static void lpfc_mbox_test_expect_released(struct kunit *test)
+{
+	struct lpfc_mbox_test *ctx = test->priv;
+	LPFC_MBOXQ_t *mbox;
+
+	mbox = lpfc_mbox_test_take_from_pool(test);
+	if (mbox)
+		mempool_free(mbox, &ctx->pool);
+	else
+		mempool_free(&ctx->storage, &ctx->pool);
+	KUNIT_EXPECT_EQ(test, ctx->excess_frees, 0U);
+}
+
+static void lpfc_mbox_test_expect_caller_owned(struct kunit *test)
+{
+	struct lpfc_mbox_test *ctx = test->priv;
+
+	KUNIT_EXPECT_PTR_EQ(test, mempool_alloc_preallocated(&ctx->pool), NULL);
+}
+
+static void lpfc_mbox_test_mbuf_exit(void *data)
+{
+	struct lpfc_hba *phba = data;
+	struct lpfc_dma_pool *safety = &phba->lpfc_mbuf_safety_pool;
+
+	while (safety->current_count) {
+		safety->current_count--;
+		dma_pool_free(phba->lpfc_mbuf_pool,
+			      safety->elements[safety->current_count].virt,
+			      safety->elements[safety->current_count].phys);
+	}
+	dma_pool_destroy(phba->lpfc_mbuf_pool);
+}
+
+static struct lpfc_rdp_context *lpfc_mbox_test_sfp_init(struct kunit *test)
+{
+	struct lpfc_mbox_test *ctx = test->priv;
+	struct lpfc_hba *phba = &ctx->phba;
+	struct lpfc_rdp_context *rdp;
+	struct device *dev;
+	int rc;
+
+	/* lpfc_get_sfp_info_wait() allocates its own mailbox. */
+	mempool_free(ctx->mbox, &ctx->pool);
+	phba->sli_rev = LPFC_SLI_REV4;
+
+	dev = kunit_device_register(test, "lpfc_mbox_test");
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, dev);
+	rc = dma_coerce_mask_and_coherent(dev, DMA_BIT_MASK(32));
+	KUNIT_ASSERT_EQ(test, rc, 0);
+	phba->lpfc_mbuf_pool = dma_pool_create("lpfc_mbox_test", dev,
+					       LPFC_BPL_SIZE, 8, 0);
+	KUNIT_ASSERT_NOT_NULL(test, phba->lpfc_mbuf_pool);
+
+	/* Park freed mbufs in the safety pool so that they can be counted. */
+	phba->lpfc_mbuf_safety_pool.elements = ctx->mbuf_slots;
+	phba->lpfc_mbuf_safety_pool.max_count = ARRAY_SIZE(ctx->mbuf_slots);
+	rc = kunit_add_action_or_reset(test, lpfc_mbox_test_mbuf_exit, phba);
+	KUNIT_ASSERT_EQ(test, rc, 0);
+
+	rdp = kunit_kzalloc(test, sizeof(*rdp), GFP_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test, rdp);
+	return rdp;
+}
+
+static void lpfc_mbox_test_expect_sfp_released(struct kunit *test)
+{
+	struct lpfc_mbox_test *ctx = test->priv;
+
+	lpfc_mbox_test_expect_released(test);
+	KUNIT_EXPECT_EQ(test, ctx->phba.lpfc_mbuf_safety_pool.current_count,
+			1U);
+}
+
+static int lpfc_mbox_test_init(struct kunit *test)
+{
+	struct lpfc_mbox_test *ctx;
+	int rc;
+
+	ctx = kunit_kzalloc(test, sizeof(*ctx), GFP_KERNEL);
+	if (!ctx)
+		return -ENOMEM;
+
+	spin_lock_init(&ctx->phba.hbalock);
+	ctx->phba.pport = &ctx->pport;
+	ctx->phba.lpfc_sli_issue_mbox = lpfc_mbox_test_issue;
+	ctx->pport.phba = &ctx->phba;
+	ctx->issue_result = MBX_SUCCESS;
+	rc = mempool_init(&ctx->pool, 1, lpfc_mbox_test_alloc,
+			  lpfc_mbox_test_free, ctx);
+	if (rc)
+		return rc;
+
+	ctx->phba.mbox_mem_pool = &ctx->pool;
+	ctx->mbox = mempool_alloc_preallocated(&ctx->pool);
+	if (!ctx->mbox) {
+		mempool_exit(&ctx->pool);
+		return -ENOMEM;
+	}
+	ctx->mbox->u.mb.mbxCommand = MBX_HEARTBEAT;
+	test->priv = ctx;
+	return 0;
+}
+
+static void lpfc_mbox_test_exit(struct kunit *test)
+{
+	struct lpfc_mbox_test *ctx = test->priv;
+	LPFC_MBOXQ_t *mbox;
+
+	mbox = mempool_alloc_preallocated(&ctx->pool);
+	if (mbox)
+		mempool_free(mbox, &ctx->pool);
+	else
+		mempool_free(&ctx->storage, &ctx->pool);
+	mempool_exit(&ctx->pool);
+}
+
+static void lpfc_mbox_completion_before_timeout(struct kunit *test)
+{
+	struct lpfc_mbox_test *ctx = test->priv;
+	int rc;
+
+	ctx->mode = LPFC_MBOX_TEST_COMPLETE;
+	rc = lpfc_sli_issue_mbox_wait(&ctx->phba, ctx->mbox, 0);
+	KUNIT_EXPECT_EQ(test, rc, MBX_SUCCESS);
+	lpfc_mbox_test_expect_caller_owned(test);
+
+	lpfc_mbox_rsrc_cleanup(&ctx->phba, ctx->mbox, MBOX_THD_UNLOCKED);
+	lpfc_mbox_test_expect_released(test);
+}
+
+static void lpfc_mbox_busy_completion_before_timeout(struct kunit *test)
+{
+	struct lpfc_mbox_test *ctx = test->priv;
+
+	/* MBX_BUSY means the command was queued, not rejected. */
+	ctx->issue_result = MBX_BUSY;
+	lpfc_mbox_completion_before_timeout(test);
+}
+
+static void lpfc_mbox_timeout_then_current_callback(struct kunit *test)
+{
+	struct lpfc_mbox_test *ctx = test->priv;
+	void (*callback)(struct lpfc_hba *phba, LPFC_MBOXQ_t *mbox);
+	int rc;
+
+	rc = lpfc_sli_issue_mbox_wait(&ctx->phba, ctx->mbox, 0);
+	KUNIT_ASSERT_EQ(test, rc, MBX_TIMEOUT);
+	callback = ctx->mbox->mbox_cmpl;
+	callback(&ctx->phba, ctx->mbox);
+
+	lpfc_mbox_test_expect_released(test);
+}
+
+static void lpfc_mbox_timeout_then_stale_callback(struct kunit *test)
+{
+	struct lpfc_mbox_test *ctx = test->priv;
+	int rc;
+
+	rc = lpfc_sli_issue_mbox_wait(&ctx->phba, ctx->mbox, 0);
+	KUNIT_ASSERT_EQ(test, rc, MBX_TIMEOUT);
+	KUNIT_ASSERT_TRUE(test,
+			  ctx->captured_cmpl == lpfc_sli_wake_mbox_wait);
+	ctx->captured_cmpl(&ctx->phba, ctx->mbox);
+
+	lpfc_mbox_test_expect_released(test);
+}
+
+static void lpfc_mbox_immediate_issue_failure(struct kunit *test)
+{
+	struct lpfc_mbox_test *ctx = test->priv;
+	int rc;
+
+	ctx->issue_result = MBX_NOT_FINISHED;
+	rc = lpfc_sli_issue_mbox_wait(&ctx->phba, ctx->mbox, 0);
+	KUNIT_EXPECT_EQ(test, rc, MBX_NOT_FINISHED);
+	lpfc_mbox_test_expect_caller_owned(test);
+
+	lpfc_mbox_rsrc_cleanup(&ctx->phba, ctx->mbox, MBOX_THD_UNLOCKED);
+	lpfc_mbox_test_expect_released(test);
+}
+
+static void lpfc_mbox_sfp_success(struct kunit *test)
+{
+	struct lpfc_rdp_context *rdp = lpfc_mbox_test_sfp_init(test);
+	struct lpfc_mbox_test *ctx = test->priv;
+
+	ctx->mode = LPFC_MBOX_TEST_COMPLETE;
+	KUNIT_EXPECT_EQ(test, lpfc_get_sfp_info_wait(&ctx->phba, rdp), 0);
+	lpfc_mbox_test_expect_sfp_released(test);
+}
+
+static void lpfc_mbox_sfp_a0_issue_failure(struct kunit *test)
+{
+	struct lpfc_rdp_context *rdp = lpfc_mbox_test_sfp_init(test);
+	struct lpfc_mbox_test *ctx = test->priv;
+
+	ctx->issue_result = MBX_NOT_FINISHED;
+	KUNIT_EXPECT_NE(test, lpfc_get_sfp_info_wait(&ctx->phba, rdp), 0);
+	lpfc_mbox_test_expect_sfp_released(test);
+}
+
+static void lpfc_mbox_sfp_a2_issue_failure(struct kunit *test)
+{
+	struct lpfc_rdp_context *rdp = lpfc_mbox_test_sfp_init(test);
+	struct lpfc_mbox_test *ctx = test->priv;
+
+	ctx->good_issues = 1;
+	ctx->issue_result = MBX_NOT_FINISHED;
+	KUNIT_EXPECT_NE(test, lpfc_get_sfp_info_wait(&ctx->phba, rdp), 0);
+	lpfc_mbox_test_expect_sfp_released(test);
+}
+
+static void lpfc_mbox_test_sfp_a0_timeout(struct kunit *test, bool stale)
+{
+	struct lpfc_rdp_context *rdp = lpfc_mbox_test_sfp_init(test);
+	struct lpfc_mbox_test *ctx = test->priv;
+	int rc;
+
+	ctx->mode = LPFC_MBOX_TEST_EXPIRE;
+	rc = lpfc_get_sfp_info_wait(&ctx->phba, rdp);
+	KUNIT_ASSERT_EQ(test, rc, MBX_TIMEOUT);
+	lpfc_mbox_test_expect_caller_owned(test);
+	KUNIT_EXPECT_EQ(test, ctx->phba.lpfc_mbuf_safety_pool.current_count,
+			0U);
+
+	/* The late completion now owns and releases the mailbox and mbuf. */
+	if (stale)
+		ctx->captured_cmpl(&ctx->phba, &ctx->storage);
+	else
+		ctx->storage.mbox_cmpl(&ctx->phba, &ctx->storage);
+	lpfc_mbox_test_expect_sfp_released(test);
+}
+
+static void lpfc_mbox_sfp_a0_timeout(struct kunit *test)
+{
+	lpfc_mbox_test_sfp_a0_timeout(test, false);
+}
+
+static void lpfc_mbox_sfp_a0_timeout_stale_callback(struct kunit *test)
+{
+	lpfc_mbox_test_sfp_a0_timeout(test, true);
+}
+
+static struct kunit_case lpfc_mbox_test_cases[] = {
+	KUNIT_CASE(lpfc_mbox_completion_before_timeout),
+	KUNIT_CASE(lpfc_mbox_busy_completion_before_timeout),
+	KUNIT_CASE(lpfc_mbox_timeout_then_current_callback),
+	KUNIT_CASE(lpfc_mbox_timeout_then_stale_callback),
+	KUNIT_CASE(lpfc_mbox_immediate_issue_failure),
+	KUNIT_CASE(lpfc_mbox_sfp_success),
+	KUNIT_CASE(lpfc_mbox_sfp_a0_issue_failure),
+	KUNIT_CASE(lpfc_mbox_sfp_a2_issue_failure),
+	KUNIT_CASE(lpfc_mbox_sfp_a0_timeout),
+	KUNIT_CASE(lpfc_mbox_sfp_a0_timeout_stale_callback),
+	{}
+};
+
+static struct kunit_suite lpfc_mbox_test_suite = {
+	.name = "lpfc_mbox",
+	.init = lpfc_mbox_test_init,
+	.exit = lpfc_mbox_test_exit,
+	.test_cases = lpfc_mbox_test_cases,
+};
+
+kunit_test_suite(lpfc_mbox_test_suite);
-- 
2.43.0
