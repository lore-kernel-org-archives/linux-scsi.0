Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9B902F9D85
	for <linux-scsi@vger.kernel.org>; Thu, 18 Dec 2025 23:08:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766099283; cv=none; b=s6kI85CpohfRhXl61z8Tl1yUIQ819+rNWsNwqP87zoLLwWsEn470Q5TDCg9Rp6SfULHMJ5On2AwRfQkJiJyxosNi9dHr3hlqEOKPI20UOKGre0uoTDXscI0crDcas4iAX54qZnPQAwc5hMYJnMs4rOZrWUgYVPmgnGVSc93uAAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766099283; c=relaxed/simple;
	bh=Ruoa9aijKRETcfATnAuXF40KuLZJVzxsmKlatkX4cF8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=tGHYPJBh2Xos2gKItu0T2ZBVkUD8qMoP+JJxgK4/ml/rLVSMJSzUGse2m/1spwcwJNDeLIl4aiq1OAM2ISBlJKUWGGTeL4J2k3Ow4JEB3Y+4sM58CjXIhNNEOx8uMtGgzZHatHvuUuDE5OODrW3p9u1HJkjIvivWnq5tzAKcZPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=avt05lru; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="avt05lru"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4dXRCb46rQz1XM6Jh;
	Thu, 18 Dec 2025 23:07:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:x-mailer:message-id:date
	:date:subject:subject:from:from:received:received; s=mr01; t=
	1766099273; x=1768691274; bh=AC4CCNzJXLAebWo40a0X6mVTDI16gwkuZGY
	7aZY0SlA=; b=avt05lruOqWq49GkpL3ieZihjNBE4oFdbs/KuSHsAdGImeFDvi+
	F6CmQ8L4CXeOrIoRO2OWhSX3QbUqn4nI/6vBq+0zaXra1xOW6rxh9bdxf+QRLSBQ
	CAnNQAR8qEj3rDyLO+Wzx3/bsZit8h8awBkDr/CNDpmQ7q+LH7nvi2LrUSjphGsg
	ydAEHQ7kNJoj7n2UVuN8UJR9hwE6VeVrwwYtQd4rS5bbqDR/oEsKhaNy6B42d8ne
	gJ+0Vcqgl+whAPZr2AqSgC6r282NbZvmCACMDSNYT27sJE29R1Z0toUCle04h5/t
	YNK5cQfAVMdsA9kAL3WSlkXE/MF/BhqLakw==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id wMZt1qLLUwfM; Thu, 18 Dec 2025 23:07:53 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4dXRCW2y4Jz1XM6JR;
	Thu, 18 Dec 2025 23:07:51 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Nitin Rawat <nitin.rawat@oss.qualcomm.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Avri Altman <avri.altman@sandisk.com>,
	Bean Huo <beanhuo@micron.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	"Bao D. Nguyen" <quic_nguyenb@quicinc.com>
Subject: [PATCH for rc] ufs: core: Configure MCQ after link startup
Date: Thu, 18 Dec 2025 15:07:37 -0800
Message-ID: <20251218230741.2661049-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.52.0.322.g1dd061c0dc-goog
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Commit f46b9a595fa9 ("scsi: ufs: core: Allocate the SCSI host earlier")
did not only cause scsi_add_host() to be called earlier. It also swapped
the order of link startup and enabling and configuring MCQ mode. Before
that commit, the call chains for link startup and enabling MCQ were as
follows:

ufshcd_init()
  ufshcd_link_startup()
  ufshcd_add_scsi_host()
    ufshcd_mcq_enable()

Apparently this change causes link startup to fail. Fix this by configuri=
ng
MCQ after link startup has completed.

Reported-by: Nitin Rawat <nitin.rawat@oss.qualcomm.com>
Fixes: f46b9a595fa9 ("scsi: ufs: core: Allocate the SCSI host earlier")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 80c0b49f30b0..bc395434c3a2 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -10733,9 +10733,7 @@ static int ufshcd_add_scsi_host(struct ufs_hba *h=
ba)
 	if (is_mcq_supported(hba)) {
 		ufshcd_mcq_enable(hba);
 		err =3D ufshcd_alloc_mcq(hba);
-		if (!err) {
-			ufshcd_config_mcq(hba);
-		} else {
+		if (err) {
 			/* Continue with SDB mode */
 			ufshcd_mcq_disable(hba);
 			use_mcq_mode =3D false;
@@ -11008,6 +11006,9 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem=
 *mmio_base, unsigned int irq)
 	if (err)
 		goto out_disable;
=20
+	if (hba->mcq_enabled)
+		ufshcd_config_mcq(hba);
+
 	if (hba->quirks & UFSHCD_QUIRK_SKIP_PH_CONFIGURATION)
 		goto initialized;
=20
