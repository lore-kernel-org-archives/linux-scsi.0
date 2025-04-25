Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 419C121ABB0
	for <linux-scsi@vger.kernel.org>; Fri, 25 Apr 2025 19:24:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745609087; cv=none; b=VFcgw3gDIGfxX0sjWLZr3yyf5xp7y2JMzEio5krWytRLE8PpLbN+Nt3pTeE7z0LT47r2RNeGKpCevv5kDwpo8liRdfkZZzjFwE8EV1zDZLRfaozxBZwmQyeVTcV4pTRjLUJTtZKqh9LdsaqzgHvfu0Zs8F7afQI/R9WxPTZSg0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745609087; c=relaxed/simple;
	bh=Nz6BpKArnNch1V00UN8vL63qyI4nfXZTb5vr+jniu24=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=vFtzFqgS/d7+V79j5aLFgImHna74j4foc01GK6box5y5+RtOp794HftfmFomP6CR7D0NX5ZF63pw433K/x/UyvqpslvUZT0EctwyBeO/4BKuAw9Eky2QsIVaQnv4DIkRxWX4BlX+zk+DyFGW5mjogogiyZJnfQUzU9WZT+qwGyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=STLhkbF7; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="STLhkbF7"
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-7370a2d1981so2274112b3a.2
        for <linux-scsi@vger.kernel.org>; Fri, 25 Apr 2025 12:24:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745609085; x=1746213885; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=62zm1W8IoG0ZaLP3Q9zqWa2/RhtclO82F/GKf2CvRGk=;
        b=STLhkbF7s/F/Ns1zDaUrUIweNkvhcyZ74eVXqg+1ElglGaG5fKjec4yVEoci8FI3RO
         0mHkfL8jKfV3RwY+l47w2tovrQhggbntTXNcGOvEA14pCqn7ShFSJZ8nf0pamC2wVqcJ
         UCNthoQeXVIj9S7VHu4tqd3ZzroH8A1wErqI/SV1RsLMva4zWcZTN4JOYmDki+UeXj5H
         z+XJf72G4HoE9hTt5qrkyqqFUGKHmRxtYZ3jH1DjzDR8WT4s3MtwS3bQEJB7SngOxqZ1
         cjKRPC/AaY7/yBgW8K6ybELi8MMNWZqsqlQgQEsrGGCkNOOmx1xNPinxzTQQJ+LTqOp0
         IxlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745609085; x=1746213885;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=62zm1W8IoG0ZaLP3Q9zqWa2/RhtclO82F/GKf2CvRGk=;
        b=X5uYTn7J3mQcbC0EkgnVIxiiKViI+A4+6XJnPdP4w3iydr8M8wasNQiHU0/WAFDFm3
         Hr1LVbJktCGPkE+3awFTo8afnsXFd3AMu9imqrOHlpIFI9kbO58Rh8FkGy2g1AdNR5CN
         K8qVyEvtt25l+aTWmHw3Er1DWBws70or8waQUn3USzfEVXCvPukBJlDC1Yt6OETw1sgA
         KQVsq79gy/8/r+cuJb8Z8HhDNzD17+wDk+/hV1w6qJAo3/aXRNAPyVTivmRw/SvH4zsC
         HB8/wWaX3kc2vO+qjLJDAHgS1Vr+/9C1mbhnY2xmPtt1NgRtPQGZw2rQ8OHW/XK8KfPZ
         +MEQ==
X-Gm-Message-State: AOJu0Yym+OKrSBDfZJf+zwFQs7Dw2B6aiVS5QkGqHvlu/53BfFFXTwIt
	iL2/C5GdMt6XiRfi68652go3Hm9zi4SiHhkVVC+OBtGnPP74NO+kyPeWvA==
X-Gm-Gg: ASbGncsW/Qth6dOnqwVNxSMaHKg252pzjP2Ajf3rY1vhJdx2vmsJcJ/zH7WQnLhcT7f
	p2GnkmIGtV9weNuGUvOdSNTdyoulfLR01LVpjt3/NZIvY3iahnS9lp7ZGqYoKMu/SrbFazaAkLw
	f0jtKjvIwTcIYgQSAtf4WZofkMxGBZO6D+5FR86uTD5YhzTiSbGdKJPD1G6kiFOVLPGxEAqcMbc
	x05bAJqT9ai0hqHGLAPQ11ktqbu1582d/z4QyzewmdbqO6k1GmTqrvXxb4SO22kQ5szrkWPo7Wl
	t63A6xh4saI8QldpQD/BU3A20c7cMP7VoW84+QMtz7kmB0LbzdKN9cnbZ/laoi/tSsmivLnP7wQ
	inx91cRXh3ThNuC9LsufL9M5f1RPtj0b0lX8V
X-Google-Smtp-Source: AGHT+IGkrKcChxGjdgDkygeMDql0BOqHuhIhJPtRsVYDlgUf4zPMOlErgopvMjyPRem0dltjTL8nFQ==
X-Received: by 2002:a05:6a21:9004:b0:1f5:535c:82dc with SMTP id adf61e73a8af0-2046a74a4d9mr505395637.42.1745609085462;
        Fri, 25 Apr 2025 12:24:45 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-73e25a6a649sm3667513b3a.109.2025.04.25.12.24.44
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 25 Apr 2025 12:24:45 -0700 (PDT)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 7/8] lpfc: Update lpfc version to 14.4.0.9
Date: Fri, 25 Apr 2025 12:48:05 -0700
Message-Id: <20250425194806.3585-8-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20250425194806.3585-1-justintee8345@gmail.com>
References: <20250425194806.3585-1-justintee8345@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Update lpfc version to 14.4.0.9

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_version.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_version.h b/drivers/scsi/lpfc/lpfc_version.h
index 638b50f35287..749688aa8a82 100644
--- a/drivers/scsi/lpfc/lpfc_version.h
+++ b/drivers/scsi/lpfc/lpfc_version.h
@@ -20,7 +20,7 @@
  * included with this package.                                     *
  *******************************************************************/
 
-#define LPFC_DRIVER_VERSION "14.4.0.8"
+#define LPFC_DRIVER_VERSION "14.4.0.9"
 #define LPFC_DRIVER_NAME		"lpfc"
 
 /* Used for SLI 2/3 */
-- 
2.38.0

