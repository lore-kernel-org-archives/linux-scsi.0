Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C96AE51DDF0
	for <linux-scsi@vger.kernel.org>; Tue, 22 Sep 2026 23:27:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790119660; cv=none; b=Eq+x9vlBfxpBnhlSWsfxqxh53m8Ou/xhO139xOVaGblPivha7qnsSwuu+NHrHitNmHkwpjxDHfHZlq7C1aif077vb8/YWe2t+lTa76HJhGBPch3cuPSXnMw0BAENEjaxbmNVcwDEV1bL1OcwPcRo5MkSfq00HZYdQUBLhKjCljA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790119660; c=relaxed/simple;
	bh=xZL0n4mvR6+C+i+QRz3cZb2iGuXLmGHFKck5FE+Lfhc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q8mdNFFayGjcsoDlcQsAvNhyPLF890H7UOTcqr1Ji8aV+Gu1EF42jWOD/ikQKWyO6B7hutOK8C7lxEK+REZdFlIFpOQUC6VoYbSa30+aw3ls0ZanQRPybV55NZ9056RwWPG6iyFs8sfhYV0Gu1/D+40CQomxY6sZ8U6xY8s6iHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=tONl0l0D; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="tONl0l0D"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4hqGTF6fyCzlfvpN;
	Tue, 22 Sep 2026 23:26:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1790119615; x=1792711616; bh=xZL0n
	4mvR6+C+i+QRz3cZb2iGuXLmGHFKck5FE+Lfhc=; b=tONl0l0Dn5GAzvUrKyAUf
	I1X5k1eSaKAF+Vw+WM9ZMUse5It1Bevih3KxLuPij+h2/2AjcE99Zx+HARrinvyz
	7SD2tLWIUL8DPrD/WN51DBxDdQXoFRZrUjTVnT9wXxW8e89b4PIz5uqRwBbHkJ4m
	brzPI0QmA1lJ4792cb07Bv3BDmLWAhCY+L+IzgwIwUoWfE/BnCAoiq89ZqzwgXfl
	LLyWpvYNmD6lusmupyJqev9ftFll7AwPhFEIQe1mL0rVcWHmSzdMvUtCZHkPjXAQ
	kZl54YTCdyLnfr9EyOkoLgAhRAaPI9loc/JOW8TM3zOh24O89VFDLikRmVA3TdQK
	g==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id c3BAybfHyct4; Tue, 22 Sep 2026 23:26:55 +0000 (UTC)
Received: from bvanassche.c.googlers.com.com (148.60.168.34.bc.googleusercontent.com [34.168.60.148])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4hqGT941xLzlfvpH;
	Tue, 22 Sep 2026 23:26:53 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	John Garry <john.g.garry@oracle.com>,
	Christoph Hellwig <hch@lst.de>,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 7/7] scsi: core: Enable lock context analysis for the scsi_debug driver
Date: Tue, 22 Sep 2026 16:26:27 -0700
Message-ID: <bdc1e3c51dc5583f251d8105ab8eb4075b5d8948.1790119506.git.bvanassche@acm.org>
X-Mailer: git-send-email 2.55.0.1082.g2b9226bbc0-goog
In-Reply-To: <cover.1790119506.git.bvanassche@acm.org>
References: <cover.1790119506.git.bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Enable lock context analysis now that all lock context analysis warnings
have been fixed.

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
