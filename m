Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E558443A88
	for <linux-scsi@vger.kernel.org>; Fri, 21 Aug 2026 09:30:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787304650; cv=none; b=UkoTkMGV2KetEwI4q93s5YaKLE2oPidMcroRbURqd9P4gZmyM+CGQlO4cY/Irp5h9X/eR0R3wzdmWNub/FfvOLbAQ7NkPNMzShzFnZ06J3E3ULrZBmAcYhBcB1NoJisOKiEZIfflWSFzyKBsSm/Ve/PatsvNEO6bfHBfJby+KYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787304650; c=relaxed/simple;
	bh=7hMrDytZk4rXQNcGEKzJJbOYPcD2ETUB3xZNb34nPPU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=RHQnm9vuTumChDInQiDLrhxT1hxSgIIRrHZouyPh2ZGSmfSUM7nKGVZuMRxUcwWXkMK77o1AXhkU9CKbJnOZwF8XoWZ7lHSCMnKU2zS5gHhPTuiarOfPmYIgRd554ghJ4rFu64KuUUMIty2OVxm6P6LCtblpyErPaBG4ZyUKocg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4hRFQP28djzKHMhv
	for <linux-scsi@vger.kernel.org>; Fri, 21 Aug 2026 17:30:05 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.75])
	by mail.maildlp.com (Postfix) with ESMTP id 7693F4056D
	for <linux-scsi@vger.kernel.org>; Fri, 21 Aug 2026 17:30:37 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.87.132])
	by APP2 (Coremail) with UTF8SMTPSA id Syh0CgA3o4q7GohqZuCMDA--.3625S6;
	Fri, 21 Aug 2026 17:30:37 +0800 (CST)
From: Ye Bin <yebin@huaweicloud.com>
To: lduncan@suse.com,
	cleech@redhat.com,
	michael.christie@oracle.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	open-iscsi@googlegroups.com,
	linux-scsi@vger.kernel.org
Cc: yebin10@huawei.com
Subject: [PATCH -next 2/2] scsi: iscsi: Fix use-after-free in iscsi_conn_release() for cleanup_work
Date: Fri, 21 Aug 2026 17:24:35 +0800
Message-Id: <20260821092435.1632931-3-yebin@huaweicloud.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260821092435.1632931-1-yebin@huaweicloud.com>
References: <20260821092435.1632931-1-yebin@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:Syh0CgA3o4q7GohqZuCMDA--.3625S6
X-Coremail-Antispam: 1UD129KBjvJXoWxZFWDAF17Kw1kCFyxJF1xuFg_yoW5WFWfpr
	4ag343G3yDJr1Fkrs8Jr10qFyrKFs5Gry7tFy8C3Z5Zas8AryDtF4xt3WF9FyUGrykJr1a
	vF4jqaykWFy5ArJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9Cb4IE77IF4wAFF20E14v26rWj6s0DM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI8067AKxVWUXw
	A2048vs2IY020Ec7CjxVAFwI0_Gr0_Xr1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxS
	w2x7M28EF7xvwVC0I7IYx2IY67AKxVWUJVWUCwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxV
	W8JVWxJwA2z4x0Y4vEx4A2jsIE14v26F4UJVW0owA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_
	GcCE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx
	0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWU
	JVW8JwACjcxG0xvY0x0EwIxGrwCY1x0262kKe7AKxVWUAVWUtwCF04k20xvY0x0EwIxGrw
	CFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE
	14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2
	IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxK
	x2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI
	0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07jYLvtUUUUU=
X-CM-SenderInfo: p1hex046kxt4xhlfz01xgou0bp/

From: Ye Bin <yebin10@huawei.com>

iscsi_conn_error_event() queues conn->cleanup_work without taking a
reference to the connection. If the connection's refcount drops to zero
while the work is still pending or running, iscsi_conn_release() frees
the connection memory without canceling the work, leading to a
use-after-free when iscsi_cleanup_conn_work_fn() later dereferences the
freed conn struct.

This can happen when a session is torn down via iscsi_remove_session(),
which calls iscsi_iter_destroy_conn_fn() to remove and drop the final
reference on each remaining connection. Unlike iscsi_if_destroy_conn()
(which flushes the work) and iscsi_if_stop_conn() (which cancels or
flushes the work), the iscsi_iter_destroy_conn_fn() path does not handle
the pending cleanup_work before dropping the connection reference.

Trigger flow:

  CPU 0 (error path)               CPU 1 (session teardown)
  -----------------------          --------------------------
  iscsi_conn_error_event(conn)
    queue_work(cleanup_work)
    [no conn reference taken]      iscsi_remove_session()
                                     iscsi_iter_destroy_conn_fn()
                                       iscsi_remove_conn(conn)
                                       iscsi_put_conn(conn)
                                         refcount == 0
                                         iscsi_conn_release()
                                           kfree(conn)

  [workqueue picks up work]
  iscsi_cleanup_conn_work_fn()
    container_of(work, ...)
    mutex_lock(&conn->ep_mutex)     *** USE-AFTER-FREE ***

Fix this by calling cancel_work_sync(&conn->cleanup_work) in
iscsi_conn_release() before freeing the connection. This is safe
because:
  - iscsi_conn_release() is always called in process context
  - iscsi_cleanup_conn_work_fn() never drops a conn reference, so
    there is no deadlock risk
  - If the work is running, cancel_work_sync() waits for it to
    complete before kfree(conn), keeping conn valid during execution
  - If the work is pending, it is simply canceled, which is harmless
    since the connection is being destroyed

Fixes: 23d6fefbb3f6 ("scsi: iscsi: Fix in-kernel conn failure handling")
Signed-off-by: Ye Bin <yebin10@huawei.com>
---
 drivers/scsi/scsi_transport_iscsi.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index aea319c1e72f..cdc337b0fc26 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -2128,6 +2128,13 @@ static void iscsi_conn_release(struct device *dev)
 	struct device *parent = conn->dev.parent;
 
 	ISCSI_DBG_TRANS_CONN(conn, "Releasing conn\n");
+	/*
+	 * iscsi_conn_error_event() may have queued conn->cleanup_work without
+	 * holding a reference to the connection. Cancel any pending or
+	 * running work before freeing the connection to prevent a
+	 * use-after-free.
+	 */
+	cancel_work_sync(&conn->cleanup_work);
 	kfree(conn);
 	put_device(parent);
 }
-- 
2.34.1

