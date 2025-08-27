Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E77624C6C
	for <linux-scsi@vger.kernel.org>; Wed, 27 Aug 2025 00:08:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756253330; cv=none; b=KaiGZetWhCkZXTDgN4rhkkATSCXB83XOfu91Qocz/xAbRGeTAZnW0HHtUdmfwGl/8AxjDqpntP/jmTBKUtdDrt8fbG1nl7ks9G/929jvcCdd8IY4yTtm1yPq37E+2pYfbJc+iDkbprXbXZD4ccDwwtXyjPVJ3hm4EpSk7j9WJoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756253330; c=relaxed/simple;
	bh=rv9VV3fj3vSL+/BDc2VgY3r9gufeLZL62Nh/89ada6U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QXaxqpNMh1a6jkG2EXdmlMNb6tGR6hHD2rs1rtTdfR5VEbu5Ku5ucFhTfQc86i/R99/8aB5OnMZ36TF05ves700xaF2dqmYSgeQkjJP3xttCj9xL3aiyCcgduKvGm41jQjpeRGEx5yxFKRJTXCdxlREi5LvRGbMGZz+y1Xa83W4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=Hab3/k2E; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="Hab3/k2E"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4cBPyR6lcTzm174B;
	Wed, 27 Aug 2025 00:08:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1756253326; x=1758845327; bh=wr1gV
	o8BUs8klCO6FwO4gXcU8l6j8NWOpJLCFBJT69o=; b=Hab3/k2E6M98Gje0Jq2xq
	LeiA/nJR4qh3bGkHuWr417EbXekD+0ZnhFbOxPOk4zbBc/lKE+cxPyIj6Wieiw9m
	JHWZIGclZL4uHor5mkophdqEkPBTTdOvucZHAE+7K8jxQ3ZdnOUzcD3skmjE+jpI
	pj1+MG7GzA2M2lDstSaBHFsD4JU/sfS1jfNTPJR9cpmBBRaBs5hgwTdIeacUazNt
	1jJQJXlKL1sj7EXPiL1J8XRXWTXSZyUV56SpC4YngqCX1kjlQOIxiu6DVxKufBms
	APsJ+VMFUx5aGitC3spRKOmaYA8abpm6Apf4/iXyulreYJc+WRFMTv+NrIlSIPx0
	A==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id EhN3Zw02_WkZ; Wed, 27 Aug 2025 00:08:46 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4cBPyM05Q8zm0yQq;
	Wed, 27 Aug 2025 00:08:42 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Hannes Reinecke <hare@suse.de>,
	John Garry <john.g.garry@oracle.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v3 01/26] scsi: core: Support allocating reserved commands
Date: Tue, 26 Aug 2025 17:06:05 -0700
Message-ID: <20250827000816.2370150-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.51.0.261.g7ce5a0a67e-goog
In-Reply-To: <20250827000816.2370150-1-bvanassche@acm.org>
References: <20250827000816.2370150-1-bvanassche@acm.org>
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
  following statement: "if (sdev->host->nr_reserved_cmds)
  flags |=3D BLK_MQ_REQ_RESERVED;". See also
  https://lore.kernel.org/linux-scsi/20210503150333.130310-11-hare@suse.d=
e/ ]
Cc: John Garry <john.g.garry@oracle.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/hosts.c     |  3 +++
 drivers/scsi/scsi_lib.c  |  3 ++-
 include/scsi/scsi_host.h | 22 +++++++++++++++++++++-
 3 files changed, 26 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index cc5d05dc395c..d7091f625faf 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -499,6 +499,9 @@ struct Scsi_Host *scsi_host_alloc(const struct scsi_h=
ost_template *sht, int priv
 	else
 		shost->dma_boundary =3D 0xffffffff;
=20
+	if (sht->nr_reserved_cmds)
+		shost->nr_reserved_cmds =3D sht->nr_reserved_cmds;
+
 	device_initialize(&shost->shost_gendev);
 	dev_set_name(&shost->shost_gendev, "host%d", shost->host_no);
 	shost->shost_gendev.bus =3D &scsi_bus_type;
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
index c53812b9026f..722ecbee938e 100644
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
+	 * @can_queue to calcumate the maximum number of simultaneous
+	 * commands sent to the host.
+	 */
+	int nr_reserved_cmds;
+
 	/*
 	 * In many instances, especially where disconnect / reconnect are
 	 * supported, our host also has an ID on the SCSI bus.  If this is
@@ -611,6 +620,11 @@ struct Scsi_Host {
 	unsigned short max_cmd_len;
=20
 	int this_id;
+
+	/*
+	 * Number of commands this host can handle at the same time.
+	 * This excludes reserved commands as specified by nr_reserved_cmds.
+	 */
 	int can_queue;
 	short cmd_per_lun;
 	short unsigned int sg_tablesize;
@@ -631,6 +645,12 @@ struct Scsi_Host {
 	 */
 	unsigned nr_hw_queues;
 	unsigned nr_maps;
+
+	/*
+	 * Number of reserved commands to allocate, if any.
+	 */
+	unsigned int nr_reserved_cmds;
+
 	unsigned active_mode:2;
=20
 	/*
