Received: from mail.nearlyone.de (mail.nearlyone.de [49.12.199.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CDCC1A28D;
	Thu, 12 Sep 2024 09:08:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=49.12.199.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726132120; cv=none; b=kKcF4DPuNyaEBSXbk75P2o123hQXxZF0DYN9XFYxONmHmMcH9DvkAzrvYjATiqYut5a7KnqNJNPKFOlSj4jiPRj9FYwEtOQtCjxVyJksuirU7YswqT7FPh7Tt+B5dNj4KrYS8Ff7Z/AzE0URFfQwfu9XxG1T3uK3Jo2/DEt99F4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726132120; c=relaxed/simple;
	bh=eDwqi0a8JHRp1tOSNI4fimvjD8vE5846U2/abAnguoI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=Smqy/rIA4ikFTrOH2DcpHNM/QCfAKZxTeaEtHbIxOj6GouFaRzU0KoA+oT3hAT/XqPfBoQFMGf/icLMVPF7NdZOjx9qjgCt+WRtP6TigTRmS17O5vnuF4cDZZg9NV+V3qsbTlKbjNlDY02jJSColBKDBuZWuHnoXsADPDWIIucg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=monom.org; dkim=pass (2048-bit key) header.d=monom.org header.i=@monom.org header.b=Fa4w+GiF; arc=none smtp.client-ip=49.12.199.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=monom.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=monom.org header.i=@monom.org header.b="Fa4w+GiF"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 1A1B3DAF58;
	Thu, 12 Sep 2024 10:58:44 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=monom.org; s=dkim;
	t=1726131526; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding; bh=NuLXFrCZijz9V8ltrIadE9R4BQOOOSNnOlutqu2BrD8=;
	b=Fa4w+GiFP8sEeXlbU3p117YIYzYaLNhVeWv0MjwSdHasHImsod0NajrB/rAlSaDD0PEH+w
	tPAxXEbmk3kUxI9EkdGvmTddNMf7ZmJGPGS70AnCv9b+UdoYGjCrfW22TSx+yVRwL8u9gP
	zv/yciH1gSQ5ogZdFxu1P8lLKaOJ/RJt7cD1qgi23IMe4TLIxzfVM3bW0yTGNpSwRAfx2j
	W5xO1yarvyWwmrYnIwDK56fhGpU52gBu2BwY+uTdqYkmcs4oqxlCK1vj+K4gqNQTU0z5tv
	CSJwLms1wbmBHOVStjy6wnMNDGAqoNFnPAr6rwz1Ja5GdQcSfq5n4QaC1n19dg==
From: Daniel Wagner <dwagner@suse.de>
Date: Thu, 12 Sep 2024 10:58:28 +0200
Subject: [PATCH] scsi: pm8001: do not overwrite PCI queue mapping
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240912-do-not-overwrite-pci-mapping-v1-1-85724b6cec49@suse.de>
X-B4-Tracking: v=1; b=H4sIADOt4mYC/x3MOwqAMAwA0KtIZgOmCn6uIg7FRs1gW1JRQby7x
 fEt74HEKpxgKB5QPiVJ8BlUFjBv1q+M4rLBVKapejLoAvpwYDhZL5WDMc6Cu41R/Io9OWqJutr
 UDLmIyovcfz9O7/sBrFDsj24AAAA=
To: "Martin K. Petersen" <martin.petersen@oracle.com>, 
 John Garry <john.g.garry@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Christoph Hellwig <hch@lst.de>, Daniel Wagner <dwagner@suse.de>
X-Mailer: b4 0.14.0
X-Last-TLS-Session-Version: TLSv1.3

blk_mq_pci_map_queues maps all queues but right after this, we
overwrite these mappings by calling blk_mq_map_queues. Just use one
helper but not both.

Fixes: 42f22fe36d51 ("scsi: pm8001: Expose hardware queues for pm80xx")
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: John Garry <john.g.garry@oracle.com>
Signed-off-by: Daniel Wagner <dwagner@suse.de>
---
I've factored this fix out from the 'honor isolcpus configuration' [1]
series. No need to hold the fix off.

[1] https://lore.kernel.org/all/20240806-isolcpus-io-queues-v3-0-da0eecfeaf8b@suse.de
---
 drivers/scsi/pm8001/pm8001_init.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
index 1e63cb6cd8e3..33e1eba62ca1 100644
--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -100,10 +100,12 @@ static void pm8001_map_queues(struct Scsi_Host *shost)
 	struct pm8001_hba_info *pm8001_ha = sha->lldd_ha;
 	struct blk_mq_queue_map *qmap = &shost->tag_set.map[HCTX_TYPE_DEFAULT];
 
-	if (pm8001_ha->number_of_intr > 1)
+	if (pm8001_ha->number_of_intr > 1) {
 		blk_mq_pci_map_queues(qmap, pm8001_ha->pdev, 1);
+		return;
+	}
 
-	return blk_mq_map_queues(qmap);
+	blk_mq_map_queues(qmap);
 }
 
 /*

---
base-commit: 70302fc7adcd29c4c744489cd89e2d3ed08ecd8d
change-id: 20240912-do-not-overwrite-pci-mapping-91d17118323e

Best regards,
-- 
Daniel Wagner <dwagner@suse.de>

