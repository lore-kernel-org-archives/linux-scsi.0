From: Julia Lawall <Julia.Lawall@lip6.fr>
Subject: [PATCH 5/8] drivers/scsi/qla2xxx/qla_nx.c: drop if around WARN_ON
Date: Sat,  3 Nov 2012 21:30:22 +0100
Message-ID: <1351974625-10282-6-git-send-email-Julia.Lawall@lip6.fr>
References: <1351974625-10282-1-git-send-email-Julia.Lawall@lip6.fr>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1351974625-10282-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: kernel-janitors@vger.kernel.org, linux-driver@qlogic.com, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Just use WARN_ON rather than an if containing only WARN_ON(1).

A simplified version of the semantic patch that makes this transformation
is as follows: (http://coccinelle.lip6.fr/)

// <smpl>
@@
expression e;
@@
- if (e) WARN_ON(1);
+ WARN_ON(e);
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/scsi/qla2xxx/qla_nx.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_nx.c b/drivers/scsi/qla2xxx/qla_nx.c
index f5e297c..4c62a5d 100644
--- a/drivers/scsi/qla2xxx/qla_nx.c
+++ b/drivers/scsi/qla2xxx/qla_nx.c
@@ -388,8 +388,7 @@ qla82xx_pci_set_crbwindow(struct qla_hw_data *ha, u64 off)
 
 	if ((off >= QLA82XX_CRB_PCIX_HOST) && (off < QLA82XX_CRB_PCIX_HOST2)) {
 		/* We are in first CRB window */
-		if (ha->curr_window != 0)
-			WARN_ON(1);
+		WARN_ON(ha->curr_window != 0);
 		return off;
 	}
 
