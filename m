Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F01331FBCA7;
	Mon, 23 Feb 2026 15:45:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771861522; cv=none; b=GnWfFpK1xPpShR4D98FtRFOJ0jz56ih14BkYbyl/8rFC6LePLQ1K0LLDlE5x9Qu161O1RGq62VdtDIQ3PzLCgJQTcsmvZrzvwyQYN8GSej3Ew+GetAghMVZEF9cIjbAArQL9D721L33B8Ci+QGZZKRK/WfVWtrSOAAuoAupzOjc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771861522; c=relaxed/simple;
	bh=uI2CTnMZZo8iPqYpwm0xtZd6/FFIAG4bUniP6Ll6Ts8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Ef5W20iaDwzTwAKIvmEeLmgyqxeeKAB5qSbMbk6xVEUg2iKCOA58CNFWmbalyakhKn+wBNDQJJFgOtr99bKlb1zOEPxlUqb2yyxoBpfmP3N1EHPB5S1ZbGZfNaCFPvnHLgZkEjNglAH3VJr4U2rw/2jyk7/E6qADXwkPL3nkwQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q33Cd8Cl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q33Cd8Cl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A11BDC116C6;
	Mon, 23 Feb 2026 15:45:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771861521;
	bh=uI2CTnMZZo8iPqYpwm0xtZd6/FFIAG4bUniP6Ll6Ts8=;
	h=From:To:Cc:Subject:Date:From;
	b=q33Cd8Cl2SYM5KlzfAb/xFHR4WHivHVw0eru2+E0awP9IVPiERW6Z+ep959rKmqG8
	 +n0ESof9gl4vgXKbLZKK+kcAR3XT9BgFidR1b1WG4rhpRZvnYwhf7qECGcQVPcJ+uM
	 h09hZBr1QmnQaAOvQ4y94Pg8C5MEheF4XLK+p6pE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	stable <stable@kernel.org>
Subject: [PATCH] scsi: ses: Handle positive SCSI error from ses_recv_diag()
Date: Mon, 23 Feb 2026 16:44:59 +0100
Message-ID: <2026022301-bony-overstock-a07f@gregkh>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1051; i=gregkh@linuxfoundation.org; h=from:subject:message-id; bh=uI2CTnMZZo8iPqYpwm0xtZd6/FFIAG4bUniP6Ll6Ts8=; b=owGbwMvMwCRo6H6F97bub03G02pJDJlzSv+qMPh9jmmf/aVCzy7ZUt+iYNkyeYcbW+7uc/N9P dm2Oq+mI5aFQZCJQVZMkeXLNp6j+ysOKXoZ2p6GmcPKBDKEgYtTACaydCfD/Fz2ZQfUD+15am+Z uL1o8eykc1MeMTEs2DqnX/1edsOOdayH99y5et7jRaHNfwA=
X-Developer-Key: i=gregkh@linuxfoundation.org; a=openpgp; fpr=F4B60CC5BF78C2214A313DCB3147D40DDB2DFB29
Content-Transfer-Encoding: 8bit

ses_recv_diag() can return a positive value, which also means that an
error happened, so do not only test for negative values.

Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: stable <stable@kernel.org>
Assisted-by: gkh_clanker_2000
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/ses.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ses.c b/drivers/scsi/ses.c
index 35101e9b7ba7..128042c734cc 100644
--- a/drivers/scsi/ses.c
+++ b/drivers/scsi/ses.c
@@ -215,7 +215,7 @@ static unsigned char *ses_get_page2_descriptor(struct enclosure_device *edev,
 	unsigned char *type_ptr = ses_dev->page1_types;
 	unsigned char *desc_ptr = ses_dev->page2 + 8;
 
-	if (ses_recv_diag(sdev, 2, ses_dev->page2, ses_dev->page2_len) < 0)
+	if (ses_recv_diag(sdev, 2, ses_dev->page2, ses_dev->page2_len))
 		return NULL;
 
 	for (i = 0; i < ses_dev->page1_num_types; i++, type_ptr += 4) {
-- 
2.53.0

