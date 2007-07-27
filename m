From: Jesper Juhl <jesper.juhl@gmail.com>
Subject: [PATCH][sas] Fix potential NULL pointer dereference bug in sas_smp_get_phy_events()
Date: Fri, 27 Jul 2007 23:27:57 +0200
Message-ID: <200707272327.57356.jesper.juhl@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ik-out-1112.google.com ([66.249.90.183]:19614 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761271AbXG0V3P (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Jul 2007 17:29:15 -0400
Received: by ik-out-1112.google.com with SMTP id b32so751746ika
        for <linux-scsi@vger.kernel.org>; Fri, 27 Jul 2007 14:29:12 -0700 (PDT)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Luben Tuikov <luben_tuikov@adaptec.com>, James Bottomley <James.Bottomley@steeleye.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Jesper Juhl <jesper.juhl@gmail.com>

Hello,

In sas_smp_get_phy_events() we never test if the call to 
alloc_smp_req(RPEL_REQ_SIZE) succeeds or fails. That means we run 
the risk of dereferencing a NULL pointer if it does fail. Far 
better to test if we got NULL back and in that case return -ENOMEM 
just as we already do for the other memory allocation in that 
function.
This patch reworks the memory allocation a bit to deal with it 
(compile tested only).


Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---

 drivers/scsi/libsas/sas_expander.c |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
index b500f0c..85f5145 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -507,14 +507,21 @@ static int sas_dev_present_in_domain(struct asd_sas_port *port,
 int sas_smp_get_phy_events(struct sas_phy *phy)
 {
 	int res;
+	u8 *req;
+	u8 *resp;
 	struct sas_rphy *rphy = dev_to_rphy(phy->dev.parent);
 	struct domain_device *dev = sas_find_dev_by_rphy(rphy);
-	u8 *req = alloc_smp_req(RPEL_REQ_SIZE);
-	u8 *resp = kzalloc(RPEL_RESP_SIZE, GFP_KERNEL);
 
+	resp = kzalloc(RPEL_RESP_SIZE, GFP_KERNEL);
 	if (!resp)
 		return -ENOMEM;
 
+	req = alloc_smp_req(RPEL_REQ_SIZE);
+	if (!req) {
+        	res = -ENOMEM;
+		goto out;
+	}
+
 	req[1] = SMP_REPORT_PHY_ERR_LOG;
 	req[9] = phy->number;
 





  PS. Please keep me on Cc when replying.


