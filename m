Received: from mail-yw1-f178.google.com (mail-yw1-f178.google.com [209.85.128.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61ABE2E7394
	for <linux-scsi@vger.kernel.org>; Thu, 25 Jun 2026 13:58:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782395895; cv=none; b=aFUpNiQJFqzCjG3j0iW3g2Z0SOA4RGZ72NnwrpyQHCm3LQPPSVF9P+RrT/MOypqM3jwGA2XSQ/OuOxnJoF3o/uo9dQSaSbLS/IUryYYh2ibuZ+3VUqkEFvNx++TNzoRwnbtTkNkSygVKcV8l8eqBPB9CE4gkgKfvldUNEvaSerk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782395895; c=relaxed/simple;
	bh=aaow2J8uneh9+RZAcv4jv4/p3n3Ld70tT5UQwQPt7BE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lZ9jqrNhCZ+fwh8bsvMs8nKahlpp9VAyfKz79VZ6sOizg0ZHqque30MKOU1rTitmPd8iK3CWpAaHl0Hu/8xDFE6ci8hX5lxBvzIrUYb5/i0H1yviFPqhZ74uoWiO6C7zdEYg0ewU5PhvYdlCAWTW+SE8VH2sBNjP7oinPWpl7bc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GwYE8hDw; arc=none smtp.client-ip=209.85.128.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GwYE8hDw"
Received: by mail-yw1-f178.google.com with SMTP id 00721157ae682-7ff05e5d009so20405967b3.1
        for <linux-scsi@vger.kernel.org>; Thu, 25 Jun 2026 06:58:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782395889; x=1783000689; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vSaCjeuPGGEPfBrbRqFxRbNFqwRfD6aY4yIXoAa5R08=;
        b=GwYE8hDwYBqzpj9qMl9b6G/fAzg84HKaWezNpBl96NegvS0AfK3Z7saR6Mdbfmjhun
         bP4N+2yF6W5IQsWgaZ1bruLUc0bqsWzqigNjmmQHD10UQDflL7XT5y6Lgh2GYNGsNNIB
         TlOQZC2T3/daONWFH6fRY+lSRg0zIVWEH2sfljUPRYW8TDJIFwyoPxeO+Cu9pmOK1l04
         JqTLsQ8v3WbvxAEx2Tl+6DpK1YAPB0ahS/oRQ++ARI2tZdC5oTNaakozIWrgQd3P8BKe
         YNDxCLCqGXYGZQwuVJI5YpTM7Hi6z8wBZkr1FiiPPH38OoQIiQ4/vJXUQ37Aq0/uKial
         8hcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782395889; x=1783000689;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=vSaCjeuPGGEPfBrbRqFxRbNFqwRfD6aY4yIXoAa5R08=;
        b=b8lDXn1K/GcMiidxeZlqMTJ3derYBaFWOiEg2Os/+BJkaaqrthoZOnTGcpJLRPbVF4
         DpsWzS4xr4B7JBdYYxFNCaEJJ59IIDrjDtMqXs9KZ1AJQLAQGxTuuzA2bLNRXA4EX/bV
         f8N12tUaICHqxpnnwXGRdwwlUqDTniN8+3Gnt1AMa/yQIY2pmRfGtkdtKHlJ2I+rIn43
         eGexKO/XDDI4ZXj/4mODC00SoH0jd70xMOWrWGIyOJD+zTT/WaMTTq1NZo2CwSGjYWpd
         aHa1I8BqNUf6AdaxjqyEOqOwqd1GX3dKZrRWVzrAsh5nGb5nBF9KoFBuOpSa0ScW81xi
         uizA==
X-Gm-Message-State: AOJu0Yya67epF9anNIPhyQ27bHd+vMkS4UNBVyIEntDzuZBsveBos8qg
	G+sskvZC+x2AEbYX4sD/1QvDeq14naEPJ5FhkyEj4NPLgLBc09DFFsOM
X-Gm-Gg: AfdE7clvA0EKicR5HsA9klBhCCq5fGbFtol2I1noR7DjrIlLy3w6vD1Te7u1Zn+0o8X
	OzFuqMa3n965woxnYomwYUHxWI9qWfQGTDVc7Yo5V7z4BLORZ1kYoIncobd+cMeofyvCqFTMTIE
	bY5OddDOCmSo8xBzwP/UXe/g7wr5U/8lc00Hx2XkVYQp9Z1OlrU8Wa/TelgZutg3FGgMy4YfAnB
	FJKv9IdKNv2NCqePpyjBdSOIUvxDz4QlXotj+aGOv6/pOqTXHD4lAui+Ho5J3Hn4BMIm42v0WPx
	VNGm/usAH+YjsvQM2wgWcyt+AYUQa/LNB49UOshuwXhTO/7XPEs2yzux3PGQ56eEbvqilRg5U2f
	Q0qMR1rxgGItAmQxIcAYRkZcvptHBuOV58K36w1KJOxfXSHmhd2mVyfXq6pF8O4kOIXaxWMkz9C
	AkYRjopUYt2KRvu8Qobk/2PTmkMw==
X-Received: by 2002:a05:690c:6204:b0:809:4f29:fa98 with SMTP id 00721157ae682-80a6b4a3534mr26298727b3.45.1782395889364;
        Thu, 25 Jun 2026 06:58:09 -0700 (PDT)
Received: from Dev-Null-MSI ([2a0d:3344:52ac:a808:98a4:4381:be45:536f])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8025ffc47fbsm72140707b3.33.2026.06.25.06.58.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Jun 2026 06:58:08 -0700 (PDT)
From: Yousef Alhouseen <alhouseenyousef@gmail.com>
To: Adam Radford <aradford@gmail.com>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yousef Alhouseen <alhouseenyousef@gmail.com>
Subject: [PATCH v2 1/2] scsi: 3w-9xxx: sanitize passthrough SGLs
Date: Thu, 25 Jun 2026 15:57:45 +0200
Message-ID: <20260625135746.1639-1-alhouseenyousef@gmail.com>
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

TW_IOCTL_FIRMWARE_PASS_THROUGH copies a full command packet from userspace
and then overwrites the first SGL entry. The SGL location and command
size remain user-controlled for legacy commands, and any additional
firmware-visible SGL entries can survive in the packet.

Validate the legacy SGL placement before writing it, force the command
size to describe only the single driver-owned data buffer, and clear the
SGL arrays before filling entry zero. Also zero the DMA bounce buffer
before copying the user request so short device writes cannot expose
stale coherent memory on copyout.

Since a successful SGL setup leaves retval at zero, reset retval to the
copyout error before the final copy_to_user() so a failed copyout cannot
be reported as success.

Signed-off-by: Yousef Alhouseen <alhouseenyousef@gmail.com>
---
Changes in v2:
- Preserve -EFAULT if the final copy_to_user() fails after successful SGL
  setup.

 drivers/scsi/3w-9xxx.c | 55 ++++++++++++++++++++++++++++++++----------
 1 file changed, 42 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/3w-9xxx.c b/drivers/scsi/3w-9xxx.c
index a125801e3..1e48d6280 100644
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
 
@@ -891,6 +902,7 @@ static long twa_chrdev_ioctl(struct file *file, unsigned int cmd, unsigned long
 	}
 
 	/* Now copy the entire response to userspace */
+	retval = TW_IOCTL_ERROR_OS_EFAULT;
 	if (copy_to_user(argp, tw_ioctl, sizeof(TW_Ioctl_Buf_Apache) + driver_command.buffer_length) == 0)
 		retval = 0;
 out3:
@@ -1398,11 +1410,14 @@ static irqreturn_t twa_interrupt(int irq, void *dev_instance)
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
@@ -1412,6 +1427,8 @@ static void twa_load_sgl(TW_Device_Extension *tw_dev, TW_Command_Full *full_comm
 		newcommand = &full_command_packet->command.newcommand;
 		newcommand->request_id__lunl =
 			TW_REQ_LUN_IN(TW_LUN_OUT(newcommand->request_id__lunl), request_id);
+		newcommand->sgl_offset = 16;
+		memset(newcommand->sg_list, 0, sizeof(newcommand->sg_list));
 		if (length) {
 			newcommand->sg_list[0].address = TW_CPU_TO_SGL(dma_handle + sizeof(TW_Ioctl_Buf_Apache));
 			newcommand->sg_list[0].length = cpu_to_le32(length);
@@ -1421,19 +1438,31 @@ static void twa_load_sgl(TW_Device_Extension *tw_dev, TW_Command_Full *full_comm
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
