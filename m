Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C52B1216A2F
	for <linux-scsi@vger.kernel.org>; Wed, 16 Oct 2024 20:13:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729109625; cv=none; b=dgMkRkHFa3xF45SNf2mH0xm6/Pxvr1CF7HyvOkNGarTO4aRm/eGcq+PkU21EvQqqV9QKPwMfWN1tqA4hCdj7FIX0n0CQolFAbbjMlNIJMNpf7msyAvSZN9UQ2qaIL9Fj1rvxcfrBZnX/nTRpZG5kit7zHqVTWzGRMZVrAcS81RQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729109625; c=relaxed/simple;
	bh=l7zpIObIHmeefx+6Bd8CVeiVAZXklNAquvVu/uguf5g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mU3iwtYVbziNxuoIIYZ9JArLhMuIEVrTu6VZ7vG0hv/N/bODWP3d7L9Zz1tIvgsxkqruWuxVDSDUd0maUh63m9j99yt+l4JAWAO7JE52Tg69shuYCtc+JMhJbTDvtjwJGnTowhQ7Awf1hR2pPfivXy0Ix26Z4l1pofB9XHZLqho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=DIQSYOp4; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="DIQSYOp4"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4XTMc72fHNz6ClY9l;
	Wed, 16 Oct 2024 20:13:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1729109618; x=1731701619; bh=/NNbG
	6RIcSaUAnxTooaivkM1JeTa92umfn6us3KLGhA=; b=DIQSYOp4t2iP9ZBA7ga5I
	7QjxWPW3sJ1SVJ2ytB4RQyCctdQn/ow27n+7lAH9i9MrEAifEbzrBbJEAFQDj5tw
	Uvic/MY9h22+QdkNASkdB1mGlL3oqCsgvXDCYd2sJW+wc689eQaducBx0opfeZHK
	mrgmaQxY25u2bcQC0bdEwOdMZcSJ7N/jCvwja2QDBL9/EmGd0ThLFNd2hSe8xiuD
	7EmgctfZrOQFjn0JBa2VQHlRjXMzTS91xjO0rYTHQJ2K8yNKFL9B9x1kWH/YyqLf
	86GnNbCB4y/YVrAOrzzU9S0YRDs6AiSLnRe3Np4bd5/HojicLCwokoYXk2nsumb/
	w==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id dmO7j30x7F_b; Wed, 16 Oct 2024 20:13:38 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4XTMc04Lyyz6ClY9d;
	Wed, 16 Oct 2024 20:13:36 +0000 (UTC)
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
Subject: [PATCH v6 07/11] scsi: ufs: core: Move the ufshcd_device_init(hba, true) call
Date: Wed, 16 Oct 2024 13:12:03 -0700
Message-ID: <20241016201249.2256266-8-bvanassche@acm.org>
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

ufshcd_async_scan() is called (asynchronously) only by ufshcd_init().
Move the ufshcd_device_init(hba, true) call from ufshcd_async_scan()
into ufshcd_init(). This patch prepares for moving both scsi_add_host()
calls into ufshcd_add_scsi_host(). Calling ufshcd_device_init() from
ufshcd_init() without holding hba->host_sem is safe. This is safe because
hba->host_sem serializes core code and sysfs callbacks. The
ufshcd_device_init() call is moved before the scsi_add_host() call and
hence happens before any SCSI sysfs attributes are created.

Since ufshcd_device_init() may call scsi_add_host(), only call
scsi_add_host() from ufshcd_add_scsi_host() if the SCSI host has not yet
been added by ufshcd_device_init().

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 8803031f1694..063b87be23e9 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -8937,9 +8937,7 @@ static void ufshcd_async_scan(void *data, async_coo=
kie_t cookie)
 	down(&hba->host_sem);
 	/* Initialize hba, detect and initialize UFS device */
 	probe_start =3D ktime_get();
-	ret =3D ufshcd_device_init(hba, /*init_dev_params=3D*/true);
-	if (ret =3D=3D 0)
-		ret =3D ufshcd_probe_hba(hba, true);
+	ret =3D ufshcd_probe_hba(hba, true);
 	ufshcd_process_probe_result(hba, probe_start, ret);
 	up(&hba->host_sem);
 	if (ret)
@@ -10408,7 +10406,8 @@ static int ufshcd_add_scsi_host(struct ufs_hba *h=
ba)
 {
 	int err;
=20
-	if (!is_mcq_supported(hba)) {
+	if (!hba->scsi_host_added) {
+		WARN_ON_ONCE(is_mcq_supported(hba));
 		if (!hba->lsdb_sup) {
 			dev_err(hba->dev,
 				"%s: failed to initialize (legacy doorbell mode not supported)\n",
@@ -10637,6 +10636,11 @@ int ufshcd_init(struct ufs_hba *hba, void __iome=
m *mmio_base, unsigned int irq)
 	 */
 	ufshcd_set_ufs_dev_active(hba);
=20
+	/* Initialize hba, detect and initialize UFS device */
+	err =3D ufshcd_device_init(hba, /*init_dev_params=3D*/true);
+	if (err)
+		goto out_disable;
+
 	err =3D ufshcd_add_scsi_host(hba);
 	if (err)
 		goto out_disable;
