Received: from bedivere.hansenpartnership.com (bedivere.hansenpartnership.com [96.44.175.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E85AE14293;
	Tue,  2 Jul 2024 02:26:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=96.44.175.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719887210; cv=none; b=Z4K6w3ikHCEFsFf2iGWDWPOK+7RLTZ3PXlR/dqbOgwVvxVTuoaox61qQkO+HzlwGrhalYI7DXUePV7QQp2s9aExjRYnjHti2ebfzjJkcUlnHkZMc624hSkOVJdzPwtyqL4paDf8jYh/gw94KfFZ0rAdj/iwypTxdOYDsKFrmSy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719887210; c=relaxed/simple;
	bh=7VWvMsjMHz5vpZgJgChD4sJ+XNDMoIvDIOsXcuM/Oys=;
	h=Message-ID:Subject:From:To:Cc:Date:Content-Type:MIME-Version; b=pmc7NSikzit0LxTqbyKa94p3tMuJMvflErbJNOknao9PQcjyNl5Nd69NDaDFzyMVg5LY27zVdebj3kofceCIOaNaFfA6dnYWyld9uMw8bD8DRT3Id8ZxyyCfnCbxJ1wW5gKPiBOVhxYGmdK4tn3zjL6EoOCG+wInmUYo4x5+JEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=HansenPartnership.com; spf=pass smtp.mailfrom=HansenPartnership.com; dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b=PrAjDdOr; dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b=PrAjDdOr; arc=none smtp.client-ip=96.44.175.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="PrAjDdOr";
	dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="PrAjDdOr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=hansenpartnership.com; s=20151216; t=1719887206;
	bh=7VWvMsjMHz5vpZgJgChD4sJ+XNDMoIvDIOsXcuM/Oys=;
	h=Message-ID:Subject:From:To:Date:From;
	b=PrAjDdOrVp6EaySNPYIjD211GQ/whiuYjXiW1YkFWRKHvb8lWwZ2JA75qMRj5/0zo
	 uYWqTcgaLqcPKTkK3LNKcBZhIDOw1MYwiYtgEzCXzszgfSF+uOAznDDPgMB5pePWq6
	 HUzO3cAZ/4wcvfg3IXk8irbeEmmt3HIMPbEZe0WU=
Received: from localhost (localhost [127.0.0.1])
	by bedivere.hansenpartnership.com (Postfix) with ESMTP id 9030B1286A68;
	Mon, 01 Jul 2024 22:26:46 -0400 (EDT)
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
 by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavis, port 10024)
 with ESMTP id 1pbM5qQSN7xt; Mon,  1 Jul 2024 22:26:46 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=hansenpartnership.com; s=20151216; t=1719887206;
	bh=7VWvMsjMHz5vpZgJgChD4sJ+XNDMoIvDIOsXcuM/Oys=;
	h=Message-ID:Subject:From:To:Date:From;
	b=PrAjDdOrVp6EaySNPYIjD211GQ/whiuYjXiW1YkFWRKHvb8lWwZ2JA75qMRj5/0zo
	 uYWqTcgaLqcPKTkK3LNKcBZhIDOw1MYwiYtgEzCXzszgfSF+uOAznDDPgMB5pePWq6
	 HUzO3cAZ/4wcvfg3IXk8irbeEmmt3HIMPbEZe0WU=
Received: from lingrow.int.hansenpartnership.com (unknown [IPv6:2601:5c4:4302:c21::a774])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(Client did not present a certificate)
	by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id 976DF1286ABD;
	Mon, 01 Jul 2024 22:26:45 -0400 (EDT)
Message-ID: <912f0f5fe2c02157edb47b1e9c730d1dbc563c55.camel@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 6.10-rc6
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds
	 <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel
	 <linux-kernel@vger.kernel.org>
Date: Mon, 01 Jul 2024 22:26:43 -0400
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

A couple of error leg problems, one affecting scsi_debug and the other
affecting pure SAS (i.e. not SATA) SCSI expanders.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Ming Lei (1):
      scsi: scsi_debug: Fix create target debugfs failure

Xingui Yang (1):
      scsi: libsas: Fix exp-attached device scan after probe failure scanned in again after probe failed

And the diffstat

 drivers/scsi/libsas/sas_internal.h | 14 ++++++++++++++
 drivers/scsi/scsi_debug.c          |  6 +++++-
 2 files changed, 19 insertions(+), 1 deletion(-)

With full diff below

James

---

diff --git a/drivers/scsi/libsas/sas_internal.h b/drivers/scsi/libsas/sas_internal.h
index 85948963fb97..03d6ec1eb970 100644
--- a/drivers/scsi/libsas/sas_internal.h
+++ b/drivers/scsi/libsas/sas_internal.h
@@ -145,6 +145,20 @@ static inline void sas_fail_probe(struct domain_device *dev, const char *func, i
 		func, dev->parent ? "exp-attached" :
 		"direct-attached",
 		SAS_ADDR(dev->sas_addr), err);
+
+	/*
+	 * If the device probe failed, the expander phy attached address
+	 * needs to be reset so that the phy will not be treated as flutter
+	 * in the next revalidation
+	 */
+	if (dev->parent && !dev_is_expander(dev->dev_type)) {
+		struct sas_phy *phy = dev->phy;
+		struct domain_device *parent = dev->parent;
+		struct ex_phy *ex_phy = &parent->ex_dev.ex_phy[phy->number];
+
+		memset(ex_phy->attached_sas_addr, 0, SAS_ADDR_SIZE);
+	}
+
 	sas_unregister_dev(dev->port, dev);
 }
 
diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index acf0592d63da..91f022fb8d0c 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -926,6 +926,7 @@ static const int device_qfull_result =
 static const int condition_met_result = SAM_STAT_CONDITION_MET;
 
 static struct dentry *sdebug_debugfs_root;
+static ASYNC_DOMAIN_EXCLUSIVE(sdebug_async_domain);
 
 static void sdebug_err_free(struct rcu_head *head)
 {
@@ -1148,6 +1149,8 @@ static int sdebug_target_alloc(struct scsi_target *starget)
 	if (!targetip)
 		return -ENOMEM;
 
+	async_synchronize_full_domain(&sdebug_async_domain);
+
 	targetip->debugfs_entry = debugfs_create_dir(dev_name(&starget->dev),
 				sdebug_debugfs_root);
 
@@ -1174,7 +1177,8 @@ static void sdebug_target_destroy(struct scsi_target *starget)
 	targetip = (struct sdebug_target_info *)starget->hostdata;
 	if (targetip) {
 		starget->hostdata = NULL;
-		async_schedule(sdebug_tartget_cleanup_async, targetip);
+		async_schedule_domain(sdebug_tartget_cleanup_async, targetip,
+				&sdebug_async_domain);
 	}
 }
 

