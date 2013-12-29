From: Julia Lawall <Julia.Lawall@lip6.fr>
Subject: [PATCH 24/25]  fix error return code
Date: Sun, 29 Dec 2013 23:47:39 +0100
Message-ID: <1388357260-4843-25-git-send-email-Julia.Lawall@lip6.fr>
References: <1388357260-4843-1-git-send-email-Julia.Lawall@lip6.fr>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1388357260-4843-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
To: Eddie Wai <eddie.wai@broadcom.com>
Cc: kernel-janitors@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Set the return variable to an error code as done elsewhere in the function.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
(
if@p1 (\(ret < 0\|ret != 0\))
 { ... return ret; }
|
ret@p1 = 0
)
... when != ret = e1
    when != &ret
*if(...)
{
  ... when != ret = e2
      when forall
 return ret;
}

// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
Not tested.

 drivers/scsi/bnx2fc/bnx2fc_fcoe.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
index 9b94850..d8cb194 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
@@ -2199,6 +2199,7 @@ static int _bnx2fc_create(struct net_device *netdev,
 	interface = bnx2fc_interface_create(hba, netdev, fip_mode);
 	if (!interface) {
 		printk(KERN_ERR PFX "bnx2fc_interface_create failed\n");
+		rc = -ENOMEM;
 		goto ifput_err;
 	}
 
