Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C79531A23B1
	for <linux-scsi@vger.kernel.org>; Mon, 28 Jul 2025 21:28:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753738098; cv=none; b=FRn4Xut+2O2fxRo8IE0axPK/DvdeEZ/yfJxlFM4uRoD4JRr6JEV652Y8ajoGoCDCAal+KfLEeU72RGKMIpw56RsJ4tIt4wEVX4YSxVoTiLOU3w2NTIHpltXw0SWVnOrQ+PLcrF0kqjdUfz8MrEYwXco1uVRIgYRH18UzTbTl4Uk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753738098; c=relaxed/simple;
	bh=m7ecyAf1EbT26lD66rK+riyKkyEw1NXbiTPE6lV5vLU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=BLsr7Pr+0JtndySg2Q36Srda1lIJfXxGpuMe3haGOpn2d9otAsvBt/BxGADlBl8Zgbo8WrGqgQs2nOvANDVSTKx7zkzxEAOY2ym+/ny0gC5S8dv2Nb4SA5RwqCfZaD6pHrRDbGIXpagRYLkLqw4G5V5qPRFb4mcQIsC9pP0AE9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=Kyc2qs+/; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="Kyc2qs+/"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4brWmZ3xjhzm0ySs;
	Mon, 28 Jul 2025 21:28:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:mime-version
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1753738092; x=1756330093; bh=ulvNk
	PLdtHbA6eVMUh0msrGvGSuOvG417QKskwCVaAc=; b=Kyc2qs+/OjGY8q/TegJ0H
	XFBoSRvIaywQXsWWJ0OJxkocirCP9mqBxnSDDnf0lA+xSOIDTSisnDc9tq11p1RR
	PkPl6Z9PfvM3OagCSdmdVJnksT2oUq7RelrDZATdFBjGjMKPkvebe3xXeqXj2YHk
	zhEuQD6c7SpcjMOk+oDqaE8Zvm28y6OzEk7Lutx47tWWVE50WFiPZwQHc8/qnQZM
	d3K0sEmypCrh48A2SSknFR8XkdxLhT+vJ+7Wjpyds7Bf2JI0RwPcwKteoDztV53l
	b1q9fc/jwQTcRaJNKAsJ+6Ud0AqaW0HFfp4WD0C+9izG9J76JWpbXK2wkCvyCt6q
	w==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 2hUzo9C1zpm9; Mon, 28 Jul 2025 21:28:12 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4brWmN2xNLzm0yVd;
	Mon, 28 Jul 2025 21:28:03 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	=?UTF-8?q?Andr=C3=A9=20Draszik?= <andre.draszik@linaro.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Avri Altman <avri.altman@sandisk.com>,
	Bean Huo <beanhuo@micron.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	"Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
	Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH] ufs: core: Fix interrupt handling
Date: Mon, 28 Jul 2025 14:27:23 -0700
Message-ID: <20250728212731.899429-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.50.1.487.gc89ff58d15-goog
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Fix the following issues:
* An "irq ...: nobody cared" complaint during boot.
* Not handling a SCSI command in time, resulting in the following
  complaint:

[   41.700204][   T13] google-ufshcd 3c2d0000.ufs: ufshcd_abort: Device a=
bort task at tag 23
[   41.700945][   T13] sd 0:0:0:0: [sda] tag#23 CDB: opcode=3D0x2a 2a 00 =
00 02 61 e5 00 00 01 00

Cc: Neil Armstrong <neil.armstrong@linaro.org>
Cc: Andr=C3=A9 Draszik <andre.draszik@linaro.org>
Fixes: 3c7ac40d7322 ("scsi: ufs: core: Delegate the interrupt service rou=
tine to a threaded IRQ handler")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 77768bf722fa..7f4651b570be 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -7137,8 +7137,7 @@ static irqreturn_t ufshcd_intr(int irq, void *__hba=
)
 		return IRQ_WAKE_THREAD;
=20
 	/* Directly handle interrupts since MCQ ESI handlers does the hard job =
*/
-	return ufshcd_sl_intr(hba, ufshcd_readl(hba, REG_INTERRUPT_STATUS) &
-				   ufshcd_readl(hba, REG_INTERRUPT_ENABLE));
+	return ufshcd_threaded_intr(irq, hba);
 }
=20
 static int ufshcd_clear_tm_cmd(struct ufs_hba *hba, int tag)
