Received: from mail-gw02.astralinux.ru (mail-gw02.astralinux.ru [93.188.205.243])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC03E27603A;
	Wed,  2 Jul 2025 13:34:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=93.188.205.243
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751463266; cv=none; b=alJUbcZ/YC348qIGYicLV+HpFjDwjt3Yx/AOlNK2n7Lef6Y3X+yMvTCqSDhaLk9S07/atEEj7PW2iVVuL8U0frtIUDOqhUaQUMRm6TBhlvUoLNgtnaXtrJrDgRMMOl9+eRLTrEHpzxRbIfGfBLblRrLzi5mNqxSRNTEjXK6Mq20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751463266; c=relaxed/simple;
	bh=JNr5JhnmpSELPd3exj25rIHy7u/NEDaXATV0e2m0pTM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=A1lBF5U9sSyRyg5sDOtFueNgdfeupeyThjEV2+r5SJPnO1/D38Ur7PrBLSWdnGBJwrd8BNLStArPRaBnB0KRb8ZtIw9bDCaGGSm7b2qh+4ikpmPVlhP8v2l2MoXIrjz8cCAw1IukAQf140xwfXNxdP/wrsETuP58boqhDpCbJ6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=astralinux.ru; spf=pass smtp.mailfrom=astralinux.ru; dkim=pass (2048-bit key) header.d=astralinux.ru header.i=@astralinux.ru header.b=cV01KRSp; arc=none smtp.client-ip=93.188.205.243
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=astralinux.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=astralinux.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=astralinux.ru header.i=@astralinux.ru header.b="cV01KRSp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=astralinux.ru;
	s=mail; t=1751462785;
	bh=JNr5JhnmpSELPd3exj25rIHy7u/NEDaXATV0e2m0pTM=;
	h=From:To:Cc:Subject:Date:From;
	b=cV01KRSpnCED0ratvOKTGc7rUUJQGMIX26Iv/7CxtTd208y0UL2rPlMtgYwwuPLN+
	 6FR+GEYYa9dZBkxLs3UYbyBj/epVq9QOEMgbEN3r54568KH26p07//kM8JuxyRiQ/O
	 SMLlN4boXKI6K5SNm+3h2+mW/AqyqJKyG/fLTcELSOd2zrP/x83OZRV4CPz37HJcFX
	 ISscKlf/mzB+GN4FhAA3PjgI2ECokqQQ4EaUjb28q94KIibRtXyxc8TG+JtTf3Z+rq
	 td3OfxBaO/K02Y5qpp4mwcLVO90pQAoyBOxrkCmDXR+tkX7lp7A5QTxUnPocyE9nct
	 8DovlkdLiwuCg==
Received: from gca-msk-a-srv-ksmg01.astralinux.ru (localhost [127.0.0.1])
	by mail-gw02.astralinux.ru (Postfix) with ESMTP id 47C621F97E;
	Wed,  2 Jul 2025 16:26:25 +0300 (MSK)
Received: from new-mail.astralinux.ru (unknown [10.177.185.198])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail-gw02.astralinux.ru (Postfix) with ESMTPS;
	Wed,  2 Jul 2025 16:26:24 +0300 (MSK)
Received: from localhost.localdomain (unknown [10.198.18.126])
	by new-mail.astralinux.ru (Postfix) with ESMTPA id 4bXLJZ5sYPz16Hnt;
	Wed,  2 Jul 2025 16:26:22 +0300 (MSK)
From: Anastasia Belova <abelova@astralinux.ru>
To: stable@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Anastasia Belova <abelova@astralinux.ru>,
	James Smart <james.smart@broadcom.com>,
	Dick Kennedy <dick.kennedy@broadcom.com>,
	"James E.J. Bottomley" <jejb@linux.ibm.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	lvc-project@linuxtesting.org,
	Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 5.10] scsi: lpfc: Move NPIV's transport unregistration to after resource clean up
Date: Wed,  2 Jul 2025 16:24:46 +0300
Message-ID: <20250702132448.93012-1-abelova@astralinux.ru>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-KSMG-AntiPhishing: NotDetected, bases: 2025/07/02 12:42:00
X-KSMG-AntiSpam-Auth: dkim=none
X-KSMG-AntiSpam-Envelope-From: abelova@astralinux.ru
X-KSMG-AntiSpam-Info: LuaCore: 63 0.3.63 9cc2b4b18bf16653fda093d2c494e542ac094a39, {Tracking_uf_ne_domains}, {Tracking_from_domain_doesnt_match_to}, astralinux.ru:7.1.1;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;new-mail.astralinux.ru:7.1.1;lore.kernel.org:7.1.1;127.0.0.199:7.1.2, FromAlignment: s
X-KSMG-AntiSpam-Interceptor-Info: scan successful
X-KSMG-AntiSpam-Lua-Profiles: 194491 [Jul 02 2025]
X-KSMG-AntiSpam-Method: none
X-KSMG-AntiSpam-Rate: 0
X-KSMG-AntiSpam-Status: not_detected
X-KSMG-AntiSpam-Version: 6.1.1.11
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 2.1.0.7854, bases: 2025/07/02 12:40:00 #27611971
X-KSMG-AntiVirus-Status: NotDetected, skipped
X-KSMG-LinksScanning: NotDetected, bases: 2025/07/02 12:41:00
X-KSMG-Message-Action: skipped
X-KSMG-Rule-ID: 1

From: Justin Tee <justin.tee@broadcom.com>

commit 4ddf01f2f1504fa08b766e8cfeec558e9f8eef6c upstream.

There are cases after NPIV deletion where the fabric switch still believes
the NPIV is logged into the fabric.  This occurs when a vport is
unregistered before the Remove All DA_ID CT and LOGO ELS are sent to the
fabric.

Currently fc_remove_host(), which calls dev_loss_tmo for all D_IDs including
the fabric D_ID, removes the last ndlp reference and frees the ndlp rport
object.  This sometimes causes the race condition where the final DA_ID and
LOGO are skipped from being sent to the fabric switch.

Fix by moving the fc_remove_host() and scsi_remove_host() calls after DA_ID
and LOGO are sent.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Link: https://lore.kernel.org/r/20240305200503.57317-3-justintee8345@gmail.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Anastasia Belova <abelova@astralinux.ru>
---
Backport fix for CVE-2024-36952
 drivers/scsi/lpfc/lpfc_vport.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_vport.c b/drivers/scsi/lpfc/lpfc_vport.c
index aa4e451d5dc1..921630f71ee9 100644
--- a/drivers/scsi/lpfc/lpfc_vport.c
+++ b/drivers/scsi/lpfc/lpfc_vport.c
@@ -668,10 +668,6 @@ lpfc_vport_delete(struct fc_vport *fc_vport)
 		ns_ndlp_referenced = true;
 	}
 
-	/* Remove FC host and then SCSI host with the vport */
-	fc_remove_host(shost);
-	scsi_remove_host(shost);
-
 	ndlp = lpfc_findnode_did(phba->pport, Fabric_DID);
 
 	/* In case of driver unload, we shall not perform fabric logo as the
@@ -783,6 +779,10 @@ lpfc_vport_delete(struct fc_vport *fc_vport)
 		lpfc_nlp_put(ndlp);
 	}
 
+	/* Remove FC host to break driver binding. */
+	fc_remove_host(shost);
+	scsi_remove_host(shost);
+
 	lpfc_cleanup(vport);
 	lpfc_sli_host_down(vport);
 
-- 
2.43.0

