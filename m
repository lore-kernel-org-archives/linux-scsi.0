Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 307F73CAE80
	for <linux-scsi@vger.kernel.org>; Thu, 30 Jul 2026 22:47:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785451634; cv=none; b=RUlL27qeAte0zh/fbgTNu2pa7h7Dkk3HKJh342WLW9rNpOUdr3O4SKv0W+P8jlfeU/buaftpo9o+7ORn5x61R8YNFazg72CeT2myaKuIA7IN12hPfwNUwtk1Civx+43dgYm36aYG5SM3Og6kJzVBaFDVPUI65DBDGJdvVUHqPkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785451634; c=relaxed/simple;
	bh=dkXb6i5TmKrCux51QN6KulIMmIykKy0JnkhupjwAPtI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V74d5gA/wqLaBBFOyp6hvKBbHVBq9hg7o598Aw9PoWd29M9XveZs6vfPH4MnpQv9vR1xCtGzjraa49K4Bo9pEmvg0R/BTzFXakUSyaYuEotj3ufpzCo8ShysemTZugoBAxUhslO110thOSg7GyG1lz4+w2zdxKGx7aaCE62AcK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=RylH9boS; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="RylH9boS"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4hB48J5npCz1XM30k;
	Thu, 30 Jul 2026 22:47:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1785451629; x=1788043630; bh=GkWf1
	MFsZ8IfycG1KIlDcIOA6Vwvau+lNSzrHC3In0U=; b=RylH9boSw3Rjz+FzajTav
	AL6Y5qSSSUTEZGEu5KnMI3rGxZ0SKHPoLLVYTBQY9o0i9821gp8xWVmOXOcmvSsL
	TjnS5XnvlyEgYy938hfkCuFb8NIJkK8d62XebdDh4MFJsp48zbXG2wmT37QYXYrO
	5KMC1O0lHsNFf6rKVJp1r1GR9J2ngbq87G5DJA1Ewy9TQavseGdzHMVSkt8LSmNg
	81VspCCTM6mr6UEwMOPwvmCSw3uYXlb+1xjTzqa7kXiFq3inbEJU/IG5rF9ZzGpr
	rfxtFVdVd0m1hxQFwMlAa9JXwi95Kk2eDympw+83Q4R9SyDun5Y+zUDHepRQWDN1
	A==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id Ge2Ad3XdcWUN; Thu, 30 Jul 2026 22:47:09 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4hB48C5vNdz1XM6Jk;
	Thu, 30 Jul 2026 22:47:07 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Marco Elver <elver@google.com>,
	linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Khalid Aziz <khalid@gonehiking.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v3 06/57] scsi: BusLogic: Prepare for enabling lock context analysis
Date: Thu, 30 Jul 2026 15:44:49 -0700
Message-ID: <045a86725b6f568d4f070c036d40d0352d25424a.1785451174.git.bvanassche@acm.org>
X-Mailer: git-send-email 2.55.0.508.g3f0d502094-goog
In-Reply-To: <cover.1785451174.git.bvanassche@acm.org>
References: <cover.1785451174.git.bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Document locking requirements with __must_hold().

Acked-by: Khalid Aziz <khalid@gonehiking.org>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/BusLogic.c | 1 +
 drivers/scsi/BusLogic.h | 3 ++-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/BusLogic.c b/drivers/scsi/BusLogic.c
index f2a6ed710c77..dafec8b24e58 100644
--- a/drivers/scsi/BusLogic.c
+++ b/drivers/scsi/BusLogic.c
@@ -2878,6 +2878,7 @@ static int blogic_hostreset(struct scsi_cmnd *SCpnt=
)
 */
=20
 static enum scsi_qc_status blogic_qcmd_lck(struct scsi_cmnd *command)
+	__must_hold(command->device->host->host_lock)
 {
 	void (*comp_cb)(struct scsi_cmnd *) =3D scsi_done;
 	struct blogic_adapter *adapter =3D
diff --git a/drivers/scsi/BusLogic.h b/drivers/scsi/BusLogic.h
index 24697a5bedc8..c152b93fb6dd 100644
--- a/drivers/scsi/BusLogic.h
+++ b/drivers/scsi/BusLogic.h
@@ -1279,7 +1279,8 @@ static int blogic_sdev_configure(struct scsi_device=
 *,
 				 struct queue_limits *lim);
 static void blogic_qcompleted_ccb(struct blogic_ccb *);
 static irqreturn_t blogic_inthandler(int, void *);
-static int blogic_resetadapter(struct blogic_adapter *, bool hard_reset)=
;
+static int blogic_resetadapter(struct blogic_adapter *adapter, bool hard=
_reset)
+	__must_hold(adapter->scsi_host->host_lock);
 static void blogic_msg(enum blogic_msglevel, char *, struct blogic_adapt=
er *, ...);
 static int __init blogic_setup(char *);
=20
