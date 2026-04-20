Received: from mail-yw1-f225.google.com (mail-yw1-f225.google.com [209.85.128.225])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6E1039D6DD
	for <linux-scsi@vger.kernel.org>; Mon, 20 Apr 2026 11:09:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.225
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776683376; cv=none; b=PPp4wpprAAIujDOUxS6aCI+pSjF53jfCWKJ4QblBY81WliU6wq622VMBJNYzrCWIl47wXN3XGhVvofWj7Y552b1GXmv4nwkD2AkxcWAqevF9750ZsPeTURMAkrEKCXdzz1AukJjYOa5VF1f1F3YpICgQSsn51cHQqqqfLMZJhOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776683376; c=relaxed/simple;
	bh=KvosSvUYYt87Z7DauV7Mb+cE9OHUaVO0rJKoqkbrhKk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hooHtTWamyMKhpGHmLPKfw5347VrObiaEXiShI5Fg78r5R0qk8bYCGUnltdTK9IbArdb7RzaZW/OhfTKgBoZw+ApoomkJ8ngU7uJ9rTVq+C65WdfZYkMw+AKMBcldZOe0X3I2RXHnVVMvbrxL8jZLUZCkAzLNzciArlkeDrvpJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=M1nvyp/R; arc=none smtp.client-ip=209.85.128.225
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="M1nvyp/R"
Received: by mail-yw1-f225.google.com with SMTP id 00721157ae682-79ee5037d44so36183097b3.0
        for <linux-scsi@vger.kernel.org>; Mon, 20 Apr 2026 04:09:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776683369; x=1777288169;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EvtElR9jgLe1msoqA+SsekbRWN4DGaUCVyyMSUvV2mk=;
        b=Rk5XSv3a4Knt5r9E+d/rWgKmfRtVKR0Q2lOUj+MruTDECOwKj3UxIwkWKDIG9sV0/4
         Shmmk7lV9ajsrngnydpx3rouGNvh+j1QXFHiOiG0B3QqrSiitDWKJhbtqIHEmgNVKDT6
         LsCVWdP0JXntDuQDgJjMtwYSUNgnzQp7JzAZB+6dnmN1jKguH5jdHWfzCMU8SS/K1s/4
         5A2B3RKQSrkltAqGDn7NNlYouTvna85GBzcbkbAsqvhw0BZNOLZ+6ek4C1CrGD30Pk3n
         il8XxtK/wsNzfMGqbOYGii5ajva+nNbH5BCsH3hfrRPWNZWjw6AkC2xajOc83MAw5A9x
         q1CA==
X-Gm-Message-State: AOJu0YxmFGSmHgpLrIhxqSjyne+RP9jNAuFzkckCtOcMzuFefZPMOfG6
	ZqN/gkj/czpSEeeZnohw1WJHdwkvn9TAqy025P1/HhWRwTnqcDyg3PZQBPKf3B5NNLDNAPwthn0
	tVBfHXziAFoiyd95AwGJrgikPuymMAxTxjqJQ5Li6Z1s9IhwUdohy6Sn+Ql+6hPmK6Znn9bxLR7
	pmHr9nJnXHa9lgGhtsHlgU7tBvUTTBVlDPlkTbry8N0R1LNItqHhypeVpc9aw/hkUm++IqU9KlW
	VAHTvJxbvPHXcx3
X-Gm-Gg: AeBDietFg6Kyjl4KElb4VdxpQM21FRJ2/6djuAIyl5firKJgCUl5zjzbPwypFHTvRTL
	BnQoClgGvB4jCpLLSGu5MkAq5Uei5bdFkk+RiPk3JDdHs1R2VuDU0lZUxB8c1EvFJM3ZqFEraXC
	WLdVsIizKz1ZVZGIBkKSgDHuGU4h9RR18lfqRTF6lXPlFsIXzncFXq/5bjpCM3VnNqbKC1mC8vZ
	0EVSIhwFzpnsSYyddFNQx9Khp3lfDDMRTCNHw/qiEr0DrYsX+A+GexR5czSb5PzCE1MEFTfVFGT
	QQGmTf2EO8vTdSNXwe2LjT9Qg8nQSxj8ivcKF+tr4d8+OEPCPX4Hj51K3TR374otSqoTMQBAjbo
	YdrUp+N9po5Q0xBhdydhmoXBn0XOZqRJhmnfooffs6CHAIyiW/8dk3HjEmm7BTnWaKrQjyDRWGn
	gGjXFDaMb+ct0xbJ0Cu4Y+Gd1Nbyf49TO9O3G043DPyLz7/+Of5ak2E0GgNxU8KDQCNqI=
X-Received: by 2002:a05:690c:e3ea:b0:794:c6fb:5f2c with SMTP id 00721157ae682-7b9ed275da4mr92627327b3.4.1776683369543;
        Mon, 20 Apr 2026 04:09:29 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-24.dlp.protect.broadcom.com. [144.49.247.24])
        by smtp-relay.gmail.com with ESMTPS id 00721157ae682-7b9ee881c1bsm6439857b3.1.2026.04.20.04.09.28
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 20 Apr 2026 04:09:29 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2a90510a6d1so23522155ad.0
        for <linux-scsi@vger.kernel.org>; Mon, 20 Apr 2026 04:09:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1776683368; x=1777288168; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EvtElR9jgLe1msoqA+SsekbRWN4DGaUCVyyMSUvV2mk=;
        b=M1nvyp/RD4stzD1YBCzYQUJLyARuOAl2plrwqqFJGaVYuUL4ibKdFv0trHRaVoOHKd
         obGT0nDnQKtSUWJdoQ9O/R965GtoN0zGSDlJ8uKaWWqnSNBQRVTRdedlfoTYVnAZ+Jsa
         UyEvIy7iihMk6JIP2rgCVSWVMRIrVbDrTJEnI=
X-Received: by 2002:a17:903:98f:b0:2b2:6fbf:ea2d with SMTP id d9443c01a7336-2b5f9df1eccmr108162655ad.7.1776683367736;
        Mon, 20 Apr 2026 04:09:27 -0700 (PDT)
X-Received: by 2002:a17:903:98f:b0:2b2:6fbf:ea2d with SMTP id d9443c01a7336-2b5f9df1eccmr108162475ad.7.1776683367267;
        Mon, 20 Apr 2026 04:09:27 -0700 (PDT)
Received: from sumit_ws.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b5faa1739fsm103115415ad.22.2026.04.20.04.09.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Apr 2026 04:09:26 -0700 (PDT)
From: Sumit Saxena <sumit.saxena@broadcom.com>
To: martin.petersen@oracle.com,
	axboe@kernel.dk
Cc: linux-scsi@vger.kernel.org,
	linux-block@vger.kernel.org,
	mpi3mr-linuxdrv.pdl@broadcom.com,
	James Rizzo <james.rizzo@broadcom.com>,
	Sumit Saxena <sumit.saxena@broadcom.com>
Subject: [PATCH v2 1/3] scsi: scan: allocate sdev and starget on the NUMA node of the host adapter
Date: Mon, 20 Apr 2026 17:08:37 +0530
Message-ID: <20260420113846.1401374-2-sumit.saxena@broadcom.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260420113846.1401374-1-sumit.saxena@broadcom.com>
References: <20260420113846.1401374-1-sumit.saxena@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

From: James Rizzo <james.rizzo@broadcom.com>

When a host adapter is attached to a specific NUMA node, allocating
scsi_device and scsi_target via kzalloc() may place them on a remote
node.  All hot-path I/O accesses to these structures then cross the NUMA
interconnect, adding latency and consuming inter-node bandwidth.

Use kzalloc_node() with dev_to_node(shost->dma_dev) so allocations land
on the same node as the HBA, reducing cross-node traffic and improving
I/O performance on NUMA systems.

Signed-off-by: James Rizzo <james.rizzo@broadcom.com>
Signed-off-by: Sumit Saxena <sumit.saxena@broadcom.com>
---
 drivers/scsi/scsi_scan.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index ef22a4228b85..9749a8dbe964 100644
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
 
@@ -501,8 +503,9 @@ static struct scsi_target *scsi_alloc_target(struct device *parent,
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

