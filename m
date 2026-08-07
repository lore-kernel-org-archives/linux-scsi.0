Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 871AF2F30
	for <linux-scsi@vger.kernel.org>; Fri,  7 Aug 2026 22:50:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786143049; cv=none; b=sI5kmT9rYrca+TdOJbLYxr9+uKTrwcqMkSBix5Odp7aboaPn3KsBYkRgI8j2Nwm6tzDYJsYFo29v1hmmGvis7Nt+xgmCr7/uXWmlda4HAp5XsouFCf0RW4FDvIqc9nQ0fZB8SpRH+ltUjptztA7WuAeNVAU43+45frRmocJAsQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786143049; c=relaxed/simple;
	bh=UDSdCE74/4o2r53YjZHtwTSER3+QgK3pX7D+Pwl7jP0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lzQD5yGoyiAJ/Y0z+eIIwvboOUdCb01umlukcHyhqwxMAndliQ6ZOuM15R3wuh0PDOmdtHBzfS+5X2DSDXzurl7n6u2ULwvItswIWm9isGFb0D3BTUCkwM+c5ymlO9EIOBFxslI8atdbC3zO8+tBekbf+8YeBmcI04Ca3PsY3ZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=IeBju6xX; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="IeBju6xX"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4hGzrm27cmzlfvq0;
	Fri,  7 Aug 2026 22:50:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1786143044; x=1788735045; bh=872pa
	CzLk2r8OVfYOGWh081zQdr6Ud+CL7/5F7uGo0U=; b=IeBju6xXHOgpA1gKH9T3I
	QusdT0kPzLvdergSRmOrEDG+C9/e+gmNF7Yah7jLL8Mv5KxhqIymF9lwhQcFjaBw
	QOvOf5Yfw4Xjalvfjh7zkQb1lKyTDJNs/oTR66mT4yrcb+Yw1OjUC3Gl72gLNNNF
	Tf8LbdayLoTuiPjx67oF4kirknqhQqEb3MyNeQXugeCOuKx6ia+5vIBv2slFVe3A
	xX6ayy/kBl7so647nRnw0nDkRsP61KMhOwlT3LmuXSCzNoYO9ICew0AAUC6I1Ivn
	pI8mCuMN5UzdYe01D6OTAG0J84D7qjVE7ou2YGbjckf8b6NTALvswyF0n2XoVGe+
	A==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id Zr9nBtPExFTy; Fri,  7 Aug 2026 22:50:44 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4hGzrg2Cr2zlfwgW;
	Fri,  7 Aug 2026 22:50:43 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: John Garry <john.g.garry@oracle.com>,
	Marco Elver <elver@google.com>,
	linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v7 6/6] scsi: core: Enable context analysis
Date: Fri,  7 Aug 2026 15:49:51 -0700
Message-ID: <2576d2f7e3530b721b5050ac6d25c413037d7e7e.1786142946.git.bvanassche@acm.org>
X-Mailer: git-send-email 2.55.0.679.g6767b8d81c-goog
In-Reply-To: <cover.1786142946.git.bvanassche@acm.org>
References: <cover.1786142946.git.bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Enable context analysis for those SCSI core files that build without
triggering any context analysis warnings.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/Makefile                | 22 ++++++++++++++++++++++
 drivers/scsi/device_handler/Makefile |  3 +++
 2 files changed, 25 insertions(+)

diff --git a/drivers/scsi/Makefile b/drivers/scsi/Makefile
index 098f35219e7d..72eb395ccf1d 100644
--- a/drivers/scsi/Makefile
+++ b/drivers/scsi/Makefile
@@ -14,6 +14,28 @@
 # satisfy certain initialization assumptions in the SCSI layer.
 # *!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!
=20
+CONTEXT_ANALYSIS_constants.o :=3D y
+CONTEXT_ANALYSIS_scsi.o :=3D y
+CONTEXT_ANALYSIS_scsi_common.o :=3D y
+CONTEXT_ANALYSIS_scsi_devinfo.o :=3D y
+CONTEXT_ANALYSIS_scsi_dh.o :=3D y
+CONTEXT_ANALYSIS_scsi_error.o :=3D y
+CONTEXT_ANALYSIS_scsi_ioctl.o :=3D y
+CONTEXT_ANALYSIS_scsi_lib.o :=3D y
+CONTEXT_ANALYSIS_scsi_lib_dma.o :=3D y
+CONTEXT_ANALYSIS_scsi_logging.o :=3D y
+CONTEXT_ANALYSIS_scsi_netlink.o :=3D y
+CONTEXT_ANALYSIS_scsi_pm.o :=3D y
+CONTEXT_ANALYSIS_scsi_proc.o :=3D y
+CONTEXT_ANALYSIS_scsi_scan.o :=3D y
+CONTEXT_ANALYSIS_scsi_sysfs.o :=3D y
+CONTEXT_ANALYSIS_scsi_trace.o :=3D y
+CONTEXT_ANALYSIS_scsicam.o :=3D y
+CONTEXT_ANALYSIS_sd.o :=3D y
+CONTEXT_ANALYSIS_sd_dif.o :=3D y
+CONTEXT_ANALYSIS_sd_zbc.o :=3D y
+CONTEXT_ANALYSIS_sr.o :=3D y
+CONTEXT_ANALYSIS_sr_ioctl.o :=3D y
=20
 CFLAGS_aha152x.o =3D   -DAHA152X_STAT -DAUTOCONF
=20
diff --git a/drivers/scsi/device_handler/Makefile b/drivers/scsi/device_h=
andler/Makefile
index 0a603aefd2bb..5aa282a63e24 100644
--- a/drivers/scsi/device_handler/Makefile
+++ b/drivers/scsi/device_handler/Makefile
@@ -2,6 +2,9 @@
 #
 # SCSI Device Handler
 #
+
+CONTEXT_ANALYSIS :=3D y
+
 obj-$(CONFIG_SCSI_DH_RDAC)	+=3D scsi_dh_rdac.o
 obj-$(CONFIG_SCSI_DH_HP_SW)	+=3D scsi_dh_hp_sw.o
 obj-$(CONFIG_SCSI_DH_EMC)	+=3D scsi_dh_emc.o
