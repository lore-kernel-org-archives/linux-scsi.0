From: Sinan Kaya <okaya@codeaurora.org>
Subject: [PATCH v4 7/7] scsi: csiostor: Eliminate duplicate barriers on weakly-ordered archs
Date: Mon, 19 Mar 2018 22:50:07 -0400
Message-ID: <1521514207-10695-8-git-send-email-okaya@codeaurora.org>
References: <1521514207-10695-1-git-send-email-okaya@codeaurora.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1521514207-10695-1-git-send-email-okaya@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, timur@codeaurora.org, sulrich@codeaurora.org
Cc: linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, Sinan Kaya <okaya@codeaurora.org>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Varun Prakash <varun@chelsio.com>, Peter Senna Tschudin <peter.senna@collabora.com>, Romain Perier <romain.perier@collabora.com>, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Code includes barrier() followed by writel(). writel() already has a
barrier
on some architectures like arm64.

This ends up CPU observing two barriers back to back before executing the
register write.

Create a new wrapper function with relaxed write operator. Use the new
wrapper when a write is following a barrier().

Signed-off-by: Sinan Kaya <okaya@codeaurora.org>
---
 drivers/scsi/csiostor/csio_hw.h | 4 ++++
 drivers/scsi/csiostor/csio_wr.c | 2 +-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/csiostor/csio_hw.h b/drivers/scsi/csiostor/csio_hw.h
index 30f5f52..9fd8b00 100644
--- a/drivers/scsi/csiostor/csio_hw.h
+++ b/drivers/scsi/csiostor/csio_hw.h
@@ -512,6 +512,10 @@ struct csio_hw {
 						csio_reg((_h)->regstart, (_r)))
 #define	csio_wr_reg16(_h, _v, _r)	writew((_v), \
 						csio_reg((_h)->regstart, (_r)))
+
+#define	csio_wr_reg32_relaxed(_h, _v, _r) \
+	writel_relaxed((_v), csio_reg((_h)->regstart, (_r)))
+
 #define	csio_wr_reg32(_h, _v, _r)	writel((_v), \
 						csio_reg((_h)->regstart, (_r)))
 #define	csio_wr_reg64(_h, _v, _r)	writeq((_v), \
diff --git a/drivers/scsi/csiostor/csio_wr.c b/drivers/scsi/csiostor/csio_wr.c
index c0a1778..db26222 100644
--- a/drivers/scsi/csiostor/csio_wr.c
+++ b/drivers/scsi/csiostor/csio_wr.c
@@ -984,7 +984,7 @@ csio_wr_issue(struct csio_hw *hw, int qidx, bool prio)
 
 	wmb();
 	/* Ring SGE Doorbell writing q->pidx into it */
-	csio_wr_reg32(hw, DBPRIO_V(prio) | QID_V(q->un.eq.physeqid) |
+	csio_wr_reg32_relaxed(hw, DBPRIO_V(prio) | QID_V(q->un.eq.physeqid) |
 			  PIDX_T5_V(q->inc_idx) | DBTYPE_F,
 			  MYPF_REG(SGE_PF_KDOORBELL_A));
 	q->inc_idx = 0;
-- 
2.7.4
