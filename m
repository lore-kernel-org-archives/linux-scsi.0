Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24810477E43
	for <linux-scsi@vger.kernel.org>; Thu, 30 Apr 2026 18:22:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777573362; cv=none; b=UJ0Txsi1IiuiQQP3FbBnPxRqwPuVxVLjbb5tb47ix7xqhQhwyuZ7aRbMW1yaQ2sO96+o7IWCajxtaHaDjM9B3zc+IY+iHh80EZtHPyVxTROsAy9rv6P+M4JrVsD0eDJYz7tlDJyjeNJVV+BJ5IUAPBORz+c9jMSFmQPYE2vFBTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777573362; c=relaxed/simple;
	bh=7FuJyjhhqhvsxrht7jskilcR6CMqGTAiPtMN4gKB6ow=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XAqvnGTDQZv7IRcqPRa/R4UZSbFU+zE1Jxxmf3B1lODPrAtLkYV4uhuwz9zQ+ake3BQQ4hqTJCyH3vz3vec/Yko/no2VDAxr3z0RyE51Ao/xdxwMFn+F8PNmfxqtekHDf+eaWxavBN7c26TYTvghM3wpbz35fuCYRuX9P0PsJnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=JsE033QU; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="JsE033QU"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4g62b46YtmzlhpdP;
	Thu, 30 Apr 2026 18:22:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1777573358; x=1780165359; bh=7FuJy
	jhhqhvsxrht7jskilcR6CMqGTAiPtMN4gKB6ow=; b=JsE033QURieTIrraiDOtu
	liqHfWZsMnSzB6pn6b65+a7aknwdV5Vrv6TfnitBoY7pqRJN6ALiJNqzraI4Jg4R
	2KCzMIuNwxbDANKpB4VOXI91N4JlLJS9UW9o3E87o0GwrtAQ9Ab8FCnBuU3cYyi2
	Mci5KBEYs/gI5xRElWbOVzOedUCRIAjmLzU2vZ0wMIMO7AUZ02o00ME8azo5q72D
	zJ05lpIF1M9Zq3UWKAZK0D7QjQLlmf6MbVIwu2CQ8xFTb+22x+coBx16jiMyVQJC
	NGLlgO6mrpqnwlCWqK3OM3sFnkMQb3k9ZiVq6LYUeEzb/mqOlQrzCIZazO9Mktze
	Q==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id sKRFPi0AetQI; Thu, 30 Apr 2026 18:22:38 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4g62b04Y0Lzlffts;
	Thu, 30 Apr 2026 18:22:36 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Marco Elver <elver@google.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Ketan Mukadam <ketan.mukadam@broadcom.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v2 16/56] scsi: be2iscsi: Enable lock context analysis
Date: Thu, 30 Apr 2026 11:19:46 -0700
Message-ID: <20260430182130.1978347-17-bvanassche@acm.org>
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
 drivers/scsi/be2iscsi/Makefile | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/be2iscsi/Makefile b/drivers/scsi/be2iscsi/Makef=
ile
index 910885343a75..73d47c687007 100644
--- a/drivers/scsi/be2iscsi/Makefile
+++ b/drivers/scsi/be2iscsi/Makefile
@@ -4,6 +4,8 @@
 #
 #
=20
+CONTEXT_ANALYSIS :=3D y
+
 obj-$(CONFIG_BE2ISCSI) +=3D be2iscsi.o
=20
 be2iscsi-y :=3D be_iscsi.o be_main.o be_mgmt.o be_cmds.o
