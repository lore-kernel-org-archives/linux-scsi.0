Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3869D311C16
	for <linux-scsi@vger.kernel.org>; Mon, 11 Aug 2025 17:38:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754933881; cv=none; b=CMzheyu29pYEO0JT8LRh4Fa8mbVO/sR8HK+Z5sOcXEB2Rf2jl5VYCutWSy2CinRmRzaRiKh3ceWAaaXCv+f0dWyQf8B0GzVd2dTJXeGD7XwfyWsngDCZ4uijtijBvAXYxYM25slS1bMDmwMMp1/lcw7UrruFg8vxtLhTYIJpi5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754933881; c=relaxed/simple;
	bh=OfGLAhnVTsVQhgsEsrgTd2aHAjbcdtpVdUBAVQwUIMQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=em0F6BX3HdI0O8C2XymRBEJPwAE68IaTODzPAOp1hxZGyQApfaVSnwWjyO47Kun2hOscLb+0uzCiu9JY4I/sX2IZfgaSiAUqOjNGyLc4VCfOza+AWtszFXnyzwql0dJD6T1JMPmLlp5XJrUTAaHDimLgEh0the4ATNcjY9sKuGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=xT3yca7g; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="xT3yca7g"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4c120R42BPzlgqV4;
	Mon, 11 Aug 2025 17:37:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1754933878; x=1757525879; bh=4uZJq
	j/f+UFZXjTkMZwlNexflJd8cG+puW7NCQjGAlU=; b=xT3yca7gdg9lRNP+XOKbj
	a838tVYqk1Irym0rcLh7JSCDV9ZVJT+4CiVCXOj0IHj5OjqO3NfEKIEKTzEWebv5
	UxExUQNWKNPBsZUjYMdbxnfktHKlLW/Mr0XTdj/Wr77jlkl2KIQ+dhy3L+fOm7Lp
	AMFSnT27Q16v9JfFYSQQ3+x9KvbdOaIcBfZB20NuEdabKtkOe1yRJNH11trIiLKc
	ubW0BJ4+GBuPym7Oq3F5OlYWrERJcTI09p+aOwzGeT+1pYehfFe14XJ5XJX/9yJd
	qh2wXWPgXFE18XS8bd+dyMllCIwcW86SI7v4SGhTv2KuErzAmFTNE6CE1jec8Qgt
	w==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id jq1CpLKqPtCm; Mon, 11 Aug 2025 17:37:58 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4c120N0b0szlgqV3;
	Mon, 11 Aug 2025 17:37:55 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v2 06/30] scsi_debug: Set .alloc_pseudo_sdev
Date: Mon, 11 Aug 2025 10:34:18 -0700
Message-ID: <20250811173634.514041-7-bvanassche@acm.org>
X-Mailer: git-send-email 2.51.0.rc0.155.g4a0f42376b-goog
In-Reply-To: <20250811173634.514041-1-bvanassche@acm.org>
References: <20250811173634.514041-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Make sure that the code for allocating a pseudo SCSI device gets triggere=
d
while running blktests.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_debug.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 353cb60e1abe..620560c2676c 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -9463,6 +9463,7 @@ static const struct scsi_host_template sdebug_drive=
r_template =3D {
 	.module =3D		THIS_MODULE,
 	.skip_settle_delay =3D	1,
 	.track_queue_depth =3D	1,
+	.alloc_pseudo_sdev =3D	1,
 	.cmd_size =3D sizeof(struct sdebug_scsi_cmd),
 	.init_cmd_priv =3D sdebug_init_cmd_priv,
 	.target_alloc =3D		sdebug_target_alloc,
