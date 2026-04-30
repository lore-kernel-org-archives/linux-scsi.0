Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8A23421F06
	for <linux-scsi@vger.kernel.org>; Thu, 30 Apr 2026 18:23:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777573408; cv=none; b=PzyhXOuqcG28ITpm3Pl7lluYAtdvf7+a1lFWfNeqcJODJuHmSP5GFAxXnm+h6qVzp73FSENFPhqpPQlzsKi+VJwoZK8+gAPAGnfaKgurJ0f7m3oGPNY4mNq5jxrBMwgByDJ8boZ+pkx6ZiVNtVkKeRnHXIkxdZPQcours2oFCm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777573408; c=relaxed/simple;
	bh=B7a3aLhKXLGOrB+jS153LnWbyEkz/zg5oUxSiOhylcQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J41Rssvsxbb3YB8ug7hz5Kd8NbRGyMaxjcPNr1xR52EkMwNUabl+l6S2TAYlLltGWxrJhweq+TuYYhXhY8FaSNZGThRyTI9zkqKOforTsPs1/GvuykYyMRLiROU5/YWtikCPJRxrGJtRiG973d0suYU2x4Ln3TZSpFETriFsVUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=o+fI2mjS; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="o+fI2mjS"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4g62bz0WybzlfvpH;
	Thu, 30 Apr 2026 18:23:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1777573404; x=1780165405; bh=B7a3a
	LhKXLGOrB+jS153LnWbyEkz/zg5oUxSiOhylcQ=; b=o+fI2mjSsKlbvZoXsRi4+
	jAoJprPlHGTNRQ3inLkADazVojRk926l5OLU+cYPcxHREZSNvMXHh6HAeGrQ4sjG
	MdSiDr3bp5s7ZbjIbcGUfNs9uf7KltBBkwl/6nuZzZUmLdenCFV2upOHz3Rnhzc/
	lHSldmk7IcgUYGp0BUdYGTCxGz4TLsiRC2qrfAIaOXcQhiGrcxdU6mxJ3MEX9klv
	jVzXDn17mf0jT6KtFH+Mj8H93PzOHArp8wzNnwCLW5YKraL02TSpHLyEpnCCG09l
	ewjGUgpiydN0FHHPMXDbSAZADVon+adNw/nG2tjfP0zGvRLe6ympnV4CWoO7Klk2
	Q==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id vTEvAeRuzlJk; Thu, 30 Apr 2026 18:23:24 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4g62br6d3Mzlffts;
	Thu, 30 Apr 2026 18:23:20 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Marco Elver <elver@google.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Hannes Reinecke <hare@suse.de>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v2 25/56] scsi: fcoe: Enable lock context analysis
Date: Thu, 30 Apr 2026 11:19:55 -0700
Message-ID: <20260430182130.1978347-26-bvanassche@acm.org>
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
 drivers/scsi/fcoe/Makefile | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/fcoe/Makefile b/drivers/scsi/fcoe/Makefile
index 1183e80a09e7..5e7121231801 100644
--- a/drivers/scsi/fcoe/Makefile
+++ b/drivers/scsi/fcoe/Makefile
@@ -1,4 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0-only
+
+CONTEXT_ANALYSIS :=3D y
+
 obj-$(CONFIG_FCOE) +=3D fcoe.o
 obj-$(CONFIG_LIBFCOE) +=3D libfcoe.o
=20
