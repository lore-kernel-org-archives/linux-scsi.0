Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19DA2176FA5
	for <linux-scsi@vger.kernel.org>; Wed, 26 Jun 2024 10:14:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719396862; cv=none; b=hzUg9XikZnJ2Iw9yGhTlVRDaMwjYEbIjby3YVTJslXn5jROSwoiW5DDO7MhYxjGPRmgo5TZRddxH864OYy9fCJ+/599AvQSqEY/iBc15CJITYXTKrrZp0cnrOnTMEZL4SgWb0YNyAqODY/9bKIFJ4mAAYQHq6UCXK3uUURkkpQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719396862; c=relaxed/simple;
	bh=yC38hflJn7cuFBI3UfTk9pmjq9eYcIISELcFHnXTDr8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SurTfKOjH3LjXNK4jnitluaQOfV+voxUZHoIoIuBdatiHZFtbZJ6YluAsty6Ttni1MoWwkBUOzfU1DxOGzjNA3BYtRj5+UnwZkv/mrfS6PXfqcZfEx3CCb+H228UFIIya6tuxYRTEHAqzkUxx8jEr5Ppb8zkjeerFNXMKry7+A8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CzA3u6sT; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CzA3u6sT"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-1f4a5344ec7so3029135ad.1
        for <linux-scsi@vger.kernel.org>; Wed, 26 Jun 2024 03:14:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1719396860; x=1720001660; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9lXMN2sH57JcKYjj5wzd43H2Wegbr7/Nv7tJWddu4J8=;
        b=CzA3u6sTAsY4oWdGshGGmQGTgdTDVAfjN4yr5KrbyK+Yr3j2Gj9hsmdNQTGNQ+XFqX
         APljNLNlTVDSo0GMHk2+tp0cJlvf4wGVBdFTwSw59GRWWEj6WFsH3DxtynBHxz83BptQ
         N11ueUGGyGmpGKQ6RKinbs9ic4WcqZwRoewRe9GtxnbOW9CgoLJzAMLyvvhIj8oFJBpa
         o+O4TFJpLuIhzjOg8ptiUj29l0BAFoiKGMLoPcrOMC2gnZiWkGbYwCk5gaV0T1V4MyHz
         /Q630E1pWlWz5lNeE/yN0YBhV9MERZadsUavZZKQe3mQYtezj1UmMTuq0SCulPS5Oa3F
         P20Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719396860; x=1720001660;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9lXMN2sH57JcKYjj5wzd43H2Wegbr7/Nv7tJWddu4J8=;
        b=XTztwTbnDecW9bN4ctUpNt8JtYMPBuZKsJc6CtkxeITxu6x8SZ0zcBmFOm1cOmriKq
         pprLFKYrlDb2JESH8YQTqtDfmyfufM9ebPbrIriDLW+h25RXbeaiL8rbm87L98OJHaKO
         +QxEXgXI4K4ZkNgdAdfpy95IrkvdsmFfxFsITXhUVwCx6qTa2p4Wgf3Rf1MikHj38iuH
         zER+T0a3aH+zU6HyfKw+lSPYaw9idt5kMqfNPH5roqR2PZRWnt3hwzk/7FeTWYtC2W5v
         5CHxfTKUcjd9JL6Estn+KHo+5iRIcDYzXiEEtOzn/xL0UO5iS5LkDBTCorS2kijsGMES
         Ym1Q==
X-Gm-Message-State: AOJu0Yx3BWOJ8GHVK4RZ8iQUTrtW584Bq1cTZelwgWihuDY24TdQI4Li
	brwv+nSjCDYsmEgVV7Ux0RwcOMOCevFfvVVplbhPmEmtRw632U0HFw5tEg==
X-Google-Smtp-Source: AGHT+IEwjzlQowNCPGeXbZnoqW4HUH7teNEqeKuPNbv5UmcueX8310v8z9YcJb97XAAklY3Yqabrbg==
X-Received: by 2002:a17:902:f70b:b0:1fa:918e:eb8 with SMTP id d9443c01a7336-1fa918e117fmr14018895ad.47.1719396860273;
        Wed, 26 Jun 2024 03:14:20 -0700 (PDT)
Received: from localhost.localdomain.oslab.amer.dell.com ([139.167.223.130])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1fa360317ccsm57063865ad.279.2024.06.26.03.14.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jun 2024 03:14:20 -0700 (PDT)
From: Prabhakar Pujeri <prabhakar.pujeri@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: Prabhakar Pujeri <prabhakar.pujeri@gmail.com>
Subject: [PATCH 06/14] scsi: megaraid_sas: Simplified transfer length calculation using max() in mega_m_to_n
Date: Wed, 26 Jun 2024 06:13:34 -0400
Message-ID: <20240626101342.1440049-7-prabhakar.pujeri@gmail.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240626101342.1440049-1-prabhakar.pujeri@gmail.com>
References: <20240626101342.1440049-1-prabhakar.pujeri@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Prabhakar Pujeri <prabhakar.pujeri@gmail.com>
---
 drivers/scsi/megaraid.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/megaraid.c b/drivers/scsi/megaraid.c
index 38976f94453e..8e9caf124778 100644
--- a/drivers/scsi/megaraid.c
+++ b/drivers/scsi/megaraid.c
@@ -3469,8 +3469,7 @@ mega_m_to_n(void __user *arg, nitioctl_t *uioc)
 		/*
 		 * Choose the xferlen bigger of input and output data
 		 */
-		uioc->xferlen = uioc_mimd.outlen > uioc_mimd.inlen ?
-			uioc_mimd.outlen : uioc_mimd.inlen;
+		uioc->xferlen = max(uioc_mimd.outlen, uioc_mimd.inlen);
 
 		if( uioc_mimd.outlen ) uioc->flags = UIOC_RD;
 		if( uioc_mimd.inlen ) uioc->flags |= UIOC_WR;
-- 
2.45.1

