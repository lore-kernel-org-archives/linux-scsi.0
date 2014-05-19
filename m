From: Julia Lawall <Julia.Lawall@lip6.fr>
Subject: [PATCH 2/13 v2] [SCSI] qla2xxx: make return of 0 explicit
Date: Mon, 19 May 2014 06:47:12 +0200
Message-ID: <1400474832-22422-1-git-send-email-Julia.Lawall@lip6.fr>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: qla2xxx-upstream@qlogic.com
Cc: kernel-janitors@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Delete unnecessary use of a local variable to immediately return 0.

A simplified version of the semantic patch that fixes this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@r exists@
local idexpression ret;
expression e;
position p;
@@

-ret = 0;
... when != ret = e
return 
- ret
+ 0
  ;
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
Changed subject line, which was not appreciated by some spam filters.

 drivers/scsi/qla2xxx/qla_init.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 38aeb54..a63f9b6 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -4593,8 +4593,7 @@ qla2x00_abort_isp(scsi_qla_host_t *vha)
 		if (unlikely(pci_channel_offline(ha->pdev) &&
 		    ha->flags.pci_channel_io_perm_failure)) {
 			clear_bit(ISP_ABORT_RETRY, &vha->dpc_flags);
-			status = 0;
-			return status;
+			return 0;
 		}
 
 		ha->isp_ops->get_flash_version(vha, req->ring);
