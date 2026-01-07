Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63A0738E130
	for <linux-scsi@vger.kernel.org>; Wed,  7 Jan 2026 17:48:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767808105; cv=none; b=YaAl/jTsyCKHO5dVD2iyU//4KR7iaFxfZDdXDV9a3Xo01dk+22JsKaWGGMT7OijyyVPwYPcTBjJ7GYp4HKQ8tqIme4Y438XRZQIMpkShf4QYJr2VsmrqQKrONFRfTp7rN0ZNR1RS2YN+vbNEXSJwgYlNpp2RdFi1JGgQCCwkc6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767808105; c=relaxed/simple;
	bh=ezEwF8goScUQP9vDawny47R28Gh7VyJXu9xALbToumk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eYQc4RGmzQ7l3VH0vZwQYi9DqmHGlAEUCbSjMAFvZW63mHW3KzWMEx8jKwTA52xL8OYkQ+awNS842UsX1ehTEQbiXjgjsepBAzQZ16Ik6O1j8YDwt5toPHP6P8+ocOiUuPSWHa4DBJ6BV39+kecu+mQlCf++eqUZjUbgI1KTGV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=pILKKiIf; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="pILKKiIf"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4dmb9R0TjCzlm2CS;
	Wed,  7 Jan 2026 17:48:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1767808089; x=1770400090; bh=JzQUv
	EY+v+QS0sBC9L4rI1cHzm+E4KQdHJSUdcu4lRI=; b=pILKKiIfTgV8ULs/XAX0m
	sHs3BTMXQD1VwCPnpuiJz9Tol7ktZ5Pzt+QiHgiUweRggSG9iBZgdasuX6iGjn3Y
	GUfSqRt0m3BTtJ9LCof91NAG30pcsEBJnNJtvHBDX6yMz0Am7TbPoTAFL6p3Ss1g
	JXvxPTi8MlCybUbCmeCCcnFnhQxcBT1/EXTAZnwan1oF1OFdL0tsn8H4dAEplJx+
	GICt5Y5FY2CFXeKsSHHen894x/0yQcJ/6tYb9Mn5lF3NIuy2XBKWeikPvvZEdqUM
	kPgDDHqbGsDnjDMc6l7B+pxSLmJ5fc1kiAV5aPMDwThym/pZ6vyiETNk+z0vTjT5
	Q==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id H9kyaLpxoDBZ; Wed,  7 Jan 2026 17:48:09 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4dmb9M0bytzlkMXy;
	Wed,  7 Jan 2026 17:48:06 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	John Garry <john.g.garry@oracle.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Avri Altman <avri.altman@sandisk.com>,
	Bean Huo <beanhuo@micron.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	"Bao D. Nguyen" <quic_nguyenb@quicinc.com>
Subject: [PATCH 1/2] ufs: core: Only call scsi_host_busy() after the SCSI host has been added
Date: Wed,  7 Jan 2026 09:47:50 -0800
Message-ID: <20260107174753.3089238-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.52.0.351.gbe84eed79e-goog
In-Reply-To: <20260107174753.3089238-1-bvanassche@acm.org>
References: <20260107174753.3089238-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

scsi_host_busy() iterates over the host tag set. The host tag set is
initialized by scsi_mq_setup_tags(). The latter function is called by
scsi_add_host(). Hence only call scsi_host_busy() after the SCSI host
has been added. This patch prepares for reverting commit a0b7780602b1
("scsi: core: Fix a regression triggered by scsi_host_busy()").

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 562d8cffc6f6..69630677b23f 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -283,7 +283,8 @@ static bool ufshcd_has_pending_tasks(struct ufs_hba *=
hba)
=20
 static bool ufshcd_is_ufs_dev_busy(struct ufs_hba *hba)
 {
-	return scsi_host_busy(hba->host) || ufshcd_has_pending_tasks(hba);
+	return (hba->scsi_host_added && scsi_host_busy(hba->host)) ||
+		ufshcd_has_pending_tasks(hba);
 }
=20
 static const struct ufs_dev_quirk ufs_fixups[] =3D {
@@ -678,7 +679,8 @@ static void ufshcd_print_host_state(struct ufs_hba *h=
ba)
=20
 	dev_err(hba->dev, "UFS Host state=3D%d\n", hba->ufshcd_state);
 	dev_err(hba->dev, "%d outstanding reqs, tasks=3D0x%lx\n",
-		scsi_host_busy(hba->host), hba->outstanding_tasks);
+		hba->scsi_host_added ? scsi_host_busy(hba->host) : 0,
+		hba->outstanding_tasks);
 	dev_err(hba->dev, "saved_err=3D0x%x, saved_uic_err=3D0x%x\n",
 		hba->saved_err, hba->saved_uic_err);
 	dev_err(hba->dev, "Device power mode=3D%d, UIC link state=3D%d\n",
