Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4353286891
	for <linux-scsi@vger.kernel.org>; Mon, 15 Sep 2025 17:39:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757957977; cv=none; b=FPYxk3lQgjcX1kbJz0uH/u9q/DFQkzZ6IYTC5iG/tB1vgc4JlBJatEdZH6pMmzdWfaIZ2Tp2D8+hwT6FNZgZpp8M57AmqT0O0H+2jtEi1BMOQdXRJg/rww5D3YKY3TtDyBM0kFt4ge4N6a/0zv7KzsFKWGbTOxEQbBy5CnCzogM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757957977; c=relaxed/simple;
	bh=aRkTPad38ybvCXoLeRIKIp2UGjvmmlVm4pGiMIM+Ey0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=TWHaMycM95z0jfWPoGaMcMovrcW9xMjO3UzOke/ABQt/lX7D2DJjH+Xx5oae154IFklwRxidrfx9HRLfQDzkFnlRa1nzl16PiznIieX21mNLCHnWqZS6aQ6QvyUTg0dn56EY9cQsHDgRXZqZCs26Sha3MD6+SRkBOckRu4DDu0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WEBcXB+Z; arc=none smtp.client-ip=209.85.219.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WEBcXB+Z"
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-777dbedf6f0so11570996d6.1
        for <linux-scsi@vger.kernel.org>; Mon, 15 Sep 2025 10:39:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757957974; x=1758562774; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sJO/D8MJibsb8c/+xLiFsXY+BhEfZwvE6GNu1m+9yr8=;
        b=WEBcXB+Z7pk/2HaS1Ynd+FYFn620QEvN/9zoXGM9qQg67s7qXpM37jciItuyiFAtpk
         RHu+6hwqWIYF9ybkfpJ/swjfSa2XzrnGss0IvTSnQaoHqgnHGQnYmihqgK58bLM2CYaC
         GkFwxg2rHwrlSQg3VLK3jjTx3DTgDoZb8HF1tGquF/2dwVO23rGOcvQ/78+81NKKEPhC
         gPw/alxW8Kj4GnU8AuwhPice+YgZyi7JUBqgYlDwZs107d+tudrsy7u886sQ8yv+zTSU
         1cQDwvUKVIXfFfP/C8+ZnxZ82js3+MfsbeeNLrOUMzDah/UQjHfmDiINBXA4vej4FMoR
         HfrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757957975; x=1758562775;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sJO/D8MJibsb8c/+xLiFsXY+BhEfZwvE6GNu1m+9yr8=;
        b=JRUp1lq0SJtZw/JkJoD7gxahZUIIVQFFYhxU6Xhhhp+2THZJBtklYyepvVi6sudTKF
         0xkVM9gGGtaTdFKZl4ZSptzUUiQKjev9G9AwBLrVTJbaG7/a/FMQp86KLewGlEy4SG9r
         W/7KxFgKbityfQ2B1hGgV917HdgN3mi9Nxiqbrnzddn1wdRRZL3GXdnZ4TT/ft0c7Hes
         BKKlmP4FVdU7qa8iW//lsrD5WMcihnM54xLI/JeqMY7DAoybdZUWWilsUrWmjXC43kv4
         2/Zh88gDttk2F8hgjzfb+YHbG/ZFusfz8fEqA+797Tcz1E2unGxt18lJqC5YIs76OzK+
         yktA==
X-Gm-Message-State: AOJu0YzF4+CJeLzbc4ndvymHkcxKIqJhwSNafU1c9abJZH6WZkA2e64r
	W4Rk1wNMixQ4FIXqw6OE16eQhi0QRi3/p6b/6dVJn0miYLRMMlPoB6ws4KgvhA==
X-Gm-Gg: ASbGncuKo5CM20nh9XSrNosKBDWjY9xMar7AFTYg2kteYODXI5trAGTbmBz+3zVlNeM
	6e50zqYbHalef/ZxobllR1S22hl2izLoAoV4WLW3446fWBtfewuunSw+XXUp69ORGyjPzpEPoe3
	XGpMl5ZVk/5WL2FazXITRkOW5rzlBZy/tRqq8PQ5Px8yOx7n1PmE3CeZhPfqLEOBBJ/CEhKovJr
	yx1IXfd0QXNZ208WZZKPlQa5MUAV2DkXNSAoEM+7Nr0AjYIwIs3ISVN7rJSsNWMBb6yUf0giAQN
	MwTd+VS6qCbV0iC0ajBJgxdvFGlw2WrksGSPJUX8Uastep6SCR+nQU5cTSwFHOloD92O49piuzE
	8b5c9SENW+Gk2ifU+MsDzi73EJV9o4I+RgY1puYP9oekpDAqdAwUR9srb3pVj0V+9zDqiKRZhnb
	XUO82cSOjGNtMfahPV2g==
X-Google-Smtp-Source: AGHT+IHTBpscpDgfT6vvdIwlYnoAHLMPoEHpgAFmJP/n+q6MFanA3BO91sFs0ZRZYBjFN3Ii14cDdg==
X-Received: by 2002:a05:6214:1bcc:b0:742:90e:d904 with SMTP id 6a1803df08f44-767c4012056mr192622636d6.50.1757957974413;
        Mon, 15 Sep 2025 10:39:34 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-77ef70bcc4esm29710976d6.41.2025.09.15.10.39.33
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 15 Sep 2025 10:39:34 -0700 (PDT)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 13/14] lpfc: Update lpfc version to 14.4.0.11
Date: Mon, 15 Sep 2025 11:08:10 -0700
Message-Id: <20250915180811.137530-14-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20250915180811.137530-1-justintee8345@gmail.com>
References: <20250915180811.137530-1-justintee8345@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Update lpfc version to 14.4.0.11

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_version.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_version.h b/drivers/scsi/lpfc/lpfc_version.h
index 9ee3a3a4ec4d..31c3c5abdca6 100644
--- a/drivers/scsi/lpfc/lpfc_version.h
+++ b/drivers/scsi/lpfc/lpfc_version.h
@@ -20,7 +20,7 @@
  * included with this package.                                     *
  *******************************************************************/
 
-#define LPFC_DRIVER_VERSION "14.4.0.10"
+#define LPFC_DRIVER_VERSION "14.4.0.11"
 #define LPFC_DRIVER_NAME		"lpfc"
 
 /* Used for SLI 2/3 */
-- 
2.38.0

