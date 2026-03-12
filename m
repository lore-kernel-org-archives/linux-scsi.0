Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BD5D3C456A
	for <linux-scsi@vger.kernel.org>; Thu, 12 Mar 2026 21:17:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773350274; cv=none; b=UDCdOQOeW89ku5c/kw8HUJWEb/fapBMrwx7rwD9IRFUJTfS29H3r1rA9Q8YvHVGsy1KSUt8RFOyzIz0w+BEEhLKs9m5J2nSCgp4i77G+5Umtv8gsT6Jgk5n77Eri9FUiUuW1eTjFytxM6QPYC5kHWwJeJgn0zqoTWH1gUj/h1OQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773350274; c=relaxed/simple;
	bh=pjOLlZ4J3FaNldF/9wa/o1sMD1n/N8P7u3G9oDBGgMA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=arLf52C2BDFqSGAquDwM8p3r1zVDJSYOFYLiT2W50XFPgNNXkJN4D1QtP2U/WqRafb23bbb0N7LV1jkQ81y6yx8My0I5DdTxp9j7c3bwRtO8rk6ASgfmFrjdKaXKMKN6tUwH2Jj/EBklQQKA4sBpFwwwHl/wYGGDT13VJ1kbuow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=BtliPY9m; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="BtliPY9m"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4fX0ns1D8kzlfl5V;
	Thu, 12 Mar 2026 21:17:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1773350269; x=1775942270; bh=Uo5Oi
	vh22U9kUfcQnLB1vnFNjvTc95Jty92RAjj79VA=; b=BtliPY9mHIRwB2k7gVzQc
	kLUx/i61/Z9/fwVQcVZbYKI+P/YjLeIDAinEwm0TtG6UJMVmSXKGCN1e37w5yYly
	StLa8foa9xcmlkEzUyV1Q9fCrj8zBKu02Vy63mxqphuknHGZUxTsU1xOR1Zh9w3T
	2Ko/CkZIdQfvX0HHJZxMfdPqCycFaEsVonHqM8GYxkSWueKvcnq6CMhrKYdsFSp2
	3cYhQrc/xnDndi3IPlO/wvjFXm/MvvjqiF/nd7yPpekyU8RnIOFUBTTLAQXfm0jm
	9ix3Z/C/kDvi39A4ndd2Lo+aqhhijKW0xQ4rvQ8Z23379rocIbpA97MKOIp6Zea+
	Q==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id K9XEFfVi1ZW4; Thu, 12 Mar 2026 21:17:49 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4fX0nj3p0hzlfl5W;
	Thu, 12 Mar 2026 21:17:45 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Tyrel Datwyler <tyreld@linux.ibm.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH 18/36] scsi: ibmvscsi_tgt: Prepare for enabling lock context analysis
Date: Thu, 12 Mar 2026 14:15:29 -0700
Message-ID: <20260312211636.3245119-19-bvanassche@acm.org>
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

Document locking requirements with __must_hold().

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c | 7 +++++++
 1 file changed, 7 insertions(+)

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
