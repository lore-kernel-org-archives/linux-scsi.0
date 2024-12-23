Received: from mx.treblig.org (mx.treblig.org [46.235.229.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CE791AF0D7;
	Mon, 23 Dec 2024 18:01:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.235.229.95
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734976884; cv=none; b=jk9h+G/wl8HWFn44AORye21+yf9NSwOMlxXduVFH8q6jKLLBB0pNbqF/z0e+k9Bu7sCxWxUKUgMJLutnahl9hn9/MT20EYnGd+9gcdECSQfDZONs7z4mHvZJ9naKmllaNtGKfu4yhr5m9ncGrqeMkPUVG7AVyXytthRaEuU6mKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734976884; c=relaxed/simple;
	bh=fFcYOVV1J6ZSiBeZEmR7DhoYM7yMSAfkFc2Q293bmUA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=K7Q8HacXLmMMynaICvpXLpzZ8cQ5eE2WdOISrI73+s5tGE1DSqu5mWTNSaYD9WtTC0Cu1VGTpdi2rJQdZmLGqb/tp7sPNX49PO2c5Szo4FxE4Yb81n8RyTwiKqFHua49PFyn+XSH/7T/cmrYpUqcjebJqF65Z5lp6XbINvaZcvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org; spf=pass smtp.mailfrom=treblig.org; dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b=iYvJGNt9; arc=none smtp.client-ip=46.235.229.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=treblig.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b="iYvJGNt9"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=treblig.org
	; s=bytemarkmx; h=MIME-Version:Message-ID:Date:Subject:From:Content-Type:From
	:Subject; bh=Ik3x0FYHFo/iQgBcTqpNku8S7FmBbhDYxy7i8w/n5Xg=; b=iYvJGNt9w/UYnnsg
	ykIDkJ78rjUSXHpW3Kse7QUltnGYWvHpSS9PoONv0j4YCpuYwbaofhGjkQcH+LO5TYh7BvTWl1hp2
	7O6DHwzQ/GTG2gmGFOwFpraz59wXPa/+KDTS7ceKkMgAnmG7Hd3SK0Hcy2trHRt9E1VdyUpGBzzKV
	QeEcXfXxxufQLI+a710AWot1xIYfvTfSAp5oB5xCIXLDQz/pR+zmagPprkT6APFTmrE2NVMdqjr1e
	BpsUCEFkHvxYiMcqkHfBxuLeA5SUyoCAgvECoXZj5LHPjm6HC0OuODOjeRUFIh1j+h/S+adPOYM4o
	bJtsvMnj0E1bNf0JGQ==;
Received: from localhost ([127.0.0.1] helo=dalek.home.treblig.org)
	by mx.treblig.org with esmtp (Exim 4.96)
	(envelope-from <linux@treblig.org>)
	id 1tPmjv-006uG9-0g;
	Mon, 23 Dec 2024 18:01:11 +0000
From: linux@treblig.org
To: lduncan@suse.com,
	cleech@redhat.com,
	michael.christie@oracle.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: open-iscsi@googlegroups.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	"Dr. David Alan Gilbert" <linux@treblig.org>
Subject: [PATCH] scsi: iscsi: Remove unused iscsi_create_session
Date: Mon, 23 Dec 2024 18:01:10 +0000
Message-ID: <20241223180110.50266-1-linux@treblig.org>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Dr. David Alan Gilbert" <linux@treblig.org>

iscsi_create_session() last use was removed in 2008 by
commit 756135215ec7 ("[SCSI] iscsi: remove session and host binding in
libiscsi")

Remove it.

Signed-off-by: Dr. David Alan Gilbert <linux@treblig.org>
---
 drivers/scsi/scsi_transport_iscsi.c | 27 ---------------------------
 include/scsi/scsi_transport_iscsi.h |  4 ----
 2 files changed, 31 deletions(-)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index fde7de3b1e55..8fc5e0aa5eaf 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -2122,33 +2122,6 @@ int iscsi_add_session(struct iscsi_cls_session *session, unsigned int target_id)
 }
 EXPORT_SYMBOL_GPL(iscsi_add_session);
 
-/**
- * iscsi_create_session - create iscsi class session
- * @shost: scsi host
- * @transport: iscsi transport
- * @dd_size: private driver data size
- * @target_id: which target
- *
- * This can be called from a LLD or iscsi_transport.
- */
-struct iscsi_cls_session *
-iscsi_create_session(struct Scsi_Host *shost, struct iscsi_transport *transport,
-		     int dd_size, unsigned int target_id)
-{
-	struct iscsi_cls_session *session;
-
-	session = iscsi_alloc_session(shost, transport, dd_size);
-	if (!session)
-		return NULL;
-
-	if (iscsi_add_session(session, target_id)) {
-		iscsi_free_session(session);
-		return NULL;
-	}
-	return session;
-}
-EXPORT_SYMBOL_GPL(iscsi_create_session);
-
 static void iscsi_conn_release(struct device *dev)
 {
 	struct iscsi_cls_conn *conn = iscsi_dev_to_conn(dev);
diff --git a/include/scsi/scsi_transport_iscsi.h b/include/scsi/scsi_transport_iscsi.h
index bd1243657c01..5474494a1e99 100644
--- a/include/scsi/scsi_transport_iscsi.h
+++ b/include/scsi/scsi_transport_iscsi.h
@@ -447,10 +447,6 @@ extern int iscsi_add_session(struct iscsi_cls_session *session,
 			     unsigned int target_id);
 extern int iscsi_session_event(struct iscsi_cls_session *session,
 			       enum iscsi_uevent_e event);
-extern struct iscsi_cls_session *iscsi_create_session(struct Scsi_Host *shost,
-						struct iscsi_transport *t,
-						int dd_size,
-						unsigned int target_id);
 extern void iscsi_force_destroy_session(struct iscsi_cls_session *session);
 extern void iscsi_remove_session(struct iscsi_cls_session *session);
 extern void iscsi_free_session(struct iscsi_cls_session *session);
-- 
2.47.1

