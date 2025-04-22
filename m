Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17A4914C5B0
	for <linux-scsi@vger.kernel.org>; Tue, 22 Apr 2025 17:51:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745344309; cv=none; b=d9073SfpM/HfUuq93NDGEiFO2Ecnw+Rz/YujzQ/NZ0/9nqWV7GkTKqusX3p3rf+cXkuAJ5E7mCs2Y3DmjyqMFLzwhfmM8kbn/9MtD58gM/5jBXQ6gFouy0Q4YWzInx8I519xjaOJdi7Qe3ivPSadjnKkMcmLRO5gFjC1JfSQD3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745344309; c=relaxed/simple;
	bh=glzgGwBa0z73tkF70TipUoFYetOf3XZBdMqwFj57g9Y=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=n/ktyU1y1tu30FH9reXMY7YOL2iajZQiS4eJA+kkpaf55E60WbuNQ9b8IECFAJm+AW/NdySEPw2750dS0ejYehvR6oLKAA7fThL+TnRcYe2kAW/KcrFEny/Z+sesOkUJoH52e3TZW65XZUgeoBvJh8XuVl6djW2NRsMYuulnrlk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ZnlGoChg; arc=none smtp.client-ip=91.218.175.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ZnlGoChg"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1745344304;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=0ydwoQy174fnIeX8b6mxNKv5PHl9MRDMKnEHAr6lH5I=;
	b=ZnlGoChgOKsekZ5OPX+iz12I89TUzKtNKzNF+PfevamI3YE1aZIidlZwqd1RxZf3qkrPbo
	Xu/zcKZ/+WgNrYlWGUkU1DTEABYsYPXqUAJFzupWPBq9NqMCfI/1mDgocwnl0tLNylXPWA
	rY9X0GnmDacUcnFUq34NJV2uDawZnhQ=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Vishal Bhakta <vishal.bhakta@broadcom.com>,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [RESEND PATCH] scsi: vmw_pvscsi: Use str_enabled_disabled() helper in pvscsi_probe()
Date: Tue, 22 Apr 2025 19:51:29 +0200
Message-ID: <20250422175129.27810-1-thorsten.blum@linux.dev>
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

Use pr_debug() instead of printk(KERN_DEBUG) to silence a checkpatch
warning.

Suggested-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 drivers/scsi/vmw_pvscsi.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/vmw_pvscsi.c b/drivers/scsi/vmw_pvscsi.c
index 32242d86cf5b..4927c6a33bd8 100644
--- a/drivers/scsi/vmw_pvscsi.c
+++ b/drivers/scsi/vmw_pvscsi.c
@@ -25,6 +25,7 @@
 #include <linux/slab.h>
 #include <linux/workqueue.h>
 #include <linux/pci.h>
+#include <linux/string_choices.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_host.h>
@@ -1508,8 +1509,8 @@ static int pvscsi_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		goto out_reset_adapter;
 
 	adapter->use_req_threshold = pvscsi_setup_req_threshold(adapter, true);
-	printk(KERN_DEBUG "vmw_pvscsi: driver-based request coalescing %sabled\n",
-	       adapter->use_req_threshold ? "en" : "dis");
+	pr_debug("vmw_pvscsi: driver-based request coalescing %s\n",
+		 str_enabled_disabled(adapter->use_req_threshold));
 
 	if (adapter->dev->msix_enabled || adapter->dev->msi_enabled) {
 		printk(KERN_INFO "vmw_pvscsi: using MSI%s\n",
-- 
2.49.0

