Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C6472E62A6
	for <linux-scsi@vger.kernel.org>; Thu,  3 Apr 2025 21:20:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743715219; cv=none; b=RINTSLPKVMVXyRezvQxG2PZFFn9Meyg0hggJsDeznVIBJcMUYU83xogJ9GBh7933k2n96WWiJp3woy1kUABO4Y4s0dvuZa/Z/u7mlLAFlFmSPNcAcuHzYZgzVdK1vZ/huMzVCiUuoHOpeZ+VTbpXxUCGo5f+mHSrjOn7G0VdKQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743715219; c=relaxed/simple;
	bh=8u6aKBsRuvyyKw+KQPRIlUt7vDp0fsL80YTbySuoXiY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Coczc4s2GCIZSZm8JQUOw3jLT1VEch7wPqAGuqYD8RiYn0m7Q1u0+IBauU1NZV6JkK7eV90Zpr8/26fULhKCw09pQ+JwHLI1YJ1/AZ6vJilTdZEqeKoPf0XjZQa8C7kXGEWxW0KzyuuYcg5F17V5OvzC6mMcJOPIGP+z+JYkQBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=wCmXf6ft; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="wCmXf6ft"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4ZTF4t42lKzmWSLK;
	Thu,  3 Apr 2025 21:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1743715213; x=1746307214; bh=7U0nx
	JcXoFx0gPpz4DQBiBVkPHA5xxY45iObj9TF/Zo=; b=wCmXf6ftCnhwlaFrOk6qv
	GC6byuPmuETS/DlbwWyKrpVhOy6YTYVy03v+JUIfOmSSl+/gX4dAhpVMjlvl5mbn
	KaWUWfui+nYpGHMjv0Tvb8ZiUoSuxbl9QBzpOSY1aq7bjowCq9AnivHFhNPPMxo3
	LXZoUdRB5FPaNijzGxk3ZPtLnB6e4xc9TRRW/wTq/cosbsZ2Itd22dz0suPHwwoh
	7E0NuEsQBEE0k3pa2KLaQRas6HDt3rHQ97Cuzev0NWX9A8Mr2qju2tEF9pw+MhYF
	43E0k1bBBjL3xL1gSvx9BtiKCc+eKYBsEkMmKdSYzZx75kHu9LeJ18VfaKRWHXk8
	A==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id nwWmZwwnlr-s; Thu,  3 Apr 2025 21:20:13 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4ZTF4m22qqzmWSKc;
	Thu,  3 Apr 2025 21:20:05 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Hannes Reinecke <hare@suse.de>,
	John Garry <john.g.garry@oracle.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH 04/24] scsi: core: Implement reserved command handling
Date: Thu,  3 Apr 2025 14:17:48 -0700
Message-ID: <20250403211937.2225615-5-bvanassche@acm.org>
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

From: Hannes Reinecke <hare@suse.de>

Quite some drivers are using management commands internally. These comman=
ds
typically use the same tag pool as regular SCSI commands. Tags for these
management commands are set aside before allocating the block-mq tag bitm=
ap
for regular SCSI commands. The block layer already supports this via the
reserved tag mechanism. Add a new field 'nr_reserved_cmds' to the SCSI ho=
st
template to instruct the block layer to set aside a tag space for these
management commands by using reserved tags. Exclude reserved commands fro=
m
.can_queue because .can_queue is visible in sysfs.

Signed-off-by: Hannes Reinecke <hare@suse.de>
[ bvanassche: modified patch description ]
Cc: John Garry <john.g.garry@oracle.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/hosts.c     |  3 +++
 drivers/scsi/scsi_lib.c  |  4 +++-
 include/scsi/scsi_host.h | 22 +++++++++++++++++++++-
 3 files changed, 27 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index e021f1106bea..c2c6c96781e3 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -495,6 +495,9 @@ struct Scsi_Host *scsi_host_alloc(const struct scsi_h=
ost_template *sht, int priv
 	if (sht->virt_boundary_mask)
 		shost->virt_boundary_mask =3D sht->virt_boundary_mask;
=20
+	if (sht->nr_reserved_cmds)
+		shost->nr_reserved_cmds =3D sht->nr_reserved_cmds;
+
 	device_initialize(&shost->shost_gendev);
 	dev_set_name(&shost->shost_gendev, "host%d", shost->host_no);
 	shost->shost_gendev.bus =3D &scsi_bus_type;
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 1da26f300287..94dafa5ceaaa 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2083,7 +2083,9 @@ int scsi_mq_setup_tags(struct Scsi_Host *shost)
 		tag_set->ops =3D &scsi_mq_ops_no_commit;
 	tag_set->nr_hw_queues =3D shost->nr_hw_queues ? : 1;
 	tag_set->nr_maps =3D shost->nr_maps ? : 1;
-	tag_set->queue_depth =3D shost->can_queue;
+	tag_set->queue_depth =3D
+		shost->can_queue + shost->nr_reserved_cmds;
+	tag_set->reserved_tags =3D shost->nr_reserved_cmds;
 	tag_set->cmd_size =3D cmd_size;
 	tag_set->numa_node =3D dev_to_node(shost->dma_dev);
 	if (shost->hostt->tag_alloc_policy_rr)
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 26bc23419cfd..2c0f5ec1046e 100644
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
+	unsigned nr_reserved_cmds;
+
 	unsigned active_mode:2;
=20
 	/*
