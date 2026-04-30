Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C6F339D6DE
	for <linux-scsi@vger.kernel.org>; Thu, 30 Apr 2026 18:22:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777573340; cv=none; b=nbprMQ9mHqR0G5Llcq+YXz0loJjkGehdUxS0S3Nb6iq/oNMGnGZ/OIB47a2nZnYvYIQDpS6H4PDjDzwmFSvAJ6cwxK/DRVtKBpo0cTJNp8dldMBX6zYkcsd2NumZmd2rgr1HqP7Y6USCd+EYPoDaDTsYobHvgAEzHqYUwlqZTTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777573340; c=relaxed/simple;
	bh=1t7VfrksXycQIc1lfpcGAV/Z0pP08w0kwOQGHr2yS0k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QJ0DbsNRJc4lJ2AtPUrkBPLAcw/u/DtTDw4TJJzT1Y+ScToCm2HUYO/5xYzX0CG84Ax+FLdTs4sUY/B6RYOM2B5KOzr6bEIfILG3kvKoWpOJffK6PdYr9L/xdwVpu2r05eWT0AMle1xce91SvlW3QSnnLwNBwQwJ2PGclSQFX7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=YLP4BGkX; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="YLP4BGkX"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4g62Zg18m2zlfdfN;
	Thu, 30 Apr 2026 18:22:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1777573335; x=1780165336; bh=I+jb6
	UK56S2qUsrCX9zO3qKaalkMPRc/xo5wK1/2gio=; b=YLP4BGkXLMhg1aQC961+c
	c4IRRkG/a06tBs98Nc3nCJVJcI+ve1NrlNs053nYKk3dcs+F1G9vTDnE76LvuZpT
	1HECtyExn5XH0pDkWxbLhV9//LfoaLMKP4VxeKI4M6V7gcDPMjkwOJ2DkVIfs222
	rxGDmy7mm5kLfNQap837kCTEeMLmUiJZmf8Jv4oomfdrIBZTCw+xmNqmu7++1ATp
	qSzlyRI2/FXSQIriiK3mz5lJSE9LJKlHX8/D6SscBBMfWohyCNYelIh6CNLGQ/eQ
	Wg5hfyG587E+u9cAkyR+JlRXYEHTeHpK/UFR1hY/xE+QRo+SKpoE5qd9X8wvwfQu
	g==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id dULfj49-sOz1; Thu, 30 Apr 2026 18:22:15 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4g62ZZ17PHzlfftl;
	Thu, 30 Apr 2026 18:22:13 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Marco Elver <elver@google.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Hannes Reinecke <hare@suse.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v2 09/56] scsi: aic7xxx: Enable lock context analysis
Date: Thu, 30 Apr 2026 11:19:39 -0700
Message-ID: <20260430182130.1978347-10-bvanassche@acm.org>
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
 drivers/scsi/aic7xxx/Makefile        | 2 ++
 drivers/scsi/aic7xxx/aicasm/Makefile | 3 +++
 2 files changed, 5 insertions(+)

diff --git a/drivers/scsi/aic7xxx/Makefile b/drivers/scsi/aic7xxx/Makefil=
e
index 853c72a81ae0..2da370d3d904 100644
--- a/drivers/scsi/aic7xxx/Makefile
+++ b/drivers/scsi/aic7xxx/Makefile
@@ -5,6 +5,8 @@
 # $Id: //depot/linux-aic79xx-2.5.0/drivers/scsi/aic7xxx/Makefile#8 $
 #
=20
+CONTEXT_ANALYSIS :=3D y
+
 # Let kbuild descend into aicasm when cleaning
 subdir-				+=3D aicasm
=20
diff --git a/drivers/scsi/aic7xxx/aicasm/Makefile b/drivers/scsi/aic7xxx/=
aicasm/Makefile
index a3f2357a3f08..152ca676d0a2 100644
--- a/drivers/scsi/aic7xxx/aicasm/Makefile
+++ b/drivers/scsi/aic7xxx/aicasm/Makefile
@@ -1,4 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
+
+CONTEXT_ANALYSIS :=3D y
+
 PROG=3D	aicasm
=20
 OUTDIR ?=3D ./
