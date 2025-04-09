Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D18F26AF5
	for <linux-scsi@vger.kernel.org>; Wed,  9 Apr 2025 01:29:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744162182; cv=none; b=pjlDX7pVhqRnOWIWEIMljKdpZIsn5asS6WBdsZ6kEQbc0hPoCk/GdAC00d//4dppxcHkLTZPbGXaY7dS/FZ3SNJBynz0rZpwNixKh5gFYIF4s10rATKnf7EPw7crBLVAflyvTKWwrw+C2qFQFD1dLo+H4MULxS75ZjgEVSbpqhA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744162182; c=relaxed/simple;
	bh=A53SRAiflstKJLcYcl4nvrnmCpFsjwmcXeakoVFrwaE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=YyyZfQ9WZKn7HJrNgQCqUyFNaw/MTYDTReY69qtY3kVGgQ0koYCZ3xDtQvItR/IXINNBlTR46TXl8AuVcW3Kt9W71PpoMqNvIko4iq6uGwRiaJdAbyC0gcddwDX0oUKpA0AgJx40fu9NfJI5UAOeYZRBVAqng/MfSq3DXy5qe4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4ZXQMp34tRz4f3lff
	for <linux-scsi@vger.kernel.org>; Wed,  9 Apr 2025 09:29:10 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 68A851A0ADC
	for <linux-scsi@vger.kernel.org>; Wed,  9 Apr 2025 09:29:35 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.101.107])
	by APP4 (Coremail) with SMTP id gCh0CgCnCl99zfVnMme3Iw--.5740S4;
	Wed, 09 Apr 2025 09:29:35 +0800 (CST)
From: Ye Bin <yebin@huaweicloud.com>
To: lduncan@suse.com,
	martin.petersen@oracle.com,
	linux-scsi@vger.kernel.org,
	michael.christie@oracle.com,
	James.Bottomley@HansenPartnership.com,
	open-iscsi@googlegroups.com
Cc: cleech@redhat.com
Subject: [PATCH] scsi: iscsi: print error info after unlock 'frwd_lock' in iscsi_check_transport_timeouts()
Date: Wed,  9 Apr 2025 09:29:33 +0800
Message-Id: <20250409012933.3101354-1-yebin@huaweicloud.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgCnCl99zfVnMme3Iw--.5740S4
X-Coremail-Antispam: 1UD129KBjvJXoWxJrWUZrW5XF4ktw13Ww47twb_yoW8Cw45pa
	1Fg398JrWUZr1Sk3WkCrsrZryYqw4kJrWUKF1Dt348uFn8tFZxKr47K3s0ga42gFs2qrW3
	XF1rWF1DCF40gw7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUyKb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JMxkF7I0En4kS14v26r126r1DMxAIw28IcxkI
	7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxV
	Cjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUAVWUtwCIc40Y0x0EwIxGrwCI42IY
	6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6x
	AIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY
	1x0267AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjxUwxhLUUUUU
X-CM-SenderInfo: p1hex046kxt4xhlfz01xgou0bp/

From: Ye Bin <yebin10@huawei.com>

When a timeout occurs in iscsi_check_transport_timeouts(), it may be
accompanied by many storage failures, and there may be many error logs
printed to the serial port in a short period. In the case of a slow
serial port, it may take a long time to output to the serial port in
printk while holding the "&session->frwd_lock" lock. This can cause
other processes to be unable to obtain the "&session->frwd_lock" lock,
triggering a series of issues. To reduce the critical section of the
"&session->frwd_lock" lock, error printing is moved outside the lock.

Signed-off-by: Ye Bin <yebin10@huawei.com>
---
 drivers/scsi/libiscsi.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 1ddaf7228340..bbaed4eccfbf 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -2252,20 +2252,23 @@ static void iscsi_check_transport_timeouts(struct timer_list *t)
 	if (!recv_timeout)
 		goto done;
 
-	recv_timeout *= HZ;
 	last_recv = conn->last_recv;
 
 	if (iscsi_has_ping_timed_out(conn)) {
+		int ping_timeout = conn->ping_timeout;
+		unsigned long last_ping = conn->last_ping;
+
+		spin_unlock(&session->frwd_lock);
 		iscsi_conn_printk(KERN_ERR, conn, "ping timeout of %d secs "
-				  "expired, recv timeout %d, last rx %lu, "
+				  "expired, recv timeout %lu, last rx %lu, "
 				  "last ping %lu, now %lu\n",
-				  conn->ping_timeout, conn->recv_timeout,
-				  last_recv, conn->last_ping, jiffies);
-		spin_unlock(&session->frwd_lock);
+				  ping_timeout, recv_timeout,
+				  last_recv, last_ping, jiffies);
 		iscsi_conn_failure(conn, ISCSI_ERR_NOP_TIMEDOUT);
 		return;
 	}
 
+	recv_timeout *= HZ;
 	if (time_before_eq(last_recv + recv_timeout, jiffies)) {
 		/* send a ping to try to provoke some traffic */
 		ISCSI_DBG_CONN(conn, "Sending nopout as ping\n");
-- 
2.34.1

