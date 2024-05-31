Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48A8B77114;
	Fri, 31 May 2024 08:13:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717143233; cv=none; b=jrIDsz1ll9Bnrw58HzO5GrDrasg88jGCfawUMqb5ILdbu6pWsarmdf6BVzjw4A2Tebxz76k2zp7G5ModoXRudvECYEKTu8jkiA2OM0ZZuOrP7+g3UkVUjHojnNQR7Amt6rQmstIlqrBivmaivoraRRKrLXrQj8sCw8ii8sPMlDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717143233; c=relaxed/simple;
	bh=KaZu3PfnuCLAgttdKtOj8aMS+kBKtD2hyquye1H9HRU=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=GEDkNL2Qjdh6LtWg2xTXhc6tq8UyyYPkk9Itg5t/jj36ctJE5ROcCCef1/e4PA0bcBtRZbAM6Yoj7fJhH1BBCRtI8ecSZ2y4USeElubTfB6mVkZsEZ7RaJqNV35HrHQM2Bh48eS5WOMuygflFggSKMX1nQfsXjVHQ1PR3wnBIbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: b10363301f2511ef9305a59a3cc225df-20240531
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.38,REQID:5d283cd1-a105-48ee-8743-2c5c99b604d6,IP:20,
	URL:0,TC:0,Content:-25,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACT
	ION:release,TS:-10
X-CID-INFO: VERSION:1.1.38,REQID:5d283cd1-a105-48ee-8743-2c5c99b604d6,IP:20,UR
	L:0,TC:0,Content:-25,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:-10
X-CID-META: VersionHash:82c5f88,CLOUDID:e8ac45031189e541bd5ee02aacc15a8a,BulkI
	D:240531161344YZ4O3K9Z,BulkQuantity:0,Recheck:0,SF:66|38|24|72|19|44|102,T
	C:nil,Content:0,EDM:-3,IP:-2,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil
	,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0
X-CID-BVR: 0,NGT
X-CID-BAS: 0,NGT,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FSD,TF_CID_SPAM_FSI
X-UUID: b10363301f2511ef9305a59a3cc225df-20240531
Received: from node4.com.cn [(39.156.73.12)] by mailgw.kylinos.cn
	(envelope-from <tanzheng@kylinos.cn>)
	(Generic MTA)
	with ESMTP id 1052488889; Fri, 31 May 2024 16:13:41 +0800
Received: from node4.com.cn (localhost [127.0.0.1])
	by node4.com.cn (NSMail) with SMTP id 4AFC916002081;
	Fri, 31 May 2024 16:13:41 +0800 (CST)
X-ns-mid: postfix-665986B5-191610221
Received: from localhost.localdomain (unknown [10.42.124.206])
	by node4.com.cn (NSMail) with ESMTPA id 62B0016002081;
	Fri, 31 May 2024 08:13:40 +0000 (UTC)
From: zheng tan <tanzheng@kylinos.cn>
To: hare@suse.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Zheng tan <tanzheng@kylinos.cn>,
	k2ci <kernel-bot@kylinos.cn>
Subject: [PATCH] scsi: aic7xxx: Fix some build warning
Date: Fri, 31 May 2024 16:13:37 +0800
Message-Id: <20240531081337.536182-1-tanzheng@kylinos.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=y
Content-Transfer-Encoding: quoted-printable

From: Zheng tan <tanzheng@kylinos.cn>

Fixed some warnings in compilation:

aicasm_gram.c:1562:16: warning: implicit declaration of function =E2=80=98=
yylex=E2=80=99
yychar =3D yylex ();

aicasm_scan.l:417:6: warning: implicit declaration of function =E2=80=98m=
m_switch_to_buffer=E2=80=99
      mm_switch_to_buffer(old_state);
      ^~~~~~~~~~~~~~~~~~~
      yy_switch_to_buffer
aicasm_scan.l:418:6: warning: implicit declaration of function =E2=80=98m=
mparse=E2=80=99
      mmparse();
      ^~~~~~~
      yyparse
aicasm_scan.l:421:6: warning: implicit declaration of function =E2=80=98m=
m_delete_buffer=E2=80=99
      mm_delete_buffer(temp_state);

Reported-by: k2ci <kernel-bot@kylinos.cn>
Signed-off-by: Zheng tan <tanzheng@kylinos.cn>
---
 drivers/scsi/aic7xxx/aicasm/aicasm_gram.y       | 2 +-
 drivers/scsi/aic7xxx/aicasm/aicasm_macro_gram.y | 2 +-
 drivers/scsi/aic7xxx/aicasm/aicasm_scan.l       | 7 ++++---
 3 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/aic7xxx/aicasm/aicasm_gram.y b/drivers/scsi/aic=
7xxx/aicasm/aicasm_gram.y
index 65182ad9cdf8..ac96fb9152b6 100644
--- a/drivers/scsi/aic7xxx/aicasm/aicasm_gram.y
+++ b/drivers/scsi/aic7xxx/aicasm/aicasm_gram.y
@@ -103,7 +103,7 @@ static void add_version(const char *verstring);
 static int  is_download_const(expression_t *immed);
 static int  is_location_address(symbol_t *symbol);
 void yyerror(const char *string);
-
+int yylex(void);
 #define SRAM_SYMNAME "SRAM_BASE"
 #define SCB_SYMNAME "SCB_BASE"
 %}
diff --git a/drivers/scsi/aic7xxx/aicasm/aicasm_macro_gram.y b/drivers/sc=
si/aic7xxx/aicasm/aicasm_macro_gram.y
index 8c0479865f04..d787b2f89007 100644
--- a/drivers/scsi/aic7xxx/aicasm/aicasm_macro_gram.y
+++ b/drivers/scsi/aic7xxx/aicasm/aicasm_macro_gram.y
@@ -62,7 +62,7 @@ static symbol_t *macro_symbol;
=20
 static void add_macro_arg(const char *argtext, int position);
 void mmerror(const char *string);
-
+int mmlex(void);
 %}
=20
 %union {
diff --git a/drivers/scsi/aic7xxx/aicasm/aicasm_scan.l b/drivers/scsi/aic=
7xxx/aicasm/aicasm_scan.l
index c78d4f68eea5..8214d7eaef1d 100644
--- a/drivers/scsi/aic7xxx/aicasm/aicasm_scan.l
+++ b/drivers/scsi/aic7xxx/aicasm/aicasm_scan.l
@@ -56,6 +56,7 @@
 #include "aicasm.h"
 #include "aicasm_symbol.h"
 #include "aicasm_gram.h"
+#include "aicasm_macro_gram.h"
=20
 /* This is used for macro body capture too, so err on the large size. */
 #define MAX_STR_CONST 4096
@@ -414,11 +415,11 @@ nop			{ return T_NOP; }
 					    yy_create_buffer(stdin,
 							     YY_BUF_SIZE);
 					yy_switch_to_buffer(temp_state);
-					mm_switch_to_buffer(old_state);
+					yy_switch_to_buffer(old_state);
 					mmparse();
-					mm_switch_to_buffer(temp_state);
+					yy_switch_to_buffer(temp_state);
 					yy_switch_to_buffer(old_state);
-					mm_delete_buffer(temp_state);
+					yy_delete_buffer(temp_state);
 					expand_macro(yylval.sym);
 				} else {
 					if (yylval.sym->type =3D=3D UNINITIALIZED) {
--=20
2.25.1

