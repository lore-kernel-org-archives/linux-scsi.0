Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2B28240220
	for <linux-scsi@vger.kernel.org>; Mon, 13 Jan 2025 15:24:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736781877; cv=none; b=SbuFAX+npe/lSSdZ71onYr7+co4V6+bCO0P4NpCfaSd7zHC9rJfS172NgKfP8RBU2bVfkSGSF8l+es+q0ouDQ7FLp6f4T2S+BpfZNy1xMo2NkdZP3N+KJvbQp4HieLbeLIGg7EPNILSlxqrxf0Eo6Fz0o79EOHPHpDNH8KVM9+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736781877; c=relaxed/simple;
	bh=BszdlMEjmPU6bXtXwuZsyPGiZ+9/TmuMvG5IQhPskfg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=VZuGiZKalKjbHi5RfKfjRV+n0Eh60yJyPxcuqifCqvkmCvemZejS0I0LP6T9qrrCAwR3kQN+eCVuZllf1O8k2vkynz3eM9GUFNNa4uJdfiA+AV3htYuM50RcTvUQmf1deto94nthYb3fwXfiNjS+zAUToDc877EO8JR6x2L+C4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=i8//5h+5; arc=none smtp.client-ip=95.215.58.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="i8//5h+5"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1736781873;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=QQNpWrbqUWe97igo6yAMoWQGxn0dgLOn1PoKsly3zVU=;
	b=i8//5h+5VtGPPm+Xhxf6GExuddzChbTjrv+mCRovKTe7H/yONVJ9SCz8S8ZuV0VhfGUrD7
	BKkRRjIrNmyhOUfNP0QOIEMCbgH3JQhQNfDNC/Px3/+w4cDGHBPyiuwNmltymssZHst23G
	Bk+XyhW2bmyD8Ezu1jEkxkDOg/fHqJM=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: aha1740: Use str_enabled_disabled() helper
Date: Mon, 13 Jan 2025 16:23:38 +0100
Message-ID: <20250113152338.473477-2-thorsten.blum@linux.dev>
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

Use pr_info() instead of printk(KERN_INFO) to silence multiple
checkpatch warnings.

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 drivers/scsi/aha1740.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/aha1740.c b/drivers/scsi/aha1740.c
index be7ebbbb9ba8..c21286eaa8a1 100644
--- a/drivers/scsi/aha1740.c
+++ b/drivers/scsi/aha1740.c
@@ -114,9 +114,9 @@ static int aha1740_show_info(struct seq_file *m, struct Scsi_Host *shpnt)
 {
 	struct aha1740_hostdata *host = HOSTDATA(shpnt);
 	seq_printf(m, "aha174x at IO:%lx, IRQ %d, SLOT %d.\n"
-		      "Extended translation %sabled.\n",
+		      "Extended translation %s.\n",
 		      shpnt->io_port, shpnt->irq, host->edev->slot,
-		      host->translation ? "en" : "dis");
+		      str_enabled_disabled(host->translation));
 	return 0;
 }
 
@@ -578,10 +578,10 @@ static int aha1740_probe (struct device *dev)
 		outb(G2CNTRL_HRST, G2CNTRL(slotbase));
 		outb(0, G2CNTRL(slotbase));
 	}
-	printk(KERN_INFO "Configuring slot %d at IO:%x, IRQ %u (%s)\n",
-	       edev->slot, slotbase, irq_level, irq_type ? "edge" : "level");
-	printk(KERN_INFO "aha174x: Extended translation %sabled.\n",
-	       translation ? "en" : "dis");
+	pr_info("Configuring slot %d at IO:%x, IRQ %u (%s)\n",
+		edev->slot, slotbase, irq_level, irq_type ? "edge" : "level");
+	pr_info("aha174x: Extended translation %s.\n",
+		str_enabled_disabled(translation));
 	shpnt = scsi_host_alloc(&aha1740_template,
 			      sizeof(struct aha1740_hostdata));
 	if(shpnt == NULL)
-- 
2.47.1

