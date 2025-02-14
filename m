Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D8532AF16
	for <linux-scsi@vger.kernel.org>; Fri, 14 Feb 2025 19:24:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739561087; cv=none; b=CZHG7kZvuICxHax5xFjBVsuJWBD9cUNLSaxjZNPwJHC8FiMLvo9IMFcqfFL8rltybFoABxxVcR7cIH0UxDKdFiLDdDGnhWyRH6vTr/I62X014qtWgTIfIxu/bqlraX3rsfURl26XPIRs1JMVpWcfxi0s1/NfYLW7hWfK/NhWlfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739561087; c=relaxed/simple;
	bh=d7eLa+l0BgxHNOGpkfo2U7Ib7OXM+0lkMqMNR9qYx4s=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ds4DVs4/uaOUPrUo0Gx84DXa64wi9GVBA7foil2+LfMXO13vdQuSUyioB3pm/awWqKsRRZPaozv1pVBEdH3tSPuUEhNNAEleNvqkkuuLKRN8bQixgQNVjvI4je6u+t0Ll6ypPW77lFiAxTKrwQGK4xpebWKcNvckJZU+jIjsvZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CIG/YieS; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CIG/YieS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739561084;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=uU18PgJHAWxgzCn1GD8uryQE/mKTabOBU2mLmRwwGxI=;
	b=CIG/YieS7Qd0b8EUv4rAp/eh7DuaemICgR5oDq/aVjYQkLRDJ3ny2ouKz02W1j+KhCdUdy
	D5qKQMG1ixDE7MC5UAXSfKGZ1nFfwlKWvAbWRlzsFtNQknPs4T170/2n0Sn35OKgbknwXB
	WkgJRRLmYxYs50Wxi7I9Q7MAb30qjHk=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-77-dfWXpf46OYOZdi8cUPKRNw-1; Fri,
 14 Feb 2025 14:24:41 -0500
X-MC-Unique: dfWXpf46OYOZdi8cUPKRNw-1
X-Mimecast-MFC-AGG-ID: dfWXpf46OYOZdi8cUPKRNw_1739561080
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id F129A19039C5;
	Fri, 14 Feb 2025 19:24:39 +0000 (UTC)
Received: from llong-thinkpadp16vgen1.westford.csb (unknown [10.22.89.30])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id AB8FB1800365;
	Fri, 14 Feb 2025 19:24:37 +0000 (UTC)
From: Waiman Long <longman@redhat.com>
To: Don Brace <don.brace@microchip.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: storagedev@microchip.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Waiman Long <longman@redhat.com>
Subject: [PATCH] scsi: smartpqi: Add lun_reset_key to initialize ctrl_info->lun_reset_mutex
Date: Fri, 14 Feb 2025 14:23:24 -0500
Message-ID: <20250214192324.2471148-1-longman@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

A lockdep recursive locking splat happens when shutting down a debug kernel
on some systems.

 ============================================
 WARNING: possible recursive locking detected
 --------------------------------------------
 reboot/15103 is trying to acquire lock:
 ffff8881435af8c8 (&ctrl_info->lun_reset_mutex){+.+.}-{3:3}, at: pqi_shutdown+0x112/0x4b0 [smartpqi]

 but task is already holding lock:
 ffff8888929278c8 (&ctrl_info->lun_reset_mutex){+.+.}-{3:3}, at: pqi_shutdown+0x112/0x4b0 [smartpqi]

  other info that might help us debug this:
   Possible unsafe locking scenario:

         CPU0
         ----
    lock(&ctrl_info->lun_reset_mutex);
    lock(&ctrl_info->lun_reset_mutex);

   *** DEADLOCK ***

   May be due to missing lock nesting notation

  4 locks held by reboot/15103:
   #0: ffffffff8db76f40 (system_transition_mutex){+.+.}-{3:3}, at: __do_sys_reboot+0x12b/0x2f0
   #1: ffff8888929278c8 (&ctrl_info->lun_reset_mutex){+.+.}-{3:3}, at: pqi_shutdown+0x112/0x4b0 [smartpqi]
   #2: ffff88810a8921a8 (&dev->mutex){....}-{3:3}, at: device_shutdown+0x1de/0x540
   #3: ffff88810a9141a8 (&dev->mutex){....}-{3:3}, at: device_shutdown+0x1ec/0x540
  Call Trace:

   dump_stack_lvl+0x6f/0xb0
   print_deadlock_bug.cold+0xbd/0xca
   validate_chain+0x37b/0x570
   __lock_acquire+0x55b/0xac0
   lock_acquire.part.0+0xf5/0x2b0
   mutex_lock_nested+0x4b/0x190
   pqi_shutdown+0x112/0x4b0 [smartpqi]
   pci_device_shutdown+0x76/0x110
   device_shutdown+0x2ea/0x540
   kernel_restart+0x64/0xa0
   __do_sys_reboot+0x1d8/0x2f0
   do_syscall_64+0x92/0x180

The fact that there are two dev->mutex'es acquired in device_shutdown()
means both a parent and a child devices are being worked on and
likely that the lun_reset_mutex'es of these two devices are being
acquired here too. However, the way lun_reset_mutex is initialized in
pqi_alloc_ctrl_info() will casue all the lun_reset_mutex'es to be treated
as in the same class leading to this false positive warning. Fix that
by initializing each instance of lun_reset_mutex with its own unique
key so that they will be treated as different by lockdep.

Also call mutex_destroy() and lockdep_unregister_key() in
pqi_free_ctrl_info() before ctrl_info is freed.

With this patch applied, the lockdep splat no longer happens.

Signed-off-by: Waiman Long <longman@redhat.com>
---
 drivers/scsi/smartpqi/smartpqi.h      | 1 +
 drivers/scsi/smartpqi/smartpqi_init.c | 8 +++++++-
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/smartpqi/smartpqi.h b/drivers/scsi/smartpqi/smartpqi.h
index fae6db20a6e9..fb75de53d401 100644
--- a/drivers/scsi/smartpqi/smartpqi.h
+++ b/drivers/scsi/smartpqi/smartpqi.h
@@ -1359,6 +1359,7 @@ struct pqi_ctrl_info {
 
 	struct mutex	scan_mutex;
 	struct mutex	lun_reset_mutex;
+	struct lock_class_key lun_reset_key;
 	bool		controller_online;
 	bool		block_requests;
 	bool		scan_blocked;
diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 0da7be40c925..5c54dee67e54 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -8789,9 +8789,11 @@ static struct pqi_ctrl_info *pqi_alloc_ctrl_info(int numa_node)
 		return NULL;
 
 	mutex_init(&ctrl_info->scan_mutex);
-	mutex_init(&ctrl_info->lun_reset_mutex);
 	mutex_init(&ctrl_info->ofa_mutex);
 
+	lockdep_register_key(&ctrl_info->lun_reset_key);
+	mutex_init_with_key(&ctrl_info->lun_reset_mutex, &ctrl_info->lun_reset_key);
+
 	INIT_LIST_HEAD(&ctrl_info->scsi_device_list);
 	spin_lock_init(&ctrl_info->scsi_device_list_lock);
 
@@ -8830,6 +8832,10 @@ static struct pqi_ctrl_info *pqi_alloc_ctrl_info(int numa_node)
 
 static inline void pqi_free_ctrl_info(struct pqi_ctrl_info *ctrl_info)
 {
+	mutex_destroy(&ctrl_info->scan_mutex);
+	mutex_destroy(&ctrl_info->ofa_mutex);
+	mutex_destroy(&ctrl_info->lun_reset_mutex);
+	lockdep_unregister_key(&ctrl_info->lun_reset_key);
 	kfree(ctrl_info);
 }
 
-- 
2.48.1

