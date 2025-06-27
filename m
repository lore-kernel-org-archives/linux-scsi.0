Received: from stargate.chelsio.com (unknown [12.32.117.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B851A202C50
	for <linux-scsi@vger.kernel.org>; Fri, 27 Jun 2025 10:34:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=12.32.117.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751020460; cv=none; b=mu5WuFZlKXoQ9msN/ZoC62NyrJYDNSHdbmCSbX+b8c+8N6smszpUhvPU3TzJ5fnr7w9Uh6Wx4Ye3SkJt8E3ua0J1GS+QLz7PC9IyStWUQkjmotW+4z8lKLnLMinQtVvUNd5MJctAwmn9bkqlXpe9M4bpER9zS4SDWKaVq2/DJCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751020460; c=relaxed/simple;
	bh=Yx1hxyuhRPkNOMT7u/nsDRogCcRi+9XU2JMlTt6Q3PQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=thrDbuMTexlG8pJ86GB++dcGUr0kjgDrc5BtOMyHhVSj4T++IhjAdGLEWUQzoSkE4DHRj0NNRI/EQeljjHImKn/8mxtU1t4fb1lR6s68HHIUdd8yOxNcJbmTjMDvPukWPMekRYZEZwxavw3ixjlTCqZlMVabm5vOcdlN6x4fCUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=chelsio.com; spf=pass smtp.mailfrom=chelsio.com; arc=none smtp.client-ip=12.32.117.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=chelsio.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chelsio.com
Received: from gayabhari.blr.asicdesigners.com (gayabari.blr.asicdesigners.com [10.193.186.186])
	by stargate.chelsio.com (8.14.7/8.14.7) with ESMTP id 55RAY0Uq022815;
	Fri, 27 Jun 2025 03:34:01 -0700
From: Showrya M N <showrya@chelsio.com>
To: lduncan@suse.com, michael.christie@oracle.com, martin.petersen@oracle.com,
        cleech@redhat.com
Cc: linux-scsi@vger.kernel.org, showrya@chelsio.com, bharat@chelsio.com
Subject: [PATCH for-rc] scsi: libiscsi: initialize iscsi_conn->dd_data only if memory is allocated
Date: Fri, 27 Jun 2025 16:53:29 +0530
Message-Id: <20250627112329.19763-1-showrya@chelsio.com>
X-Mailer: git-send-email 2.39.3
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In case of an ib_fast_reg_mr allocation failure during iSER setup,
the machine hits a panic because iscsi_conn->dd_data is initialized
unconditionally, even when no memory is allocated (dd_size == 0).
This leads invalid pointer dereference during connection teardown.

Fix by setting iscsi_conn->dd_data only if memory is actually allocated.

Panic trace:
------------
 iser: iser_create_fastreg_desc: Failed to allocate ib_fast_reg_mr err=-12
 iser: iser_alloc_rx_descriptors: failed allocating rx descriptors / data buffers
 BUG: unable to handle page fault for address: fffffffffffffff8
 RIP: 0010:swake_up_locked.part.5+0xa/0x40
 Call Trace:
  complete+0x31/0x40
  iscsi_iser_conn_stop+0x88/0xb0 [ib_iser]
  iscsi_stop_conn+0x66/0xc0 [scsi_transport_iscsi]
  iscsi_if_stop_conn+0x14a/0x150 [scsi_transport_iscsi]
  iscsi_if_rx+0x1135/0x1834 [scsi_transport_iscsi]
  ? netlink_lookup+0x12f/0x1b0
  ? netlink_deliver_tap+0x2c/0x200
  netlink_unicast+0x1ab/0x280
  netlink_sendmsg+0x257/0x4f0
  ? _copy_from_user+0x29/0x60
  sock_sendmsg+0x5f/0x70

Signed-off-by: Showrya M N <showrya@chelsio.com>
Signed-off-by: Potnuri Bharat Teja <bharat@chelsio.com>
---
 drivers/scsi/libiscsi.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 392d57e054db..c9f410c50978 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -3185,7 +3185,8 @@ iscsi_conn_setup(struct iscsi_cls_session *cls_session, int dd_size,
 		return NULL;
 	conn = cls_conn->dd_data;
 
-	conn->dd_data = cls_conn->dd_data + sizeof(*conn);
+	if (dd_size)
+		conn->dd_data = cls_conn->dd_data + sizeof(*conn);
 	conn->session = session;
 	conn->cls_conn = cls_conn;
 	conn->c_stage = ISCSI_CONN_INITIAL_STAGE;
-- 
2.39.3

