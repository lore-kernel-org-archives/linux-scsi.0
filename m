Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4EE63AA1A1
	for <linux-scsi@vger.kernel.org>; Fri, 25 Sep 2026 18:33:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790361199; cv=none; b=gi/5Q9MUIETszr9o0FQvMTjEc+2WhjPAISg3FVcz7iznsV1wBOsUvpdnRdqLRfNXVb2V1fj5SDbJFj18UE1qof95Ga2eNO6PeBvy1AggGqu95NnwWvoS6IwwHktdam7Lp/OBUgrdBZNJCSONOGp5d91f2c8HztSJE0TQR/OITc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790361199; c=relaxed/simple;
	bh=zlQknLbdpjHzQcJ9hlH5HaL7OX9stKNRv3kn7GlvN+Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pqlxbPKKPTMGHwEaSgYtNojoy/B2JEl54XDddlCa1E8oeSNpYetMuT1fDKqa52Ej+SHBAsQdgIlrCLulKWl7jiulNK4TEvyQvkIC8/VCwqlQT1NaQXcH2nAFecKVL4oYUb1g/aMhtNjUaJ0g2HN9TYQ1IZ8CAOV3JL6qPcOso0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=BKh6rdau; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="BKh6rdau"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4hrzq14sktz1XM5kt;
	Fri, 25 Sep 2026 18:33:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1790361194; x=1792953195; bh=SSEFe
	7+7GsxVT+/7VRNpblj90Niou5nbIwbY6ZMokHU=; b=BKh6rdauAzsu0rsYm5TGG
	2Kj/TD0qvHqnsUNqrkpBxOm79iaXs+VW2PVXbms42Ore/SKj2AgSZINdh25qZemJ
	FMXpFPdEdMfGhdT5hrLt9mGgwUuX8+yqaNQgYjeUDhN2bj1jzjYcAdcQpNhjQkg7
	g5RWPSDpLdN2aCH3wTvFu+OoLflqD1daJb4aisXgMdqakFpGEEka8jTFsBNIhOSw
	ocK5NhI2eBHKmsgxh38zSlw60mClbJMjrjanuZG2UR7yfoyiOUdLj0kpiUZCziio
	2N4KXvD18tp03PouxMDXZ15/Jd8pu4zMLIvU+Ye4BqO+yxhmhxGNGPIRo+jtdDDR
	w==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id G4hHYb7FnN1k; Fri, 25 Sep 2026 18:33:14 +0000 (UTC)
Received: from bvanassche.c.googlers.com.com (148.60.168.34.bc.googleusercontent.com [34.168.60.148])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4hrzpw5mkzz1XM5kW;
	Fri, 25 Sep 2026 18:33:12 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Subject: [PATCH v4 54/54] scsi: drivers: Enable lock context analysis
Date: Fri, 25 Sep 2026 11:26:32 -0700
Message-ID: <91ec026386fea160bc7080de977ce4e076eeb510.1790360262.git.bvanassche@acm.org>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
In-Reply-To: <cover.1790360262.git.bvanassche@acm.org>
References: <cover.1790360262.git.bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Enable lock context analysis for all drivers in the drivers/scsi/ directo=
ry
except for the scsi_debug driver. The scsi_debug driver is excluded becau=
se
of a locking bug in that driver.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/Makefile | 25 ++-----------------------
 1 file changed, 2 insertions(+), 23 deletions(-)

diff --git a/drivers/scsi/Makefile b/drivers/scsi/Makefile
index 533623382eca..370e38625763 100644
--- a/drivers/scsi/Makefile
+++ b/drivers/scsi/Makefile
@@ -14,29 +14,8 @@
 # satisfy certain initialization assumptions in the SCSI layer.
 # *!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!
=20
-CONTEXT_ANALYSIS_constants.o :=3D y
-CONTEXT_ANALYSIS_hosts.o :=3D y
-CONTEXT_ANALYSIS_scsi.o :=3D y
-CONTEXT_ANALYSIS_scsi_common.o :=3D y
-CONTEXT_ANALYSIS_scsi_devinfo.o :=3D y
-CONTEXT_ANALYSIS_scsi_dh.o :=3D y
-CONTEXT_ANALYSIS_scsi_error.o :=3D y
-CONTEXT_ANALYSIS_scsi_ioctl.o :=3D y
-CONTEXT_ANALYSIS_scsi_lib.o :=3D y
-CONTEXT_ANALYSIS_scsi_lib_dma.o :=3D y
-CONTEXT_ANALYSIS_scsi_logging.o :=3D y
-CONTEXT_ANALYSIS_scsi_netlink.o :=3D y
-CONTEXT_ANALYSIS_scsi_pm.o :=3D y
-CONTEXT_ANALYSIS_scsi_proc.o :=3D y
-CONTEXT_ANALYSIS_scsi_scan.o :=3D y
-CONTEXT_ANALYSIS_scsi_sysfs.o :=3D y
-CONTEXT_ANALYSIS_scsi_trace.o :=3D y
-CONTEXT_ANALYSIS_scsicam.o :=3D y
-CONTEXT_ANALYSIS_sd.o :=3D y
-CONTEXT_ANALYSIS_sd_dif.o :=3D y
-CONTEXT_ANALYSIS_sd_zbc.o :=3D y
-CONTEXT_ANALYSIS_sr.o :=3D y
-CONTEXT_ANALYSIS_sr_ioctl.o :=3D y
+CONTEXT_ANALYSIS :=3D y
+CONTEXT_ANALYSIS_scsi_debug.o :=3D n
=20
 CFLAGS_aha152x.o =3D   -DAHA152X_STAT -DAUTOCONF
=20
