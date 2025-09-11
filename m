Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06EBF317712;
	Thu, 11 Sep 2025 12:22:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757593360; cv=none; b=rB9UCW7855LtCvnSPwgFBzjcIbriRFLXARwM+aCcLVv/c8cKRART03UQAQQGnWyDBiXeIBsDxysYinNuXBCGllwxKhCmM7/JKKfmkZLexUvoIKZO3gFfP/RCwAfbjeKEwwI1/evkkM3rbpK0YF5Gp9fuJ/BlVWI5wQbF53tEpNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757593360; c=relaxed/simple;
	bh=K5yMCkZEPBamsnYLvIMHFL5NSEe6jr5yyoMtgbK8IPA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=FLSB1F++DIFPa1e5WEmibZKRCk+NELMYuiWV0c+ezSyOe7CZ40JLGGK3s65g8lLdjkf4VaJ8KRk+TWzAaj/atMSevWOGQ1asHPQreKMfT9/Wr1BEjuVFEJzxSDrz1/GvS2Yxxuxi3E0sCMJ2B1GlKo7M0wZumsc3xMHEAzs1iiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=MUwWEKoi; arc=none smtp.client-ip=91.218.175.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="MUwWEKoi"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1757593346;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=15ZbTdicaZVwX6eRBAn7SFw+ucv468vVpXD3Z7POy5s=;
	b=MUwWEKoiyES1vPhJs0unFpxTiDo5PbhKVMm/NqVKY22OvOAkw1n3U1zg95mVlNnRhKm5Sv
	myt3A6bBgczpHu6FQTvEC4nU023BTD92DCY7WTEgz/gv4V8lXJfEBXG1hOIWEJ1OCFGzse
	8abrFRDgouFYsxPqILE+mk6zKZaeOAk=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Vishal Bhakta <vishal.bhakta@broadcom.com>,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-hardening@vger.kernel.org,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH RESEND] scsi: vmw_pvscsi: Use str_enabled_disabled() helper in pvscsi_probe()
Date: Thu, 11 Sep 2025 14:21:49 +0200
Message-ID: <20250911122149.1389092-1-thorsten.blum@linux.dev>
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
2.51.0

