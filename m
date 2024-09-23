Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 049F619E990
	for <linux-scsi@vger.kernel.org>; Mon, 23 Sep 2024 17:48:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727113728; cv=none; b=i5h0JrkOvAskr6SYpc4g+CfZNkGark2kp/JsTGE/ft0JFqYILvru2hFNnL9PgMSQcjLsyt6bkIQi8I+SCptLCVeJnhUui9N2AJK/91Nt7Jbll4IZxGyi0LV9XZl7rl2q6l1BkLEEFSreSaW+7zJyrfPBf2513dwQlIrSwykgx6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727113728; c=relaxed/simple;
	bh=W63gcfqEBIwQOnwc35vzRToMNkoC5VFi8SIU+zmxbcY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=CoCJUUxzxXpQLnwICKWT98CJ9PT4T4A0KZuhcP9sUHxaxu1PPSQh6nEhSJtmIcv4BCT1BZ+Mz6gTo+4Z9iCsqf0ijzhkEhs7W4V4nDPjjeE6ZQYr986XqyVKfpLtMZKHw9NVOzIS6Zqi6tlY8HaKNZ/pL8Oy6lYbw+wurn8s7zo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Jh4RTzlL; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Jh4RTzlL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1727113723;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Ck/vQsuLDc6HFMzvZkeq8plMu/BYorQtj2DGOSPMadA=;
	b=Jh4RTzlL6hJFDl0OEzPeg1hCzraEYQlyu7n+NRS2ZtYhup0hsdtxbAr6nskeQdOAPOUZLG
	aL5gcIdW0mbZqrkvk4Hlb/fu+nQsQdAihDUR21TTi1cyz4XoR9fMOQiplKddYIVWWUnKkt
	JMPkTRQ1zEh6PunTuj7r39tiDEThDyA=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-59-fqZP-v48M1SEku0zQum_zA-1; Mon,
 23 Sep 2024 13:48:37 -0400
X-MC-Unique: fqZP-v48M1SEku0zQum_zA-1
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (unknown [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id ABE2B190A37F;
	Mon, 23 Sep 2024 17:48:36 +0000 (UTC)
Received: from localhost.redhat.com (unknown [10.45.224.51])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id B102F1956052;
	Mon, 23 Sep 2024 17:48:34 +0000 (UTC)
From: Tomas Henzl <thenzl@redhat.com>
To: linux-scsi@vger.kernel.org
Cc: chandrakanth.patil@broadcom.com,
	sathya.prakash@broadcom.com,
	sumit.saxena@broadcom.com,
	ranjan.kumar@broadcom.com
Subject: [PATCH] megaraid_sas: fix for a potential deadlock
Date: Mon, 23 Sep 2024 19:48:33 +0200
Message-ID: <20240923174833.45345-1-thenzl@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

This fixes a 'possible circular locking dependency detected' warning
      CPU0                    CPU1 
      ----                    ---- 
 lock(&instance->reset_mutex); 
                              lock(&shost->scan_mutex); 
                              lock(&instance->reset_mutex); 
 lock(&shost->scan_mutex); 
 

Fix this but temporarily releasing the reset_mutex.

Signed-off-by: Tomas Henzl <thenzl@redhat.com>
---
 drivers/scsi/megaraid/megaraid_sas_base.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 6c79c350a4d5..253cc1159661 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -8907,8 +8907,11 @@ megasas_aen_polling(struct work_struct *work)
 						   (ld_target_id / MEGASAS_MAX_DEV_PER_CHANNEL),
 						   (ld_target_id % MEGASAS_MAX_DEV_PER_CHANNEL),
 						   0);
-			if (sdev1)
+			if (sdev1) {
+				mutex_unlock(&instance->reset_mutex);
 				megasas_remove_scsi_device(sdev1);
+				mutex_lock(&instance->reset_mutex);
+			}
 
 			event_type = SCAN_VD_CHANNEL;
 			break;
-- 
2.46.0

