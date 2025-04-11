Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6E91189B84
	for <linux-scsi@vger.kernel.org>; Fri, 11 Apr 2025 08:47:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744361277; cv=none; b=JomppyTsVm0ynpPR74zWSfEQmYfRTmnAcgEnR53Fp66lRO0BSTthB29BBQW6MBWd4WSCsI3eloPVSPUDaYBRp2MJZBved5/1E3jMTN+cFlzu0S/Vtz2UPM2VXXtvEWxkSA6MN6NouDxAsFWEM0if/2dfXOejmbHC5WbzdmN23y4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744361277; c=relaxed/simple;
	bh=usfVP6LlpHBCPvtgzb/m0iAxVThx8yduHHfIQc3dpew=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=nuN0WZcDC8efONm5L9wEWldORTfTiFiBiuI9RUFqXKwbbV/9mVLLUyfr/eVN5NrlCjCw7t9SursEokxly4JeCCcn9ZQFuYsd6EpzDUQRijfO18ImaCymDvZPeDzFirYZwF9HVVmutSHwP5fefCXdFIOMi1ZliBMeWrpUkyuyLGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=TvUo8GK0; arc=none smtp.client-ip=91.218.175.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="TvUo8GK0"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1744361262;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=CISzMpwIVKRzzULkCjNr+EVHLzO+7fOhSA52j2Jwi44=;
	b=TvUo8GK0bJeYa8uDnR1BO0JMMwlbFvluTLw8tFxmhg+WE0gbr+lt/2fjFiEWXQmDkcO4s3
	/SXU9HCyoCrisbe/ZfBUVlqjF9eJVcQr6AJlnxyWPxGPKv6eIQoH/DgtQxVHmavU4cSvqS
	IGCsnyx8WGBOF+PwO1v0Ba7xBJ2EJkc=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Don Brace <don.brace@microchip.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	storagedev@microchip.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [RESEND PATCH] scsi: hpsa: Use str_enabled_disabled() helper function
Date: Fri, 11 Apr 2025 10:47:20 +0200
Message-ID: <20250411084719.7396-2-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Remove hard-coded strings by using the str_enabled_disabled() helper
function.

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 drivers/scsi/hpsa.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index c73a71ac3c29..c190412ad9fc 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -36,6 +36,7 @@
 #include <linux/dma-mapping.h>
 #include <linux/completion.h>
 #include <linux/moduleparam.h>
+#include <linux/string_choices.h>
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_device.h>
@@ -465,7 +466,7 @@ static ssize_t host_store_hp_ssd_smart_path_status(struct device *dev,
 	h->acciopath_status = !!status;
 	dev_warn(&h->pdev->dev,
 		"hpsa: HP SSD Smart Path %s via sysfs update.\n",
-		h->acciopath_status ? "enabled" : "disabled");
+		str_enabled_disabled(h->acciopath_status));
 	return count;
 }
 
@@ -552,7 +553,7 @@ static ssize_t host_show_hp_ssd_smart_path_status(struct device *dev,
 
 	h = shost_to_hba(shost);
 	return snprintf(buf, 30, "HP SSD Smart Path %s\n",
-		(h->acciopath_status == 1) ?  "enabled" : "disabled");
+		str_enabled_disabled(h->acciopath_status == 1));
 }
 
 /* List of controllers which cannot be hard reset on kexec with reset_devices */
-- 
2.49.0

