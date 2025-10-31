Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96988CA6F
	for <linux-scsi@vger.kernel.org>; Fri, 31 Oct 2025 20:43:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761943429; cv=none; b=h7FDKs5l/owv3HhNQ9CjqSGq/6Rn5MaKXmyktwBvz/zZuVjlX9j6virblGccoEClKMsClhDz1iRKhBNhWQMTxlWoXknq998F+m/5x0YAtvpeNhgljoBubVFKb3vkGSg+o+x/1OZRbv9iinVYavHOJhlxGtrjbfHYpATzRreBxx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761943429; c=relaxed/simple;
	bh=rXhKAGXHee1we0hNiqW7mPay7RD89qvAUu0CciRj+CI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gsQkn5f9CuTfESG616VJQnz39aSE0Nv+fbEdLW3CCYkr7GHmFsfJ2LzxiOfUwP33PoiW2hFfntTA2MV0E3LvBNzee254jyVr4CICIMt9EJZXmxdNSh0HOZX2PMa1EOmPRsJEQBV0IErnVOvS8MYBf3Kx6Dyy/a5zVNycVfqMPhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=eDOBZRQQ; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="eDOBZRQQ"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4cytHQ4RTYzm0pKn;
	Fri, 31 Oct 2025 20:43:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1761943424; x=1764535425; bh=RrLPt
	4C5e6+12kGLJZdYNVbXvlyjHZdpg48s/AIwbjU=; b=eDOBZRQQ2J3nV3rSY+ctH
	W2mlnBOib/83KS6zammuJ3kKbAIpi+JFnROJOMy7WPKbfY+n5PFboVqtEPwEbxpr
	h4HV328IBmadRIl9u5wq7k0r1Gimy4cgdW3pPGn6wFVkx22OlyK79GI8JqxrtNgx
	c+gybCoSqtg+Wh7Hj7suLfJ8LWDiY66/1f/53yqIwHlL86Fmm4+c5mZYVBCcOmO6
	3YUF7r9y5AW/ISnX0ZsmOVqr4HBfiXwJsc4lM7nPlfFg7HIUUdxfyIiFQ9x0isJA
	aK3NPgezWW4q1cRMt/dKbwSLWePJ1P5KRXj4oA1+t6JOocyJg/UhKO53aEhzrMR4
	w==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id DhrLhJTZaamn; Fri, 31 Oct 2025 20:43:44 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4cytHG6f3Rzm0pL4;
	Fri, 31 Oct 2025 20:43:38 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Avri Altman <avri.altman@sandisk.com>,
	Bean Huo <beanhuo@micron.com>,
	"Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
	Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH v8 22/28] ufs: core: Do not clear driver-private command data
Date: Fri, 31 Oct 2025 13:39:30 -0700
Message-ID: <20251031204029.2883185-23-bvanassche@acm.org>
X-Mailer: git-send-email 2.51.1.930.gacf6e81ea2-goog
In-Reply-To: <20251031204029.2883185-1-bvanassche@acm.org>
References: <20251031204029.2883185-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Tell the SCSI core to skip the memset() call that clears driver-private
data because __ufshcd_setup_cmd() performs all necessary initialization.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufshcd.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 20eae5d9487b..1757aa0237da 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -2996,6 +2996,15 @@ static void ufshcd_map_queues(struct Scsi_Host *sh=
ost)
 	}
 }
=20
+/*
+ * The only purpose of this function is to make the SCSI core skip the m=
emset()
+ * call for the private command data.
+ */
+static int ufshcd_init_cmd_priv(struct Scsi_Host *host, struct scsi_cmnd=
 *cmd)
+{
+	return 0;
+}
+
 /**
  * ufshcd_queuecommand - main entry point for SCSI requests
  * @host: SCSI host pointer
@@ -9182,6 +9191,7 @@ static const struct scsi_host_template ufshcd_drive=
r_template =3D {
 	.name			=3D UFSHCD,
 	.proc_name		=3D UFSHCD,
 	.map_queues		=3D ufshcd_map_queues,
+	.init_cmd_priv		=3D ufshcd_init_cmd_priv,
 	.queuecommand		=3D ufshcd_queuecommand,
 	.nr_reserved_cmds	=3D UFSHCD_NUM_RESERVED,
 	.mq_poll		=3D ufshcd_poll,
