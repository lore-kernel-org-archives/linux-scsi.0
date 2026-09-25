Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AAD53A782B
	for <linux-scsi@vger.kernel.org>; Fri, 25 Sep 2026 18:31:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790361072; cv=none; b=P2eHrZuymZSPuNHr0mm8bILVAod/WLcPFmI8f0O01CwwVAhpKb9urtq/7wvC2v6WcdCFoHDnCidEkO4DTJw7HZTW3ket7iG0V+a6NWh+RfTBymYEuZMfZ290tCyqr0zPjbyFOn8S7tvVjhABMgcVizLC9BKHbrgL68vZQfKvT0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790361072; c=relaxed/simple;
	bh=JGPuIyysDyaqVHQqhXHi0htNmLW6ILwWM7dGBH7g3y4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=K+SMDY/225eOLJXQPMmf73As1qnetNQy32mpt4Phea3RNURxGJIn8xBu0BtucFLpZTz1ik8Q7ltzjHU+kkk9AonV+cl8TujfDW6Rm4nby6v22L6/jwObx2acTlZvaPjSThb5WUhuaxwaZgvsSB5CM7si+PYiWxeLgDdb3nYzQ+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=Ds5y+WoZ; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="Ds5y+WoZ"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4hrzmZ3hstz1XM30g;
	Fri, 25 Sep 2026 18:31:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:mime-version
	:references:in-reply-to:x-mailer:message-id:date:date:subject
	:subject:from:from:received:received; s=mr01; t=1790361067; x=
	1792953068; bh=JGPuIyysDyaqVHQqhXHi0htNmLW6ILwWM7dGBH7g3y4=; b=D
	s5y+WoZrGYtWAverchYHaczJS8bWI0HJbuxUFtFSf44dUB6HNmJt1lhVNpE528UR
	PNxSoXMxlRlDBfwklx1xMWETA3tz0NJSlelmfxw+X2um4e90wp/DbW+cdvfBU3zc
	eLtLeYWjsSr9cEQH5T9b/syJMPexZU8bXbMGsP24bAWkPH7JkCT1Wub3+yXYZyXO
	69rOFK6/Yw7sKQKpv79pJvh+k3779uvnjVxFXhJB0iOGv4orhE7M25DPe7XLWciP
	/qDkw0h2H3N4EfRhKWXezA73IGrLCG1MoZoMVEp5yMCc3VK8PTq5h9MkILbHOnZz
	GntG5BxEJHHufjK11/wxA==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id R-oIjCP6I4Mj; Fri, 25 Sep 2026 18:31:07 +0000 (UTC)
Received: from bvanassche.c.googlers.com.com (148.60.168.34.bc.googleusercontent.com [34.168.60.148])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4hrzmT52Pcz1XM5kY;
	Fri, 25 Sep 2026 18:31:05 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Ram Vegesna <ram.vegesna@broadcom.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Subject: [PATCH v4 22/54] scsi: elx: Enable lock context analysis
Date: Fri, 25 Sep 2026 11:26:00 -0700
Message-ID: <5514a1e6c77a2143f52b74747ad8de568b04e2f4.1790360262.git.bvanassche@acm.org>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
In-Reply-To: <cover.1790360262.git.bvanassche@acm.org>
References: <cover.1790360262.git.bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/elx/Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/elx/Makefile b/drivers/scsi/elx/Makefile
index a8537d7a2a6e..0ed508e379fb 100644
--- a/drivers/scsi/elx/Makefile
+++ b/drivers/scsi/elx/Makefile
@@ -4,6 +4,7 @@
 # * =E2=80=9CBroadcom=E2=80=9D refers to Broadcom Inc. and/or its subsid=
iaries.
 # */
=20
+CONTEXT_ANALYSIS :=3D y
=20
 obj-$(CONFIG_SCSI_EFCT) :=3D efct.o
=20
