Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 757C93191AF
	for <linux-scsi@vger.kernel.org>; Sun, 25 Jan 2026 12:18:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769343537; cv=none; b=rN8pTDEfYh3WOESf8grBSVX+PKb/z5lWtu90mnN2/hkLX0HHPTy2eMrphVLDh4/fCw/HLZbCydSa0g0jmybd0Akmh/mWB6E8rzHSsd5/JwjEdR2WYCct1u9k83sMVR8sIGBJGw9r6UnFhY/eDnHPmKNBvPTobvpGpomKcxSeaTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769343537; c=relaxed/simple;
	bh=cL2WwYEYrOj2TIZHpzBc+McaMibair9DAj52Xdpsq3M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FyYdgNQkJ9fMqH+dnXTbSmQqADIT3+/Q9XqzIokccj483lz4+g+wj+d6oekPMIObJW1TYNgLv7HBD7w1QhxA4CbE5XOKKcY2gMlbF8NbOMR0f6wlWdhB8GVlNpBVA4fbmTe6H1wPPI9e9YPeZBYxk0x7gi8lGwm4bGm2No0CinE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gft9xM8d; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gft9xM8d"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2a79998d35aso22984325ad.0
        for <linux-scsi@vger.kernel.org>; Sun, 25 Jan 2026 04:18:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769343536; x=1769948336; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nQLEjpoaTZ5WPWDSuakk1TbfMfDUPRk42g1n/YO4vJY=;
        b=gft9xM8d1utFQDpmnImZ6sRTVC9GMHyFosJ0nSwuOjtQprGg7Dg66S8af4u1b5mwg8
         4mOWgSsQSNRQQTOtBITICFXgqtNT9g8GEyqHnw2tg0Xz/NUG6uUrXd2G9ZaqRhCEP8tj
         DVm6Sa8T8CLJyk/hDheSMa9vqfVTyUfLqefIX/te7nU4L+ZVdUvvpHAXAcrF1mVRsqn7
         ffH+I52hT1SnF8XoGjm5o+dd7VfqtDLE5WLRchngYFZLW5KAXEKDLKJnAeB+39AYS0t8
         VDW+G8bHO3m+ps1DRMEqpXpvExxovhOXnPMOmPhE4nixVtUz1yjJE5XeTybxHJklCgBV
         Hm6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769343536; x=1769948336;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=nQLEjpoaTZ5WPWDSuakk1TbfMfDUPRk42g1n/YO4vJY=;
        b=uZqLdu5LHujPay9AsfSjssBoxlY9C+lcyGqqQbPhLSWgI7JXNeVn4TNNsT2hJfS0eJ
         V9N0lJmU3Chh09dP8ZzzR7AM+dDX3YwO1qqIMmhTxTgwcV/CKIwVk0Ik4RzCOwb/Xo3E
         25QyS0s/bNRVKFOKyLUfx+HtSTQ6UOn5SRiS8nnd6dHys/0F2YXKHz+OxijuiwaPC+yR
         /sKEp1e0EIVbh9HBhtWv3T/QOJVuwvXGLqvpTEVPArWMDQIn4tM42HEYOQ4eD9Wzc0Ij
         7tPb2Gtz9Dw7hUmrlc80DA6yglH4CsVKRiAjBb5fm68u7UIrg6wNavuSJcF4OBAtUZwP
         iRsQ==
X-Forwarded-Encrypted: i=1; AJvYcCUUjqLuL/zfw5xWAu/CnUWnDaf4bW9MkwPoZ+u88Zq5FGZvWAxwN6LHxXk2OXf7KaP8uGafrJSl/bs+@vger.kernel.org
X-Gm-Message-State: AOJu0YzFYpaeD7FtiVNrB58gZ/m9iT7zPVj9p3p2zIPlfrnGRnbW7EXJ
	ZLVtIHiEsw7P6s3C806tEPdsNA05NcjVDOf+QIcnhbVujDk/IYAA6LQ9
X-Gm-Gg: AZuq6aKOGE3EvCLwzPMi2+MagSAcCTWCjljrrj48qxp2i8M4Xm+YRqzDIjbBWA3DK41
	9kc0E09rJYC7Fb5HNlD4jMe4NLRsa7yKhnv0m3Fg5vqrsVa+xYRvGbmnQWESvfQJamWSoX3NDQI
	SPSDENoRecbrEWIgC/ljnI2YI2v3uJyoE5u2pOhv35roA+CyfVjyhiVyD/6ogvzp21j//tzFIG6
	ZieBvhvG42P3RTrMQ1dqg0C1hGe52rTPDe9E995YipReFkqLirK+3rnW6CozP+6ffFok5QEyrzI
	B+FUdo/Xa7iSFLpJFJ+LGdolWfnDqvELBEO9exWHtTBrBV4cSFUSDqheF5KPiZCNwjvObTcJ5DN
	QL3yuXOCGUDCSWxzbQbr6Fy/xvbh1Ucn12gR82NXc+H2Px6orycIvmQm+VajCjNSAC7krk8WzL4
	eoC09ZanyNi6AVNDL3/+gekulY3IQN4NM4c7Efp96n
X-Received: by 2002:a17:903:285:b0:2a1:10f6:3c1 with SMTP id d9443c01a7336-2a84524a14emr16781685ad.26.1769343535861;
        Sun, 25 Jan 2026 04:18:55 -0800 (PST)
Received: from localhost.localdomain ([113.218.252.97])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a802f974d8sm66774625ad.63.2026.01.25.04.18.51
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 25 Jan 2026 04:18:55 -0800 (PST)
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
Subject: [RFC 1/2] megaraid: Fix the issue of erroneous reset of Words in reply_desc
Date: Sun, 25 Jan 2026 20:18:41 +0800
Message-ID: <20260125121842.79839-2-pilgrimtao@gmail.com>
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

