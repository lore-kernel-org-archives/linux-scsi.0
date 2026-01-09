Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAED4274B42
	for <linux-scsi@vger.kernel.org>; Fri,  9 Jan 2026 20:51:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767991884; cv=none; b=CAOOW4t90W9gVpTXaUZbc5H70YrD6OTc/ds+wNwK2XEyyrCslhSHy55NaucQ+eK0JFIaGqvsd1YfUb9UZt57P+cxgwI8DuNGXcxu+5j7ER6ZJZxl1gHM89Y69KLwk4hHQSD/ID8fps4NxbmHB5Uemj0x5OKlE4BCjZT2WD2RPyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767991884; c=relaxed/simple;
	bh=sSbaoZteXT0vuytQbBlFHjej+Zx7ZtmxnY5mcRFHEUk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=opRro41pton/ydr5A043UmNrtH/bxLe+DvEkm0wvWN7ANP+zvSoHPvsIavG9jjwO80y8bhV9A8/VIahFmEwMVOdTtpywuc8HvQuwG8Tgl69t/hPIWP1cQ/VPd4rXcQyoP+qT/WuA2Qu1DDE/w5TejB0TxTv6M0YK8WnuuCPhuEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=snqTPrhc; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="snqTPrhc"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4dnv7t42LJzmP6YN;
	Fri,  9 Jan 2026 20:51:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1767991880; x=1770583881; bh=XbxXk
	ib0yh+fOi1bUXFU5fM9PzmrM7R8WCoQRNQ9SdA=; b=snqTPrhcLBg/He/0+eg0j
	KN15inWgppgVo3RZc90D7VKqUK3aWFnpUnhxupOjydBX1n18fIjc/orSEog29vbi
	aqVesjMRlv6NPvWy1p9du77yeZIxSzlLqaR+p9Iohat0oPUAWxwhvanN7fmiWLpn
	x7JiLBWn2j1JIImBRUaNj141Dw3qdT7Ulyh5Eei8delWHAYhcZGiXcaL8GejWPaB
	iDz1Gxv0L9n70S3HNmuUxsk623GpUDHUUsHhPef+0JHTqL28NR42PknwUw3WS5HF
	146B8/44uJnWSjwczmq/Xj7dERQLXUr64IDAWx5EaHtamMdyICvyAgpYbJp6W4ru
	Q==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id kD9CUvUIrBjY; Fri,  9 Jan 2026 20:51:20 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4dnv7p0fPQzmLCvb;
	Fri,  9 Jan 2026 20:51:17 +0000 (UTC)
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
Subject: [PATCH v2 1/2] ufs: core: Only call scsi_host_busy() after the SCSI host has been added
Date: Fri,  9 Jan 2026 12:51:01 -0800
Message-ID: <20260109205104.496478-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
In-Reply-To: <20260109205104.496478-1-bvanassche@acm.org>
References: <20260109205104.496478-1-bvanassche@acm.org>
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

Reviewed-by: John Garry <john.g.garry@oracle.com>
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
