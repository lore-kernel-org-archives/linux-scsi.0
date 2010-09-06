From: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>
Subject: [PATCH 09/14] drivers/scsi: Removing undead ifdef REAL_DMA
Date: Mon, 6 Sep 2010 16:36:41 +0200
Message-ID: <7b674189916f2e7c83cc1f4013a0b1431f863148.1283782701.git.qy03fugy@stud.informatik.uni-erlangen.de>
References: <cover.1283782698.git.qy03fugy@stud.informatik.uni-erlangen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <cover.1283782698.git.qy03fugy@stud.informatik.uni-erlangen.de>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <James.Bottomley@suse.de>, Tejun Heo <tj@kernel.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: vamos-dev@i4.informatik.uni-erlangen.de
List-Id: linux-scsi@vger.kernel.org

The REAL_DMA ifdef isn't necessary at this point, because it is
checked in an outer ifdef level already and has no effect here.

Signed-off-by: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>
---
 drivers/scsi/atari_NCR5380.c |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/atari_NCR5380.c b/drivers/scsi/atari_NCR5380.c
index 158ebc3..7edec2d 100644
--- a/drivers/scsi/atari_NCR5380.c
+++ b/drivers/scsi/atari_NCR5380.c
@@ -1942,9 +1942,7 @@ static int NCR5380_transfer_dma(struct Scsi_Host *instance,
 
 	NCR5380_write(TARGET_COMMAND_REG, PHASE_SR_TO_TCR(p));
 
-#ifdef REAL_DMA
 	NCR5380_write(MODE_REG, MR_BASE | MR_DMA_MODE | MR_ENABLE_EOP_INTR | MR_MONITOR_BSY);
-#endif /* def REAL_DMA  */
 
 	if (IS_A_TT()) {
 		/* On the Medusa, it is a must to initialize the DMA before
@@ -2101,16 +2099,12 @@ static void NCR5380_information_transfer(struct Scsi_Host *instance)
 						cmd->scsi_done(cmd);
 						/* XXX - need to source or sink data here, as appropriate */
 					} else {
-#ifdef REAL_DMA
 						/* ++roman: When using real DMA,
 						 * information_transfer() should return after
 						 * starting DMA since it has nothing more to
 						 * do.
 						 */
 						return;
-#else
-						cmd->SCp.this_residual -= transfersize - len;
-#endif
 					}
 				} else
 #endif /* defined(REAL_DMA) */
-- 
1.7.0.4
