Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D7F93264DF
	for <linux-scsi@vger.kernel.org>; Wed, 15 Jul 2026 13:57:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784123824; cv=none; b=lvhGXKrNISxkKOOtMcCHq4yJpf2R4/yQYQHF5GVZLJXErpunkkSFGUAdzgU0eb87nsZV++h+/2nhunMC64dY5tHD9aIUOYT+V3gJgkidexLN6kbTiz+lBsMFbasIlbYzt4lA2orBIDlwAAffCnHmOAGDt02mRbz8cYaX2IZkbDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784123824; c=relaxed/simple;
	bh=fHfXfwEc0ghsiYFZBHpO96ExH/GyzOS5wPECh/RgVIY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=XuKmxrGrZ0TQBxZIYw0niBcRcdpPRi7maMnIuo/g5u9/g1wUAodY51FZqfDq8d15218n9vHR2rGKt/ZFQXFI+bT2F7/2SyvO7xcD0UBRJEK4dS9YmQ0s1diA7z/wP3MBPQxh/dBIbQN0wjz1Y1P4XAJevh0uAsT0KfeR0BDGEvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b=Ff9BqWfU; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b="Ff9BqWfU"
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-47640541585so2715208f8f.1
        for <linux-scsi@vger.kernel.org>; Wed, 15 Jul 2026 06:57:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1784123820; x=1784728620; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=13DZ1ti/XUipAhOOzOx37nwrN3CtQ4Vj0oi6u43J5uE=;
        b=Ff9BqWfUyD94xR221QC1OnFimmefE2CEkatAt5z2SQy2Eg/eFgNNxBOs1b43b+vSdE
         ikm7pQFTOJGkHv27wEXtpu/IoGsiGeQjM7L541KN6LeV4+YGYh/aG/bmro1Q9QXuZPP3
         Tn5GOJYDuGQzL8xdkzrWfyxKQM1+fFlwxKws0tEP8WLVXlXYJKfDBhFhuTTR5KNXCCUb
         UDQ2i9D/RklmMh9l3suvLnJ3nw/sdfxaR2sIfntTLMi9OjKOby9hS9WOHP9jlngzzmIq
         cJr25HhRHu4JKpSeDCEMj3UYiSOZ32w2aUwrUPA6TLuH8x219YrM/FPu9/lQqQRKoAqt
         oBZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784123820; x=1784728620;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=13DZ1ti/XUipAhOOzOx37nwrN3CtQ4Vj0oi6u43J5uE=;
        b=UaKN400BkFP18PeiLWd+LTfxevlTxOKSEKzIQopAJ2PWsY5QuSMQqbxl7jYcH86fnz
         L7Ncu9G2dKLWfwYJx/L3WmzynNwqSmBr8uOsva7OPMKTAzFBZ4Yd86L/kvEYjgzEkU5e
         qGoCxcA3r461ZAld/bUSE8n78R2FjgrzrNEdbIJmkYMMsvWqWdKHsVWMf2rRSd6bSlWE
         fv29wdxd3VciVruOSBbUzzpFyxJX7qd1pvFI7RNdPd1PH44l/bz0oLdeeK2kzYOAFNHt
         RIkeMhaToTS5JFT7fnSPDbTGx6EggfgxCxfVEA2HaGdQOtE5BTVl1NUl05juVO+s9BAc
         VdJw==
X-Forwarded-Encrypted: i=1; AHgh+RpgJk2eUVO4lZJFyOLKZGb0nanljWK9avZrRAzNOqf1W6JSk4kHtJVYybktaCc1IILmcVkmfwd8HUii@vger.kernel.org
X-Gm-Message-State: AOJu0YyzJ7TefMyXhEAwJwYLuvoKF1DstSZBmt8Yuj69m8BY16vYYRSm
	SSHMAV8vHclMm2VS3d6HmqEMKBsgwUhjNBgZQvu1wbRil30yz51Y8OOOho3vn6eYgmA=
X-Gm-Gg: AfdE7cn9W8/gFh9TgUxufF+RGZ+PQd/gCJok8dZxyzJqmt2q2gqZUBykfTS9AOLferQ
	U6Pz218+0mAmMjvKRnl2Ac9q6LfiTwa12EhjiMx3RVqZ9wbjaN3j3RyjCsyElIx0xDT2zDd73jD
	2OuHNLbLoAeWKQ6GmgFrCe066EwMxb9egT1FLjUvAMOGFJt7mAzA5WBViiAXDZq9ELcNEaa6Jq/
	8RT65slrPrclEbZbjSP6exhx/CpPmCtcS6wNZQErLFHBXmwIXwlaJdcwgGeYvn7CUkT1En7w2dZ
	IJeiwWxMrrW2HAihOLqKGw+4PndjuMBm9yyDMz13KKnbrcgaJYO1mLjAALi8QkLaodNubRp3P6a
	trnJsPR+htF1Z0uC1SfPxCkFBw/O8JvO3F6FvPo39tmh6hGlObFH1RorGR9ZIf64ldM6at5ftqz
	3cHq55qXPMPtmbb3+vyQLAMBo4pMUC75+PgBrqv9OPFkbPj3LOqeaD3SBoPdCHbSHlIq4/8wvh7
	Xun2Gc0qikYEv8bg8J5gaDULMRSyV/UiVE=
X-Received: by 2002:a05:6000:2911:b0:47e:5c6c:bdd5 with SMTP id ffacd0b85a97d-47f4fc998a1mr3336281f8f.6.1784123820192;
        Wed, 15 Jul 2026 06:57:00 -0700 (PDT)
Received: from lb03189.fkb.profitbricks.net ([212.227.34.98])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f4635a935sm16404864f8f.11.2026.07.15.06.56.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jul 2026 06:56:59 -0700 (PDT)
From: Md Haris Iqbal <haris.iqbal@ionos.com>
To: Sathya Prakash <sathya.prakash@broadcom.com>,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
	Ranjan Kumar <ranjan.kumar@broadcom.com>
Cc: MPT-FusionLinux.pdl@broadcom.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Md Haris Iqbal <haris.iqbal@ionos.com>
Subject: [PATCH] scsi: mpt3sas: don't post task management replies to io_uring poll queues
Date: Wed, 15 Jul 2026 15:56:42 +0200
Message-ID: <20260715135642.456578-1-haris.iqbal@ionos.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

mpt3sas_scsih_issue_tm() posts a task management (TM) request to the
reply queue given by @msix_task. For ABORT_TASK and the broadcast
primitive QUERY_TASK/ABORT_TASK paths, @msix_task is the msix_io of the
command being managed; for an io_uring polled (RWF_HIPRI) command that is
an io_uring poll reply queue (index >= ioc->iopoll_q_start_index).

io_uring poll queues have no MSI-X interrupt registered and are drained
only by mpt3sas_blk_mq_poll(), which the block layer calls to complete
polled block I/O. A task management request is not a block layer request,
so nothing polls on its behalf: the reply is posted to a queue that is
never serviced during the wait, tm_cmds.done is never completed, and the
TM times out even though the controller is healthy. The abort then
escalates to a controller reset that was not needed.

Post TM replies to reply queue 0 whenever the selected reply queue is an
io_uring poll queue; reply queue 0 is always interrupt-serviced. When
poll queues are disabled, iopoll_q_start_index equals reply_queue_count,
so the check is a no-op and behaviour is unchanged.

Reachable only when the driver is loaded with poll_queues > 0 and an
io_uring polled workload issues I/O that later times out and is aborted.

Fixes: 432bc7caef4e ("scsi: mpt3sas: Add io_uring iopoll support")
Signed-off-by: Md Haris Iqbal <haris.iqbal@ionos.com>
---
Found by code inspection while auditing the task-management reply path.
Posting for review of the analysis.

 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 12caffeed3a0..572ec1787e10 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -3186,6 +3186,16 @@ mpt3sas_scsih_issue_tm(struct MPT3SAS_ADAPTER *ioc, u16 handle, uint channel,
 	int_to_scsilun(lun, (struct scsi_lun *)mpi_request->LUN);
 	mpt3sas_scsih_set_tm_flag(ioc, handle);
 	init_completion(&ioc->tm_cmds.done);
+	/*
+	 * A task management reply must be posted to an interrupt-serviced
+	 * reply queue. If the associated command was submitted on an io_uring
+	 * poll queue, that queue has no MSI-X interrupt and is drained only by
+	 * mpt3sas_blk_mq_poll(); a task management request is not a block layer
+	 * request, so nothing would process its reply and the command would
+	 * time out. Fall back to reply queue 0 in that case.
+	 */
+	if (msix_task >= ioc->iopoll_q_start_index)
+		msix_task = 0;
 	ioc->put_smid_hi_priority(ioc, smid, msix_task);
 	wait_for_completion_timeout(&ioc->tm_cmds.done, timeout*HZ);
 	if (!(ioc->tm_cmds.status & MPT3_CMD_COMPLETE)) {
-- 
2.43.0

