Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C42923CAE80
	for <linux-scsi@vger.kernel.org>; Thu, 30 Jul 2026 22:48:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785451737; cv=none; b=uPzWp5fWrXNQ0br+Y9/4nFxU53W50dQOftyzoVvhPXYmHkzfM4QFkh4IFXZ+6c4056LhwYivS4ISICoPeq6gv+QYyqgiVaqwBIO4+hNcHVhIRK3MDoUCnOUdQ+8K54Erfr8t1bj5Rp9xEI2GWDBeQ+AItcjl71JJ5e+xmPoz2oc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785451737; c=relaxed/simple;
	bh=rKL7Un/25EVlg8BoZQ3yIJdADOjUgx3f75ypUeGOCgE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q25WpwXjhbcMiZtfd7I4ZLhOto8myox5y8rBgizu26KoRrVE/6lYMBj+EJqxuYCj5ccCVUVXlKgsaEhtIADUo36ZtKy5veN73EZOZ1b4eZPYLuHKuKNlTS98VMyqd+LtoTq36VylpBLK2neCe2QnMXAcbtKj7MPpVyZAY1AR4SE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=WBWW6r8e; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="WBWW6r8e"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4hB4BH30fhz1XM2FN;
	Thu, 30 Jul 2026 22:48:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1785451732; x=1788043733; bh=+T9qp
	0MI3Op598YBfIGU6wwUsIu/3chuKe4V8rg3h1Y=; b=WBWW6r8ewzOpGfohC1ToP
	4JR+ZcBaw3fDGKZwSrJLm79X3uMhgYY9G2rfm2DO41ZhdVgRtzwJGwDP5959R2U/
	9umpXoe7udFBmfPcKzAjpmR0qSprkp6xkoBj5LCrB3Eyvcn8FHW18ix+UK5duz3Y
	HZqL8XVRM6CeFsTFai7315H3/4APD8Xf0JA8r8WubeghdNieEp8UkHDmgouWeIG0
	mbejNWyq83l06c8dL2mafE7puHpQ+79v/S4eoX4W5+Xykr43YTAdrYrUPYM72t1Z
	008j3uwnrCNd8i2uXlTyLQXo1oK4wAF4wewYYdp16Sn9/4QfVdGEq0l/w20LPK5A
	w==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id ABfSoyAY_2W3; Thu, 30 Jul 2026 22:48:52 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4hB4BC4ppPz1XM30r;
	Thu, 30 Jul 2026 22:48:51 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Marco Elver <elver@google.com>,
	linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v3 43/57] scsi: pcmcia: Enable lock context analysis
Date: Thu, 30 Jul 2026 15:45:26 -0700
Message-ID: <056c3d79700a4737f19aa775e5e590f3dc577641.1785451174.git.bvanassche@acm.org>
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
