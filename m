Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BA4530171D
	for <linux-scsi@vger.kernel.org>; Tue, 14 Oct 2025 20:02:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760472158; cv=none; b=BtNnLW8U/OOirOy4O2iS3Go6Yv8rfiYRABc+WqOT+O91EnUJh/aTYGQQzhXemfbli3LVGgHOi9aGOn6VMksqsLrMAAF51G00ImJBExcmCctkRJR61TfoUVtb1kpaB8u7Xafcna+1KSTmF4lcb1veOFKNeXp3cvk0rVmZQ4ap53I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760472158; c=relaxed/simple;
	bh=OmH71SpuD3y0i+m5Iiw9k2HsHh+y6xy48jSz/i3Fano=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j1sM6uP4SXfKJVO5rvDyR1Xq2G0Yccpl2BcJyWTfuVmIuNdDN7Ffcj3PnNrkAgaiJIJ53MnNzge09gstZKKRiW+eXbOGOXZg1lSmBMGMzJ4Q4pNPaH6I3hEI9awnFkuJ/mkKEEG/enkBuDceZaN4NIhVZlVL6bRS0uvVNyQvGHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=hYHz+iQN; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="hYHz+iQN"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4cmQ9l20vBzlgqVb;
	Tue, 14 Oct 2025 20:02:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1760472152; x=1763064153; bh=Q7f13
	FJJUqCiaRMwbqVOSpt+oLvY7hLJizBp//6htto=; b=hYHz+iQNCtOFonz6KeuHL
	HmTtBdI/Erjq8QMVWKxL8Z42ZDQLNHKyNZHxxgXKjlk+kRevJtM1bYDtBbLE3WIf
	0nrQHwD4vM/ZO+pGn1Mxe/wcY2X0qSkZ+9g+U35kgYUxRbI3behvX+T+D6W16B45
	l9su9KMznUwtVU4XjBAS7TI0zxVtmAQ8uc1xQV62gYBiUyx0qTd2Tu5m6Xlq7Gia
	/lnhemL4izq+oqIgOUMSW6GpoMlYmud6y0wlqtRZgDWOG9kzgDCt2NFEre2vXki6
	9oy6D1jTQ5kluk7YJ9FmQnuH+fyS7Ltl/quPHDUj0l24a4zElZymDB8AtS9vNPS7
	A==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 6P1e8a6Vj7D7; Tue, 14 Oct 2025 20:02:32 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4cmQ9P2xq4zlgqyY;
	Tue, 14 Oct 2025 20:02:16 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Avri Altman <avri.altman@sandisk.com>,
	Bean Huo <beanhuo@micron.com>,
	"Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Can Guo <quic_cang@quicinc.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Eric Biggers <ebiggers@kernel.org>,
	Nitin Rawat <quic_nitirawa@quicinc.com>
Subject: [PATCH 4/8] ufs: core: Change the type of uic_command::cmd_active
Date: Tue, 14 Oct 2025 13:00:56 -0700
Message-ID: <20251014200118.3390839-5-bvanassche@acm.org>
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

Since uic_command::cmd_active is used as a boolean variable, change its
type from 'int' into 'bool'. No functionality has been changed.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 6 +++---
 include/ufs/ufshcd.h      | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index fa20082ac4d4..43e527926bf3 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -2618,7 +2618,7 @@ __ufshcd_send_uic_cmd(struct ufs_hba *hba, struct u=
ic_command *uic_cmd)
=20
 	init_completion(&uic_cmd->done);
=20
-	uic_cmd->cmd_active =3D 1;
+	uic_cmd->cmd_active =3D true;
 	ufshcd_dispatch_uic_cmd(hba, uic_cmd);
=20
 	return 0;
@@ -5583,13 +5583,13 @@ static irqreturn_t ufshcd_uic_cmd_compl(struct uf=
s_hba *hba, u32 intr_status)
 		cmd->argument2 |=3D ufshcd_get_uic_cmd_result(hba);
 		cmd->argument3 =3D ufshcd_get_dme_attr_val(hba);
 		if (!hba->uic_async_done)
-			cmd->cmd_active =3D 0;
+			cmd->cmd_active =3D false;
 		complete(&cmd->done);
 		retval =3D IRQ_HANDLED;
 	}
=20
 	if (intr_status & UFSHCD_UIC_PWR_MASK && hba->uic_async_done) {
-		cmd->cmd_active =3D 0;
+		cmd->cmd_active =3D false;
 		complete(hba->uic_async_done);
 		retval =3D IRQ_HANDLED;
 	}
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index 9425cfd9d00e..4d215a18522c 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -78,7 +78,7 @@ struct uic_command {
 	const u32 argument1;
 	u32 argument2;
 	u32 argument3;
-	int cmd_active;
+	bool cmd_active;
 	struct completion done;
 };
=20
