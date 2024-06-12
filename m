Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E97384FB7;
	Wed, 12 Jun 2024 20:37:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718224670; cv=none; b=NZ/KntlwofEsyGeddDruvA7zikRWeRa2g70ZrI1hG2if0UoOIlgV581qqbC7PVFTwpqv9kxyEYQgnLxJd1yEV/q0GGIf5YuKpd0SBgaARPLBde0uVgVOZ3VT5zVNj9HQ2VEo1MWq2qu91SuDmBbV6TbgI/GJvheSdpi24UMznjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718224670; c=relaxed/simple;
	bh=qVdsce9kI7phLWSg6H8f1oBYl958AVtUymwUn2irbvs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kS5IlNSfANIHQnv0jxPhcEIURQJtDT22u6wGUG56RFH24QCYpikzc/lqXsnx5ZWcwieDv2pwAQY5u3IpantJRFEuC1PgLLgakg3hJ/AIlD5bmwz2dQog9pPeH0FL84hPIIuG9dMl4D066TTcrIKCkac00dfXtqpCWGVbdLXRXMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=V/PnVLy9; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="V/PnVLy9"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4Vzy644rBnz6Cnk9X;
	Wed, 12 Jun 2024 20:37:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1718224663; x=1720816664; bh=yEYek
	9bgEzYOmdogb2Tp0iSUExccUecXfH9k7dVFWHc=; b=V/PnVLy9Na1LnEh6+A6Ki
	UBZ24k5kEbInQzIka2dqkgiVQ+irDnoWZz0u4M94WmNSdCNfJwEaOQlXoAvEaBOf
	b4fQbTJuYgIekc09dSmH2f5wnNyMIUHT/r+LVpT6bT511Uz105mmK/c/bonCFdGo
	yXWE9phwDS3n6j8ZcU/vIsGxTAyERVP3J3BOxI74b9mbB3izFpic+52BUIALx5nN
	h61CODWTw/7jjRcEzCX9Jr6HElU6JmsZG4sMOX0GybkLjOEqo52HCIv6p28251oV
	+2eDWkq+xswQKkMkqBfc4TgTEkhQya5PMQTwCXhb6G04uxu6mGRI11v6hRflUTae
	A==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id fISjZYGyZOef; Wed, 12 Jun 2024 20:37:43 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.132.0.90])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4Vzy5y6gb9z6Cp2tZ;
	Wed, 12 Jun 2024 20:37:42 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
	linux-scsi@vger.kernel.org,
	linux-usb@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Joao Machado <jocrismachado@gmail.com>,
	Andy Shevchenko <andy.shevchenko@gmail.com>,
	Christian Heusel <christian@heusel.eu>,
	stable@vger.kernel.org,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v2 1/2] scsi: core: Introduce the BLIST_SKIP_IO_HINTS flag
Date: Wed, 12 Jun 2024 13:37:33 -0700
Message-ID: <20240612203735.4108690-3-bvanassche@acm.org>
X-Mailer: git-send-email 2.45.2.505.gda0bf45e8d-goog
In-Reply-To: <20240612203735.4108690-1-bvanassche@acm.org>
References: <20240612203735.4108690-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Prepare for skipping reading the IO hints VPD page for USB storage device=
s.

Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Joao Machado <jocrismachado@gmail.com>
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Christian Heusel <christian@heusel.eu>
Cc: stable@vger.kernel.org
Fixes: 4f53138fffc2 ("scsi: sd: Translate data lifetime information")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/sd.c           | 4 ++++
 include/scsi/scsi_devinfo.h | 4 +++-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 3a43e2209751..fcf3d7730466 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -63,6 +63,7 @@
 #include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_dbg.h>
 #include <scsi/scsi_device.h>
+#include <scsi/scsi_devinfo.h>
 #include <scsi/scsi_driver.h>
 #include <scsi/scsi_eh.h>
 #include <scsi/scsi_host.h>
@@ -3117,6 +3118,9 @@ static void sd_read_io_hints(struct scsi_disk *sdkp=
, unsigned char *buffer)
 	struct scsi_mode_data data;
 	int res;
=20
+	if (sdp->sdev_bflags & BLIST_SKIP_IO_HINTS)
+		return;
+
 	res =3D scsi_mode_sense(sdp, /*dbd=3D*/0x8, /*modepage=3D*/0x0a,
 			      /*subpage=3D*/0x05, buffer, SD_BUF_SIZE, SD_TIMEOUT,
 			      sdkp->max_retries, &data, &sshdr);
diff --git a/include/scsi/scsi_devinfo.h b/include/scsi/scsi_devinfo.h
index 6b548dc2c496..fa8721e49dec 100644
--- a/include/scsi/scsi_devinfo.h
+++ b/include/scsi/scsi_devinfo.h
@@ -69,8 +69,10 @@
 #define BLIST_RETRY_ITF		((__force blist_flags_t)(1ULL << 32))
 /* Always retry ABORTED_COMMAND with ASC 0xc1 */
 #define BLIST_RETRY_ASC_C1	((__force blist_flags_t)(1ULL << 33))
+/* Do not read the I/O hints mode page */
+#define BLIST_SKIP_IO_HINTS	((__force blist_flags_t)(1ULL << 34))
=20
-#define __BLIST_LAST_USED BLIST_RETRY_ASC_C1
+#define __BLIST_LAST_USED BLIST_SKIP_IO_HINTS
=20
 #define __BLIST_HIGH_UNUSED (~(__BLIST_LAST_USED | \
 			       (__force blist_flags_t) \
