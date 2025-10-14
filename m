Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30D4F305972
	for <linux-scsi@vger.kernel.org>; Tue, 14 Oct 2025 20:20:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760473249; cv=none; b=P2v5GQ/kqGzny9ISWBIeAUfQj1WVsbMs8iYhvjMZTOjp7rYnKMl69c2ydQA7Jq+lFdEk/dHg86KktC63i8RyOK5mdqyCwCI7w9XE7jSTD/8axWqbFLJhhRySX/WeBQPnCiMf5wi6Id1bZrEUQvnJaRiBrtVE7YsBrBZjUDSSZB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760473249; c=relaxed/simple;
	bh=5lNT4DwMZVbdP9dLx1AlsDhp6LUILTn7pmn71IPN4Z8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m5WrpuoGPiS1Ar02tFXy9n+PA4eLfMlTKAIyQDrgAKQuUp8zV73abIoGDB717inENFfaF2noCBh54/IzSSSaS5K/y4oq3Q+uI55MIMy+nVVRT4utekdxv0R7D/OBuDnKt7p6rZOW23Z+n7a6T+G/jbT7yDeVb4azbyx0mgYdoow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=4pCIOq/4; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="4pCIOq/4"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4cmQZl3tkSzm0yV3;
	Tue, 14 Oct 2025 20:20:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1760473245; x=1763065246; bh=QLvhR
	GvRDYSz389gHQ5nrfcum4dpZCFG/u0KjIoAFPE=; b=4pCIOq/4plu2KlJlcu70P
	P3hS8XVLVrkQp31MOd6s8O6SGuuvwISVboFWeU4Crx2HQzMadhcL9E9bPuS0StSd
	z7EtDcNC3a5XRrG8EC/FzfE4gKGSv3/pFVlzfWmghYlyEBEKCayG4kqvYNJcBSRH
	vzhbycgd+LMKt0j8Uw7Nm0UzaI51tNNPNi4KnJjpTISYM1V6RQ7tV1dUCxTB3M5E
	z9WpDkmzTqlw4rWlYK7han2RbvVEOz0Hr7/AINRUmPzAdshYsDpc/Vr4hJeW/6Wu
	910BV7qKiAZwyhO2oEbRr+VP8sBBebROXF1RFiPyvew3yxnvsNpAV6sQzRgoTKZv
	A==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 8RdrT0nxVqr1; Tue, 14 Oct 2025 20:20:45 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4cmQZd58Klzm0yVk;
	Tue, 14 Oct 2025 20:20:40 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Avri Altman <avri.altman@sandisk.com>,
	Bean Huo <beanhuo@micron.com>
Subject: [PATCH v6 22/28] ufs: core: Do not clear driver-private command data
Date: Tue, 14 Oct 2025 13:16:04 -0700
Message-ID: <20251014201707.3396650-23-bvanassche@acm.org>
X-Mailer: git-send-email 2.51.0.788.g6d19910ace-goog
In-Reply-To: <20251014201707.3396650-1-bvanassche@acm.org>
References: <20251014201707.3396650-1-bvanassche@acm.org>
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
index dd280a85ebb5..a566c1771ffc 100644
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
@@ -9179,6 +9188,7 @@ static const struct scsi_host_template ufshcd_drive=
r_template =3D {
 	.name			=3D UFSHCD,
 	.proc_name		=3D UFSHCD,
 	.map_queues		=3D ufshcd_map_queues,
+	.init_cmd_priv		=3D ufshcd_init_cmd_priv,
 	.queuecommand		=3D ufshcd_queuecommand,
 	.nr_reserved_cmds	=3D UFSHCD_NUM_RESERVED,
 	.mq_poll		=3D ufshcd_poll,
