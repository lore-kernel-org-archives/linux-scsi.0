Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88284311C16
	for <linux-scsi@vger.kernel.org>; Mon, 11 Aug 2025 17:37:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754933879; cv=none; b=BSJS9OCjsd20smRr1asRhVGZhYHqjV76P2jLqwZx2ZZGz6BMSQTUdGdoBUWfpDtx7khGQuihn/zY64YA1XW1JKcLjroymE2p2fvp7iKz0m4nmP9hObPTahUlTgWcy85OFaIeuDrvae5U6sjNS0UpREQhwf7b3xhLQ+m7q7lP5oc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754933879; c=relaxed/simple;
	bh=lRFvwfJ1qpg1tojWUPiH0ebvwNygiD+vEvHmYQNf/F0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bhDSPuoC3dbObxPacyBqjHUu9wYncEpI475pbaOhdpUOgS00dJyv6UhwsiHs9yKmDHGs+2qWlJ7YyGJeGsCwb9LD3Zl//lqaYF2Lt1OpWFEfHE5Q2MNRDZw9+9hpRSOORqIgkBmrREDqTlDG1MWYnZEfzXokRbudb7ZRlrVec68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=pJmcI/hl; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="pJmcI/hl"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4c120N4qTszlgqxg;
	Mon, 11 Aug 2025 17:37:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1754933875; x=1757525876; bh=G3UHz
	Stfy5gBguUyUWQ94SGHMFSYx2K4Vxf1ASz/DkI=; b=pJmcI/hlacQNknb9yV7X4
	Do3meEkMIC8nFYYlX5Lq4Dh76YAnG9AkeBFrw6VQetvDIOZJfafcuPaa3hba3Hhq
	OtbpYvt+rC9LAj8SHNE7enDR6+heJHCegX2Zy4N7ivC8DAJZeZOi4EII2bOFL3Wf
	tNJtu9vR4krrbeHs4jsMEZfZz1glFzz2flfOL3+RTP30xa1j+zGNipirCd7M8u26
	sYqtdleK36pK2Tqokm62grX6qdvO3C+GkvNjZTOkqTEXv7Lilm2ArWbSynbdIPAa
	Y5A6trmDKQ9HGjQvgO0mHaTS9CAEtPjJSKL+cLo1QZOdkc6Pfroh5iFBouc7qUKf
	Q==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 9eTp5AiMVMHt; Mon, 11 Aug 2025 17:37:55 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4c120H3b4SzlgqV4;
	Mon, 11 Aug 2025 17:37:50 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Hannes Reinecke <hare@suse.de>,
	John Garry <john.g.garry@oracle.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v2 05/30] scsi: core: Introduce scsi_host_update_can_queue()
Date: Mon, 11 Aug 2025 10:34:17 -0700
Message-ID: <20250811173634.514041-6-bvanassche@acm.org>
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

If a SCSI driver must use reserved commands to discover the supported
queue depth then the queue depth must be initialized to a small value and
must be changed after the queue depth has been queried. Support such SCSI
drivers by introducing the function scsi_host_update_can_queue().

Cc: Hannes Reinecke <hare@suse.de>
Cc: John Garry <john.g.garry@oracle.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi.c      | 45 ++++++++++++++++++++++++++++++++++++++++
 include/scsi/scsi_host.h |  2 ++
 2 files changed, 47 insertions(+)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index a290c3aa7b88..3d3603b74d9f 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -198,6 +198,51 @@ void scsi_finish_command(struct scsi_cmnd *cmd)
 	scsi_io_completion(cmd, good_bytes);
 }
=20
+/**
+ * scsi_host_update_can_queue - Modify @host->can_queue
+ * @host:	SCSI host pointer
+ * @can_queue:	New value for @host->can_queue.
+ *
+ * @host->__devices must be empty except for the pseudo SCSI device and =
I/O
+ * must have been quiesced before this function is called.
+ */
+int scsi_host_update_can_queue(struct Scsi_Host *host, int can_queue)
+{
+	struct blk_mq_tag_set prev_set;
+	bool realloc_pseudo_sdev =3D false;
+	struct scsi_device *sdev;
+	int prev_can_queue, ret;
+
+	scoped_guard(spinlock_irq, host->host_lock)
+		list_for_each_entry(sdev, &host->__devices, siblings)
+			if (WARN_ON_ONCE(sdev !=3D host->pseudo_sdev))
+				return -EINVAL;
+
+	if (host->pseudo_sdev) {
+		realloc_pseudo_sdev =3D true;
+		__scsi_remove_device(host->pseudo_sdev);
+		host->pseudo_sdev =3D NULL;
+	}
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
+
+	if (realloc_pseudo_sdev) {
+		host->pseudo_sdev =3D scsi_get_pseudo_dev(host);
+		if (!host->pseudo_sdev)
+			return -ENOMEM;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(scsi_host_update_can_queue);
=20
 /*
  * 4096 is big enough for saturating fast SCSI LUNs.
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 3b5150759c44..dd967f35df33 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -837,6 +837,8 @@ extern void scsi_block_requests(struct Scsi_Host *);
 extern int scsi_host_block(struct Scsi_Host *shost);
 extern int scsi_host_unblock(struct Scsi_Host *shost, int new_state);
=20
+int scsi_host_update_can_queue(struct Scsi_Host *host, int can_queue);
+
 void scsi_host_busy_iter(struct Scsi_Host *,
 			 bool (*fn)(struct scsi_cmnd *, void *), void *priv);
=20
