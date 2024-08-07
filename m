Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 525FD4204F
	for <linux-scsi@vger.kernel.org>; Wed,  7 Aug 2024 20:32:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723062763; cv=none; b=FycaO0ad4fxhQNUusTicHi5uW15JfAqnFSsnx0Zal5NEqTJs/ItOq5JnxOXz00/+adjGlTDD3bhaTP3TCySjdNrSyU6jZKOkreghhv38dGJcki87Y4prunTo9jzCdG2iCFJHI4mlUv6EijxeNvWfy77S7Qr1LllkQMARSpVqULw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723062763; c=relaxed/simple;
	bh=3A8P1YpJlurPG4fkhcmtpUiRs25q9sYHK/Fcaa+mmO0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AkyedBYmKwoLve4WlTIlu3NmAm1ThF42qw02hpHPiTsfVwe3fm/T/2S9kiR7J5PHGiCNzRV55CPUxBgYrjNobh2VcwnT/o8pxDHrgIjuhag893F5l5JqUasUdUE8Xn5Zyum4DHTFdZrbbOaVxBXYs2+5kZeJdknP6d4OBrDWfYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=48bu40UU; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="48bu40UU"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4WfMLK4y3mzlgVnF;
	Wed,  7 Aug 2024 20:32:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1723062759; x=1725654760; bh=aexlB
	JaKGcGKhi47kA/pnougfssIwQfAs8/aDkITw3E=; b=48bu40UU8dtJ98MvyefGW
	YrXe2Kh+3HQH8VYL0BrPToLvJ85JsfYXATaWZ9/53STSejZEmhWihon8/8aQFZ7t
	a4I2WaVOa9iPB6oV13gZpTEOc5Pk1osdsxi0WyKdZncNv/cgejT3+LO+SF4HWMfq
	v+hP6ULGekVJPZwRgc2oBbFS5izlYgCSys6fdWaNH/EJ/DNcLZZiL85DmHOhQl/k
	eI7kOUoc18r973bnwVm0tgIxxd4VCjCAmr8svNMfPXLyDiSZe3dIOSIWVmEUcS1l
	p+oPjW9Zyz8zsAyQ8dnYMtCNf0+Ls9neN6JUHKWp+Fb9VeqhhhuJ6+FJs3qH4BQr
	A==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 6w5GPnuWE4VT; Wed,  7 Aug 2024 20:32:39 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4WfMLH076WzlgTGW;
	Wed,  7 Aug 2024 20:32:38 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	Mike Christie <michael.christie@oracle.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH 2/2] sd: Retry START STOP UNIT commands in case of a unit attention
Date: Wed,  7 Aug 2024 13:32:14 -0700
Message-ID: <20240807203215.2439244-3-bvanassche@acm.org>
X-Mailer: git-send-email 2.46.0.rc2.264.g509ed76dc8-goog
In-Reply-To: <20240807203215.2439244-1-bvanassche@acm.org>
References: <20240807203215.2439244-1-bvanassche@acm.org>
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
reports a unit attention.

Cc: Damien Le Moal <dlemoal@kernel.org>
Cc: Mike Christie <michael.christie@oracle.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/sd.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 718eb91ba9a5..1b6996b48c8b 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -4093,6 +4093,7 @@ static int sd_start_stop_device(struct scsi_disk *s=
dkp, int start)
 	const struct scsi_exec_args exec_args =3D {
 		.sshdr =3D &sshdr,
 		.req_flags =3D BLK_MQ_REQ_PM,
+		.scmd_flags =3D SCMD_RETRY_PASST_ON_UA,
 	};
 	struct scsi_device *sdp =3D sdkp->device;
 	int res;
