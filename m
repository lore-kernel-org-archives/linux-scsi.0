Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.101
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794170896;
	b=gEjPDPS1KX84DeNZUT5MB7PMZCc4BBWylsoGRkFqri7JiJVmwPwvyNJ+lKwD+VH6iQHI
	 cDalemZ7UH3FhV0vWl8dl7QKoWycla/iCKyfOMEIIfmNfSfRCibTAEwllkybJKzJb7QhK
	 EFqt0YwpEKsRYFsQIPNDLiaVykPqzb/VpfXnyROkXLc3H8OdUNF5yIzTu0J7FmfqvPcBy
	 aKRmC+3B44BJr6xGyzRxe++kakVH8szwPTqeD0xztm0ysB3NVv6EH/VGxMI9fM8Fb4doU
	 Z8awS9lRZYPlR1EjG7ML7q+xAUJ9iRxNdS6lbKAwdJylNhnRT85GxRBW4VNgeBSzoWw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794170896;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=wUNj3zcErgaPzyJWqZg0hX16vWl0qpJJmvLNO3XQBUs=;
	b=AgdeSq+yWJwPz+pTd47r3TI90x5TDTtf8MlLyLsQAiQ6SD6R9Nk0KMnt7WzZoqBIuhDS
	 ZaukKXJz48mV8Pwb1Mu7aALL+kF7rRIxmk8HCM0bR3xlMWaKVlDDz3E1NG4nrhbpvN+S1
	 GOdmq6I5rX0qlGeh3JzugYBbmE+tEXKTDoE6XGKt80qgEUYGBQySmBczIaOq7LxLNUgpX
	 WCpU6qkbGfbfk0Lh0xApzjXiv9T4x7NDrab2bS5LWCZpP004vP5jPyw48Ukv7pWB2V9FI
	 PehQLefYxVHpzrVsbsD+7UBZCfA6ZppHET2dh6qpvW8XCGGrPWWHxDl4ry7xSFG7QtA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=JoCP8mSk;
	arc=none smtp.remote-ip=95.215.58.101
Received: from mta1.migadu.com (out-101.mta1.migadu.com [95.215.58.101])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1FB0606D805
	for <linux-scsi@vger.kernel.org>; Sun,  8 Nov 2026 20:48:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A1FB0606D805
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=JoCP8mSk
X-Envelope-To: linux-scsi@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=pn2Yu/uIIBg3kKaM6bVH+66C04F3rhaZVDPZfB5P3mM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794170893; v=1; x=1794775693;
 b=JoCP8mSkZajjXQrlA+PQu8uVatkwBDgTURkfM5QEdlXUt66/zi9cx9goYvmCloHvEFGEegpH
 mCi9ag8zub8hANZd+jMaZG4AmkE1yIRRAi714xkQVxrhYh5zhEvLrdPaFwlx670npjtvxAtXLZe
 HuSBhzAdU3uWGXo+nZLqHXDU=
X-Envelope-To: linux-scsi@vger.kernel.org
Received: by mta10.migadu.com with ESMTPS id c491654f1496b39a;
	Sun, 08 Nov 2026 20:48:13 +0000
X-Mizu-Trace-ID: c491654f1496b39a
X-Migadu-Flow: FLOW_OUT
From: John Garry <john.garry@linux.dev>
To: james.bottomley@hansenpartnership.com,
	mkp@kernel.org
Cc: hare@suse.com,
	linux-nvme@lists.infradead.org,
	linux-scsi@vger.kernel.org,
	snitzer@kernel.org,
	jmeneghi@redhat.com,
	bmarzins@redhat.com,
	dm-devel@lists.linux.dev,
	hch@lst.de,
	michael.christie@oracle.com,
	John Garry <john.garry@linux.dev>
Subject: [PATCH v9 16/29] scsi-multipath: clone each bio
Date: Sun,  8 Nov 2026 20:47:20 +0000
Message-ID: <20261108204733.557995-17-john.garry@linux.dev>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261108204733.557995-1-john.garry@linux.dev>
References: <20261108204733.557995-1-john.garry@linux.dev>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

For failover handling, we will take the approach to resubmit each
bio.

However, unlike NVMe, for SCSI there is no guarantee that any bio submitted
is either all or none completed.

As such, for SCSI, for failover handling we will take the approach to
just re-submit the original bio. For this, clone and submit each bio.

Signed-off-by: John Garry <john.garry@linux.dev>
---
 drivers/scsi/scsi_multipath.c | 33 +++++++++++++++++++++++++++++++++
 include/scsi/scsi_multipath.h |  1 +
 2 files changed, 34 insertions(+)

diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
index baf4ca73f8c9..8e229357e62c 100644
--- a/drivers/scsi/scsi_multipath.c
+++ b/drivers/scsi/scsi_multipath.c
@@ -101,6 +101,7 @@ static void scsi_mpath_head_release(struct device *dev)
 		container_of(dev, struct scsi_mpath_head, dev);
 	struct mpath_head *mpath_head = &scsi_mpath_head->mpath_head;
 
+	bioset_exit(&scsi_mpath_head->bio_pool);
 	ida_free(&scsi_multipath_dev_ida, scsi_mpath_head->index);
 	ida_destroy(&scsi_mpath_head->ida);
 	mpath_head_uninit(mpath_head);
@@ -239,7 +240,34 @@ static int scsi_multipath_sdev_init(struct scsi_device *sdev)
 	return 0;
 }
 
+static void scsi_mpath_clone_end_io(struct bio *clone)
+{
+	struct bio *master_bio = clone->bi_private;
+
+	master_bio->bi_status = clone->bi_status;
+	bio_put(clone);
+	bio_endio(master_bio);
+}
+
+static struct bio *scsi_mpath_clone_bio(struct bio *bio)
+{
+	struct mpath_head *mpath_head = bio->bi_bdev->bd_disk->private_data;
+	struct scsi_mpath_head *scsi_mpath_head = to_scsi_mpath_head(mpath_head);
+	struct bio *clone;
+
+	clone = bio_alloc_clone(bio->bi_bdev, bio, GFP_NOIO,
+				&scsi_mpath_head->bio_pool);
+	if (!clone)
+		return NULL;
+
+	clone->bi_end_io = scsi_mpath_clone_end_io;
+	clone->bi_private = bio;
+
+	return clone;
+}
+
 static struct mpath_head_template smpdt = {
+	.clone_bio = scsi_mpath_clone_bio,
 };
 
 static struct scsi_mpath_head *scsi_mpath_alloc_head(char *vpd_id)
@@ -265,6 +293,9 @@ static struct scsi_mpath_head *scsi_mpath_alloc_head(char *vpd_id)
 	scsi_mpath_head->index = ida_alloc(&scsi_multipath_dev_ida, GFP_KERNEL);
 	if (scsi_mpath_head->index < 0)
 		goto out_uninit_head;
+	if (bioset_init(&scsi_mpath_head->bio_pool, BIO_POOL_SIZE,
+			0, BIOSET_PERCPU_CACHE))
+		goto out_ida_free;
 	kref_init(&scsi_mpath_head->ref);
 
 	device_initialize(&scsi_mpath_head->dev);
@@ -284,6 +315,8 @@ static struct scsi_mpath_head *scsi_mpath_alloc_head(char *vpd_id)
 
 	return scsi_mpath_head;
 
+out_ida_free:
+	ida_free(&scsi_multipath_dev_ida, scsi_mpath_head->index);
 out_uninit_head:
 	mpath_head_uninit(&scsi_mpath_head->mpath_head);
 out_free:
diff --git a/include/scsi/scsi_multipath.h b/include/scsi/scsi_multipath.h
index d6f290b84f7f..d2ef94ebd29a 100644
--- a/include/scsi/scsi_multipath.h
+++ b/include/scsi/scsi_multipath.h
@@ -26,6 +26,7 @@ struct scsi_mpath_head {
 	struct ida		ida;
 	struct kref		ref;
 	enum mpath_iopolicy_e	iopolicy;
+	struct bio_set		bio_pool;
 	struct device		dev;
 	int			index;
 };
-- 
2.43.0

