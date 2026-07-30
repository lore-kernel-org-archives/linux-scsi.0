Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF2353B7B76
	for <linux-scsi@vger.kernel.org>; Thu, 30 Jul 2026 22:48:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785451727; cv=none; b=oH7fGm4HaoipaL5YXo1t0riZRyLD2cOmW/QXYK7J99VLsJvLHtkku9AzhDakqdTqNpJCEnn9wlGppuDp0w7P4orUX4XQLfFZor2SXGEsJiDzTXFFp4wlb+m7PN2PmjPnBLKlP6IlpNlJ4ecJ7+FiVyjVBE1bNBzK7HI9ffJVEzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785451727; c=relaxed/simple;
	bh=DmXZG1cfq9Z6xh2EA7NSAPd3Mw/ivsW7C07yq/8f0x0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nhc7+yfwso0CfjTDz2COlT0nCPFOG3LapZ+wnM++zIqZWv2Xn1s6i4+hGEr9QScXE6I7VppBJbxnbpgzUHqrQC/e9rrs8X5MWzzCgx5tw4t7T6dg/dIOzcHGrTcRrPg6bRZHyMMH+BK3aTAEsvCMSzpnlwzXup1g/sQYfPzXCIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=KUzXfdJ2; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="KUzXfdJ2"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4hB4B52rJvz1XM6Jk;
	Thu, 30 Jul 2026 22:48:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1785451721; x=1788043722; bh=mYDY5
	wLSD/qBDImoW5YNaScbDiQY5dFj+/NZ6SMMItg=; b=KUzXfdJ2ov9UFQBBnql0o
	wJU+FpvnNJpnW1obG9fFxePsjd/ZYcjh8f2u7pOgO5zp243UFaw1YG9zJ+qKDl7y
	DPk2iaYcH6peqPmm9k3V3ArFsY73JJjyU+MsL3sMzxVTUImnltxt62LDFpNmdv/d
	tIErWSYH2GYyP94zXBmR0B9AC9kCjdNZHjE5RCsE/iMDkEdcyBhlMvfCGcBiyTiU
	uahV2EoQybd/u7XD1hN+NNdvrA4LbDe1DWuUhLV0TcKUbEgnxPyjRLL3Bck3vaqL
	Wd55hSXzB5TpB35Iki+tb3fJc+Veb7lcagR/0WtCURuOdZ+BnHITXCVJpq9la5nb
	g==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id wclV303HdrjV; Thu, 30 Jul 2026 22:48:41 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4hB49y5K0hz1XM6Jm;
	Thu, 30 Jul 2026 22:48:38 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Marco Elver <elver@google.com>,
	linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Kashyap Desai <kashyap.desai@broadcom.com>,
	Sumit Saxena <sumit.saxena@broadcom.com>,
	Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
	Chandrakanth patil <chandrakanth.patil@broadcom.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v3 40/57] scsi: megaraid: Enable lock context analysis
Date: Thu, 30 Jul 2026 15:45:23 -0700
Message-ID: <78e04b1886820daa15ab84e1b322cc19eaa36cca.1785451174.git.bvanassche@acm.org>
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
 drivers/scsi/megaraid/Makefile | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/megaraid/Makefile b/drivers/scsi/megaraid/Makef=
ile
index 12177e4cae65..9a6976a4dc22 100644
--- a/drivers/scsi/megaraid/Makefile
+++ b/drivers/scsi/megaraid/Makefile
@@ -1,4 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
+
+CONTEXT_ANALYSIS :=3D y
+
 obj-$(CONFIG_MEGARAID_MM)	+=3D megaraid_mm.o
 obj-$(CONFIG_MEGARAID_MAILBOX)	+=3D megaraid_mbox.o
 obj-$(CONFIG_MEGARAID_SAS)	+=3D megaraid_sas.o
