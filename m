From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 2.6.24-git3] firewire: fw-sbp2: relax SCSI DMA alignment
Date: Sun, 27 Jan 2008 22:31:27 +0100 (CET)
Message-ID: <tkrat.6b01fb9bb536c584@s5r6.in-berlin.de>
References: <479B80A3.5070207@s5r6.in-berlin.de>
	<1201373642.4387.0.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux1394-devel-bounces@lists.sourceforge.net>
In-Reply-To: <1201373642.4387.0.camel@localhost.localdomain>
Content-Disposition: INLINE
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux1394-devel>
List-Post: <mailto:linux1394-devel@lists.sourceforge.net>
List-Help: <mailto:linux1394-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=subscribe>
Sender: linux1394-devel-bounces@lists.sourceforge.net
Errors-To: linux1394-devel-bounces@lists.sourceforge.net
To: linux1394-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---

Not run-time tested yet.

 drivers/firewire/fw-sbp2.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

Index: linux-2.6.24-git3/drivers/firewire/fw-sbp2.c
===================================================================
--- linux-2.6.24-git3.orig/drivers/firewire/fw-sbp2.c
+++ linux-2.6.24-git3/drivers/firewire/fw-sbp2.c
@@ -1309,11 +1309,8 @@ static int sbp2_scsi_slave_alloc(struct 
 
 	sdev->allow_restart = 1;
 
-	/*
-	 * Update the dma alignment (minimum alignment requirements for
-	 * start and end of DMA transfers) to be a sector
-	 */
-	blk_queue_update_dma_alignment(sdev->request_queue, 511);
+	/* SBP-2 requires quadlet alignment of the data buffers. */
+	blk_queue_update_dma_alignment(sdev->request_queue, 4 - 1);
 
 	if (lu->tgt->workarounds & SBP2_WORKAROUND_INQUIRY_36)
 		sdev->inquiry_len = 36;

-- 
Stefan Richter
-=====-==--- ---= ==-==
http://arcgraph.de/sr/


-------------------------------------------------------------------------
This SF.net email is sponsored by: Microsoft
Defy all challenges. Microsoft(R) Visual Studio 2008.
http://clk.atdmt.com/MRT/go/vse0120000070mrt/direct/01/
