From: Julia Lawall <Julia.Lawall@lip6.fr>
Subject: [PATCH 10/20] scsi: qla2xxx: drop useless LIST_HEAD
Date: Sun, 23 Dec 2018 09:57:05 +0100
Message-ID: <1545555435-24576-11-git-send-email-Julia.Lawall@lip6.fr>
References: <1545555435-24576-1-git-send-email-Julia.Lawall@lip6.fr>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1545555435-24576-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
To: qla2xxx-upstream@qlogic.com
Cc: kernel-janitors@vger.kernel.org, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Drop LIST_HEAD where the variable it declares is never used.

The uses of new_fcports were removed in 726b85487067 ("qla2xxx:
Add framework for async fabric discovery"), but not the
declaration.

The semantic patch that fixes this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
identifier x;
@@
- LIST_HEAD(x);
  ... when != x
// </smpl>

Fixes: 726b85487067 ("qla2xxx: Add framework for async fabric discovery")
Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
Successfully 0-day tested on 151 configurations.

 drivers/scsi/qla2xxx/qla_init.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 364bb52ed2a6..d72e3ad97a54 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -5400,7 +5400,6 @@ qla2x00_configure_fabric(scsi_qla_host_t *vha)
 	fc_port_t	*fcport;
 	uint16_t	mb[MAILBOX_REGISTER_COUNT];
 	uint16_t	loop_id;
-	LIST_HEAD(new_fcports);
 	struct qla_hw_data *ha = vha->hw;
 	int		discovery_gen;
 
