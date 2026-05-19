Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCC0D377558
	for <linux-scsi@vger.kernel.org>; Tue, 19 May 2026 19:41:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779219684; cv=none; b=dFjsaBteoysgtPnjfSv1TAP7IpTtgLP2oEYrBuRkH+3dDAVub85g1H9xBN0VzKyA7daTbIiAJHOfMD5o+KrfofY06+AfEakDft5YIZ8dnm5RppskNpSsofxwb/r3ZGHBOqhMCj/xq9oFqzW+vXIHZYUxnbKHhpP8yfiHlJ7bbhc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779219684; c=relaxed/simple;
	bh=k/rQIwS1kkGpERf0z7mr3TpuPUL0KXSb36DK53Ki6eM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ixE14g88T9HnBUfskgq50ze3NqfMv0XnCJCml5LMwZvB2zrRcO2S+hp4ZxiZa2Ie6cpPbccdo4RzHfqpKsbuX1b2Hd3NWLgWB4YE1xbIGbjWgQp9uIci2dHlixFkNa6JfDLvqftaUIm6IHUbT3+vzWcNm3opH1jE2I4HX7GOC1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=rBfrWzaE; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="rBfrWzaE"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4gKlR62TQVz1XM6JQ;
	Tue, 19 May 2026 19:41:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:x-mailer:message-id:date
	:date:subject:subject:from:from:received:received; s=mr01; t=
	1779219678; x=1781811679; bh=NNSSEjEe0I6GWXxbGWb6oaLzkFNeUXojY+D
	tOzgzNKQ=; b=rBfrWzaEXCnPPgdbtAKC1fUiXTOcZdfdgMxmviWR0J6nREl6h7W
	RNNNZtgHYs8NzQn4nJeUro79XrLeA+jmey78ZyQb1reh3aek16hvhIB0XJLnq1w1
	71fMJADa8jyhxKov88zaPwEMiSnwT1f28ktkn7s3ZzSNO4E1r9W3zMiBSW5d6580
	IprMdie7ITi1bCkpwSoESYkeaexuXBNKMoAUZM5nWEwTv13y9dGSs8gw2TmfRWBj
	uDa4k5Sjpc+ALcftRT4BKKCbLdezywJHQAOx1Y4BOwouOeqMuL9R1y4IvbChyLfZ
	fkmPcnkOiCJ+PO8V2LYRoxHHs16RzZTxzYA==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id fOffJ8kiFsYn; Tue, 19 May 2026 19:41:18 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4gKlR135ybz1XM5jn;
	Tue, 19 May 2026 19:41:17 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH] scsi_debug: Remove a set-but-not-used variable
Date: Tue, 19 May 2026 12:41:05 -0700
Message-ID: <20260519194106.2534147-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.54.0.631.ge1b05301d1-goog
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

The static variable sdebug_any_injecting_opt is no longer read. Commit
3a90a63d02b8 ("scsi: scsi_debug: every_nth triggered error injection")
removed all code that reads this variable. Hence, also remove this
variable itself. This has been detected by building the scsi_debug
driver with the git HEAD version of Clang and with W=3D1.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_debug.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 1515495fd9ea..5ae7e4b83408 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -955,7 +955,6 @@ static bool sdebug_removable =3D DEF_REMOVABLE;
 static bool sdebug_clustering;
 static bool sdebug_host_lock =3D DEF_HOST_LOCK;
 static bool sdebug_strict =3D DEF_STRICT;
-static bool sdebug_any_injecting_opt;
 static bool sdebug_no_rwlock;
 static bool sdebug_verbose;
 static bool have_dif_prot;
@@ -7528,7 +7527,6 @@ static int scsi_debug_write_info(struct Scsi_Host *=
host, char *buffer,
 		return -EINVAL;
 	sdebug_opts =3D opts;
 	sdebug_verbose =3D !!(SDEBUG_OPT_NOISE & opts);
-	sdebug_any_injecting_opt =3D !!(SDEBUG_OPT_ALL_INJECTING & opts);
 	if (sdebug_every_nth !=3D 0)
 		tweak_cmnd_count();
 	return length;
@@ -7748,7 +7746,6 @@ static ssize_t opts_store(struct device_driver *ddp=
, const char *buf,
 opts_done:
 	sdebug_opts =3D opts;
 	sdebug_verbose =3D !!(SDEBUG_OPT_NOISE & opts);
-	sdebug_any_injecting_opt =3D !!(SDEBUG_OPT_ALL_INJECTING & opts);
 	tweak_cmnd_count();
 	return count;
 }
@@ -9659,7 +9656,6 @@ static int sdebug_driver_probe(struct device *dev)
 		scsi_host_set_guard(hpnt, SHOST_DIX_GUARD_CRC);
=20
 	sdebug_verbose =3D !!(SDEBUG_OPT_NOISE & sdebug_opts);
-	sdebug_any_injecting_opt =3D !!(SDEBUG_OPT_ALL_INJECTING & sdebug_opts)=
;
 	if (sdebug_every_nth)	/* need stats counters for every_nth */
 		sdebug_statistics =3D true;
 	error =3D scsi_add_host(hpnt, &sdbg_host->dev);
