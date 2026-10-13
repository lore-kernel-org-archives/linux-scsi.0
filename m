Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48E34560AD0
	for <linux-scsi@vger.kernel.org>; Tue, 13 Oct 2026 22:10:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791929433; cv=none; b=g6lZLsS0wvxQHzaU2H+646QRB3wLVtnn7Jp+/eo6Lg56xr7zbeqjs++CHSAhroF6cfkWgwCkOc+MOJcIqrP2cT6ZkozcvYOSdmxc4M6xfla1fXVZAv3B1EzkJzLLwPvfvrJxN1bBo6oB3EEIjj12bLAYcSsJ5WvpcZVYDJSdGts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791929433; c=relaxed/simple;
	bh=dM4sRFEqNCR9x1u7fWc02bYsKonZD3wyAUnia+USyyI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Umj1Tm6YV1loNB3IO+tYl1m5X6dfjRcN6FLw9hLGfFFkQPC0RtRcnLJhvOuaFLa00Dd0ACBHY85Vg7DeDN+vi6n4ONbbY5xVqxO8w+DonN9o1ma2EwahDGwDJI+pWqyj39dnxmzH0vcGExfnNlyc33sjYyi+inf6Pl2myRJl+DQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=BJzto+ES; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="BJzto+ES"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4j47nN0JnhzlfvpT;
	Tue, 13 Oct 2026 22:10:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1791929429; x=1794521430; bh=dM4sR
	FEqNCR9x1u7fWc02bYsKonZD3wyAUnia+USyyI=; b=BJzto+ESvpDlc6aaGDLmI
	yu+XuX1H0YzQ3YAhNvcsOpivKhVG3jzNOJSpgk9LIkkb1Laxo6L/hrsmf+TeWbId
	ZscpjEyHJZVdhZVTwDJQa4buxXzALWS6sMwOgicNiGBKbp7zIDtrUg3urzUNSs7E
	c7UqkSLIC58NzH35rqry05GMWXAN2FqQKx97dJfDkmugSSStqcnTUteaaib8RdeK
	DNkoiUiPpQcKR6WdJLkea6ESjH51GBGKTTWhMAIRqNi6X5if7WnEtndNDn/S0MgV
	qRTLpSDxCFr6SJNf+I+kV3AQNXkpvtve+ytfoMwn5IztfhgfM7rxZ+TDNujyoWPd
	w==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id JQtvM_Txj_GI; Tue, 13 Oct 2026 22:10:29 +0000 (UTC)
Received: from bvanassche.c.googlers.com.com (245.199.118.34.bc.googleusercontent.com [34.118.199.245])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4j47nG43dYzlfvpK;
	Tue, 13 Oct 2026 22:10:26 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	John Garry <john.garry@linux.dev>,
	Christoph Hellwig <hch@lst.de>,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v6 8/8] scsi: core: Enable lock context analysis for the scsi_debug driver
Date: Tue, 13 Oct 2026 15:10:09 -0700
Message-ID: <46613e281866679cff455c3cbab842e48ad2a3d3.1791924924.git.bvanassche@acm.org>
X-Mailer: git-send-email 2.56.0.176.g3575e65682-goog
In-Reply-To: <cover.1791924924.git.bvanassche@acm.org>
References: <cover.1791924924.git.bvanassche@acm.org>
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
