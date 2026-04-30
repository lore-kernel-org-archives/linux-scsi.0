Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 437A339D6DE
	for <linux-scsi@vger.kernel.org>; Thu, 30 Apr 2026 18:24:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777573486; cv=none; b=PaZAH3SxfUqEYPlIMnZ/qXBaVFdc+dx8pWCU2FnLNG9hbFW4T8/hhyK1j3BwWw5VgNq043O9DC6TGkyF0bf9AlP8Pu/n5rZRP04saku2dkpw80CKmqjCl7GGa8tlaM8o8ee1tKBmA7twW2lD9/wHpLGqvwaT0iEICpI2Bb1VXoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777573486; c=relaxed/simple;
	bh=rKL7Un/25EVlg8BoZQ3yIJdADOjUgx3f75ypUeGOCgE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eztT2yDoFJKK93Js4UXjIU09Eh9/BlkoAOflt35EZLnG7almgIsm56PsNFS+YjQJWIWx0WgC1wO9xTb8hGmUArrlwu8KEVo4nVdnwajkp45w9QTHk6J16V2P2GEP1fF5GqnyMuLtB1+a8NdxMgtIOkJyBpP3ClSzsyfVBd93H10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=BO9Cixco; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="BO9Cixco"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4g62dS6YHGzlfvpH;
	Thu, 30 Apr 2026 18:24:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1777573482; x=1780165483; bh=+T9qp
	0MI3Op598YBfIGU6wwUsIu/3chuKe4V8rg3h1Y=; b=BO9CixcoVRvge6MpXQt3l
	A5jotFcgbJo3WZAGOdFVqmbraSKZMS1iY/T/fLwbz+OeSPBpLIpfJU0ZjvneaEhr
	NGGLP4lDJVNWn1t/WP3G4EbJfGMFlUuJwB+1a3v/2+M4vzhJBMACgkqZE8CGqGij
	MQK1dT6Kc7ze3YW8YPoyeFZrOrtU6BMYdMYHhNYYuO65XfDs/yjxQeaWn3O7gEso
	COS7/G6egpNe61yRA0rqLDhDVpVTRunPiy8jw2bC0s/HcHUv4UpjIJcRCeLyU4LD
	asPKLorDNQ6fDZwonnIw2jsnjORql/hzauNLv2/vrQKqDHf6IVzxZAGDi4+g46F7
	g==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 3W8B9bUefSGX; Thu, 30 Apr 2026 18:24:42 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4g62dP3L3Kzlfdds;
	Thu, 30 Apr 2026 18:24:41 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Marco Elver <elver@google.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v2 43/56] scsi: pcmcia: Enable lock context analysis
Date: Thu, 30 Apr 2026 11:20:13 -0700
Message-ID: <20260430182130.1978347-44-bvanassche@acm.org>
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
 drivers/scsi/pcmcia/Makefile | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/pcmcia/Makefile b/drivers/scsi/pcmcia/Makefile
index 02f5b44a2685..06ea2bfcd42a 100644
--- a/drivers/scsi/pcmcia/Makefile
+++ b/drivers/scsi/pcmcia/Makefile
@@ -1,5 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
=20
+CONTEXT_ANALYSIS :=3D y
+
 ccflags-y		:=3D -I $(srctree)/drivers/scsi
=20
 # 16-bit client drivers
