Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F85437C911
	for <linux-scsi@vger.kernel.org>; Fri, 31 Jul 2026 21:53:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785534787; cv=none; b=SY2qBprRqkyPUZ/vf8vy+BsC6e28o24pAv3OwfeoNZSmgWUvE1DDpLKf7qIfk4q9YzZ+Cm/Rafn8bdlTAhmRceL78xNAo71vr508bPaLdP2iRzBCZpLk1ggXFF9t+nACetlKZJObCdI9OU1h9SZOnMgzIUJ/3eRhR+ojoVtsyEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785534787; c=relaxed/simple;
	bh=rjSvNstV+g5rr8ipz3jqzaPOs7kXHwkYONm1JfaQ+8U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RlXl6j54ohaULRs/EIgiQMnP5jaNVPI4dMyz7fL4HhMP6J2eOfVBdITaM4+ho6yTYj7s4D73+4xzvLU6pC0k8Ak0Bz71XS+6KEBzbBZcDYK4q+Tb/0gzJZYuKlpICcHj1eX0Qx2u8ytt9xMmd5cwwRn6wbwpyu+Nn/GGj9Px/q0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=dBU1Fi0H; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="dBU1Fi0H"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4hBfvP4gMtzlfvq7;
	Fri, 31 Jul 2026 21:53:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1785534782; x=1788126783; bh=kxSRk
	Hd9sNVNF9OS5lAm/Lu/BFEBRlgDHdM2SbItl4c=; b=dBU1Fi0H7OoQ0pTtfVvED
	JeMrUVCngWkigz8dRJqB1xNG0g/7TuPkoIh/iJKYuuQSMgxD7De9HThPpUiZWoTl
	RhNFBcoHdFdi6DrFDE4BPbzaV3RElnTnhz4LyWjgV5yRKF5+1Niq/QeugMJSInLJ
	tcYo+nn4FUl3+aZz+BQSuiUQ8/Tj0HFgDfxzm9p+LcjaJkHAYcutZTftpvRrjI32
	BBlC0QfWq0xg2sF7D5Ha7ivkP3UE+3cxYNtnk+JMSnbhVeDNTGhZA58uT7Z44nbG
	+PdLAzfsjcqkgSofu0ndENQcMD3zwPfg3YhKMgdlV1FDxX0UV/mLHWvcfrPgUy3d
	Q==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id If-l1P2LsmZ7; Fri, 31 Jul 2026 21:53:02 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4hBfvF30Mlzlfvq2;
	Fri, 31 Jul 2026 21:52:57 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Marco Elver <elver@google.com>,
	linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v4 4/6] scsi: core: Add lock context annotations
Date: Fri, 31 Jul 2026 14:52:09 -0700
Message-ID: <0a289ca5cf0c22588e4ae193acabd1cdfef672f3.1785534721.git.bvanassche@acm.org>
X-Mailer: git-send-email 2.55.0.508.g3f0d502094-goog
In-Reply-To: <68f3346cab2be570839350831f82b6c9233832ed.1785534721.git.bvanassche@acm.org>
References: <68f3346cab2be570839350831f82b6c9233832ed.1785534721.git.bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Document which functions expect that shost->scan_mutex is held.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_scan.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index d7e0e9393194..3b82e80e807a 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -1195,6 +1195,7 @@ static int scsi_probe_and_add_lun(struct Scsi_Host =
*shost,
 				  struct scsi_device **sdevp,
 				  enum scsi_scan_mode rescan,
 				  void *hostdata)
+	__must_hold(&shost->scan_mutex)
 {
 	struct scsi_device *sdev;
 	unsigned char *result;
@@ -1352,6 +1353,7 @@ static void scsi_sequential_lun_scan(struct Scsi_Ho=
st *shost,
 				     struct scsi_target *starget,
 				     blist_flags_t bflags, int scsi_level,
 				     enum scsi_scan_mode rescan)
+	__must_hold(&shost->scan_mutex)
 {
 	uint max_dev_lun;
 	u64 sparse_lun, lun;
@@ -1444,6 +1446,7 @@ static void scsi_sequential_lun_scan(struct Scsi_Ho=
st *shost,
 static int scsi_report_lun_scan(struct Scsi_Host *shost,
 			struct scsi_target *starget, blist_flags_t bflags,
 			enum scsi_scan_mode rescan)
+	__must_hold(&shost->scan_mutex)
 {
 	unsigned char scsi_cmd[MAX_COMMAND_SIZE];
 	unsigned int length;
@@ -1769,6 +1772,7 @@ EXPORT_SYMBOL(scsi_rescan_device);
 static void __scsi_scan_target(struct Scsi_Host *shost, struct device *p=
arent,
 			       unsigned int channel, unsigned int id, u64 lun,
 			       enum scsi_scan_mode rescan)
+	__must_hold(&shost->scan_mutex)
 {
 	blist_flags_t bflags =3D 0;
 	int res;
@@ -1866,6 +1870,7 @@ EXPORT_SYMBOL(scsi_scan_target);
 static void scsi_scan_channel(struct Scsi_Host *shost, unsigned int chan=
nel,
 			      unsigned int id, u64 lun,
 			      enum scsi_scan_mode rescan)
+	__must_hold(&shost->scan_mutex)
 {
 	uint order_id;
=20
