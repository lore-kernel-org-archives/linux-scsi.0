Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 362851C2DC5
	for <linux-scsi@vger.kernel.org>; Thu, 12 Sep 2024 22:30:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726180253; cv=none; b=kqy3pLQEfk7YgYKNmY1WTtG28JEdPr/4w1GchT68P8pjmfAnlwKTzbutRY7h9h1P4GYUC5M9ZP8UDgOfMQ29pkgaLbKj77oDsje1ixHn1aHRnwsf2hycIE4emRZvgnT/IT1yOwrt32RmvkjFw72rzkWKXVyZxhB3TlOLuhbP3jQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726180253; c=relaxed/simple;
	bh=EItZQZqGW67M4lIKGR/iRJ2sWrG3xM+ZPKTZnbqzjkI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N35L6Pj5ADdf7meIeoIoK2JPc8pYZTt6V+HGrKKInWPdiXRkQUU13VkMF5EG/uuMyUP4y0mNElssGY9IVO9Ul08+yCoMEmdrgejH4VM8DjFPvQlKBcbhD9Z3l7KXihlDF87IY2kOWD+ZMDm3B/i4E9Uc6EYf6jzqwZGmHzlJ0kI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=10DEGMer; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="10DEGMer"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4X4XG34mzkz6ClY9f;
	Thu, 12 Sep 2024 22:30:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1726180247; x=1728772248; bh=KjUCX
	+a/r76Kaz62EccFAD9fZ938Fa4JiaRnBwzRj0I=; b=10DEGMer9HkzsBil55WAb
	YUt9Ls0Uc7efe0RUDC9RXoWayeN3M6yTbIDuZyMC8KEvk6Le+aNr8PMDSMk3YEMK
	yZeTMnvAl+J2IYq3YHIdIp0CX6r0AdYPwjnVLSboc6hzO1OAKX/NBTTDmn3IkeHq
	URZsr3MCzP4fY3z1EpBxLtjY+C4U/NSDOYBlylIas86gbyGEuXt9MVpGW6SmZk8G
	4rxT/SVCEY2KLFhaNZnBFra2M86QTLyjVsK8HGYUfAn+5gBCUcxfQMNQ1nT597Wg
	QBjLBLlbymo7R+uj1fMx7b4Ist2nwwh9jXwNjHF+6F05MgFMkl0TYUFtT5rRzgHR
	w==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 4yUXmUbTB7NZ; Thu, 12 Sep 2024 22:30:47 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4X4XFy2bzTz6ClY9R;
	Thu, 12 Sep 2024 22:30:46 +0000 (UTC)
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
Subject: [PATCH v4 3/4] scsi: ufs: core: Make ufshcd_uic_cmd_compl() easier to analyze
Date: Thu, 12 Sep 2024 15:30:04 -0700
Message-ID: <20240912223019.3510966-4-bvanassche@acm.org>
X-Mailer: git-send-email 2.46.0.662.g92d0881bb0-goog
In-Reply-To: <20240912223019.3510966-1-bvanassche@acm.org>
References: <20240912223019.3510966-1-bvanassche@acm.org>
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
index 134cba0ff512..d047ccba8b84 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -5462,10 +5462,13 @@ static irqreturn_t ufshcd_uic_cmd_compl(struct uf=
s_hba *hba, u32 intr_status)
=20
 	spin_lock(hba->host->host_lock);
 	cmd =3D hba->active_uic_cmd;
+	if (WARN_ON_ONCE(!cmd))
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
