Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2995626C3AA;
	Wed, 10 Sep 2025 21:33:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757540012; cv=none; b=Mk7jA8wZ+VhPnm65WpEI+dGAUXRuc6bWpQgwdp5unTpFR2VEJ2DUSPMRICVakXWkPs9gxqRrIIj0mGDjd6IAfJJNf+wcoxEprDM7DEK6zNF4pavh6Q3e5NiMKJsoeRwhAfdQT+biQCC/2tZmk3d2jTcwzs9R3c6ORZ5gLrKwz8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757540012; c=relaxed/simple;
	bh=py7tkCkmCZNOaKK/EmOP3FklYFGdukzH8kHnnAABZ1E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dwA52gzF+X7UnWCd+ZVMb3sKZdtpaAMpQTqfHItISdQ9iruPvoLbPQzn12iOJzyGsM0rUhasVAUq9xT4E4XMyUgdrTSJ4L4DuPXXBui8Q2mjZGBMTjRy71Yy45NdD02KmAGVeDuizyfsb23fOmi/5m5K0wk9J39hCT09hytduI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=1GdFl16h; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="1GdFl16h"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4cMYpL14hgzm174M;
	Wed, 10 Sep 2025 21:33:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1757540008; x=1760132009; bh=wSaNS
	clKvMW5D0Le0KkPIcaTj58vXxrrUjRcU8kIEkc=; b=1GdFl16hAtZjAgUm8zZz4
	27AVEyvaTcE2WN7ARw7MLevbodkKtpuShPCOLO08oy+szmMKtE5K1SPsa4f5AQEi
	eCWIbl9nYidrY8KVdUGsEECVhmD3ZWyMdEVKON3sFxIRl40YGPlKQZnpbZvIrZW+
	FqItswQWrsqZivIoy98PBetrLdv0xIzWjXKjXPBDppUgCn1BYAL5qGd020jOIW45
	BJwqVsstKekWE5BnBwzMCFL8TfHaaVL4dgck9G09x9GDv8dDsZFCKI6AoKqnXvUg
	oSyykNFk5/Q7/DQxn75th4Q7O49Dysa6kOSm8UzuZ2H7yFIPxP9bOxBmu8ZO2Z/E
	A==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id u7ffe3nzxLAx; Wed, 10 Sep 2025 21:33:28 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4cMYp74Z53zm0yVj;
	Wed, 10 Sep 2025 21:33:18 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	linux-block@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Jens Axboe <axboe@kernel.dk>,
	Christoph Hellwig <hch@infradead.org>,
	Ming Lei <ming.lei@redhat.com>,
	John Garry <john.g.garry@oracle.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Avri Altman <avri.altman@sandisk.com>,
	Bean Huo <beanhuo@micron.com>
Subject: [PATCH 2/3] ufs: core: Use scsi_device_busy()
Date: Wed, 10 Sep 2025 14:32:50 -0700
Message-ID: <20250910213254.1215318-3-bvanassche@acm.org>
X-Mailer: git-send-email 2.51.0.384.g4c02a37b29-goog
In-Reply-To: <20250910213254.1215318-1-bvanassche@acm.org>
References: <20250910213254.1215318-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Use scsi_device_busy() instead of open-coding it. This patch prepares
for skipping the SCSI device budget map initialization in certain cases.

Cc: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Ming Lei <ming.lei@redhat.com>
Cc: John Garry <john.g.garry@oracle.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index e2157128e3bf..e03e555cc148 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -1287,13 +1287,13 @@ static bool ufshcd_is_devfreq_scaling_required(st=
ruct ufs_hba *hba,
  */
 static u32 ufshcd_pending_cmds(struct ufs_hba *hba)
 {
-	const struct scsi_device *sdev;
+	struct scsi_device *sdev;
 	unsigned long flags;
 	u32 pending =3D 0;
=20
 	spin_lock_irqsave(hba->host->host_lock, flags);
 	__shost_for_each_device(sdev, hba->host)
-		pending +=3D sbitmap_weight(&sdev->budget_map);
+		pending +=3D scsi_device_busy(sdev);
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
=20
 	return pending;
