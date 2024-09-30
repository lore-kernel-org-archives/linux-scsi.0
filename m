Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76E981A256C
	for <linux-scsi@vger.kernel.org>; Mon, 30 Sep 2024 20:14:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727727260; cv=none; b=qNAHeZLSHd0aefpYmj5txIhcCrGpSCCATW794sAXMlD7i52062z5pcz0zacGMf6e0q4Hhl2xj60gPAF0U23MYcUdqyaixCPuiX1xjqWJ0GvRBGtoXhqz1Y1NLvkwAzS3NX+vKxAG+sguCmQ6gvENGN8UguW2jitg8cBJZApiong=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727727260; c=relaxed/simple;
	bh=/lVslN7TI3ihpHlKP/sSCsTKos2geT7/VqkGkDgLM0s=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=csaZMuGMWZWLMaF2yR7Lyx+s86MCc6fADw+p7F0h/Vs3TgxWNJCQQyRw20FgLTXShuTGkdMmOHAYsa5E2D3lGpQA56xqQIEkYN0/i1bsrQEvrEn3N8Ck6e8xTI+7oxcaQGS+h0xH0vdWs6C04sMNJP4XKUHTq4EE+FoMP4rvb9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=nd3PYwVM; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="nd3PYwVM"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4XHXN96ZYtz6ClY9Y;
	Mon, 30 Sep 2024 20:14:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:x-mailer:message-id:date
	:date:subject:subject:from:from:received:received; s=mr01; t=
	1727727255; x=1730319256; bh=/lVslN7TI3ihpHlKP/sSCsTKos2geT7/Vqk
	GkDgLM0s=; b=nd3PYwVMLXT002HBiFCk31I7sCKOv5yB/xIEAb+ipQBDvTOZ2oL
	QzSd1Q0C9OgHsTbX/mo8vCs6//0dSQ6bQp51KjbJ/NobK6RIcxvZgY6IlCh8cSBH
	gRT8hpefRMle74h7TDSoue3M/DKAeOt/3mnOiMPurIzXcTkP/zg+X60zdCvItShE
	DWIObqtXlo56fLPLKxeVVO3nbnaQYSE6Y4GxHn1HR3LsHkoz3oaQLIKcqCJzhYaz
	vZ23rsOJ2yd8AVv7ObbTBenBM3QKLLJRhNX86nPk5IXOqHY9T5hIISWG8iJvEOWS
	btxWLrIeGs63z+BlXEyokUtcuyi3Ix6JTZg==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id gH0buwXbFlBy; Mon, 30 Sep 2024 20:14:15 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4XHXN53xs8z6ClY9T;
	Mon, 30 Sep 2024 20:14:13 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Sathya Prakash <sathya.prakash@broadcom.com>,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
	MPT-FusionLinux.pdl@broadcom.com
Subject: [PATCH] scsi: mptfusion: Remove #ifndef __GENKSYMS__ / #endif
Date: Mon, 30 Sep 2024 13:13:47 -0700
Message-ID: <20240930201347.1837690-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.46.1.824.gd892dcdcdd-goog
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Except for preventing build errors, there shouldn't be any conditionals i=
n
kernel drivers on __GENKSYMS__. Hence remove an #ifndef __GENKSYMS__ / #e=
ndif
pair from the MPT Fusion driver.

Cc: Sathya Prakash <sathya.prakash@broadcom.com>
Cc: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Cc: Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>
Cc: MPT-FusionLinux.pdl@broadcom.com
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/message/fusion/mptlan.h | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/message/fusion/mptlan.h b/drivers/message/fusion/mpt=
lan.h
index a1ec7e84d6fe..40b34f670065 100644
--- a/drivers/message/fusion/mptlan.h
+++ b/drivers/message/fusion/mptlan.h
@@ -51,10 +51,7 @@
 #define LINUX_MPTLAN_H_INCLUDED
 /***********************************************************************=
******/
=20
-#if !defined(__GENKSYMS__)
 #include <linux/module.h>
-#endif
-
 #include <linux/netdevice.h>
 #include <linux/errno.h>
 // #include <linux/etherdevice.h>
