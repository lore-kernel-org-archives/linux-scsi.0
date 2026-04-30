Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 912B9477E43
	for <linux-scsi@vger.kernel.org>; Thu, 30 Apr 2026 18:23:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777573437; cv=none; b=j4PTg3NeBeCI25ho4m3oIp0DsGgiuBErTf97igA3E587rZFnZhheDg6PkkZKSi7LEB4Rtkax6flGlWX7rNYefg1f7XgUp03dlaQGXPEISI9O/IYXczUCQV+xaS9yjOYBwyoxUN8rPyKk1BqjDl5c1HVYQ91y5OJ0W90EteQXKO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777573437; c=relaxed/simple;
	bh=jkBaaX3fswOzJBryZmOJCwbhehR5ja+0lhOZsnubYcU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dudWRJ+e/EoRdl1TnygCVwdxHUpLmThrqbyXpp/7+6UanKKukelUlGsEx5TuJeti3e0p18ySYj/n1DHoHyHMlOh3o0LJispKJ4xrK/CAYGZwPtIe4FYncN2AM6Zocm3idq0+PSo4pRZtgoGk1/lKEf2Qhh70vrrhxF4XSbtz0CY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=g53eoyyf; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="g53eoyyf"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4g62cX0vMhzlfl89;
	Thu, 30 Apr 2026 18:23:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1777573433; x=1780165434; bh=6jI0p
	cC10q66grU/E6Q6GBF4vhCzJyle4HKc12rXP8w=; b=g53eoyyfkKPCN2ZP+WZzz
	5+kKOQS0SISuxL9fMJsSPEFNQzQ9JdBV4Q3GlLR/q3Kk4LPzUAISDkcZcglM0O1Q
	i6Csq+sGbl6AU9QjX5HO3B5zrGAZK/DtdaKeaf0BdxDoEkZ5bhl1kBnZ6jpLpxuE
	XworMUMrKAVRHIuv5RjCIr3ZEk6NA3BgAhu4XTCIrpZEJBN95saZX6UdITy3UjXW
	LJu45k3nWKLLeWjvb4J7svGV3KWj5Gbyowb5LY9QRgZ6J/wiqv/KBkAQvkSu+xdI
	RysqaYfnoSd5hWx8l+NJo3QYaJtr95UlmHBgNNo7r95iVOB4xhAdzgeo5ZHIaYHx
	g==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id Ms0_4u1tqtsL; Thu, 30 Apr 2026 18:23:53 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4g62cM6twczlfdds;
	Thu, 30 Apr 2026 18:23:47 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Marco Elver <elver@google.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v2 33/56] scsi: isci: Enable lock context analysis
Date: Thu, 30 Apr 2026 11:20:03 -0700
Message-ID: <20260430182130.1978347-34-bvanassche@acm.org>
X-Mailer: git-send-email 2.54.0.545.g6539524ca2-goog
In-Reply-To: <20260430182130.1978347-1-bvanassche@acm.org>
References: <20260430182130.1978347-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/isci/Makefile | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/isci/Makefile b/drivers/scsi/isci/Makefile
index da6f04cae272..00fd5c1a8d39 100644
--- a/drivers/scsi/isci/Makefile
+++ b/drivers/scsi/isci/Makefile
@@ -1,4 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
+
+CONTEXT_ANALYSIS :=3D y
+
 obj-$(CONFIG_SCSI_ISCI) +=3D isci.o
 isci-objs :=3D init.o phy.o request.o \
 	     remote_device.o port.o \
