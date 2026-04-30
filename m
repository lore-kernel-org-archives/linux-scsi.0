Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11BA247A0CB
	for <linux-scsi@vger.kernel.org>; Thu, 30 Apr 2026 18:22:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777573342; cv=none; b=POq/ZUntVVW+snXYQzgIfqPod0XC9n31vhuG9OU36GghnX3MXZJsa/5h5CSLojvoXNMPpaGCTJJP2uValTAxq6fuRP3Q5/swr1O34UxZadk5B0SJlJA7o4al+NHfsIP4mRAwDAaqLnRnRn9Xaesx8s0dtBIVuqDhRdouF1SFpK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777573342; c=relaxed/simple;
	bh=76u1kUdSOMdw1vAjVXt4g3N7fVwAJKLab7WirB4o6pc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AxVAAlKK6U+CIG9UWNkofZETclt9W4a3oeXCEZIqYMXHMYMf/zIgHF6ge5CE0wn7F4uO3Jo3S3j4hdDe7cZK3JGwPo1eAssxIcA7kpZR8sk13PrTtWCHjDNcUrYJXlPMUJbV3rtrnPCciNKI267Xihl7F4VIsPqu6yh6+1bDbUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=IHxRnLLf; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="IHxRnLLf"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4g62Zh62HNzm1W1D;
	Thu, 30 Apr 2026 18:22:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1777573338; x=1780165339; bh=56XqI
	xnR3+CKVjP7ELXa8qEDxDHIlibcqQYsgKj+vhw=; b=IHxRnLLfb7xGlLHe6fbbF
	miAtkkpvBym6l4Sf9ZBKaFsY3OMEkzTnyMfoh4rsetYMmHliZSdp2kEyCutDRcNE
	+SYVAL4Tq2VmcHmypo7hi5CEr79P4RpnlznYYlOdLDViwoMvpnAXQrBP3MkgqIBv
	9Jpb9zcfOUFz/8TJ2n4REhxgB9tLSGZ+FALRaw+5Kw/JZHpnUqJ0Oj4EQpND+h05
	sjGzf5NXhXHkGKAhw6GAd7NgY+itta3tFSpIIAc1Jnv1YW45wxNxKTFPIBQBiSKc
	tq0S9p6x1MijA6CGSY7ostYXzqN5lBjPT5ouOweAIalkef1rkZg+szEs3ec15Jdv
	w==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id L3UaJNMZ3xqh; Thu, 30 Apr 2026 18:22:18 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4g62Zc4B8Yzm1W1N;
	Thu, 30 Apr 2026 18:22:16 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Marco Elver <elver@google.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Juergen E. Fischer" <fischer@norbit.de>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v2 10/56] scsi: aha152x: Prepare for enabling lock context analysis
Date: Thu, 30 Apr 2026 11:19:40 -0700
Message-ID: <20260430182130.1978347-11-bvanassche@acm.org>
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

Annotate is_complete() with __context_unsafe() because it performs
conditional locking.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/aha152x.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/aha152x.c b/drivers/scsi/aha152x.c
index e3ccb6bb62c0..c16dcb9274eb 100644
--- a/drivers/scsi/aha152x.c
+++ b/drivers/scsi/aha152x.c
@@ -2319,6 +2319,7 @@ static void rsti_run(struct Scsi_Host *shpnt)
  *
  */
 static void is_complete(struct Scsi_Host *shpnt)
+	__context_unsafe(conditional locking)
 {
 	int dataphase;
 	unsigned long flags;
