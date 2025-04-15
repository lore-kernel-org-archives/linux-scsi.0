Received: from mx.treblig.org (mx.treblig.org [46.235.229.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83A0F158535;
	Tue, 15 Apr 2025 00:28:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.235.229.95
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744676898; cv=none; b=PnTxwdrsTJPP294uoOLcygjxCd/qVjUfKlN/eYObUX6bGIVkA3h4epAEfSuMEfnzHxLMRlpXZJ/AMAVz7xgO3tdNL4ap9hjAex9eAJgD5KBpHhF7ODDQg3e+eRP80EWmHcUIFu3v9HhgemNnCuYkLwGjyx/XPpPIEL0G/JByytQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744676898; c=relaxed/simple;
	bh=uwwyvOUW/QnJKlbJSloTLLrbNbLZvfCq7w/19JpgapA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SoKS8jBmwlQe9H2NZyapR7yXv17whXkgBpDtP+h2JePXHgahfk0TzthFYRCzB0MRxvhh3dJihAEbO1Ndea1mtd9XFXNVFpWCaOn5yQfakjiVz5VVwDSns63weNRNlwfBbT3uCK8PKbQkhdyYj3ZsPa/Qn+UaWhIy0JdDTG2IURk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org; spf=pass smtp.mailfrom=treblig.org; dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b=KdkXj/i8; arc=none smtp.client-ip=46.235.229.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=treblig.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b="KdkXj/i8"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=treblig.org
	; s=bytemarkmx; h=MIME-Version:Message-ID:Date:Subject:From:Content-Type:From
	:Subject; bh=EeR6PlpJ6PblJomDo7Q/40ybKoYSkZf5bhbmbd/ljwo=; b=KdkXj/i8Y0E69s7a
	ioXBTWByznvaHYZym2LboYAxN1GgHMvJ741oSS3Hxj6kCtabHm05f4RzglU+rfvcC59VkZCbg+mAw
	udlebSgNmCTo9XOa7w1v0PdwBfd9XBUjhobM/OKHPxcip/809Hl8OGcg5llH9dXmHKwRJnBu74A3E
	I8Ea5lqCdqYaSoZEIu5pyYEbJY1c09hfK8oDw+40ORbLENkcCfDXepNmr0z+8LKRqD0lZIynQfKu3
	tF72AeHQOxw3pIL/7Xf9t3gpWSO5cRz2YJHXBJgHSwEWJoNLVBF+sU75nLcaHHaAdvUMAaVGgkd5v
	HnM9Evg5vJ1b3T3d+Q==;
Received: from localhost ([127.0.0.1] helo=dalek.home.treblig.org)
	by mx.treblig.org with esmtp (Exim 4.96)
	(envelope-from <linux@treblig.org>)
	id 1u4U9n-00BSPG-21;
	Tue, 15 Apr 2025 00:28:07 +0000
From: linux@treblig.org
To: njavali@marvell.com,
	GR-QLogic-Storage-Upstream@marvell.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	"Dr. David Alan Gilbert" <linux@treblig.org>
Subject: [PATCH 6/8] scsi: qla2xxx: Remove unused ql_log_qp
Date: Tue, 15 Apr 2025 01:28:01 +0100
Message-ID: <20250415002803.135909-7-linux@treblig.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250415002803.135909-1-linux@treblig.org>
References: <20250415002803.135909-1-linux@treblig.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Dr. David Alan Gilbert" <linux@treblig.org>

ql_log_qp() was added in 2017 as part of
commit 22d84726e3b8 ("scsi: qla2xxx: Add debug logging routine for qpair")
but has remained unused.

Remove it.
(That patch also added ql_dbg_qp but that is still used so is left in).

Signed-off-by: Dr. David Alan Gilbert <linux@treblig.org>
---
 drivers/scsi/qla2xxx/qla_dbg.c | 53 ----------------------------------
 drivers/scsi/qla2xxx/qla_dbg.h |  3 --
 2 files changed, 56 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
index 691ef827a5ab..5136549005e7 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.c
+++ b/drivers/scsi/qla2xxx/qla_dbg.c
@@ -2705,59 +2705,6 @@ ql_dump_buffer(uint level, scsi_qla_host_t *vha, uint id, const void *buf,
 	}
 }
 
-/*
- * This function is for formatting and logging log messages.
- * It is to be used when vha is available. It formats the message
- * and logs it to the messages file. All the messages will be logged
- * irrespective of value of ql2xextended_error_logging.
- * parameters:
- * level: The level of the log messages to be printed in the
- *        messages file.
- * vha:   Pointer to the scsi_qla_host_t
- * id:    This is a unique id for the level. It identifies the
- *        part of the code from where the message originated.
- * msg:   The message to be displayed.
- */
-void
-ql_log_qp(uint32_t level, struct qla_qpair *qpair, int32_t id,
-    const char *fmt, ...)
-{
-	va_list va;
-	struct va_format vaf;
-	char pbuf[128];
-
-	if (level > ql_errlev)
-		return;
-
-	ql_ktrace(0, level, pbuf, NULL, qpair ? qpair->vha : NULL, id, fmt);
-
-	if (!pbuf[0]) /* set by ql_ktrace */
-		ql_dbg_prefix(pbuf, ARRAY_SIZE(pbuf), NULL,
-			      qpair ? qpair->vha : NULL, id);
-
-	va_start(va, fmt);
-
-	vaf.fmt = fmt;
-	vaf.va = &va;
-
-	switch (level) {
-	case ql_log_fatal: /* FATAL LOG */
-		pr_crit("%s%pV", pbuf, &vaf);
-		break;
-	case ql_log_warn:
-		pr_err("%s%pV", pbuf, &vaf);
-		break;
-	case ql_log_info:
-		pr_warn("%s%pV", pbuf, &vaf);
-		break;
-	default:
-		pr_info("%s%pV", pbuf, &vaf);
-		break;
-	}
-
-	va_end(va);
-}
-
 /*
  * This function is for formatting and logging debug information.
  * It is to be used when vha is available. It formats the message
diff --git a/drivers/scsi/qla2xxx/qla_dbg.h b/drivers/scsi/qla2xxx/qla_dbg.h
index 54f0a412226f..5f4a8c9ae6ba 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.h
+++ b/drivers/scsi/qla2xxx/qla_dbg.h
@@ -334,9 +334,6 @@ ql_log(uint, scsi_qla_host_t *vha, uint, const char *fmt, ...);
 void __attribute__((format (printf, 4, 5)))
 ql_log_pci(uint, struct pci_dev *pdev, uint, const char *fmt, ...);
 
-void __attribute__((format (printf, 4, 5)))
-ql_log_qp(uint32_t, struct qla_qpair *, int32_t, const char *fmt, ...);
-
 /* Debug Levels */
 /* The 0x40000000 is the max value any debug level can have
  * as ql2xextended_error_logging is of type signed int
-- 
2.49.0

