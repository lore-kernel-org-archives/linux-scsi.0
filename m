From: Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V3 01/15] scsi: vmw_pscsi: use sg helper to operate scatterlist
Date: Fri, 14 Jun 2019 10:53:02 +0800
Message-ID: <20190614025316.7360-2-ming.lei@redhat.com>
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

Use the scatterlist iterators and remove direct indexing of the scatterlist
array.

This way allows us to pre-allocate one small scatterlist, which can be chained
with one runtime allocated scatterlist if the pre-allocated one isn't enough
for the whole request.

Reviewed-by: Ewan D. Milne <emilne@redhat.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 drivers/scsi/vmw_pvscsi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/vmw_pvscsi.c b/drivers/scsi/vmw_pvscsi.c
index ecee4b3ff073..d71abd416eb4 100644
--- a/drivers/scsi/vmw_pvscsi.c
+++ b/drivers/scsi/vmw_pvscsi.c
@@ -335,7 +335,7 @@ static void pvscsi_create_sg(struct pvscsi_ctx *ctx,
 	BUG_ON(count > PVSCSI_MAX_NUM_SG_ENTRIES_PER_SEGMENT);
 
 	sge = &ctx->sgl->sge[0];
-	for (i = 0; i < count; i++, sg++) {
+	for (i = 0; i < count; i++, sg = sg_next(sg)) {
 		sge[i].addr   = sg_dma_address(sg);
 		sge[i].length = sg_dma_len(sg);
 		sge[i].flags  = 0;
-- 
2.20.1
