Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42DEB263F2D
	for <linux-scsi@vger.kernel.org>; Wed, 24 Sep 2025 20:34:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758746074; cv=none; b=E3SlAOP0AQQZSlAz7IaT3U8XwYBAn5ovlinjokRPDJa7lihNVbFcT9AljqPQVjvZD0Rlubde706zw6557eyAm9TMHT92vUesZt1MgNWl8R9ztUQobL1nshnKoE09EXUjGuMpFLDdAPPAp2TcFT0qsCVa5BMWAvJeAH0ggeXGZKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758746074; c=relaxed/simple;
	bh=K3EB5JXPVRNVBmqvLLyzc7UL9V1WItRJTzVmJ2T1+W0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Oy0pzHoV5X7L4ffsNaaAiVXNxAHyzLSKPl/SZAqkFz/4B4sdEgMSZihOJOMOHF99RX8jzIEFS7/2FWQhpfqxQNyGreSRpFYHSPeNNpnUwyvGC7NLOw+I+8a2miz1MlUCHK80gGRT0A5H2b/BErnGIBG1kUH4tRFyP43+ZFYQU4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=MKD5HC2i; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="MKD5HC2i"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4cX7qr1VGSzlgqxk;
	Wed, 24 Sep 2025 20:34:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1758746070; x=1761338071; bh=mWX0p
	o95CPgj+dpppYnQZ5WJR4Ir6hsKvl9Wi4VORqc=; b=MKD5HC2iQNuR+BLUfnuO1
	SsTKrsG1HXGQ7Jm4cax+Efe1Dp5RLdhNojxTIuMVnCDpyRJGOLVNP0pxKTNROIqT
	Nu5gbHmppTPp8+096NAX5AdqXmX9SZ4DXPwMlHu8Ei9T/9z83qH6LXMRSkxRNH5S
	SJt4DS6jcfrRyVMhJXeH9iBquEBTM8KQY77ICauRmJ1kQqEH863eTDfZ7DACwygW
	W7zdD7NaCNYg4hq0YceOwuXDcLf/ITDACoRZy51PtYYq7plhqXZ1ep637EkxS13U
	MGNBEpgzMOddq3XEoK4+gmBfCHDaTxaYXDPaIgWeBslbY9sLTB2LrL9vAIyFRUTP
	Q==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id DbKfLFo_RsUC; Wed, 24 Sep 2025 20:34:30 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4cX7qj3JSMzlgqVP;
	Wed, 24 Sep 2025 20:34:24 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Avri Altman <avri.altman@sandisk.com>,
	Bean Huo <beanhuo@micron.com>
Subject: [PATCH v5 22/28] ufs: core: Do not clear driver-private command data
Date: Wed, 24 Sep 2025 13:30:41 -0700
Message-ID: <20250924203142.4073403-23-bvanassche@acm.org>
X-Mailer: git-send-email 2.51.0.536.g15c5d4f767-goog
In-Reply-To: <20250924203142.4073403-1-bvanassche@acm.org>
References: <20250924203142.4073403-1-bvanassche@acm.org>
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
index 1dbb5bdf84f2..a54359289db5 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -2995,6 +2995,15 @@ static void ufshcd_map_queues(struct Scsi_Host *sh=
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
@@ -9157,6 +9166,7 @@ static const struct scsi_host_template ufshcd_drive=
r_template =3D {
 	.name			=3D UFSHCD,
 	.proc_name		=3D UFSHCD,
 	.map_queues		=3D ufshcd_map_queues,
+	.init_cmd_priv		=3D ufshcd_init_cmd_priv,
 	.queuecommand		=3D ufshcd_queuecommand,
 	.mq_poll		=3D ufshcd_poll,
 	.sdev_init		=3D ufshcd_sdev_init,
