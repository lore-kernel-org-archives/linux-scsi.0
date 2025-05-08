Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3A9028315F
	for <linux-scsi@vger.kernel.org>; Thu,  8 May 2025 16:54:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746723284; cv=none; b=lCcM+K+jScmvboVRMTzTL6HkLsrkoqOkVGv6irCFGnolFnDTJfX6U/0pxFQl3ZN6kdUyz5aoShNvSW5zyPxZoU1VvvYW6V/+39tpxLIBpEtNaXd7ctLqoaup0hvsiKdTOFi3tzP1rQc6+mCDXXozc6OZnb9PkYCMGQto0HJ3ks4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746723284; c=relaxed/simple;
	bh=tIAY59g+Wr0BTPMoQi6ocR51UKAbCHv33iRnXeP1p5o=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ly/Nb+JWWBJdZSluk7wT1dTgLh326G2keSbpO/VnW1BlTsQ4WaKqyEQfHSY+hLuj4mnt3N07TaFnGcV4JgKnICKdpG9JyH16gtCfJ6wkkGBL6I7hKeDzOM8H1oP1Q6c4R53/OG5w8YATJd+ooY65Dz4bbmyUYmE+DYwzWUmqUfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=ma05jJes; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="ma05jJes"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4ZtdXJ4Y6HzlnfZR;
	Thu,  8 May 2025 16:54:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:x-mailer:message-id:date
	:date:subject:subject:from:from:received:received; s=mr01; t=
	1746723278; x=1749315279; bh=Z+y0mybq7Wn+PAj2gNmW2UJdTBkrcfP0ccI
	hS0N1oq4=; b=ma05jJesNXLdedxSb3MlFob8wNykqB5WE3628ZOC+M0yV2LRmGS
	hdZ48ZEKheBwPnzY3fHSGFVyNNDL9ot8xMwMFezt8k6GrdltJRuGbHiSb6yycE3J
	tusE5RZHn3GNOBECfO5z06VTENlj1j6VOL+RF3CuoOB6ra+Katq0Gi5zmus3cCFQ
	ZimyoG2JfNrTLLWX/zeqG2CNoKEeG2d0JCMjLnCtiOsviOsvRjAtUenaVvNO74jJ
	1Eli4U+JkMYe9Ps7BK1ixJTZ2MNs8au9rgph0BX72KfBl0k6CWuOzjT1zR+O7RDd
	7SFTBqwc+6pQDNnpQOXvYR3h0Wt/0pQBbfQ==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id wy8Fd54odszP; Thu,  8 May 2025 16:54:38 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4ZtdX92VrbzlgqV4;
	Thu,  8 May 2025 16:54:32 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Avri Altman <avri.altman@wdc.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	"Bao D. Nguyen" <quic_nguyenb@quicinc.com>
Subject: [PATCH] scsi: ufs: core: Increase the UIC command timeout further
Date: Thu,  8 May 2025 09:54:03 -0700
Message-ID: <20250508165411.3755300-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.49.0.987.g0cc8ee98dc-goog
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

On my development board I observed that it can take a little longer than
two seconds before UIC completions are processed if the UART is enabled.
Hence this patch that increases the UIC command timeout upper limit
further.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 2d39924a32b0..b18ba17c22ff 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -54,7 +54,7 @@
 /* UIC command timeout, unit: ms */
 enum {
 	UIC_CMD_TIMEOUT_DEFAULT	=3D 500,
-	UIC_CMD_TIMEOUT_MAX	=3D 2000,
+	UIC_CMD_TIMEOUT_MAX	=3D 5000,
 };
 /* NOP OUT retries waiting for NOP IN response */
 #define NOP_OUT_RETRIES    10
@@ -134,7 +134,7 @@ static const struct kernel_param_ops uic_cmd_timeout_=
ops =3D {
=20
 module_param_cb(uic_cmd_timeout, &uic_cmd_timeout_ops, &uic_cmd_timeout,=
 0644);
 MODULE_PARM_DESC(uic_cmd_timeout,
-		 "UFS UIC command timeout in milliseconds. Defaults to 500ms. Supporte=
d values range from 500ms to 2 seconds inclusively");
+		 "UFS UIC command timeout in milliseconds. Defaults to 500ms. Supporte=
d values range from 500ms to 5 seconds inclusively");
=20
 #define ufshcd_toggle_vreg(_dev, _vreg, _on)				\
 	({                                                              \
