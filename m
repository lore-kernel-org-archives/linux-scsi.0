Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 337C947F3A0
	for <linux-scsi@vger.kernel.org>; Thu,  8 Oct 2026 22:42:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791499368; cv=none; b=uhqTcfOigFKw3FBio6qEJ07dy0SAzX7SrbSYnqn9k9cKZVQAYo8dOYiEFx2vaRpQntSrChhaVM/oRhFX6t8pnAkkRVd+k5t/3U1Gc5xrf06XtePfRbywtMTOFV1JyzeUFyDZB+r8peLgUnL0fbxyGiPRLJoRF7Ld5HtN2Ds0Vdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791499368; c=relaxed/simple;
	bh=v2wOXBJv4uMmGY0mnXoqSTD1369gonzd2tZ+TV1eWP0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZuC4gjcTjP/y4aQIJ2nkpOGQB9nmQFwB1C6yYWItxb7Gc+kP9kdZDaC+GbSnOxCBQMSyUBvKaxqFqFsrAKV3l0ApmGpsN9zUMX8nsqXIiSCcFOPo2TBpAiranX1K8nfasBtSzqerq/ONgb/l5RQBVwuUl95VqzXiTmtLlE3tGE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=ka6GoUgA; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="ka6GoUgA"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4j14kt2k0Wz1XM30r;
	Thu,  8 Oct 2026 22:42:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1791499363; x=1794091364; bh=x5tik
	20ktVm0iochiRD0eB5yYPuKR5Is36iKx1njNrM=; b=ka6GoUgAUf1KVgmDjq0fk
	HRyQTQZAlnj1nfirocyWRkZa0K7HYC92VAB/0c5F980cs1Amb7rqgfnafyX9mT8y
	ld1gLbE6KpoTkuraS79fH27UO0A74KZrU55PyznL/N5Sopbm3ivRTKVU5CRGEn/5
	tGR7fhICSfHzthNKcBNJ0kC7Ny3fteYHrI7oZK40NaSon4znzhDtOQ9mD3gvDANo
	DfpVTXYaiGVCjmPw6diDsJYsovvusuVpjWB/asGOaKt0zKYL8wLvRvwIFWekfIdH
	UNuFkApLjSUboL6OXLCMKBrgTQYNwh+vQxMyPMnqyRN9nlHIBdl+Xpz+w+/LxQfc
	w==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 307wMDxv6sGE; Thu,  8 Oct 2026 22:42:43 +0000 (UTC)
Received: from bvanassche.c.googlers.com.com (245.199.118.34.bc.googleusercontent.com [34.118.199.245])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4j14kn5jpTz1XM30j;
	Thu,  8 Oct 2026 22:42:41 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	John Garry <john.garry@linux.dev>,
	Christoph Hellwig <hch@lst.de>,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v5 6/8] scsi: scsi_debug: Split resp_atomic_write()
Date: Thu,  8 Oct 2026 15:42:17 -0700
Message-ID: <a38dc856bb360f90f3819d5063bd3c30246afe9a.1791499174.git.bvanassche@acm.org>
X-Mailer: git-send-email 2.56.0.170.g584c36229d-goog
In-Reply-To: <cover.1791499174.git.bvanassche@acm.org>
References: <cover.1791499174.git.bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Prepare for enabling lock context analysis by eliminating conditional
locking.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_debug.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 685949aedf9a..244250ba460b 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -6352,13 +6352,13 @@ static int resp_atomic_write(struct scsi_cmnd *sc=
p,
 	if (scsi_bufflen(scp) < len * sdebug_sector_size)
 		return DID_ERROR << 16;
=20
-	if (lbp)
-		sdeb_meta_write_lock(sip);
-
-	ret =3D do_device_access(sip, scp, 0, lba, len, 0, true, true);
 	if (lbp) {
+		sdeb_meta_write_lock(sip);
+		ret =3D do_device_access(sip, scp, 0, lba, len, 0, true, true);
 		map_region(sip, lba, len);
 		sdeb_meta_write_unlock(sip);
+	} else {
+		ret =3D do_device_access(sip, scp, 0, lba, len, 0, true, true);
 	}
=20
 	if (unlikely(ret =3D=3D -1))
