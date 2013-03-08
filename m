From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch] [SCSI] bfa: Use GFP_ATOMIC under spin_lock
Date: Fri, 8 Mar 2013 15:01:15 +0300
Message-ID: <20130308120115.GA18712@longonot.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Anil Gurumurthy <agurumur@brocade.com>
Cc: Vijaya Mohan Guvva <vmohan@brocade.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This is always called with spinlocks held so it should use
GFP_ATOMIC.  The call tree is:

-> bfad_drv_start()
   Takes spin_lock_irqsave(&bfad->bfad_lock, flags);
   -> bfa_fcs_pbc_vport_init()
      -> bfa_fcb_pbc_vport_create()

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/scsi/bfa/bfad.c b/drivers/scsi/bfa/bfad.c
index a5f7690..d144a06 100644
--- a/drivers/scsi/bfa/bfad.c
+++ b/drivers/scsi/bfa/bfad.c
@@ -491,7 +491,7 @@ bfa_fcb_pbc_vport_create(struct bfad_s *bfad, struct bfi_pbc_vport_s pbc_vport)
 	struct bfad_vport_s   *vport;
 	int rc;
 
-	vport = kzalloc(sizeof(struct bfad_vport_s), GFP_KERNEL);
+	vport = kzalloc(sizeof(struct bfad_vport_s), GFP_ATOMIC);
 	if (!vport) {
 		bfa_trc(bfad, 0);
 		return;
