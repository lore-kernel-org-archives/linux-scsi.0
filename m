Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DC64435EF2
	for <linux-scsi@vger.kernel.org>; Fri, 14 Aug 2026 16:20:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786724427; cv=none; b=lqBdfLytIyAZq9umUDW3wL4dNNhAhNl6f4+P3tq2S2hTCUhtB8fV3HPxnlRVghvOo2Uj46DtFjNK9HxB7hlDN7MDOJq57xpttfdxDBNfeRE0p90TZK7R651cJLuJR+leGK1iEJW54hCtx8ayHfZg0GMxMMMJkLEqHuMI6y8d/DQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786724427; c=relaxed/simple;
	bh=uAwj3CCtQN1w2Mx62tmWvaJJpxt5dhCqVP++1vPTUlo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Hl5aZTz2xuXW5KWdQesq4Uibvsvg1rIWBeL/DMuwvXsigDwB4hzfGItmD65NS4v7rVOoVf2Gryo1oXP3URjPpt37FIGAeauiL4Mexwgc+2OfPmQOJIQFVw4jbQhRTeM5FFYw9QLSd/Kn6ka91Ls9p4uKtxGeLTkZOMo1hiOmV78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=VjMNTnu+; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="VjMNTnu+"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4hM6s23lg5zlfvq4;
	Fri, 14 Aug 2026 16:20:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:x-mailer:message-id:date
	:date:subject:subject:from:from:received:received; s=mr01; t=
	1786724419; x=1789316420; bh=uAwj3CCtQN1w2Mx62tmWvaJJpxt5dhCqVP+
	+1vPTUlo=; b=VjMNTnu+ReCGAkqOqCkziK7MSRHXRcduCE3IZjYHfZwD6GS5iX9
	wnbv1W1g0fGkYYHH5A1XJUyRD73frH7nJLl/8SRXy2qlMbFRSGkZi5PPAh+SVUQp
	8EshkR3qGu3lepGdeQIiHuNi9HRrdRFJV2nkH89Jh4hR8EkI885mPEh39qeA+7AP
	apVA6WK9W0J/NFW3WYosQdzMIoFqk0O6Xwfa+k+WvzkMSVjISUh/9S1l/Vk9S2tk
	3oW1N+fI+KGk5T/b8Qza9pJv7SjuCMbxZ8K14yHtaYe/6a9T0dYTi4KuFhuElLwI
	Qxdg1IwcvY0BjvOc1cYjZBeB+3ADxTaM5fA==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id H3a63DWbz12M; Fri, 14 Aug 2026 16:20:19 +0000 (UTC)
Received: from bvanassche.c.googlers.com.com (245.199.118.34.bc.googleusercontent.com [34.118.199.245])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4hM6rx4CKpzlfvpG;
	Fri, 14 Aug 2026 16:20:17 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	John Garry <john.g.garry@oracle.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>
Subject: [PATCH] scsi: core: Enable context analysis for hosts.o
Date: Fri, 14 Aug 2026 16:20:08 +0000
Message-ID: <3e1c3c0ca9307e2581cf4b96cf3fcdae35202255.1786724393.git.bvanassche@acm.org>
X-Mailer: git-send-email 2.55.0.691.gc56d675ccc-goog
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Enable compiler-based context analysis for drivers/scsi/hosts.c by settin=
g
CONTEXT_ANALYSIS_hosts.o :=3D y in drivers/scsi/Makefile.

The SCSI host management code in hosts.c now has the necessary lock conte=
xt
annotations (such as __must_hold(shost->host_lock) on scsi_host_set_state=
)
and conforms to compile-time lock checking rules. It builds cleanly witho=
ut
triggering any context analysis warnings.

Enable context analysis for hosts.o so that lock correctness and context
safety invariants for SCSI host operations are verified at compile time
when CONFIG_WARN_CONTEXT_ANALYSIS is enabled.

Fixes: fb0fc67db962 ("scsi: core: Enable context analysis")
Reported-by: John Garry <john.g.garry@oracle.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/Makefile b/drivers/scsi/Makefile
index 72eb395ccf1d..533623382eca 100644
--- a/drivers/scsi/Makefile
+++ b/drivers/scsi/Makefile
@@ -15,6 +15,7 @@
 # *!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!*!
=20
 CONTEXT_ANALYSIS_constants.o :=3D y
+CONTEXT_ANALYSIS_hosts.o :=3D y
 CONTEXT_ANALYSIS_scsi.o :=3D y
 CONTEXT_ANALYSIS_scsi_common.o :=3D y
 CONTEXT_ANALYSIS_scsi_devinfo.o :=3D y
