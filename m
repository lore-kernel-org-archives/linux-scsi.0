Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8403833EAED
	for <linux-scsi@vger.kernel.org>; Fri, 29 Aug 2025 15:39:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756481946; cv=none; b=epDdSotJLoUfXMZ/VpsZNxXbWhcqWgwQk9f7O+0iDfcRP7DQK4HFq/97pXMsxlRP4+9/AbHDukIbOrfps5h/YLJh2a/2HqtKFUE8BnEWXp/0HwloJo5YQzFhblMGFTlqNO+E3jr72kvG6rEYfEgzloAOVsPiLEF87Pgd/2BScYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756481946; c=relaxed/simple;
	bh=a+vLyGG0Fcg6LhbVoTzq/ANJh0o1edwPsXRAuBsQXOg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=qXXOiZWDBGpXZiiu74PX+UrNspw5fXPhxukbOPw0WNQaPeXraCmphqAQ9I8dq96nxVc3rgvz1qDeFb3sVq0fQCoxC7RNT2XxltmPJjxA1dRR+7oy6IgbG092idBGLKdxTkZwrLMYmfdxkr2w1gRzh5dzS70fhxkhJWLin9esFQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=NK6Z0icq; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="NK6Z0icq"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4cD2Vt4C0LzlgqVs;
	Fri, 29 Aug 2025 15:39:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:x-mailer:message-id:date
	:date:subject:subject:from:from:received:received; s=mr01; t=
	1756481940; x=1759073941; bh=zJKn/VuGAlpaZ7GH7uDuo7cPkm4j13guzyf
	MZOkbZLs=; b=NK6Z0icqt0mEaqlS0YhdfmlubziOqbe1WWud6oF9teoH1u2pFoM
	mA6uIsoe5Gn5ReWzL35ghryJOxaDpwwPLhs/5E1TSpz+OQr3gD2B3LgeohmwIsBb
	jpaaaPbqPMcqyqPO8dwAxW945rOGMrgqYLxUoc54ON3sRQGthm/161miIueADkxP
	l20LB/rsAshOCDIQcuo8PcMt4P1feXfkthBfKBuRL9wukL4oqi3DcaMLdb/6O/qr
	OLg/TqG84Mb08Yy8r84B6M9GCCXV3sFZE3MasX8Rk/wkebv2twUs3uBUWye4jZ5F
	Bbo3SKXnw+KC4cNSVXn7ypgZGHR1yVscVWA==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id hQTRlIrLBT4o; Fri, 29 Aug 2025 15:39:00 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4cD2Vl2xxVzlgqVh;
	Fri, 29 Aug 2025 15:38:54 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Avri Altman <avri.altman@wdc.com>,
	"Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
	Huan Tang <tanghuan@vivo.com>
Subject: [PATCH] ufs: core: Move the tracing enumeration types into a new file
Date: Fri, 29 Aug 2025 08:38:16 -0700
Message-ID: <20250829153841.2201700-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.51.0.318.gd7df087d1a-goog
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

The <ufs/ufs.h> header file defines constants and data structures
related to the UFS standard. Move the enumeration types related to
tracing into a new header file because these are not defined in the UFS
standard. An intended side effect of this patch is that the tracing
enumeration types are no longer visible to UFS host drivers.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/ufs/core/ufs_trace.h       |  1 +
 drivers/ufs/core/ufs_trace_types.h | 24 ++++++++++++++++++++++++
 include/ufs/ufs.h                  | 17 -----------------
 3 files changed, 25 insertions(+), 17 deletions(-)
 create mode 100644 drivers/ufs/core/ufs_trace_types.h

diff --git a/drivers/ufs/core/ufs_trace.h b/drivers/ufs/core/ufs_trace.h
index caa32e23ffa5..584c2b5c6ad9 100644
--- a/drivers/ufs/core/ufs_trace.h
+++ b/drivers/ufs/core/ufs_trace.h
@@ -11,6 +11,7 @@
=20
 #include <ufs/ufs.h>
 #include <linux/tracepoint.h>
+#include "ufs_trace_types.h"
=20
 #define str_opcode(opcode)						\
 	__print_symbolic(opcode,					\
diff --git a/drivers/ufs/core/ufs_trace_types.h b/drivers/ufs/core/ufs_tr=
ace_types.h
new file mode 100644
index 000000000000..f2d5ad1d92b9
--- /dev/null
+++ b/drivers/ufs/core/ufs_trace_types.h
@@ -0,0 +1,24 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef _UFS_TRACE_TYPES_H_
+#define _UFS_TRACE_TYPES_H_
+
+enum ufs_trace_str_t {
+	UFS_CMD_SEND,
+	UFS_CMD_COMP,
+	UFS_DEV_COMP,
+	UFS_QUERY_SEND,
+	UFS_QUERY_COMP,
+	UFS_QUERY_ERR,
+	UFS_TM_SEND,
+	UFS_TM_COMP,
+	UFS_TM_ERR
+};
+
+enum ufs_trace_tsf_t {
+	UFS_TSF_CDB,
+	UFS_TSF_OSF,
+	UFS_TSF_TM_INPUT,
+	UFS_TSF_TM_OUTPUT
+};
+
+#endif /* _UFS_TRACE_TYPES_H_ */
diff --git a/include/ufs/ufs.h b/include/ufs/ufs.h
index 72fd385037a6..245a6a829ce9 100644
--- a/include/ufs/ufs.h
+++ b/include/ufs/ufs.h
@@ -653,21 +653,4 @@ struct ufs_dev_info {
 	bool hid_sup;
 };
=20
-/*
- * This enum is used in string mapping in ufs_trace.h.
- */
-enum ufs_trace_str_t {
-	UFS_CMD_SEND, UFS_CMD_COMP, UFS_DEV_COMP,
-	UFS_QUERY_SEND, UFS_QUERY_COMP, UFS_QUERY_ERR,
-	UFS_TM_SEND, UFS_TM_COMP, UFS_TM_ERR
-};
-
-/*
- * Transaction Specific Fields (TSF) type in the UPIU package, this enum=
 is
- * used in ufs_trace.h for UFS command trace.
- */
-enum ufs_trace_tsf_t {
-	UFS_TSF_CDB, UFS_TSF_OSF, UFS_TSF_TM_INPUT, UFS_TSF_TM_OUTPUT
-};
-
 #endif /* End of Header */
