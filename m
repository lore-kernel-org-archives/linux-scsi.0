Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3A49346AE3
	for <linux-scsi@vger.kernel.org>; Wed,  5 Aug 2026 21:37:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785965871; cv=none; b=Ph4GgqwQ6L3CIhC4uyy8IYHv5IHbdYbnyrbDbdmps357w0nued79B5TBsMTT4L3RMAsN/LPJ9h/XGnt9iHqQ3uBaY7qvo3OLK0r9dcpWS/0i2hy0PYn3aHIo8nEHM3wk9/ZOTiFJ7DiKDdfV1iDULPwcIccfD8OH3nzIjiThxyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785965871; c=relaxed/simple;
	bh=HVv26ryUF+GjKg2RecUUl2dFlTmEdrVXfzWyoJgj9Go=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qSqsW9b61Up1Q4hml/LaR2BESh3eTjoif9IEIBUGSx+Q6o05iX+C2ifAthhId/aL3194/RUKooGxz9KPb3uM33pzh38a2HiDHHw7FYUVgDHAQg6BHldjg3AM/umI6k8o0VfKvxCjngek+No0796Qn2/fbFcHGvyGe8rScESllMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=VBIPqoXi; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="VBIPqoXi"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4hFkKV2q4Sz1XM30n;
	Wed,  5 Aug 2026 21:37:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1785965866; x=1788557867; bh=FxI45
	/yHnsSVi+zfh84QH7cSvAg/1FfDo8aUyEjda2Q=; b=VBIPqoXi4rBHIYXQX4IBP
	dNgeDYyqTbynxTXbytAepmbXDoddYDcHQvWMB7eIEFumO6MZ6+3z3MiwVaZRj4Zs
	0rMqqgjpTdx+fN1vbGD8zydBZYg7K3w+CTy15uCQJ1ALLoeiUM/iWBQdKrSoh8+0
	4eTYiXw0u5ua/UBRyiONwprQPrVp0HpIlckdLgObiwZODq9VeO98qtv6c52ugQr4
	NyMt1psM+RiBVzfFz2efjncoSDrh0QuVjW/5gNRgYp9AX12Q8UQoL+EBEngE/Lu/
	Vpv8MybgjbNA8psN934oKHxhlNcZJeZQgPLBADzKRDPNxuCRgL3dzXjpwR1LEWFz
	w==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 38ZdUE1rbYX5; Wed,  5 Aug 2026 21:37:46 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4hFkKN72Wrz1XM4TB;
	Wed,  5 Aug 2026 21:37:44 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: John Garry <john.g.garry@oracle.com>,
	Marco Elver <elver@google.com>,
	linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v5 6/6] scsi: core: Enable lock context analysis
Date: Wed,  5 Aug 2026 14:36:53 -0700
Message-ID: <9b8e6e601725f0a6b8ac1b9609426734f4ed502d.1785965531.git.bvanassche@acm.org>
X-Mailer: git-send-email 2.55.0.629.g250fe7f194-goog
In-Reply-To: <cover.1785965531.git.bvanassche@acm.org>
References: <cover.1785965531.git.bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Enable lock context analysis for those SCSI core files that build
without triggering any compiler warnings.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/Makefile                | 22 ++++++++++++++++++++++
 drivers/scsi/device_handler/Makefile |  3 +++
 2 files changed, 25 insertions(+)

diff --git a/drivers/scsi/Makefile b/drivers/scsi/Makefile
index 842c254bb226..7677fece9dcd 100644
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
