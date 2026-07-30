Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E14B5464C
	for <linux-scsi@vger.kernel.org>; Thu, 30 Jul 2026 22:47:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785451649; cv=none; b=nJapIMDQt3GcP3xPULMOQfgWcoCUkbu3Z4Ub+ALCwDMjc1+zkJy+LwTtPhgsGK4Ogy9tUM9mapZuYJlX2bRMeBRPTbrjC8RNpOHy8F1mE/TawVCNiXlRsdwzxK7MD1qSDYcEeiWcZRQZ0aIr+0nch/UBLmfmf86T1X09LA7JQkE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785451649; c=relaxed/simple;
	bh=eR+lxdrj9h43hWxvPvQYuh4o4+yZXm2dLUA5q7qAUCI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F6fmfTeh2YLDxzCy/bPJssBjT+5kejnaiCuleJZyM/zT65Mjwaa154KGMwXRcOCaVhzHTKBct+7ZkEu69aUDXNcgwg/FndwKG67eAwJ6JrYYlhPorJzYOQLsRR3s9NwRp5PSsbeFjwU8D57pJ4eeRsnhjqOT2WpMMI64vYhg4xs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=Z7HjWbzZ; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="Z7HjWbzZ"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4hB48b5sQhz1XM30k;
	Thu, 30 Jul 2026 22:47:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1785451645; x=1788043646; bh=eR+lx
	drj9h43hWxvPvQYuh4o4+yZXm2dLUA5q7qAUCI=; b=Z7HjWbzZ4zzY8MWZPobvq
	lI1kUMaiUNhNJQcwKVuxEU6XjS529Xi79DJfghOTnoiE7Xh2byEKc/at9DnGTemj
	zLGkDEvB1ciS82W8kan0booIQsV/LX1eWNXV6RKDRi8vlnWY9YFBTryx6SnknKa+
	4Ca2yuiSutyDVc8spd1sOtzvooz+l3TELDKghw2p2GW2b1CU4cN3j4NHF/LNPP4v
	bAErE4ySVrEjOOPVUzVgAGPvXBix5Takvz3+cQ9lb4cXdlDpkB3eCGkec84LBm5V
	qaArFHyFhj+b/IYuH0hJTt273j76GjOfAaWxlSr8HTIC0hSHN7EfqrHBJplY6FuB
	Q==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 1jSQlX_jONai; Thu, 30 Jul 2026 22:47:25 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4hB48X3zb4z1XM30r;
	Thu, 30 Jul 2026 22:47:24 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Marco Elver <elver@google.com>,
	linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v3 13/57] scsi: arcmsr: Enable lock context analysis
Date: Thu, 30 Jul 2026 15:44:56 -0700
Message-ID: <fcad304c611814d19a17639f9a3f4cda70e58772.1785451174.git.bvanassche@acm.org>
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
 drivers/scsi/arcmsr/Makefile | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/arcmsr/Makefile b/drivers/scsi/arcmsr/Makefile
index 9051f66cae36..6c12d36994da 100644
--- a/drivers/scsi/arcmsr/Makefile
+++ b/drivers/scsi/arcmsr/Makefile
@@ -2,6 +2,8 @@
 # File: drivers/arcmsr/Makefile
 # Makefile for the ARECA PCI-X PCI-EXPRESS SATA RAID controllers SCSI dr=
iver.
=20
+CONTEXT_ANALYSIS :=3D y
+
 arcmsr-objs :=3D arcmsr_attr.o arcmsr_hba.o
=20
 obj-$(CONFIG_SCSI_ARCMSR) :=3D arcmsr.o
