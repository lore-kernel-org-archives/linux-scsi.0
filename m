Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83142137923
	for <linux-scsi@vger.kernel.org>; Wed,  5 Aug 2026 21:37:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785965868; cv=none; b=YXN5L5y9qbevt2Dy+Y7+7vEsKxaubWIWA+Wqte+8YCeXTC6b8ePL0n6MybQKICC7F8K/rraXqLfd0vVBQLiPx+CoMLAbb2nIicBWrIBpAfmNNsaboLzhfFyCmdotu0b2i9izjDIqs3cjdcLvjcQ0+riQatnsez7eXkoXZIRHItY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785965868; c=relaxed/simple;
	bh=rjSvNstV+g5rr8ipz3jqzaPOs7kXHwkYONm1JfaQ+8U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HtafPQCVPdhw6/sXg+DjkXltMaWFwHopwteI58Z9jHvUI0dUluPhxP67HlFP310uNZws9wYyk/P76pSg2OSgGi2Y+qGk9bLOB5XF/46Lj2LcnaDY4VSUWmOvLKuKIPB6+uUTti8FOe5DpaYhjZ6jBfoohEU6Zp6vIYhC+XTNtJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=L4470GeQ; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="L4470GeQ"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4hFkKR1vP9z1XM30n;
	Wed,  5 Aug 2026 21:37:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1785965863; x=1788557864; bh=kxSRk
	Hd9sNVNF9OS5lAm/Lu/BFEBRlgDHdM2SbItl4c=; b=L4470GeQWDi07E6VGKUgJ
	XNc/eqNVahhd5buIBqGWq2ghQwZteYdXjsuxNv8RIn/wRnrRwPbLnwDlM5JxfjNh
	0bNBzTiosjUplt1ITvsR7B3rWaHM+yejyy72brFVXI2zaTL3VUCD4nySUkoh93bh
	mXofyR+N4DX2ASmDcZzHzDcBUpHiuxuvyPg6A46mDjukE6oYzhaRB0ZFspk317H/
	L/u9kCmlhc7XvoAYtQy6Ol95ROXDSWBjSCEScbAManDNm4uuGHYDjGb1CeTX7cCk
	t/YaIhpFNGlgFkwqQIVwYd1/M0x/apekkAKe+w1zzLbPjin6535KV6OzOHuhZUEr
	g==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id xOD0hjQN9RFa; Wed,  5 Aug 2026 21:37:43 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4hFkKC5gRrz1XM6JY;
	Wed,  5 Aug 2026 21:37:35 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: John Garry <john.g.garry@oracle.com>,
	Marco Elver <elver@google.com>,
	linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v5 4/6] scsi: core: Add lock context annotations
Date: Wed,  5 Aug 2026 14:36:51 -0700
Message-ID: <da0d5e522eb10312076580371ee41e1d28f7ac18.1785965531.git.bvanassche@acm.org>
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
