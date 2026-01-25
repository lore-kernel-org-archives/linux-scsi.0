Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAF1331AF25
	for <linux-scsi@vger.kernel.org>; Sun, 25 Jan 2026 12:19:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769343542; cv=none; b=KAo2YvGbw/N1/ySMrn79J3P8BVZCM9ISyXJTyAAqb/KERb9MiZSwck2kg9aoH2sKbTaq/mpmpTLfJmMDzEIXtOxYTEm9gVKg60yvDPS6P46uYGvV+gkwfCzZC1SCM6OaXZfGbBseFJ48Z934P2w9t81UFGKnzWK8BDAiJ0oWN5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769343542; c=relaxed/simple;
	bh=UfZLTG3BY76eQmvrJZoKh2ydo53KYQ7gI/Q5BDw5Gns=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iYXMF4Jc5YYj4GOW1wWq6tRJJikMbNo5N2myh/RW1HWGcrE93gt1GqihA87bg6UEFS+nf5W6N84MfPBYtNjnJOVCA/zb1sARqd+uERk5rpvUWbzHFvE50zTEroiZm9izLqlQFwJviXtTJBRtTEfH81iQ5LicXI1+xK/gOMXyCIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lzlsmVyx; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lzlsmVyx"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2a09d981507so24363565ad.1
        for <linux-scsi@vger.kernel.org>; Sun, 25 Jan 2026 04:19:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769343540; x=1769948340; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fqrS1FqBluHn0sbWWyJsNAR0qxaXDS+eOYJqNFFyYfA=;
        b=lzlsmVyxhpx9vgXBNVrmFYsusgOG+Lqmc1mRJne+FFZgo+i69YMXD/U+EVTNvtBZKk
         aA2ItMqFsiDkr2ZMQTOcSN7TSphrpAzqyGnuTZV+gHDMpmas8lJ5Ptas8D5W6oWg3JUl
         8ZkqzEmY9EijZ6wqFGudqByWMYsZ6iTu9V9vsHyRLmYZzIBf9D3JMrcPtjfpallqL8WO
         xkucBu1soJv4WGSXUg38y1ufDbv7rDFdA8eZP/w9NdXzPnXNOFn7zg0LPyi8gK3bPo1H
         eD8zJUwECDWKSDh8RtHNXvNEKkmmE08BjWz+n8cf25p9C7nVLtaigA72ZrQBzgqEaCYY
         3kZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769343540; x=1769948340;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=fqrS1FqBluHn0sbWWyJsNAR0qxaXDS+eOYJqNFFyYfA=;
        b=ItBvFFBO1hhJvfqvp5OIiCdUltDcl6MJaqGqFvSWI7YDPN9at9GJlZqwLcnlA/Tw5C
         +XpDPUPqCFRx7/IsH604BvOP4A3tQDTu7Nlh4+tT7NeRT0kbqeKA4ajaK8kZre/NoQFE
         jbp/seCRecfOSD1LhstxWpYXrq1FZCnDHZYKhR+BYUsRIg9V3EZ0NSz6T5SXIN58twiH
         SqSIFFnXBKqNy7fJ5SzLk8VvHkM3qVvOOezy0MOkzaGezJMaSKFXEi9Gt3NIWrHhaqnh
         KMLYtnQhA4cQ6zI4y1RduYc9r/h8GeISJyT7wnnUokA4SMxZw8i0RuTUBY9gyyck5QtQ
         noFA==
X-Forwarded-Encrypted: i=1; AJvYcCUfqlo0LfYjpcZcR2BUBsKFk7NXJkNTSiKeUkP00IPKxtMZzt1y/epZFYbs3tVaBUPiHV6A1yxvnDfK@vger.kernel.org
X-Gm-Message-State: AOJu0YwMBVK9qBxsd/Du6QK4qcs9x2H8yoqkQY3qlvrVCkrkQgjpUWw9
	ZtWGNGGpgCbeyjDNxIKLLOaMKZcbZkgC9OmA3kMwsdnv9PYNxEQOvGFn
X-Gm-Gg: AZuq6aJg6qkEO1fl+09rGjRxJFCdkmeeHfKas4mtysoReEZ/XI8lQvDoWWT3mFrdhxD
	pGXv8xSy0LLNV1IU3MBUaj7f2f44LHBIswDXe1xSMI0cfqsaxnhUTMvd52SmzaVCfPlzYPfE+j5
	wohWodL7l3MxS3iUXsfMcuSEd21X0MjqY6v+yS1XyvjHxOTecxsPfU7zxvE1jN41Jk52txmyyOS
	29k+brBTGJBVgBYDj/27Hxqkjiic9tRCRMn94NUHfJkoOjd70gSHb63Tezoyju7TWUj/muRysfT
	6maVnd68sA1feBDrtYOyrcv3457oiqjXsuxOpIWrWuksCI38FKPRn4fQTky7uoBMpn4UVQFoU1z
	jn7Oh2OPp9ltPrd/XBPj/c/Q2OYRI0zBIsiLam8KxsIjo9xAjhiEogR9HrdAVEbS9avSYlyyysS
	57Gwl2A4bJNmOIVNS+OdVrSigH9VY12qOf2F993lv1
X-Received: by 2002:a17:903:2347:b0:2a0:fb1c:144e with SMTP id d9443c01a7336-2a8454deb18mr14023355ad.7.1769343540309;
        Sun, 25 Jan 2026 04:19:00 -0800 (PST)
Received: from localhost.localdomain ([113.218.252.97])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a802f974d8sm66774625ad.63.2026.01.25.04.18.56
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 25 Jan 2026 04:19:00 -0800 (PST)
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
	Chengkaitao <chengkaitao@kylinos.cn>
Subject: [RFC 2/2] megaraid: replacing fusion->busy_mq_poll[*] with irq_context->in_used in megasas_blk_mq_poll
Date: Sun, 25 Jan 2026 20:18:42 +0800
Message-ID: <20260125121842.79839-3-pilgrimtao@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260125121842.79839-1-pilgrimtao@gmail.com>
References: <20260125121842.79839-1-pilgrimtao@gmail.com>
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

