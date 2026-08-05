Received: from mail-pj1-f98.google.com (mail-pj1-f98.google.com [209.85.216.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE41F3EEAEB
	for <linux-scsi@vger.kernel.org>; Wed,  5 Aug 2026 11:14:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785928488; cv=none; b=WAya9qdDeo32RR/NR9LPEmHDqRIihDgmRPHtS/YEbcfnqdl4kWEh4hbDNjxiltr8PRuWMYZyvPsAhNd2W42fUcHhKMlJqwNC4kwO5/IHm0ml+hpc3Xju5Ki3i97bgzrhI5QLTuFgN+keoN8JSex/v687GU0CFrSDotXCCMAAgzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785928488; c=relaxed/simple;
	bh=YS8G7xFDIqSMALlBBgwgzLsTXiltwDXlZ/lvGyRz+Z8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fk5565vg6kFXOgGyYYdNvxbJSFmjUiG18hOglomOGE/EK+5MVyrUU9m7I6H+8EfVNCPxJmxKy3gZA0IHIN9NBIjEydZZKqF1/X8I/V/ZugdX8bkuaeJvMoPG5zf+DPN6mL/bgFxwjR1ICaMyGwzyLFHS435B53rc/R4q1ujgJ+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=SJi7cSUP; arc=none smtp.client-ip=209.85.216.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="SJi7cSUP"
Received: by mail-pj1-f98.google.com with SMTP id 98e67ed59e1d1-383b4a3755fso821471a91.3
        for <linux-scsi@vger.kernel.org>; Wed, 05 Aug 2026 04:14:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785928486; x=1786533286;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=hh20xApue4fwWsHR+zvFD8axJLUqwcBrKIhIHy4dJXs=;
        b=hgObrLBPC1l5ulGh4fBjIVR8laKj8iZ5419B/RLvEIUIPN4HJORGgk2loXfleIFUB8
         +ONSF+HWvnksy67WTpGbDO2nqBWsNXLAHFhzJRUPyEwH82p6ItxQNI01jjUrYmMSiDYs
         a0fPei3sBxkehHRLQGuuh4/TEfrXiNxoEkvonDxkDs8UakixatLycYUqjQWSY+vqWDtK
         RKB177BaTu/rwbATSoDTJMwU27js0U9LsBTW22rDs66cc1WOujrkLeKcazvNXbji2WMK
         XWs+EHWjlM8f1sGu/O8oaGyGp6QGZdh/0Jj9FAIWQyx2pxxQDiamLSb15Hf69yq9Nsyx
         4vWQ==
X-Gm-Message-State: AOJu0Yz4H2AgDzq2HYh6U/Ac6ro23g8AwzUk53gIVlbhm+LFT2BGg29y
	Xy0xGORRuHr7MyWzUpQGXcy/aCFFxDHTmcZMwINy2DRTKrZSpvzcfszEd1avojCfYzpAd4xmWBl
	ZAU7DR1Zgjj0YM1I2+mhEe0FfN5OVZSLYzUUIDlD4sqItRzP+nDeEfBCF9NVLdGUPM1GgD6xhuA
	8D0YfO+jS4lPRRctmZn3j5gODJTQrn7kbpWFY+O5agdRvpaLDVIaMsAoOQJszW/p8RnDV/j2rC2
	hxR/2OVcSCycFkY
X-Gm-Gg: AR+sD13af5gU8CY5d+p5dOf/RlTtzmktZqyXmopMNRFisuB8OvDchc/P8Qc+L3GdU6J
	QmNWn1f9vu16GwuHZ0/1UTgJ19YDjFa7bzy1Ygd5XdLhghUNyoIi668m+sb0WxjAm2AZNr89Ai6
	gyqZtCvhL2jZEp2kQaQ2aX9cf/5VNLcMdTKWuZ2UQ0n7IsDoWPs2AOxcJxNeiuPUnB7lSkg1O7C
	O0e5HbdWKAUnuziI/vMJjgkRWPbxdRriBoFqXk6nTAlVKJTijYaat8xMxw6WsrU2BImF1Mq0V1u
	e80i3nNRHLDQA5/W5/doSOvT49MXyX3O+eAoHfrmkMJc/2nm+oCTDbW6gDhI1h719jGtH/vIg/X
	IRZEHkzIpdCXOyhq5beUCO2qFCYnLK4h+b/OjsmmRJ+spi6qzObAe6SIvlxU/LtlDQb7fDMjJ/y
	rwIoH4l/B/+kzbYw4YsOJPRaKd1ZYak7aB+68=
X-Received: by 2002:a17:90a:ec86:b0:38e:bbf1:de34 with SMTP id 98e67ed59e1d1-3903c537a12mr6529004a91.7.1785928486091;
        Wed, 05 Aug 2026 04:14:46 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-27.dlp.protect.broadcom.com. [144.49.247.27])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-390392b0042sm785206a91.7.2026.08.05.04.14.45
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 05 Aug 2026 04:14:46 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-38ec0f510a9so1880760a91.2
        for <linux-scsi@vger.kernel.org>; Wed, 05 Aug 2026 04:14:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1785928484; x=1786533284; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=hh20xApue4fwWsHR+zvFD8axJLUqwcBrKIhIHy4dJXs=;
        b=SJi7cSUPAK7Um9lRjvZ4/0k/miulL9qwF48EatWuQ8o94/fGZOuhqZ0jy9GeOIt2EC
         hvylkFendFe07iWXFlzKVLK7oMQbmWEdPjC2KKFwmCUMtLeWHLH3OER06G2S21NISY9i
         avW8IaU4EIQNUtG7rUiLu3/MfDRfB6ZCzFLI4=
X-Received: by 2002:a17:90b:1c0a:b0:38d:f096:a1dc with SMTP id 98e67ed59e1d1-3903c58a715mr5967917a91.11.1785928484169;
        Wed, 05 Aug 2026 04:14:44 -0700 (PDT)
X-Received: by 2002:a17:90b:1c0a:b0:38d:f096:a1dc with SMTP id 98e67ed59e1d1-3903c58a715mr5967854a91.11.1785928483657;
        Wed, 05 Aug 2026 04:14:43 -0700 (PDT)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3158673b7f4sm16740227eec.17.2026.08.05.04.14.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Aug 2026 04:14:43 -0700 (PDT)
From: Ranjan Kumar <ranjan.kumar@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: sathya.prakash@broadcom.com,
	chandrakanth.patil@broadcom.com,
	vishakhavc@google.com,
	ipylypiv@google.com,
	Ranjan Kumar <ranjan.kumar@broadcom.com>
Subject: [PATCH v4 10/10] mpi3mr: Driver version update to 8.18.0.8.50
Date: Wed,  5 Aug 2026 16:36:34 +0530
Message-ID: <20260805110634.346670-11-ranjan.kumar@broadcom.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260805110634.346670-1-ranjan.kumar@broadcom.com>
References: <20260805110634.346670-1-ranjan.kumar@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

Update driver version to 8.18.0.8.50

Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi3mr.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
index 4d19a9460d38..d6e16707fd97 100644
--- a/drivers/scsi/mpi3mr/mpi3mr.h
+++ b/drivers/scsi/mpi3mr/mpi3mr.h
@@ -56,8 +56,8 @@ extern struct list_head mrioc_list;
 extern int prot_mask;
 extern atomic64_t event_counter;
 
-#define MPI3MR_DRIVER_VERSION	"8.17.0.3.50"
-#define MPI3MR_DRIVER_RELDATE	"09-January-2026"
+#define MPI3MR_DRIVER_VERSION	"8.18.0.8.50"
+#define MPI3MR_DRIVER_RELDATE	"26-June-2026"
 
 #define MPI3MR_DRIVER_NAME	"mpi3mr"
 #define MPI3MR_DRIVER_LICENSE	"GPL"
-- 
2.47.3

