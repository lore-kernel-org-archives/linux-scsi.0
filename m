Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC6DE2D12ED
	for <linux-scsi@vger.kernel.org>; Fri, 21 Nov 2025 23:48:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763768924; cv=none; b=R0CLDZKAye2Dwzssfuhv2NcpILyWPMuuIwDZxNKWCbkbknO6ZVsPyeQOQ+9K6+SXqs03eKNonxdLgJRSo8GUsPIExq9ycuctQ8cebus4kMDuXU65Bfx7pqSDtR8h4cGybJpJlL5+EWRsCTTdoU4eJ7e6lmRQ5L7PGAdQodcU9Rc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763768924; c=relaxed/simple;
	bh=zTOpv/kzstJRNJt7qtvfazQzE4Hcs2E3ZAMtIbHiS7s=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=DyVGJyq5GEfiqhyw2pfyX9neL4CG/8pVZt6XrL+OjhRXm6Pk1Zdsp3iwhqm9c7E2cljFFFRxupnxWgLjUUw20zyUyCqMmCEJ6VJ1Ud6u+YX5fE3hv0O87HHIJ5nGTqKgiqPwbJwvpgl2L7U6eFfl8EtV/QoLf/x3zqTdzSmakTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=A1taUXl6; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="A1taUXl6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763768921;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=E+Eg2flOqAY1uEOOIaEtYRBAik9fTv58h5ybQjqBjPg=;
	b=A1taUXl6+w/1s8x5lPAZKC30+TVqxp7p5G4TJq233sDOAgAA1bcGB6SRr0Oyy7CNHAxsdl
	b8PmF93oClC7CI8hHRTF5qRBFs54mOmngncRgBUxmWCWvVeJLKqZh76+zPCdYbD1QnmcTq
	6fr79hcH0of0XS6w8NWobutsba1dlgk=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-294-DcYN3yFfOoOdUiv-wH5b9Q-1; Fri,
 21 Nov 2025 18:48:38 -0500
X-MC-Unique: DcYN3yFfOoOdUiv-wH5b9Q-1
X-Mimecast-MFC-AGG-ID: DcYN3yFfOoOdUiv-wH5b9Q_1763768917
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D0C311800447;
	Fri, 21 Nov 2025 23:48:36 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (unknown [10.6.23.247])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8B02D30044DC;
	Fri, 21 Nov 2025 23:48:36 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 5ALNmZs21035037
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 21 Nov 2025 18:48:35 -0500
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 5ALNmYt91035036;
	Fri, 21 Nov 2025 18:48:34 -0500
From: Benjamin Marzinski <bmarzins@redhat.com>
To: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Mike Snitzer <snitzer@kernel.org>
Cc: linux-scsi@vger.kernel.org, dm-devel@lists.linux.dev,
        Martin Wilck <mwilck@suse.com>
Subject: [PATCH] scsi: scsi_dh: Return error pointer in scsi_dh_attached_handler_name
Date: Fri, 21 Nov 2025 18:48:34 -0500
Message-ID: <20251121234834.1035028-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

If scsi_dh_attached_handler_name() fails to allocate the handler name,
dm-multipath (its only caller) assumes there is no attached device
handler, and sets the device up incorrectly. Return an error pointer
instead, so multipath can distinguish between failure and success where
there is no attached device handler.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 drivers/md/dm-mpath.c  | 8 ++++++++
 drivers/scsi/scsi_dh.c | 8 +++++---
 2 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index c18358271618..063dc526fe04 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -950,6 +950,14 @@ static struct pgpath *parse_path(struct dm_arg_set *as, struct path_selector *ps
 
 	q = bdev_get_queue(p->path.dev->bdev);
 	attached_handler_name = scsi_dh_attached_handler_name(q, GFP_KERNEL);
+	if (IS_ERR(attached_handler_name)) {
+		if (PTR_ERR(attached_handler_name) == -ENODEV)
+			attached_handler_name = NULL;
+		else {
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

