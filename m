Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A9CF370AEB
	for <linux-scsi@vger.kernel.org>; Fri, 28 Aug 2026 18:19:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787941172; cv=none; b=TqR8XNKy7pZ5LklrGzC3qNW7TNYBp9ru9hUvazc2SZ4MmS973B3I8SA0n0ZJcS1bV5k73X6jli7OUhIDwvLceRODvt+fOvQi121C39tVMDJvegEdSOYcU93wi/KJxkpIph67htX++3AO+KxGiCHw1zH9f3UDLnW2vkHSjUrk1ZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787941172; c=relaxed/simple;
	bh=bUHu0nE8Itd/gyYfZBWIZQRB2LcfKsvw6lqRv5NRrBE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=hU4KpwFFOF6g8sVTlbKozpbaVbGQtZ3q6bpeBsyfmkCbmr5U7T89qzhRP+qNPh5wQhTavSuhqjWTEUGt/q02jTNecziwlpzU/kCnd8bRvOQOU900v/WdTp4wGP41hJhPSlJK9/oxsjPkXDY2pcd83AqTLKS+g60UIL9XPj+Po6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=xeZkV+9u; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="xeZkV+9u"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4hWmr23Vr1zlfvq6;
	Fri, 28 Aug 2026 18:19:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:x-mailer:message-id:date
	:date:subject:subject:from:from:received:received; s=mr01; t=
	1787941166; x=1790533167; bh=KBnsO4kDz2w7wryNiVyF0WurWVA7/KEMWKe
	cS2jNkqs=; b=xeZkV+9uYoRUJBUzpaA9xeUYqiPFPlQbIfse+6kIEcweizYMJW9
	iXFaqY/dN6shlluK5038OI7Fu5/J7Gl+Lo8UFxK8uKCuQH7UTSbeqmju6Minpdbn
	LnqBzxLuqAL2Nhsd+S7Jfhpbp01BZg44Xk02MzVADkm3y4boRcaV1b2mPqtVeee1
	sIxrS7iawM83d6CRZqEwF/XqdBtTacrYDWxjHPwrqHI7Pk89sEqWpFIfFnOtCnfc
	nmjB9G83r7nT/Vv3seheIjPuuINYB0Nhe/JR9CaYI+uzF1RMhOSwBVM2sJ31w9QX
	HcEllIEhwXZtP54B1wJI1FYb3xs+OQfSq0g==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id PjUjpNbhRAVI; Fri, 28 Aug 2026 18:19:26 +0000 (UTC)
Received: from bvanassche.c.googlers.com.com (148.60.168.34.bc.googleusercontent.com [34.168.60.148])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4hWmqv6ngbzlfvpq;
	Fri, 28 Aug 2026 18:19:23 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Kashyap Desai <kashyap.desai@broadcom.com>,
	Sumit Saxena <sumit.saxena@broadcom.com>,
	Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
	Chandrakanth patil <chandrakanth.patil@broadcom.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH] scsi: megaraid_sas: Protect megasas_get_ctrl_info() in megasas_resume()
Date: Fri, 28 Aug 2026 11:19:14 -0700
Message-ID: <6e802da5e402b1d304ab753da77d27f118d0f61b.1787941140.git.bvanassche@acm.org>
X-Mailer: git-send-email 2.55.0.897.gb25b4bd76c-goog
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Protect the megasas_get_ctrl_info() call in megasas_resume() with
instance->reset_mutex using scoped_guard().

megasas_get_ctrl_info() submits a DCMD command and modifies shared
controller information (instance->ctrl_info_buf). Calling it without
holding reset_mutex can race with adapter reset and other DCMD
operations.

Fixes: c3b10a55abc9 ("scsi: megaraid_sas: Update controller info during r=
esume")
Cc: Kashyap Desai <kashyap.desai@broadcom.com>
Cc: Sumit Saxena <sumit.saxena@broadcom.com>
Cc: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Cc: Chandrakanth patil <chandrakanth.patil@broadcom.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/megaraid/megaraid_sas_base.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/meg=
araid/megaraid_sas_base.c
index f0152b043e18..f345fb266db0 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -7875,8 +7875,9 @@ megasas_resume(struct device *dev)
 			goto fail_init_mfi;
 	}
=20
-	if (megasas_get_ctrl_info(instance) !=3D DCMD_SUCCESS)
-		goto fail_init_mfi;
+	scoped_guard(mutex, &instance->reset_mutex)
+		if (megasas_get_ctrl_info(instance) !=3D DCMD_SUCCESS)
+			goto fail_init_mfi;
=20
 	tasklet_init(&instance->isr_tasklet, instance->instancet->tasklet,
 		     (unsigned long)instance);
