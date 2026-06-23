Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85A743D333C;
	Tue, 23 Jun 2026 11:29:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782214190; cv=none; b=M1p5ffu75acJAEhagXs0gaSuFX+1/3B3qDFO5jEgqWoP6SrBn4K536NeGyAx8n5fkOh1cftT6XYFYG0fYKVsHzKVcoKaWFWI3x/tkO4ek5jxAz/LCx/1/hGyCT/k4IG3H3UpWAtEcyOrur9ZLTIlculhjsTjEfOhTciSKuJVOg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782214190; c=relaxed/simple;
	bh=ABq8V93E2h3jxiC9SA6zjQ+D35EeHxtUEVbCx+hMsaQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=i4LPYpERfS6x13njO62yiE2u6rTq6+h5iOI2GQQRzI5QlzFQhLwjwNAnJ3wg2iLagsJCpWI8AIkEtv7Fkjjzf33kEd2vsfnZfxBN30/K7s5naMMiN0gWeW6Z1xsPSrz61NsdpnwnWYtpLVPbPDHZuFr8qYbnga0Wt+H7a8CwkME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=fV1V6y6B; arc=none smtp.client-ip=117.135.210.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="fV1V6y6B"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=6p
	vvRCIk0fcvMKQDxa5gPVNtwMST+cXow735qegu0ek=; b=fV1V6y6BssUSQzV2z3
	sSb1TuFrC0ZCfK7KZ3bALTEUVe931Ej+mfnkJqD/ijf0HhITTHSQ6IM3WzadqMAR
	pQm+Dnh2VrmnoKBHIq19YBCoAm9UIgjbybcqrqm7LEIbtDI59qeK32UyuEGFA3Et
	B56Gag1to4HLTPI1a7QMNSTHA=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g1-2 (Coremail) with SMTP id _____wBHjGEFbjpqGb47FQ--.13247S2;
	Tue, 23 Jun 2026 19:29:11 +0800 (CST)
From: Haoxiang Li <haoxiang_li2024@163.com>
To: john.g.garry@oracle.com,
	yanaijie@huawei.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	dlemoal@kernel.org,
	cassel@kernel.org,
	kees@kernel.org
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Haoxiang Li <haoxiang_li2024@163.com>
Subject: [PATCH] scsi: libsas: Handle expander discovery allocation failures
Date: Tue, 23 Jun 2026 19:29:09 +0800
Message-Id: <20260623112909.2172701-1-haoxiang_li2024@163.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wBHjGEFbjpqGb47FQ--.13247S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7Cr4UXry3ZryDWrW7Jr1rXrb_yoW8tF1fpa
	ykGa98KayDtw17AwsIgF4kXrW5Cryrta4UCF4rW3sa9FyrXFyqvaySyr4q9FyUCrWxJFyf
	trZ5Xa1kGF4UGrDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0piMGQDUUUUU=
X-CM-SenderInfo: xkdr5xpdqjszblsqjki6rwjhhfrp/xtbCxgfFNGo6bgeh9wAA3f

sas_ex_discover_expander() allocates a domain device and SAS port before
allocating the expander rphy, but it does not check all allocation and
registration failures. In particular, sas_expander_alloc() can return
NULL and the returned rphy is dereferenced unconditionally.

Add error handling for sas_port_alloc(), sas_port_add(), and
sas_expander_alloc(), and unwind the resources allocated on each path.
Use sas_port_free() before a port has been added and sas_port_delete()
after it has been added.

Free the child device directly on these early failures because child->rphy
has not been initialized yet, and sas_put_device() would dereference it.

Signed-off-by: Haoxiang Li <haoxiang_li2024@163.com>
---
 drivers/scsi/libsas/sas_expander.c | 24 +++++++++++++++++++++---
 1 file changed, 21 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
index f471ab464a78..56c04c4ae818 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -909,9 +909,11 @@ static struct domain_device *sas_ex_discover_expander(
 		return NULL;
 
 	phy->port = sas_port_alloc(&parent->rphy->dev, phy_id);
-	/* FIXME: better error handling */
-	BUG_ON(sas_port_add(phy->port) != 0);
-
+	if (!phy->port)
+		goto out_free_child;
+	res = sas_port_add(phy->port);
+	if (res)
+		goto out_free_port;
 
 	switch (phy->attached_dev_type) {
 	case SAS_EDGE_EXPANDER_DEVICE:
@@ -926,6 +928,9 @@ static struct domain_device *sas_ex_discover_expander(
 		rphy = NULL;	/* shut gcc up */
 		BUG();
 	}
+	if (!rphy)
+		goto out_delete_port;
+
 	port = parent->port;
 	child->rphy = rphy;
 	get_device(&rphy->dev);
@@ -963,6 +968,19 @@ static struct domain_device *sas_ex_discover_expander(
 	}
 	list_add_tail(&child->siblings, &parent->ex_dev.children);
 	return child;
+
+out_delete_port:
+	sas_port_delete(phy->port);
+	phy->port = NULL;
+	kfree(child);
+	return NULL;
+
+out_free_port:
+	sas_port_free(phy->port);
+	phy->port = NULL;
+out_free_child:
+	kfree(child);
+	return NULL;
 }
 
 static int sas_ex_discover_dev(struct domain_device *dev, int phy_id)
-- 
2.25.1

