Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 629554DC525
	for <linux-scsi@vger.kernel.org>; Wed, 13 May 2026 17:43:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778694189; cv=none; b=Ql9sZDam53xvHu84Za+zRfIzOPLT8UfPGdV21oXRrynM1z6zS8lNfuTTKnpXPH2q7RQplJEC2VWL+xRJm8ypBfXL1ubR4x0bibZ9AMCslgYsYMThCmuEsdiwlowMhnysiVnFrJLLAYAoIxCCQhlBqIGCn/z6SdccVB1nXqCRcQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778694189; c=relaxed/simple;
	bh=l2MrUwUaDGrM5PTNiRZ7KpiypyLfXZWg8/bwvAXQ4cg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jJjPAfv/E/O+H9lEIYwIZbMWCoICYVa1zZKx818u5OjZDweSrUQzv+Sk+IdVcvT9zs1KiNWTSjTILUSoz5ksqHV8lp1nO7emP8ieAHGEyBFZsRH5s29rvqxJqKm6nJ52Az1iWReazZLrrBKsJa6BxKl/feqKtYKq2RZH88oiwTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=XGpQJk/h; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="XGpQJk/h"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-48a563e4ef7so64822115e9.0
        for <linux-scsi@vger.kernel.org>; Wed, 13 May 2026 10:43:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1778694186; x=1779298986; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yWjS26Gf/63uWEL7gl3MzZ0+nKncnwUlgtmy27LOtJE=;
        b=XGpQJk/h3FM67wJRrErZygRNlKjySBnAQKoDIHv79jDT6DKqpv4BJxi2Da+j8S3IdM
         E8M8hQm/53jjqn3mUt0z6XHQrfuLKjdZ5+1/rAix0aHWi6u5NtlM852YJ0W3LJP1kN+v
         D+KHBneycdjzEhPVv7DySr4zuzkQYWXvNTfRAfCHj2TydtyBpPj6LEKy50O7m/0lNWkp
         FOuHT0jvkbATi+H+0T3uttAHh1aIdBrEw3e+HpSBzkPGqf5ghrgHrf2gqWU6VsibdhvK
         4/jSNK5CpBm2R9KwAKzz5TI+jFqKQzOrrSqJ3VJolshg6Ao1OXfVMNFyxyXdMGHACzao
         m4RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778694186; x=1779298986;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=yWjS26Gf/63uWEL7gl3MzZ0+nKncnwUlgtmy27LOtJE=;
        b=EooAnbDZ77tIqR4EygUzu1fYPqfWwzQJWDbynuq8grLPKxrMqqDGvfd5q5IWfVxrxP
         mrQZL8fLM7ayWoBcSbvFysm6CLyLrZPrrB8VFIphicf2Oa7cZTkFExMMukLUhhv6AscG
         Tnmt1UslP4H1b8TOsKnAfOmV3MUfVz/URWXpw8vfldmmc/s+M95jg+6+MfDWhi7v+Tkc
         CSEcWNpWv2zXTV8BjAyitIZAUz7Dv4pv79nnbwTOaRpoeMGo88b+Afvj7WIq9FwyKNTt
         STOF2O0/1fXhe1Wsgnl336xUs9yTzdAQwRVQZo5YrUovUEG4EztdtYhiZ6lPgU6liCIC
         8EoA==
X-Gm-Message-State: AOJu0YyrY6SAHCZz878gGkUPHaaQLxWQzdPi5i5csOD1h/YlobSYAgVF
	sLXawzQ7LcPZ6qdm5PkIVmkb84kaBHhd0TW9kQHR8Se1Z+GAluB43oAvFW164SqnCCk=
X-Gm-Gg: Acq92OFJmpWfPZtvbBID3xoLPkMVj6PXHOvp9XeNkxaAhq8lycBOSqE2tNgLTbHZNNV
	TkMJ/gsZDKHN1JOe6l/plnPHX2SJU+gJgFkR5GqRaGYo8jyXBhW8GxHcH8fAHNyIToWPSLOZg4T
	R8bvB7r0mEQAeEUAV0unW6rzj2XDOAyEfv4FuC1aSEDBVaQ4TbSAVisWehBp9DfLAeiUWFW6tOi
	ylbGO94I+r3sF5HcSx2280n+9X7TUu7dMp0GKkQDmefb5OAeiM2+xYD5lNhQ/PC23xixt29eqXU
	zMqslm+w03KAf+gI/a2v0RVsLcoCWgbnroUIoklbGczjEtV14hiZPz9IxqCLZpWWhKoQbjI5bxz
	2PYqmnZyhKvz8vJEU8xmkSXu8zLZ6+Q+RvS7TmFPspWWeoQAGx4fup7IU2G0ykCVnfno4M8Digc
	6ZBJ26Rkcu2CRhW1dGFX94akQpyzFutYzDJHm/XUmOl7Ige5sc1R1uNCzq9y76cUj4Kw4EBXYwQ
	FO9bE/HKeirSQ==
X-Received: by 2002:a05:600c:4595:b0:48e:706b:53e8 with SMTP id 5b1f17b1804b1-48fc9a1b9famr64922945e9.11.1778694185697;
        Wed, 13 May 2026 10:43:05 -0700 (PDT)
Received: from localhost (p200300de374a06005c73df0aad605173.dip0.t-ipconnect.de. [2003:de:374a:600:5c73:df0a:ad60:5173])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-45da0fe222bsm290537f8f.27.2026.05.13.10.43.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 May 2026 10:43:04 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: "Martin K. Petersen" <martin.petersen@oracle.com>,
	Christoph Hellwig <hch@lst.de>,
	Don Brace <don.brace@microchip.com>,
	ranjan.kumar@broadcom.com
Cc: linux-scsi@vger.kernel.org,
	Hannes Reinecke <hare@suse.de>,
	Lee Duncan <lduncan@suse.com>,
	Martin Wilck <mwilck@suse.com>,
	mpi3mr-linuxdrv.pdl@broadcom.com,
	storagedev@microchip.com,
	Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
	Kashyap Desai <kashyap.desai@broadcom.com>,
	Sumit Saxena <sumit.saxena@broadcom.com>,
	MPT-FusionLinux.pdl@broadcom.com
Subject: [PATCH v3 2/2] Revert "scsi: Fix sas_user_scan() to handle wildcard and multi-channel scans"
Date: Wed, 13 May 2026 19:42:36 +0200
Message-ID: <20260513174236.430465-3-mwilck@suse.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260513174236.430465-1-mwilck@suse.com>
References: <20260513174236.430465-1-mwilck@suse.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This reverts commit 37c4e72b0651e7697eb338cd1fb09feef472cc1a.

Said commit causes excessive resource usage and even system freeze with
some controllers, e.g. smartpqi and hisi_sas. The justification provided
by the patch authors [1] was supporting a special mode of the mpi3mr and
mpt3sas, so-called "Tri-mode", in which NVMe drives are exposed as SCSI
devices on a separate channel. While that's useful for these drivers, it
seems wrong to cause major breakage for other drivers for the sake of
this feature.

[1] https://lore.kernel.org/linux-scsi/CAFdVvOwjy+2ORJ6uJkspiLTPF05481U7gcS4QohFOFGPqAs8ig@mail.gmail.com/

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
Cc: Yihang Li <liyihang9@h-partners.c
---
 drivers/scsi/scsi_scan.c          |  2 +-
 drivers/scsi/scsi_transport_sas.c | 60 +++++++------------------------
 2 files changed, 13 insertions(+), 49 deletions(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index ef22a4228b85..b118ed0bf53f 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -1910,7 +1910,7 @@ int scsi_scan_host_selected(struct Scsi_Host *shost, unsigned int channel,
 
 	return 0;
 }
-EXPORT_SYMBOL(scsi_scan_host_selected);
+
 static void scsi_sysfs_add_devices(struct Scsi_Host *shost)
 {
 	struct scsi_device *sdev;
diff --git a/drivers/scsi/scsi_transport_sas.c b/drivers/scsi/scsi_transport_sas.c
index 13412702188e..d8f2377b017f 100644
--- a/drivers/scsi/scsi_transport_sas.c
+++ b/drivers/scsi/scsi_transport_sas.c
@@ -40,8 +40,6 @@
 #include <scsi/scsi_transport_sas.h>
 
 #include "scsi_sas_internal.h"
-#include "scsi_priv.h"
-
 struct sas_host_attrs {
 	struct list_head rphy_list;
 	struct mutex lock;
@@ -1685,22 +1683,6 @@ int scsi_is_sas_rphy(const struct device *dev)
 }
 EXPORT_SYMBOL(scsi_is_sas_rphy);
 
-static void scan_channel_zero(struct Scsi_Host *shost, uint id, u64 lun)
-{
-	struct sas_host_attrs *sas_host = to_sas_host_attrs(shost);
-	struct sas_rphy *rphy;
-
-	list_for_each_entry(rphy, &sas_host->rphy_list, list) {
-		if (rphy->identify.device_type != SAS_END_DEVICE ||
-		    rphy->scsi_target_id == -1)
-			continue;
-
-		if (id == SCAN_WILD_CARD || id == rphy->scsi_target_id) {
-			scsi_scan_target(&rphy->dev, 0, rphy->scsi_target_id,
-					 lun, SCSI_SCAN_MANUAL);
-		}
-	}
-}
 
 /*
  * SCSI scan helper
@@ -1710,41 +1692,23 @@ static int sas_user_scan(struct Scsi_Host *shost, uint channel,
 		uint id, u64 lun)
 {
 	struct sas_host_attrs *sas_host = to_sas_host_attrs(shost);
-	int res = 0;
-	int i;
+	struct sas_rphy *rphy;
 
-	switch (channel) {
-	case 0:
-		mutex_lock(&sas_host->lock);
-		scan_channel_zero(shost, id, lun);
-		mutex_unlock(&sas_host->lock);
-		break;
+	mutex_lock(&sas_host->lock);
+	list_for_each_entry(rphy, &sas_host->rphy_list, list) {
+		if (rphy->identify.device_type != SAS_END_DEVICE ||
+		    rphy->scsi_target_id == -1)
+			continue;
 
-	case SCAN_WILD_CARD:
-		mutex_lock(&sas_host->lock);
-		scan_channel_zero(shost, id, lun);
-		mutex_unlock(&sas_host->lock);
-
-		for (i = 1; i <= shost->max_channel; i++) {
-			res = scsi_scan_host_selected(shost, i, id, lun,
-						      SCSI_SCAN_MANUAL);
-			if (res)
-				goto exit_scan;
+		if ((channel == SCAN_WILD_CARD || channel == 0) &&
+		    (id == SCAN_WILD_CARD || id == rphy->scsi_target_id)) {
+			scsi_scan_target(&rphy->dev, 0, rphy->scsi_target_id,
+					 lun, SCSI_SCAN_MANUAL);
 		}
-		break;
-
-	default:
-		if (channel <= shost->max_channel) {
-			res = scsi_scan_host_selected(shost, channel, id, lun,
-						      SCSI_SCAN_MANUAL);
-		} else {
-			res = -EINVAL;
-		}
-		break;
 	}
+	mutex_unlock(&sas_host->lock);
 
-exit_scan:
-	return res;
+	return 0;
 }
 
 
-- 
2.54.0

