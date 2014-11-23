From: Julia Lawall <Julia.Lawall@lip6.fr>
Subject: [PATCH 1/5] mptfusion: fix error return code
Date: Sun, 23 Nov 2014 14:11:14 +0100
Message-ID: <1416748278-22881-2-git-send-email-Julia.Lawall@lip6.fr>
References: <1416748278-22881-1-git-send-email-Julia.Lawall@lip6.fr>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1416748278-22881-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
To: Nagalakshmi Nandigama <nagalakshmi.nandigama@avagotech.com>
Cc: kernel-janitors@vger.kernel.org, Praveen Krishnamoorthy <praveen.krishnamoorthy@avagotech.com>, Sreekanth Reddy <sreekanth.reddy@avagotech.com>, Abhijit Mahajan <abhijit.mahajan@avagotech.com>, MPT-FusionLinux.pdl@avagotech.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Return a negative error code on failure.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@@
identifier ret; expression e1,e2;
@@
(
if (\(ret < 0\|ret != 0\))
 { ... return ret; }
|
ret = 0
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
 drivers/message/fusion/mptfc.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/message/fusion/mptfc.c b/drivers/message/fusion/mptfc.c
index d8bf84a..629df6d 100644
--- a/drivers/message/fusion/mptfc.c
+++ b/drivers/message/fusion/mptfc.c
@@ -1325,8 +1325,10 @@ mptfc_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		 "mptfc_wq_%d", sh->host_no);
 	ioc->fc_rescan_work_q =
 		create_singlethread_workqueue(ioc->fc_rescan_work_q_name);
-	if (!ioc->fc_rescan_work_q)
+	if (!ioc->fc_rescan_work_q) {
+		error = -ENOMEM;
 		goto out_mptfc_probe;
+	}
 
 	/*
 	 *  Pre-fetch FC port WWN and stuff...
