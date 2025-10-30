Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46FD832E757
	for <linux-scsi@vger.kernel.org>; Thu, 30 Oct 2025 19:40:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761853250; cv=none; b=mbAwHScMYr1fimSYMS9gA4GXLOAcKM/lESrZAqouQU9Uq/QIGOCfnQWMac7Vkmk5VFijJdoml0A4iywGQYHBY3+5AjzydWuzdDbSpdLxRrTxCjjIlmleQDUldlD75kk1R//PHsQV8adNjQ/lLUKkKQdtUgubX6i/h4wyd5As+Wc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761853250; c=relaxed/simple;
	bh=rXhKAGXHee1we0hNiqW7mPay7RD89qvAUu0CciRj+CI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lBtAWhAbXpsPXGV+bN7uU8pMFCtvwkNLkfbsScZYBEv4VzJ7b/Ydb20MVVUf7FKW0qgNIz1FU1tH3C5RFWCpnRs6/XT/urSf17sHLdwP3bFQVq8QpBVKV1KGlWxxPJ3y1hSNCqHceRjv7Fk3eKN5D/DHSnOa1WASCSNmrVsYcj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=LplWi353; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="LplWi353"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4cyDxD3WVPzlv4Vd;
	Thu, 30 Oct 2025 19:40:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1761853246; x=1764445247; bh=RrLPt
	4C5e6+12kGLJZdYNVbXvlyjHZdpg48s/AIwbjU=; b=LplWi353b//62UJILpeCn
	90yTw5yEC2xU49TRpNKmOTuOk2l4P9KxvUMG71/DP8q4dKcGDdouAq9SL1bwDQ5p
	ngrkbQwrWgLwQi5K7EEi+p9sDRZFq1UXcXjfNGQyVN2fIpMkcyHrLk9TpiU9WmXL
	NC8UwCzVIvJJrGsORUAHELruj4ukmB25wkHW85exv0mSg1LKacrNIXHIQVQK9Baf
	ox8r1tQzpXnogomNWnepOkF2nGxuC5ODEXiiGYiOQifccLTjZ72G6iUb7XbBiFdv
	5L8KRj/0gauExBhM1ze+pZEfAGZWpX16RSsFKtMTizhQaHbm0J8bBn4OnrOyAmIe
	g==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id Rb_YvdGsGROi; Thu, 30 Oct 2025 19:40:46 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4cyDx438lyzlngp5;
	Thu, 30 Oct 2025 19:40:39 +0000 (UTC)
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
Subject: [PATCH v7 22/28] ufs: core: Do not clear driver-private command data
Date: Thu, 30 Oct 2025 12:36:21 -0700
Message-ID: <20251030193720.871635-23-bvanassche@acm.org>
X-Mailer: git-send-email 2.51.1.930.gacf6e81ea2-goog
In-Reply-To: <20251030193720.871635-1-bvanassche@acm.org>
References: <20251030193720.871635-1-bvanassche@acm.org>
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
