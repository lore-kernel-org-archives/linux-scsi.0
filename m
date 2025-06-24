Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3428B3074B5
	for <linux-scsi@vger.kernel.org>; Tue, 24 Jun 2025 21:06:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750799180; cv=none; b=poFqEqBSL/jSfj93PYq2tzMKjnkzkkxz5V40WY4sCi+yRw5Ne/vk7egFQJts0XwfGumyrFjYinkA4UR744rjq7x8rBtmxeao9DyqTTYekFAA8UtLT3lfSb25XSjSVWmOspR3bsH0MjhjbAkuRTnhY1DdA0ryBtP9Tc3qZVwUPdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750799180; c=relaxed/simple;
	bh=aLKrEGkdu8qkM80iPwJ96qInXcmFJZ5fhQoB6GHg4dg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wbl3s0wkxTrj12SfSpzNEjTRlV2Hqc2FFj+uI0s99Ctq1rCVUmRySVyp35VnQonL56MdBgR5w9n01bFWu8TcLseatszt0cnhrZJrYvLrIM7W+VWOq+CdVwGZCADVNub3FJ/+BxD+MU75gApFxI+muFccR/8emdLwbdFCfr083/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=mfriqxea; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="mfriqxea"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4bRcty2DnDzm0pK8;
	Tue, 24 Jun 2025 21:06:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1750799176; x=1753391177; bh=+LNiJ
	IkXS4qHzIIC/MRpdEnHE3PKREXliZ1yMFmbWmE=; b=mfriqxeaTNoeuyRfg/CO6
	QoS0PPH3DGSkTDNcgpa1d7vAut2yAKnh6kLgpnsK0IIsGZV+Q2WhGX+zKyjhsjZZ
	CoyZS1fmziss5k6sGpzauxYGiQE3ouX313DjQMKisxngi4unjfOZxzgmANOgF6wH
	dKn4WSYZ92LsKEBLXw7A6DmLAP1nLeb3R1hLEYRKGxc34jGywlWAV1U8Ll/GAfOA
	kw2MclzzZ0moPt1qKWxPVlLhgGG4Z6aNWVkm6qO9QuVJezscauPRATPve7O3O8yC
	WE19jPzFtMwXTa/ooBIbNj3Ks0iLi/xlJ3xl83jnucyxMVQ+mxgG28d0hSNvgpGh
	Q==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id WF-rRRtJcWep; Tue, 24 Jun 2025 21:06:16 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4bRcts2CVWzm0yQk;
	Tue, 24 Jun 2025 21:06:12 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Hannes Reinecke <hare@suse.de>,
	John Garry <john.g.garry@oracle.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH 2/3] scsi: core: Make scsi_cmd_priv() accept const arguments
Date: Tue, 24 Jun 2025 14:05:39 -0700
Message-ID: <20250624210541.512910-3-bvanassche@acm.org>
X-Mailer: git-send-email 2.50.0.714.g196bf9f422-goog
In-Reply-To: <20250624210541.512910-1-bvanassche@acm.org>
References: <20250624210541.512910-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Instead of requiring the caller to cast away constness, make
scsi_cmd_priv() accept const arguments.

Cc: Hannes Reinecke <hare@suse.de>
Cc: John Garry <john.g.garry@oracle.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 include/scsi/scsi_cmnd.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index 154fbb39ca0c..09176b07e891 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -154,10 +154,10 @@ struct scsi_cmnd {
  * Return the driver private allocation behind the command.
  * Only works if cmd_size is set in the host template.
  */
-static inline void *scsi_cmd_priv(struct scsi_cmnd *cmd)
-{
-	return cmd + 1;
-}
+#define scsi_cmd_priv(cmd)                                         \
+	_Generic(cmd,                                              \
+		const struct scsi_cmnd *: (const void *)(cmd + 1), \
+		struct scsi_cmnd *: (void *)(cmd + 1))
=20
 void scsi_done(struct scsi_cmnd *cmd);
 void scsi_done_direct(struct scsi_cmnd *cmd);
