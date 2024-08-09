Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4A1B15A876
	for <linux-scsi@vger.kernel.org>; Fri,  9 Aug 2024 19:31:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723231906; cv=none; b=sLvTBdRpGln2INkTOFtemYUq2H9AFfNaUE0DZv89gjG6W1+pCrDmEm1efU11u6bsBqHMBNbT6H3TdXnyzqJFObOyUXnAAUrlqSaJCWDDwDfS46DVTYuqcB2exvSQyIFsSwTJj3wBML4w9/c9eXxzrgiitH5jfhFH0Kc+FyAmd58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723231906; c=relaxed/simple;
	bh=VF6JHaISikOJQOm5dviStZ8StCNHIRdZoEIPaslCmHk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pzlar1Q2Mregoezpwcdo4MRVu8wciYK0b8E+EYFbloecPDu8qAoSDab0/coPQ2sXy0yZUph9KDzYCPslIGylkHAWLzCMJ2YuRaSP7zto4jne6BHkXhweP7PXqQp2U74+ibPJamG+Y7P8TQ0oWOhbXrNdfVyIMSXKuSMrw6gCO5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=zLb0gE40; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="zLb0gE40"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4WgYv40hQFz6CmQwQ;
	Fri,  9 Aug 2024 19:31:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1723231901; x=1725823902; bh=hN3FJ
	50mm/TM0z4Gt5stbMxpIQIfCIF1xU0v3PhNFm8=; b=zLb0gE40F2yH9Oa6PPD/w
	240ketC+TUkugIBa2P+ram9k12JQyNP7kgXELqUePuRpY+I3RfCUXSBLBOjzOXOa
	D6zgxJYPOiteEc/6HbPhx8zs7Y7FGjqp3hGjrOzHAJ8dqNsK7PedD+nJc/P32qbT
	7Y+GtOHTBkfegQSlNskXxFqCi6zqUffz4qdAu/zhyynMdKi+dhHQYYCBvWRM0d4I
	kb2jz+32jAewPxCo/7lBsBHo8cf85ZurUN+tkXDqnPzVh0uSfd8Net8iGMpVRg9h
	QdqlqNkawgiWIdskesAz9jwaYREIppLrvUKXp/bAi4xmaonwsRnE5mlUgI29SxKC
	g==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id vfX6CDxzuns1; Fri,  9 Aug 2024 19:31:41 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4WgYv06j1lz6ClY8y;
	Fri,  9 Aug 2024 19:31:40 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	Mike Christie <michael.christie@oracle.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v2 2/2] sd: Retry START STOP UNIT commands
Date: Fri,  9 Aug 2024 12:31:14 -0700
Message-ID: <20240809193115.1222737-3-bvanassche@acm.org>
X-Mailer: git-send-email 2.46.0.76.ge559c4bf1a-goog
In-Reply-To: <20240809193115.1222737-1-bvanassche@acm.org>
References: <20240809193115.1222737-1-bvanassche@acm.org>
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

Make the SCSI core retry the START STOP UNIT command if a retryable
error is encountered.

Cc: Damien Le Moal <dlemoal@kernel.org>
Cc: Mike Christie <michael.christie@oracle.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/sd.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 718eb91ba9a5..4cbf3e5740e1 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -4093,6 +4093,7 @@ static int sd_start_stop_device(struct scsi_disk *s=
dkp, int start)
 	const struct scsi_exec_args exec_args =3D {
 		.sshdr =3D &sshdr,
 		.req_flags =3D BLK_MQ_REQ_PM,
+		.scmd_flags =3D SCMD_RETRY_PASSTHROUGH,
 	};
 	struct scsi_device *sdp =3D sdkp->device;
 	int res;
