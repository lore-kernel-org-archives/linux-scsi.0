From: Julia Lawall <Julia.Lawall@lip6.fr>
Subject: [PATCH 10/15] scsi: don't export static symbol
Date: Wed, 11 Mar 2015 17:56:32 +0100
Message-ID: <1426092997-30605-11-git-send-email-Julia.Lawall@lip6.fr>
References: <1426092997-30605-1-git-send-email-Julia.Lawall@lip6.fr>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1426092997-30605-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: kernel-janitors@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, daniel@iogearbox.net
List-Id: linux-scsi@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

The semantic patch that fixes this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@r@
type T;
identifier f;
@@

static T f (...) { ... }

@@
identifier r.f;
declarer name EXPORT_SYMBOL;
@@

-EXPORT_SYMBOL(f);
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/scsi/libsas/sas_scsi_host.c |    1 -
 1 file changed, 1 deletion(-)

diff -u -p a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
--- a/drivers/scsi/libsas/sas_scsi_host.c
+++ b/drivers/scsi/libsas/sas_scsi_host.c
@@ -440,7 +440,6 @@ static void sas_wait_eh(struct domain_de
 		goto retry;
 	}
 }
-EXPORT_SYMBOL(sas_wait_eh);
 
 static int sas_queue_reset(struct domain_device *dev, int reset_type,
 			   u64 lun, int wait)
