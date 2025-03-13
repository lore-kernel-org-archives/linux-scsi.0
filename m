Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACA9326463E
	for <linux-scsi@vger.kernel.org>; Thu, 13 Mar 2025 14:26:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741876004; cv=none; b=HZuUzzkjv76Y7OzoUDZDBfXVP08+kX3dNVdSE9bBFmqBQmXdvoxOu9Z+sxPxu8xUgySCnWBP5oDW5GIYh+qSqgQynkpg71C89E4sjvNgSNF6D87X6oZq3oS6ZnjiHo231LanvWnlp/GQIQUbJZ1IqxFQMtBMgd/NDDqTZf/zxBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741876004; c=relaxed/simple;
	bh=ts84cm5dT13q05hefIVcRkm1LjtvF92DcRpv1IASMy8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=O3QFszhaU/W5z+4yM1UE71eOykHGUJTou29V5QJmYA1OcgPQr2HYKi9gb46grhFMeuq4hg0J+0AwHzIL5Mm4hux9FSPnWHG0lELXa4mMnwBYJKTEFCIzcmV/nuAS5DSQEdWm32jLaS0OvCMGRNRiXw/wcK4ReOyWNvNHtSJU8Qc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=di3gf8D4; arc=none smtp.client-ip=95.215.58.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="di3gf8D4"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1741875999;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=b7TaF0+rQ1df3IWfbD7/Cbo7lt7svQRAuL8kAQPftgg=;
	b=di3gf8D4792VwqxXzKRY489GaeKpe8uwgP3xYd35PazV3tQZcWvJNDFg3+TgIxDi39Xuje
	E9XKjlFT0KePL5t11hOimcwMjAqEsNLR6oxwLQDcGp2QBrmybIV+0p1zweO2a9Izqo5u9b
	PLlKMv1RqlhtrKn2eMrGq6w73tEATsU=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [RESEND PATCH] scsi: sd: Use str_on_off() helper in sd_read_write_protect_flag()
Date: Thu, 13 Mar 2025 15:25:57 +0100
Message-ID: <20250313142557.36936-2-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Remove hard-coded strings by using the str_on_off() helper function.

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 drivers/scsi/sd.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 950d8c9fb884..96f64237360f 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -50,6 +50,7 @@
 #include <linux/rw_hint.h>
 #include <linux/major.h>
 #include <linux/mutex.h>
+#include <linux/string_choices.h>
 #include <linux/string_helpers.h>
 #include <linux/slab.h>
 #include <linux/sed-opal.h>
@@ -3004,7 +3005,7 @@ sd_read_write_protect_flag(struct scsi_disk *sdkp, unsigned char *buffer)
 		set_disk_ro(sdkp->disk, sdkp->write_prot);
 		if (sdkp->first_scan || old_wp != sdkp->write_prot) {
 			sd_printk(KERN_NOTICE, sdkp, "Write Protect is %s\n",
-				  sdkp->write_prot ? "on" : "off");
+				  str_on_off(sdkp->write_prot));
 			sd_printk(KERN_DEBUG, sdkp, "Mode Sense: %4ph\n", buffer);
 		}
 	}
-- 
2.48.1

