Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F590FC02;
	Fri,  7 Jun 2024 01:17:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717723052; cv=none; b=O3+5PmcsumLDC/bBvuB6xgTsP58bxUWa8b4odXesvErPuRtF3BJiFziBPh6bXf1peI2jSUVAMDoAhiP9RaToL3cqsZoTpADl4ptZAwE18KKlvOs8rOoIKFaDQxEHfuIFEEwv/Sdke7MU2JrEMNMAE+TRe7rMt1X2UGsg45P0jcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717723052; c=relaxed/simple;
	bh=FYRngkhgGgfJjkyIA3QVacDQ9yUC5Q90KNhq+/oi63s=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=HCMRZuttn1WO7GMkfBwWImmlgX3rgsSkALrUXZf5Y9QsyFn6ogUasZtOis/D1oG8qHFthOQ6ZG8KDEhMbsr3SD2iYowW+nmLvMqESR3JGw+acCslxnM92dsoLiOLrWHZ0A2SR9FJ2Xv1rmRfzqhCxLMVSTSukRa/fILUhgCAhZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=ltr4w4x4; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="ltr4w4x4"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4VwNbW657Qz6Cnk9Y;
	Fri,  7 Jun 2024 01:17:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:x-mailer:message-id:date
	:date:subject:subject:from:from:received:received; s=mr01; t=
	1717723044; x=1720315045; bh=VP/wPXWXbhw4UPJxDcMkq5aVkaQOj8VYrPN
	d+MMaFQw=; b=ltr4w4x4hGMWO82k268JuOxZ/wJNk4s4xvr968KIaFU5Ehen/UZ
	r+8VwIkKdrSHe/jTVcODTBVcwEMFk6aclgG0j7OffVynxvytPOJX3Mjb5gQnQdfc
	lvPbGOALQ92wmVHiq/FEauCVxogHUn57s95wJWnK5V2QRG2il7wtXGQPHAOG66Zu
	cuOx8t/xkYp+v4k28s8oj4IoIB6r2UaGYWnDHrC08kgS87dbEFbR9LLk5o8cdcqC
	hCiG8G/lrBkig2UuUH/+9Rou70iYjADYNTkDEHD19Zt0kituFhrXqkKHDTkP/f8M
	IXhGZSwIAEW/aB0GTbrg+q3QpaS5mr6EjeA==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id FBuDYg4T2Vur; Fri,  7 Jun 2024 01:17:24 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.132.0.90])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4VwNbQ6BMcz6Cnk9W;
	Fri,  7 Jun 2024 01:17:22 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Joao Machado <jocrismachado@gmail.com>,
	stable@vger.kernel.org,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH] scsi: core: Do not query the IO hints for a particular USB device
Date: Thu,  6 Jun 2024 18:16:51 -0700
Message-ID: <20240607011651.1618706-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.45.2.505.gda0bf45e8d-goog
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Recently it was reported that Kingston DataTraveler G2 USB devices are
unusable with 6.9.x kernels. Hence this patch that skips reading the IO
hints VPD page for these USB devices.

Cc: Joao Machado <jocrismachado@gmail.com>
Cc: stable@vger.kernel.org
Fixes: 4f53138fffc2 ("scsi: sd: Translate data lifetime information")
Reported-by: Joao Machado <jocrismachado@gmail.com>
Closes: https://lore.kernel.org/linux-scsi/CACLx9VdpUanftfPo2jVAqXdcWe8Y4=
3MsDeZmMPooTzVaVJAh2w@mail.gmail.com/
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_devinfo.c | 1 +
 drivers/scsi/sd.c           | 4 ++++
 include/scsi/scsi_devinfo.h | 4 +++-
 3 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_devinfo.c b/drivers/scsi/scsi_devinfo.c
index a7071e71389e..85111e14c53b 100644
--- a/drivers/scsi/scsi_devinfo.c
+++ b/drivers/scsi/scsi_devinfo.c
@@ -197,6 +197,7 @@ static struct {
 	{"INSITE", "I325VM", NULL, BLIST_KEY},
 	{"Intel", "Multi-Flex", NULL, BLIST_NO_RSOC},
 	{"iRiver", "iFP Mass Driver", NULL, BLIST_NOT_LOCKABLE | BLIST_INQUIRY_=
36},
+	{"Kingston", "DataTraveler G2", NULL, BLIST_SKIP_IO_HINTS},
 	{"LASOUND", "CDX7405", "3.10", BLIST_MAX5LUN | BLIST_SINGLELUN},
 	{"Marvell", "Console", NULL, BLIST_SKIP_VPD_PAGES},
 	{"Marvell", "91xx Config", "1.01", BLIST_SKIP_VPD_PAGES},
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
