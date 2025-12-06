Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E53C1F17E8
	for <linux-scsi@vger.kernel.org>; Sat,  6 Dec 2025 01:00:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764982827; cv=none; b=sNro05UZ0+w0aF3oo5/BHnVoQhmH6hevKxtLfhA86+63sFmsxovu9Zm6vsYhUd+lJrS6o+kjDOvfDMnJt9Vu84mQcnRAIcTCOKxd0shBOTROngpqSgIG1GpcACAVLScM7bt4aMxMGUQ54BoXXNmtLu/P9s29AivuMuCdAQwO9ac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764982827; c=relaxed/simple;
	bh=O9OGJs90B8jaJWOEsvr8omGjkuVilZIJM6X/eJ+o5ss=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=R+72JLKOoZaOn3TDj7LyRjbNn+sVw5Edz3VUcSVLd8nQpYPi17vn4Z23sWxjgAH0rQ5hQ505IShaGI+/p3lww1l5BY317ZbsptnyadZtE8SZGbkZlv+aUgdfk+1Hg6/OwHDBca+FtrmPOoUsMyJINdOLFzYAM9+30cJjDdeTtXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MGnhb4ki; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MGnhb4ki"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764982824;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=5w4UtrYE7AWo/3qHhRYQubzzzFodcpQGNINtBKnKQWY=;
	b=MGnhb4kiXO6F7762kQ3+euvtyaLe3iCsGBzLojK6R1ytLDD1hPjZ7aKVI7mOhz70qqQNGV
	81xHn810ObcGRicPd3G8xB7xBWQefSfGYFoASVig14eTKFh7fdzlfe1iYTvGW/tLhhCA43
	LMzLc6LRaLNmGIHvGB1OOitlIJoEzrE=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-643-OC-B9ONaMla49omkhCrVTA-1; Fri,
 05 Dec 2025 20:00:19 -0500
X-MC-Unique: OC-B9ONaMla49omkhCrVTA-1
X-Mimecast-MFC-AGG-ID: OC-B9ONaMla49omkhCrVTA_1764982818
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2E5611956066;
	Sat,  6 Dec 2025 01:00:18 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A740B19560B4;
	Sat,  6 Dec 2025 01:00:17 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 5B610GfL1595234
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 5 Dec 2025 20:00:16 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 5B610F531595233;
	Fri, 5 Dec 2025 20:00:15 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Mike Snitzer <snitzer@kernel.org>
Cc: linux-scsi@vger.kernel.org, dm-devel@lists.linux.dev,
        Martin Wilck <mwilck@suse.com>
Subject: [PATCH v2] scsi: scsi_dh: Return error pointer in scsi_dh_attached_handler_name
Date: Fri,  5 Dec 2025 20:00:15 -0500
Message-ID: <20251206010015.1595225-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

If scsi_dh_attached_handler_name() fails to allocate the handler name,
dm-multipath (its only caller) assumes there is no attached device
handler, and sets the device up incorrectly. Return an error pointer
instead, so multipath can distinguish between failure, success where
there is no attached device handler, or when the path device is not
a scsi device at all.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---

Changes from v1:
If scsi_dh_attached_handler_name() returns that the path device is not
a scsi device (-ENODEV) but m->hw_hander_name is set, print an error
message and clear it, like the code does when a hardware handler is set
on a bio-based multipath device.

 drivers/md/dm-mpath.c  | 13 +++++++++++++
 drivers/scsi/scsi_dh.c |  8 +++++---
 2 files changed, 18 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index c18358271618..65a3e93385c0 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -950,6 +950,19 @@ static struct pgpath *parse_path(struct dm_arg_set *as, struct path_selector *ps
 
 	q = bdev_get_queue(p->path.dev->bdev);
 	attached_handler_name = scsi_dh_attached_handler_name(q, GFP_KERNEL);
+	if (IS_ERR(attached_handler_name)) {
+		if (PTR_ERR(attached_handler_name) == -ENODEV) {
+			if (m->hw_handler_name) {
+				DMERR("hardware handlers are only allowed for scsi devices");
+				kfree(m->hw_handler_name);
+				m->hw_handler_name = NULL;
+			}
+			attached_handler_name = NULL;
+		} else {
+			r = PTR_ERR(attached_handler_name);
+			goto bad;
+		}
+	}
 	if (attached_handler_name || m->hw_handler_name) {
 		INIT_DELAYED_WORK(&p->activate_path, activate_path_work);
 		r = setup_scsi_dh(p->path.dev->bdev, m, &attached_handler_name, &ti->error);
diff --git a/drivers/scsi/scsi_dh.c b/drivers/scsi/scsi_dh.c
index 7b56e00c7df6..b9d805317814 100644
--- a/drivers/scsi/scsi_dh.c
+++ b/drivers/scsi/scsi_dh.c
@@ -353,7 +353,8 @@ EXPORT_SYMBOL_GPL(scsi_dh_attach);
  *      that may have a device handler attached
  * @gfp - the GFP mask used in the kmalloc() call when allocating memory
  *
- * Returns name of attached handler, NULL if no handler is attached.
+ * Returns name of attached handler, NULL if no handler is attached, or
+ * and error pointer if an error occurred.
  * Caller must take care to free the returned string.
  */
 const char *scsi_dh_attached_handler_name(struct request_queue *q, gfp_t gfp)
@@ -363,10 +364,11 @@ const char *scsi_dh_attached_handler_name(struct request_queue *q, gfp_t gfp)
 
 	sdev = scsi_device_from_queue(q);
 	if (!sdev)
-		return NULL;
+		return ERR_PTR(-ENODEV);
 
 	if (sdev->handler)
-		handler_name = kstrdup(sdev->handler->name, gfp);
+		handler_name = kstrdup(sdev->handler->name, gfp) ? :
+			       ERR_PTR(-ENOMEM);
 	put_device(&sdev->sdev_gendev);
 	return handler_name;
 }
-- 
2.50.1

