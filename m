Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 350302773F4
	for <linux-scsi@vger.kernel.org>; Sun,  1 Feb 2026 03:31:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769916685; cv=none; b=LHVppewboKWEC3rXI87jv8aV8TDGqZdpvZsniExHrbWHGwqhAiVde8vHRPLsvjgf5HKyYl7PRjHnNXRqA8haDKta/Urd125+314X4CxR0hWWEUnB4K5scsdcKn9OWFEfrQY/WuEphWTzEWjHKtjBihK5cxhz5JGVUXi6LAGx2GA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769916685; c=relaxed/simple;
	bh=hLQNZt7neDC3Eu0yqb2A/11Pitd7n2KuvK8pghcMxZs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nk1g32hs1aiqFjZdiRFeDFIVJpLLcKAOQ7UhDtHvThUdqaipiQqvBFAW4Jc4ItRmSrtT09LozZzFbo0Bwr/xjZq5jXUgTSvtBaEvQ3fMS6kv2IMZJfjNMoqJwNEmPbpWA/wQVTAUCODGt4L9T6eMSfDMdG+MtJOGPqjXg4wstLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iwGSYCqs; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iwGSYCqs"
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-823075fed75so2041739b3a.1
        for <linux-scsi@vger.kernel.org>; Sat, 31 Jan 2026 19:31:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769916683; x=1770521483; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8OW6YK/7zWKCsYWYbcpNBYGrHBCbd+EbSHR5nwi0Y6U=;
        b=iwGSYCqseEXifrISDZEzwJ0gcjrqMQpO4hCpzm0dhEZEtiIu6kEBfA7/Ii7iY+gcEj
         zzmcZgAzCADLJsSkm27dXYfEcEmLIP1Cd6T9LDaQuxDH5OE/68hfsFNu9BmpwG76k0D8
         dyiy91hhJonCQthizQpyWpm/mzY4eDj3o5FlfcpJy/5o3FgQpISyG6qRMpK6U8XqYtWu
         LKkkVnu9cl6MuTrOhaDXFkR2uEGb/oaROoQrQy3MxhMSY1LOK4tAj+6fzcCBx70bcNtV
         nwrV3qFXPHx+0mtMsBZoMvvUhzHPYC+9zYVulE50ZI3t22ksHFqWb/Juu+9ZW0RT+EfB
         1eMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769916683; x=1770521483;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=8OW6YK/7zWKCsYWYbcpNBYGrHBCbd+EbSHR5nwi0Y6U=;
        b=fwProCd+jmX2kCo7r2W5WVD5VmmFzactE2tT6mgpNKkJ2X4kbE1PGBizGzJZQBjOdn
         u8pR2wwQF7YAUTQFVzKHLNMNMT8VlpZNH9f5p5WqBjRHfKP4ruHEgp/+ytNlpjms0uB9
         GJdJQCaBen0O21TEflxW6Ya/mwPDOu43ThZdCOgBsiNcdSlmRIN0eW2sH7dc7Nx9OuNs
         Tk64ZkEbAvmrYM5Vo1e9vJqNC6182Y6CeAMzG9cDG8XFFYXnQD2JzdK6RHhu3EvOFZJB
         7PBk21fSKPrUybcKSBxsZyjdp4J8QCsuzMnfNzS7LZmQrShE8LT1nHFv3csFZGIOEBqo
         RtrQ==
X-Forwarded-Encrypted: i=1; AJvYcCUSCX3VifbENS3dKJb7IfhpnCYvwddQl6oZ6lhXafikCkzyZQa76zShdLawxtiJH4Jjz4zLJ3mv49OU@vger.kernel.org
X-Gm-Message-State: AOJu0YwY5kVWicxWkE8ipPx+UxANZlPXpSEMA6xZy6O6EWbMo3KWeEsX
	BnkrtBtCevKAO6RNKu/muILoawLrrHCa2hhQl4Qv79hh+YJcx3yf+JlV
X-Gm-Gg: AZuq6aJhTsjxkP9vZ9SH2iqR4zSXTkuMoLJtt7H0rdu8UVqgoLVSttEjVyqZbVdJ+BD
	JwF+yPPSPAOIeJgZkh+IdsCds7oWf5mqFvhq+pfU8JVfa4MiGbFUO+vr9QMZISrccC7Ik1bhvKa
	L1SSriJYnrrRgVmkpPPLUiCg3y/pKJ0cv/6uBQs5SmBlaEEbxNLEpS4V8T+knVw20Z79aXMqY/a
	EuOWnapePNdy0/Mcp9VhmKY0WLIlM9Bd56ETrkwRQQxVrzwdJtDsdNI2R6ZQaRcVeOkL3nHwuzm
	DjyGypeMK6bELT3jnmFjYfsU9a3F1aZ/Gm78RWX3/NmJZJtOO8+N9EfXz0br1DNXUBSiGjz7RhS
	1mg2gddiSEbilGcQqAJMeGr+Ts2MazdSkXPxWUrZxw6TQqa/QrbvrPMB5BGlFzgwQwIUATd57lR
	k1J3AOVkpKJ9EoW075SpiQu24Ba29tFrmimlT+ZanKXQ==
X-Received: by 2002:a05:6a00:1742:b0:80f:4667:a94a with SMTP id d2e1a72fcca58-82392069529mr9860928b3a.10.1769916683494;
        Sat, 31 Jan 2026 19:31:23 -0800 (PST)
Received: from localhost.localdomain ([113.218.252.120])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82379b6b2bdsm11831817b3a.30.2026.01.31.19.31.18
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 31 Jan 2026 19:31:22 -0800 (PST)
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
Subject: [RFC RESEND 1/2] megaraid: Fix the issue of erroneous reset of Words in reply_desc
Date: Sun,  1 Feb 2026 11:31:09 +0800
Message-ID: <20260201033110.34297-2-pilgrimtao@gmail.com>
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

The following panic occurred on kernel 6.6 (arch: loongarch):
Call Trace:
complete_cmd_fusion+0x180/0x7c8 [megaraid_sas]
megasas_isr_fusion+0xd4/0xf0 [megaraid_sas]
__handle_irq_event_percpu+0x70/0x228
handle_irq_event+0x44/0xf8
handle_edge_irq+0xe8/0x328
avecintc_irq_dispatch+0x68/0x120
handle_irq_desc+0x5c/0x78
handle_cpu_irq+0x6c/0xa8
handle_loongarch_irq+0x2c/0x48
do_vint+0x7c/0xd0
sched_update_worker+0x8/0x90
worker_thread+0x218/0x480
kthread+0xf0/0xf8
ret_from_kernel_thread+0x28/0xc8
ret_from_kernel_thread_asm+0xc/0xa0

Observed symptoms during the issue:
complete_cmd_fusion(struct megasas_instance *instance, u32 MSIxIndex,
		    struct megasas_irq_context *irq_context)
{
	******

	while (d_val.u.low != cpu_to_le32(UINT_MAX) &&
	       d_val.u.high != cpu_to_le32(UINT_MAX)) {

	/**
		When the issue occurs:
		d_val.u.low == 60293120
		d_val.u.high == 0
		reply_desc->SMID == 0xffff
 	 **/
		smid = le16_to_cpu(reply_desc->SMID);
		cmd_fusion = fusion->cmd_list[smid - 1];
		scsi_io_req = (struct MPI2_RAID_SCSI_IO_REQUEST *)
						cmd_fusion->io_request;
	/** cmd_fusion becomes an invalid pointer **/

	******
}

In the complete_cmd_fusion function, the following assignment exists:
	d_val.word = desc->Words;
Thus, reply_desc->SMID == 0xffff may be caused by a concurrency-related
corruption.

Reproduction probability is very low. After code review, I suspect the
following race condition scenario:

interrupt(complete_cmd_fusion)           cpu1(megasas_reset_reply_desc)
while (d_val.u.low != *****) {
        scsi_io_req =
            cmd_fusion->io_request;

        d_val.word = desc->Words;
                                        reply_desc->Words =
                                          cpu_to_le64(ULLONG_MAX);
}

Note: This is a proposed patch for discussion only. It has not been
verified to resolve the issue. If you have alternative suggestions,
please join the discussion.

Signed-off-by: Chengkaitao <chengkaitao@kylinos.cn>
Reported-by: Zheng tan <tanzheng@kylinos.cn>
---
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index a6794f49e9fa..3d3480b19734 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -4282,16 +4282,23 @@ void  megasas_reset_reply_desc(struct megasas_instance *instance)
 	int i, j, count;
 	struct fusion_context *fusion;
 	union MPI2_REPLY_DESCRIPTORS_UNION *reply_desc;
+	struct megasas_irq_context *irq_context;
 
 	fusion = instance->ctrl_context;
 	count = instance->msix_vectors > 0 ? instance->msix_vectors : 1;
 	count += instance->iopoll_q_count;
 
 	for (i = 0 ; i < count ; i++) {
+		irq_context = &instance->irq_context[i];
+		while (!access_irq_context(irq_context))
+			cpu_relax();
+
 		fusion->last_reply_idx[i] = 0;
 		reply_desc = fusion->reply_frames_desc[i];
 		for (j = 0 ; j < fusion->reply_q_depth; j++, reply_desc++)
 			reply_desc->Words = cpu_to_le64(ULLONG_MAX);
+
+		release_irq_context(irq_context);
 	}
 }
 
-- 
2.50.1 (Apple Git-155)

