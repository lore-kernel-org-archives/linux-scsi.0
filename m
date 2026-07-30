Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF9DC5464C
	for <linux-scsi@vger.kernel.org>; Thu, 30 Jul 2026 22:48:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785451697; cv=none; b=siC2HI1KVlzvcyYCdYzg2YC3z+4wZywkzgwADOgwuLelAI384chST2bLzzbFiOmrEkw0U6bXinnK3JYgd7FZKYPB3e+p25NrdlCzhtE83k2UFnV3eIfSwKdn23b0mi+1cRsqNgOSKrElrdo72vhs2zxpldN77paZ2/wQPUCABw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785451697; c=relaxed/simple;
	bh=S8s9Evt9q6E9ThD59drqkw4KAmBOa9WrUWu/y3I8FGw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UJ9ilENzdnf7in+wNdaiNurrTm3wzSH4wBmL1x1YJMiG9THyYCbzBI57QnYpfM+bEUQR/izsXiuVdYkSv+1cG2Nz9bNJYDhFtec9hnYl9ARpMLBKdUSZo+x0g038VUjQS8DhNjgnvhpj6pffZYSG/kiWLltd5j+4/ZJ5AxF1f2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=G3Ip7BnH; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="G3Ip7BnH"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4hB49W3CRZz1XM6Jn;
	Thu, 30 Jul 2026 22:48:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1785451692; x=1788043693; bh=RVmcU
	AOb7A/6iFXQs8RCS0FKx9GP3tYcdj9zAlZo2Zc=; b=G3Ip7BnHmXBd/GKwa8Tpd
	NBiSp/n4xH+TW10PoPPog6ygFcw9b7gK7rUUK6rTJ41vPh+hNRDwcFejIgdQC1GJ
	yyhvvM8e9nQeFeRAUtP2MzmJlGe+By+JMkJszLHmEECE4i1pWbxXdN1yjjOQzWBk
	TDj+BG8XgVHFLcSkJXCdezo1/DijKa+Vuk+FATDDIx1FaSOQXSLuQcbmE55Zalrb
	y9aBl/Ag1DnloBkaaBTfFsohGoGLCwpXSOrUTCytt4ZIV2g5v9GipfKWV7YD9zk2
	zsYENJ2VDM6gjQ6WfSSWglL/whbbEZseRsogITju/az3p9uho0bRCMmkXpV7adad
	w==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id z9iw9XZLt0kj; Thu, 30 Jul 2026 22:48:12 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4hB49Q4zqfz1XM6Jm;
	Thu, 30 Jul 2026 22:48:10 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Marco Elver <elver@google.com>,
	linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v3 29/57] scsi: ibmvscsi: Enable lock context analysis
Date: Thu, 30 Jul 2026 15:45:12 -0700
Message-ID: <0106d5b61f6269d9f768f24f1421472fb4c2c685.1785451174.git.bvanassche@acm.org>
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
 drivers/scsi/ibmvscsi/Makefile | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/ibmvscsi/Makefile b/drivers/scsi/ibmvscsi/Makef=
ile
index 9408c7f4cdee..de6ed9e64b63 100644
--- a/drivers/scsi/ibmvscsi/Makefile
+++ b/drivers/scsi/ibmvscsi/Makefile
@@ -1,4 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0-only
+
+CONTEXT_ANALYSIS :=3D y
+
 ibmvfc-objs :=3D ibmvfc-core.o ibmvfc-nvme.o
=20
 obj-$(CONFIG_SCSI_IBMVSCSI)	+=3D ibmvscsi.o
