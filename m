Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27C51345751
	for <linux-scsi@vger.kernel.org>; Fri,  7 Aug 2026 22:45:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786142744; cv=none; b=gsVk/uyzofu55tjo8fXcLZRM05PyaBR4Zmhqzx8LUQR4QwbC6iaRiiMX/+R5f6EFO3+H4zFDb1+yV0PIfjCeNz9xmOC8jh/ebHeMx4wEqlhXLj2usru6QAAA9u7ZI8o6wKewjvOthq+YfALrnm1h43+4akY+Q6OVuBiHvBmvDQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786142744; c=relaxed/simple;
	bh=UDSdCE74/4o2r53YjZHtwTSER3+QgK3pX7D+Pwl7jP0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M1YiR8ySFiLlEiX0/l/UvrMvx4IX4g8pD+MHXSHCU+PT+ucuC5uRCXnQ34WprxAIGciksQq0qjAiXE5pjFEd9SbZcoATJpK8j56p6AMTIoxZMSdIaULwpnOv9B/OD/6d3XcbzzeLrAkot7aNDwkK5GCZaktKHw+fQiUasYMFfVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=bBdwgyYH; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="bBdwgyYH"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4hGzks4CDrz1XM6JY;
	Fri,  7 Aug 2026 22:45:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1786142738; x=1788734739; bh=872pa
	CzLk2r8OVfYOGWh081zQdr6Ud+CL7/5F7uGo0U=; b=bBdwgyYHV1B9slqVrQDNJ
	t//VX8YIUi1hzkZz8BRhubKdNnOPpkpIUKLA4I9RDeR203rGDOv6ZDufa/CjYORz
	SdlkIROkVD+iXSe4J956B0d7ksk+gefxWNM4l2UnHgGkUccL8Gr86lv9w/+gEhwM
	8hDdmAOhgtEUqo782OplQGEHlcZmOEepNcZy8eFTkp9Df92oL7lSiIY81Q7joHrq
	L7ohN4hYFcWHvBZpHGl1JXJwZ+DmT2NHCvRw/i8i1sPYnqeup9nbQAJh+yt7mfy7
	JJbKbxEDQC9y0ZUMnfXlTcLDYcjTwDq8X2PL7asgWs74ibG4tFgwGYwD41sJ7GNC
	Q==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 0boJtiNbfXgo; Fri,  7 Aug 2026 22:45:38 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4hGzkm4sLSz1XM4Tn;
	Fri,  7 Aug 2026 22:45:36 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: John Garry <john.g.garry@oracle.com>,
	Marco Elver <elver@google.com>,
	linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v6 6/6] scsi: core: Enable context analysis
Date: Fri,  7 Aug 2026 15:44:24 -0700
Message-ID: <2576d2f7e3530b721b5050ac6d25c413037d7e7e.1786142608.git.bvanassche@acm.org>
X-Mailer: git-send-email 2.55.0.679.g6767b8d81c-goog
In-Reply-To: <8fe4526ce272811b28e99048b42358dd8f7c48af.1786142607.git.bvanassche@acm.org>
References: <8fe4526ce272811b28e99048b42358dd8f7c48af.1786142607.git.bvanassche@acm.org>
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
