Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D76D36729C
	for <linux-scsi@vger.kernel.org>; Fri, 21 Aug 2026 09:30:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787304648; cv=none; b=oLPY4SheRnFf4doiLCN8bU1PpjOxPubkhOXah7sx/igCuWFdaj/YHjZ3ZCC0jahXG8zwXky9CYQ1py4F8KJSdNt229R7F62uDBXeLU+4XCWS9vNn3uNXXJ4RfGm9Cl6c8J3L2yWm3WAxXMWy+TNVYINPIHBJAkxGuapJIilYWHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787304648; c=relaxed/simple;
	bh=i0h+vuUpJ7auxr08vZ6UZquoTLB8e+xAWHHfsgGBVi0=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=HaSoVLjG5nb3RXqrwPMs0UQNH1TffYBcmNeWV759f1i1wf1uvVde8ihq6Q2BhVIQ4xWJ9EjL0zMhBdCTPCQn1U8+60m36ocUfF/smTX46sORR/XCkGkK+yr05Rb6fYo2ZFTaETSByiGmgbNMuQ4ZVwsyjHVqpIeFMylg4wsJOYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4hRFQd11hZzYQv49
	for <linux-scsi@vger.kernel.org>; Fri, 21 Aug 2026 17:30:17 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.75])
	by mail.maildlp.com (Postfix) with ESMTP id 5EC6140594
	for <linux-scsi@vger.kernel.org>; Fri, 21 Aug 2026 17:30:37 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.87.132])
	by APP2 (Coremail) with UTF8SMTPSA id Syh0CgA3o4q7GohqZuCMDA--.3625S4;
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
Subject: [PATCH -next 0/2] scsi: iscsi: Fix races in connection cleanup path
Date: Fri, 21 Aug 2026 17:24:33 +0800
Message-Id: <20260821092435.1632931-1-yebin@huaweicloud.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:Syh0CgA3o4q7GohqZuCMDA--.3625S4
X-Coremail-Antispam: 1UD129KBjvJXoW7Ar4DuF47Cw1xJFWUtrWxXrb_yoW8AFy5pr
	45W3y5tw4DJ39akFs0vF4F9r1F9rs5KFyfKF17KFnxAa15JFyjvF4Ivw1qgF98CrZ7Jr17
	Zr42qFs5WF1jy3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUyKb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Jr0_JF4l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVWxJr0_GcWl84ACjcxK6I8E87Iv6xkF7I
	0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
	x7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
	0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lc7CjxVAaw2AFwI0_JF0_Jw1l42xK82IYc2Ij
	64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x
	8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE
	2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42
	xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF
	7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxUwxhLUUUUU
X-CM-SenderInfo: p1hex046kxt4xhlfz01xgou0bp/

From: Ye Bin <yebin10@huawei.com>

This series fixes two races in the iSCSI connection cleanup path that
were introduced by commit 23d6fefbb3f6 ("scsi: iscsi: Fix in-kernel
conn failure handling").

Patch 1 fixes a NULL pointer dereference in iscsi_sw_tcp_release_conn()
that occurs when userspace delivers STOP_CONN_TERM while the kernel has
already queued cleanup_work for the same connection. The two paths race
on tcp_sw_conn->sock: the userspace path clears it under sock_lock while
the workqueue path dereferences it locklessly in
iscsi_sw_tcp_conn_restore_callbacks(), leading to a NULL dereference.
The fix sets ISCSI_CLS_CONN_BIT_CLEANUP when userspace delivers
STOP_CONN_TERM to prevent concurrent invocation of iscsi_stop_conn().

Patch 2 fixes a use-after-free in iscsi_conn_release().
iscsi_conn_error_event() queues conn->cleanup_work without taking a
reference to the connection, so if the connection is freed (e.g. via
iscsi_remove_session() -> iscsi_iter_destroy_conn_fn()) while the work
is still pending or running, iscsi_cleanup_conn_work_fn() dereferences
freed memory. Unlike the iscsi_if_destroy_conn() and iscsi_if_stop_conn()
paths, the session teardown path does not handle the pending
cleanup_work before dropping the connection reference. The fix calls
cancel_work_sync(&conn->cleanup_work) in iscsi_conn_release() before
freeing the connection.

Ye Bin (2):
  scsi: iscsi: fix NULL pointer dereference in
    iscsi_sw_tcp_release_conn()
  scsi: iscsi: Fix use-after-free in iscsi_conn_release() for
    cleanup_work

 drivers/scsi/scsi_transport_iscsi.c | 50 +++++++++++++++++------------
 1 file changed, 30 insertions(+), 20 deletions(-)

-- 
2.34.1

