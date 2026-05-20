Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54E433F39F5
	for <linux-scsi@vger.kernel.org>; Wed, 20 May 2026 17:15:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297315; cv=none; b=lBQGWN8SsGGbVcAwvsJcVwzULveeEG5yDN0SGYtPhtHa7CFO5LY9wCR9onuOwW5vO0fXV7igIv4Wmyd8v1FY03kFBK05ac5n632JfWIkkw+11gsaSsfNX4swqrPbF1q77+8u5spYGAMnGG43WwGbeeU4ee6GxROY3n4JmpIHpsk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297315; c=relaxed/simple;
	bh=l/OSgj1VfN7mTsXoSlZmbguN/FLpmUwioXrN4JOCllc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=hJT0dHXKeywx+zgy6RGWjAyWU0fhnMOFJo7uoeMagew9YRzhdHzxr8mJBDszabwtF0ftNcHcOS2mK+ic7fnJMXL4ii2Y0JYqDGh7IwFwNU3sYVGvrPgrNzRUkqO3xvcPHrfs2mNlix3fxmcIePEeNsKegetAF5RDGUgaCRNYaAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=R0dBgN9n; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="R0dBgN9n"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4gLJ816bRSzlffvc;
	Wed, 20 May 2026 17:15:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:x-mailer:message-id:date
	:date:subject:subject:from:from:received:received; s=mr01; t=
	1779297310; x=1781889311; bh=dD83LvsxoB+7EB6turP9jcJQZBqt5mW5E+3
	CC1E5UCI=; b=R0dBgN9ndzGnZ8xDZJzSDowk3NOIKisF2izVTKSZ6PZ5qT06Ubs
	9sAlLXvxo2NuXNJxe9cZKEQBToXA/WPyRkGq26xYJ230u6uCca+Juv+WXhf8No0n
	T1D86FyUBNW8JE+62zBnxbuXVvFUubriN60RZfbWkmxK6PT5aohnrE0N5GY8GB8n
	PfE/8uRHIz+sIj7tNiJ5Mtol7JoNGxlmzJfJoqHg6lIZprRvZ4rn4MBoZ3G6Qped
	JIBajv+R78BZFqLO0Lo61oRuFAXYMIPDTATIZMaWUxrdoiSox1/3nhNql9igE0WE
	pGNtn7PnDu/AE/M2t24bU3imroWZV0qPxSw==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 7S9T_-c-NL_K; Wed, 20 May 2026 17:15:10 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4gLJ7x1Q0zzlfl7l;
	Wed, 20 May 2026 17:15:08 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH v2] scsi_debug: Remove the set-but-not-used variable "sdebug_any_injecting_opt"
Date: Wed, 20 May 2026 10:14:53 -0700
Message-ID: <20260520171454.4035623-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.54.0.669.g59709faab0-goog
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
variable itself. Remove SDEBUG_OPT_ALL_INJECTING because there is no
code left that uses this constant if sdebug_any_injecting_opt is
removed. This has been detected by building the scsi_debug driver with
the git HEAD version of Clang and with W=3D1.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---

Changes compared to v1:
 - Also remove the SDEBUG_OPT_ALL_INJECTING constant.
 - Include the name of the sdebug_any_injecting_opt variable in the
   patch subject.

 drivers/scsi/scsi_debug.c | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 1515495fd9ea..a2f85ee1ae57 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -233,13 +233,6 @@ struct tape_block {
 #define SDEBUG_OPT_UNALIGNED_WRITE	0x20000
 #define SDEBUG_OPT_ALL_NOISE (SDEBUG_OPT_NOISE | SDEBUG_OPT_Q_NOISE | \
 			      SDEBUG_OPT_RESET_NOISE)
-#define SDEBUG_OPT_ALL_INJECTING (SDEBUG_OPT_RECOVERED_ERR | \
-				  SDEBUG_OPT_TRANSPORT_ERR | \
-				  SDEBUG_OPT_DIF_ERR | SDEBUG_OPT_DIX_ERR | \
-				  SDEBUG_OPT_SHORT_TRANSFER | \
-				  SDEBUG_OPT_HOST_BUSY | \
-				  SDEBUG_OPT_CMD_ABORT | \
-				  SDEBUG_OPT_UNALIGNED_WRITE)
 #define SDEBUG_OPT_RECOV_DIF_DIX (SDEBUG_OPT_RECOVERED_ERR | \
 				  SDEBUG_OPT_DIF_ERR | SDEBUG_OPT_DIX_ERR)
=20
@@ -955,7 +948,6 @@ static bool sdebug_removable =3D DEF_REMOVABLE;
 static bool sdebug_clustering;
 static bool sdebug_host_lock =3D DEF_HOST_LOCK;
 static bool sdebug_strict =3D DEF_STRICT;
-static bool sdebug_any_injecting_opt;
 static bool sdebug_no_rwlock;
 static bool sdebug_verbose;
 static bool have_dif_prot;
@@ -7528,7 +7520,6 @@ static int scsi_debug_write_info(struct Scsi_Host *=
host, char *buffer,
 		return -EINVAL;
 	sdebug_opts =3D opts;
 	sdebug_verbose =3D !!(SDEBUG_OPT_NOISE & opts);
-	sdebug_any_injecting_opt =3D !!(SDEBUG_OPT_ALL_INJECTING & opts);
 	if (sdebug_every_nth !=3D 0)
 		tweak_cmnd_count();
 	return length;
@@ -7748,7 +7739,6 @@ static ssize_t opts_store(struct device_driver *ddp=
, const char *buf,
 opts_done:
 	sdebug_opts =3D opts;
 	sdebug_verbose =3D !!(SDEBUG_OPT_NOISE & opts);
-	sdebug_any_injecting_opt =3D !!(SDEBUG_OPT_ALL_INJECTING & opts);
 	tweak_cmnd_count();
 	return count;
 }
@@ -9659,7 +9649,6 @@ static int sdebug_driver_probe(struct device *dev)
 		scsi_host_set_guard(hpnt, SHOST_DIX_GUARD_CRC);
=20
 	sdebug_verbose =3D !!(SDEBUG_OPT_NOISE & sdebug_opts);
-	sdebug_any_injecting_opt =3D !!(SDEBUG_OPT_ALL_INJECTING & sdebug_opts)=
;
 	if (sdebug_every_nth)	/* need stats counters for every_nth */
 		sdebug_statistics =3D true;
 	error =3D scsi_add_host(hpnt, &sdbg_host->dev);
