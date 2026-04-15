Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F6F238C2A9
	for <linux-scsi@vger.kernel.org>; Wed, 15 Apr 2026 20:49:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776286149; cv=none; b=AFOx7PaG5qzEsef1uz2LtMoC/oM0rRg/3KMetxEhzbpRg0zGYq4IoMRKZ2sL1h9Dfrh1f0/pCVBkoW+iNk3W9PkNl6Xfb5/p4psIHIcWtRM1JmW9WGSkL/QRbKJCgz+5hPF+SU3ZWl5c/1F1y4mRgzKhkTpinB6VsbuxsHK5kBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776286149; c=relaxed/simple;
	bh=o0420ct71g4J8Qq0IbSQu1YVb5Yi0toLPfTbBPr1Om8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WuRheLTfVKXwXUdG5ZvfWP31pmSXjPcIGT1DfiK/nKyttPv621xVYB7km1eRmq+gxt7qpopngWVz7kJGcXpegF0j92EMxIHXcEyGKSXT0ySSR8WhKlIGclhig1QEV1lKil9/xF12tdAGrE6PB4EIFC9zdBkpzwp4/OhJldh9rOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=QzjeObE8; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="QzjeObE8"
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-43cfac48bc7so5076559f8f.0
        for <linux-scsi@vger.kernel.org>; Wed, 15 Apr 2026 13:49:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1776286146; x=1776890946; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VJIlB3FzovpxBjH/S/NcQfMKUjgTzTqyTBnKuvwk7ak=;
        b=QzjeObE8Pw86+cPo2bNz5KjQQTqhEIiY0gsoKBUWnEtQ8dgqStEvFQtHlzoCVJhS3w
         okV4ShNe/HAoipgUl6mbgv4ACdxLSEkH450skfGLXZ0vo5a/8LoGCRarRua/gcqdC0YE
         +6EkBE5RDkISM+d88GN+cvQ/y+xyY9KzErdlBKniy4w3ehRjDJ/Or3RgrffyylXLkfA0
         b8i0cq3VJjl4MqkUqI37E6s8vuC3dbfmtB1HHSlFcl7wqfno/qD3IuibBV51xwTbg6qF
         Eo5Q9gTSDr7Gx9nVVHej5QZJEbwREvHzpJ/Yy3mZqNX9r9QyURkRmJ99+14dkSmkU+tk
         x75w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776286146; x=1776890946;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=VJIlB3FzovpxBjH/S/NcQfMKUjgTzTqyTBnKuvwk7ak=;
        b=hnSzcKY29ioBbvQ5cqktsqJQRH+UpbRd/JcMDd5+h9V74UE9dTSLj/jX7TGqpPoNO2
         YejdYKyH7Kbuxn+O5+cNr1m8ninAiXEAdd2cmT4O+XrKqbztZMhZvykHyU+rUIDx50BV
         PlrR9aKM96HdZQgTs+1JD1XqHzEKlgEXNrc69A/o5f1WutDyWJdooRYPa+SEpmBTIFUE
         HyRKVJtLynj4CRZbvC0jr1iBqiASlpbwDu+ZT19ISipe3RyKZZjm9wkkNW0caXarGn2P
         VOMGPf/bvMNeHJv9aqU/rH2BMa0ru5B/clbmW0DpWO5UR61y8StIkyyog+ZxdOEqX0NS
         2GZg==
X-Gm-Message-State: AOJu0YzHrF7wpiKqH3C6rSnDykYkKEYoMq3wkZQJpa9Tj4UOFgTkvYOi
	e9O87sypwjarOZcNrWRsGiAcxNGq0eQHIeUH+ppC73JTNWVaQms7K2Ke00Zul2UciV8cfqGknYT
	WiyuuAiI=
X-Gm-Gg: AeBDietiFPv/z4k1jDnZ7wovd0Wcbl/UDB5RSdfqzwV/4HDeK8f0dYhdmZgqIHBj8RO
	XC227VPQP3/hvqCUJwybt4Wx6VOP/9tgt6QJa8unehT6R0Uiec+06RLXWGzGuqvaOAa5OBhFsaa
	V7/d+6TIIPDGKuh54/aU4wDbjkbc4TaeN4oWk+DfKUvyTJ6vTsB7FpOqMWOW8+r04myaXyAjkmS
	Sot461U3hb/jkmLpRaP+06p8psyjBy+CnzBRoMKKUwzCEof5ShjFDv4k8Cxyd0Z7Kj8I0sxJcnL
	JJhrV7RNiB19pQ1/jmGHJoK1lxxK5F0KGn9aS0+RqLHVNg0/bAUAVHLqnbkj+Gp1nXzKzm8HPUS
	C525HckKq3lZHBPlshTSyGNeItYc7y82Y7ZOV7W3UhJl2Tv5qCUVu/eEYEqYcvmR5HHeXxn93T0
	0Ubr4kr3MeigGFYj2cOJogvf/EE/QpUpyG5PjVAFGLP6lIXu5PxlyUfRPDIvfP8T4zDzh03ikBz
	OS03tIhpGcm5Ql1SESIFLj/
X-Received: by 2002:a05:6000:2886:b0:43b:93af:e124 with SMTP id ffacd0b85a97d-43d642c7992mr33810337f8f.26.1776286146278;
        Wed, 15 Apr 2026 13:49:06 -0700 (PDT)
Received: from localhost (p200300de374a06005c73df0aad605173.dip0.t-ipconnect.de. [2003:de:374a:600:5c73:df0a:ad60:5173])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-43ead33d518sm8229248f8f.6.2026.04.15.13.49.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Apr 2026 13:49:05 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: "Martin K. Petersen" <martin.petersen@oracle.com>,
	Christoph Hellwig <hch@lst.de>,
	Don Brace <don.brace@microchip.com>
Cc: linux-scsi@vger.kernel.org,
	Hannes Reinecke <hare@suse.de>,
	Lee Duncan <lduncan@suse.com>,
	Martin Wilck <mwilck@suse.com>,
	storagedev@microchip.com,
	Ranjan Kumar <ranjan.kumar@broadcom.com>,
	Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
	Kashyap Desai <kashyap.desai@broadcom.com>,
	Sumit Saxena <sumit.saxena@broadcom.com>,
	mpi3mr-linuxdrv.pdl@broadcom.com,
	MPT-FusionLinux.pdl@broadcom.com,
	Yihang Li <liyihang9@h-partners.com>,
	Jack Wang <jinpu.wang@cloud.ionos.com>,
	John Garry <john.g.garry@oracle.com>
Subject: [PATCH 2/2] scsi: sas_user_scan: use scan_start if available
Date: Wed, 15 Apr 2026 22:48:50 +0200
Message-ID: <20260415204850.799431-3-mwilck@suse.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260415204850.799431-1-mwilck@suse.com>
References: <20260415204850.799431-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Since 37c4e72b0651 ("scsi: Fix sas_user_scan() to handle wildcard and
multi-channel scans"), a wildcard scan on a SAS host scans all channels.
This can cause excessive resource usage and even system freeze with
some controllers, e.g. smartpqi. smartpqi and other drivers provide
the scan_start() and scan_finished() methods to scan devices
efficiently. Instead of blindly scanning every device, use these
methods to do the wildcard scan when available.

Fixes: 37c4e72b0651 ("scsi: Fix sas_user_scan() to handle wildcard and multi-channel scans")
Signed-off-by: Martin Wilck <mwilck@suse.com>
Cc: Don Brace <don.brace@microchip.com>
Cc: storagedev@microchip.com
Cc: Ranjan Kumar <ranjan.kumar@broadcom.com>
Cc: Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>
Cc: Kashyap Desai <kashyap.desai@broadcom.com>
Cc: Sumit Saxena <sumit.saxena@broadcom.com>
Cc: mpi3mr-linuxdrv.pdl@broadcom.com
Cc: MPT-FusionLinux.pdl@broadcom.com
Cc: Yihang Li <liyihang9@h-partners.com>
Cc: Jack Wang <jinpu.wang@cloud.ionos.com>
Cc: John Garry <john.g.garry@oracle.com>

----
This patch has been tested successfully with smartpqi, but it would
affect other drivers that provide scan_start(), and we don't have
hardware to test them all. Affected drivers are aic94xx, hisi_sas,
hpsa, isci, mpi3mr, mpt3sas, mvsas, pm8001, and smartpqi.
I cc'd the maintainers of these drivers above.
---
 drivers/scsi/scsi_transport_sas.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/drivers/scsi/scsi_transport_sas.c b/drivers/scsi/scsi_transport_sas.c
index 1341270..2231609d 100644
--- a/drivers/scsi/scsi_transport_sas.c
+++ b/drivers/scsi/scsi_transport_sas.c
@@ -31,6 +31,7 @@
 #include <linux/string.h>
 #include <linux/blkdev.h>
 #include <linux/bsg.h>
+#include <linux/delay.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
@@ -1702,6 +1703,26 @@ static void scan_channel_zero(struct Scsi_Host *shost, uint id, u64 lun)
 	}
 }
 
+/*
+ * For wildcard scans on hosts that provide a scan_start method,
+ * use that instead of blindly scanning everything.
+ */
+static int sas_user_scan_with_scan_start(struct Scsi_Host *shost)
+{
+	unsigned long start;
+
+	if (!shost->hostt->scan_finished || !shost->hostt->scan_start)
+		return 1;
+
+	start = jiffies;
+	shost->hostt->scan_start(shost);
+
+	while (!shost->hostt->scan_finished(shost, jiffies - start))
+		msleep(10);
+
+	return 0;
+}
+
 /*
  * SCSI scan helper
  */
@@ -1721,6 +1742,11 @@ static int sas_user_scan(struct Scsi_Host *shost, uint channel,
 		break;
 
 	case SCAN_WILD_CARD:
+
+		if (id == SCAN_WILD_CARD && lun == SCAN_WILD_CARD
+			&& !sas_user_scan_with_scan_start(shost))
+			return 0;
+
 		mutex_lock(&sas_host->lock);
 		scan_channel_zero(shost, id, lun);
 		mutex_unlock(&sas_host->lock);
-- 
2.51.0

