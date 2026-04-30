Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 422CD3537FF
	for <linux-scsi@vger.kernel.org>; Thu, 30 Apr 2026 18:24:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777573485; cv=none; b=JB+jZ5UT4VoEBOppLQzj5suzTL7eCVwkcDL3wPXh1lqqZhbxYuPPrcusVSckishel2ZE2LFr1P/vu1wWdT59k/p7YrsnQu2ibP8qoOezaCMc/LpqCBiVR67dV+sXVtgzPQpfMuWeWraCLOean7H/8/Hf4gip4oiMHh5w1YUqqJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777573485; c=relaxed/simple;
	bh=rJ4tvIgM50dJNYJUZOv6Jbfn5W/lTP9ETjSf/0zN2TM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zlzp22pJTZJ9NI9zvKH1gfoHI3cPNtj8830Fb1/Trlxtqf9c6mZkLpowEKaBYNagQLw7NnbMJOvzwgeArzPjUMXbzZYFhdaeVghB9rW3LSp7pO634ohs+rodjYc8C+9/9iw2KAaF1yr4Hki8qOXN2Bd5HlSk8/fOixIZi2j8em8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=BwD58tfO; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="BwD58tfO"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4g62dR63P9zlh2fq;
	Thu, 30 Apr 2026 18:24:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1777573477; x=1780165478; bh=JzvvY
	7sWq0sW394ARjYdYXMhHd0O8NqLKu+32rkVuiU=; b=BwD58tfONBmUQnIIDuVhN
	99C2TwSRmornIao8Ti8QMN1KdOTl3xJH0TFFQ2LE+YlGs197sH+gB7QA5YTqmvPJ
	Eo0ihboYJsuFT4I/T8RJyzR2amslKo11vydACYZdCEee4AJdUmXbHSd/qWAff4Ag
	fL9lTWt4jy1D9A6soy1S+NrVpSpHlIznH/Z+aH+5xdkSVfvx3HG1v12dmMePKzpl
	r1McjHyzWygEVf+xMGPOVM2e9nixwzJMDp3TEN984ZVCk8N3J3JVkHI5UNt+qx36
	L6hwfDwYspjvzl9lRPlpid5RXX4xpoK+QrOLnY8VXhaVogT4xWawH6DEPojISyUv
	g==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id PbFwctVusSVu; Thu, 30 Apr 2026 18:24:37 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4g62dG3X6RzlfvpH;
	Thu, 30 Apr 2026 18:24:34 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Marco Elver <elver@google.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	Thomas Fourier <fourier.thomas@gmail.com>,
	Kees Cook <kees@kernel.org>
Subject: [PATCH v2 42/56] scsi: mvsas: Enable lock context analysis
Date: Thu, 30 Apr 2026 11:20:12 -0700
Message-ID: <20260430182130.1978347-43-bvanassche@acm.org>
X-Mailer: git-send-email 2.54.0.545.g6539524ca2-goog
In-Reply-To: <20260430182130.1978347-1-bvanassche@acm.org>
References: <20260430182130.1978347-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Document locking requirements with __must_hold(). Annotate functions
that perform conditional locking with __no_context_analysis.

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
index 359226e80eae..f63e0dc1abd2 100644
--- a/drivers/scsi/mvsas/mv_sas.c
+++ b/drivers/scsi/mvsas/mv_sas.c
@@ -1055,6 +1055,7 @@ void mvs_update_phyinfo(struct mvs_info *mvi, int i=
, int get_st)
 }
=20
 static void mvs_port_notify_formed(struct asd_sas_phy *sas_phy, int lock=
)
+	__context_unsafe(conditional locking)
 {
 	struct sas_ha_struct *sas_ha =3D sas_phy->ha;
 	struct mvs_info *mvi =3D NULL; int i =3D 0, hi;
@@ -1153,6 +1154,7 @@ static void mvs_free_dev(struct mvs_device *mvi_dev=
)
 }
=20
 static int mvs_dev_found_notify(struct domain_device *dev, int lock)
+	__context_unsafe(conditional locking)
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
