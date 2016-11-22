From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 4/5] scsi: bnx2fc: annoate unlock + release for sparse
Date: Tue, 22 Nov 2016 18:48:12 +0100
Message-ID: <20161122174813.16184-5-bigeasy@linutronix.de>
References: <20161122174813.16184-1-bigeasy@linutronix.de>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from Galois.linutronix.de ([146.0.238.70]:60418 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933722AbcKVRs0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Nov 2016 12:48:26 -0500
In-Reply-To: <20161122174813.16184-1-bigeasy@linutronix.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Chad Dupuis <chad.dupuis@qlogic.com>, rt@linutronix.de, QLogic-Storage-Upstream@qlogic.com, Johannes Thumshirn <jth@kernel.org>, Christoph Hellwig <hch@lst.de>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>

The caller of bnx2fc_abts_cleanup() holds the tgt->tgt_lock lock and it
is expected to release the lock during wait_for_completion() and acquire
the lock afterwards.

This patch was only compile-tested due to -ENODEV.

Cc: QLogic-Storage-Upstream@qlogic.com
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/scsi/bnx2fc/bnx2fc_io.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_io.c b/drivers/scsi/bnx2fc/bnx2fc_i=
o.c
index f501095f91ac..634e1e539850 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_io.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_io.c
@@ -1080,6 +1080,8 @@ int bnx2fc_eh_device_reset(struct scsi_cmnd *sc_cmd)
 }
=20
 static int bnx2fc_abts_cleanup(struct bnx2fc_cmd *io_req)
+__releases(tgt->tgt_lock)
+__acquires(tgt->tgt_lock)
 {
 	struct bnx2fc_rport *tgt =3D io_req->tgt;
 	int rc =3D SUCCESS;
--=20
2.10.2

