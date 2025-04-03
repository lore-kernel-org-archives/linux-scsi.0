Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9101E1F4C95
	for <linux-scsi@vger.kernel.org>; Thu,  3 Apr 2025 21:23:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743715425; cv=none; b=E0hbZe+YYyvFBl9cu7lRAfDlBM/QBaw5eAm4fnMtrPZjrFcH3mqzEzCcDTytB5vIed80IL5PPL4NThaUF4X5L9HNfj0A8AHwPYyGSpnv6ANhqT89Jq1Yk3sES0UZ81vtkN/QGH+EHHblcp/8oPnq3xbOnn2RrX2b7D5CHpFWRis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743715425; c=relaxed/simple;
	bh=Zt4ImnZ0/NgDgp/TF1MRzoxsUWl50X4KxWkE3dLQbQ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bWjlhpsgrpCQzQDvw/ZNdRkOY15ENFLcthDxotG3e4k2V1ArRozD3/mxEseMKvaCT7DTpop3nB5f9Nmktzp1XcJ1Ba2SCBNqJfQx7mvppVNSrnU85Fjfb35LjYEM13hfcS9e7oGaR4c24hgCFPcPD1eauX36NULl+XDGSqVg1rs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=SDkCrnQt; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="SDkCrnQt"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4ZTF8r4Rgqzm0yTx;
	Thu,  3 Apr 2025 21:23:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1743715419; x=1746307420; bh=Zg05L
	WNN2nN/KCxq+5JKhGHre/KICYlPjC5rPfVJw9c=; b=SDkCrnQtiyBoiF0R1E8po
	Ihot4opFBgNC7Enum59Hg4rUHv+kVyPr0IOiQyY0709vcl3pp+I4693eSFKb1/MQ
	gri9L9x6INCvu4RimU7gzY0WUuGO2gFV7B6yQGqIeMyzt/4fopp/UT16V+9IYeeG
	TJyRQXOtdx64EY2SBKiV2c98p1sqDUXgadZHY83Lg/Xn2s/cwB7qcaeXyyKMIJ5R
	dn2AiKDmwH4sMjcAxtp5CAVI39cQJoDLtN7aSGIXyu4DpwquXCoN6fNa8VZz0beU
	WWcG4orjJqMXuO4+GPsUm3fid9DuJr1jbTcXxA03dx6w7SwlSd/htf9Ex6Jx6Lta
	g==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id VMDrQ2qny4Y7; Thu,  3 Apr 2025 21:23:39 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4ZTF8j4Js0zm0XBp;
	Thu,  3 Apr 2025 21:23:32 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Avri Altman <avri.altman@wdc.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	"Bao D. Nguyen" <quic_nguyenb@quicinc.com>
Subject: [PATCH 22/24] scsi: ufs: core: Do not clear driver-private command data
Date: Thu,  3 Apr 2025 14:18:06 -0700
Message-ID: <20250403211937.2225615-23-bvanassche@acm.org>
X-Mailer: git-send-email 2.49.0.504.g3bcea36a83-goog
In-Reply-To: <20250403211937.2225615-1-bvanassche@acm.org>
References: <20250403211937.2225615-1-bvanassche@acm.org>
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
index 0adc0f879196..615c943ce9f1 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -2960,6 +2960,15 @@ static void ufshcd_map_queues(struct Scsi_Host *sh=
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
@@ -9031,6 +9040,7 @@ static const struct scsi_host_template ufshcd_drive=
r_template =3D {
 	.name			=3D UFSHCD,
 	.proc_name		=3D UFSHCD,
 	.map_queues		=3D ufshcd_map_queues,
+	.init_cmd_priv		=3D ufshcd_init_cmd_priv,
 	.queuecommand		=3D ufshcd_queuecommand,
 	.mq_poll		=3D ufshcd_poll,
 	.sdev_init		=3D ufshcd_sdev_init,
