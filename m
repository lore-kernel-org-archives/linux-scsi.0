Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42CD74D9557
	for <linux-scsi@vger.kernel.org>; Fri, 25 Sep 2026 18:30:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790361012; cv=none; b=Pl/EALXbA4B/fF5N2UB9SMxmRMLlJN4ygUSbrv408yI3JBG65DszOjHxrEYuj7h0hXwFE1UYAeb2KAhKSqGQ5/PsaVafwRizqp2reh/46rDAuGCZX/P1HcQKH45uXktzlWRiGkoPkD6PfMm915Ht+BfSPBXo/AaW/LNmMIvzxcc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790361012; c=relaxed/simple;
	bh=cYafpE8Aagw+72f8xp1S4C/uzFasuohihy5Q8yn3QJY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YGNW5lO0BZH4fyjQe3k2KneUSUAqGLCUuBTUP9uDim6E7/JiJhzE56gKT8cQOu/DVoxByUpGOGilCbNDAtk68urVyu/ZaB2tCxZ40wzqZvbxC9il/e4DiEJqR+1S/o3DTjlqVF9zeJkHPbzjahncGzOG6Aqbqk6Fc/JXvBNjKU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=YicyqpeZ; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="YicyqpeZ"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4hrzlP45slz1XM5kY;
	Fri, 25 Sep 2026 18:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1790361005; x=1792953006; bh=cYafp
	E8Aagw+72f8xp1S4C/uzFasuohihy5Q8yn3QJY=; b=YicyqpeZ2miPL60gTLe3s
	H9chimboF8+E+OVheijdST8Pv9a0zhFNUZikGNzxTNdc8O/Mh7ZVHvsD9LVcX1Rh
	E3ioAQs/NlnrXVxTFwLzfr6UphsfoL+SFKo0OBXoBaJXNlcClKB2fCKEhZY+nrQ9
	9XMZ+J8go/S2/D8zESBri9LCrNwCYSwmC0c0EGSai4AcUyla0r1gi3CstQcXOJ/B
	ppw0xBpohHzHfckmREsUBSdq4MD8ryoEl4g29Z4tLHEm/z++HrQLTDQvVzUL0Uss
	MTL5roxlK9gt8Z9RAWBMCQ1Liyh5B4xxU25UBuxpNexKtzoh7sTArUPtb4QFa9UK
	g==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id oCcFYVvlUgUi; Fri, 25 Sep 2026 18:30:05 +0000 (UTC)
Received: from bvanassche.c.googlers.com.com (148.60.168.34.bc.googleusercontent.com [34.168.60.148])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4hrzlH3fKqz1XM5kt;
	Fri, 25 Sep 2026 18:30:03 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Anil Gurumurthy <anil.gurumurthy@qlogic.com>,
	Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Subject: [PATCH v4 16/54] scsi: bfa: Enable lock context analysis
Date: Fri, 25 Sep 2026 11:25:54 -0700
Message-ID: <a109c89c781c7623a7a1f4aa3b4bd4bbfe32d7b8.1790360262.git.bvanassche@acm.org>
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
 drivers/scsi/bfa/Makefile | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/bfa/Makefile b/drivers/scsi/bfa/Makefile
index 442fc3db8f1f..50c16fcfb01c 100644
--- a/drivers/scsi/bfa/Makefile
+++ b/drivers/scsi/bfa/Makefile
@@ -1,4 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
+
+CONTEXT_ANALYSIS :=3D y
+
 obj-$(CONFIG_SCSI_BFA_FC) :=3D bfa.o
=20
 bfa-y :=3D bfad.o bfad_im.o bfad_attr.o bfad_debugfs.o bfad_bsg.o
