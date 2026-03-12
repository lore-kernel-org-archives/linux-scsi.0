Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50B903C6A39
	for <linux-scsi@vger.kernel.org>; Thu, 12 Mar 2026 21:18:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773350292; cv=none; b=Xlf4C/itUKk1/IgYZl6jGcGlimFIuXZhW0Ne4XbQsMfo+ga9s/Hdjw6x1kFmxnDa1CY1RvioiM+hoVHHPqruETd3/Kogn/EoQ6Rw1iUeGiHHtR5sX4OqtUDl5ZMcH+eH1KxOSkdHmwyWN4ghp5AuLcDOEaJTD4f5qll86NlTciU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773350292; c=relaxed/simple;
	bh=qjjMVCwknV8E5QavW1+KWkIJlHwbuLYfWRSCiiEL9qQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kaDaPzJTpefBGcsSXKs6xs7+Di5t4KNL1tv/uXrubdqAl6CfU9Vf4vDs6DNYp8f21fnJRHzcsffxDACPFoG2/Xb+WIhyTRVKzdvyuUTdDYZPs83Dz6AMZTnbjpJtotWcqpwRPVAOqJXZHp9xL7dCa8MRZ2jxn7kSlMHeghK+l9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=Sl47Px1C; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="Sl47Px1C"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4fX0pB6SMxzlfl5W;
	Thu, 12 Mar 2026 21:18:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1773350285; x=1775942286; bh=8XSlT
	Ju1KIze/MhfQD12ZAB0X4U00ZB43nrRby3ebMc=; b=Sl47Px1CWcihoaU2crCot
	PUpf9ucuIZh5CYvESND0A/CK10ocFkrSdFzGm/aC1hvNZv9On3DTGJq3bETUTs3+
	5rm/hrWm7HGm5JfTPBREClcRj3oYS1YlJf7KEut+P5V4+1rISU/D3f2ED979yUwT
	GrOec2IsaF6O9i+KEN5JXVUlSiwYkS12YVDXt/fAYQoIDfQ+gstxL169A4/+n818
	CUdLotKDX0007NxoSrWZfRP+XghCJHnr2A9c425Fjm8Sp+707QBFHkTlPqjkLsWP
	4Vl70G91C0nOnJn8IZe2mmGDDQGeU9id0KEC/1jOoAEWqvaOR8MdyMN3Tnfa7ryi
	g==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id XSnRw8sy6m5S; Thu, 12 Mar 2026 21:18:05 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4fX0p32cKPzlfl8L;
	Thu, 12 Mar 2026 21:18:03 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@kernel.org>,
	John Garry <john.g.garry@oracle.com>,
	Niklas Cassel <cassel@kernel.org>,
	Thomas Fourier <fourier.thomas@gmail.com>,
	Kees Cook <kees@kernel.org>
Subject: [PATCH 26/36] scsi: mvsas: Prepare for enabling lock context analysis
Date: Thu, 12 Mar 2026 14:15:37 -0700
Message-ID: <20260312211636.3245119-27-bvanassche@acm.org>
X-Mailer: git-send-email 2.53.0.851.ga537e3e6e9-goog
In-Reply-To: <20260312211636.3245119-1-bvanassche@acm.org>
References: <20260312211636.3245119-1-bvanassche@acm.org>
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
 drivers/scsi/mvsas/mv_sas.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/scsi/mvsas/mv_sas.c b/drivers/scsi/mvsas/mv_sas.c
index 359226e80eae..79d79155ba80 100644
--- a/drivers/scsi/mvsas/mv_sas.c
+++ b/drivers/scsi/mvsas/mv_sas.c
@@ -1055,6 +1055,7 @@ void mvs_update_phyinfo(struct mvs_info *mvi, int i=
, int get_st)
 }
=20
 static void mvs_port_notify_formed(struct asd_sas_phy *sas_phy, int lock=
)
+	__no_context_analysis /* conditional locking */
 {
 	struct sas_ha_struct *sas_ha =3D sas_phy->ha;
 	struct mvs_info *mvi =3D NULL; int i =3D 0, hi;
@@ -1153,6 +1154,7 @@ static void mvs_free_dev(struct mvs_device *mvi_dev=
)
 }
=20
 static int mvs_dev_found_notify(struct domain_device *dev, int lock)
+	__no_context_analysis /* conditional locking */
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
