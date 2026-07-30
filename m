Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EDF43B7B76
	for <linux-scsi@vger.kernel.org>; Thu, 30 Jul 2026 22:48:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785451692; cv=none; b=KzystnM0EX96bNSxIORgJfwdhyzd9ji//Knn0fCicWUUjb1LHyHz9nSJ5cDWipeQZdzH0k3YvOIw75vWy3n7CrddwZHEmMdO6S4vw80AMU8Mo/5b1fNzuEVl0KOlGZBdXxG/iLkJjrrVSW7X3gbT/uKNNz0r8ViVjZEljy3kRM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785451692; c=relaxed/simple;
	bh=k4tldGNR5CErhM5sxtZLS/GW+khBvOrodyLMisdkMLc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=moD8n+1I2kqwu7hsAYWpA8P6YQof+AhXpk3L1IFaZfj7B8mPK+TwWHnmIIaKnGzLchKRF+HR+606bXSY+DEG4ToRkyF1oaw1VVnY6v8AKugySQZfcwyvZoWdQoahEGhmsV3HNlKjJOrZU4m9cisiWOYG2tVmAE1cwmhdCxji6I4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=Zr3384kF; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="Zr3384kF"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4hB49R0DN0z1XM6Jn;
	Thu, 30 Jul 2026 22:48:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1785451688; x=1788043689; bh=8EX99
	Tg7aEDSo+xYJ5hBUWcZ/pki/1tzNSzfGgBln+8=; b=Zr3384kFu9MdfEyrPoyWx
	zy9VViGR/s5wngJzz0QjhouSI3/YHLxS8PamkJtsHokq39YwSOiVW4f7xZ0i5F0F
	DKRKp5ZIRaJQ5j5j5zfP4Xlzh4mt8K18hKsD0d0k3yvVwN0llh9xoaI8Tj7DzieK
	SM20Q0A6P//3eejZtpQcFY1fFAnVbKyUk7EubLhilojBHBbZFvtCO2fxFh9lOLcT
	D8QaYnnN8J4a4DWxpLAmI1v5nUya1Y/LV/SglZ54/kVKN/i8QxexRAcezkhprQ/E
	a12qakeXN/PGg405sSCEEP7ctCSBKN+4zJoPJ2p1sb+khlEoH1IrFRqbJ6mFs/o/
	g==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id IxTG0JT1c3Ig; Thu, 30 Jul 2026 22:48:08 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4hB49L4jCTz1XM6Jk;
	Thu, 30 Jul 2026 22:48:06 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Marco Elver <elver@google.com>,
	linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Xingui Yang <yangxingui@huawei.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v3 27/57] scsi: hisi_sas: Enable lock context analysis
Date: Thu, 30 Jul 2026 15:45:10 -0700
Message-ID: <805f885fbac93c01cf2427cc144c48bd7c22a3c9.1785451174.git.bvanassche@acm.org>
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
 drivers/scsi/hisi_sas/Makefile | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/hisi_sas/Makefile b/drivers/scsi/hisi_sas/Makef=
ile
index 742e732cd51d..8576c78d4afe 100644
--- a/drivers/scsi/hisi_sas/Makefile
+++ b/drivers/scsi/hisi_sas/Makefile
@@ -1,4 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0-only
+
+CONTEXT_ANALYSIS :=3D y
+
 obj-$(CONFIG_SCSI_HISI_SAS)		+=3D hisi_sas_main.o
 obj-$(CONFIG_SCSI_HISI_SAS)		+=3D hisi_sas_v1_hw.o hisi_sas_v2_hw.o
 obj-$(CONFIG_SCSI_HISI_SAS_PCI)		+=3D hisi_sas_v3_hw.o
