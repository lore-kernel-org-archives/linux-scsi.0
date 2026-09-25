Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAE662D63E5
	for <linux-scsi@vger.kernel.org>; Fri, 25 Sep 2026 18:32:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790361148; cv=none; b=dttw571kt0DQuuYtIevVT0IBPNRji7Ec1PXn6TS23k0YcOHWWpKxDpneaTyQdLga4J5TmKf7sUwWgLpTZK/2hUY8wLAZGz7QiHNkohiB4HGAtj0gXoN2DKrwTQzXSurz9Kcc+WJqAJDHUWjXKVCmPPFDdUuhEKW4SjT5ME+YK3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790361148; c=relaxed/simple;
	bh=Js2hHP5yjftrVDnXotiRryJGKmhiMAyy4S7KEls5pvg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YO3z4KHcwS02izc6opTsaLN6dy/iZqFC/8bfc8VDZrOpG6XhIuBb8hYMsrUnejvo4Q1j1cuHCBbzt5rYRvb9iQlYCc5nRCDYeXk1ZfV7tbJP0hQXBRhYs59aRRML/gA6H0MPCi24vjabCM8rlAljApPhw5AOEOBTp9rcL/Mk7r8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=exzM2ddN; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="exzM2ddN"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4hrzp14ZHRz1XM4Sx;
	Fri, 25 Sep 2026 18:32:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1790361140; x=1792953141; bh=AN4sN
	jZ3SZFM0Iubrh4KE8ooAJscwAkC2AOQFYh6LR8=; b=exzM2ddNUw9lRx7Obv0yi
	k/5wZ81+SrP4MBGGruJ6ZCKLvOHFfU/XBdygk49oJTqzVkOKpvCmLO4lj/yXPdLw
	vSGRvwP4bpjUlLp369BruseB3trAAzOS4pANACgZ+GQHL6zvBETwXXSltWNyCPG0
	tHOttEHG/Ne/UvNV/cgJd6zs4JGpbhDOvZOUqtFprgT7xUtJMWnIZ3dLgdrxrO/Z
	MLe8y6j9DKJdHIHfonqh8quJB9VLYD9uLwKS57gpW4WijVs6xZD4rn8YSwdZn6nz
	F6DHWOxdvCO+rMyxMRoujVAmlm6DSqDkm6spTnAeuO6zoWit2Cf0tlQfM17hPJtY
	A==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id jwumMMpU3LoF; Fri, 25 Sep 2026 18:32:20 +0000 (UTC)
Received: from bvanassche.c.googlers.com.com (148.60.168.34.bc.googleusercontent.com [34.168.60.148])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4hrzns51hdz1XM5kW;
	Fri, 25 Sep 2026 18:32:17 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Sathya Prakash <sathya.prakash@broadcom.com>,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
	Ranjan Kumar <ranjan.kumar@broadcom.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Subject: [PATCH v4 40/54] scsi: mpt3sas: Enable lock context analysis
Date: Fri, 25 Sep 2026 11:26:18 -0700
Message-ID: <91450f15b421be527cb9831e3f9a762d7f56536f.1790360262.git.bvanassche@acm.org>
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

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/mpt3sas/Makefile | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/mpt3sas/Makefile b/drivers/scsi/mpt3sas/Makefil=
e
index 18e2d87eb4a2..c698a106f3e3 100644
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
