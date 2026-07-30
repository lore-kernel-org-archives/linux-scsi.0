Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BC123DA5C3
	for <linux-scsi@vger.kernel.org>; Thu, 30 Jul 2026 22:47:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785451639; cv=none; b=C9Lkj08+vDE/Mp1R8WjxFuOvWoS0O/DxEGPjE1XEPqOGBOQ6r4ByYq3pjkzD4K5HiZTpTIopk2Kw/49L4QBprgn5WXf93FUVWoVSssUSzR0BOROTZxwr/IMvqJHX0L8n0IYtQCRJnTuTbfsgCk8AEstgt4HD6CjAYBHL9TP0eTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785451639; c=relaxed/simple;
	bh=LfYNUf/FOKKCwDnHK7oTSoZt5g4llnXd/AmwsiGMmnk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M8kFvXQ4xi7dFgmbIoMl7QXjx1YgszXFcOW8ShHtvsa+djS5vi9zCKZit4i4ncCuqdiPeHTFANSrQg23tS2C3AVjBcmfX+GWA5qsrw5c/aQL0vVy9OdJSO7QcOyNcrfdQAVJAu0ZnUSW0vjarbaNVZAPmZLqH/JQNZaDRv0PXMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=ZR6Jl0Ni; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="ZR6Jl0Ni"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4hB48Q1lhXz1XM30k;
	Thu, 30 Jul 2026 22:47:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1785451635; x=1788043636; bh=k4FJB
	H+TV7Aoi/UWpAJPtYHw9mJd3UC0yM67ok15oqk=; b=ZR6Jl0Ni8ddIN6hpfhVQg
	ynxNyRT8uyOzov4uRs1Ma7B8v6JXDeTfLelG7f5ygKtkuEuHA9aELPk4SaEp3Nmd
	E5RWUC54JQb1CeS+kU+NZQubbET0rM7ZwqEOqO8i9ugDl+308lcdgwVFf+qKZrVS
	pbXy70zjtclgsf/IZPGIvk9oNM4uMQwutiW4oA/KVsVHdPskyQMEnUbSgOhNfr1s
	DXXm9muzp0JAxV4cadNPVjwxMS1IzPdl7w18tczFhEefd056LEOzlvxM2j1g6L/2
	WXExtrJSZYt+XXIoBYLZJNTqv+INZIvNWpOUY0bhQcvyRG/Q72FDBiCkls6FGd+G
	A==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 7hOtafIJ6l0Q; Thu, 30 Jul 2026 22:47:15 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4hB48K5dGyz1XM30r;
	Thu, 30 Jul 2026 22:47:13 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Marco Elver <elver@google.com>,
	linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Hannes Reinecke <hare@suse.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v3 09/57] scsi: aic7xxx: Enable lock context analysis
Date: Thu, 30 Jul 2026 15:44:52 -0700
Message-ID: <18c946b5149e8ecd112d4f7408efc7f42bf22e89.1785451174.git.bvanassche@acm.org>
X-Mailer: git-send-email 2.55.0.508.g3f0d502094-goog
In-Reply-To: <cover.1785451174.git.bvanassche@acm.org>
References: <cover.1785451174.git.bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/aic7xxx/Makefile | 2 ++
 1 file changed, 2 insertions(+)

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
