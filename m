Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC9B03085C7
	for <linux-scsi@vger.kernel.org>; Wed, 18 Jun 2025 18:56:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750272969; cv=none; b=rjktGbe5PTFq9w8nXQuHUYnhqu3SNKoinOyh6ja2ocG774aWZM5BvBFXX6tJM5nR6shQ25f27A+HGlQH+N0VyhXYezDFhcOxqAzdfyGtfefZEy7iTIvrCmk9KDaPHY0WKBVvAnY/g7syd2QPHsU/z4KE99zTf/Q5fOOrXxYTbSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750272969; c=relaxed/simple;
	bh=ClSmxWPMwnoXNRBCVfYtGk32oeYun9qO5pz2jYHHGKc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=fuDp7slsk0L82hIKDp6990HFn3P7JE7ApzdUAtTxFB0X55bcXljzMgnxdp60A2YV0N1cHWC7hb9Qr3UOmfg3KIAxJqoSVxuud038UoKDXLILl/gfhIswo0TxKVvO+16U3nPCdL3mKVEsu+NUp1MI5+0W1DKEYCVNXKmcwDLLlAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Lzaf8WQn; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Lzaf8WQn"
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-748d982e92cso1340198b3a.1
        for <linux-scsi@vger.kernel.org>; Wed, 18 Jun 2025 11:56:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750272967; x=1750877767; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=d7wMqzLtAQ/D3AvrhGBANGvTV+XOH7rvyvWnciP+vS0=;
        b=Lzaf8WQnJdhra/BJ5bsvqiZeXx4L0PMyrBAvnM8wA3MMfh72yMaz8vpg5LV9kEhEeU
         /7kPKRT3MVGCQaXc5LxyEFqwcPmnhIlBxzuWeyRfn8F0z4qUCGRyXrL1i7W4PfVkyamo
         O09EY7imv8Q/LSOYv6lgoW/Chbb5m4sv5l1SyiUtdWo0w/MCq0uigcUwLRQ4Eu+EK/kA
         K71yY4beTLB0HBpzSlFLNhgicaotYt3xzFP49sj4AhZP3FwQEliy7zrc4eKsQ+CGe/fZ
         j+xlkHGjfXb5n82K4/Ol7qSVl1deM+kCsn8k/x9IxauPLGvBPObpZCTza3yCRIzKo2HL
         ltLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750272967; x=1750877767;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=d7wMqzLtAQ/D3AvrhGBANGvTV+XOH7rvyvWnciP+vS0=;
        b=TPTh7A2H+8MiMJCieXjkdHDAKOHHYlc8xfXjqIrzXFtCt2tD9oE4krX2PYCTPQNDsz
         DuJ0sEtCHPKp+BYAa+D5eKRKAjguX+ymWIdwSW7VvTx9IEg5JhFX7ae2CbRxzUWXlmpH
         GS43Vbne7vXc5y9eCcQt7YRqfi41NhltOblgoTrQW2SK9GsMZoohQrRTqTWy1ylwXYBH
         I2XNlhvW91Rq8FCPMYJ1bJvaGO3+RiD8RSTo/BXe8Y6APv0/mI0T2BuQ5CKCsTq5CNYs
         7mOe3XimAhP3jFQKUoRJqxo9Qm10ZhW5PKOBLKjjIaNlNF7pkEuSD0c+1EpPYev04WTr
         gQcg==
X-Gm-Message-State: AOJu0YzLyWiVMTyJbJ0xVAG+P5b4kFRVjID4PV/OL8ROJyEroZz5TRJE
	JBl22YsaH8o3OcqzNg36f/aJMqxtoDjWj40yDuRPwr9QKNnM5pKQoubJwlSZQg==
X-Gm-Gg: ASbGnct1/y1VzB1bIMIDn0A7fPwI9A6QOtzxM2BOTUMf7GPUpDdoH08nHjxGNmWTTw2
	tus2RvCPPLYiwNM/jTfMkkxWpBV1cs4LazlmKRchijGhzr24ERVpSnv6g6vr7zlVufOTzXam9GN
	dJClcpjJhCd0B32BVLANHQoyVxCh1atXVEJ4gIsNqjYAYHvRaiRMC4WK2PV+0l991FexZriKWIk
	lUHLeqmO83XmOHPcIqImTjJ6SeYgcXi7wUnFPxXWaWExgWubHXI/m0J0hbT4Ty69SNu+IrnPZAM
	+V1jo+8NE+DNt8Vi3th2SIdN824yqHVEmyKFJgmPbEYqaJ+fmbRNd9c1BArvHueEu7fkuPr8mTn
	QG3m6iQgEuW/ajGj/+3n5CnNVKmoZ97bQ+U6Auv7dvNY1x1g=
X-Google-Smtp-Source: AGHT+IFY2UYxnGKfw6I8zrXDHH+35bK7p+4d0HfrgxOI10KhrTuJLTK5M9DI7EAoPy+A1qFiBFNjdA==
X-Received: by 2002:a05:6a00:1989:b0:736:4e67:d631 with SMTP id d2e1a72fcca58-7489cfddacdmr24686959b3a.23.1750272967075;
        Wed, 18 Jun 2025 11:56:07 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-748900b75a8sm11798834b3a.133.2025.06.18.11.56.06
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Jun 2025 11:56:06 -0700 (PDT)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 02/13] lpfc: Update debugfs trace ring initialization messages
Date: Wed, 18 Jun 2025 12:21:27 -0700
Message-Id: <20250618192138.124116-3-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20250618192138.124116-1-justintee8345@gmail.com>
References: <20250618192138.124116-1-justintee8345@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Initialization parameters for trace rings used in debugfs are sometimes
automatically adjusted.  This patch corrects and updates the corresponding
log messages.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_debugfs.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_debugfs.c b/drivers/scsi/lpfc/lpfc_debugfs.c
index 3fd1aa5cc78c..061a5e4e525d 100644
--- a/drivers/scsi/lpfc/lpfc_debugfs.c
+++ b/drivers/scsi/lpfc/lpfc_debugfs.c
@@ -6227,8 +6227,9 @@ lpfc_debugfs_initialize(struct lpfc_vport *vport)
 					i++;
 				}
 				lpfc_debugfs_max_slow_ring_trc = (1 << i);
-				pr_err("lpfc_debugfs_max_disc_trc changed to "
-				       "%d\n", lpfc_debugfs_max_disc_trc);
+				pr_info("lpfc_debugfs_max_slow_ring_trc "
+					"changed to %d\n",
+					lpfc_debugfs_max_slow_ring_trc);
 			}
 		}
 
@@ -6260,7 +6261,7 @@ lpfc_debugfs_initialize(struct lpfc_vport *vport)
 		atomic_set(&phba->nvmeio_trc_cnt, 0);
 		if (lpfc_debugfs_max_nvmeio_trc) {
 			num = lpfc_debugfs_max_nvmeio_trc - 1;
-			if (num & lpfc_debugfs_max_disc_trc) {
+			if (num & lpfc_debugfs_max_nvmeio_trc) {
 				/* Change to be a power of 2 */
 				num = lpfc_debugfs_max_nvmeio_trc;
 				i = 0;
@@ -6269,10 +6270,9 @@ lpfc_debugfs_initialize(struct lpfc_vport *vport)
 					i++;
 				}
 				lpfc_debugfs_max_nvmeio_trc = (1 << i);
-				lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
-						"0575 lpfc_debugfs_max_nvmeio_trc "
-						"changed to %d\n",
-						lpfc_debugfs_max_nvmeio_trc);
+				pr_info("lpfc_debugfs_max_nvmeio_trc changed "
+					"to %d\n",
+					lpfc_debugfs_max_nvmeio_trc);
 			}
 			phba->nvmeio_trc_size = lpfc_debugfs_max_nvmeio_trc;
 
@@ -6317,8 +6317,8 @@ lpfc_debugfs_initialize(struct lpfc_vport *vport)
 				i++;
 			}
 			lpfc_debugfs_max_disc_trc = (1 << i);
-			pr_err("lpfc_debugfs_max_disc_trc changed to %d\n",
-			       lpfc_debugfs_max_disc_trc);
+			pr_info("lpfc_debugfs_max_disc_trc changed to %d\n",
+				lpfc_debugfs_max_disc_trc);
 		}
 	}
 
-- 
2.38.0

