Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 164BE6FA8
	for <linux-scsi@vger.kernel.org>; Wed, 19 Jun 2024 01:38:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718761113; cv=none; b=kwuxx5cvBLsqSNjqmAkHnZw1mQfY9JPb3y/DnCsnbifygdsqgp4VqQAsAGoDIxgWYGMqwb8N/yIX0cfK8VzLh4+de0SxrJeyEqvert1+iGCTBpoKglKlFmDvdBf/U8lUC0r5s7qVVqEdhzObsR/dEMqjM0/GcUEcse60OAvRtxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718761113; c=relaxed/simple;
	bh=MGbeFEftmf6H/2+43Wr7TfH6kARyGKxTpQTeFGPXXB8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ju/JIcFljAraqtZtiDV9+69/78G6lBktBMGyHU8NJZM2/WgQIGVSVGEQPEUak4SXpP48GB6TAvKZwBfrCaLLYRtk6XRs8+g7D991TPv3nlmGToYGMJOhEfbOoAprZU6+dWwYJbcV7CfgR5cHXoxEyJ4o/9ehdCbtlVUkGpQPBL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CK1R9Pjp; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CK1R9Pjp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1718761106;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=kdE5jEBdboTnse5xQrt8G73Vz9nzuTru8pllLjTZ3xc=;
	b=CK1R9PjpxS98lkvWS1mcMysvwnT7etYkHmvyheQpHQRu2t2cuTwetrddA3YkxCnVmwZl47
	Ak6sH8xuxL+SBxVJ0olQz/mU/45RCzJvj2DK6VOyX7NZGK12Cui3A8J9Zz+R3aS8LgzMau
	MgS6ftNIRlL7vq5UA+8TGbVrwlkgu1o=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-339-9M2p4VoPMhGDkjFK9Q10gQ-1; Tue,
 18 Jun 2024 21:38:18 -0400
X-MC-Unique: 9M2p4VoPMhGDkjFK9Q10gQ-1
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id F0FBB19560B2;
	Wed, 19 Jun 2024 01:38:12 +0000 (UTC)
Received: from localhost (unknown [10.72.112.109])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 9675E1956055;
	Wed, 19 Jun 2024 01:38:11 +0000 (UTC)
From: Ming Lei <ming.lei@redhat.com>
To: "Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org
Cc: Ming Lei <ming.lei@redhat.com>,
	Wenchao Hao <haowenchao2@huawei.com>
Subject: [PATCH] scsi: scsi_debug: fix create target debugfs failure
Date: Wed, 19 Jun 2024 09:38:03 +0800
Message-ID: <20240619013803.3008857-1-ming.lei@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

Target debugfs entry is removed via async_schedule() which isn't drained
when adding same name target, so failure of "Directory 'target11:0:0' with
parent 'scsi_debug' already present!" can be triggered easily.

Fix it by switching to domain async schedule, and draining it before
adding new target debugfs entry.

Cc: Wenchao Hao <haowenchao2@huawei.com>
Fixes: f084fe52c640 ("scsi: scsi_debug: Add debugfs interface to fail target reset")
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 drivers/scsi/scsi_debug.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index acf0592d63da..91f022fb8d0c 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -926,6 +926,7 @@ static const int device_qfull_result =
 static const int condition_met_result = SAM_STAT_CONDITION_MET;
 
 static struct dentry *sdebug_debugfs_root;
+static ASYNC_DOMAIN_EXCLUSIVE(sdebug_async_domain);
 
 static void sdebug_err_free(struct rcu_head *head)
 {
@@ -1148,6 +1149,8 @@ static int sdebug_target_alloc(struct scsi_target *starget)
 	if (!targetip)
 		return -ENOMEM;
 
+	async_synchronize_full_domain(&sdebug_async_domain);
+
 	targetip->debugfs_entry = debugfs_create_dir(dev_name(&starget->dev),
 				sdebug_debugfs_root);
 
@@ -1174,7 +1177,8 @@ static void sdebug_target_destroy(struct scsi_target *starget)
 	targetip = (struct sdebug_target_info *)starget->hostdata;
 	if (targetip) {
 		starget->hostdata = NULL;
-		async_schedule(sdebug_tartget_cleanup_async, targetip);
+		async_schedule_domain(sdebug_tartget_cleanup_async, targetip,
+				&sdebug_async_domain);
 	}
 }
 
-- 
2.44.0

