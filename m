Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DD5D261591
	for <linux-scsi@vger.kernel.org>; Tue, 25 Feb 2025 09:41:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740476502; cv=none; b=mx8Lw5p+MtTozBjsPqf1vCqd5fPKHDMnZGPE8/tuK+T1/hbeCnsif1369JXVqYSfqjBQv3anhdc4ptINjy86+b3k1q63edPArJka7fl3rd7aXLejUAKZQGb5cgupY30woLttB7xGPj+clQ1plJ/Nf2otDBOS8Uipi4cPfrUGhp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740476502; c=relaxed/simple;
	bh=umBuQl2QuBFeO9IxtwbPuUMLEtLD5ox0Hz4hVd/Q4JE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=scq3/Usod79WghbCEEitFINNZ0kdx3zZroZ2OK8Tf4NZ8qGNcxBS0oC9UtjeHDJpPVwjMb1d5uEtFVxZ8fxwI3fMovHGQkIVocCVVz+YmRu2BXH7gjUfHHir5/HjwI2NGkCqTtvHBaPi4zXoMRqUegwuMOwvrTK1RYtTC9EQ9F8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=g80bBMzR; arc=none smtp.client-ip=91.218.175.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="g80bBMzR"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1740476488;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=FSnRdmhAXCNG5wX/lQk1babI2j58rDjAV131IDGWdyI=;
	b=g80bBMzRzAMxcAYS974A5/dRA0qkOeAEES2zpvFW3TWPKX2tuTB/O01ifs7pzhaVMsJM0L
	+x9/N3ZwZI/rgXAbH8007GRDKmq/oVmWyJn3dyrMnZhpU8t3ggnf6iaxV+2YJCkpy1IeZi
	262j01ErZq73lXdNqbGprfCvTZdZUkI=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Don Brace <don.brace@microchip.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	storagedev@microchip.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH RESEND] scsi: hpsa: Use str_enabled_disabled() helper function
Date: Tue, 25 Feb 2025 10:41:08 +0100
Message-ID: <20250211102643.614133-1-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
Message-ID: <20250225094108.yqDeWUIAi5BR5vW08rCu7S4nGFGWkdZA_m_ykgwgJgk@z>

Remove hard-coded strings by using the str_enabled_disabled() helper
function.

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 drivers/scsi/hpsa.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 84d8de07b7ae..ff49e93df4ed 100644
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
@@ -469,7 +470,7 @@ static ssize_t host_store_hp_ssd_smart_path_status(struct device *dev,
 	h->acciopath_status = !!status;
 	dev_warn(&h->pdev->dev,
 		"hpsa: HP SSD Smart Path %s via sysfs update.\n",
-		h->acciopath_status ? "enabled" : "disabled");
+		str_enabled_disabled(h->acciopath_status));
 	return count;
 }
 
@@ -560,7 +561,7 @@ static ssize_t host_show_hp_ssd_smart_path_status(struct device *dev,
 
 	h = shost_to_hba(shost);
 	return snprintf(buf, 30, "HP SSD Smart Path %s\n",
-		(h->acciopath_status == 1) ?  "enabled" : "disabled");
+		str_enabled_disabled(h->acciopath_status == 1));
 }
 
 /* List of controllers which cannot be hard reset on kexec with reset_devices */
-- 
2.48.1

