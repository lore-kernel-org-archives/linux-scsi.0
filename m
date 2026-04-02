Received: from mail-qt1-f225.google.com (mail-qt1-f225.google.com [209.85.160.225])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A56D2362143
	for <linux-scsi@vger.kernel.org>; Thu,  2 Apr 2026 07:17:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.225
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775114249; cv=none; b=gbgzrMkfblNIfq3lcP4B7VAdLvcdYGqbBp+xp5Hyzdo4ZiIL6jTZkQwiuYC22v9SLzSeR/o4yE7oHyVJyOjarEiA+6iDaUyXQokzSLj0agir2L0faqIO07U10TSpWMlG4+ON9T/NyC/QOggbPItv0nAg4VYUHwZdCim/5FqIns0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775114249; c=relaxed/simple;
	bh=2R2GMZ73Yol7gtDOUlrMhMWsyLM7lFI5nI31CwQKusQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PF8XX0FPpUjIT4rLQotAkDPIPw0QAjNXKboqPakYzBXNcjo/lyoWLKnbc7V48leJdcBy/C5jGNTLRF94cJFiWcfrJEtgZlNaXYsuKnLpkbRWfztiqisNkHDi8o5YPmba+7IUYWjoO5j8YyJcC2jVGNmOkOxeYAIAZoecb7Ct6is=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=iFIL3vyT; arc=none smtp.client-ip=209.85.160.225
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="iFIL3vyT"
Received: by mail-qt1-f225.google.com with SMTP id d75a77b69052e-50b3488fb31so25958451cf.1
        for <linux-scsi@vger.kernel.org>; Thu, 02 Apr 2026 00:17:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775114247; x=1775719047;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=goIi9ZqVO3x7phHT0vr2LplFt4y4whfau7BpPAyCJ1w=;
        b=mt8vWJH9emqK2JNcejmCkyrLbqjVmWauFEWz/aYdHueflmHztvzmIq7CxxJygbJal9
         j5HU2LocRa0ktnXQiyQ9h395mSvsr1nb0yEUsUtOd3bkTeIYeJcG+2Se8CA0H6hsy+HJ
         Rghqd1DfN7IW9jIUb1wmAs5o4ivZ4eaTQku6dWiYj5Mqa/6wwaQz7XpvrmBlWx2y80zG
         5tUD0VGhL7d0D17rY6T1wMgF17pyy6RIkoiEjo/cSPiGC21zS3cOPjVW7RJJfV7THHrb
         fPTtEwXWvUtGhqgzX3YwNUhPajQWfjM7AU8yI0nLlE1TKnEJqMsIkhM7oxdcvu4bmOE9
         CSXQ==
X-Gm-Message-State: AOJu0Yz4mKdnppGOK09VFJLP0WofCNyHkc7fTQdkVon3pKRqDxFz7PvC
	nmGSHXP1rFfDp8vmFDh6TSY/3TEu394kqsH8vz2QtZ5ibrwoR+ee6aYOA28vkHb8uupcPdKpkVj
	SRp6vH85ZH1oKULJswlxIR3I9Z5URddguWPxcEDJniy703oMTVUVC7Q3FZ78/c/rRm6mvXOjVFE
	UzACP9TWDHg/BBIlF3vzVmaCtittdEYuH7sefYj9I6A6lZulYfp6VtOW9bP4CNlEKDKeC5Vdt6Y
	Gr0zdtl/nPIrxO+VFY=
X-Gm-Gg: ATEYQzwWquXQiYffHaA/K6gUbALIRTQPYGcKHirSSsdfmITt2EA36wlzAVph0YNMzSK
	errNeesQlhCQZOtMR2h0726eVydwgCNqg9r1NiiDfgVTEA1ImYXm8j6tjKViMojda5JwT1VdaCN
	nL0dmMZRUferzR7CYw14yXa+YBcIk0BZWa5uVaDxdGchZP+csP8RcFfBpoc/uqsMWoD/eODrSwq
	enj3QngkY1ogQ9otVlyX0KVpj4Q0MWD9vOjeuZr1NRHH7Xcb5WIRwbQ4n6dRSy+gomwtTmveYFR
	grxOfx8X+2xpQ1HoydqyrFC2ZnnGFilatTKprRvFjLUWMmfYrDQ3IYXYd0qFTZmkUDXI9VXQJcE
	wbtf+oemfQeO4NqO1deJWX/jBQ6JsG14VuIbc6sh5E2yYZjZ13siHTBMrbHH/DmO5W4Zxw9Y95s
	dfkY6EytlzI0/ZXzIAokdBb6dsDofnnr1quH03cKyY+Zb74R0Ug13PevWG
X-Received: by 2002:a05:622a:835b:b0:50b:3128:9916 with SMTP id d75a77b69052e-50d4fac4c65mr11716981cf.18.1775114247500;
        Thu, 02 Apr 2026 00:17:27 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-15.dlp.protect.broadcom.com. [144.49.247.15])
        by smtp-relay.gmail.com with ESMTPS id d75a77b69052e-50d4aec58d0sm1461271cf.0.2026.04.02.00.17.27
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 02 Apr 2026 00:17:27 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2b2489af602so5923295ad.1
        for <linux-scsi@vger.kernel.org>; Thu, 02 Apr 2026 00:17:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1775114246; x=1775719046; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=goIi9ZqVO3x7phHT0vr2LplFt4y4whfau7BpPAyCJ1w=;
        b=iFIL3vyTUGzbnnVslATYFihJ8ZiA+7vr9plfccVTKwUJW7GkQx9auV6fSwNsjAhobk
         Rq9b6PCD2ERrtwPdpf12JUnANe3oPi05qgcURpRHyClkY5CeMYb6Hkts7w15PHE6D07+
         fOjrnfIc2Fwu1QcUScPBuxuhPWqfNQtbvr1uQ=
X-Received: by 2002:a17:903:1b4e:b0:2b0:51be:f9d7 with SMTP id d9443c01a7336-2b277e2cdb1mr13499535ad.18.1775114245732;
        Thu, 02 Apr 2026 00:17:25 -0700 (PDT)
X-Received: by 2002:a17:903:1b4e:b0:2b0:51be:f9d7 with SMTP id d9443c01a7336-2b277e2cdb1mr13499295ad.18.1775114245334;
        Thu, 02 Apr 2026 00:17:25 -0700 (PDT)
Received: from sumit_ws.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b27477c54bsm24612825ad.27.2026.04.02.00.17.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2026 00:17:24 -0700 (PDT)
From: Sumit Saxena <sumit.saxena@broadcom.com>
To: martin.petersen@oracle.com,
	axboe@kernel.dk
Cc: linux-scsi@vger.kernel.org,
	linux-block@vger.kernel.org,
	mpi3mr-linuxdrv.pdl@broadcom.com,
	James Rizzo <james.rizzo@broadcom.com>,
	Sumit Saxena <sumit.saxena@broadcom.com>
Subject: [PATCH 1/3] scsi: use NUMA-local allocation for sdev and starget
Date: Thu,  2 Apr 2026 13:16:35 +0530
Message-ID: <20260402074637.92417-2-sumit.saxena@broadcom.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260402074637.92417-1-sumit.saxena@broadcom.com>
References: <20260402074637.92417-1-sumit.saxena@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

From: James Rizzo <james.rizzo@broadcom.com>

Allocate scsi_device and scsi_target on the same NUMA node as the host
adapter's DMA device to improve memory locality and reduce cross-node
traffic.

Signed-off-by: James Rizzo <james.rizzo@broadcom.com>
Signed-off-by: Sumit Saxena <sumit.saxena@broadcom.com>
---
 drivers/scsi/scsi_scan.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index efcaf85ff699..b98c5b7d8018 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -34,6 +34,7 @@
 #include <linux/kthread.h>
 #include <linux/spinlock.h>
 #include <linux/async.h>
+#include <linux/topology.h>
 #include <linux/slab.h>
 #include <linux/unaligned.h>
 
@@ -286,9 +287,10 @@ static struct scsi_device *scsi_alloc_sdev(struct scsi_target *starget,
 	int display_failure_msg = 1, ret;
 	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
 	struct queue_limits lim;
+	int node = dev_to_node(shost->dma_dev);
 
-	sdev = kzalloc(sizeof(*sdev) + shost->transportt->device_size,
-		       GFP_KERNEL);
+	sdev = kzalloc_node(sizeof(*sdev) + shost->transportt->device_size,
+		       GFP_KERNEL, node);
 	if (!sdev)
 		goto out;
 
@@ -504,8 +506,9 @@ static struct scsi_target *scsi_alloc_target(struct device *parent,
 	struct scsi_target *starget;
 	struct scsi_target *found_target;
 	int error, ref_got;
+	int node = dev_to_node(shost->dma_dev);
 
-	starget = kzalloc(size, GFP_KERNEL);
+	starget = kzalloc_node(size, GFP_KERNEL, node);
 	if (!starget) {
 		printk(KERN_ERR "%s: allocation failure\n", __func__);
 		return NULL;
-- 
2.43.7

