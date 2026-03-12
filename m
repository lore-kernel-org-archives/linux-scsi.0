Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D5A03CA4BE
	for <linux-scsi@vger.kernel.org>; Thu, 12 Mar 2026 21:17:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773350238; cv=none; b=t+6uWCcqnZV5RPkNcM8FhA5GNAJww7eVdBvb75Rbs0TjhmKmFh+BHEfnZKIj/ZANlEiJf2wY6nuXmMboqaQdr4J9w7tlPgBxXBZCPVJ2RQTR4zBiKJ5Th/Xov/N3iCNnkBLrZr/qys97UEMF9eMQvM+CnmC0c7s/LSzxv0RgOG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773350238; c=relaxed/simple;
	bh=RPSqlyVcrDjD3TyHDhbtTp+CYlig+PugFITVpvIhexE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HF9BfmtBzrjSMK3JZ1nVnrl7+rBuCYLWDgOeKkALGQmOMOaLoEIpoRHSGLnCehrllfyyhv5hjRk/PUMJawkonu9cRWFEX6fUhZmB/Q3+/S5BkzW6ygnwnL14KwVdI2P3xvVQ6gPSVIp3b/zzNOBPDRhLVrE6X0M6acG7FILDarg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=VrLOLBlH; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="VrLOLBlH"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4fX0n84Y5czlfl5l;
	Thu, 12 Mar 2026 21:17:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1773350234; x=1775942235; bh=H3cBp
	wEs3DjpsYI96fr8/RXLpTdX3J+hBmOfzTi+6t8=; b=VrLOLBlHba1tqPbhZ7Ta/
	D5Bpekm84jN/KWW1gWidfI/w3YjZzsiVw+wv26utDNtZBuS/9oY7vzccPrxH6f02
	x6P2Mr42HBSqQhq/BRxdzYSZdypdj/G+AXtRUJeFlXVXl/1gSDorD2YHYcJM1F+z
	AEuq8DIoVLM8QwTJSIE3dT2lQ5pS7SkicNqjLsjypSTmWsoIWmD//qJEPhdTqf9F
	7QvO7HsRs7cSPqFWl4Nc7ot9TEQ1hFLaSPItNnY0ymCMDZGHhNlxiMLqTqNAE2aY
	JZCyQI6WutOANPpgZ86zF6Z8ZydIa21UpKEcV5XhTJgOzlXQmww7z3qUhsa3Wpv3
	Q==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id Sq8BoSkWuH41; Thu, 12 Mar 2026 21:17:14 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4fX0n52yCvzlfl8L;
	Thu, 12 Mar 2026 21:17:13 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	=?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH 04/36] scsi: st: Prepare for enabling lock context analysis
Date: Thu, 12 Mar 2026 14:15:15 -0700
Message-ID: <20260312211636.3245119-5-bvanassche@acm.org>
X-Mailer: git-send-email 2.53.0.851.ga537e3e6e9-goog
In-Reply-To: <20260312211636.3245119-1-bvanassche@acm.org>
References: <20260312211636.3245119-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Document what mutex is released by st_common_ioctl().

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/st.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index f1c3c4946637..234482e1b70b 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -3535,6 +3535,7 @@ static int partition_tape(struct scsi_tape *STp, in=
t size)
 static long st_common_ioctl(struct scsi_tape *STp, struct st_modedef *ST=
m,
 			    struct file *file, unsigned int cmd_in,
 			    unsigned long arg)
+	__releases(&STp->lock)
 {
 	int i, retval =3D 0;
=20
