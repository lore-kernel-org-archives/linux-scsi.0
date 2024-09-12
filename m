Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEB105684
	for <linux-scsi@vger.kernel.org>; Thu, 12 Sep 2024 00:31:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726101089; cv=none; b=Doxa14v1dTBsoKT2E1ixWxifDx7LcsRoTv2oIpfZ4275upFXKzGWTTp8o83HIQZitE+IynaX0OrnqUf+XLpYqsl6gWmgrGe6sAJbjTSzcGMfR3RSw5bDX+OARnWbpzrEZ2CstMDJbwqBFzJUzl8lATvMJdp0SHuMhec37kdjWh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726101089; c=relaxed/simple;
	bh=3StelB+OMxZvrOslTKx1BGcXrp0fdmzFNI3GQu30oiE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AH/apw/eZoF4CiRV18YT3+rFfQPgjA1mpUnSi6bw8/cuAgV9HUCOMOIti2V4SiL3j0l/4mKsX7bLKvwAwAvPhv312FMnoOEr6Ax8Yc11CHe+81GuKQA5NzGvvXspOsyPIOjLkEUkyPbpGAwpH+fehG/U9c0JNl/dsod/aZwONJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=M5k4dkgR; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="M5k4dkgR"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4X3yzg4Cfwz6ClY9R;
	Thu, 12 Sep 2024 00:31:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1726101083; x=1728693084; bh=MZuqY
	m1wzEII0tIbL7jkYNJTnU9MWqLzTZimNWxUcIs=; b=M5k4dkgReyO6eNrnXSAzP
	AFlTv59lv192Q6NR4EOw5Ww2cIq6eolEk6rbLHpLyPLbQXL/DRhUUK6akibDucvP
	2tFruPGQHw1BudVsJopOxrg7YxsQzjij9w2ncmsId80x4+Qll8ulrk5j7r6joaFR
	tNBztTfcon/nnPSmQFDl7RAf+G0wazTLZYa79HCLYKjgwu3nkIwbOjTe8HadUEsg
	+cPzIT4y9i5/pNmA1SofyliLX/ca+9zXn4+1sbG9PHRSJYh/7GzxHTA9Zi4WswOP
	Tj0LOGyOgZq5nbfNKp74qYs9aLBJWJTa7fWNbnsD3zYEfPJpYOt/IDefi0Npazdy
	Q==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id PCKA0WooIsHK; Thu, 12 Sep 2024 00:31:23 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4X3yzZ3nkFz6ClY9K;
	Thu, 12 Sep 2024 00:31:22 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Avri Altman <avri.altman@wdc.com>,
	Andrew Halaney <ahalaney@redhat.com>,
	Bean Huo <beanhuo@micron.com>,
	"Bao D. Nguyen" <quic_nguyenb@quicinc.com>
Subject: [PATCH v3 3/4] scsi: ufs: core: Make ufshcd_uic_cmd_compl() easier to analyze
Date: Wed, 11 Sep 2024 17:30:48 -0700
Message-ID: <20240912003102.3110110-4-bvanassche@acm.org>
X-Mailer: git-send-email 2.46.0.598.g6f2099f65c-goog
In-Reply-To: <20240912003102.3110110-1-bvanassche@acm.org>
References: <20240912003102.3110110-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

In ufshcd_uic_cmd_compl(), there is code that dereferences 'cmd' with
and without checking the 'cmd' pointer. This confuses static source code
analyzers like Coverity and sparse. Since none of the code in
ufshcd_uic_cmd_compl() can do anything useful if 'cmd' is NULL, move the
'cmd' test near the start of this function.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 134cba0ff512..bd4ce3395972 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -5462,10 +5462,13 @@ static irqreturn_t ufshcd_uic_cmd_compl(struct uf=
s_hba *hba, u32 intr_status)
=20
 	spin_lock(hba->host->host_lock);
 	cmd =3D hba->active_uic_cmd;
+	if (!cmd)
+		goto unlock;
+
 	if (ufshcd_is_auto_hibern8_error(hba, intr_status))
 		hba->errors |=3D (UFSHCD_UIC_HIBERN8_MASK & intr_status);
=20
-	if (intr_status & UIC_COMMAND_COMPL && cmd) {
+	if (intr_status & UIC_COMMAND_COMPL) {
 		cmd->argument2 |=3D ufshcd_get_uic_cmd_result(hba);
 		cmd->argument3 =3D ufshcd_get_dme_attr_val(hba);
 		if (!hba->uic_async_done)
@@ -5482,7 +5485,10 @@ static irqreturn_t ufshcd_uic_cmd_compl(struct ufs=
_hba *hba, u32 intr_status)
=20
 	if (retval =3D=3D IRQ_HANDLED)
 		ufshcd_add_uic_command_trace(hba, cmd, UFS_CMD_COMP);
+
+unlock:
 	spin_unlock(hba->host->host_lock);
+
 	return retval;
 }
=20
