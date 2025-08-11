Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E1B524DCFD
	for <linux-scsi@vger.kernel.org>; Mon, 11 Aug 2025 17:37:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754933864; cv=none; b=IS7av6PISBWYzZzN9h66OcGqfGk34jx+IW6lmo9hU3vRlvQe7RUZyItcm3pMsegvqM/LGDcHxavZ3H6KZteBblYSNFfvzsokXUHLt3LWAzrmN2E2ApeTcQ1eOYdVXJ7QgkjYTUjRXrerPkWylSkHCaPQ0IkvgrJsN9d5i+bUr6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754933864; c=relaxed/simple;
	bh=0yprttaykhPCmqMMbNUh7OMvYKuBjQi+KNkKFRB5rLA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L+vTYlWZWLWTXnJ6okY1gFJXZP3PLSrc/skOqnzVUR6WpJ6DtUWeMgN7xg4I3EVr9peOITfMe4HtV9RNGumQKIcKitc5XwNveE6I3tYs3cHvofhCe7qxOky48yUu0T0SoOvvqUgrNQ5Hl/G+laMgwxnkLmqXeiW3wVJ6RyNzGe0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=C4zMr6Sw; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="C4zMr6Sw"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4c120539mrzlgqVH;
	Mon, 11 Aug 2025 17:37:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1754933859; x=1757525860; bh=JMQ/U
	tTSjpZNDq6URlOGH629fQUS1S2WWIuTiarRRag=; b=C4zMr6SwcKBFdt/JwSaD0
	GHTui3tmyj9EJm6AHOXxASPgybEnEncxRAZgGrJ+CzeuYmkwYsuIzKzUCLQzjlJn
	gxFFfaNCaibdwMLEfUR+iseQtaHTEjhHSPcECvKy4WqY7NOkIxApNanFeD+cQgLN
	SJdkatBQFDefj+Ufr0R1JxLvSghOp64I1AeCavlFTPQju3TANQ4qwH06abUoutEm
	d7XdsQfooZS9TAA9CBqUGscIVc3yI0PeINOWSFJBac7j2ZH+xPAwAJP5x53c1oQS
	bY1tpriEyniqsJpLPRB7QZFVrMLGXYtO24Van/xsQGDOF4qvOGs/z5Qece8YJaS/
	g==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id x0lKx1YNBM1a; Mon, 11 Aug 2025 17:37:39 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4c1200243czlgqV3;
	Mon, 11 Aug 2025 17:37:34 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Hannes Reinecke <hare@suse.de>,
	John Garry <john.g.garry@oracle.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v2 02/30] scsi: core: Support allocating a pseudo SCSI device
Date: Mon, 11 Aug 2025 10:34:14 -0700
Message-ID: <20250811173634.514041-3-bvanassche@acm.org>
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

From: Hannes Reinecke <hare@suse.de>

Add the flag 'alloc_pseudo_sdev' to the SCSI host template and allocate a
pseudo SCSI device if the flag is set.  This device has the SCSI ID
<max_id>:U64_MAX so it won't clash with any devices the LLD might create.
It's excluded from scanning and will not show up in sysfs. Additionally,
pseudo SCSI devices are skipped by shost_for_each_device(). This prevents
that the SCSI error handler tries to submit a reset to a non-existent
logical unit.

The intention is to use this device to send internal commands to the
storage device.

Cc: John Garry <john.g.garry@oracle.com>
Signed-off-by: Hannes Reinecke <hare@suse.de>
[ bvanassche: edited patch description / renamed host_sdev into
  pseudo_sdev / unexported scsi_get_host_dev() / modified error path in
  scsi_get_pseudo_dev() / skip pseudo devices in __scsi_iterate_devices()
  and also when calling sdev_init(), sdev_configure() and sdev_destroy().
  See also
  https://lore.kernel.org/linux-scsi/20211125151048.103910-2-hare@suse.de=
/ ]
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/hosts.c       |  8 +++++
 drivers/scsi/scsi.c        |  7 ++--
 drivers/scsi/scsi_priv.h   |  2 ++
 drivers/scsi/scsi_scan.c   | 70 ++++++++++++++++++++++++++++++++++++--
 drivers/scsi/scsi_sysfs.c  |  4 ++-
 include/scsi/scsi_device.h | 16 +++++++++
 include/scsi/scsi_host.h   |  9 +++++
 7 files changed, 110 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index c2c6c96781e3..8632bf61160b 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -307,6 +307,14 @@ int scsi_add_host_with_dma(struct Scsi_Host *shost, =
struct device *dev,
 	if (error)
 		goto out_del_dev;
=20
+	if (sht->alloc_pseudo_sdev) {
+		shost->pseudo_sdev =3D scsi_get_pseudo_dev(shost);
+		if (!shost->pseudo_sdev) {
+			error =3D -ENOMEM;
+			goto out_del_dev;
+		}
+	}
+
 	scsi_proc_host_add(shost);
 	scsi_autopm_put_host(shost);
 	return error;
diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 9a0f467264b3..a290c3aa7b88 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -826,8 +826,11 @@ struct scsi_device *__scsi_iterate_devices(struct Sc=
si_Host *shost,
 	spin_lock_irqsave(shost->host_lock, flags);
 	while (list->next !=3D &shost->__devices) {
 		next =3D list_entry(list->next, struct scsi_device, siblings);
-		/* skip devices that we can't get a reference to */
-		if (!scsi_device_get(next))
+		/*
+		 * Skip pseudo devices and also devices for which
+		 * scsi_device_get() fails.
+		 */
+		if (!scsi_device_is_pseudo_dev(next) && !scsi_device_get(next))
 			break;
 		next =3D NULL;
 		list =3D list->next;
diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
index 5b2b19f5e8ec..da3bc87ac5a6 100644
--- a/drivers/scsi/scsi_priv.h
+++ b/drivers/scsi/scsi_priv.h
@@ -135,6 +135,8 @@ extern int scsi_complete_async_scans(void);
 extern int scsi_scan_host_selected(struct Scsi_Host *, unsigned int,
 				   unsigned int, u64, enum scsi_scan_mode);
 extern void scsi_forget_host(struct Scsi_Host *);
+struct scsi_device *scsi_get_pseudo_dev(struct Scsi_Host *);
+bool scsi_device_is_pseudo_dev(struct scsi_device *sdev);
=20
 /* scsi_sysctl.c */
 #ifdef CONFIG_SYSCTL
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 3c6e089e80c3..3eba5656c82a 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -365,7 +365,7 @@ static struct scsi_device *scsi_alloc_sdev(struct scs=
i_target *starget,
=20
 	scsi_sysfs_device_initialize(sdev);
=20
-	if (shost->hostt->sdev_init) {
+	if (!scsi_device_is_pseudo_dev(sdev) && shost->hostt->sdev_init) {
 		ret =3D shost->hostt->sdev_init(sdev);
 		if (ret) {
 			/*
@@ -1077,7 +1077,7 @@ static int scsi_add_lun(struct scsi_device *sdev, u=
nsigned char *inq_result,
 	else if (*bflags & BLIST_MAX_1024)
 		lim.max_hw_sectors =3D 1024;
=20
-	if (hostt->sdev_configure)
+	if (!scsi_device_is_pseudo_dev(sdev) && hostt->sdev_configure)
 		ret =3D hostt->sdev_configure(sdev, &lim);
 	if (ret) {
 		queue_limits_cancel_update(sdev->request_queue);
@@ -1212,6 +1212,12 @@ static int scsi_probe_and_add_lun(struct scsi_targ=
et *starget,
 	if (!sdev)
 		goto out;
=20
+	if (scsi_device_is_pseudo_dev(sdev)) {
+		if (bflagsp)
+			*bflagsp =3D BLIST_NOLUN;
+		return SCSI_SCAN_LUN_PRESENT;
+	}
+
 	result =3D kmalloc(result_len, GFP_KERNEL);
 	if (!result)
 		goto out_free_sdev;
@@ -2077,12 +2083,16 @@ EXPORT_SYMBOL(scsi_scan_host);
=20
 void scsi_forget_host(struct Scsi_Host *shost)
 {
-	struct scsi_device *sdev;
+	struct scsi_device *sdev, *pseudo_sdev =3D NULL;
 	unsigned long flags;
=20
  restart:
 	spin_lock_irqsave(shost->host_lock, flags);
 	list_for_each_entry(sdev, &shost->__devices, siblings) {
+		if (scsi_device_is_pseudo_dev(sdev)) {
+			pseudo_sdev =3D sdev;
+			continue;
+		}
 		if (sdev->sdev_state =3D=3D SDEV_DEL)
 			continue;
 		spin_unlock_irqrestore(shost->host_lock, flags);
@@ -2090,5 +2100,59 @@ void scsi_forget_host(struct Scsi_Host *shost)
 		goto restart;
 	}
 	spin_unlock_irqrestore(shost->host_lock, flags);
+
+	/*
+	 * Remove the pseudo device last since it may be needed during removal
+	 * of other SCSI devices.
+	 */
+	if (pseudo_sdev)
+		__scsi_remove_device(pseudo_sdev);
 }
=20
+/**
+ * scsi_get_pseudo_dev() - Attach a pseudo SCSI device to a SCSI host
+ * @shost: Host that needs a pseudo SCSI device
+ *
+ * Lock status: None assumed.
+ *
+ * Returns:     The scsi_device or NULL
+ *
+ * Notes:
+ *	Attach a single scsi_device to the Scsi_Host. The primary aim for thi=
s
+ *	device is to serve as a container from which SCSI commands can be
+ *	allocated. Each SCSI command will carry a command tag allocated by th=
e
+ *	block layer. These SCSI commands can be used by the LLDD to send
+ *	internal or passthrough commands without having to manage tag allocat=
ion
+ *	inside the LLDD.
+ */
+struct scsi_device *scsi_get_pseudo_dev(struct Scsi_Host *shost)
+{
+	struct scsi_device *sdev =3D NULL;
+	struct scsi_target *starget;
+
+	guard(mutex)(&shost->scan_mutex);
+
+	if (!scsi_host_scan_allowed(shost))
+		goto out;
+
+	starget =3D scsi_alloc_target(&shost->shost_gendev, 0, shost->max_id);
+	if (!starget)
+		goto out;
+
+	sdev =3D scsi_alloc_sdev(starget, U64_MAX, NULL);
+	if (!sdev)
+		goto reap_target;
+
+	sdev->borken =3D 0;
+
+put_target:
+	/* See also the get_device(dev) call in scsi_alloc_target(). */
+	put_device(&starget->dev);
+
+out:
+	return sdev;
+
+reap_target:
+	scsi_target_reap(starget);
+	goto put_target;
+}
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index e6464b998960..fa510455886e 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -1406,6 +1406,8 @@ int scsi_sysfs_add_sdev(struct scsi_device *sdev)
 	int error;
 	struct scsi_target *starget =3D sdev->sdev_target;
=20
+	WARN_ON_ONCE(scsi_device_is_pseudo_dev(sdev));
+
 	error =3D scsi_target_add(starget);
 	if (error)
 		return error;
@@ -1513,7 +1515,7 @@ void __scsi_remove_device(struct scsi_device *sdev)
 	kref_put(&sdev->host->tagset_refcnt, scsi_mq_free_tags);
 	cancel_work_sync(&sdev->requeue_work);
=20
-	if (sdev->host->hostt->sdev_destroy)
+	if (!scsi_device_is_pseudo_dev(sdev) && sdev->host->hostt->sdev_destroy=
)
 		sdev->host->hostt->sdev_destroy(sdev);
 	transport_destroy_device(dev);
=20
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 6d6500148c4b..3846f5dfc51c 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -589,6 +589,22 @@ static inline unsigned int sdev_id(struct scsi_devic=
e *sdev)
 #define scmd_id(scmd) sdev_id((scmd)->device)
 #define scmd_channel(scmd) sdev_channel((scmd)->device)
=20
+/**
+ * scsi_device_is_pseudo_dev() - Whether a device is a pseudo SCSI devic=
e.
+ * @sdev: SCSI device to examine
+ *
+ * A pseudo SCSI device can be used to allocate SCSI commands but does n=
ot show
+ * up in sysfs. Additionally, the logical unit information in *@sdev is =
made up.
+ *
+ * This function tests the LUN number instead of comparing @sdev with
+ * @sdev->host->pseudo_sdev because this function may be called before
+ * @sdev->host->pseudo_sdev has been initialized.
+ */
+static inline bool scsi_device_is_pseudo_dev(struct scsi_device *sdev)
+{
+	return sdev->lun =3D=3D U64_MAX;
+}
+
 /*
  * checks for positions of the SCSI state machine
  */
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 722ecbee938e..3b5150759c44 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -463,6 +463,9 @@ struct scsi_host_template {
 	 */
 	unsigned emulated:1;
=20
+	/* True if a pseudo sdev should be allocated */
+	unsigned alloc_pseudo_sdev:1;
+
 	/*
 	 * True if the low-level driver performs its own reset-settle delays.
 	 */
@@ -722,6 +725,12 @@ struct Scsi_Host {
 	/* ldm bits */
 	struct device		shost_gendev, shost_dev;
=20
+	/*
+	 * A SCSI device structure used for sending internal commands to the
+	 * HBA. There is no corresponding logical unit inside the SCSI device.
+	 */
+	struct scsi_device *pseudo_sdev;
+
 	/*
 	 * Points to the transport data (if any) which is allocated
 	 * separately
