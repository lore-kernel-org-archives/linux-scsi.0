Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6129384CEA
	for <linux-scsi@vger.kernel.org>; Thu, 25 Jun 2026 08:58:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782377940; cv=none; b=O0xrodthCikcJxN2MfJwU8/fUc49JNAlH0lRliHWNnQcXBLjU9H8CRzJhYud7EBCHCAH75i2ui1J21LOJ2f6aOAyyNc8iLmwmeV/8TnK7V366HXAcjSj9HZyWX9NR14IwIvGlL510UdpAmpY21lP9/WotMN9yqo6q98GDrX2vZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782377940; c=relaxed/simple;
	bh=WYRZeTJn/uiYcMC2UcKc9V+GySJbOyVvf2ROe4GUPWo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z8MeEdaISdAPE8yJQyqqWk/lg7l6IBL0v8aDgfXYZSTJB+RjbgTp4jGyXjhu4Us0zUeAKMFwacoAiMqt0GtzfBQU6bbSOSyokhVxoNrb5UQ65AaOXgdqXHZOJ4WJY2C8Q6+4l2TTXJC8ctveXRoYWNXvPcGF0onMvMW+g2+crF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZWgI7iWJ; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZWgI7iWJ"
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-46066e640easo1271684f8f.1
        for <linux-scsi@vger.kernel.org>; Thu, 25 Jun 2026 01:58:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782377937; x=1782982737; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=k771cx0tQVjm348W96Re7pXEgkIusxwUEudnumrDEAs=;
        b=ZWgI7iWJqy6+6HQWVfB0HGtbfwV0nQQ2QBgxWrQMt0/6X4l4miBExWk4al9f7HEsyc
         6SnFXDF874NJHF+x08q6h1XjpyB3swShYYbzQK80Wi8ByQy+p/8r4CvVb6Yd5ghS5FaX
         3oi6xCgc91u7UcdYKJ8k4WIS305IYcU/+Y0i4Gg1LL2oevgEkzL93f6QxGv2iyn0lD/i
         NtS/FgRs+MIy45h2TCFBazuOaXumji0SsmRTZQWkOqhb+DhQt2aTUNy7q55jizB8MaOo
         zpnvYNLl0J9bHWFCvVvI+Fk3dHHrEn8cujXxEl7evsbaq+I9ovKaZr4N0vPS09M3zfLW
         l8aQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782377937; x=1782982737;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=k771cx0tQVjm348W96Re7pXEgkIusxwUEudnumrDEAs=;
        b=TdQK9MmO0PAJNO7k41LAYStctHf4m01LOhl9/uPXZjO7kW/V/1XvlwOG+eHPVvv0f1
         psWHFTq5CZ2iDxYJrBfckA1zgBZ8JiqKwNThLRMjvx+6qQb4VaGhJ4Edo3E2RTZiNgW9
         2PUTqTtEZZpDnaI7qbySYt0nkAkD+GpqDc+rVY5YirWvEVfZafijcEig4xyy0b65PjMT
         rRDPLWrfA1z5AaqSvTdaXPPkj4yZiexvcgReDGllKaSs+ZZ8tfwbxm05+XeAYkog432r
         /3qejLuCRn4nLpKxaBFn0NPbbLcPGtEcaptmgp3KYo7hjrfGSgXkR/pBdzYAo/JUAoCX
         P0Vg==
X-Gm-Message-State: AOJu0Yw+K2O8I8CrGXHGtSKc19/uFOINinIpj25wmq2kOoGbjT+NXtYS
	jDO/BCH/cjx2cenzeFmr2cCkGgfwfdffDpUuygdHK4n9ERBS1RTXBESa
X-Gm-Gg: AfdE7cmMzS6VGFYyPYUfxmPfhLTNsjTh7871BgBuD4+wKhpJNv2EK8gVYcyipiRIrRc
	LZhgxjrjosMD8Aum5VWIy/18GRUDhNXg50CTTjTA+1AbFP5K003E6wZBqztCHTshMWFr0n/flq4
	3QhKL1jC/+FD/Y+fNL5P4a9zoIJk4/GEmwQqF6dOskB3ddarLgLR+fFrwaF3D72cPNiMjOa8J87
	nQcGL5KR32tlxYoLAsTBV6VruY7QhXq/lAiWlOz54ExQXVIwacbCJqZm7zKdPeYA0HFJYWzDR5d
	mgUtn7l4fMEGG6N2OH6BqzTEZzHuF9pCoSulCkga+FFbmEclL5u3Vd/0+XhqxEoxbuSXN12j6Bf
	zq18NG6xW+BdePgz+mQLYw1+6bvaLUiugkhN0ogA05cB6WxOmpCmScIvvds6pou/KDnC2bLhYnS
	iLDq5zbnZe4tobCV4nHZj1ny7A8g==
X-Received: by 2002:a05:6000:460f:b0:45e:eaed:afd2 with SMTP id ffacd0b85a97d-46dbc1bc950mr2277516f8f.0.1782377937016;
        Thu, 25 Jun 2026 01:58:57 -0700 (PDT)
Received: from Dev-Null-MSI ([2a0d:3344:52ac:a808:98a4:4381:be45:536f])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-46c221d9371sm14891997f8f.21.2026.06.25.01.58.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Jun 2026 01:58:56 -0700 (PDT)
From: Yousef Alhouseen <alhouseenyousef@gmail.com>
To: Adam Radford <aradford@gmail.com>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yousef Alhouseen <alhouseenyousef@gmail.com>
Subject: [PATCH 2/2] scsi: 3w-xxxx: sanitize passthrough SGLs
Date: Thu, 25 Jun 2026 10:58:42 +0200
Message-ID: <20260625085842.4522-2-alhouseenyousef@gmail.com>
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

