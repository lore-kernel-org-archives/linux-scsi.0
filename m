Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 667FB23CE;
	Tue, 18 Mar 2025 13:05:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742303147; cv=none; b=j74bW+641arYtxlsfGzopQ2SXuPaKl9G+kf22zpXDINfSJtTJvL4HCQlALyKozBUgOzGnxatRigzSpaIYs17kKgdUL/yJFpj5iW+Wrimh2Mi12ZcRrKirczfLtUDaGxaZkGtrErX5uWHuL5tsUxUJQlNSIDpGWuErPCkWwKAbps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742303147; c=relaxed/simple;
	bh=LTnYDGwMN5d3Op+Nl1b42xkyXuHkpUQftS6wAHT18+4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=HjfGQa6Hf2f0oj3dB/xpwoQ9t/Cx4Xau3qicD29rwNSvdn6QAHGexHbqWFWee4tQYDBeNYtVmAhKOKqUgH5JmzaB35isXa2S3dUDQtt0qaDIdSnPdoF+RDisdAJz7ijqdHQXm37OGMmHhwQSrieuqnzk/CwvUtKwawvDrpjDZQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ebjaj9Ei; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ebjaj9Ei"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2255003f4c6so97080325ad.0;
        Tue, 18 Mar 2025 06:05:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1742303141; x=1742907941; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=XhcrugomjK2m254dsTrybh/L5JPvIJL7STh6pHupN5A=;
        b=ebjaj9EibtSu5BLONfv0+ZQ09Rwzy/FSYU+iha3NsKRRgB0FGsP28napuAI8V5IAro
         uxI2vd4Z2U1T4kmyODkNObMU35fQbT1dWYgbQy/flQHOJqlxYTwiMwzOQkQs6pK1kGBF
         PW2vXlBE3vY/IQ1G2rzZ+zd/aN/OJTl3ssdxZFFvj/HkmANvl0emewKdgG6PgrJhOxRU
         GadfJNguJ+OjM9QnU4rk9CY4Ao58viQDx6eX/GCcYIQw64bOeOKQK6G/ydtKr+gCwi5X
         bKPqO7sSXIKQ8pcpCMt+pZ63VCl/M6orxPDo3wtxzX6ZCfkqfmoLQLO1HQ7htWBybC54
         IcyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742303141; x=1742907941;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XhcrugomjK2m254dsTrybh/L5JPvIJL7STh6pHupN5A=;
        b=ijqll+MfzArdqc6o1zx5nJIbZ56L0UELCT5m2CzJ7OdTR2uWLmOE02+jFoDlFYwz6F
         Yj0bUMyZA1/Dh5/yYEc7DQudHS6hCSx5Q3rjVAexAvhCpTZ3QqdDBFecSv36E8UFcAjC
         r0warr7cnrKH688xLs2Isn/HS1g2btugqlh40h3/109q+6cJDlFHEdOE717bUgABuxi7
         l4c5o5SftEgEAAo54FHcy+mDjZ4SbnkiQij4B55XQYuIN4MWyUA/QjIEEoJphvBTIDfr
         uNXNAnKVOT731VoSf+cnOEb/xQYlQDviSl8hHXGoKEbYZ1xN6pB8V4adxpNSW+CndPzn
         7wLw==
X-Forwarded-Encrypted: i=1; AJvYcCW18qYD1HHDZAP/mn6b7wgddifE1c9uvT5P9Ng8TrFPLcNwTuqBKjCWE+AInZ46TQ/azFGv4frakQOZhqA=@vger.kernel.org, AJvYcCXoOoURmDymbcoNm0x2SPfp94HNXSu00PrYtgFFR40pNcYC4W2lUKbRI4hAG/vzl/RShbdv/PCkZpvkTQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YyTrcnQoOl36u3oG+En1YUFdy9CMOWJgqlfa8qatevWFLmk3iHc
	2knts7A7EV1oDF6VCt5kubf9+h25tOoqDwg15j0K7n7UNMpNIp//
X-Gm-Gg: ASbGnct+vRV3AC5ETwWBcmX/CGsvg1BcipaHWgBCKdP1vfjQVBxDysBvBiSEIM6TG0T
	v6NuMP7q9tertFYd+hKMgIhYB0IgW85b7huWocSpT7qIK2TLZhLPsEvlmBXt2N4OeE7eo9Xn4ty
	Bn9YbA+JtZ3AEYcDp2RZ6E3CIpx/XNoSpSxDMHyz0RT0Q9jfIVfQitlrciwA0oDCDTpKamaopqe
	ZauDis6nP1/V6NrBnWPb7hqBGTht34E/dKEnDCPaeD+Uxw3jm//h3KHTKpJh1EvmkLmGDrhjsG2
	0V8rtrkSgP+P3exAyKClStqh2F4Ge+h6gnmEtX7fpWCCcB6+PRkn8+dFYSFHk41gfxcfCi7p/9L
	nMEw=
X-Google-Smtp-Source: AGHT+IGKSU1pfalfp/0y2XKW009eBBNDnmMjL1GVV9MizZy6cB1Tiu/f4815fNnZsgPHZb58XFzBQw==
X-Received: by 2002:a05:6a21:a92:b0:1f5:77bd:ecbc with SMTP id adf61e73a8af0-1f5c1182d35mr23654387637.16.1742303140596;
        Tue, 18 Mar 2025 06:05:40 -0700 (PDT)
Received: from localhost.localdomain ([183.242.254.176])
        by smtp.googlemail.com with ESMTPSA id 41be03b00d2f7-af56ea947a4sm8975705a12.70.2025.03.18.06.05.35
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 18 Mar 2025 06:05:40 -0700 (PDT)
From: Miaoqian Lin <linmq006@gmail.com>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
	Ronnie Sahlberg <lsahlber@redhat.com>,
	Namjae Jeon <namjae.jeon@samsung.com>,
	Steve French <stfrench@microsoft.com>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: linmq006@gmail.com
Subject: [PATCH] scsi: gvp11: Fix error path after scsi_host_alloc
Date: Tue, 18 Mar 2025 21:05:31 +0800
Message-Id: <20250318130532.11546-1-linmq006@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fix error path after scsi_host_alloc() by using fail_irq label instead of
fail_check_or_alloc when dma_set_mask_and_coherent() fails. This ensures
proper cleanup of allocated resources by calling scsi_host_put().

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
---
 drivers/scsi/gvp11.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/gvp11.c b/drivers/scsi/gvp11.c
index 0420bfe9bd42..272ea2d1c8fd 100644
--- a/drivers/scsi/gvp11.c
+++ b/drivers/scsi/gvp11.c
@@ -381,7 +381,7 @@ static int gvp11_probe(struct zorro_dev *z, const struct zorro_device_id *ent)
 			dev_warn(&z->dev, "cannot use DMA mask %llx\n",
 				 TO_DMA_MASK(gvp11_xfer_mask));
 			error = -ENODEV;
-			goto fail_check_or_alloc;
+			goto fail_irq;
 		}
 	} else
 		hdata->wh.dma_xfer_mask = default_dma_xfer_mask;
-- 
2.39.5 (Apple Git-154)

