Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D747132A3EC
	for <linux-scsi@vger.kernel.org>; Wed, 24 Sep 2025 20:35:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758746128; cv=none; b=CVSr4LLHWeq/kvA4m/vA/YtUrEB1G5w3nJH9ffK2fZl6/6fLGjazt0fWIrFeJt7VtEALf4J2HSyzGaZBQorzQaYln1MC50P+t9Ae0zX9Rp4vG/lJsOQ+STIoJnc4ZD28NwxhlqftKc2KQgGerPX42E4vKcm/vt/sN6ezqKDrsCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758746128; c=relaxed/simple;
	bh=4WJTkDCR4zJK+RPvPP5WAkd3lGQ2HFGK0857HKe2gG4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PLaX4KFJ4ccgwlxhrQk5Sf0W9H7fveLTAXYvHfwxUzwkAL/Pn4UHJHh8gqDtEFBilC345kzbb97hg1iF4E5r/AVJ1ocDEW4mUZKqmcB0MZGSBsZNiYcluExlxNoCsw3dK7Utqx4XDwEGHqZRu9P1SYpR2R7BjI5AIjuprkaL+Us=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=jMlhBMjT; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="jMlhBMjT"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4cX7mz4pZnzlgqxn;
	Wed, 24 Sep 2025 20:32:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1758745922; x=1761337923; bh=w4IGV
	yt2ZryuwB6AoPct6pLrk4xyQ98jPpBniikmNsU=; b=jMlhBMjTcmjxoucsWoV8j
	vi5CjyPLqCVmNoXlxZ6IwmuP+k6nTm5+CW2wLlBx4pjbrz3qiuwOIJR/NC3VHvlY
	W+8r0YzBqQdDyZjXp14P/n89dVrWfoAGKvCPZca7T6calNfZrhGcdiaxHDCZ7gB6
	k5fFMa4PlNiuv7U+jvz7gwXSH3VBZwC/cMS2jUTLex+4AucrZTlT9f2WNBGbfuu7
	YkHhb+9k3bvU2Paw/jbhGF5aJ14lMS8goyFLeFQU+aL6SxnOSXYasxK3ttCFrpac
	MMoLrSPLI1TE2ZDeF7W/jsErGmHXVIcnJPSOM8S5QoFJJAspig+aCZq6YG303KvF
	A==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id Trp4SDF-YqLu; Wed, 24 Sep 2025 20:32:02 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4cX7mt4Bv8zlgqxl;
	Wed, 24 Sep 2025 20:31:57 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Hannes Reinecke <hare@suse.de>,
	John Garry <john.g.garry@oracle.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v5 01/28] scsi: core: Support allocating reserved commands
Date: Wed, 24 Sep 2025 13:30:20 -0700
Message-ID: <20250924203142.4073403-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.51.0.536.g15c5d4f767-goog
In-Reply-To: <20250924203142.4073403-1-bvanassche@acm.org>
References: <20250924203142.4073403-1-bvanassche@acm.org>
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
