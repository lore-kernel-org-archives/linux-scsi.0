Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 870BD4CCDD4
	for <linux-scsi@vger.kernel.org>; Fri, 25 Sep 2026 18:29:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790360947; cv=none; b=aDTcW84MtsTE2VaPppvPIqzs39ZgHVAAIdFReTgjyK8bll2USW/NzDY2nLq6vAeOibGOt6M2cixStf/Pyfy2izCoEsK4415G/HTYOgt+QzXV/4h6mY4cGWVtfPEMwsKbXdXxHjg32weUGlTQLpBkw7scpJ+RmONop13uFKdmsV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790360947; c=relaxed/simple;
	bh=SsPUINw+kf9VvAahHh6jRmqtsd3gnq36k9EiMnrLqu0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dKdbUckeaKSqUYI5JFEnPjDzUc2vR5X+5D4T+tPjfrxzMzH5mHPqnLZCRVylHWCVmco78UUyclSto0ogS9DK2EPKnSRP3tld2AQCY1iv0aGq9rAZoS942fYPzuK+278nvDK5g4bogH0CGnqrC+4eT0bXY88dlMTJMzhZt7B5FaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=OxLwh0cI; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="OxLwh0cI"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4hrzk96m2zz1XM5kt;
	Fri, 25 Sep 2026 18:29:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1790360942; x=1792952943; bh=ggaEg
	Q2z258biGmki0PdsJIpA15FtUeq9D9Ju3Y9/hk=; b=OxLwh0cITgW3PSbrJCFaX
	/2AsgNnME+zpftdC0BbQ1O+5l7yHAqal0Ft4o1u6qE6dPQi9jvhlnc2xEiS+aH5r
	hTsKwNMLUHgryBTFovVvIoiA44rh1G/BWUnSHBINTsKuTz9IFsAr15LUzE6X4uA6
	kRMEvkaSfYKYsMr6WlqSkgf9J0jZNjfOi75jsc5Rluunc4P+nufnsso+Jlzni/rl
	n9MJYemP5KncQ9mQkx1lEgPd3thCsEUbUKAcqgupJH9GXhoXNO11FCc+qPh38IOE
	ifdH+H6anLsikapzagL5MG4jQI/S4LZcZvkLN+bTYrTozZpEyIWOGFsL+Qxbu5dy
	w==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id b0Z6f2laka67; Fri, 25 Sep 2026 18:29:02 +0000 (UTC)
Received: from bvanassche.c.googlers.com.com (148.60.168.34.bc.googleusercontent.com [34.168.60.148])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4hrzk432n1z1XM5kW;
	Fri, 25 Sep 2026 18:29:00 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Doug Gilbert <dgilbert@interlog.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Subject: [PATCH v4 02/54] scsi: sg: Prepare for enabling lock context analysis
Date: Fri, 25 Sep 2026 11:25:40 -0700
Message-ID: <e522b403882f67edd0c6b2865de71c032aaa6dfa.1790360262.git.bvanassche@acm.org>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
In-Reply-To: <cover.1790360262.git.bvanassche@acm.org>
References: <cover.1790360262.git.bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Annotate open_wait() with __must_hold() since it unlocks and locks a
mutex.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/sg.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 5408f002e6c0..714ae6f0cf18 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -245,6 +245,7 @@ static int sg_allow_access(struct file *filp, unsigne=
d char *cmd)
=20
 static int
 open_wait(Sg_device *sdp, int flags)
+	__must_hold(&sdp->open_rel_lock)
 {
 	int retval =3D 0;
=20
