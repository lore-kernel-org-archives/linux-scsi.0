From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: [PATCH 06/28] blk_end_request: changing DAC960 (take 3)
Date: Fri, 30 Nov 2007 18:27:08 -0500 (EST)
Message-ID: <20071130.182708.45746495.k-ueda@ct.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: jens.axboe@oracle.com, bharrosh@panasas.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, dm-devel@redhat.com
List-Id: linux-scsi@vger.kernel.org

This patch converts DAC960 to use blk_end_request().

Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
---
 drivers/block/DAC960.c |    5 +----
 1 files changed, 1 insertion(+), 4 deletions(-)

Index: 2.6.24-rc3-mm2/drivers/block/DAC960.c
===================================================================
--- 2.6.24-rc3-mm2.orig/drivers/block/DAC960.c
+++ 2.6.24-rc3-mm2/drivers/block/DAC960.c
@@ -3464,10 +3464,7 @@ static inline bool DAC960_ProcessComplet
 	pci_unmap_sg(Command->Controller->PCIDevice, Command->cmd_sglist,
 		Command->SegmentCount, Command->DmaDirection);
 
-	 if (!end_that_request_first(Request, UpToDate, Command->BlockCount)) {
-		add_disk_randomness(Request->rq_disk);
- 	 	end_that_request_last(Request, UpToDate);
-
+	 if (!__blk_end_request(Request, UpToDate, Command->BlockCount << 9)) {
 		if (Command->Completion) {
 			complete(Command->Completion);
 			Command->Completion = NULL;
