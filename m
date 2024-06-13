Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56FD113D243;
	Thu, 13 Jun 2024 21:18:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718313540; cv=none; b=itgKkDDKAyCdh+9XeKyPnrJDJ60lA0Pun5Yat2q8e6Qm4UnMKn7X7Nx6Zd2PimZugbq9IShJaT8Ce9wZzn5e5qX3MgpohrXd3kqjsqZQOSTtDhNSMkZMB3Q9lFhRaidzsfCa5WxOL0BtL53DWrPpXTdwHc87mmQWPC3kWKxcBjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718313540; c=relaxed/simple;
	bh=FiKVW0wZ+Y09epymmFWsZIe0hWkZ9SjWUvaN6eSdRJc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l5WVemQXAplcSVBonyKopfNdLMxkSR3edOhIhmeXIaOPU+eocwA6S/3EDOKQ6LyZLMrhuar4HsYMruFS7kK1k8DWtOFFrEKJkpeSmUab7aREy7OT/rg6floDYYdM8G1STLNptce9DNraYyBQwMlyiXTm7VCZsaz3mc3TkGTVyV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=An8/2Fxf; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="An8/2Fxf"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4W0Zz664Y2zlgMVV;
	Thu, 13 Jun 2024 21:18:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1718313534; x=1720905535; bh=hRjwi
	sCRW+42XD56aJIGghuXRjkwKRzKpLBkptDCAso=; b=An8/2Fxf2tXy7IYpKFJmQ
	RlOlddBbDGXJ/yRj7IJpXaIcTMlB1H+e7ZY4f2xkbwlE7IVM6ewLI7AcMEi3gb21
	N/IeuQzXapnecCBK5Kni3DxTh7mqgePCrac27uDE8OBBvw9xI1vKNak+MkbrDX+J
	F5krQV9CbHnIWboM9WUnZvGrNojGIXHC6VVrdvtXvB/L+1LBTfltxC/GB182+EJj
	3WaotLaWxRVg8s4eKfYvb4TtLSzIsERBpdnyf2ZkPF6qjhw5jOEzJd9zmNr22u/l
	9ras0dtpAnJhfHPcSLvnxr23QDp2LE9wj+MuIvDoXzeTWaoDkrRxeMf5bntCqkb6
	Q==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id nVcG7BlvKVaz; Thu, 13 Jun 2024 21:18:54 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.132.0.90])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4W0Zz140S2zlgMVW;
	Thu, 13 Jun 2024 21:18:53 +0000 (UTC)
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
Subject: [PATCH v3 1/2] scsi: core: Introduce the BLIST_SKIP_IO_HINTS flag
Date: Thu, 13 Jun 2024 14:18:26 -0700
Message-ID: <20240613211828.2077477-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.45.2.627.g7a2c4fd464-goog
In-Reply-To: <20240613211828.2077477-1-bvanassche@acm.org>
References: <20240613211828.2077477-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Prepare for skipping the IO advice hints grouping mode page for USB stora=
ge
devices.

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
index 6b548dc2c496..5856b68a5180 100644
--- a/include/scsi/scsi_devinfo.h
+++ b/include/scsi/scsi_devinfo.h
@@ -69,8 +69,10 @@
 #define BLIST_RETRY_ITF		((__force blist_flags_t)(1ULL << 32))
 /* Always retry ABORTED_COMMAND with ASC 0xc1 */
 #define BLIST_RETRY_ASC_C1	((__force blist_flags_t)(1ULL << 33))
+/* Do not query the IO advice hints grouping mode page */
+#define BLIST_SKIP_IO_HINTS	((__force blist_flags_t)(1ULL << 34))
=20
-#define __BLIST_LAST_USED BLIST_RETRY_ASC_C1
+#define __BLIST_LAST_USED BLIST_SKIP_IO_HINTS
=20
 #define __BLIST_HIGH_UNUSED (~(__BLIST_LAST_USED | \
 			       (__force blist_flags_t) \
