Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793709223;
	b=m+vEfm8vSfLXaZNuYGTl2je/oKFHoLpUH3QUF0ikF+Lp/f2S6Cp7YGI/+VSKVOW0BUpr
	 z3oXkCGRmpHHu8crB+yqLbFFPFDiMkZhJUnO+RG+sESlvC1e/UaRxx3CZYwlEAZIlFwXe
	 X7Kd0OKbt32ia+WBPuOUIgLiWdKPl8mv6NHVAKG3RpqFeBk+FOChK+x0Mq/rIYphBtpJj
	 UCgR+BZG4bdLU6157eqzVyO+qoiL3toCXHovHdOOp05GXiNtgTXe6GOPZCqBtbHMRy1YT
	 PevXErZSQugpYOUT0HrV5/c3oy/U9lkrfdNhoCPaQ8gLmqkL/Yv+OK9pEPmgwy+NkjA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793709223;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:From:To:Cc:
	 Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=9kjhtb4pMCtL4sI0pWrXeiyW7bmvjyE4sCW+R/9c2t8=;
	b=S9xrcRR7dxlSqiVIqatz6dJ+kQW08wuya0MOT4lyvQwMbWPeB1sbY5aFKZOR8K3TZ0Iu
	 3AEa/NOhqiUw2IVf4EZwp52KFu61RO9TMWYxj8yC+8QjO/q/fGEX+98VYHhmcD6sGMOOK
	 TFuhNor5Q85m+BIKZ6EmoUf+u9YWUCcq2DhFm36PcLIWGI1G6QKFnG5ELsYj+SpSXD7Sn
	 b3rLP+2Lsjf4D/itxnQ/BiSuIi3ZLVFyk4DxshKSi0EfQ5XqEj+0x863vsFqogfPe7Ulb
	 /JuE0dKBr/JKvhC9iV+1g6GD8LE+9hWAPOLNrEfIU98lbuSwt3Gh8yxDLkbnrKKlASA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=BOcgH7Uw;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=N4mnIjJ0;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC9E6606A32E
	for <linux-scsi@vger.kernel.org>; Tue,  3 Nov 2026 12:33:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CC9E6606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=BOcgH7Uw;
	dkim=pass (2048-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=N4mnIjJ0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793709221;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=9kjhtb4pMCtL4sI0pWrXeiyW7bmvjyE4sCW+R/9c2t8=;
	b=BOcgH7UwuxV78ljG5yC6qqBL/5O97h5DSz/cwhDLbu8/Vqe9pm6la9TZOEg7SkdGHk57tn
	w/rDuzZoLmHFuRdI7JMzFO43hWDtE2hUMe6/j/gaslhVDbh75k5QDoNkPOigL4/lsBTED5
	mBPtMKEC2dPB+O3b4wU7EdOM+cMHXeU=
Received: from mail-dl1-f69.google.com (mail-dl1-f69.google.com
 [74.125.82.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-125-WFtTmGUwOTmelZeTV2HJSA-1; Tue, 03 Nov 2026 07:33:40 -0500
X-MC-Unique: WFtTmGUwOTmelZeTV2HJSA-1
X-Mimecast-MFC-AGG-ID: WFtTmGUwOTmelZeTV2HJSA_1793709220
Received: by mail-dl1-f69.google.com with SMTP id a92af1059eb24-14373747468so5443242c88.1
        for <linux-scsi@vger.kernel.org>; Tue, 03 Nov 2026 04:33:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1793709219; x=1794314019; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=9kjhtb4pMCtL4sI0pWrXeiyW7bmvjyE4sCW+R/9c2t8=;
        b=N4mnIjJ0gFZdIU/eAoQ0meISSelGwIuT51Iohh5OtxvInfHLmvly5WjlM0S6mx5KIO
         mAHM5oBDu7LxP4dEUfo4QUUqf50mTReagnA5qAVPbBcGvMpr4Uf7Qrp2lj6uWycpYX1/
         zTOWYlW0Kep63IqI9MCKC9+bc3WYcSNydgSZtOselsogavpv3Vl+MNnVdbgsbc14RM5+
         hFML+C/Dhe3DBE0DLu128RkQ0yU6u6VdWaoH6d39OVazmDFzt7fdEf+DDhjq2DFJ4JuL
         rgaVbdvgiXOq1HnI7WYnHN6sa5hu1QtOzGEt56GnaEeB6T5aOI1AiT9q7mVIkjFATwym
         bY9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793709219; x=1794314019;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=9kjhtb4pMCtL4sI0pWrXeiyW7bmvjyE4sCW+R/9c2t8=;
        b=E8VUsy//wHtiIKvvKk+YekcRBGkqkhSS0zggmpY7caorVPCIgNGSt5ROkyvP9Gm1Ay
         Io7g27gjWPB1UtIIWfJCsGTZZfZY5iRKiFlVnyXfdZo9iT+BkPTJlpVG9CzOStpAzelI
         ndXCGriF4+wrDWu7kQ8sCieOW3yrqy/MZhq5EuUHBZUlvJREcImE4eW5YD5yzrea4U7Z
         ExRemyV004hUC9nK+kQBpM6HwkR8mhwjZipOtnnAVOYW+uLtCuQMtH+q+X1qlE+owzmd
         21RAkTnmZP4CCPLdMc3NM81IZhQyKFqKuGACXUl8llFi0G9AyFh7cyp0sVirHFo4U+zW
         /7sA==
X-Gm-Message-State: APuU4Z8DRCeX7aAPSToOv15boWMkwJAjWbrWffBCEOLwWTBgqMTCwn7A
	lN4Lrw9FnMc/pWN0fC1++TE/aLizj6MGmpA/Ysj3y+kcJmOPN2UdWNvjHzuxeZU4prHLjRn2gsq
	469UTEUk2i9zAIS11XOkZQOT9/BYuORYzx9xpyjv9uIVySe0YlHfXT17laeWKbF4ofUsp4ts=
X-Gm-Gg: AYBFou2eOAvsS/kmJ1X93D+xXczPUPiybCpWl7AaOKSV1ATk7F6eueeP1pEfSxFoZd4
	WAgQ4uolpOZC/ZVTAkPZtSq80u/6i1HKedAvAkh0INtECKC5rtIh3TONoQi4eEandf0kxoitsEr
	NmtuBsTL5vpzZlvrnhmnjzQmLmJya7ujfltozPURr/+L9x/p06HfQ/qr7EcvkPKYndexo7CQN1z
	qvk0uUvo0hvWUboep4FUAsVjh/YROPEZpNgeImUjGZ0ecBgggoV2jDo6Uzerj78nbFvSvUMi5IQ
	nyzj/PU1gqRbEIFdVdZac+C2tnyLWuc1fFmpLzzZ2KIhe0EhOHkdou8ar9CKXU26yE1X0C8oWcH
	xtJzyKKaa/YSousiyCnBOEtV9sPgxbm7UW6Ho7IaEPwTXprj3zdcslwlOhGtL17fSQfVzkjH8xI
	Lk0lh9bTKJZmMu9Pki0LgYknX7aJBoUu98Hpiq0c1o
X-Received: by 2002:a05:701a:c907:b0:151:6e80:baa9 with SMTP id a92af1059eb24-1ac5a2a138cmr19661614c88.12.1793709219239;
        Tue, 03 Nov 2026 04:33:39 -0800 (PST)
X-Received: by 2002:a05:701a:c907:b0:151:6e80:baa9 with SMTP id a92af1059eb24-1ac5a2a138cmr19661556c88.12.1793709218260;
        Tue, 03 Nov 2026 04:33:38 -0800 (PST)
Received: from mgandhi-thinkpadp16vgen1.redhat.corp ([2401:4900:88f9:2014:83b2:887f:ed66:aa65])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1aed79b3dfcsm46086298c88.12.2026.11.03.04.33.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 04:33:37 -0800 (PST)
From: "Milan P. Gandhi" <mgandhi@redhat.com>
To: sathya.prakash@broadcom.com,
	kashyap.desai@broadcom.com,
	sumit.saxena@broadcom.com,
	sreekanth.reddy@broadcom.com,
	martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org,
	mgandhi@redhat.com,
	stable@vger.kernel.org
Subject: [PATCH] scsi: mpi3mr: Fix integer overflow in reply frame size calculation
Date: Tue,  3 Nov 2026 18:03:16 +0530
Message-ID: <20261103123316.223917-1-mgandhi@redhat.com>
X-Mailer: git-send-email 2.56.0
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The driver reads reply_frame_size from firmware as a u16 value in dwords
and multiplies by 4 to convert to bytes. If the firmware (malicious or
buggy) provides a value greater than U16_MAX / 4, the multiplication
overflows the u16 result before assignment to mrioc->facts.reply_sz.

For example:
  reply_frame_size = 20000 dwords
  20000 * 4 = 80000 bytes (as int)
  Assigned to u16: 80000 & 0xFFFF = 14464 bytes (truncated)

This truncated value is then used to allocate DMA reply buffers via
kzalloc(). The firmware believes it can send 80000-byte replies, but
the driver only allocated 14464 bytes, causing a heap buffer overflow
when the firmware DMAs the full-sized reply.

Additionally, if firmware reports reply_frame_size == 0, facts.reply_sz
becomes 0, which can cause division-by-zero or zero-sized DMA pool
allocations downstream.

Fix by validating reply_frame_size in mpi3mr_issue_iocfacts() before
processing the facts data. Reject values that are zero or would overflow
u16 when converted to bytes.

An attacker with firmware control could exploit this to corrupt kernel
heap memory via DMA, potentially leading to privilege escalation.

Fixes: 824a156633df ("scsi: mpi3mr: Base driver code")
Cc: stable@vger.kernel.org
Signed-off-by: Milan P. Gandhi <mgandhi@redhat.com>
---
 drivers/scsi/mpi3mr/mpi3mr_fw.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index f0d3cd398dd0..2b72218e79fb 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -3261,6 +3261,7 @@ static int mpi3mr_issue_iocfacts(struct mpi3mr_ioc *mrioc,
 	struct mpi3_ioc_facts_data *facts_data)
 {
 	struct mpi3_ioc_facts_request iocfacts_req;
+	u16 reply_frame_size;
 	void *data = NULL;
 	dma_addr_t data_dma;
 	u32 data_len = sizeof(*facts_data);
@@ -3318,6 +3319,19 @@ static int mpi3mr_issue_iocfacts(struct mpi3mr_ioc *mrioc,
 		goto out_unlock;
 	}
 	memcpy(facts_data, (u8 *)data, data_len);
+
+	reply_frame_size = le16_to_cpu(facts_data->reply_frame_size);
+	/*
+	 * Validate reply_frame_size to prevent integer overflow when
+	 * converting dwords to bytes (reply_frame_size * 4).
+	 */
+	if (!reply_frame_size || reply_frame_size > (U16_MAX / 4)) {
+		ioc_err(mrioc, "Invalid reply_frame_size %u from firmware\n",
+			reply_frame_size);
+		retval = -EINVAL;
+		goto out_unlock;
+	}
+
 	mpi3mr_process_factsdata(mrioc, facts_data);
 out_unlock:
 	mrioc->init_cmds.state = MPI3MR_CMD_NOTUSED;
-- 
2.56.0

