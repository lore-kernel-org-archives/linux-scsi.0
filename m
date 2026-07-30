Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F1C03D5221
	for <linux-scsi@vger.kernel.org>; Thu, 30 Jul 2026 22:48:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785451737; cv=none; b=WT14ZjAQxqIrFbRPzoeWyIbT6hyQnWA0ifA5lKekMpQRSfkZ7Wp7+eyyjWcsm8Nc5ZaQSqoozLUfjE1k2NR0YxGNuQVP/dwyc2W6EhbdPotFK+Qeu/4TaBLIiD6VP5UsW+aM6R0Pi+KEOnW7/xHvHNGFlKNmKiYcUSrz4dZNOdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785451737; c=relaxed/simple;
	bh=rJ4tvIgM50dJNYJUZOv6Jbfn5W/lTP9ETjSf/0zN2TM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mk18rRgzUME53qMreRd3qMDtBNeOr3nV4ocEtEliWo0+d048GIpaisz8ywboCkCn8vzS+fJuBVHaWlycOoHKCEd1pY57e7MDSMn2N2mZKId6BzFIDjWgKRglWgjnoVjBxFccbOhh/1Pe/PbTdbRQG7LxjUICZmYfbZUG5Bl4NU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=BCkIL41N; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="BCkIL41N"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4hB4BH6XlLz1XM30r;
	Thu, 30 Jul 2026 22:48:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1785451729; x=1788043730; bh=JzvvY
	7sWq0sW394ARjYdYXMhHd0O8NqLKu+32rkVuiU=; b=BCkIL41N2+MQ73anUsliD
	F1g8yeziuHFQKf7go5rWv3fusNo5CiZcyX89HFruYGxOsk4vN9TkcZHIGQMg0mKT
	5JwJQSbW1iBRf/j0wURwNRWzSiFfay5fJ0XBBbSmCMQFf10KRsMTpuU2P/ZbfIdU
	LBDilvgVsNwXgKnQ6AxtzoE6PtQjdGlpeZb+loU5L3gUWBWvreBoHBiRDmLu0ilw
	wsJl1PBisq74NWa/RLQQiB2SB0QYQ7QJEoEhvhufNgD+tMPVaGRNcBygOvSm+eAG
	IPFBNm9yShUuaaxC3JUkVUevejsUNkuHfnxoTvJxUqZAvm2HAfMC/tgwyVO1lnFW
	A==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id DRcrlcmf5Abm; Thu, 30 Jul 2026 22:48:49 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4hB4B73v0Dz1XM30k;
	Thu, 30 Jul 2026 22:48:47 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Marco Elver <elver@google.com>,
	linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Kees Cook <kees@kernel.org>,
	John Garry <john.g.garry@oracle.com>,
	Niklas Cassel <cassel@kernel.org>
Subject: [PATCH v3 42/57] scsi: mvsas: Enable lock context analysis
Date: Thu, 30 Jul 2026 15:45:25 -0700
Message-ID: <5e65b2732191612e2dc82258c1b3c25831ec958f.1785451174.git.bvanassche@acm.org>
X-Mailer: git-send-email 2.55.0.508.g3f0d502094-goog
In-Reply-To: <cover.1785451174.git.bvanassche@acm.org>
References: <cover.1785451174.git.bvanassche@acm.org>
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
