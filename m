Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2D0E38DD1
	for <linux-scsi@vger.kernel.org>; Wed,  4 Sep 2024 21:03:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725483813; cv=none; b=fTeey1ksvJqgH60xmIUKkCYU0P9ip5tuwic9LuK47y9P/x5+w7SxSiZ+p8B06owpKte0x+/9l2LnzB7M7ss241fWq6Zh4nu8W4uyWVgx0AUn8VhpHXm0AQPNMtYAAUiR6pc5y1Mjk21BojqgNxphd0ioRqoiXW2gbGJC4YYl0sE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725483813; c=relaxed/simple;
	bh=G+Czn/ou5DRHnaV5GRWXscmqP0eSEtcZCNZCbonZpnk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ncSmU0lUvLmSohDSxffL0jRzuvDFu+UwD3K93O1rSpuhhGZaub/TN5/izVoavNhmAa37HOrDTLsDssMqYFlr1NYCBYkS8pK6EUNZ8+7rz/+Dw2AF1CLrM+OeDzEAtnuiIIbaUPMVFlq8ijFpnu7Smd9SwZSEdQogpCkhXmpGRLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=3cZQ9iMz; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="3cZQ9iMz"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4WzZhz2HlHzlgVnF;
	Wed,  4 Sep 2024 21:03:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:x-mailer:message-id:date
	:date:subject:subject:from:from:received:received; s=mr01; t=
	1725483808; x=1728075809; bh=pBs/EmJfOZZXsEHd571BliG2HQfnBNHGeG+
	gKwz7a/4=; b=3cZQ9iMz+JMFHlh+adA7tKkAXZ/mMKxJ8c7m2NugBhO9p3k3ksv
	pUPpselgPo22Y6/8mHBfehUoCNiAG3kWcZcZk4OrtqueiGQVDsrF/Z9OkUtDudH9
	c6dVFgmsHrCnbskEVuXooFdAW+YObvTypsXHj1y3L3xjB0oiHnTtEd3Qvfy1iA1L
	slATC2iDS4gPNkrKqkEE3FonbXZsCGFMLM90vwNmDWlvLYebxltj4v9Mn/B5xFLj
	94vcrMZyOeVGq6G6Yi+gnIqQ4PcmWNPVePwghNfY+c+fgGQCmLsZ0uYCdoeBwOvC
	/9wiv1xdkwKKufQRBc34T/WjqhDk1/EY8xw==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id gd8qvIdcdO7q; Wed,  4 Sep 2024 21:03:28 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4WzZhv1LqszlgTWP;
	Wed,  4 Sep 2024 21:03:26 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	Mike Christie <michael.christie@oracle.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v3] sd: Retry START STOP UNIT commands
Date: Wed,  4 Sep 2024 14:03:04 -0700
Message-ID: <20240904210304.2947789-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.46.0.469.g59c65b2a67-goog
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

During system resume, sd_start_stop_device() submits a START STOP UNIT
command to the SCSI device that is being resumed. That command is not
retried in case of a unit attention and hence may fail. An example:

[16575.983359] sd 0:0:0:3: [sdd] Starting disk
[16575.983693] sd 0:0:0:3: [sdd] Start/Stop Unit failed: Result: hostbyte=
=3D0x00 driverbyte=3DDRIVER_OK
[16575.983712] sd 0:0:0:3: [sdd] Sense Key : 0x6
[16575.983730] sd 0:0:0:3: [sdd] ASC=3D0x29 ASCQ=3D0x0
[16575.983738] sd 0:0:0:3: PM: dpm_run_callback(): scsi_bus_resume+0x0/0x=
a0 returns -5
[16575.983783] sd 0:0:0:3: PM: failed to resume async: error -5

Make the SCSI core retry the START STOP UNIT command if the device
reports that it has been powered on or that it has been reset.

Cc: Damien Le Moal <dlemoal@kernel.org>
Cc: Mike Christie <michael.christie@oracle.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---

Changes compared to v2:
 - Dropped the SCMD_RETRY_PASSTHROUGH flag and use the SCSI failure mecha=
nism
   instead.

Changes compared to v1:
 - Renamed SCMD_RETRY_PASST_ON_UA into SCMD_RETRY_PASSTHROUGH.

drivers/scsi/sd.c | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 9db86943d04c..9f09060ab401 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -4093,9 +4093,38 @@ static int sd_start_stop_device(struct scsi_disk *=
sdkp, int start)
 {
 	unsigned char cmd[6] =3D { START_STOP };	/* START_VALID */
 	struct scsi_sense_hdr sshdr;
+	struct scsi_failure failure_defs[] =3D {
+		{
+			/* Power on, reset, or bus device reset occurred */
+			.sense =3D UNIT_ATTENTION,
+			.asc =3D 0x29,
+			.ascq =3D 0,
+			.result =3D SAM_STAT_CHECK_CONDITION,
+		},
+		{
+			/* Power on occurred */
+			.sense =3D UNIT_ATTENTION,
+			.asc =3D 0x29,
+			.ascq =3D 1,
+			.result =3D SAM_STAT_CHECK_CONDITION,
+		},
+		{
+			/* SCSI bus reset */
+			.sense =3D UNIT_ATTENTION,
+			.asc =3D 0x29,
+			.ascq =3D 2,
+			.result =3D SAM_STAT_CHECK_CONDITION,
+		},
+		{}
+	};
+	struct scsi_failures failures =3D {
+		.total_allowed =3D 3,
+		.failure_definitions =3D failure_defs,
+	};
 	const struct scsi_exec_args exec_args =3D {
 		.sshdr =3D &sshdr,
 		.req_flags =3D BLK_MQ_REQ_PM,
+		.failures =3D &failures,
 	};
 	struct scsi_device *sdp =3D sdkp->device;
 	int res;
