Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 314583CAE80
	for <linux-scsi@vger.kernel.org>; Thu, 30 Jul 2026 22:48:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785451705; cv=none; b=NCYniE5ldsON2wOHILJAgKUmEyLeTlPGBYjccV7nC+7zu4i9+tx2PI+6JjHF1+mAb+t8RUeRAL7oIHrexTz11ekC1gOU2zcmB3SoQcoSpcg9Ob9+PvTLmwwyHrUjcXPH5JEarLdZjhaleivJg8112620IHBuMy6g5g/o6DeFeBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785451705; c=relaxed/simple;
	bh=jkBaaX3fswOzJBryZmOJCwbhehR5ja+0lhOZsnubYcU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FeIBJqDdRsOkm57vHiegj24nQ39OowZZ/XNCiCboWTQJdM5LI155HOWZmMELggn70VLcAP2Fp7aeQpXiwwXI0i5Q9s6VdmWF4eNa0RuSdpeuQDQqrZCxFiSuBuZbl8v5pU+EZokiwDmaamlHXcCVny65q62ez9uXs5rVJ3Gg2pQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=ZNQJmlJx; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="ZNQJmlJx"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4hB49g5TrQz1XM4TB;
	Thu, 30 Jul 2026 22:48:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1785451701; x=1788043702; bh=6jI0p
	cC10q66grU/E6Q6GBF4vhCzJyle4HKc12rXP8w=; b=ZNQJmlJxBT0FAp6BfQwpw
	Js46kbWtjxyuk4jBpE2xpq1gfKQz4ZK5H/ukRHgg24EjOY2RtJTPExa71S3cG8eQ
	gvg4Zlb7bmoTjB3hdFryNMeZ+LPrOPMfFEVNRFmQecmX0SVBx0qmCEZM/IYubG9j
	lyrSmhREFocdS7+umlhcQ//e5YzD5SKHV+0crf5llr7njDFGHPLuz92F/JC+nwFL
	yFtbOXoQfI+FoTtzDA2GrYZt3FraSV2gVg3PLfoU7YdaJA0kyd1HNXIaaOyMkY1m
	RZTpJDrWwoTpX1vFYC+7l/xsLoE6DqFeyY7OX2xK60L7kq+N2ecLMjRhKqq1RX0S
	w==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id JH_J6_GedK3g; Thu, 30 Jul 2026 22:48:21 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4hB49c0kGJz1XM6Jk;
	Thu, 30 Jul 2026 22:48:19 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Marco Elver <elver@google.com>,
	linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v3 33/57] scsi: isci: Enable lock context analysis
Date: Thu, 30 Jul 2026 15:45:16 -0700
Message-ID: <f7b09131fca225272820d1ff57f55bb99933b614.1785451174.git.bvanassche@acm.org>
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
