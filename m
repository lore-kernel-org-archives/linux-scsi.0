Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1D9A39D6DE
	for <linux-scsi@vger.kernel.org>; Thu, 30 Apr 2026 18:23:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777573424; cv=none; b=oszi90RnaRbGRRlpTsXC+iQlEQp667MqVNULUGwsOCfmNfia0Ob1HBAU/OprVeRucBmTQdeJCMMolIa2hcHUTXazOFbRGXeZ0XpiEEIHpVGYeQmERop4FO7gdwguTThHNDhjCHwO/bR5TRabCLSoG6plfaM5Kt4Y6QuzW0kJUls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777573424; c=relaxed/simple;
	bh=Wqbg8+I4BMEBZ5Yd2MNbHbYp1uH4A+S/5mIZbpbasxw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r8rpzpWZk8EhkaGcHghpbqxH7o8aPe1Qqr8Xkbi4O1YMuOE8AtortX7bAIO527e6gfUxKlEbcSf0fQi3Yps6TyyhyVGldIGq2cPxGOHuaY+HW3PdhwxQ1niHkspoqU0Q65Jw6/QdHE52XF+GnNugMwh/Sc2E5ZxA3sxvp6HsFhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=uQkyY7Vr; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="uQkyY7Vr"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4g62cH2166zm1W13;
	Thu, 30 Apr 2026 18:23:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1777573419; x=1780165420; bh=Vaosc
	cPIH4QlvP3+Ov4vo1JkmtOlCFWwS8RtBBoO9So=; b=uQkyY7VruQq72gyqh37M1
	sG841IWeBgLz96S2NK6pJiWIzCdjDSaVeR0+1Xxy/rzHhLpO7EWVVD3S1mHlD4Nf
	b2IkryWXJbBBzYi0Zr0i4t7iISYNE+/S86Ozj6TtGFdg7fIoXm5HMSdqYHxFtsUy
	YOo1PC5y9gmHs3k0Ztl+yjUefdRDHA/oq3TyzAh5r1STx9oBwUxLQQRUO70zKD36
	SbNPpJK4iLcTPk7lwwtBGlbqZMhBQnX3iaTqATrz8MVuxsuqk3uSwW1YPhkNLu6L
	2RrkG+d/lB0Qt2Wsok003lJ7IiSicz1yevp+zU5y5Eisx8WYAMMgFE9mi+z3dee2
	A==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id kvcTMXzJZG58; Thu, 30 Apr 2026 18:23:39 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4g62c95bxJzlkQM1;
	Thu, 30 Apr 2026 18:23:37 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Marco Elver <elver@google.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Tyrel Datwyler <tyreld@linux.ibm.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v2 30/56] scsi: ibmvscsi_tgt: Enable lock context analysis
Date: Thu, 30 Apr 2026 11:20:00 -0700
Message-ID: <20260430182130.1978347-31-bvanassche@acm.org>
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

Document locking requirements with __must_hold().

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ibmvscsi_tgt/Makefile       | 3 +++
 drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c | 7 +++++++
 2 files changed, 10 insertions(+)

diff --git a/drivers/scsi/ibmvscsi_tgt/Makefile b/drivers/scsi/ibmvscsi_t=
gt/Makefile
index cc7a8256dcf8..7ae12ee9a347 100644
--- a/drivers/scsi/ibmvscsi_tgt/Makefile
+++ b/drivers/scsi/ibmvscsi_tgt/Makefile
@@ -1,4 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0-only
+
+CONTEXT_ANALYSIS :=3D y
+
 obj-$(CONFIG_SCSI_IBMVSCSIS)	+=3D ibmvscsis.o
=20
 ibmvscsis-y :=3D libsrp.o ibmvscsi_tgt.o
diff --git a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c b/drivers/scsi/ibmv=
scsi_tgt/ibmvscsi_tgt.c
index 61f682800765..8e532a195bf9 100644
--- a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
+++ b/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
@@ -251,6 +251,7 @@ static void ibmvscsis_delete_client_info(struct scsi_=
info *vscsi,
  *	Process level, interrupt lock is held
  */
 static long ibmvscsis_free_command_q(struct scsi_info *vscsi)
+	__must_hold(&vscsi->intr_lock)
 {
 	int bytes;
 	u32 flags_under_lock;
@@ -874,6 +875,7 @@ static long ibmvscsis_establish_new_q(struct scsi_inf=
o *vscsi)
  *	Process environment, called with interrupt lock held
  */
 static void ibmvscsis_reset_queue(struct scsi_info *vscsi)
+	__must_hold(&vscsi->intr_lock)
 {
 	int bytes;
 	long rc =3D ADAPT_SUCCESS;
@@ -974,6 +976,7 @@ static void ibmvscsis_free_cmd_resources(struct scsi_=
info *vscsi,
  *	Process or interrupt environment called with interrupt lock held
  */
 static long ibmvscsis_ready_for_suspend(struct scsi_info *vscsi, bool id=
le)
+	__must_hold(&vscsi->intr_lock)
 {
 	long rc =3D 0;
 	struct viosrp_crq *crq;
@@ -1030,6 +1033,7 @@ static long ibmvscsis_ready_for_suspend(struct scsi=
_info *vscsi, bool idle)
  */
 static long ibmvscsis_trans_event(struct scsi_info *vscsi,
 				  struct viosrp_crq *crq)
+	__must_hold(&vscsi->intr_lock)
 {
 	long rc =3D ADAPT_SUCCESS;
=20
@@ -1166,6 +1170,7 @@ static long ibmvscsis_trans_event(struct scsi_info =
*vscsi,
  *	intr_lock must be held
  */
 static void ibmvscsis_poll_cmd_q(struct scsi_info *vscsi)
+	__must_hold(&vscsi->intr_lock)
 {
 	struct viosrp_crq *crq;
 	long rc;
@@ -1310,6 +1315,7 @@ static struct ibmvscsis_cmd *ibmvscsis_get_free_cmd=
(struct scsi_info *vscsi)
  *	Process environment called with interrupt lock held
  */
 static void ibmvscsis_adapter_idle(struct scsi_info *vscsi)
+	__must_hold(&vscsi->intr_lock)
 {
 	int free_qs =3D false;
 	long rc =3D 0;
@@ -2520,6 +2526,7 @@ static long ibmvscsis_ping_response(struct scsi_inf=
o *vscsi)
  */
 static long ibmvscsis_parse_command(struct scsi_info *vscsi,
 				    struct viosrp_crq *crq)
+	__must_hold(&vscsi->intr_lock)
 {
 	long rc =3D ADAPT_SUCCESS;
=20
