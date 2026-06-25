Received: from mail-yw1-f176.google.com (mail-yw1-f176.google.com [209.85.128.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E3FA348477
	for <linux-scsi@vger.kernel.org>; Thu, 25 Jun 2026 13:58:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782395893; cv=none; b=AD2/RdYfJ7e05xYHVaFzfoUwovph5SEYjRMQmJ058caRkx2k1mfczhYVTOjwBmRkfJjpqXq7aZYl8nr3HvgTPX/iSxpOX6OKKikGTg3vhRS0hfjuRK+myrBqvwSqCnUYxXGdt3GOJ9weGJxaoro1fizBxDU980AbFtss5r2mgkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782395893; c=relaxed/simple;
	bh=YM0Pf4g84Gk/Iw5uTNfnM7ToHIwKLrGrH1zJ52sflnI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vc9zJmRGXbeN9xrUceCR6D9MwEOsJ/QzcpfTp3S6o8jrBv0c/dynybmQAoJSiJrIU4E0eLMoGPaHesRcceQb/8YvorO2rfOvXMa7+qr1vIUAxUMBxHYa4A25iMzEHw3bMOn7uN7INxhEqgs4cJJOrRhW1CVMb4WBFZItxO1NZBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XaXZ+EC4; arc=none smtp.client-ip=209.85.128.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XaXZ+EC4"
Received: by mail-yw1-f176.google.com with SMTP id 00721157ae682-80814edb536so23665057b3.2
        for <linux-scsi@vger.kernel.org>; Thu, 25 Jun 2026 06:58:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782395891; x=1783000691; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qLwPDJ5uNtZ+0JOqHQVrfZz9SuM/vNVm9AbbVLKitTE=;
        b=XaXZ+EC4qGMxa7j4uyh1tgwASz+2ebfkaJ/XCuxz/BTtrXOyk/nOqFt25cnnScq1ma
         5EhGNNKNQUpn7JQywCQ2i0VyWEJ080F1lhx/U7EzjS+oA0nu7Wx1fZpcqqDhqKUJ7kSh
         W/hbHLr6Jl3Ux669Gs7vyEgEFi3PjWW9j9bCtgHjHbVoyB7+KRScdc52P/ZfTHXh932Y
         Xy2dbWKtH8ehYLIdl2N9vJaFf/kcd3bOSHA9JJ52NAExSKMDCQR49N2NrwKC1QOdbY6p
         kDQk/alOgAFbYmQbzY7gcI6SmdzI9UQ+YI9bK2wbmxVFYxWPg9hZ4cae3wuTtUg+Su7F
         jSbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782395891; x=1783000691;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=qLwPDJ5uNtZ+0JOqHQVrfZz9SuM/vNVm9AbbVLKitTE=;
        b=YdAxM7ZS6A93iN7ckQ8bnTmTm0tGi4gsChwNMZxPpl/tMih2KT9VzhIRWmKjmBXAEo
         1ui6anYmK0shZjBa10PeaqYv81kwUAYgm6kiFG55cRgjBhVEquXTzlUGNJEILvXmbgUd
         JvPocGHytFIzoIc5qCihi0ECpqLqG7qrteDao4eog2Bp4a0re/rceJXw2h9ieae1FpNR
         mg58qWAgpizHWJpG3IcXrDfTpwqgtBIy9Bt/q3kbrjddglAnQmd9Otu/T6zumtXk9pN0
         XJIitn1tHJUTv8y8YSWdoz61lWAX5Zs24PVpeU462dBcK7wf4VuGd8tfHkp6NS8ai2pG
         tx7Q==
X-Gm-Message-State: AOJu0YyOsJ+FtIuGPOHlUYW3SWDBXxaMxm3BTQMgguy3JH62mOQh2mpd
	MLEpc4vWE+8JwuwAsLml563VLieCKxEDdOA6jccDu9vAeLZvXNwZosPw
X-Gm-Gg: AfdE7clAKHy+c4dtd37C6sydpCXto0vl1NOfpHoE/3W9O9jZzgnU6XXA86X5mKfEjSM
	Yu2S81rabdho0gbRmSogyPtX+0NG7w6bu9GPgj8F2W3VOOQ8F8tmIr6diUj1ssjL17074czkL9x
	B/t0DLcNB//k6C1YcKvd1keH0fjZkNDdXkTRuNlq2GAQ5jYypZJpHwVLx2iscy42xzlA67nHfpX
	gw0WXyziVX8HMNjtZAcdzoZ0kdWwD/0zw+Q088y09fhe+k1AXKxCP+PnVvHabbK+qYALoL/y8JL
	dGLC6V5AHn7KQ8gdoC4OJ/dGFeuo9JxgGhVPER4qQF8WoNTHBGoPQ6Kk1FHIn9YiihJqQevriRD
	9cE4R/FdymYVp4ptAw2pAeKWrCYp0jxHShZtM0oXw0Hl5urgL5dMJXrudWryVVK76JMdN+LAQjF
	gvdR/iTx4Xk1ExoRvBtICt8t9xnQ==
X-Received: by 2002:a05:690c:45c5:b0:7ea:c21:631f with SMTP id 00721157ae682-80a6c282ae1mr27961607b3.34.1782395891235;
        Thu, 25 Jun 2026 06:58:11 -0700 (PDT)
Received: from Dev-Null-MSI ([2a0d:3344:52ac:a808:98a4:4381:be45:536f])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8025ffc47fbsm72140707b3.33.2026.06.25.06.58.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Jun 2026 06:58:10 -0700 (PDT)
From: Yousef Alhouseen <alhouseenyousef@gmail.com>
To: Adam Radford <aradford@gmail.com>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yousef Alhouseen <alhouseenyousef@gmail.com>
Subject: [PATCH v2 2/2] scsi: 3w-xxxx: sanitize passthrough SGLs
Date: Thu, 25 Jun 2026 15:57:46 +0200
Message-ID: <20260625135746.1639-2-alhouseenyousef@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260625085842.4522-1-alhouseenyousef@gmail.com>
References: <20260625085842.4522-1-alhouseenyousef@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

TW_CMD_PACKET_WITH_DATA accepts a command packet from userspace and
patches only the first SGL entry before posting it to the controller. The
command size and remaining SGL contents can still describe user-controlled
DMA descriptors to firmware.

Reject unknown SGL offsets, clear the relevant SGL array, and force the
command size to the single driver-owned DMA buffer. Zero the coherent
ioctl buffer before copying the request so short device writes do not leak
stale memory back to userspace.

Signed-off-by: Yousef Alhouseen <alhouseenyousef@gmail.com>
---
Changes in v2:
- No change.

 drivers/scsi/3w-xxxx.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/scsi/3w-xxxx.c b/drivers/scsi/3w-xxxx.c
index 147a47e6b..033f79eaa 100644
--- a/drivers/scsi/3w-xxxx.c
+++ b/drivers/scsi/3w-xxxx.c
@@ -925,6 +925,7 @@ static long tw_chrdev_ioctl(struct file *file, unsigned int cmd, unsigned long a
 	}
 
 	tw_ioctl = (TW_New_Ioctl *)cpu_addr;
+	memset(tw_ioctl, 0, data_buffer_length_adjusted + sizeof(TW_New_Ioctl));
 
 	/* Now copy down the entire ioctl */
 	if (copy_from_user(tw_ioctl, argp, data_buffer_length + sizeof(TW_New_Ioctl)))
@@ -972,17 +973,31 @@ static long tw_chrdev_ioctl(struct file *file, unsigned int cmd, unsigned long a
 			/* Load the sg list */
 			switch (TW_SGL_OUT(tw_ioctl->firmware_command.opcode__sgloffset)) {
 			case 2:
+				memset(tw_ioctl->firmware_command.byte8.param.sgl, 0,
+				       sizeof(tw_ioctl->firmware_command.byte8.param.sgl));
+				tw_ioctl->firmware_command.size = 4;
 				tw_ioctl->firmware_command.byte8.param.sgl[0].address = dma_handle + sizeof(TW_New_Ioctl);
 				tw_ioctl->firmware_command.byte8.param.sgl[0].length = data_buffer_length_adjusted;
 				break;
 			case 3:
+				memset(tw_ioctl->firmware_command.byte8.io.sgl, 0,
+				       sizeof(tw_ioctl->firmware_command.byte8.io.sgl));
+				tw_ioctl->firmware_command.size = 5;
 				tw_ioctl->firmware_command.byte8.io.sgl[0].address = dma_handle + sizeof(TW_New_Ioctl);
 				tw_ioctl->firmware_command.byte8.io.sgl[0].length = data_buffer_length_adjusted;
 				break;
 			case 5:
+				memset(passthru->sg_list, 0, sizeof(passthru->sg_list));
+				passthru->size = 7;
 				passthru->sg_list[0].address = dma_handle + sizeof(TW_New_Ioctl);
 				passthru->sg_list[0].length = data_buffer_length_adjusted;
 				break;
+			default:
+				retval = -EINVAL;
+				tw_dev->chrdev_request_id = TW_IOCTL_CHRDEV_FREE;
+				tw_state_request_finish(tw_dev, request_id);
+				spin_unlock_irqrestore(tw_dev->host->host_lock, flags);
+				goto out2;
 			}
 
 			memcpy(tw_dev->command_packet_virtual_address[request_id], &(tw_ioctl->firmware_command), sizeof(TW_Command));
-- 
2.54.0
