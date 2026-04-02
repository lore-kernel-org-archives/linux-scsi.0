Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AB7922FE0A
	for <linux-scsi@vger.kernel.org>; Thu,  2 Apr 2026 15:33:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775144039; cv=none; b=lhUlYAR6pAXBdVsVTo++FwImq0f+BD+GXt5ABOWvBxhwxNLu9h6ss/Y2dIBwVsP7SImYbl/VveFne1vLIMPLxbXjB06WvN1Vi2n1sOeTPEAwY89yEwF1AJJHRxWJFhHqmV+J+0kZZxifaRCQExfv0i8Q/wbMxSrMmnZgtnYEYAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775144039; c=relaxed/simple;
	bh=O3bx/xfLS7R1LedwOP5IMpfS+KihL2lmi6k8bwOJF4I=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=gHGBRkSLIdGw0Hg25FfGaDXSd/rsrhurlC5lgBLphOSUOLLC0s1RGblN02nmyzk7ogEhNKI+n9pg0oh4wrV0uMZJFBCdTzHKWTqZVpP2aDUn9SbIR4oFSck7hj0TiM4pOk7+YbSIp+cNWFamLLoIK3xqpoboZTP9njU5rgUda0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=m9n8xBVW; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="m9n8xBVW"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4fmm9L0Xnwz1XM0p5;
	Thu,  2 Apr 2026 15:33:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:x-mailer:message-id:date
	:date:subject:subject:from:from:received:received; s=mr01; t=
	1775144034; x=1777736035; bh=IcpqhweVZCmII5uLWVF8vzv00IUQ5HEB4XP
	mNQ7u+V4=; b=m9n8xBVWoYiZHhiQAJutFVZBCzWGCOnxAibh7/fvJuDklB+lyXD
	vaNFLdZ50Oltv812DwlBN1a5YZHS+kB6sBMoWPUi0zRQmvqvPM8xxQ2lMfuwles8
	iSca2+Mp7aUIIVpYr06CWVfTgoahi1rGYjRZvavLG/b0uQ2QexhEwOdPwySedcal
	6hNuyrZZXLLqxB2MdN0dCovQzqFjzo+s8kf284al8/8pK7HjYaHqSJth1117oj/a
	jJawLYLLh5hcHz8kXMPd+DcZykrHK7iHp4AV+XoFF9tZPbB14I2IX6t5zH92nn7X
	0GDLupQwkOJCsfFhhAv526KFqYybfy3J8SQ==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id L3gd2-ZG7DUK; Thu,  2 Apr 2026 15:33:54 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4fmm9D3sTtz1XMG4X;
	Thu,  2 Apr 2026 15:33:52 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Hannes Reinecke <hare@suse.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH] scsi: aic7xxx: Fix compiler warnings triggered by user space code
Date: Thu,  2 Apr 2026 08:33:33 -0700
Message-ID: <20260402153341.2909184-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.53.0.1185.g05d4b7b318-goog
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Fix the following compiler warnings:

aicasm_gram.y:1107:24: warning: comparison of different enumeration types
      ('scope_type' and 'enum yytokentype') [-Wenum-compare]
 1107 |                  || last_scope->type =3D=3D T_ELSE) {
      |                     ~~~~~~~~~~~~~~~~ ^  ~~~~~~
aicasm_scan.l:392:14: warning: using the result of an assignment as a con=
dition
      without parentheses [-Wparentheses]
  392 |                                 while (c =3D *yptr++) {
      |                                        ~~^~~~~~~~~
aicasm_macro_scan.l:153:1: warning: non-void function does not return a v=
alue
      [-Wreturn-type]
  153 | }
      | ^

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/aic7xxx/aicasm/aicasm.h      | 2 +-
 drivers/scsi/aic7xxx/aicasm/aicasm_gram.y | 2 +-
 drivers/scsi/aic7xxx/aicasm/aicasm_scan.l | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/aic7xxx/aicasm/aicasm.h b/drivers/scsi/aic7xxx/=
aicasm/aicasm.h
index 716a2aefc925..f290b50c6475 100644
--- a/drivers/scsi/aic7xxx/aicasm/aicasm.h
+++ b/drivers/scsi/aic7xxx/aicasm/aicasm.h
@@ -82,7 +82,7 @@ extern int   src_mode;
 extern int   dst_mode;
 struct symbol;
=20
-void stop(const char *errstring, int err_code);
+void __attribute__((noreturn)) stop(const char *errstring, int err_code)=
;
 void include_file(char *file_name, include_type type);
 void expand_macro(struct symbol *macro_symbol);
 struct instruction *seq_alloc(void);
diff --git a/drivers/scsi/aic7xxx/aicasm/aicasm_gram.y b/drivers/scsi/aic=
7xxx/aicasm/aicasm_gram.y
index b1c9ce477cbd..f6dbb9855daa 100644
--- a/drivers/scsi/aic7xxx/aicasm/aicasm_gram.y
+++ b/drivers/scsi/aic7xxx/aicasm/aicasm_gram.y
@@ -1104,7 +1104,7 @@ conditional:
 		last_scope =3D TAILQ_LAST(&scope_context->inner_scope,
 					scope_tailq);
 		if (last_scope =3D=3D NULL
-		 || last_scope->type =3D=3D T_ELSE) {
+		 || last_scope->type =3D=3D (int)T_ELSE) {
=20
 			stop("'else if' without leading 'if'", EX_DATAERR);
 			/* NOTREACHED */
diff --git a/drivers/scsi/aic7xxx/aicasm/aicasm_scan.l b/drivers/scsi/aic=
7xxx/aicasm/aicasm_scan.l
index fc7e6c58148d..c0d92cf5f9b5 100644
--- a/drivers/scsi/aic7xxx/aicasm/aicasm_scan.l
+++ b/drivers/scsi/aic7xxx/aicasm/aicasm_scan.l
@@ -389,7 +389,7 @@ nop			{ return T_NOP; }
 				char c;
=20
 				yptr =3D yytext;
-				while (c =3D *yptr++) {
+				while ((c =3D *yptr++)) {
 					/*
 					 * Strip carriage returns.
 					 */
