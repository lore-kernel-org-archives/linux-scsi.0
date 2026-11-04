Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=45.254.49.207
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793784500;
	b=QzAH/LNMErZFuAzxRYhB9S/H26m95+QrZqnI7mG3R0sdgYu2e6oDNH1jRq3PJxbpKjo2
	 2hcfLzgMrGk+NuXBybLpdQV0b3G6/bEIiZTcuAu3s+8fkKUV0CKdsrPpFPMTmE5NHejzM
	 +Ozd/6OYNan6tKL1b+RW6EziyQ7S4QI46DBwAdqJRIljTroTusESwl7pBF4lcTMBY81J8
	 WF7zemgLN2XgX4Ep2rpwo/kI2LmBDamENXPdnakr2vqqTFq+0I68+8In3AsM1KKxl1siq
	 3vSdO2OEZT31Bj8FQ8Ly9jZj6wUvgSt38VUp4Ik4h6cPLoqur4dKMMKyaesRXaxloWw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793784500;
	h=DMARC-Filter:Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding:X-HM-Tid:X-HM-MType:
	 X-HM-Spam-Status:DKIM-Signature;
	bh=/tZlYIvGbzLcUIVFqkO0wDdyza8BS1AZcDos/cWKlXg=;
	b=PVhtaJqDNc+WlrT5RzyMbGbG8KKrH9rpAffVj7BMPMQO3XhBnp5kbrj8Kxm9RI08YWlb
	 T93zCeN5rxI+/HdiVxqD4C5Mt1p/TLr6sq9iteWWv1k3si3yjYzbA/f8KbabAl0NfiydG
	 GdAvzaNyu2QgY1C65S5bcnPpjqJcRjjDwUsjtBSai/9i3wgIMrRoJapy8uURUddLyEv4K
	 U88O5XL+PkXcULOaZnDl0lL1lcZudM64789x6Euvy33Zl0fcBLbxOJOlMEiBwskQnsVJy
	 nt5u8xkqfYwRav5cUeTtI4PTIR1ggV7xgkhQKmsIpYf3CNz5/OdbH4qOzctn1SXI+1A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=leap-io-kernel.com;
	spf=pass smtp.mailfrom=leap-io-kernel.com;
	dkim=pass header.d=leap-io-kernel.com header.i=@leap-io-kernel.com header.a=rsa-sha256 header.s=default header.b=OtiB277D;
	arc=none smtp.remote-ip=45.254.49.207
Received: from mail-m49207.qiye.163.com (mail-m49207.qiye.163.com [45.254.49.207])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C3A0606A32C
	for <linux-scsi@vger.kernel.org>; Wed,  4 Nov 2026 09:28:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3C3A0606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=leap-io-kernel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=leap-io-kernel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=leap-io-kernel.com header.i=@leap-io-kernel.com header.a=rsa-sha256 header.s=default header.b=OtiB277D
Received: from localhost.localdomain (unknown [222.130.22.242])
	by smtp.qiye.163.com (Hmail) with ESMTP id 5377ea1ae;
	Wed, 4 Nov 2026 17:28:08 +0800 (GMT+08:00)
From: Dongdong Hao <doubled@leap-io-kernel.com>
To: James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: dlemoal@kernel.org,
	hare@kernel.org,
	hare@suse.de,
	doubled@leap-io-kernel.com,
	yjzhang@leap-io-kernel.com,
	kezijie@leap-io-kernel.com,
	jzzhang@leap-io-kernel.com,
	baikefan@leap-io-kernel.com,
	linux-scsi@vger.kernel.org
Subject: [PATCH v2] scsi: leapraid: Fix init_cmd_priv error handling
Date: Wed,  4 Nov 2026 17:28:08 +0800
Message-Id: <20261104092808.206067-1-doubled@leap-io-kernel.com>
X-Mailer: git-send-email 2.25.1
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
X-HM-Tid: 0aa1a5e3237a03aekunm7a9c86c545ed53
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVkaTh5PVk1KThlPHx9CGkJMHVYVFA
	kWGhdVEwETFhoSFyQUDg9ZV1kYEgtZQVlJSUlVSkhLVUlJVUlPSVlXWRYaDxIVHRRZQVlPS0hVSk
	tJT09PSFVKS0tVSkJLS1kG
DKIM-Signature: a=rsa-sha256;
	b=OtiB277DC7DkNqa0pCJ9QVLsc9HkWvPLZYkxGBS9kRa4oczbw1TyHun+rgca2LsQ9YQQkEZjddZVYJZ3XiYPOhQN9TUq/cadMAXWlFPmnTZG7SiHfH6o+dM5AohuDTFGfuurU/g4Uy/1yFeN5HjoUiihleoXAMxOZKgS6MtWcjZZVHi2lsK1QPZXTbmQJevt2ihLpxOz4k2M60fbshwq9TcLsKwqg/YJ/qbLkZFAVepn0aS2fqWnQDhB5zbxzp2a2L7beQUFljYymkBle+ixq9nwwY49ZFNRb2sZiH3kv+eUnQ3ch2fg1atGL1xJv6O2XG+eeyO7pR5Cb3KbjPH+QQ==; c=relaxed/relaxed; s=default; d=leap-io-kernel.com; v=1;
	bh=/tZlYIvGbzLcUIVFqkO0wDdyza8BS1AZcDos/cWKlXg=;
	h=date:mime-version:subject:message-id:from;

leapraid_init_cmd_priv() ignores the return value of
leapraid_internal_init_cmd_priv() and always returns success. If
dma_pool_alloc() fails, io_tracker->chain remains NULL, but the SCSI
midlayer considers the command successfully initialized.

A subsequent I/O requiring more than LEAPRAID_SGL_INLINE_THRESHOLD
DMA-mapped scatter-gather entries dereferences the NULL chain buffer
while building the chained SGL, causing a kernel crash.

Return the result of leapraid_internal_init_cmd_priv() so that allocation
failures propagate to the SCSI midlayer and abort initialization of the
affected request.

Changes in v2:
- Inline scsi_cmd_priv(scmd) and drop the io_tracker local variable.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Dongdong Hao <doubled@leap-io-kernel.com>
---
 drivers/scsi/leapraid/leapraid_os.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/leapraid/leapraid_os.c b/drivers/scsi/leapraid/leapraid_os.c
index da597eb99377..749e50366dbc 100644
--- a/drivers/scsi/leapraid/leapraid_os.c
+++ b/drivers/scsi/leapraid/leapraid_os.c
@@ -935,22 +935,16 @@ static int leapraid_init_cmd_priv(struct Scsi_Host *shost,
 				  struct scsi_cmnd *scmd)
 {
 	struct leapraid_adapter *adapter = shost_priv(shost);
-	struct leapraid_io_req_tracker *io_tracker;
 
-	io_tracker = scsi_cmd_priv(scmd);
-	leapraid_internal_init_cmd_priv(adapter, io_tracker);
-
-	return 0;
+	return leapraid_internal_init_cmd_priv(adapter, scsi_cmd_priv(scmd));
 }
 
 static int leapraid_exit_cmd_priv(struct Scsi_Host *shost,
 				  struct scsi_cmnd *scmd)
 {
 	struct leapraid_adapter *adapter = shost_priv(shost);
-	struct leapraid_io_req_tracker *io_tracker;
 
-	io_tracker = scsi_cmd_priv(scmd);
-	leapraid_internal_exit_cmd_priv(adapter, io_tracker);
+	leapraid_internal_exit_cmd_priv(adapter, scsi_cmd_priv(scmd));
 
 	return 0;
 }
-- 
2.25.1

