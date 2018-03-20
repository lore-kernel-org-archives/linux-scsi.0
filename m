From: Sinan Kaya <okaya@codeaurora.org>
Subject: [PATCH v4 3/7] scsi: dpt_i2o: eliminate duplicate barriers on weakly-ordered archs
Date: Mon, 19 Mar 2018 22:50:03 -0400
Message-ID: <1521514207-10695-4-git-send-email-okaya@codeaurora.org>
References: <1521514207-10695-1-git-send-email-okaya@codeaurora.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1521514207-10695-1-git-send-email-okaya@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, timur@codeaurora.org, sulrich@codeaurora.org
Cc: linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, Sinan Kaya <okaya@codeaurora.org>, Adaptec OEM Raid Solutions <aacraid@adaptec.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Code includes barrier() followed by writel(). writel() already has a
barrier
on some architectures like arm64.

This ends up CPU observing two barriers back to back before executing the
register write.

Since code already has an explicit barrier call, changing writel() to
writel_relaxed().

Signed-off-by: Sinan Kaya <okaya@codeaurora.org>
---
 drivers/scsi/dpt_i2o.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/dpt_i2o.c b/drivers/scsi/dpt_i2o.c
index fd172b0..3c1e64a 100644
--- a/drivers/scsi/dpt_i2o.c
+++ b/drivers/scsi/dpt_i2o.c
@@ -1300,7 +1300,7 @@ static s32 adpt_i2o_post_this(adpt_hba* pHba, u32* data, int len)
 	wmb();
 
 	//post message
-	writel(m, pHba->post_port);
+	writel_relaxed(m, pHba->post_port);
 	wmb();
 
 	return 0;
@@ -1390,7 +1390,7 @@ static s32 adpt_i2o_reset_hba(adpt_hba* pHba)
 
 	memcpy_toio(pHba->msg_addr_virt+m, msg, sizeof(msg));
 	wmb();
-	writel(m, pHba->post_port);
+	writel_relaxed(m, pHba->post_port);
 	wmb();
 
 	while(*status == 0){
@@ -2797,7 +2797,7 @@ static s32 adpt_send_nop(adpt_hba*pHba,u32 m)
 	writel( 0,&msg[2]);
 	wmb();
 
-	writel(m, pHba->post_port);
+	writel_relaxed(m, pHba->post_port);
 	wmb();
 	return 0;
 }
-- 
2.7.4
