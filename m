Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE0CE47A0CB
	for <linux-scsi@vger.kernel.org>; Thu, 30 Apr 2026 18:24:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777573472; cv=none; b=KAmnka0WriuK5wB16mBh+fDsBJcJq8gZF3QTBgeAiIW1FjT0mymiRu03kKf1qhpDanMhIYn0GCBZ8+o1m6GcCsy7X6Nb8NnQNNtRFprll40EMhRAGWQg1J0kKckx6thZ2TJQdnGEljWvi4straF4WSn88nb10Hj76TjXmudpLlc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777573472; c=relaxed/simple;
	bh=HJXiUOkdQ9kMnH5DZgevRHU07bWtuzUH67337nbEBYc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DXtzcOxeT/9/a9B6TZlZTXANgJaw5kycQTsOeZ7IWCOktVqLIYmLOGWVgrJGPrZwTmV1PNQkwT1BIlAfAdEO3w0/c3kDFQamP9qgvRVoip8QtIA9tOgMOi5IHe6L7+0+fj0gaRbL2AWjaUSzXxuBxBRBVDmd1GRT5ukx+mLd8EE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=QZ2F8cmb; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="QZ2F8cmb"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4g62dB418Tzlfl89;
	Thu, 30 Apr 2026 18:24:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1777573466; x=1780165467; bh=ZQ37Z
	OYKscgPlVPKWJotbgx1Eq+4p3gngLj4/iTUK20=; b=QZ2F8cmbz2/NIL6O9z+H2
	IgqrF8cayM6Q7ONk1y5dHqWY3IBXuaxqclG+7mYRN8p1PqUH81eIrB8RCFqPkiy0
	VxX7cIv1ttwf6FvzbLixsZ/q2Q690QyucKSDkBTvJiAjLqhTpN+SHbt422RZVYmO
	EY8XSWB2fSidwqoXf11duutonb38jbfg8IS+57/hmrvHL7DrZh6LpvL5ldWgAfo3
	XmaiDuiMTWrHpEJzn7bcCnrYr+NwMbXpAHg66CpQXHQX485lw0cbpmFXFvREWiK4
	yM/wI/5VO0ReQSl2PVvVofD/7V96f7TpRBYAgRXH3bJzQmr5KJnnaDZhlS5lyN1o
	w==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id qkwSlzJ3IrTA; Thu, 30 Apr 2026 18:24:26 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4g62d41hVtzlfdfc;
	Thu, 30 Apr 2026 18:24:23 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Marco Elver <elver@google.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Sathya Prakash <sathya.prakash@broadcom.com>,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
	Ranjan Kumar <ranjan.kumar@broadcom.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v2 41/56] scsi: mpt3sas: Enable lock context analysis
Date: Thu, 30 Apr 2026 11:20:11 -0700
Message-ID: <20260430182130.1978347-42-bvanassche@acm.org>
X-Mailer: git-send-email 2.54.0.545.g6539524ca2-goog
In-Reply-To: <20260430182130.1978347-1-bvanassche@acm.org>
References: <20260430182130.1978347-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/mpt3sas/Makefile | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/mpt3sas/Makefile b/drivers/scsi/mpt3sas/Makefil=
e
index e76d994dbed3..5653baeae26c 100644
--- a/drivers/scsi/mpt3sas/Makefile
+++ b/drivers/scsi/mpt3sas/Makefile
@@ -1,5 +1,8 @@
 # SPDX-License-Identifier: GPL-2.0
 # mpt3sas makefile
+
+CONTEXT_ANALYSIS :=3D y
+
 obj-$(CONFIG_SCSI_MPT3SAS) +=3D mpt3sas.o
 mpt3sas-y +=3D  mpt3sas_base.o     \
 		mpt3sas_config.o \
