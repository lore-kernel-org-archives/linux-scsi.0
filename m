From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: [PATCH 06/30] blk_end_request: changing DAC960 (take 4)
Date: Tue, 11 Dec 2007 17:43:15 -0500 (EST)
Message-ID: <20071211.174315.57154895.k-ueda@ct.jp.nec.com>
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
To: jens.axboe@oracle.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, dm-devel@redhat.com
List-Id: linux-scsi@vger.kernel.org

This patch converts DAC960 to use blk_end_request interfaces.
Related 'UpToDate' arguments are converted to 'Error'.

Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
---
 drivers/block/DAC960.c |   11 ++---------
 1 files changed, 2 insertions(+), 9 deletions(-)

Index: 2.6.24-rc4/drivers/block/DAC960.c
===================================================================
--- 2.6.24-rc4.orig/drivers/block/DAC960.c
+++ 2.6.24-rc4/drivers/block/DAC960.c
@@ -3455,19 +3455,12 @@ static inline bool DAC960_ProcessComplet
 						 bool SuccessfulIO)
 {
 	struct request *Request = Command->Request;
-	int UpToDate;
-
-	UpToDate = 0;
-	if (SuccessfulIO)
-		UpToDate = 1;
+	int Error = SuccessfulIO ? 0 : -EIO;
 
 	pci_unmap_sg(Command->Controller->PCIDevice, Command->cmd_sglist,
 		Command->SegmentCount, Command->DmaDirection);
 
-	 if (!end_that_request_first(Request, UpToDate, Command->BlockCount)) {
-		add_disk_randomness(Request->rq_disk);
- 	 	end_that_request_last(Request, UpToDate);
-
+	 if (!__blk_end_request(Request, Error, Command->BlockCount << 9)) {
 		if (Command->Completion) {
 			complete(Command->Completion);
 			Command->Completion = NULL;
