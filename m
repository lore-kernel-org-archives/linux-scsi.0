Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C9EB156F5E
	for <linux-scsi@vger.kernel.org>; Thu, 21 Nov 2024 19:49:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732218561; cv=none; b=uYC3oCvJGAcHR0EZ1vb8UquZ0mapwBLWHIr4BykTlgfRMwjg8MYOY1QGvvmQVbKqtqH/ftaYkKSVLv2Bo2Va4gyUxDKaxKBC8iwIyGX4MyB8SKSRXrm3wiDDsw4RCnfpTl7V1+XaXnBcNyJwKY37b6ljwpvjlZMTrT26u6vrGnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732218561; c=relaxed/simple;
	bh=/EhwlAowUPBNCPPUkYBxaERl2CCDs7Vetj3wrmlCrDQ=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=qxJUXN/v5t9y4piZtMkHPqkD8S6+S+nfhIMbX90gCk4xdamHDlqtcN/NaY+9rIA6Y6Ox2IbLIUdmPlZwRfv6bnxR0Vhi/WdCoEi5B9rukUANny6XXkrp+a3RiR7Tc0CM4622do+d3GznBL3S5zGWIYEvPr4B9wiQBPQrVg8pbp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tadamsjr.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=i/Kpp21V; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tadamsjr.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="i/Kpp21V"
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6eeb9152b2cso24333567b3.1
        for <linux-scsi@vger.kernel.org>; Thu, 21 Nov 2024 11:49:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732218559; x=1732823359; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=FlTVGm5qa99OPyjgK2sYE6lFf2Ldqoi0UzDo7GJSevQ=;
        b=i/Kpp21VAn51ZqhFYF7Cjncw62474OtRtoADBZybA2vu4KJKFbuHjNPnKRWFVJyJTD
         3oi81O6JEzL6EYC25sGd8tlur6uagkkqq+yGKfbMdg4jV9h1W9/ENHx5zqDc94xN7pAo
         HYQsKjIB5RVBQUjII8LSTWffEmQAhZEvL8dKIQTGQf/XRAGsPx+rRmPJMl/YbxI3PQcx
         1hdP6G7fAyUZvqtgnSdAVjvUvOroXezjkpbpalofx/uB74EIOv0LOhWuUktp1PB89o34
         Q1Ij+O8U3lHzJc2bgo0BmWYK8jdecupw7t26906HnNHh0noFNIKxKEOCA3P4x+lQ9s4B
         e1dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732218559; x=1732823359;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=FlTVGm5qa99OPyjgK2sYE6lFf2Ldqoi0UzDo7GJSevQ=;
        b=o/lWV5gXIFYz97Jov0ac6QSAbaN+W3Tyodl+DmMoLNEWSTaPOf3jYQpROoR69YyMBN
         QsSAiayfvQRu5NeAUUrAC0kXgU7XSVvgi0KcTv9bSe86P4l7cZqjwAqYq2LtLK+STlCx
         CnvxVGefQMjXQNm8A+XtYePO60POd3ti+pavZG+ZlYtGXw1/Cbe5HvHFab3BNQD30Ov5
         qTBKxV4nnjw92rYSsqkHR0h00To78tL99fAbRAcm5Ir4ZKW6is542/X1JO/fr4HUwsn3
         xq1x1LctKL+xx8SmiWZi6VXwbK53yPLAQFb5PPvkoG1c2ktOv9+Jv7tPk2B66zeeLcyr
         njLA==
X-Gm-Message-State: AOJu0YxTQghsM4aKHBVWyxrnW6llp7zWUQsjwQ0Uwat1rRpKoIG5TNCc
	zaPvx9zRnukOm/xhSqDbxWr4pYIrXEpzzFvp4G4yb077OTESW9MYMjzCYI5K0Xuskk7m0XNdjss
	sOG0lDuj+2A==
X-Google-Smtp-Source: AGHT+IGJd7/uvd/MveJMgVETHnva4G0+/AAqBaP8ft/tMr6ZWbYv/L2EZ60cfLxbRKbHYVPTXuL+MmRYVE48xQ==
X-Received: from tadamsjr.c.googlers.com ([fda3:e722:ac3:cc00:13f:f798:ac1c:499f])
 (user=tadamsjr job=sendgmr) by 2002:a05:690c:288d:b0:62c:ea0b:a447 with SMTP
 id 00721157ae682-6eee08a96cemr2517b3.2.1732218559215; Thu, 21 Nov 2024
 11:49:19 -0800 (PST)
Date: Thu, 21 Nov 2024 11:49:15 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.47.0.371.ga323438b13-goog
Message-ID: <20241121194915.3039073-1-tadamsjr@google.com>
Subject: [PATCH] scsi: pm80xx: Do not use libsas port id
From: TJ Adams <tadamsjr@google.com>
To: Jack Wang <jinpu.wang@cloud.ionos.com>, 
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>, 
	"Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Igor Pylypiv <ipylypiv@google.com>, Terrence Adams <tadamsjr@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Igor Pylypiv <ipylypiv@google.com>

libsas port ids can differ from the controller's port ids.
Using libsas port id to index pm8001_ha->port array is a bug.

Remove sas_find_local_port_id(). We can use pm8001_ha->phy[phy_id].port
to get the port id.

Signed-off-by: Igor Pylypiv <ipylypiv@google.com>
Signed-off-by: Terrence Adams <tadamsjr@google.com>
---
 drivers/scsi/pm8001/pm8001_sas.c | 21 ++-------------------
 1 file changed, 2 insertions(+), 19 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm8001_sas.c
index ee2da8e49d4c..061b57b1cc7a 100644
--- a/drivers/scsi/pm8001/pm8001_sas.c
+++ b/drivers/scsi/pm8001/pm8001_sas.c
@@ -374,23 +374,6 @@ static int pm8001_task_prep_ssp(struct pm8001_hba_info *pm8001_ha,
 	return PM8001_CHIP_DISP->ssp_io_req(pm8001_ha, ccb);
 }
 
- /* Find the local port id that's attached to this device */
-static int sas_find_local_port_id(struct domain_device *dev)
-{
-	struct domain_device *pdev = dev->parent;
-
-	/* Directly attached device */
-	if (!pdev)
-		return dev->port->id;
-	while (pdev) {
-		struct domain_device *pdev_p = pdev->parent;
-		if (!pdev_p)
-			return pdev->port->id;
-		pdev = pdev->parent;
-	}
-	return 0;
-}
-
 #define DEV_IS_GONE(pm8001_dev)	\
 	((!pm8001_dev || (pm8001_dev->dev_type == SAS_PHY_UNUSED)))
 
@@ -463,10 +446,10 @@ int pm8001_queue_command(struct sas_task *task, gfp_t gfp_flags)
 	spin_lock_irqsave(&pm8001_ha->lock, flags);
 
 	pm8001_dev = dev->lldd_dev;
-	port = &pm8001_ha->port[sas_find_local_port_id(dev)];
+	port = pm8001_ha->phy[pm8001_dev->attached_phy].port;
 
 	if (!internal_abort &&
-	    (DEV_IS_GONE(pm8001_dev) || !port->port_attached)) {
+	    (DEV_IS_GONE(pm8001_dev) || !port || !port->port_attached)) {
 		ts->resp = SAS_TASK_UNDELIVERED;
 		ts->stat = SAS_PHY_DOWN;
 		if (sas_protocol_ata(task_proto)) {
-- 
2.47.0.371.ga323438b13-goog

