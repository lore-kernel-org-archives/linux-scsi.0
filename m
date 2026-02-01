Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 229CF25D208
	for <linux-scsi@vger.kernel.org>; Sun,  1 Feb 2026 03:31:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769916689; cv=none; b=abvslJ0eBPpT94ka+Nr72Dmwm+ikKKpOChBCFEv3aeK1e1kS6EknzX1fgVngGyE+ofkbY3jVFGL4a+dJqkyoSxIXf5rXrhTWp9xBLD9YDljQcv1gyf13uZqGj/wLm6CllQRTvF84/A9ddEkvsSahrBqz7YobrYDRF3DKIrbOXkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769916689; c=relaxed/simple;
	bh=jN28yZ14SSfhHITtLRvQK90xF038BUMXya78mVCodOU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IG9G4RGXqHbKusMoh/y2rhfkvLL4sw+SnJEuULH3Fbiuz1IXAKfdLFXV9aLmoBsLc5KRAttQH5voBwWnCSp4PZRGlG0t0NX/s0EA9Zca1ODayWYiJL45TLl6+8ZBBIYTM2QAmZPwKFFEdkBQG8E8F/+yKt9m7Hk82ebLUK81+sE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KNQxxa13; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KNQxxa13"
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-81dab89f286so1649357b3a.2
        for <linux-scsi@vger.kernel.org>; Sat, 31 Jan 2026 19:31:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769916687; x=1770521487; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=a2AMZ9BtzpQEyHwPhgk6NcROcagmE4M1IuOctvq52M4=;
        b=KNQxxa13m7ED0WQPKV31AZvigum2BQe2zy80v12d8lBysvKZXvUrV1COPgchGXcsce
         ldLdenYAVrDU4B+z0D/JrcusAxEWVGvt77HLtTZd63TKwQu0r2TikyRCH6NaT26XeJg7
         sMhqoaosrw7ll+v5fWV4e4+Dibnndu3ek/f/yULViSValeLSPVmg/F9rNm3kQyRK18YM
         Bm+JFei0xu10zdeF5MdTaF0chtckUDDSjEVT5hDswe8fE8mvGJhd0TUGh87gItM3zgnq
         V1LieOqMnhq+t/J2ABpkMscCm7lM97I7hOaIuRCdgDjvn1Xz9HOXHzLISi1UiOPXIPJd
         NyBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769916687; x=1770521487;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=a2AMZ9BtzpQEyHwPhgk6NcROcagmE4M1IuOctvq52M4=;
        b=DwlcDC3psy7ndK23LTuwteKXe4qxl2beC0GUHvQd5Rh9UKlNQgaCN2Yoa/2PAnmeUS
         8NGN7MVAhM0+m+uJEN7r9opgWIJMa0+HTa4NcdKL9537QfaeoUkAOYjq9RhKSQuUnCdT
         zFnn3y4RmymYNDukXmhudohFgqmGQE6R8ihJtTBaJZO/lD8VuWPNo6iBhntQlSvZn8tw
         1r49w1Vi3/L+HKfcyEXe/MX8KKlWyMgxz076+6LHoBAndN5oaupoNziAizUa2EmiW2me
         ehdeuZRDtyk30cAOWJPzN7EFdZPZ10/IMpI/AbpmArCmqWr+Alik3Uxe42k+6IKqpe+q
         P7bw==
X-Forwarded-Encrypted: i=1; AJvYcCVO7iLYalvdpdWyHuxijn4z8C4S7NKUaWPrKUFbeiWQdmU+Nl5vH8NcD+je27kBHhfHzc539iyu31t8@vger.kernel.org
X-Gm-Message-State: AOJu0YwL2nHK7nzlW095Us6kGubNLa1Yq/bt4cjJu0MmFBH9gjsTAf1Q
	gWx0GcSichaEYgp+ovK+PnqSNdnOleXFvYtc5t+yKL58glPtsJns0cxV
X-Gm-Gg: AZuq6aKmLs5CA4HZKCWZrYekAWz9RSJe57AI9E8VzvZunkm9ZOD9v7iIrjqMQDbXeXL
	5QMMFH2yHqehwUb5Ls1hVgNlE5mJhWR9uEiT9bXg4ZLp9ojnCca1UWS2ZV7Wyd65N15GfTfO5Y9
	bNI3dIThHAgOT9cmvX89Fm9At2ySoUYhnt34awlN8UEHkdEUCrFi/F+DJZpzSoEZG/xsBJ+2Gl7
	of9TC1vlBlnR6Q0r2HHB0neGG8lxUWvo9c7PQXIiPcodxl3Q6Fud6pesO5Mfqtojy8Vptq+Oa6p
	Y2/PHvMgC20oy7AAKlyFtIVLgn60RoyyADB664QOIrJWMfumdPaxzJA7sKbj4x1uEr4EDyxXddT
	1MQzNITFf5v4+sjPnK4ftUgMvlPHOy7CDyCE+Lu5P+7YYA4yhTw/pkpXfRo5VcHo8qSdKdxObEz
	+XBU+WGEpu9qCkfC/5iGAWK0/+waD4cE5UpA32e+MRrw==
X-Received: by 2002:a05:6a00:2349:b0:81f:44bb:8aa with SMTP id d2e1a72fcca58-823aa3fd6b1mr9229916b3a.8.1769916687456;
        Sat, 31 Jan 2026 19:31:27 -0800 (PST)
Received: from localhost.localdomain ([113.218.252.120])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82379b6b2bdsm11831817b3a.30.2026.01.31.19.31.23
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 31 Jan 2026 19:31:26 -0800 (PST)
From: chengkaitao <pilgrimtao@gmail.com>
To: kashyap.desai@broadcom.com,
	sumit.saxena@broadcom.com,
	shivasharan.srikanteshwara@broadcom.com,
	chandrakanth.patil@broadcom.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: megaraidlinux.pdl@broadcom.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Chengkaitao <chengkaitao@kylinos.cn>,
	Zheng tan <tanzheng@kylinos.cn>
Subject: [RFC RESEND 2/2] megaraid: replacing fusion->busy_mq_poll[*] with irq_context->in_used in megasas_blk_mq_poll
Date: Sun,  1 Feb 2026 11:31:10 +0800
Message-ID: <20260201033110.34297-3-pilgrimtao@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260201033110.34297-1-pilgrimtao@gmail.com>
References: <20260201033110.34297-1-pilgrimtao@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Chengkaitao <chengkaitao@kylinos.cn>

The following two types of kernel panics occur on the 4.19 kernel:
Call Trace:
complete_cmd_fusion+0x448/0x6a0 [megaraid_sas]
megasas_blk_mq_poll+0xa8/0x110 [megaraid_sas]
scsi_mq_poll+0x38/0x50
blk_mq_poll+0x198/0x2d8
blk_poll+0x60/0x70
swap_readpage+0x1b0/0x260
read_swap_cache_async+0x5c/0x78
swap_cluster_readahead+0x1e0/0x2b0
swapin_readahead+0x100/0x4c0
do_swap_page+0x244/0xb40
__handle_mm_fault+0x4b0/0x560
handle_mm_fault+0x114/0x280
do_page_fault+0x1f8/0x4c0
do_translation_fault+0xa8/0xbc
do_mem_abort+0x50/0xe0
el1_da+0x20/0x94

Call trace:
complete_cmd_fusion+0x448/0x6a0 [megaraid_sas]
megasas_isr_fusion+0x98/0xa8 [megaraid_sas]
__handle_irq_event_percpu+0x64/0x260
handle_irq_event_percpu+0x28/0x60
handle_irq_event+0x50/0xf8
handle_fasteoi_edge_irq+0x190/0x208
generic_handle_irq+0x3c/0x58
__handle_domain_irq+0x68/0xc0
gic_handle_irq+0x78/0x180
el1_irq+0xb8/0x140

Later, we applied commit 9650b453a3d4 ("block: ignore RWF_HIPRI hint
for sync dio"), and the issue disappeared. Although most of the mq-poll
paths have been removed upstream, io-uring related calls still remain.

We cannot completely rule out the possibility of [patch 1/2] causing
the issue. I still suspect a concurrency/race condition between
megasas_blk_mq_poll and megasas_isr_fusion. Although historical patch
commit logs mention that interrupts are disabled when polling is used,
I haven't found code evidence to confirm it.

Replacing fusion->busy_mq_poll[*] with irq_context->in_used serves two
purposes:
To handle synchronization issues between mq-poll and megasas_isr_fusion
To handle synchronization between mq-poll and megasas_reset_reply_desc

Note: This is a proposed patch for discussion only. It has not been
verified to resolve the issue. If you have alternative suggestions,
please join the discussion.

Signed-off-by: Chengkaitao <chengkaitao@kylinos.cn>
Reported-by: Zheng tan <tanzheng@kylinos.cn>
---
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 11 +++--------
 drivers/scsi/megaraid/megaraid_sas_fusion.h |  2 --
 2 files changed, 3 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index 3d3480b19734..b647bec7115b 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -1871,9 +1871,6 @@ megasas_init_adapter_fusion(struct megasas_instance *instance)
 				MEGASAS_FUSION_IOCTL_CMDS);
 	sema_init(&instance->ioctl_sem, MEGASAS_FUSION_IOCTL_CMDS);
 
-	for (i = 0; i < MAX_MSIX_QUEUES_FUSION; i++)
-		atomic_set(&fusion->busy_mq_poll[i], 0);
-
 	if (megasas_alloc_ioc_init_frame(instance))
 		return 1;
 
@@ -3731,6 +3728,7 @@ int megasas_blk_mq_poll(struct Scsi_Host *shost, unsigned int queue_num)
 	struct megasas_instance *instance;
 	int num_entries = 0;
 	struct fusion_context *fusion;
+	struct megasas_irq_context *irq_context;
 
 	instance = (struct megasas_instance *)shost->hostdata;
 
@@ -3738,11 +3736,8 @@ int megasas_blk_mq_poll(struct Scsi_Host *shost, unsigned int queue_num)
 
 	queue_num = queue_num + instance->low_latency_index_start;
 
-	if (!atomic_add_unless(&fusion->busy_mq_poll[queue_num], 1, 1))
-		return 0;
-
-	num_entries = complete_cmd_fusion(instance, queue_num, NULL);
-	atomic_dec(&fusion->busy_mq_poll[queue_num]);
+	irq_context = &instance->irq_context[queue_num];
+	num_entries = complete_cmd_fusion(instance, queue_num, irq_context);
 
 	return num_entries;
 }
diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.h b/drivers/scsi/megaraid/megaraid_sas_fusion.h
index ddeea0ee2834..70679f53bf9d 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.h
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.h
@@ -1313,8 +1313,6 @@ struct fusion_context {
 	u8 *sense;
 	dma_addr_t sense_phys_addr;
 
-	atomic_t   busy_mq_poll[MAX_MSIX_QUEUES_FUSION];
-
 	dma_addr_t reply_frames_desc_phys[MAX_MSIX_QUEUES_FUSION];
 	union MPI2_REPLY_DESCRIPTORS_UNION *reply_frames_desc[MAX_MSIX_QUEUES_FUSION];
 	struct rdpq_alloc_detail rdpq_tracker[RDPQ_MAX_CHUNK_COUNT];
-- 
2.50.1 (Apple Git-155)

