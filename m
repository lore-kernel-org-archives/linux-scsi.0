Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C007012D1ED
	for <linux-scsi@vger.kernel.org>; Thu, 22 Feb 2024 21:45:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708638350; cv=none; b=RSsoB2ouV2YXm7Q7scSXyiQyr5GfqJr4+fxkyRJSBTGtTQCCVqFfVXmu20zU6wNDciE1FyQvnlW8Dw5n0Dxc8mfY6PntYVuGNqeEhvZ5f4iq99dzpw6xGInmNrz0hq3oifZ0tfWx2H3QXOcrpPQ+v57UdONvpEjuzPubuyl3jgw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708638350; c=relaxed/simple;
	bh=1me+1Iv1gWQ+ySDhaIkrWsKCsTYqu1di4VIRAFR4faQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J39PidbGh+gDEX/XHATqzMlz/EBctNewzgh54SQfzt1Poj/IrvOTwIjdX1qgMeqkfRpjUVfgeD38zBrOyVISF1y5T/DwYB2AKK9dWL9ritKY2/k3ZOjRzJSL2WGvC3MsWRi8UpkciX5m4pxTMHgrAbLuhYjuD8KFx+n7M1KjGb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=acm.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-6e332bc65b3so91074b3a.3
        for <linux-scsi@vger.kernel.org>; Thu, 22 Feb 2024 13:45:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708638348; x=1709243148;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=i3J+SA4hd8ZssMKvGLhLa01/X8dHvroLM2Zuh1UtpU4=;
        b=hKxPQUkUg3M5BZSkIGbBHuIreZYfvd7uWwkC+g/Iqf4Rr3ZDdkqTiaPVNF1Cbd2st5
         prem4bxtMyZKjkisMyVVNBfqqmuZ74b0SMMUkgxxDveFlyfPDBtwlapdQvZWy/YvxotJ
         W5wOi60ml4aN4U17kXjfrvCcpBMUggiIKtMFoRjReoE2P+idRqf+dToFGXXfMjCpC5Hp
         cQlMJ2dmc8WFS553ebutffzVy0uUXVVVkydidBS9zetPkyj5MDpSB05u+YElV9z8MfcT
         fTroer8KlVNgG5sexe+de0eu0BDHSEOsflfhCqVs2vTa4j/oEs7XQlhZHLdbNT2w7S5B
         gfuQ==
X-Gm-Message-State: AOJu0Yw2TG1EuSvF4E1b+KP+2CV7WYClUuByXH34BrsKzpQviVijJ8L9
	pB3Mr4L/P5r8LCL8D1Pw0coZlaeTn/BwhxxjR/THjwi+MwwrAY4q
X-Google-Smtp-Source: AGHT+IHbobqYv/wVir22xNwsC8GjqciZtOOKVbcKhAEvhSjmsmv7kAsVfBvHbud/s0ACGL67qzxXHA==
X-Received: by 2002:a05:6a00:1988:b0:6e1:4085:dd4f with SMTP id d8-20020a056a00198800b006e14085dd4fmr184245pfl.25.1708638347942;
        Thu, 22 Feb 2024 13:45:47 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:0:1000:8411:bcee:4c5d:88b9:5644])
        by smtp.gmail.com with ESMTPSA id a1-20020aa78e81000000b006e414faff99sm9598203pfr.180.2024.02.22.13.45.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Feb 2024 13:45:47 -0800 (PST)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Daejun Park <daejun7.park@samsung.com>,
	Kanchan Joshi <joshi.k@samsung.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Douglas Gilbert <dgilbert@interlog.com>,
	"James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v10 08/11] scsi: scsi_debug: Allocate the MODE SENSE response from the heap
Date: Thu, 22 Feb 2024 13:44:56 -0800
Message-ID: <20240222214508.1630719-9-bvanassche@acm.org>
X-Mailer: git-send-email 2.44.0.rc0.258.g7320e95886-goog
In-Reply-To: <20240222214508.1630719-1-bvanassche@acm.org>
References: <20240222214508.1630719-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Make the MODE SENSE response buffer larger and allocate it from the heap.
This patch prepares for adding support for the IO Advice Hints Grouping
mode page.

Suggested-by: Douglas Gilbert <dgilbert@interlog.com>
Cc: Douglas Gilbert <dgilbert@interlog.com>
Tested-by: Douglas Gilbert <dgilbert@interlog.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_debug.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 67a8e6243e5e..b544498324f6 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -43,6 +43,7 @@
 #include <linux/prefetch.h>
 #include <linux/debugfs.h>
 #include <linux/async.h>
+#include <linux/cleanup.h>
 
 #include <net/checksum.h>
 
@@ -2631,7 +2632,8 @@ static int resp_sas_sha_m_spg(unsigned char *p, int pcontrol)
 	return sizeof(sas_sha_m_pg);
 }
 
-#define SDEBUG_MAX_MSENSE_SZ 256
+/* PAGE_SIZE is more than necessary but provides room for future expansion. */
+#define SDEBUG_MAX_MSENSE_SZ PAGE_SIZE
 
 static int resp_mode_sense(struct scsi_cmnd *scp,
 			   struct sdebug_dev_info *devip)
@@ -2642,10 +2644,13 @@ static int resp_mode_sense(struct scsi_cmnd *scp,
 	int target_dev_id;
 	int target = scp->device->id;
 	unsigned char *ap;
-	unsigned char arr[SDEBUG_MAX_MSENSE_SZ];
+	unsigned char *arr __free(kfree);
 	unsigned char *cmd = scp->cmnd;
 	bool dbd, llbaa, msense_6, is_disk, is_zbc;
 
+	arr = kzalloc(SDEBUG_MAX_MSENSE_SZ, GFP_ATOMIC);
+	if (!arr)
+		return -ENOMEM;
 	dbd = !!(cmd[1] & 0x8);		/* disable block descriptors */
 	pcontrol = (cmd[2] & 0xc0) >> 6;
 	pcode = cmd[2] & 0x3f;
