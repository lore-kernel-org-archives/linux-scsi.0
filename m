Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61C9F10A1E
	for <linux-scsi@vger.kernel.org>; Wed, 27 Aug 2025 00:11:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756253513; cv=none; b=Ln/ilDMyI8bsv+P88srl1FSJUjzRNVNeuEvoaFpVzhrIqPjkfS/+KScwTsxQqiv9O6hGCLVvXI+e0TAr0jRGNrleCkPeBes0v+eRGksNtVlZwSbJhiNdwLjXaUw/dNwl/bvWwJuKpBgKdsvAS9iJCMdiKq0Hn7NBe7MhDMz5SDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756253513; c=relaxed/simple;
	bh=JA0EYzeiY681wNR8HqPcekBrNBiCennXqF497agfBCA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=loOvDtrW+/gyGTmxekAo8pwNHNCkEiYSGtf5JSEYeedFa0mO0UzwY5/dQ6EU8kR0XFn2c/8uwEqgJ1mfpC4f9IW9ID7j8pbRSvUxSQjJLMFjb86Gz9Mqb6mBF0yPmotHWH2y367yPpA/9NDkMemsewaSK2dJ6jhKOCItW6X1utk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=fL4uHTpx; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="fL4uHTpx"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4cBQ1y5PLbzm1742;
	Wed, 27 Aug 2025 00:11:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1756253509; x=1758845510; bh=93Pme
	XKnlAxOxvrfZIRwLquIbiEbtBHJQ95yw6Hof0M=; b=fL4uHTpxFT1sR+vhdlxjj
	cR0qkiZjtAyn3Z+soCcvLsCJG8JMQSos9bxC/UAvIeNvWgexMvqhXKWpQcJOPpkl
	p9HQ1+Bonz7ZgNlgZJTkQH5i4c+LrBRAA4Xj26SjyvPKd4w58ZMYGZZFfsJcK8C1
	MGdISu6wC+PJSZA+NZGipVcDH09zY1/hgmtEqAkrgHHC7o0jx/INTQX1gZXNUVjf
	SERTgD5C8uC0m9cs+OLaVuZ5AqBPe2ikwVUseSz5gbJragmH6eNOKyVvmG0beqWe
	VmhFC9nTdYw1bIm7ycjfdnuiacYbKWRB+DPFsrxj6vLlRhUgWw2N2vvpsjCpliAa
	w==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id JpEdL8QVaxu3; Wed, 27 Aug 2025 00:11:49 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4cBQ1s0xkVzm0ysy;
	Wed, 27 Aug 2025 00:11:44 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Avri Altman <avri.altman@sandisk.com>,
	Bean Huo <beanhuo@micron.com>
Subject: [PATCH v3 21/26] ufs: core: Do not clear driver-private command data
Date: Tue, 26 Aug 2025 17:06:25 -0700
Message-ID: <20250827000816.2370150-22-bvanassche@acm.org>
X-Mailer: git-send-email 2.51.0.261.g7ce5a0a67e-goog
In-Reply-To: <20250827000816.2370150-1-bvanassche@acm.org>
References: <20250827000816.2370150-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Tell the SCSI core to skip the memset() call that clears driver-private
data because __ufshcd_setup_cmd() performs all necessary initialization.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index a0a555a86403..6643ab90b2a1 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -2992,6 +2992,15 @@ static void ufshcd_map_queues(struct Scsi_Host *sh=
ost)
 	}
 }
=20
+/*
+ * The only purpose of this function is to make the SCSI core skip the m=
emset()
+ * call for the private command data.
+ */
+static int ufshcd_init_cmd_priv(struct Scsi_Host *host, struct scsi_cmnd=
 *cmd)
+{
+	return 0;
+}
+
 /**
  * ufshcd_queuecommand - main entry point for SCSI requests
  * @host: SCSI host pointer
@@ -9154,6 +9163,7 @@ static const struct scsi_host_template ufshcd_drive=
r_template =3D {
 	.name			=3D UFSHCD,
 	.proc_name		=3D UFSHCD,
 	.map_queues		=3D ufshcd_map_queues,
+	.init_cmd_priv		=3D ufshcd_init_cmd_priv,
 	.queuecommand		=3D ufshcd_queuecommand,
 	.mq_poll		=3D ufshcd_poll,
 	.sdev_init		=3D ufshcd_sdev_init,
