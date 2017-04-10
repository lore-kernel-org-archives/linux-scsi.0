From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 4/5] scsi: bnx2fc: annoate unlock + release for sparse
Date: Mon, 10 Apr 2017 19:12:53 +0200
Message-ID: <20170410171254.30367-5-bigeasy@linutronix.de>
References: <20170410171254.30367-1-bigeasy@linutronix.de>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from Galois.linutronix.de ([146.0.238.70]:52132 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753419AbdDJRNI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 10 Apr 2017 13:13:08 -0400
In-Reply-To: <20170410171254.30367-1-bigeasy@linutronix.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org
Cc: rt@linutronix.de, Lee Duncan <lduncan@suse.com>, Chris Leech <cleech@redhat.com>, Chad Dupuis <chad.dupuis@qlogic.com>, QLogic-Storage-Upstream@qlogic.com, Johannes Thumshirn <jth@kernel.org>, Christoph Hellwig <hch@lst.de>, Andrew Morton <akpm@linux-foundation.org>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>

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
index 898461b146cc..3eed2453648c 100644
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
2.11.0
