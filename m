Received: from mout.web.de (mout.web.de [212.227.17.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A20211C3F0C;
	Tue, 29 Sep 2026 14:01:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790690485; cv=none; b=rUldaGrdt5MNATo4FRos77petsX8EH+oyQOcctmz9l29nyxvOEumD6RjfLhBwe/mXYalVBjhYf0qclxus8A6kSK61EDHOQg6Ye6Bv/iAqDUePW7j8mxTP1t9QGJUcu23ainrwXFxgJwnc5rijwpuaaT6tWWe+nSBdboCw4pPJLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790690485; c=relaxed/simple;
	bh=LVtsRUPmtyRrTEclBEZ8+/4AZeE1i8vVb9aXKnV84zQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=OP3AxqjmDeCOdoZ4iGcrw6Tq1yugaUWP7LzC30GVAcj4UgeZnYmMclcj3LUqOFxaGV1+OOERN9mwkq9iWf0kUkOAVH4LDVondFCuFa9KAtGaJ5Pt2M2LBPWpMPeFPwv5AsOIjgb0eI82dHoYeCT3tOB97qeebohcVKfGnGfwcxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=michaelestner@web.de header.b=mdmf3tv3; arc=none smtp.client-ip=212.227.17.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=michaelestner@web.de header.b="mdmf3tv3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1790690475; x=1791295275; i=michaelestner@web.de;
	bh=hREXwDRP48ICU3cmg3/jSVJP6RSdHIs4ito/EUqICLU=;
	h=X-UI-Sender-Class:From:To:Cc:Subject:Date:Message-Id:
	 MIME-Version:Content-Transfer-Encoding:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=mdmf3tv3uIgtDN2wya5WRavSUN/p7BzoQDX1llmLUfjyFA9tC2sLTOtvBMsAsFgY
	 MHlrH5gQMzHKNRPyKvmz/cyUe6IquLrtshtw9C2J+MQIgMEyE9+2dMSHmbfjgOblf
	 ic28knDIeK7M5LAXbEfUF8mqLoBW+uuCLZGhMKXNdbXfqnIXY7y5NQr2llSCrwaY3
	 IinckapaVcFZWHZgJjwiGpY9Cy4XyLfsHw+QRShR4Fp0Ja2oFoXFhIND6UB/wMPjT
	 GBHp26ME7SRFOFW4pKJT9tQLzWBsbCb372CxpBF+TmP5i77C/o9SG/LmYUeOshdjs
	 jFqaIoHOjG3AH5Klyg==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from client.hidden.invalid by smtp.web.de (mrweb105
 [213.165.67.124]) with ESMTPSA (Nemesis) id 1N7QUJ-1wfEOM21Ov-012MJL; Tue, 29
 Sep 2026 16:01:15 +0200
From: Michael Estner <michaelestner@web.de>
To: Nilesh Javali <njavali@marvell.com>,
	GR-QLogic-Storage-Upstream@marvell.com,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Michael Estner <michaelestner@web.de>
Subject: [PATCH] scsi: qla2xxx: Use array_size() in vmalloc()
Date: Tue, 29 Sep 2026 16:00:57 +0200
Message-Id: <20260929140057.457605-1-michaelestner@web.de>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:mU4QqZivXyyW2P54mBWdlC73Hro1EXgsRJobtTAkmzc2e1vMADc
 nMmhQQZPR6KLccsQxl8+zLLdw1XKWXXJfVhoLcAGMrMsk5WPuxnvCY6XBBNplsXA5+gfcY8
 IWeDgawtq4F4WR7+JkC7nvPMcs6y76C9MRdLphuIxGoiGqm3ixJR9Ks0sQJrlBgdP4U6oie
 mSPSnwCk/ecDQau25F8aA==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:J211eTgPcmA=;HgWU28g4VhjWJW/QRImHOtia0wN
 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
 eyto+0PTTQQCfVLsccY0OZO9666xglby8dw==

vmalloc() has no 2-factor argument form, so multiplication factors
computing its size need to be wrapped in array_size().

This issue was found with the help of Coccinelle and audited and
fixed manually.

Addresses-KSPP-ID: https://github.com/KSPP/linux/issues/83

Signed-off-by: Michael Estner <michaelestner@web.de>
=2D--
 drivers/scsi/qla2xxx/qla_init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_in=
it.c
index bb0cc71de37b8..b269407d0ef11 100644
=2D-- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -8652,7 +8652,7 @@ qla28xx_load_fw_template(scsi_qla_host_t *vha, uint3=
2_t faddr)
 		ql_dbg(ql_dbg_init, vha, 0x01a5,
 		    "-> fwdt%u template allocate template %#x words...\n",
 		    j, risc_size);
-		fwdt->template =3D vmalloc(risc_size * sizeof(*dcode));
+		fwdt->template =3D vmalloc(array_size(risc_size, sizeof(*dcode)));
 		if (!fwdt->template) {
 			ql_log(ql_log_warn, vha, 0x01a6,
 			    "-> fwdt%u failed allocate template.\n", j);
=2D-=20
2.34.1

