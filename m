Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E37B1891A9;
	Mon, 14 Jul 2025 00:57:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752454634; cv=none; b=ulJFM+sQj6yBG2Z7yvHJIQNbBCDze2mHfstJTFF/O9UaEqVXVuZu8ZU2frIZKOGpwuNu8vqkh73l/XFSeaA0YXflAds89kn/jIJilA46mzlxOQrzB7IYMnaXH4O3szfwlPb1HER7P0pe/GPPQ5o3ZvolgtGH7f0rnS1J2YBhXqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752454634; c=relaxed/simple;
	bh=7qwvXDduW+5S26morZnMCUX461kUh7KosRJqVyRGacQ=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XrNDIQ6iRum1+PBIlXM9LPsWYgpoCglqhlmFiQgZlt/v3HYpKMFT4ZkIH2WzJylX17eDmQJ0YZzGsimW26aNEL3bu9nltQY1PjHL9bseuVjKiwn0ZC6X3mu9MUckNWW0ZR6N6ZPtJxWLpvri0SdyijvbWXtqXB/VaNAV7EcRee0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rB5n73w5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rB5n73w5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A424DC4CEE3;
	Mon, 14 Jul 2025 00:57:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752454634;
	bh=7qwvXDduW+5S26morZnMCUX461kUh7KosRJqVyRGacQ=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=rB5n73w5jr3Hj/gO+glroCoEKhU1Lp6HOeafK4njPfHw0cmHXMsvxWsBwLQ3q6LCv
	 Ba8YCb8xuthZ0zIU0hfYudwBPu02KwDoqUZfaPhACx1zrhKSz1+4maGrdYaiyItvvI
	 TwHK5o96ehFvBtZTSmXEdiqkDy2nZ4hsDMBy32GUuFfmEuk/11T0t1r0eMMwRP/Q3H
	 Msid+uYOkh6/jn62KMjOvx9cCyfM+4I7A4YBG2QeZn4+eXNpQwQW9zz2b7BR2K4PnK
	 7KmCBmvVhNjPdjBH81SwVM6ByNyRo0gSsjs9MeHyWpMFC/sPMG3Zz1mq1lwiO79z/o
	 9tGGIA25TBJZw==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-ide@vger.kernel.org,
	Niklas Cassel <cassel@kernel.org>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	John Garry <john.g.garry@oracle.com>,
	Jason Yan <yanaijie@huawei.com>
Subject: [PATCH v4 1/3] ata: libata-eh: Remove ata_do_eh()
Date: Mon, 14 Jul 2025 09:54:52 +0900
Message-ID: <20250714005454.35802-2-dlemoal@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250714005454.35802-1-dlemoal@kernel.org>
References: <20250714005454.35802-1-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The only reason for ata_do_eh() to exist is that the two caller sites,
ata_std_error_handler() and ata_sff_error_handler() may pass it a
NULL hardreset operation so that the built-in (generic) hardreset
operation for a driver is ignored if the adapter SCR access is not
available.

However, ata_std_error_handler() and ata_sff_error_handler()
modifications of the hardreset port operation can easily be combined as
they are mutually exclusive. That is, a driver using sata_std_hardreset()
as its hardreset operation cannot use sata_sff_hardreset() and
vice-versa.

With this observation, ata_do_eh() can be removed and its code moved to
ata_std_error_handler(). The condition used to ignore the built-in
hardreset port operation is modified to be the one that was used in
ata_sff_error_handler(). This requires defining a stub for the function
sata_sff_hardreset() to avoid compilation errors when CONFIG_ATA_SFF is
not enabled. Furthermore, instead of modifying the local hardreset
operation definition, set the ATA_LFLAG_NO_HRST link flag to prevent
the use of built-in hardreset methods for ports without a valid scr_read
function. This flag is checked in ata_eh_reset() and if set, the
hardreset method is ignored.

This change simplifies ata_sff_error_handler() as this function now only
needs to call ata_std_error_handler().

No functional changes.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 drivers/ata/libata-eh.c  | 48 ++++++++++++----------------------------
 drivers/ata/libata-sff.c | 10 +--------
 include/linux/libata.h   |  9 +++++---
 3 files changed, 21 insertions(+), 46 deletions(-)

diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index 436536112043..30c831e56a7f 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -4067,59 +4067,39 @@ void ata_eh_finish(struct ata_port *ap)
 }
 
 /**
- *	ata_do_eh - do standard error handling
+ *	ata_std_error_handler - standard error handler
  *	@ap: host port to handle error for
  *
- *	@prereset: prereset method (can be NULL)
- *	@softreset: softreset method (can be NULL)
- *	@hardreset: hardreset method (can be NULL)
- *	@postreset: postreset method (can be NULL)
- *
  *	Perform standard error handling sequence.
  *
  *	LOCKING:
  *	Kernel thread context (may sleep).
  */
-void ata_do_eh(struct ata_port *ap, ata_prereset_fn_t prereset,
-	       ata_reset_fn_t softreset, ata_reset_fn_t hardreset,
-	       ata_postreset_fn_t postreset)
+void ata_std_error_handler(struct ata_port *ap)
 {
-	struct ata_device *dev;
+	struct ata_port_operations *ops = ap->ops;
+	struct ata_link *link = &ap->link;
 	int rc;
 
+	/* Ignore built-in hardresets if SCR access is not available */
+	if ((ops->hardreset == sata_std_hardreset ||
+	     ops->hardreset == sata_sff_hardreset) && !sata_scr_valid(link))
+		link->flags |= ATA_LFLAG_NO_HRST;
+
 	ata_eh_autopsy(ap);
 	ata_eh_report(ap);
 
-	rc = ata_eh_recover(ap, prereset, softreset, hardreset, postreset,
-			    NULL);
+	rc = ata_eh_recover(ap, ops->prereset, ops->softreset,
+			    ops->hardreset, ops->postreset, NULL);
 	if (rc) {
-		ata_for_each_dev(dev, &ap->link, ALL)
+		struct ata_device *dev;
+
+		ata_for_each_dev(dev, link, ALL)
 			ata_dev_disable(dev);
 	}
 
 	ata_eh_finish(ap);
 }
-
-/**
- *	ata_std_error_handler - standard error handler
- *	@ap: host port to handle error for
- *
- *	Standard error handler
- *
- *	LOCKING:
- *	Kernel thread context (may sleep).
- */
-void ata_std_error_handler(struct ata_port *ap)
-{
-	struct ata_port_operations *ops = ap->ops;
-	ata_reset_fn_t hardreset = ops->hardreset;
-
-	/* ignore built-in hardreset if SCR access is not available */
-	if (hardreset == sata_std_hardreset && !sata_scr_valid(&ap->link))
-		hardreset = NULL;
-
-	ata_do_eh(ap, ops->prereset, ops->softreset, hardreset, ops->postreset);
-}
 EXPORT_SYMBOL_GPL(ata_std_error_handler);
 
 #ifdef CONFIG_PM
diff --git a/drivers/ata/libata-sff.c b/drivers/ata/libata-sff.c
index 5a46c066abc3..e61f00779e40 100644
--- a/drivers/ata/libata-sff.c
+++ b/drivers/ata/libata-sff.c
@@ -2054,8 +2054,6 @@ EXPORT_SYMBOL_GPL(ata_sff_drain_fifo);
  */
 void ata_sff_error_handler(struct ata_port *ap)
 {
-	ata_reset_fn_t softreset = ap->ops->softreset;
-	ata_reset_fn_t hardreset = ap->ops->hardreset;
 	struct ata_queued_cmd *qc;
 	unsigned long flags;
 
@@ -2077,13 +2075,7 @@ void ata_sff_error_handler(struct ata_port *ap)
 
 	spin_unlock_irqrestore(ap->lock, flags);
 
-	/* ignore built-in hardresets if SCR access is not available */
-	if ((hardreset == sata_std_hardreset ||
-	     hardreset == sata_sff_hardreset) && !sata_scr_valid(&ap->link))
-		hardreset = NULL;
-
-	ata_do_eh(ap, ap->ops->prereset, softreset, hardreset,
-		  ap->ops->postreset);
+	ata_std_error_handler(ap);
 }
 EXPORT_SYMBOL_GPL(ata_sff_error_handler);
 
diff --git a/include/linux/libata.h b/include/linux/libata.h
index d092747be588..cf0b3fff3198 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -1412,9 +1412,6 @@ extern void ata_eh_thaw_port(struct ata_port *ap);
 extern void ata_eh_qc_complete(struct ata_queued_cmd *qc);
 extern void ata_eh_qc_retry(struct ata_queued_cmd *qc);
 
-extern void ata_do_eh(struct ata_port *ap, ata_prereset_fn_t prereset,
-		      ata_reset_fn_t softreset, ata_reset_fn_t hardreset,
-		      ata_postreset_fn_t postreset);
 extern void ata_std_error_handler(struct ata_port *ap);
 extern void ata_std_sched_eh(struct ata_port *ap);
 extern void ata_std_end_eh(struct ata_port *ap);
@@ -2152,6 +2149,12 @@ static inline u8 ata_wait_idle(struct ata_port *ap)
 
 	return status;
 }
+#else /* CONFIG_ATA_SFF */
+static inline int sata_sff_hardreset(struct ata_link *link, unsigned int *class,
+				     unsigned long deadline)
+{
+	return -EOPNOTSUPP;
+}
 #endif /* CONFIG_ATA_SFF */
 
 #endif /* __LINUX_LIBATA_H__ */
-- 
2.50.1

