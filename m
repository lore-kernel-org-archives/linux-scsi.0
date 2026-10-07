Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06C053C1D5B
	for <linux-scsi@vger.kernel.org>; Wed,  7 Oct 2026 05:08:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791349688; cv=none; b=MHv2plpFOHE/DdAH1djfY/lA9Vg9nkXfPWU3CBU06S8iCK8f6xePk2d/GC/jhNS0WYQXZyA6glOPwsALjKJs4fz7UdAO1lJB1Q3gEhtWn475hGRALCXCJD4Q2X80L2V46eywMocPhknRnuLnqWbsqen4IEaWojb09wfUcu5Xf+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791349688; c=relaxed/simple;
	bh=dM4sRFEqNCR9x1u7fWc02bYsKonZD3wyAUnia+USyyI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GYmZv/iPl/q0yc1G4N6LqQ0faNbQQgq4gXH5pJ9JTxm8V9BfPV79TYcyrtPV23HJNovIDwC6exjQRd4dWmQBgd+6wshfxmr3QsqLr2al+m13qLk657Cia77f5bQLz4s8zdkTMzmT1n80kNTWjGYB0+h6F5YmGpGyCRFZQmHUbro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=KTCYSWkN; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="KTCYSWkN"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4j01NQ3npDzlfl5T;
	Wed,  7 Oct 2026 05:08:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1791349683; x=1793941684; bh=dM4sR
	FEqNCR9x1u7fWc02bYsKonZD3wyAUnia+USyyI=; b=KTCYSWkNT6c8L/8af4L5F
	0OHjvuEnE8lq+4UZhWCk1cKxMkYhRX+NxxL9lmT9J9KeQ4OWrjpUPloW9XY+4MLK
	CeRgqNxE3GBpBA+DflZjXrRFMGy7tI7iTjzz9y2x5zRGPhWOpeofrJRPfIz4Na8w
	cQkj1nMzCHxVYx+pPJqK7Zu6JBXh/84VAbFeoUUExTnAP3bR35GRAhyF9EVKOw26
	QQln4mIl6kAizKlX+gsXTICQWOL2FytdH7EXFQyQfJM5pxeckDq8W5Q/SNcDGVNY
	6Lv3iyXuVmovF3TuNgeVJePjEb9PnfLoIFwNIOREM9Gh3Jv3setWGdEy0t989GOY
	g==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 9DagICWh2ogd; Wed,  7 Oct 2026 05:08:03 +0000 (UTC)
Received: from bvanassche.c.googlers.com.com (245.199.118.34.bc.googleusercontent.com [34.118.199.245])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4j01NK5wXlzlfdfD;
	Wed,  7 Oct 2026 05:08:01 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	John Garry <john.g.garry@oracle.com>,
	Christoph Hellwig <hch@lst.de>,
	Bart Van Assche <bvanassche@acm.org>,
	John Garry <john.garry@linux.dev>
Subject: [PATCH v4 8/8] scsi: core: Enable lock context analysis for the scsi_debug driver
Date: Tue,  6 Oct 2026 22:07:30 -0700
Message-ID: <f4a83120e21a5e7dee7605ae39e470427e2492d2.1791349129.git.bvanassche@acm.org>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
In-Reply-To: <cover.1791349129.git.bvanassche@acm.org>
References: <cover.1791349129.git.bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Enable lock context analysis now that all lock context analysis warnings
have been fixed.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: John Garry <john.garry@linux.dev>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/Makefile b/drivers/scsi/Makefile
index 533623382eca..32d816e942d6 100644
--- a/drivers/scsi/Makefile
+++ b/drivers/scsi/Makefile
@@ -18,6 +18,7 @@ CONTEXT_ANALYSIS_constants.o :=3D y
 CONTEXT_ANALYSIS_hosts.o :=3D y
 CONTEXT_ANALYSIS_scsi.o :=3D y
 CONTEXT_ANALYSIS_scsi_common.o :=3D y
+CONTEXT_ANALYSIS_scsi_debug.o :=3D y
 CONTEXT_ANALYSIS_scsi_devinfo.o :=3D y
 CONTEXT_ANALYSIS_scsi_dh.o :=3D y
 CONTEXT_ANALYSIS_scsi_error.o :=3D y
