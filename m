Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E85C5379EE8
	for <linux-scsi@vger.kernel.org>; Thu, 25 Jun 2026 08:58:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782377939; cv=none; b=C5OjnnTdLDrj8FggWMn9qisIcPdxEttsAp2PnRcX5KDLRhNi0AlOp/vBtey5RgOaYKpT8WoIxyQ3rdfsb7NPV88oYZO8tiCBj7VCQt8W8uWeXEvnZnE+EGSlneF/L0lo/ikXnNS1ev8CNwTYeedLmTYvqjRTT79DyamJUO0BoIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782377939; c=relaxed/simple;
	bh=dLn0r1t38329Cig/nWjpiD0ysrQqho5Jr5F6ohO1/xk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=DY0MJ9VZqzzS5eb6JtxPJmosaCmH2OrDB5EWv2vSOuiThawvA+wM2Q5EU2B7hpVZEh7QQrAy4oXoDgZkeQg9bcHUvDINFCHQ7jMtjrS/qhRlWOvn7xbTbO+tsJSGc8xrN4BUCMb2i6Yf+xu5tb0Q/0wncxx/hyU1egiAzB22tXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=pXLFJjSW; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pXLFJjSW"
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-46e335379cbso48118f8f.0
        for <linux-scsi@vger.kernel.org>; Thu, 25 Jun 2026 01:58:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782377936; x=1782982736; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=kylAljG49Nb/Nb++seaqnb5CtH7ekas/Iy2Cej1FLXE=;
        b=pXLFJjSWy0uUzbC1ZXhBXv9FqYgJtsL9FxFQxkjLEJ4z8hMcHbjYLV6vNrfd4ntrVN
         zNmuf21pKQxR5hMeXwk8Ye46M8Gx4/KS3R0SvCzOQeOBkZBKCNWcfIfl1g3ts+p1W5FL
         npUa1ayFLMDEvPdH0fgjd+DgjFWjpzO+vIMv240uy92XPNJRQaH+PeX41Z1Q6El9/Nls
         8o+UrPkGQDCL5/kqro09TfDakAQX5/nf9LBwF8BCwS0js+z9asUf5osK6qal972KrmMe
         LO4i3Wgp0ycQVdKtyYalhxEuzg06oWRTuO/ZklWNCQuWAvueJQrC0EnYFVAoV7MBcdLp
         0zJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782377936; x=1782982736;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kylAljG49Nb/Nb++seaqnb5CtH7ekas/Iy2Cej1FLXE=;
        b=L5g44PAwzxrt4igxeNqkmvy376/lXsFlhWhpFirzT0/OjohsOc/Z3fV2+cg9v1kkIL
         KeaE+W8ld/lASgA3Va5/Fml0bxLETMnlyJpohiBtjuatBgWRucDFzJ+vhOSKsaDCBpSQ
         t6/nJMOP/IsOMDjmQse6BqbB+/VjKTE7z5w96u550XktkPkrpU96/JYNBtyxf/K5jp3T
         NGpT/hYv43xojar0TdBEpMAHw51HH+w/IBHQfC+ZgQFfQbuNuBCj16E+JH+UOx87psOH
         IFOX0IBFWTFeQRoKegQzkYyGzHLAUmsoXPjxcA52iK1OpeQQOmclyjnfPnWLaK6/f7KE
         97bw==
X-Gm-Message-State: AOJu0Yx/qOqWsr2mBLSqbkkrOYN7x0eRHV5rn4e8YxrFNq0FDJPiYmRo
	SpbG2kcJf3pTlruP269D4eZN5OB5rKmVOky0JgjVbXkErlo+mVldmAD1tv+Xrgr7yMW1aQ==
X-Gm-Gg: AfdE7cnYj4Bm8o5sY6ecuBiAjojL9Q7GNGd6cyk0skASCfu835uCRSe1gXBSycP5+1I
	PkYfggsuM5FgIvAiQ/d9RnH36av237+KT08/d0AkLWQ95MgNvUHAox03bC2GhxEGLwRfoVbflYf
	qIBmRv8a44uhgTpOz6h/WjO6mMIcSN+o5w05xjQVoxhFPeVirHeOYtL1VZm2UXPeT4ctcRqg5jh
	3XBOJ8Qbt8DwgSywE2I++qDgxyDxEn6PJlrJuLDucIrdVHOz2t+lL2ftJ3B4CKCi6zLuGcEfxEC
	OQLhpv8zeDrszbdcSe0kE2jpT7/2/H1tQwDvsv+P0xm4O7H9ypYP1KFwKca/2PafpalFkQvXvT5
	pnA8uYIvmrR1vrUtqfKqgSJAqq4SO0AviitA9cHfT0Mz0OPUb30fO4xW+TDWLZ+Yz++zGKeVitc
	4ZI1VKCnYo7ftD7qsysLQKWvHJjg==
X-Received: by 2002:a05:6000:4b1d:b0:46d:638e:4581 with SMTP id ffacd0b85a97d-46dc0744a7cmr2160458f8f.14.1782377936094;
        Thu, 25 Jun 2026 01:58:56 -0700 (PDT)
Received: from Dev-Null-MSI ([2a0d:3344:52ac:a808:98a4:4381:be45:536f])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-46c221d9371sm14891997f8f.21.2026.06.25.01.58.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Jun 2026 01:58:55 -0700 (PDT)
From: Yousef Alhouseen <alhouseenyousef@gmail.com>
To: Adam Radford <aradford@gmail.com>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yousef Alhouseen <alhouseenyousef@gmail.com>
Subject: [PATCH 1/2] scsi: 3w-9xxx: sanitize passthrough SGLs
Date: Thu, 25 Jun 2026 10:58:41 +0200
Message-ID: <20260625085842.4522-1-alhouseenyousef@gmail.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

TW_IOCTL_FIRMWARE_PASS_THROUGH copies a full command packet from userspace
and then overwrites the first SGL entry. The SGL location and command size
remain user-controlled for legacy commands, and any additional
firmware-visible SGL entries can survive in the packet.

Validate the legacy SGL placement before writing it, force the command
size to describe only the single driver-owned data buffer, and clear the
SGL arrays before filling entry zero. Also zero the DMA bounce buffer
before copying the user request so short device writes cannot expose stale
coherent memory on copyout.

Signed-off-by: Yousef Alhouseen <alhouseenyousef@gmail.com>
---
 drivers/scsi/3w-9xxx.c | 54 ++++++++++++++++++++++++++++++++----------
 1 file changed, 41 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/3w-9xxx.c b/drivers/scsi/3w-9xxx.c
index a125801e3..2f399a267 100644
--- a/drivers/scsi/3w-9xxx.c
+++ b/drivers/scsi/3w-9xxx.c
@@ -137,7 +137,9 @@ static int twa_initconnection(TW_Device_Extension *tw_dev, int message_credits,
 			      unsigned short *fw_on_ctlr_branch,
 			      unsigned short *fw_on_ctlr_build,
 			      u32 *init_connect_result);
-static void twa_load_sgl(TW_Device_Extension *tw_dev, TW_Command_Full *full_command_packet, int request_id, dma_addr_t dma_handle, int length);
+static int twa_load_sgl(TW_Device_Extension *tw_dev,
+			TW_Command_Full *full_command_packet, int request_id,
+			dma_addr_t dma_handle, int length);
 static int twa_poll_response(TW_Device_Extension *tw_dev, int request_id, int seconds);
 static int twa_poll_status_gone(TW_Device_Extension *tw_dev, u32 flag, int seconds);
 static int twa_post_command_packet(TW_Device_Extension *tw_dev, int request_id, char internal);
@@ -707,6 +709,8 @@ static long twa_chrdev_ioctl(struct file *file, unsigned int cmd, unsigned long
 	}
 
 	tw_ioctl = (TW_Ioctl_Buf_Apache *)cpu_addr;
+	memset(tw_ioctl, 0, sizeof(TW_Ioctl_Buf_Apache) +
+	       data_buffer_length_adjusted);
 
 	/* Now copy down the entire ioctl */
 	if (copy_from_user(tw_ioctl, argp, sizeof(TW_Ioctl_Buf_Apache) + driver_command.buffer_length))
@@ -727,7 +731,14 @@ static long twa_chrdev_ioctl(struct file *file, unsigned int cmd, unsigned long
 		full_command_packet = &tw_ioctl->firmware_command;
 
 		/* Load request id and sglist for both command types */
-		twa_load_sgl(tw_dev, full_command_packet, request_id, dma_handle, data_buffer_length_adjusted);
+		retval = twa_load_sgl(tw_dev, full_command_packet, request_id,
+				      dma_handle, data_buffer_length_adjusted);
+		if (retval) {
+			tw_dev->chrdev_request_id = TW_IOCTL_CHRDEV_FREE;
+			twa_free_request_id(tw_dev, request_id);
+			spin_unlock_irqrestore(tw_dev->host->host_lock, flags);
+			goto out3;
+		}
 
 		memcpy(tw_dev->command_packet_virt[request_id], &(tw_ioctl->firmware_command), sizeof(TW_Command_Full));
 
@@ -1398,11 +1409,14 @@ static irqreturn_t twa_interrupt(int irq, void *dev_instance)
 } /* End twa_interrupt() */
 
 /* This function will load the request id and various sgls for ioctls */
-static void twa_load_sgl(TW_Device_Extension *tw_dev, TW_Command_Full *full_command_packet, int request_id, dma_addr_t dma_handle, int length)
+static int twa_load_sgl(TW_Device_Extension *tw_dev,
+			TW_Command_Full *full_command_packet, int request_id,
+			dma_addr_t dma_handle, int length)
 {
 	TW_Command *oldcommand;
 	TW_Command_Apache *newcommand;
 	TW_SG_Entry *sgl;
+	unsigned int sgl_offset, sgl_words, max_words;
 	unsigned int pae = 0;
 
 	if ((sizeof(long) < 8) && (sizeof(dma_addr_t) > 4))
@@ -1412,6 +1426,8 @@ static void twa_load_sgl(TW_Device_Extension *tw_dev, TW_Command_Full *full_comm
 		newcommand = &full_command_packet->command.newcommand;
 		newcommand->request_id__lunl =
 			TW_REQ_LUN_IN(TW_LUN_OUT(newcommand->request_id__lunl), request_id);
+		newcommand->sgl_offset = 16;
+		memset(newcommand->sg_list, 0, sizeof(newcommand->sg_list));
 		if (length) {
 			newcommand->sg_list[0].address = TW_CPU_TO_SGL(dma_handle + sizeof(TW_Ioctl_Buf_Apache));
 			newcommand->sg_list[0].length = cpu_to_le32(length);
@@ -1421,19 +1437,31 @@ static void twa_load_sgl(TW_Device_Extension *tw_dev, TW_Command_Full *full_comm
 	} else {
 		oldcommand = &full_command_packet->command.oldcommand;
 		oldcommand->request_id = request_id;
+		sgl_offset = TW_SGL_OUT(oldcommand->opcode__sgloffset);
+		if (!sgl_offset)
+			return length ? -EINVAL : 0;
+
+		sgl_words = sizeof(*sgl) / sizeof(u32);
+		max_words = sizeof(*oldcommand) / sizeof(u32);
+
+		if (tw_dev->tw_pci_dev->device == PCI_DEVICE_ID_3WARE_9690SA) {
+			if (oldcommand->size < sgl_words - pae)
+				return -EINVAL;
+			if (oldcommand->size - sgl_words + pae != sgl_offset)
+				return -EINVAL;
+		}
 
-		if (TW_SGL_OUT(oldcommand->opcode__sgloffset)) {
-			/* Load the sg list */
-			if (tw_dev->tw_pci_dev->device == PCI_DEVICE_ID_3WARE_9690SA)
-				sgl = (TW_SG_Entry *)((u32 *)oldcommand+oldcommand->size - (sizeof(TW_SG_Entry)/4) + pae);
-			else
-				sgl = (TW_SG_Entry *)((u32 *)oldcommand+TW_SGL_OUT(oldcommand->opcode__sgloffset));
-			sgl->address = TW_CPU_TO_SGL(dma_handle + sizeof(TW_Ioctl_Buf_Apache));
-			sgl->length = cpu_to_le32(length);
+		if (sgl_offset > max_words || sgl_words > max_words - sgl_offset)
+			return -EINVAL;
 
-			oldcommand->size += pae;
-		}
+		sgl = (TW_SG_Entry *)((u32 *)oldcommand + sgl_offset);
+		memset(sgl, 0, sizeof(*oldcommand) - sgl_offset * sizeof(u32));
+		sgl->address = TW_CPU_TO_SGL(dma_handle + sizeof(TW_Ioctl_Buf_Apache));
+		sgl->length = cpu_to_le32(length);
+		oldcommand->size = sgl_offset + sgl_words;
 	}
+
+	return 0;
 } /* End twa_load_sgl() */
 
 /* This function will poll for a response interrupt of a request */
-- 
2.54.0

