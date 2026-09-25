Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D28084D5984
	for <linux-scsi@vger.kernel.org>; Fri, 25 Sep 2026 18:32:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790361159; cv=none; b=PgZtlfRbPoq4svnW88Je1ZXnZfyU8nLAPx75e0RAwj9BZOTm1bOfukoj4zn06TTldgsBlcyDByUY1vfplLyyw+iqmu85oWf0P9IjXQFFzUHvT6/oNuuNrAZkALkkdAK2YzOe6tQL1+AH6hoGOyG4lO2Mk7BhZG9mL7gq9iFjhZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790361159; c=relaxed/simple;
	bh=3iNO5PLRDBSGcb9eyGkS6pveVYV/ebmluetrdf9NovE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PJGPVlIOQDLo7ul+KDUtDwMRg/HDB1OROFSZQgU8NicirJ7aeyXZivQDwJ9m35SR54wf04eoyDVuFkNKgKX8S3AXRGcwBPU7fkXUshDIEAD+gCiQ2RFq71JzcQFFh3Qu3ILKSbNnIaBC3U/XjT8YZAGHNzAURrT9E67izGPxlh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=O2JmULIx; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="O2JmULIx"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4hrzpF3JDSz1XM4Sx;
	Fri, 25 Sep 2026 18:32:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1790361152; x=1792953153; bh=urkgV
	LiKYS1teml//nXAe5gBMIqHHWggAvqc2kUbuK4=; b=O2JmULIxHmipT6JodQxCx
	ZbpcEBVvZVBb5FT3rO3yiyppUAIS5fLxEF8ljCJ7l+io63y/TCLOb6442e8cVRBw
	3hpF1RXCciKYCdUn6hDAVsLdZDaS0OykABmXf2Rh2tQDSbm8Lu5U2UOwLkB0B0jj
	5IrTT1bxFOLR7llyhNas8TNq8WJFiAcd8NyA9YciDRHKMUG3YXk8GDGUgQsc3amg
	wJwO46hehEYfzvP/zOLLxk8qPbefgpDAGv0jBUDoXMHGmwAaEl/V8RUYvPq3E7of
	HZ5/swIDx/GFI93W3mg/rpBoPpWUdw6kJ9M4rQTaU2dZ0pwvPKSZ06djhonD0ryP
	w==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 3H21_VAlYiZa; Fri, 25 Sep 2026 18:32:32 +0000 (UTC)
Received: from bvanassche.c.googlers.com.com (148.60.168.34.bc.googleusercontent.com [34.168.60.148])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4hrzp54bwxz1XM5kW;
	Fri, 25 Sep 2026 18:32:29 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>,
	Kees Cook <kees@kernel.org>
Subject: [PATCH v4 41/54] scsi: mvsas: Enable lock context analysis
Date: Fri, 25 Sep 2026 11:26:19 -0700
Message-ID: <208203a820c27927c13b906fd69620de0f136502.1790360262.git.bvanassche@acm.org>
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

Document locking requirements with __must_hold(). Annotate functions
that perform conditional locking with __context_unsafe().

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/mvsas/Makefile | 2 ++
 drivers/scsi/mvsas/mv_sas.c | 7 +++++++
 2 files changed, 9 insertions(+)

diff --git a/drivers/scsi/mvsas/Makefile b/drivers/scsi/mvsas/Makefile
index 75849258e898..7f45cca38127 100644
--- a/drivers/scsi/mvsas/Makefile
+++ b/drivers/scsi/mvsas/Makefile
@@ -7,6 +7,8 @@
 # Copyright 2009-2011 Marvell. <yuxiangl@marvell.com>
 #
=20
+CONTEXT_ANALYSIS :=3D y
+
 ccflags-$(CONFIG_SCSI_MVSAS_DEBUG) :=3D -DMV_DEBUG
=20
 obj-$(CONFIG_SCSI_MVSAS) +=3D mvsas.o
diff --git a/drivers/scsi/mvsas/mv_sas.c b/drivers/scsi/mvsas/mv_sas.c
index 359226e80eae..d604aaac14a2 100644
--- a/drivers/scsi/mvsas/mv_sas.c
+++ b/drivers/scsi/mvsas/mv_sas.c
@@ -1055,6 +1055,7 @@ void mvs_update_phyinfo(struct mvs_info *mvi, int i=
, int get_st)
 }
=20
 static void mvs_port_notify_formed(struct asd_sas_phy *sas_phy, int lock=
)
+	__context_unsafe(/*conditional locking*/)
 {
 	struct sas_ha_struct *sas_ha =3D sas_phy->ha;
 	struct mvs_info *mvi =3D NULL; int i =3D 0, hi;
@@ -1153,6 +1154,7 @@ static void mvs_free_dev(struct mvs_device *mvi_dev=
)
 }
=20
 static int mvs_dev_found_notify(struct domain_device *dev, int lock)
+	__context_unsafe(/*conditional locking*/)
 {
 	unsigned long flags =3D 0;
 	int res =3D 0;
@@ -1517,6 +1519,7 @@ static int mvs_slot_err(struct mvs_info *mvi, struc=
t sas_task *task,
 }
=20
 int mvs_slot_complete(struct mvs_info *mvi, u32 rx_desc, u32 flags)
+	__must_hold(&mvi->lock)
 {
 	u32 slot_idx =3D rx_desc & RXQ_SLOT_MASK;
 	struct mvs_slot_info *slot =3D &mvi->slot_info[slot_idx];
@@ -1644,6 +1647,7 @@ int mvs_slot_complete(struct mvs_info *mvi, u32 rx_=
desc, u32 flags)
=20
 void mvs_do_release_task(struct mvs_info *mvi,
 		int phy_no, struct domain_device *dev)
+	__must_hold(&mvi->lock)
 {
 	u32 slot_idx;
 	struct mvs_phy *phy;
@@ -1677,6 +1681,7 @@ void mvs_do_release_task(struct mvs_info *mvi,
=20
 void mvs_release_task(struct mvs_info *mvi,
 		      struct domain_device *dev)
+	__must_hold(&mvi->lock)
 {
 	int i, phyno[WIDE_PORT_MAX_PHY], num;
 	num =3D mvs_find_dev_phyno(dev, phyno);
@@ -1769,6 +1774,7 @@ static void mvs_sig_time_out(struct timer_list *t)
 }
=20
 void mvs_int_port(struct mvs_info *mvi, int phy_no, u32 events)
+	__must_hold(&mvi->lock)
 {
 	u32 tmp;
 	struct mvs_phy *phy =3D &mvi->phy[phy_no];
@@ -1862,6 +1868,7 @@ void mvs_int_port(struct mvs_info *mvi, int phy_no,=
 u32 events)
 }
=20
 int mvs_int_rx(struct mvs_info *mvi, bool self_clear)
+	__must_hold(&mvi->lock)
 {
 	u32 rx_prod_idx, rx_desc;
 	bool attn =3D false;
