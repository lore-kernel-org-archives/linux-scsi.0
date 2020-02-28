Return-Path: <SRS0=EUsX=4Q=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78B1EC3F2CF
	for <linux-scsi@archiver.kernel.org>; Fri, 28 Feb 2020 09:34:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4BFEB24695
	for <linux-scsi@archiver.kernel.org>; Fri, 28 Feb 2020 09:34:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iNwkoOkW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726614AbgB1JeG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 28 Feb 2020 04:34:06 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:33527 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726538AbgB1JeF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 28 Feb 2020 04:34:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582882445;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=bukg1E7s/jol6gr/YlHe9RA8JYmCB17ynKnnQIzeNiQ=;
        b=iNwkoOkWGgig7N070qM5S7LcbazRzefvDNRTMEOIDl9F/nQ31W4USi5XKopyjFqYP3pB1L
        8gbDPRgiCPZEZUNstE6D85xrRwYr8S5rZFiHABzgE6qXL6rwmudrsE5J3ZiCbSdTe4DGha
        7rQepAYyJs/cxJdgWwlhVrvtRb1fSp0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-315-hxaeBYT4NZao-s_XY_b-Zw-1; Fri, 28 Feb 2020 04:33:59 -0500
X-MC-Unique: hxaeBYT4NZao-s_XY_b-Zw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 679EE19057A3;
        Fri, 28 Feb 2020 09:33:57 +0000 (UTC)
Received: from localhost (ovpn-8-19.pek2.redhat.com [10.72.8.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 83BE687B08;
        Fri, 28 Feb 2020 09:33:53 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     James Bottomley <James.Bottomley@HansenPartnership.com>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Ming Lei <ming.lei@redhat.com>,
        Sumanesh Samanta <sumanesh.samanta@broadcom.com>,
        "Ewan D . Milne" <emilne@redhat.com>,
        Hannes Reinecke <hare@suse.de>,
        Bart Van Assche <bart.vanassche@wdc.com>,
        Christoph Hellwig <hch@lst.de>
Subject: [PATCH] scsi: avoid to fetch scsi host template instance in IO path
Date:   Fri, 28 Feb 2020 17:33:46 +0800
Message-Id: <20200228093346.31213-1-ming.lei@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Content-Transfer-Encoding: quoted-printable
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

scsi host template struct is quite big, and the following three
fields are needed in SCSI IO path:

- queuecommand
- commit_rqs
- cmd_size

Cache them into scsi host intance, so that we can avoid to fetch
big scsi host template instance in IO path.

40% IOPS boost can be observed in my scsi_debug performance test after
applying this change.

Cc: Sumanesh Samanta <sumanesh.samanta@broadcom.com>
Cc: Ewan D . Milne <emilne@redhat.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Bart Van Assche <bart.vanassche@wdc.com>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 drivers/scsi/hosts.c     |  4 ++++
 drivers/scsi/scsi_lib.c  | 10 +++++-----
 include/scsi/scsi_host.h | 11 ++++++++++-
 3 files changed, 19 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index 1d669e47b692..8012c1db092e 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -466,6 +466,10 @@ struct Scsi_Host *scsi_host_alloc(struct scsi_host_t=
emplate *sht, int privsize)
 	if (sht->virt_boundary_mask)
 		shost->virt_boundary_mask =3D sht->virt_boundary_mask;
=20
+	shost->cmd_size =3D sht->cmd_size;
+	shost->queuecommand =3D sht->queuecommand;
+	shost->commit_rqs =3D sht->commit_rqs;
+
 	device_initialize(&shost->shost_gendev);
 	dev_set_name(&shost->shost_gendev, "host%d", shost->host_no);
 	shost->shost_gendev.bus =3D &scsi_bus_type;
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index e7fbf3a9a6aa..f4243ae1d4a9 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1148,7 +1148,7 @@ void scsi_init_command(struct scsi_device *dev, str=
uct scsi_cmnd *cmd)
 	in_flight =3D test_bit(SCMD_STATE_INFLIGHT, &cmd->state);
 	/* zero out the cmd, except for the embedded scsi_request */
 	memset((char *)cmd + sizeof(cmd->req), 0,
-		sizeof(*cmd) - sizeof(cmd->req) + dev->host->hostt->cmd_size);
+		sizeof(*cmd) - sizeof(cmd->req) + dev->host->cmd_size);
=20
 	cmd->device =3D dev;
 	cmd->sense_buffer =3D buf;
@@ -1547,7 +1547,7 @@ static int scsi_dispatch_cmd(struct scsi_cmnd *cmd)
 	}
=20
 	trace_scsi_dispatch_cmd_start(cmd);
-	rtn =3D host->hostt->queuecommand(host, cmd);
+	rtn =3D host->queuecommand(host, cmd);
 	if (rtn) {
 		trace_scsi_dispatch_cmd_error(cmd, rtn);
 		if (rtn !=3D SCSI_MLQUEUE_DEVICE_BUSY &&
@@ -1584,7 +1584,7 @@ static blk_status_t scsi_mq_prep_fn(struct request =
*req)
 	cmd->tag =3D req->tag;
 	cmd->prot_op =3D SCSI_PROT_NORMAL;
=20
-	sg =3D (void *)cmd + sizeof(struct scsi_cmnd) + shost->hostt->cmd_size;
+	sg =3D (void *)cmd + sizeof(struct scsi_cmnd) + shost->cmd_size;
 	cmd->sdb.table.sgl =3D sg;
=20
 	if (scsi_host_get_prot(shost)) {
@@ -1752,7 +1752,7 @@ static int scsi_mq_init_request(struct blk_mq_tag_s=
et *set, struct request *rq,
=20
 	if (scsi_host_get_prot(shost)) {
 		sg =3D (void *)cmd + sizeof(struct scsi_cmnd) +
-			shost->hostt->cmd_size;
+			shost->cmd_size;
 		cmd->prot_sdb =3D (void *)sg + scsi_mq_inline_sgl_size(shost);
 	}
=20
@@ -1844,7 +1844,7 @@ static void scsi_commit_rqs(struct blk_mq_hw_ctx *h=
ctx)
 	struct scsi_device *sdev =3D q->queuedata;
 	struct Scsi_Host *shost =3D sdev->host;
=20
-	shost->hostt->commit_rqs(shost, hctx->queue_num);
+	shost->commit_rqs(shost, hctx->queue_num);
 }
=20
 static const struct blk_mq_ops scsi_mq_ops =3D {
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index f577647bf5f2..ccd5b9a5de2a 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -522,7 +522,16 @@ struct Scsi_Host {
 	 */
 	struct list_head	__devices;
 	struct list_head	__targets;
-=09
+
+	/*
+	 * cacahe the three fields from scsi_host_template, so that
+	 * the big host template  instance needn't to be fetched in
+	 * IO path. Big IOPS boost can be observed by this way.
+	 */
+	unsigned int cmd_size;
+	int (*queuecommand)(struct Scsi_Host *, struct scsi_cmnd *);
+	void (*commit_rqs)(struct Scsi_Host *, u16);
+
 	struct list_head	starved_list;
=20
 	spinlock_t		default_lock;
--=20
2.20.1

