Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7CA23DA5C3
	for <linux-scsi@vger.kernel.org>; Thu, 30 Jul 2026 22:47:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785451656; cv=none; b=c2yetASnR9sRrojAj4EF9oXAtAjDoDMc9g730byw7KmzbzWdMtag7QQfFPEkFZEd7XoSROl45HR/31K+VXoBJxI8RuVZE9gn7KzmrPBImCYLcRG9+U0sCZt13Y7ibYdflRyxHLSSpukw1OOtl1fu75D+1XX0WlcIk310s8a2wew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785451656; c=relaxed/simple;
	bh=7FuJyjhhqhvsxrht7jskilcR6CMqGTAiPtMN4gKB6ow=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CKKha1c0HYHp2AcZoIgbf6jORlve17xjMoRemeyZjZR07377gU5t321RrhY9trSvEt7YmOjtmWhFo68H57Se2lNw8nR0JIBk2y29ET4O4QYr5DPmqKy91MTl0uz7eRU9NBk44xtOqlouGqe6sfmsvhOeA/HLVPMCW2Mbydl+T3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=gG8GY2A7; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="gG8GY2A7"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4hB48k4LzQz1XM6Jm;
	Thu, 30 Jul 2026 22:47:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1785451651; x=1788043652; bh=7FuJy
	jhhqhvsxrht7jskilcR6CMqGTAiPtMN4gKB6ow=; b=gG8GY2A7Wt2rAiJL+Nltn
	PE4RH6Bs056zjUZ/1AUf4Mdy3nm3sIS5SCKm2i4e02WEJyoyVI98T0cUq/AnbxWO
	FTYJEc03jVgYu7hDEV8s3QKErtF/9otFRaDCEpujEfvrcfdDNSR3M62V/SMyKYnP
	INVPuRYVPa13qp6kDZF0ColCyeBIYkKU3R/oa79IE3Ls3pc/YIN2tVSHF1L7JkES
	8CywDPZs67PPpxJRY8swcreZegTsf4SRNM73mB6UldpE+cD06GtqZsHNNFxzvFwD
	vKq6G+iyIhdPd/eXaIzMutCYSUIGYa7Zu0xt9NgZsKNb4Ted07EeTrsMu2ELFBo5
	w==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id sqGuVELbTkha; Thu, 30 Jul 2026 22:47:31 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4hB48f0DqZz1XM30k;
	Thu, 30 Jul 2026 22:47:29 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Marco Elver <elver@google.com>,
	linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Ketan Mukadam <ketan.mukadam@broadcom.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v3 16/57] scsi: be2iscsi: Enable lock context analysis
Date: Thu, 30 Jul 2026 15:44:59 -0700
Message-ID: <541c6098cc05ebf76080e7f742d139025b69de00.1785451174.git.bvanassche@acm.org>
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
