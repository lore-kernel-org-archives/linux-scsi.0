From: Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V3 10/15] scsi: aha152x: use sg helper to operate scatterlist
Date: Fri, 14 Jun 2019 10:53:11 +0800
Message-ID: <20190614025316.7360-11-ming.lei@redhat.com>
References: <20190614025316.7360-1-ming.lei@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <20190614025316.7360-1-ming.lei@redhat.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Michael Schmitz <schmitzmic@gmail.com>, devel@driverdev.osuosl.org, Hannes Reinecke <hare@suse.com>, Benjamin Block <bblock@linux.ibm.com>, Bart Van Assche <bvanassche@acm.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org, James Smart <james.smart@broadcom.com>, "Ewan D . Milne" <emilne@redhat.com>, Jim Gill <jgill@vmware.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Brian King <brking@us.ibm.com>, Finn Thain <fthain@telegraphics.com.au>, "Juergen E . Fischer" <fischer@norbit.de>, Ming Lei <ming.lei@redhat.com>, Christoph Hellwig <hch@lst.de>, Dan Carpenter <dan.carpenter@oracle.com>
List-Id: linux-scsi@vger.kernel.org

Use the scatterlist iterators and remove direct indexing of the
scatterlist array.

This way allows us to pre-allocate one small scatterlist, which can be
chained with one runtime allocated scatterlist if the pre-allocated one
isn't enough for the whole request.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 drivers/scsi/aha152x.c | 29 +++++++++++++++++++----------
 1 file changed, 19 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/aha152x.c b/drivers/scsi/aha152x.c
index 97872838b983..bc9d12aa7880 100644
--- a/drivers/scsi/aha152x.c
+++ b/drivers/scsi/aha152x.c
@@ -2033,7 +2033,7 @@ static void datai_run(struct Scsi_Host *shpnt)
 				    CURRENT_SC->SCp.buffers_residual > 0) {
 					/* advance to next buffer */
 					CURRENT_SC->SCp.buffers_residual--;
-					CURRENT_SC->SCp.buffer++;
+					CURRENT_SC->SCp.buffer = sg_next(CURRENT_SC->SCp.buffer);
 					CURRENT_SC->SCp.ptr           = SG_ADDRESS(CURRENT_SC->SCp.buffer);
 					CURRENT_SC->SCp.this_residual = CURRENT_SC->SCp.buffer->length;
 				}
@@ -2139,7 +2139,7 @@ static void datao_run(struct Scsi_Host *shpnt)
 		if(CURRENT_SC->SCp.this_residual==0 && CURRENT_SC->SCp.buffers_residual>0) {
 			/* advance to next buffer */
 			CURRENT_SC->SCp.buffers_residual--;
-			CURRENT_SC->SCp.buffer++;
+			CURRENT_SC->SCp.buffer = sg_next(CURRENT_SC->SCp.buffer);
 			CURRENT_SC->SCp.ptr           = SG_ADDRESS(CURRENT_SC->SCp.buffer);
 			CURRENT_SC->SCp.this_residual = CURRENT_SC->SCp.buffer->length;
 		}
@@ -2160,20 +2160,29 @@ static void datao_end(struct Scsi_Host *shpnt)
 	if(TESTLO(DMASTAT, DFIFOEMP)) {
 		int data_count = (DATA_LEN - scsi_get_resid(CURRENT_SC)) -
 			GETSTCNT();
+		struct scatterlist *sg = scsi_sglist(CURRENT_SC);
+		int left, i = 0;
 
 		CMD_INC_RESID(CURRENT_SC, data_count);
 
 		data_count -= CURRENT_SC->SCp.ptr -
 			SG_ADDRESS(CURRENT_SC->SCp.buffer);
-		while(data_count>0) {
-			CURRENT_SC->SCp.buffer--;
-			CURRENT_SC->SCp.buffers_residual++;
-			data_count -= CURRENT_SC->SCp.buffer->length;
+
+		left = CURRENT_SC->transfersize - data_count;
+		for (i = 0; left > 0 && !sg_is_last(sg); i++, sg = sg_next(sg)) {
+			if (left < sg->length)
+				break;
+			left -= sg->length;
+		}
+
+		if (data_count > 0) {
+			CURRENT_SC->SCp.buffers_residual += i;
+			CURRENT_SC->SCp.buffer = sg;
+
+			CURRENT_SC->SCp.ptr = SG_ADDRESS(CURRENT_SC->SCp.buffer) + left;
+			CURRENT_SC->SCp.this_residual = CURRENT_SC->SCp.buffer->length -
+				left;
 		}
-		CURRENT_SC->SCp.ptr = SG_ADDRESS(CURRENT_SC->SCp.buffer) -
-			data_count;
-		CURRENT_SC->SCp.this_residual = CURRENT_SC->SCp.buffer->length +
-			data_count;
 	}
 
 	SETPORT(SXFRCTL0, CH1|CLRCH1|CLRSTCNT);
-- 
2.20.1
