Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0063413698B
	for <linux-scsi@vger.kernel.org>; Mon,  3 Jun 2024 17:23:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717435425; cv=none; b=OlKMz10+/jKAeFG26Sg7n3MfP0rd4xJk52Q+SzJi7YdCYQGL2ptz7ryP9NS3FCyphN/S5aO6o1CF7wEQLfOorsOaZGwCaNqyGS3bgrjdiRsOdiwO/SFyj5uf/xqNklRYyuxcYNSOvgmiK977Sq06n1yOzdFUPj4LCU6W+51iR9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717435425; c=relaxed/simple;
	bh=URrDTijxdv9yZ7rKnRbajyPQBqmbr/ja7xxnRV756NE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b/aSWDtIGy6PJNY9xMgjzErCKFPJgO3PdS4IdH7XPedmBa8dFPLeLhTqojoItpM96jnOt7pNWmZVf2AtouRvz8UklR/3x2YRFhVCw6w8wsA9ir2q00h9477OqEiRE+WUN/RmUlOMo11QC7zbvaDHZnqIADGyLWWaUDSepOKOk08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=n6lJnv6+; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="n6lJnv6+"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4VtLDH2wjYzlgMVy;
	Mon,  3 Jun 2024 17:23:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1717435421; x=1720027422; bh=h8Uaz
	6pqrsRTpHNys/o4l2kZGD2BUls3+tQiVTknjbw=; b=n6lJnv6+CyFu/2+yl/f96
	F3UKRvUgBumKJYVw7Yr9pRwALb5uGVnm9K/iG0IKAZf5kInfXKL23beym3/uzf41
	K5S2G2sueW3ZUAxgd0pR8qm0Ltjqe2cETMB42Dv57yq0+dBj5RpPslRBAHdNsytY
	ua7dF4nd6rKyMMGkaPU9ls40LI0OqvNhMARU2lgAGgze6I8ScI6VZzdSs8BVHQS1
	BLdko5qUaMQ8flNm12rBlexHzpjg5I60LeawSboPmJBDwreF3m0dE2EhTurZ63OS
	iQmhEG4aw8Hfw89q2qwJl8MpWMWrQ6lhlXgIWBLqpE895Fv5Z/cEz58mtrWP5LN0
	g==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id KXdT71jOzc37; Mon,  3 Jun 2024 17:23:41 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.132.0.90])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4VtLDF0GyqzlgMVb;
	Mon,  3 Jun 2024 17:23:40 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Russell King <linux@armlinux.org.uk>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH 1/4] scsi: acornscsi: Declare local functions static
Date: Mon,  3 Jun 2024 10:23:08 -0700
Message-ID: <20240603172311.1587589-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.45.1.288.g0e0cd299f1-goog
In-Reply-To: <20240603172311.1587589-1-bvanassche@acm.org>
References: <20240603172311.1587589-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/arm/acornscsi.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/arm/acornscsi.c b/drivers/scsi/arm/acornscsi.c
index 0b046e4b395c..e50a3dbf9de3 100644
--- a/drivers/scsi/arm/acornscsi.c
+++ b/drivers/scsi/arm/acornscsi.c
@@ -2450,7 +2450,7 @@ static int acornscsi_queuecmd_lck(struct scsi_cmnd =
*SCpnt)
     return 0;
 }
=20
-DEF_SCSI_QCMD(acornscsi_queuecmd)
+static DEF_SCSI_QCMD(acornscsi_queuecmd)
=20
 enum res_abort { res_not_running, res_success, res_success_clear, res_sn=
ooze };
=20
@@ -2552,7 +2552,7 @@ static enum res_abort acornscsi_do_abort(AS_Host *h=
ost, struct scsi_cmnd *SCpnt)
  * Params   : SCpnt - command to abort
  * Returns  : one of SCSI_ABORT_ macros
  */
-int acornscsi_abort(struct scsi_cmnd *SCpnt)
+static int acornscsi_abort(struct scsi_cmnd *SCpnt)
 {
 	AS_Host *host =3D (AS_Host *) SCpnt->device->host->hostdata;
 	int result;
@@ -2634,7 +2634,7 @@ int acornscsi_abort(struct scsi_cmnd *SCpnt)
  * Params   : SCpnt  - command causing reset
  * Returns  : one of SCSI_RESET_ macros
  */
-int acornscsi_host_reset(struct scsi_cmnd *SCpnt)
+static int acornscsi_host_reset(struct scsi_cmnd *SCpnt)
 {
 	AS_Host *host =3D (AS_Host *)SCpnt->device->host->hostdata;
 	struct scsi_cmnd *SCptr;
@@ -2679,8 +2679,7 @@ int acornscsi_host_reset(struct scsi_cmnd *SCpnt)
  * Params  : host - host to give information on
  * Returns : a constant string
  */
-const
-char *acornscsi_info(struct Scsi_Host *host)
+static const char *acornscsi_info(struct Scsi_Host *host)
 {
     static char string[100], *p;
=20
