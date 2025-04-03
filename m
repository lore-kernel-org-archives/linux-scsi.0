Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 498AC19D065
	for <linux-scsi@vger.kernel.org>; Thu,  3 Apr 2025 21:19:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743715202; cv=none; b=Vh4eWaoNwxQkVXkssoaO+K2c2n7cdyzNqiyqbowVKNDI5r+dPN59ixSIiKqTI2POYTkr4WwY9vkf44uOAPIO4H60xINC88Hxp9wDzeT2bIiHpWbe6/8kQwdCR2Hw3FrWngrZ9uJKlTH54dy0H4bCjGRtDMb8Q//vFqwKKFmjubs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743715202; c=relaxed/simple;
	bh=aLKrEGkdu8qkM80iPwJ96qInXcmFJZ5fhQoB6GHg4dg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VtsFu6c90kaUWDUls+60+AkN5yW3vJwTgVUYCnkarSTm+rFNkk9yZJryrHUwFh5HgBTShPTmRsKI8N0wqDkVhWiZkOh+viH4Uc2/mF6rQMhUflwwYT0FXbaAtl2ZvtsZXyID+3prwoJcMjTrzBkJsQJxRSthpFUemkNfz7fyNB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=4XLGALtK; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="4XLGALtK"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4ZTF4b1jhkzm0yQB;
	Thu,  3 Apr 2025 21:19:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1743715197; x=1746307198; bh=+LNiJ
	IkXS4qHzIIC/MRpdEnHE3PKREXliZ1yMFmbWmE=; b=4XLGALtKRV6sVFxajSHdQ
	hiAmh5DR/vVOy1DtT+S5JtyczgT+ahy1/RSSeRsVGe7Jqy5kv4C6GNYEWNai3Flj
	i5cIcBXu0UNZta4E1YWNmt1Fxls7oWSKPsg5dOnfjxo0rMTzy+5GWR0GzXuZY5td
	6c2ZVMRKL0jOCMyTeWN50OxAnJ63tLeIFrIbbcAKYM9m0ADn4KMrmoxiy36uZd6f
	EmDGf2gKGz5FS8hZ+/eU/zQFDsfYpBz3bzfkXrIlvdgRJ+lKQF9zM9LeKWWUtvbO
	/SX9JKT2ux+t68jsmsRlw2KIrqMnD1cSWaFJbEJ4ytNE4QEkNKDqgTayzKMPveJ+
	w==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id vrHm4tEtbLJN; Thu,  3 Apr 2025 21:19:57 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4ZTF4S5ycKzm0yV3;
	Thu,  3 Apr 2025 21:19:52 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Hannes Reinecke <hare@suse.de>,
	John Garry <john.g.garry@oracle.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH 02/24] scsi: core: Make scsi_cmd_priv() accept const arguments
Date: Thu,  3 Apr 2025 14:17:46 -0700
Message-ID: <20250403211937.2225615-3-bvanassche@acm.org>
X-Mailer: git-send-email 2.49.0.504.g3bcea36a83-goog
In-Reply-To: <20250403211937.2225615-1-bvanassche@acm.org>
References: <20250403211937.2225615-1-bvanassche@acm.org>
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
