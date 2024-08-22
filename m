Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69E881D1F42
	for <linux-scsi@vger.kernel.org>; Thu, 22 Aug 2024 21:37:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724362634; cv=none; b=P3CeZf3LF0zBD0wW62LYkWtCAygMbeqvdulvbN1ruoG8Q6fyXOK549HH0JORGLJKoZf7X1l2VuyMAiG9Ox4e4mQogKO3onI1FlWKDolG7ELUKJl7GBfRu89pI2nk4KG08iJhu93VBsv7A919DifAkqjZpKmb/sc+i6oROXgFL94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724362634; c=relaxed/simple;
	bh=ewPHbCmQVpyq3A5Tqg0HlePebFfhASchmdO5YVo5tIc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qSdWflyqD+ygcFz9KDenbqbIAhz0nB3MJwYvviX/UErvSLWvCAtPM0aE87yR0cT8e8yLdE5VnVkMwAeUUuijm3cVrRLBlJg0zlsHDpVit934Hn+DM3fl1LlnrwlyDgA9EOk529aRHD3vhZAMU6Wp1AdfsKvNifkREv9H00LO/GM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=DhCrAHnX; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="DhCrAHnX"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4Wqc3s0ZGyzlgVnK;
	Thu, 22 Aug 2024 21:37:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1724362629; x=1726954630; bh=3qyuM
	SlRKZgkvJNw3433u0bgkcJrHXj/PWMXslBDeFs=; b=DhCrAHnXgkY2v03gNxBQA
	44APQ1ap+Dnki+tLM7BVLu7fTqLN4hnuFexZ8EQOmQaYbCNH+I/itTxeCqNcGBmL
	XbTOQGAAbE7jqIjPMvxtg4sXVfSt2bVwAYFh3W818m6N61PZe4UJpGtWULHVcBad
	//k8tdy5lFE4uZ8MBT6F6biDT3hAtP5D4HQnTfeaaLrsz3HD1B+IzRfT1kLbQ6N9
	FNUcKH0jirEjlJGdVn8z1pcb7JnpNrLyev9VUNJ73c3+xqdfpecpet5gqXukupt3
	Ysb9APcW6h7xOs9tPMQUZK8Dfjt6FCw+Egb4BZWCpypuMYdlbWfHxA9j38TXfVPE
	w==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id vIBnKHR24WfU; Thu, 22 Aug 2024 21:37:09 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4Wqc3m63mMzlgVnf;
	Thu, 22 Aug 2024 21:37:08 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Avri Altman <avri.altman@wdc.com>,
	Bean Huo <beanhuo@micron.com>,
	Andrew Halaney <ahalaney@redhat.com>
Subject: [PATCH v2 4/9] ufs: core: Call ufshcd_add_scsi_host() later
Date: Thu, 22 Aug 2024 14:36:05 -0700
Message-ID: <20240822213645.1125016-5-bvanassche@acm.org>
X-Mailer: git-send-email 2.46.0.295.g3b9ea8a38a-goog
In-Reply-To: <20240822213645.1125016-1-bvanassche@acm.org>
References: <20240822213645.1125016-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Call ufshcd_add_scsi_host() after host controller initialization has
completed. This is possible because no code between the old and new
ufshcd_add_scsi_host() call site depends on the scsi_add_host() call.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index dcc417d7e19c..b513ef46d848 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -10585,10 +10585,6 @@ int ufshcd_init(struct ufs_hba *hba, void __iome=
m *mmio_base, unsigned int irq)
 		hba->is_irq_enabled =3D true;
 	}
=20
-	err =3D ufshcd_add_scsi_host(hba);
-	if (err)
-		goto out_disable;
-
 	/* Reset the attached device */
 	ufshcd_device_reset(hba);
=20
@@ -10600,7 +10596,7 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem=
 *mmio_base, unsigned int irq)
 		dev_err(hba->dev, "Host controller enable failed\n");
 		ufshcd_print_evt_hist(hba);
 		ufshcd_print_host_state(hba);
-		goto free_tmf_queue;
+		goto out_disable;
 	}
=20
 	/*
@@ -10635,6 +10631,10 @@ int ufshcd_init(struct ufs_hba *hba, void __iome=
m *mmio_base, unsigned int irq)
 	 */
 	ufshcd_set_ufs_dev_active(hba);
=20
+	err =3D ufshcd_add_scsi_host(hba);
+	if (err)
+		goto out_disable;
+
 	async_schedule(ufshcd_async_scan, hba);
 	ufs_sysfs_add_nodes(hba->dev);
=20
@@ -10642,12 +10642,6 @@ int ufshcd_init(struct ufs_hba *hba, void __iome=
m *mmio_base, unsigned int irq)
 	ufshcd_pm_qos_init(hba);
 	return 0;
=20
-free_tmf_queue:
-	blk_mq_destroy_queue(hba->tmf_queue);
-	blk_put_queue(hba->tmf_queue);
-	blk_mq_free_tag_set(&hba->tmf_tag_set);
-	if (hba->scsi_host_added)
-		scsi_remove_host(hba->host);
 out_disable:
 	hba->is_irq_enabled =3D false;
 	ufshcd_hba_exit(hba);
