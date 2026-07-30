Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1CEE5464C
	for <linux-scsi@vger.kernel.org>; Thu, 30 Jul 2026 22:47:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785451663; cv=none; b=BtpStda/tWFfBEago0KnEPZFcqT1GxKK+onOH3qQbKg53f54ygeYHcbu6rm++BcOE7gGiPR6dV10msrCSaWC2Ov8nI+I7spuqiZE/qGMZLBkg85pH/qGjgMj1bhwYjubXeXKm5wq6SI4kg/QbytifoD6U1GRobRGOSeb7yROf9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785451663; c=relaxed/simple;
	bh=cYafpE8Aagw+72f8xp1S4C/uzFasuohihy5Q8yn3QJY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MjYsr5OYEDv88Nio+AZbHrPHUPyJZoIEorzFNacAIRU62oUuZjRt5nnQJ1Ml+LqErW9mMWwFY+FhKKzDFXdYgHAf3kK4LxPasJWQm+glPxXsmXLSqwbzEJIxX4c5UCVGkwpWRrCLWc6LuY0sVlsms8OzeFSa9OO7lmxQWfVHtmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=hBHwUw7N; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="hBHwUw7N"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4hB48s4BSsz1XM30r;
	Thu, 30 Jul 2026 22:47:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1785451658; x=1788043659; bh=cYafp
	E8Aagw+72f8xp1S4C/uzFasuohihy5Q8yn3QJY=; b=hBHwUw7NemAZS3Fu3h1uw
	tx/ha3fPiu8IFmsY+RQkVyMP4t+qNZDnvt6oulggd7uJ5liMUMgRAgpm95RQ1vcU
	x5HZRj2ztJ1/jrLE/0cWA7rJWh9xI0dBYRUHFEqPAtOgv0kTdTFWxKD/NLyECtEv
	Cs4jlgtQC/JcqZQgbK4PkxpFwOqaS8vVhu79gzuN27juW7+Om7wH+KrmF6DnYuls
	392o1sWXmUD/fhunWoEmPdBzEgLc4B4jnMF09ygkWh9MDU925M8m0VbqKwEOmbD2
	Lz253mrBoe3tbOwlxvET6Y6Y/T4IBwpw9gRGCuanRZCxo2AOqHiQsiTPcYEcPyOh
	Q==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id qH2736uA3GON; Thu, 30 Jul 2026 22:47:38 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4hB48m0wPVz1XM4TB;
	Thu, 30 Jul 2026 22:47:35 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Marco Elver <elver@google.com>,
	linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Anil Gurumurthy <anil.gurumurthy@qlogic.com>,
	Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v3 18/57] scsi: bfa: Enable lock context analysis
Date: Thu, 30 Jul 2026 15:45:01 -0700
Message-ID: <71fdec07b08cfa9f2967d81f9e4c7edd52a49cc4.1785451174.git.bvanassche@acm.org>
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
