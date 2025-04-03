Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFAA41A5BB7
	for <linux-scsi@vger.kernel.org>; Thu,  3 Apr 2025 21:20:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743715223; cv=none; b=GXfq02aBRXDV4BYRVTDtHxv+RZbuBmas09Q5MRCOhCQZx8wln5850im+0NrtpgSP/d29f0LSDnTK66KU0wabvRkDbNXqKlUXmflImCck8wsTmWt6lReEP13Gda8Zu2qbxx2PupfO7Obq6JvYolcgRFpRyhDWoIHXVGpMfewiMU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743715223; c=relaxed/simple;
	bh=l7bahxjjFn52/GRRy0XmnBSBryAOooc8c50W1mFeRaM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RP6vfPg6MdkJN/G1kDASmUT6WwvNpi8h7qrO6Vr6rU5UR0dNweWf8TMugYVuSz1/WdW9a+jRi2AnwZQOu+Bh2wnnIIE3fSoh2zK6HL4N+Ew/HU9ors92IztOzvxLWesdF7mldEyrHtkuG1/DAOJIf+mzRkbmXvcdEt27PmQ5mfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=2lTCWXuj; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="2lTCWXuj"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4ZTF504nZmzm0yVH;
	Thu,  3 Apr 2025 21:20:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1743715219; x=1746307220; bh=doclx
	i2zZq/vXe9EL1W2lGKklo8DcYSnP8VS7Rulrx0=; b=2lTCWXujgY/fohxmXu0Bu
	exhZjnfi16dKLqXr4cUe5/h35k01fLCFadyXJf/X6OmxLuUMn7PJSVpcZ6/2oAqP
	dGj5HY+2I0tt9cCvdSkXoBvjnRa8NZt0AqZxVBDttoNXzQ2u0FUa8kH1Cu+e2Vy7
	4HM9bZToDtJZ5iJo7/ZWVa7gWo23amtkG6IhCbCuW0kOuRhXImenBGqrHMbRfmHi
	SxWzWcC0lR1FRqHxA3PaFHDbNzOuu9CAGA5KXZkQdFM95dOk+NS1c/HHleEeQqXH
	1Quhivaz/TidXvk9Mmkc7G+zX7W9L5Af6H1j89tN9ca76QeNYx2h/OsNtzeJVFo/
	A==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id EP4_O1DRTIlN; Thu,  3 Apr 2025 21:20:19 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4ZTF4t3pBLzm0yV3;
	Thu,  3 Apr 2025 21:20:13 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Hannes Reinecke <hare@suse.de>,
	John Garry <john.g.garry@oracle.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH 05/24] scsi: core: Introduce scsi_host_update_can_queue()
Date: Thu,  3 Apr 2025 14:17:49 -0700
Message-ID: <20250403211937.2225615-6-bvanassche@acm.org>
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

The UFS host controller driver must submit a QUERY REQUEST command to the
UFS device to query the queue depth supported by the device (bQueueDepth)=
.
If the same infrastructure is used for allocating a QUERY REQUEST command
as for SCSI commands then .can_queue must initially be set to a low value
and increased once the queue depth is known. Hence this patch that adds a
function that modifies .can_queue.

Cc: Hannes Reinecke <hare@suse.de>
Cc: John Garry <john.g.garry@oracle.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi.c      | 26 ++++++++++++++++++++++++++
 include/scsi/scsi_host.h |  2 ++
 2 files changed, 28 insertions(+)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 53daf923ad8e..602cc32f139f 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -198,6 +198,32 @@ void scsi_finish_command(struct scsi_cmnd *cmd)
 	scsi_io_completion(cmd, good_bytes);
 }
=20
+/**
+ * scsi_host_update_can_queue - Modify @host->can_queue
+ *
+ * @host->__devices must be empty and I/O must have been quiesced before=
 this
+ * function is called.
+ */
+int scsi_host_update_can_queue(struct Scsi_Host *host, int can_queue)
+{
+	struct blk_mq_tag_set prev_set;
+	int prev_can_queue, ret;
+
+	if (!list_empty(&host->__devices))
+		return -EINVAL;
+
+	prev_can_queue =3D host->can_queue;
+	prev_set =3D host->tag_set;
+	host->can_queue =3D can_queue;
+	ret =3D scsi_mq_setup_tags(host);
+	if (ret) {
+		host->can_queue =3D prev_can_queue;
+		return ret;
+	}
+	blk_mq_free_tag_set(&prev_set);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(scsi_host_update_can_queue);
=20
 /*
  * 4096 is big enough for saturating fast SCSI LUNs.
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 2c0f5ec1046e..7b6aa36eac8a 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -830,6 +830,8 @@ extern void scsi_block_requests(struct Scsi_Host *);
 extern int scsi_host_block(struct Scsi_Host *shost);
 extern int scsi_host_unblock(struct Scsi_Host *shost, int new_state);
=20
+int scsi_host_update_can_queue(struct Scsi_Host *host, int can_queue);
+
 void scsi_host_busy_iter(struct Scsi_Host *,
 			 bool (*fn)(struct scsi_cmnd *, void *), void *priv);
=20
