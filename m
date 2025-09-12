Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DE6C324B25
	for <linux-scsi@vger.kernel.org>; Fri, 12 Sep 2025 18:24:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757701498; cv=none; b=l/Pj1f6u/a/km2kEFD0RxZr7hYl2kgRyqebW2Qqs5rbg3qha6iLit6lmMDVxKq6Kge2wR6HE/2x9Yy5IwEcUiXp7hte7SNMAUSt4Uo8nRIECFodgbwZhreltQhv9mMGuUVFEdti1/m0WrYUQjLPBkMke94o2pwBYeFb/KhMcu78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757701498; c=relaxed/simple;
	bh=4WJTkDCR4zJK+RPvPP5WAkd3lGQ2HFGK0857HKe2gG4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MJ8exXFH1oMJcIPmZC9SnWa0uAjsS2aRLNeOwTPC+g538CuHqSuUpYYzC8ue3PdZqNtp9Iq5kTyXnPaxAwuFL0CwoOHGIXnV4oFv1AlJoMXs8uijL2+R/awImYKZkvUweN3/ACYnyk1FdH6foVZ1QtjH/4nodT7DBxJjqiBE7vg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=h/sMUtjt; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="h/sMUtjt"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4cNjWk0yJFzltKGh;
	Fri, 12 Sep 2025 18:24:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1757701488; x=1760293489; bh=w4IGV
	yt2ZryuwB6AoPct6pLrk4xyQ98jPpBniikmNsU=; b=h/sMUtjtCYe3cu5nCuLzw
	xAtyEheiCFxNgLPPj05QOC1xIjDgX9Bu+evY1LrDFuzOrOLhcOlIhW7NLVqouiGA
	m5Rt+UXQdVf1ipVEHBnNL+3rLS/4BZcWGJ6X1fPSz1WPfASWR8j/R27whDrt8BQ/
	O77zxXCRP+7Ijb7sOO4JsQ+CKey5/UhZcrePIAHvBHxpnwQlAxHyClLqGFvpVIbR
	Mk5ujebdu12v72UVIiYaQF4ElD5b+SNA96umUbAAMV+AiyASiuR83u0VktLOo69b
	W169jSgwZelBJBciWW6YAen0oo9C0fNn7f2ep7T2RAgZ9OLP0qZkn2tt7kyUPUd+
	w==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id oq0aoKzuwyaS; Fri, 12 Sep 2025 18:24:48 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4cNjWd0z2lzltPt1;
	Fri, 12 Sep 2025 18:24:44 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Hannes Reinecke <hare@suse.de>,
	John Garry <john.g.garry@oracle.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v4 01/29] scsi: core: Support allocating reserved commands
Date: Fri, 12 Sep 2025 11:21:22 -0700
Message-ID: <20250912182340.3487688-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.51.0.384.g4c02a37b29-goog
In-Reply-To: <20250912182340.3487688-1-bvanassche@acm.org>
References: <20250912182340.3487688-1-bvanassche@acm.org>
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
index 0c65ecfedfbd..9c67e04265ce 100644
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
index c53812b9026f..91eb3f52b3d0 100644
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
