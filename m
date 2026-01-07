Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10EC038BF7C
	for <linux-scsi@vger.kernel.org>; Wed,  7 Jan 2026 17:48:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767808109; cv=none; b=Mhvz5nfNz+cIReqrTz7CK7Cu5xgQLgAdndYf+afSS+Myfv3aKGOutrR9ZE0ETxbDNJWSTd9YquV9O0R2LnOZ5h8Pj0Yqdl1ZN3YvJ7rxTTpNcPEZ0NANGOiCSSmuBKSgAZMHxe8Xapg2ppC3UluYRTLoa3BgMpn+g9O3JjYbTEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767808109; c=relaxed/simple;
	bh=oGciHMgfg61xzIXgnGeQz5A5tWPlPDXQon6+quZGeq8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RrZC4h+4wXF0w+jXmJvffC1qt4enMEs5B4VAtn9i70iF/GXdQOZhA2zspaNM/sG+JqSKpKbs2HVTwWsAoxlwiGFOti/laCF6XuOBYgSs1Wd4eYZYKt2VAPw4g4abSMSFzeKoJ2tWJCFE8zIWoSnJJWaqpGB/Bz8Mj0ar62J/YSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=uaF+qRnb; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="uaF+qRnb"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4dmb9R50j7zlkMXy;
	Wed,  7 Jan 2026 17:48:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1767808090; x=1770400091; bh=5zWh9
	Wcc7rSykMUrRHMnmGW6D0L0qyVhrFH8z4+KCB8=; b=uaF+qRnbQBbF2JRrQVWNt
	fArGn1Wkr9Q8jZa4/5lVN8jsV1z05MYsm30ded5bZ/P4Oz45UTT0Q4wS40bYKXtW
	exYWueJ4nskSTLV69l/WgolC8N2rhp9S7tXxdDcfD3xfBsFf+AqyzoVdZgVGZuVD
	9lbDH3qxeFap+kael+B6x4aamKTOEbZZZ1T/U6becZK7qYEy9rGYumryO+2xCG6k
	e5Dxk9UfYp7O7uCR3+pvJXrcyakc4JwkpL5jez+vzRSNhJASmgq0y1qrwa8vbAm0
	TKQ0M7bUmMCHxorhPrWUmMeKNBuCqcFj0XPphjweKD/SOFtHBawjYNM0aFT6VQ2k
	w==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id qp99jDS89cRK; Wed,  7 Jan 2026 17:48:10 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4dmb9P37Vfzm3Qs3;
	Wed,  7 Jan 2026 17:48:09 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	John Garry <john.g.garry@oracle.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH 2/2] scsi: core: Revert "Fix a regression triggered by scsi_host_busy()"
Date: Wed,  7 Jan 2026 09:47:51 -0800
Message-ID: <20260107174753.3089238-3-bvanassche@acm.org>
X-Mailer: git-send-email 2.52.0.351.gbe84eed79e-goog
In-Reply-To: <20260107174753.3089238-1-bvanassche@acm.org>
References: <20260107174753.3089238-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Revert commit a0b7780602b1 ("scsi: core: Fix a regression triggered by
scsi_host_busy()") because all scsi_host_busy() calls now happen after
the corresponding SCSI host has been added.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/hosts.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index 196479cbfe6e..f1dd71a2d89d 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -626,9 +626,9 @@ int scsi_host_busy(struct Scsi_Host *shost)
 {
 	int cnt =3D 0;
=20
-	if (shost->tag_set.ops)
-		blk_mq_tagset_busy_iter(&shost->tag_set,
-					scsi_host_check_in_flight, &cnt);
+	WARN_ON_ONCE(!shost->tag_set.ops);
+	blk_mq_tagset_busy_iter(&shost->tag_set,
+				scsi_host_check_in_flight, &cnt);
 	return cnt;
 }
 EXPORT_SYMBOL(scsi_host_busy);
