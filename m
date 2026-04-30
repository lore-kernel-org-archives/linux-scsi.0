Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BDF939D6DE
	for <linux-scsi@vger.kernel.org>; Thu, 30 Apr 2026 18:22:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777573367; cv=none; b=taCI9mJGgpRQkqcZkbWRqu0INmTJpBmciik0YETXBRQt9tMv+9lrgwJy6cCoSA8xJ/cr5uibAc6MU+1xe10QEcCcstRL+1X5eykh7NF91hBGg8zNYaDkrb9TOGF4PKg78gYkrb+UTH5gngo9zgAgqQP1ezNg9UMbSnZ2js9cj9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777573367; c=relaxed/simple;
	bh=ulaH0sjY527GhmuqwS/UKr75UbYd1YaFmBdUmUsZZJM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KX3qJFrG/5omdGyY4kl7MPj/qQGX9MEDKi51aiR3L4Z3uXFtA2N7RTXjAQhkdkOuM7Pj2jC2dGy+an8uxJLpEzOaRfMpN+OE+JC5gZzCn6YgYZ03YSxKr7kykbqTfav16T6aqC2Fngi9KQ4BxftuhL6quAIMJlIJFxoz6kpIu6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=x3x1ulRM; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="x3x1ulRM"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4g62b95dMQzm1W0y;
	Thu, 30 Apr 2026 18:22:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1777573363; x=1780165364; bh=atTcM
	VdPwDlERu1BqJx+BaA1RNeieDATxylIhLZqnUY=; b=x3x1ulRMUv4k6PgUPNK/9
	zh1RZm0vgv/UmpZslrCf9tsEF64QOCshRc9eGsu2OxFCGTBzt9PUXgXI0ztPpbBg
	uBsRbhf8d32kOxEPeqNIn+IgLYjSWvbWQ/qbaMKS5vQz0c3MXUqe6TVmekxZb67N
	7oh1UTgFSlXuzVyGbOFmOVfg7j2MJIZ1QEd6gDa8yhD0nTz0NEhEX2itJACmGX1i
	6v1vvb5YxGGT4bscwHUWOljt5Hfd0n9NnF1lQo/WbCao/VqInVqFEz3UXLTbqjyQ
	FKQHPqZqEWvrPtUZ4GiBukprEgzDwbZtF5zG0z82ixcUO54Ic4AWz9jdR3JFzlGp
	A==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id fhEt37IKQadd; Thu, 30 Apr 2026 18:22:43 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4g62b62Sz2zlffts;
	Thu, 30 Apr 2026 18:22:42 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Marco Elver <elver@google.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v2 17/56] scsi: cxgbi: Enable lock context analysis
Date: Thu, 30 Apr 2026 11:19:47 -0700
Message-ID: <20260430182130.1978347-18-bvanassche@acm.org>
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
 drivers/scsi/cxgbi/Makefile | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/cxgbi/Makefile b/drivers/scsi/cxgbi/Makefile
index abfd38a26fec..c614afa18a33 100644
--- a/drivers/scsi/cxgbi/Makefile
+++ b/drivers/scsi/cxgbi/Makefile
@@ -1,4 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0-only
+
+CONTEXT_ANALYSIS :=3D y
+
 ccflags-y +=3D -I $(srctree)/drivers/net/ethernet/chelsio/libcxgb
=20
 obj-$(CONFIG_SCSI_CXGB3_ISCSI)	+=3D libcxgbi.o cxgb3i/
