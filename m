Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 457EA4594E
	for <linux-scsi@vger.kernel.org>; Sun, 18 Oct 2026 00:41:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792284068; cv=none; b=pH7V4/HJzj3EF6g+Mtw4ayjKAqonE4ge7XRKGBjQeQaTMfi7rs8sxGI/nUx04XGMkhVQnVv21h80nYvYmDYye2OkBp00qr8q6qaNbl7ViApINzmIpHU9rN6GndIvCCmvio3WKo8Yva1i200QkoH/vm+ZQO0Yqdri9wOqCFGbpMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792284068; c=relaxed/simple;
	bh=aLPC+rHvFBjYJdvWCp19ojEMExO/FNau6zm7mtTm8Vk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=c+K5zexC6oMuICuNz/XdnK8WmqgSdp87RS5dQmawC0rAqSNhEwaJA9EgE8vbHZDelCormOTTZmsbpjoEW4BdKLEuvGDkWyKHZVXzTrwyOeyyogXSeVRS8f9w9RmR/vh7sQnajjJp14Tc6nS+OozqkWpc5NNtqU2SgSigSI/xh3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=PE4HWe0J; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="PE4HWe0J"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4j6fxG4M3Fz1XM5kt;
	Sun, 18 Oct 2026 00:41:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:x-mailer:message-id:date
	:date:subject:subject:from:from:received:received; s=mr01; t=
	1792284062; x=1794876063; bh=ql1I17f7DY9fTfE87GeahQ+nI90Orqvabze
	FPAWXNAU=; b=PE4HWe0JD6Xzf4rR8y5B1dcf3prNjKfpMB1ry/fK/LJEtGrsv5M
	FyE+bS+pxnE52TRSzVHSfdB6PYNU7dmT7kRKTieC0F0gBRBnbzugpw8KTaMXb+ly
	bzTFNgzML8wfUwm/F2kKGmbdQVz1Mk8H71NKykpP5a5QRRONUZk3Oqke1U9MOcUR
	yIlnWJdbV/Yf+43i15kwH0R1lfu88qs5zm+QsAPukLWC56SuFyvwRnWyYc3VP9o4
	OmvxDyQ/xNt9El4oElblUWgNMe8Xz74VRtD+CcTu1Jf4tZO/F9d8eBhX/dZmnlFL
	z7hJfkX5C4YrWHtMyasZv/P9n10vrPIrzvQ==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 2yrCtQhCV91y; Sun, 18 Oct 2026 00:41:02 +0000 (UTC)
Received: from bvanassche.c.googlers.com.com (245.199.118.34.bc.googleusercontent.com [34.118.199.245])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4j6fx96j7Jz1XM4Tl;
	Sun, 18 Oct 2026 00:41:01 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Satish Kharat <satishkh@cisco.com>,
	Sesidhar Baddela <sebaddel@cisco.com>,
	Karan Tilak Kumar <kartilak@cisco.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Subject: [PATCH] scsi: fnic: Annotate fnic_nvme functions with __must_hold()
Date: Sat, 17 Oct 2026 17:40:51 -0700
Message-ID: <3c41b84d7d832dd767b30bc04cf875f800ce748d.1792283587.git.bvanassche@acm.org>
X-Mailer: git-send-email 2.56.0.176.g3575e65682-goog
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Add __must_hold() annotations for fnic_lock to
nvfnic_process_ls_abts_rsp(), nvfnic_ls_rsp_recv(),
nvfnic_delete_tport(), and nvfnic_add_tport() in
drivers/scsi/fnic/fnic_nvme.c.

Document that callers must hold fnic_lock on entry and exit because
these functions temporarily release and reacquire fnic_lock, and
suppress context imbalance warnings reported by lock context analysis
and sparse.

Reported-by: Nathan Chancellor <nathan@kernel.org>
Closes: https://lore.kernel.org/all/20261016023120.GA2863622@ax162/
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/fnic/fnic_nvme.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/scsi/fnic/fnic_nvme.c b/drivers/scsi/fnic/fnic_nvme.=
c
index 00d9d5d439a3..d1b327c5c5e0 100644
--- a/drivers/scsi/fnic/fnic_nvme.c
+++ b/drivers/scsi/fnic/fnic_nvme.c
@@ -1284,6 +1284,7 @@ void nvfnic_fcpio_cmpl(struct fnic_io_req *io_req)
=20
 void nvfnic_process_ls_abts_rsp(struct fnic_iport_s *iport,
 		struct fc_frame_header *fchdr)
+	__must_hold(&iport->fnic->fnic_lock)
 {
 	uint32_t tport_fcid;
 	struct fnic_tport_s *tport;
@@ -1348,6 +1349,7 @@ void nvfnic_process_ls_abts_rsp(struct fnic_iport_s=
 *iport,
  */
 void nvfnic_ls_rsp_recv(struct fnic_iport_s *iport,
 		struct fc_frame_header *fchdr, int len)
+	__must_hold(&iport->fnic->fnic_lock)
 {
 	uint8_t *fcid;
 	uint32_t tport_fcid;
@@ -2086,6 +2088,7 @@ void nvfnic_exch_reset(struct fnic_iport_s *iport, =
struct fnic_tport_s *tport)
 void nvfnic_delete_tport(struct fnic_iport_s *iport,
 						struct fnic_tport_s *tport,
 						unsigned long flags)
+	__must_hold(&iport->fnic->fnic_lock)
 {
 	struct fnic *fnic =3D iport->fnic;
 	int ret;
@@ -2179,6 +2182,7 @@ void nvfnic_delete_tport(struct fnic_iport_s *iport=
,
=20
 int nvfnic_add_tport(struct fnic *fnic, struct fnic_tport_s *tport,
 		     unsigned long flags)
+	__must_hold(&fnic->fnic_lock)
 {
 	struct fnic_iport_s *iport =3D &fnic->iport;
 	struct nvme_fc_port_info pinfo;
