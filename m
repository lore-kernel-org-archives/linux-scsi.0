Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 569F53B7B76
	for <linux-scsi@vger.kernel.org>; Thu, 30 Jul 2026 22:49:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785451768; cv=none; b=BBfc5furhXkxtrNdvucmlQ6nE5mhiZ8kjY8NrZoE+dkCB+5AyHHQwEIbTOuV36qBJrYe/qk/aZm+6u64/RBkOia+n3Ywt4Na38httrbC4fMvmdAoKSwuFwQ4XcmfHpsGVb+kVOK3Bmqmhk0xRG7v18X7DTAMhUbgY5/dueTTkOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785451768; c=relaxed/simple;
	bh=PZryYS6oabDZtYzYOm+Zw+phqvE4rpAMwCPqX7oBcaE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aqISRY5jII7lIQlwwqOYQKh/cgffu23vxpPa4Gg+bm7nI77VI7kk5z8lAafcnuIoko4pp5p2T6EP4C8it2rWaRMiwMNP/P9vmMrts53DbAavrQfKpvbKtSgFbEMq95863DGzdS9iXp0lCuiKLJQg4g/4vAie/0ZwjnnXukxZr8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=JeYl5wxo; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="JeYl5wxo"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4hB4Bv0g98z1XM30k;
	Thu, 30 Jul 2026 22:49:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1785451763; x=1788043764; bh=PZryY
	S6oabDZtYzYOm+Zw+phqvE4rpAMwCPqX7oBcaE=; b=JeYl5wxoS7d8eYbq1YLJm
	lkP9uJTHUSVaFIE4UNCKdjzLbNWwRN2+Fw2o46RZu9QxpYM51y2siHwrKUNsxps+
	JMvuAVsmWBUcI3a1uPHLQb0K7+em5ALGsSwbw/VneT8otgqLNkwTKPi9szsUlpVB
	2vtz1iwrjaaKVt3MzFD8hpyK2o5dwpV37RtSADsW+pKMwBAGRHMskKY3wSKj1Jl9
	HyZ/AQhrcTrnCRcOzXqmJO/WWAwftVdW9uAsfPI0kEJkQUbwoc9HjUTA2mjxAgIe
	i9N/EgHYGmGL+QgbFZJDdKvHAj8vRyHz4qsLgbEIC+15YbX83fxHyVFvsxqDYUzL
	g==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id u0oAWA12U28N; Thu, 30 Jul 2026 22:49:23 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4hB4Bn4Tmgz1XM6Jm;
	Thu, 30 Jul 2026 22:49:21 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Marco Elver <elver@google.com>,
	linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Narsimhulu Musini <nmusini@cisco.com>,
	Karan Tilak Kumar <kartilak@cisco.com>,
	Sesidhar Baddela <sebaddel@cisco.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v3 53/57] scsi: snic: Enable lock context analysis
Date: Thu, 30 Jul 2026 15:45:36 -0700
Message-ID: <d7bcf97204c7598dfdf5e595e2a33b1a39dcdd2e.1785451174.git.bvanassche@acm.org>
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

Set the CONTEXT_ANALYSIS variable in the Makefile.

Acked-by: Narsimhulu Musini <nmusini@cisco.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/snic/Makefile | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/snic/Makefile b/drivers/scsi/snic/Makefile
index 41546e3cb701..b12563cb174d 100644
--- a/drivers/scsi/snic/Makefile
+++ b/drivers/scsi/snic/Makefile
@@ -1,4 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
+
+CONTEXT_ANALYSIS :=3D y
+
 obj-$(CONFIG_SCSI_SNIC) +=3D snic.o
=20
 snic-y :=3D \
