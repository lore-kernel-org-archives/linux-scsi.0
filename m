Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A653414A4C8
	for <linux-scsi@vger.kernel.org>; Wed,  3 Apr 2024 15:02:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712156530; cv=none; b=VkKjIxhB1kw7ljr8jznp+eojyLF98a00Crql8TVM7z3lpv9+CwKGeY5Yjj/D78rgByhjVJ1f5+JhpnN4oQhrvDhLbEG/ic1to+s/X6PGy8XzCftn8dJNc0km7N9AbB1YoWqnQP3IvkyaEmnWK7UarRsBLpv2DxqxX4xYeCa4ptI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712156530; c=relaxed/simple;
	bh=ioFvbQBkOvvRJTerHaz3kt8URF8buDZfWEZ3pwNg3io=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-type; b=hIuFrhpaTP1+/x/onQ4NZyhX6zi4jw1LA38kdypLTiZuywQflpe63kNky9DC6kbDgO07pKKXVG/NdJHK5+2TlgXM9DMM22ZjgAlNwtchVclP2gPUzRYl9a946lMfurpRd/fYhAWtfXdYlZYnSdpL2uZBL5TqGnqPAJEAShFykQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Z7esE4LO; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Z7esE4LO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1712156527;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=4HK4/miNnJq7CYq44ZkiuwwHjBixcP9cHfRzM+l+ZEU=;
	b=Z7esE4LOaFusQ5zE6ylCGC6G6RcGIgYB0Q/n0YwufjtZ3fr/s4kffRVfnzoDFpP3Z4lC3V
	xdr93Aw8oL1wXR+ylDR7KKTCBL4bg/L40VVAL8a5HeKInrXt5c7niolxPJIa4EZVk+9+ju
	sh3P5gXktQq0bySb1SpipKs/IhoaA9w=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-271-xewL20k3PRaqkTCkhOTtrw-1; Wed,
 03 Apr 2024 11:02:03 -0400
X-MC-Unique: xewL20k3PRaqkTCkhOTtrw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1049A1C07F38;
	Wed,  3 Apr 2024 15:02:03 +0000 (UTC)
Received: from jmeneghi.bos.com (unknown [10.18.25.182])
	by smtp.corp.redhat.com (Postfix) with ESMTP id CFFB71121306;
	Wed,  3 Apr 2024 15:02:02 +0000 (UTC)
From: John Meneghini <jmeneghi@redhat.com>
To: skashyap@marvell.com
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	GR-QLogic-Storage-Upstream@marvell.com,
	martin.petersen@oracle.com,
	guazhang@redhat.com,
	njavali@marvell.com
Subject: [PATCH] scsi: qedf: make qedf_execute_tmf non-preemptible
Date: Wed,  3 Apr 2024 11:01:55 -0400
Message-Id: <20240403150155.412954-1-jmeneghi@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.3

Stop calling smp_processor_id from preemptible code in qedf_execute_tmf.
This results in BUGON when running an RT kernel.

[ 659.343280] BUG: using smp_processor_id() in preemptible [00000000] code: sg_reset/3646
[ 659.343282] caller is qedf_execute_tmf+0x8b/0x360 [qedf]

Tested-by: Guangwu Zhang <guazhang@redhat.com>
Cc: Saurav Kashyap <skashyap@marvell.com>
Cc: Nilesh Javali <njavali@marvell.com>
Signed-off-by: John Meneghini <jmeneghi@redhat.com>
---
 drivers/scsi/qedf/qedf_io.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qedf/qedf_io.c b/drivers/scsi/qedf/qedf_io.c
index bf921caaf6ae..054a51713d55 100644
--- a/drivers/scsi/qedf/qedf_io.c
+++ b/drivers/scsi/qedf/qedf_io.c
@@ -2324,9 +2324,6 @@ static int qedf_execute_tmf(struct qedf_rport *fcport, u64 tm_lun,
 	io_req->fcport = fcport;
 	io_req->cmd_type = QEDF_TASK_MGMT_CMD;
 
-	/* Record which cpu this request is associated with */
-	io_req->cpu = smp_processor_id();
-
 	/* Set TM flags */
 	io_req->io_req_flags = QEDF_READ;
 	io_req->data_xfer_len = 0;
@@ -2349,6 +2346,9 @@ static int qedf_execute_tmf(struct qedf_rport *fcport, u64 tm_lun,
 
 	spin_lock_irqsave(&fcport->rport_lock, flags);
 
+	/* Record which cpu this request is associated with */
+	io_req->cpu = smp_processor_id();
+
 	sqe_idx = qedf_get_sqe_idx(fcport);
 	sqe = &fcport->sq[sqe_idx];
 	memset(sqe, 0, sizeof(struct fcoe_wqe));
-- 
2.39.3

