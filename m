Received: from mail-il1-f228.google.com (mail-il1-f228.google.com [209.85.166.228])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 662002F7457
	for <linux-scsi@vger.kernel.org>; Thu, 13 Nov 2025 15:43:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.228
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763048607; cv=none; b=kdeBphLAx5ii6pzOVEQlybSIAS0szwQ32k/H+cLzSL/mtf6TA7bq2toZGeuY2dJcwiLc1nHXHIeNlQ/lb7emJtBHwAsW2D1R/H83t13OWds2VrxzacJW/74Q9zOJjiZN1f0331BQSauQNFiaZpTaY1IbhI758LFJmZX0oOOrPwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763048607; c=relaxed/simple;
	bh=4gTqVQAkS5clV8lTx19sCVjs+ND5denjrPwCOfDRjM4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EQ/2Hokiko4vH2784hbZRhsusbWZvLwmVPqL8rjU84corF1O8iDYPXwqRQZJXV0575kPXRKJqdifPX55BDcMiv2Pi94318345mKqHjSs6C70EWj6CDuJgjdZACOD4PeF9eYz3OnhM+4GBHZsKe8b/EK/YyaLBZmlCe6yKJxOa9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=Drff/xkt; arc=none smtp.client-ip=209.85.166.228
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="Drff/xkt"
Received: by mail-il1-f228.google.com with SMTP id e9e14a558f8ab-4330dfb6ea3so4117355ab.0
        for <linux-scsi@vger.kernel.org>; Thu, 13 Nov 2025 07:43:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763048605; x=1763653405;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9mA1Eom+AjatwCzgxDnE6XGvwJsS58zse14jaFvbiIo=;
        b=AtR0KWX4n0DGNzplgL6X2x3Xi2MFB00ltpqUq3eZZLzw+VY7yi5QGkFp5xxj62OGPo
         ZBHxDXpaMNMI0wzOHhqNGSIwFQ+4aNYugXzVPv10o7/R+u3hSDoI+g3ZdhllcEhBMAGf
         MN5VK908agTRM/SiSLpJwHuLy9YJ7Hl8H9jJ3hUlbHOo/mZyaIoRKaz9g2vnOQWuc4OZ
         w/QJOv8a/QmhiwNpBfQGss5bucKlFtQbsD5GWanx+8YJ+d/dFl07Gn2+mo8OmEhKqyhy
         5YgmXfdpDkk8fXoL3mZWW6V91yTn+Jo4EgGt/YALlxgY19TZ9Nx6HVvl6ij3q7sOlXGP
         Uy2w==
X-Gm-Message-State: AOJu0YzQNqw9FhQJYLX5/TuguxymewJ89jhPmbmTQQtVlCrPPBh8FRIl
	SXO55lzNdbc9QZGQefsUL/v7iLaIxoP5ZZ6krO2ns9JS7TiKu4vygyOcoBm3Eu56bqDkoWYeojH
	EKsjRlWfS+O8bVrFGEey/67rq4w/kjKJ39fhwWJt2Np9x+vIlJlDXrWcnoupHrqVPdbJpr4Id1M
	5B4i6GOYnoUTZtGBb19cGfbU2t8N3r45YntwS5kfys3Pb71T9PuuSe5J8dTRURpZjyB9Ogs4+VY
	b2nlqSqBgCsNPkG
X-Gm-Gg: ASbGncuTRZDfwbAeY6jeTCFNly7vE/Ni52mpou2MHWOiGVRp7N3rd8yBbqwqFwwsinR
	Zoq5WbvlOUKa7S00Ff2aktKJpbo0UtWQ8ncP7M/atvdovhX1sLy7znsIQSZ/3V58JdaU36M06wI
	07mTeawWtrG9PdIYJ7N11IHEDZLB3lZP7OvvU07/le5UG/d5cCYcGUosfcbVuWXyyzzLcAkav8g
	QVj/x50mjVipWJvprHI9TUcfxiIlC9twJHJ1hM00MCdimh16By02FCBbBJBOs9z29st4Nr8iE5A
	B5gCZTKyOc47gJLCwecOPxbvPb6pHxmmG36CceENHjop8C7PMVu7lPBItZOWz/FC/4QH1qaomn4
	Vgx7JvepDAweqW3sOf4h8kK/aDevh2sQlQbsM7dJxg3yfJxwNVsS2M+CpJ6e3OG6XzRuZnarw2k
	AFj4dkrcYZxXlLBaDSGR8GbSzeaMXPlyhfQyfj
X-Google-Smtp-Source: AGHT+IG436BRhcfqbYVSr+TODoPjObyFS7+ocik+uqXFSX/LVaX1K6xHOQO2d8JD312CD7lTxd4G7XN1mWpM
X-Received: by 2002:a05:6e02:3103:b0:431:d8ce:fa15 with SMTP id e9e14a558f8ab-43473cff331mr92098935ab.5.1763048605541;
        Thu, 13 Nov 2025 07:43:25 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-101.dlp.protect.broadcom.com. [144.49.247.101])
        by smtp-relay.gmail.com with ESMTPS id 8926c6da1cb9f-5b7bd266f39sm190750173.15.2025.11.13.07.43.25
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 13 Nov 2025 07:43:25 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2980ef53fc5so30044525ad.1
        for <linux-scsi@vger.kernel.org>; Thu, 13 Nov 2025 07:43:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1763048604; x=1763653404; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9mA1Eom+AjatwCzgxDnE6XGvwJsS58zse14jaFvbiIo=;
        b=Drff/xktGLdKYt/u80ZHxkCh02JibPjZTWpp4g/W6ZXNYUe5MQpzL8I46cBBITbSKs
         W+gOJ7wVmn2girm9MGkrEICwxfWTLIxwLPN+CXNU6RkPNbaDi2m9wbClXhoGPug7DUkJ
         AyA+fQpVARt5mqjWHN4HeFWMCY7LbUhb+UYXM=
X-Received: by 2002:a17:902:c952:b0:295:62d:5004 with SMTP id d9443c01a7336-2984ed83897mr94372085ad.26.1763048603677;
        Thu, 13 Nov 2025 07:43:23 -0800 (PST)
X-Received: by 2002:a17:902:c952:b0:295:62d:5004 with SMTP id d9443c01a7336-2984ed83897mr94371825ad.26.1763048603227;
        Thu, 13 Nov 2025 07:43:23 -0800 (PST)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2985c2cca66sm29100085ad.99.2025.11.13.07.43.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Nov 2025 07:43:22 -0800 (PST)
From: Ranjan Kumar <ranjan.kumar@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: sathya.prakash@broadcom.com,
	sumit.saxena@broadcom.com,
	chandrakanth.patil@broadcom.com,
	prayas.patel@broadcom.com,
	Ranjan Kumar <ranjan.kumar@broadcom.com>
Subject: [PATCH v2 6/6] mpt3sas: Fixed the W=1 compilation warning
Date: Thu, 13 Nov 2025 21:07:10 +0530
Message-ID: <20251113153712.31850-7-ranjan.kumar@broadcom.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251113153712.31850-1-ranjan.kumar@broadcom.com>
References: <20251113153712.31850-1-ranjan.kumar@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

Fix W=1 compilation warnings.

Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 5ff31ce0c960..e4e22cb0e277 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -843,7 +843,7 @@ mpt3sas_base_start_watchdog(struct MPT3SAS_ADAPTER *ioc)
 	/* initialize fault polling */
 
 	INIT_DELAYED_WORK(&ioc->fault_reset_work, _base_fault_reset_work);
-	snprintf(ioc->fault_reset_work_q_name,
+	scnprintf(ioc->fault_reset_work_q_name,
 	    sizeof(ioc->fault_reset_work_q_name), "poll_%s%d_status",
 	    ioc->driver_name, ioc->id);
 	ioc->fault_reset_work_q = alloc_ordered_workqueue(
@@ -3178,7 +3178,7 @@ _base_request_irq(struct MPT3SAS_ADAPTER *ioc, u8 index)
 
 	if (index >= ioc->iopoll_q_start_index) {
 		qid = index - ioc->iopoll_q_start_index;
-		snprintf(reply_q->name, MPT_NAME_LENGTH, "%s%d-mq-poll%d",
+		scnprintf(reply_q->name, MPT_NAME_LENGTH, "%s%d-mq-poll%d",
 		    ioc->driver_name, ioc->id, qid);
 		reply_q->is_iouring_poll_q = 1;
 		ioc->io_uring_poll_queues[qid].reply_q = reply_q;
@@ -3187,10 +3187,10 @@ _base_request_irq(struct MPT3SAS_ADAPTER *ioc, u8 index)
 
 
 	if (ioc->msix_enable)
-		snprintf(reply_q->name, MPT_NAME_LENGTH, "%s%d-msix%d",
+		scnprintf(reply_q->name, MPT_NAME_LENGTH, "%s%d-msix%d",
 		    ioc->driver_name, ioc->id, index);
 	else
-		snprintf(reply_q->name, MPT_NAME_LENGTH, "%s%d",
+		scnprintf(reply_q->name, MPT_NAME_LENGTH, "%s%d",
 		    ioc->driver_name, ioc->id);
 	r = request_irq(pci_irq_vector(pdev, index), _base_interrupt,
 			IRQF_SHARED, reply_q->name, reply_q);
-- 
2.47.3

