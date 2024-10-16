Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 123DA1C1741
	for <linux-scsi@vger.kernel.org>; Wed, 16 Oct 2024 20:13:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729109612; cv=none; b=sOQPqXnJ+vCaN+lSm/mMb2INt6q10uvz5i/skAutCeKV9UjWQ2Z9TGbtjrSdQbVxqcFuEFdjaHTfRWnMjbML7VUgrD473FlNEoapvITLYodKBHvWiiYORyOtC2mdEnTQD9EHvcu08QDkjTAwSus6m0cKYyrTC+Z0c/KE9RRjqzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729109612; c=relaxed/simple;
	bh=kMdZiM4rNKzZLh35oqNldFK2ReI7tZDOiPeuL4NV5Uk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sj81igcNBZH8LyrRk/U/bspJLtAWSro7yRZQRMLkNCrZD0BQYXpdmWLFcuVC24PD7bDZSBxOgbfUz9WMupdd3rW4d9VZJ9qkdLvMrX5G+vYYvvFVRoaiNOsM2qSp3FxPRoiVIh2kEvpr5O4hqw4zlGrwTcc2qPGu42JZVdpU5o0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=TlLESZFJ; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="TlLESZFJ"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4XTMbt5Y8Fz6ClY9d;
	Wed, 16 Oct 2024 20:13:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1729109607; x=1731701608; bh=idj3h
	Ceuzq0P4D6iXWWRsKs+5391c9u6HDdZDSDOgD8=; b=TlLESZFJ+FHNYDp9zmjGJ
	KikAzV2gNrGfWBTKg7n0RN7J240SqyqcReoq3mgRT3+71qaHQF2Ifut7cTAnr0pI
	QtL3QBzFt4LSbKtKto8Zp9N25C/Gz1n2Cu6qzYuQNrYQcY6UsZa9MN8hHrZOo23b
	p+zt9pe2desAH2nxIa8TWwbB/EPYrVxmDqkxOEn4+R9fgJgfUG/cx10AA3+3hyAv
	ODSceL26vnW68pVRTAD7JSYgBuMFFqrAngd0dqMWcrb3/4VpgPM+GFyvk3xU1Q04
	79GlA/3efny5GnDEXyYv4qvShakv8lcFUGF06KrrqqHhNBeuUhru05QCJJLfdjl7
	g==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id IVg2-CNdbzJJ; Wed, 16 Oct 2024 20:13:27 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4XTMbm6qYvz6Cnk9T;
	Wed, 16 Oct 2024 20:13:24 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Peter Wang <peter.wang@mediatek.com>,
	Avri Altman <avri.altman@wdc.com>,
	Andrew Halaney <ahalaney@redhat.com>,
	Bean Huo <beanhuo@micron.com>,
	Maramaina Naresh <quic_mnaresh@quicinc.com>
Subject: [PATCH v6 05/11] scsi: ufs: core: Convert a comment into an explicit check
Date: Wed, 16 Oct 2024 13:12:01 -0700
Message-ID: <20241016201249.2256266-6-bvanassche@acm.org>
X-Mailer: git-send-email 2.47.0.rc1.288.g06298d1525-goog
In-Reply-To: <20241016201249.2256266-1-bvanassche@acm.org>
References: <20241016201249.2256266-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

The comment /* UFSHCD_QUIRK_REINIT_AFTER_MAX_GEAR_SWITCH is set */ is
only correct if ufshcd_device_init() is only called by ufshcd_probe_hba()=
.
Convert the comment into an explicit check. This patch prepares for movin=
g
the ufshcd_device_init() calls.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 724060a9eae7..7b8eaf2b9ce2 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -8851,8 +8851,9 @@ static int ufshcd_device_init(struct ufs_hba *hba, =
bool init_dev_params)
 				return ret;
 			}
 			hba->scsi_host_added =3D true;
-		} else if (is_mcq_supported(hba)) {
-			/* UFSHCD_QUIRK_REINIT_AFTER_MAX_GEAR_SWITCH is set */
+		} else if (is_mcq_supported(hba) &&
+			   hba->quirks &
+				   UFSHCD_QUIRK_REINIT_AFTER_MAX_GEAR_SWITCH) {
 			ufshcd_config_mcq(hba);
 			ufshcd_mcq_enable(hba);
 		}
