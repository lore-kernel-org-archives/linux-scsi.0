Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EAC430648B
	for <linux-scsi@vger.kernel.org>; Tue, 14 Oct 2025 20:18:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760473095; cv=none; b=XEtT8FzmdNFFPWidnWmOL6lcwu6MikumlFhljv561VnP9me1mWxPHWAcOKBL6IXa30GuTUvvsIdXmKaCA5FxLA1OJIjMSqUgoX9xbdOUcLqpzczMnAzjBAo2RVJLUZp6okaecSdV2phP+9BC4l1gHauVWKoyQGMpq3TebQmgRkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760473095; c=relaxed/simple;
	bh=fQzvclpi0sWBMO27IdabX0Kw4tU5DihbhSUxf2wguH0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jUXGPyXAyhF8IDgOEot2/2Iny6RZ8tVcIucIku9th/EFNOYLSCIBePQD9sM2KWilKJFq2YfGFLT5y2SMirmbgwEa0TpcmLAhwqrKyM85N1INK7OOLSBr1SRJI+UOAvWxfswFNt7HTWLuugXrOGZKK9SUife7jkvfExGPbe/WU/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=uKlM9mNv; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="uKlM9mNv"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4cmQWm11zmzm0yVW;
	Tue, 14 Oct 2025 20:18:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1760473090; x=1763065091; bh=kT+QU
	lWEwC1HbFSBuK/uEre+euvjhxI6i863ZwY7x9Q=; b=uKlM9mNvEtP6gDw2zoWin
	Y26iHVJ1gkwnhytX6ptAYJn+OYyevMLcVbf8Rn8uGr+LnrlmLcu1JhCX7R7L7wiy
	Vnjp/tIdehSNGJb5uq+zsId7DVLxpI1XsPLVWq8qOpWLFEfhlLEWykum66sT+ceq
	xs6gR/Gx+rhVWqmiJNVmMldpULdQqj3yAxp6SjIhPMOJl+31eMqNCxyJuUAbww++
	fsCCEGqSkyIxD/gX//YadFsiX5NBL0srulD9WYzsb4M3t7wWz5ETRhs5LfySoitl
	gPWN5ZBpg7p02OexJW3VsB8ZOl3kp/dOhSkz3IxbcD9XVXiPzz1Yi9a/VmeNto0Q
	Q==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id TIdSFuz6jRiV; Tue, 14 Oct 2025 20:18:10 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4cmQWd4DxFzm0yVJ;
	Tue, 14 Oct 2025 20:18:04 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Hannes Reinecke <hare@suse.de>,
	John Garry <john.g.garry@oracle.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v6 01/28] scsi: core: Support allocating reserved commands
Date: Tue, 14 Oct 2025 13:15:43 -0700
Message-ID: <20251014201707.3396650-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.51.0.788.g6d19910ace-goog
In-Reply-To: <20251014201707.3396650-1-bvanassche@acm.org>
References: <20251014201707.3396650-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

From: Hannes Reinecke <hare@suse.de>

Quite some drivers are using management commands internally. These
commands typically use the same tag pool as regular SCSI commands. Tags
for these management commands are set aside before allocating the
block-mq tag bitmap for regular SCSI commands. The block layer already
supports this via the reserved tag mechanism. Add a new field
'nr_reserved_cmds' to the SCSI host template to instruct the block layer
to set aside a tag space for these management commands by using reserved
tags. Exclude reserved commands from .can_queue because .can_queue is
visible in sysfs.

Signed-off-by: Hannes Reinecke <hare@suse.de>
[ bvanassche: modified patch title and patch description. Left out the
  following statements: "if (sht->nr_reserved_cmds)" and also
  "if (sdev->host->nr_reserved_cmds) flags |=3D BLK_MQ_REQ_RESERVED;". Mo=
ved
  nr_reserved_cmds declarations and statements close to the
  corresponding can_queue declarations and statements. See also
  https://lore.kernel.org/linux-scsi/20210503150333.130310-11-hare@suse.d=
e/ ]
Reviewed-by: John Garry <john.g.garry@oracle.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/hosts.c     |  1 +
 drivers/scsi/scsi_lib.c  |  3 ++-
 include/scsi/scsi_host.h | 21 ++++++++++++++++++++-
 3 files changed, 23 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index cc5d05dc395c..9bb7f0114763 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -436,6 +436,7 @@ struct Scsi_Host *scsi_host_alloc(const struct scsi_h=
ost_template *sht, int priv
 	shost->hostt =3D sht;
 	shost->this_id =3D sht->this_id;
 	shost->can_queue =3D sht->can_queue;
+	shost->nr_reserved_cmds =3D sht->nr_reserved_cmds;
 	shost->sg_tablesize =3D sht->sg_tablesize;
 	shost->sg_prot_tablesize =3D sht->sg_prot_tablesize;
 	shost->cmd_per_lun =3D sht->cmd_per_lun;
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index d7e42293b864..d52bbbe5a357 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2083,7 +2083,8 @@ int scsi_mq_setup_tags(struct Scsi_Host *shost)
 		tag_set->ops =3D &scsi_mq_ops_no_commit;
 	tag_set->nr_hw_queues =3D shost->nr_hw_queues ? : 1;
 	tag_set->nr_maps =3D shost->nr_maps ? : 1;
-	tag_set->queue_depth =3D shost->can_queue;
+	tag_set->queue_depth =3D shost->can_queue + shost->nr_reserved_cmds;
+	tag_set->reserved_tags =3D shost->nr_reserved_cmds;
 	tag_set->cmd_size =3D cmd_size;
 	tag_set->numa_node =3D dev_to_node(shost->dma_dev);
 	if (shost->hostt->tag_alloc_policy_rr)
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index f5a243261236..7b8f144ccf7d 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -375,10 +375,19 @@ struct scsi_host_template {
 	/*
 	 * This determines if we will use a non-interrupt driven
 	 * or an interrupt driven scheme.  It is set to the maximum number
-	 * of simultaneous commands a single hw queue in HBA will accept.
+	 * of simultaneous commands a single hw queue in HBA will accept
+	 * excluding internal commands.
 	 */
 	int can_queue;
=20
+	/*
+	 * This determines how many commands the HBA will set aside
+	 * for internal commands. This number will be added to
+	 * @can_queue to calculate the maximum number of simultaneous
+	 * commands sent to the host.
+	 */
+	int nr_reserved_cmds;
+
 	/*
 	 * In many instances, especially where disconnect / reconnect are
 	 * supported, our host also has an ID on the SCSI bus.  If this is
@@ -611,7 +620,17 @@ struct Scsi_Host {
 	unsigned short max_cmd_len;
=20
 	int this_id;
+
+	/*
+	 * Number of commands this host can handle at the same time.
+	 * This excludes reserved commands as specified by nr_reserved_cmds.
+	 */
 	int can_queue;
+	/*
+	 * Number of reserved commands to allocate, if any.
+	 */
+	unsigned int nr_reserved_cmds;
+
 	short cmd_per_lun;
 	short unsigned int sg_tablesize;
 	short unsigned int sg_prot_tablesize;
