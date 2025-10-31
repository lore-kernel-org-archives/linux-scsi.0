Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96304325701
	for <linux-scsi@vger.kernel.org>; Fri, 31 Oct 2025 20:40:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761943253; cv=none; b=i9v8AYHdbj1/Qjfyb05va69J9uiThuOwXnobcUVTPkf+fi9y/1SKDOUvXrvM+Nm+2FwVwBJTiFr/3IRQ4saDG4dmdWQlTz178UbctNDLSiR5yvKfdgS7V8QbTBlxT3uioPjw2gyW/gAXJ/sWn3jUIy1wACQCePwAJioeAttsIAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761943253; c=relaxed/simple;
	bh=XW9yJoCWbcWa/h0L1URy7TuJj9bKlbmA3WTm8OvanDg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UHumnjAKhnFQQ6+i6Ll6sT7BaAX/UDbVNS5GTi/aLMQPVTIJXrNBa9cMR6aw7fXBXTDs7GMe02rsVN1mgH9zqkrfG0+cXnAmeKERFkyHB+9nNASeruAD+Ni1hT4S+gU4SSlaelwXqqHd9dOtIJft+CIgM6hwqPezWnpn2MPQz7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=O+KWBdti; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="O+KWBdti"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4cytD242qNzm0pKx;
	Fri, 31 Oct 2025 20:40:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1761943249; x=1764535250; bh=V3STg
	pz8dXXKgsE/3OTbi1egPdkZS6LtQRl/zBuJfcI=; b=O+KWBdtib3jPuIge9h0B2
	k1b8yzRJuUQs8UaYPY0pkf0MgT9J9mWUdZ+0tNLRPgPTzUq9ZbRWmpLcO+d5tcGd
	V/ZwPLkHhw6ZhJPI0ikSd+4PoltX4F5XvQcCcH3V4Lz54vLLeYiKm+cW7OadTYiq
	qgKCowhfPJvj9Rm1ht/GaDA/4WVz+nPKH5y2ARTH/VgBYEY4hUEbyC3ZklP0sYIv
	IVu5V7TAmyA4wYRMH4KWJ0WyiNqOoTd1UuzhxC+joEhhV/kH6wsvEPfikPQmEene
	Q5gb8peUY9XqDyp1J7ScBQL4BGZQIg3oZpTDn60FxAwbmi6Z5gweNPW7UFN/6d83
	g==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id l_rzAN2hdyg5; Fri, 31 Oct 2025 20:40:49 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4cytCw3CHNzm0pKm;
	Fri, 31 Oct 2025 20:40:43 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Hannes Reinecke <hare@suse.de>,
	John Garry <john.g.garry@oracle.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v8 01/28] scsi: core: Support allocating reserved commands
Date: Fri, 31 Oct 2025 13:39:09 -0700
Message-ID: <20251031204029.2883185-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.51.1.930.gacf6e81ea2-goog
In-Reply-To: <20251031204029.2883185-1-bvanassche@acm.org>
References: <20251031204029.2883185-1-bvanassche@acm.org>
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
index eb224a338fa2..8b7f5fafa9e0 100644
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
