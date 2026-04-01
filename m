Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C2F730C62D
	for <linux-scsi@vger.kernel.org>; Wed,  1 Apr 2026 20:25:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775075131; cv=none; b=Gi/GrIu3s4/XX8wr9vLMy5a29+gsVIhFzlWmz2H7VUq5LU3mPt3/TqzaZd475Vaaf3utbNW1EmieJqOLANmUIR8QoFtUpE+tL00jccENiXVe4oFR3oovbdGsQ1HBROOKn5cDa/jCG1NJJXvZM9IBfs6oDuH3tVzOSta/MRmYdGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775075131; c=relaxed/simple;
	bh=ataI7wDo6bSbWca2NF+sD1As2u1mzdbkwPJSOTHgovM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FtodiFDRkVB25xrtcN+H0Dd3u6y172XdF79qRVAwopgMeDMSpnZtlmO0NoZpNF+cw3JzMgmrEsNLS0iktw8fdGaBeFbgnMbEE/Lk8jtX7UhSRt+nKicmx/DAB7QDCsJ0P8eHJ4V5YjdlO3cDGgYclnj1gdIiJjqm6Roe1zqnifs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=tPqkGofw; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="tPqkGofw"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4fmGh96qvLz1XM6JH;
	Wed,  1 Apr 2026 20:25:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1775075127; x=1777667128; bh=uCiKI
	Q5deaPkurwdRaLFng4dSedPz6I71GPkUaES9m4=; b=tPqkGofwzDJt5JmtxbBVj
	8E463nWaDsXbxrLiNwzyh8JD9sU/GJDtaCW3kLJ2Z9/Yk6m9yuo3dRPTdcJ3b7Rb
	cn52+REwPbllKmvYz8d08z4/Rk6c+dFkoBSqHmIP43aUSwOIWmrelwkkrFjjHhiS
	4Q+DTuVSaT4v1P10y1+X0uzv7I2QoUg2/Wfz8ugza36Xu2W5ZOtNDTd2xOt0hJTt
	01mGhfUnbCE47V1HTv6SHpMcANFs0nZ+3G4muUK60mTlluq2qKSRAfOUM+BFKktL
	jPDHIFVSYsf5qKT9Wuq4OUSDTQiOhh1Nzl73u7/utHCNqnVufXx1M3dPK9kDTh6G
	g==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id Ppdcri8Xfa1u; Wed,  1 Apr 2026 20:25:27 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4fmGh64cGBz1XM31H;
	Wed,  1 Apr 2026 20:25:26 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH 3/3] ufs: core: Make the header files self-contained
Date: Wed,  1 Apr 2026 13:25:01 -0700
Message-ID: <20260401202506.1445324-4-bvanassche@acm.org>
X-Mailer: git-send-email 2.53.0.1185.g05d4b7b318-goog
In-Reply-To: <20260401202506.1445324-1-bvanassche@acm.org>
References: <20260401202506.1445324-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Add the include directives and forward declarations that are missing
from the UFS core header files. This prevents compilation failures if
include directives are reordered.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufs-debugfs.h         | 3 +++
 drivers/ufs/core/ufs-fault-injection.h | 2 ++
 2 files changed, 5 insertions(+)

diff --git a/drivers/ufs/core/ufs-debugfs.h b/drivers/ufs/core/ufs-debugf=
s.h
index 97548a3f90eb..e5bba9671862 100644
--- a/drivers/ufs/core/ufs-debugfs.h
+++ b/drivers/ufs/core/ufs-debugfs.h
@@ -5,6 +5,9 @@
 #ifndef __UFS_DEBUGFS_H__
 #define __UFS_DEBUGFS_H__
=20
+#include <linux/init.h>
+#include <linux/types.h>
+
 struct ufs_hba;
=20
 #ifdef CONFIG_DEBUG_FS
diff --git a/drivers/ufs/core/ufs-fault-injection.h b/drivers/ufs/core/uf=
s-fault-injection.h
index 996a35769781..d0c870e19f0e 100644
--- a/drivers/ufs/core/ufs-fault-injection.h
+++ b/drivers/ufs/core/ufs-fault-injection.h
@@ -6,6 +6,8 @@
 #include <linux/kconfig.h>
 #include <linux/types.h>
=20
+struct ufs_hba;
+
 #ifdef CONFIG_SCSI_UFS_FAULT_INJECTION
 void ufs_fault_inject_hba_init(struct ufs_hba *hba);
 bool ufs_trigger_eh(struct ufs_hba *hba);
