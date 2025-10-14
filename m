Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFF0E3054DE
	for <linux-scsi@vger.kernel.org>; Tue, 14 Oct 2025 20:03:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760472196; cv=none; b=b3QPXptNBdVkneXQUh2zecY1I99xLbzz5vXpnqI1muKqg31bQun2SbE2xUOwccno4n6xzdtxj5BVoRSYYFEg4HSFT4Eggrmlr+sh8wZfFi2sVZrgf6rZ+O74iRh8Jihdgh+gTxIwdwR3wZFfFVs5H64iqFng3/NVGGwjjCqaJOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760472196; c=relaxed/simple;
	bh=/I9GwLcwh1IGIiNlwqxxnn423xWhHGZw4n9aAOkZwNc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tJp/d4aSHQxCZikC+pd97zxz3ap0w8LtV1+mPkkATXRwHDHulMB3x5I23aYn50wPuf9UA4sD8eSuPl/rjLCMTlPcodw3rx2r8XKnFR8bemFrpz+prNa2YCgMKWuZIgMBQCq1z4gk5RUA1ei/mA+YeRQuf+PUfEPMzfE8R0V2svk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=fAtb/1eE; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="fAtb/1eE"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4cmQBV1jJFzlgqTt;
	Tue, 14 Oct 2025 20:03:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1760472192; x=1763064193; bh=2zKLt
	9yfs0T+bWR8LeDOvcwJCPlCPykCXJcPb1UEH0E=; b=fAtb/1eED4LrRjer1BslO
	my+rTwQ00y3DtjCFmJBDHGUdIzFKBZKWTf3tKH88d4FAu6uaQAqmlQBI1pBJqxs7
	shk8k4z7AZ5g/QyzLjByctezUw733F63nIf1Xtiv7hfB0PoPr4B/BNXDlv3+W2xZ
	f07rFoTEYVjDg965N9ePp8DOTOZ3C2APNaV/g5o+dSzDbk7IYff8StOXVksCwP+G
	MzC1n0hrR8QJt7NYQVls0iBTUpN2ChSIAt67YdjN++0imJ3esa6mi5iS2CQcemwf
	pOVNvY4c2TPDR3kGkeRfSrSGE9C20c60bYKzoNmarBjUfXMEfqQWgw1pJpiW4vmx
	w==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id RdUpQV4exnhM; Tue, 14 Oct 2025 20:03:12 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4cmQBH2YmpzlgqVY;
	Tue, 14 Oct 2025 20:03:02 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Avri Altman <avri.altman@sandisk.com>,
	Bean Huo <beanhuo@micron.com>,
	"Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
	Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH 7/8] ufs: core: Remove a goto label from ufshcd_uic_cmd_compl()
Date: Tue, 14 Oct 2025 13:00:59 -0700
Message-ID: <20251014200118.3390839-8-bvanassche@acm.org>
X-Mailer: git-send-email 2.51.0.788.g6d19910ace-goog
In-Reply-To: <20251014200118.3390839-1-bvanassche@acm.org>
References: <20251014200118.3390839-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Return directly instead of jumping to a return statement. No
functionality has been changed.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 43e527926bf3..633fad65122e 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -5574,7 +5574,7 @@ static irqreturn_t ufshcd_uic_cmd_compl(struct ufs_=
hba *hba, u32 intr_status)
 	guard(spinlock_irqsave)(hba->host->host_lock);
 	cmd =3D hba->active_uic_cmd;
 	if (!cmd)
-		goto unlock;
+		return retval;
=20
 	if (ufshcd_is_auto_hibern8_error(hba, intr_status))
 		hba->errors |=3D (UFSHCD_UIC_HIBERN8_MASK & intr_status);
@@ -5597,7 +5597,6 @@ static irqreturn_t ufshcd_uic_cmd_compl(struct ufs_=
hba *hba, u32 intr_status)
 	if (retval =3D=3D IRQ_HANDLED)
 		ufshcd_add_uic_command_trace(hba, cmd, UFS_CMD_COMP);
=20
-unlock:
 	return retval;
 }
=20
