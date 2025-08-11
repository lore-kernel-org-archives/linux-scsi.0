Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8E7F2D47F3
	for <linux-scsi@vger.kernel.org>; Mon, 11 Aug 2025 17:41:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754934078; cv=none; b=LvBAfAk0zBgnv6oRDwzg9xySst3lzqD6tpreLhqnqxiiMrSX0nh86+UUjejmd2Mrv0qNKDoZs/+xZcVLnIGdsODbrRky3ieM30dOyRguSD5K4PX0opU+1FIElOe2NzWeqZhMMoj9U6qZbwX7VBGx2Fe0UWFkVxCb1EX4jWHgRdk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754934078; c=relaxed/simple;
	bh=iQb7R+2750taZbFWeNTQoy8+6b+zIwtopvXaI9lLBp4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lPT9IJdNxnw5MTmubPlcDur5ZLVr5V17yM4/8BCN0sxJkub/4ecFSI7y3YR2lI90Ld+aWRHGicbkoKyKpi9cu+57hP7h5iEDUZWAfJCJye3TKYMWtd8nF9M3xcklj+txNGzFAJhg6killLESbP44K/ENO9h4yxMmyCh3ax8dpJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=nmsGnY/Z; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="nmsGnY/Z"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4c124D0z95zlgqTr;
	Mon, 11 Aug 2025 17:41:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1754934074; x=1757526075; bh=VwbL5
	9LgsAMfvvJEWcXFT/aA02au03P+rQ1CZ2B1L6Q=; b=nmsGnY/ZWw+NZUGPle0tc
	jh+0TjZ8yttr3MjOIinSYQJI4rKL/VdMNsbOLDOR/xymAmgo0kE8aiUzomcHNCGy
	vzkouFfwW+MKwCgUcBFwTpQX6SDFwxUQXcd32VKrI+Ej2FEGTRpIKuZz2J6pD/Fm
	hAix1CzSkVg6a4cj4WRVoU5iRE4IGdVrq6zkK/N98HWaGvTNYpbzJHreg7fuCedQ
	0CmlqKwaWN7T6nyupcT+oo2O/NjDxMYa74/YNyiTK707YTGnZ1aJ52ZhsscO22Mg
	wmJZMxmsJGFhHmntk51DT4BeJmIsk2EvSa78x3f1KeJg5P/FPmK8k/GlUCimSEzO
	A==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id QfblOq-2rKzk; Mon, 11 Aug 2025 17:41:14 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4c12454fRxzlgqTq;
	Mon, 11 Aug 2025 17:41:08 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Avri Altman <avri.altman@sandisk.com>,
	Bean Huo <beanhuo@micron.com>
Subject: [PATCH v2 25/30] ufs: core: Do not clear driver-private command data
Date: Mon, 11 Aug 2025 10:34:37 -0700
Message-ID: <20250811173634.514041-26-bvanassche@acm.org>
X-Mailer: git-send-email 2.51.0.rc0.155.g4a0f42376b-goog
In-Reply-To: <20250811173634.514041-1-bvanassche@acm.org>
References: <20250811173634.514041-1-bvanassche@acm.org>
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
index 8014b6ec0e42..b887041aafcd 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -2986,6 +2986,15 @@ static void ufshcd_map_queues(struct Scsi_Host *sh=
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
@@ -9181,6 +9190,7 @@ static const struct scsi_host_template ufshcd_drive=
r_template =3D {
 	.name			=3D UFSHCD,
 	.proc_name		=3D UFSHCD,
 	.map_queues		=3D ufshcd_map_queues,
+	.init_cmd_priv		=3D ufshcd_init_cmd_priv,
 	.queuecommand		=3D ufshcd_queuecommand,
 	.mq_poll		=3D ufshcd_poll,
 	.sdev_init		=3D ufshcd_sdev_init,
