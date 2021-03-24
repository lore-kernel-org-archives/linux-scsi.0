Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0A6EC433E9
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Mar 2021 19:29:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BED2B61A21
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Mar 2021 19:29:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237709AbhCXT3X (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 24 Mar 2021 15:29:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237755AbhCXT3C (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Mar 2021 15:29:02 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3C55C061763;
        Wed, 24 Mar 2021 12:29:01 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id k10so34814150ejg.0;
        Wed, 24 Mar 2021 12:29:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=dzcjbeFj+WpxxyXTlFQ0pILyU0z24ZRfU4LjJPFEC9Y=;
        b=aAfYYdY2MkfeQ5kX7eTV7I5HpN0Q3T6I/ENqrCmVXqxojtf7VSRhXcd9G5ltyzQPu3
         qlmYOd6spBskWhqeH/IsEQz734PxsZGB6lm/cbTq6prarXxTORy5RmM2zGZ6VB04WL2M
         CsmyJ3eNis46Km80thkgQrvIARa02mi/vos6JxlFHPn1H+3FTc/ZmQm8548O2e8FSYLR
         1czpJe3RD6R6UQELE5BAn07kgWtY9Jbl74hxqF8B8ZL/XALhn10v7eDXI0u6+FR2ju7p
         l9DVOY4ZKa4TKCDqriI8B9+nvU5K2BFus00A701ctX3qcJREQcTAMjCkBsF00OiL6yMD
         cobg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=dzcjbeFj+WpxxyXTlFQ0pILyU0z24ZRfU4LjJPFEC9Y=;
        b=YlNGH58X2V3MD02FbXqOV2FuRg9b6uF9qIU4JR7+ggonkiEp9s4PlNWES7X5qrLbVW
         C38jJKNc+bWfuqsOkNYDQPhdW3b9bTV0BmA/NOhI6m5phPGCBbwdf+3YftIG6AzNPf/6
         DnWoCH1ZG0rzmtEFjSn4AqwA2ePkduEL4r9i6+uW3YoLRmE3Z7NDDLx3/V2gwl4TIQqw
         BUpY09Zhctw6ODzk+LKKV0VOhqN05BwQ2B/QVe9VAd6g6y3zL8ghvPmGcK5g0bMGZ2p3
         aJf/0leIzISqre9NFQ+8VjAMbLS43yUuL3VQJFNcOXS854loF6KxKtIcJzAHz3a49NkC
         Q5UA==
X-Gm-Message-State: AOAM5304awU2iHEFjupS9qJF77iecyMAjLHCiYprkO2q5wTR0bGJUW9H
        U+JRn0Nt3F0aVBMY83Uc4v8ZUlm+uWY=
X-Google-Smtp-Source: ABdhPJzBcNBJ6sH5ucFxr5Jwq7lzVvoC4G6C6082pRuPGcCRWzE6davfPLT12nk4KgeZtBfgkwpbwQ==
X-Received: by 2002:a17:906:ae88:: with SMTP id md8mr5312924ejb.264.1616614140694;
        Wed, 24 Mar 2021 12:29:00 -0700 (PDT)
Received: from localhost (ipbcc11466.dynamic.kabel-deutschland.de. [188.193.20.102])
        by smtp.gmail.com with ESMTPSA id mp12sm1316886ejc.1.2021.03.24.12.29.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Mar 2021 12:29:00 -0700 (PDT)
From:   Bodo Stroesser <bostroesser@gmail.com>
To:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Bodo Stroesser <bstroesser@ts.fujitsu.com>,
        Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 1/6] scsi: target: tcmu: Adjust names of variables and definitions
Date:   Wed, 24 Mar 2021 20:28:37 +0100
Message-Id: <20210324192842.30446-2-bostroesser@gmail.com>
X-Mailer: git-send-email 2.12.3
In-Reply-To: <20210324192842.30446-1-bostroesser@gmail.com>
References: <20210324192842.30446-1-bostroesser@gmail.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bodo Stroesser <bstroesser@ts.fujitsu.com>

Some definitions and members of struct tcmu_dev had misleading
names. Examples:
- ring_size was used for the size of mailbox + cmd ring +
  data area
- CMDR_SIZE was used for size of mailbox + cmd ring

I added the new definition MB_CMDR_SIZE (mailbox + command ring),
changed CMDR_SIZE to hold the size of the command ring only and
replaced in struct tcmu_dev the member ring_size with mmap_pages,
because the member is now used in tcmu_mmap() only, where we need
page count, not size.

I also added the new struct tcmu_dev member 'cmdr' which is used
to replace some occurences of '(void *)mb + CMDR_OFF' with
'udev->cmdr' for better readability.

Signed-off-by: Bodo Stroesser <bstroesser@ts.fujitsu.com>
---
 drivers/target/target_core_user.c | 39 ++++++++++++++++++++++-----------------
 1 file changed, 22 insertions(+), 17 deletions(-)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index bdfc057f000c..35975dd75dde 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -60,8 +60,11 @@
 
 #define TCMU_TIME_OUT (30 * MSEC_PER_SEC)
 
-/* For cmd area, the size is fixed 8MB */
-#define CMDR_SIZE (8 * 1024 * 1024)
+/* For mailbox plus cmd ring, the size is fixed 8MB */
+#define MB_CMDR_SIZE (8 * 1024 * 1024)
+/* Offset of cmd ring is size of mailbox */
+#define CMDR_OFF sizeof(struct tcmu_mailbox)
+#define CMDR_SIZE (MB_CMDR_SIZE - CMDR_OFF)
 
 /*
  * For data area, the block size is PAGE_SIZE and
@@ -126,8 +129,10 @@ struct tcmu_dev {
 
 	struct inode *inode;
 
-	struct tcmu_mailbox *mb_addr;
 	uint64_t dev_size;
+
+	struct tcmu_mailbox *mb_addr;
+	void *cmdr;
 	u32 cmdr_size;
 	u32 cmdr_last_cleaned;
 	/* Offset of data area from start of mb */
@@ -135,7 +140,7 @@ struct tcmu_dev {
 	size_t data_off;
 	size_t data_size;
 	uint32_t max_blocks;
-	size_t ring_size;
+	size_t mmap_pages;
 
 	struct mutex cmdr_lock;
 	struct list_head qfull_queue;
@@ -166,8 +171,6 @@ struct tcmu_dev {
 
 #define TCMU_DEV(_se_dev) container_of(_se_dev, struct tcmu_dev, se_dev)
 
-#define CMDR_OFF sizeof(struct tcmu_mailbox)
-
 struct tcmu_cmd {
 	struct se_cmd *se_cmd;
 	struct tcmu_dev *tcmu_dev;
@@ -941,7 +944,7 @@ static uint32_t ring_insert_padding(struct tcmu_dev *udev, size_t cmd_size)
 	if (head_to_end(cmd_head, udev->cmdr_size) < cmd_size) {
 		size_t pad_size = head_to_end(cmd_head, udev->cmdr_size);
 
-		hdr = (void *) mb + CMDR_OFF + cmd_head;
+		hdr = udev->cmdr + cmd_head;
 		tcmu_hdr_set_op(&hdr->len_op, TCMU_OP_PAD);
 		tcmu_hdr_set_len(&hdr->len_op, pad_size);
 		hdr->cmd_id = 0; /* not used for PAD */
@@ -1065,7 +1068,7 @@ static int queue_cmd_ring(struct tcmu_cmd *tcmu_cmd, sense_reason_t *scsi_err)
 
 	cmd_head = ring_insert_padding(udev, command_size);
 
-	entry = (void *) mb + CMDR_OFF + cmd_head;
+	entry = udev->cmdr + cmd_head;
 	memset(entry, 0, command_size);
 	tcmu_hdr_set_op(&entry->hdr.len_op, TCMU_OP_CMD);
 
@@ -1157,7 +1160,7 @@ queue_tmr_ring(struct tcmu_dev *udev, struct tcmu_tmr *tmr)
 
 	cmd_head = ring_insert_padding(udev, cmd_size);
 
-	entry = (void *)mb + CMDR_OFF + cmd_head;
+	entry = udev->cmdr + cmd_head;
 	memset(entry, 0, cmd_size);
 	tcmu_hdr_set_op(&entry->hdr.len_op, TCMU_OP_TMR);
 	tcmu_hdr_set_len(&entry->hdr.len_op, cmd_size);
@@ -1412,7 +1415,7 @@ static unsigned int tcmu_handle_completions(struct tcmu_dev *udev)
 
 	while (udev->cmdr_last_cleaned != READ_ONCE(mb->cmd_tail)) {
 
-		struct tcmu_cmd_entry *entry = (void *) mb + CMDR_OFF + udev->cmdr_last_cleaned;
+		struct tcmu_cmd_entry *entry = udev->cmdr + udev->cmdr_last_cleaned;
 
 		/*
 		 * Flush max. up to end of cmd ring since current entry might
@@ -1851,7 +1854,7 @@ static int tcmu_mmap(struct uio_info *info, struct vm_area_struct *vma)
 	vma->vm_private_data = udev;
 
 	/* Ensure the mmap is exactly the right size */
-	if (vma_pages(vma) != (udev->ring_size >> PAGE_SHIFT))
+	if (vma_pages(vma) != udev->mmap_pages)
 		return -EINVAL;
 
 	tcmu_vma_open(vma);
@@ -2100,20 +2103,22 @@ static int tcmu_configure_device(struct se_device *dev)
 		goto err_bitmap_alloc;
 	}
 
-	udev->mb_addr = vzalloc(CMDR_SIZE);
-	if (!udev->mb_addr) {
+	mb = vzalloc(MB_CMDR_SIZE);
+	if (!mb) {
 		ret = -ENOMEM;
 		goto err_vzalloc;
 	}
 
 	/* mailbox fits in first part of CMDR space */
-	udev->cmdr_size = CMDR_SIZE - CMDR_OFF;
-	udev->data_off = CMDR_SIZE;
+	udev->mb_addr = mb;
+	udev->cmdr = (void *)mb + CMDR_OFF;
+	udev->cmdr_size = CMDR_SIZE;
+	udev->data_off = MB_CMDR_SIZE;
 	udev->data_size = udev->max_blocks * DATA_BLOCK_SIZE;
+	udev->mmap_pages = (udev->data_size + MB_CMDR_SIZE) >> PAGE_SHIFT;
 	udev->dbi_thresh = 0; /* Default in Idle state */
 
 	/* Initialise the mailbox of the ring buffer */
-	mb = udev->mb_addr;
 	mb->version = TCMU_MAILBOX_VERSION;
 	mb->flags = TCMU_MAILBOX_FLAG_CAP_OOOC |
 		    TCMU_MAILBOX_FLAG_CAP_READ_LEN |
@@ -2129,7 +2134,7 @@ static int tcmu_configure_device(struct se_device *dev)
 
 	info->mem[0].name = "tcm-user command & data buffer";
 	info->mem[0].addr = (phys_addr_t)(uintptr_t)udev->mb_addr;
-	info->mem[0].size = udev->ring_size = udev->data_size + CMDR_SIZE;
+	info->mem[0].size = udev->data_size + MB_CMDR_SIZE;
 	info->mem[0].memtype = UIO_MEM_NONE;
 
 	info->irqcontrol = tcmu_irqcontrol;
-- 
2.12.3

