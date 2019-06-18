From: Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V5 06/16] scsi: pmcraid: use sg helper to operate scatterlist
Date: Tue, 18 Jun 2019 09:37:47 +0800
Message-ID: <20190618013757.22401-7-ming.lei@redhat.com>
References: <20190618013757.22401-1-ming.lei@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <20190618013757.22401-1-ming.lei@redhat.com>
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

Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 drivers/scsi/pmcraid.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
index e338d7a4f571..286cac59cb5f 100644
--- a/drivers/scsi/pmcraid.c
+++ b/drivers/scsi/pmcraid.c
@@ -3270,7 +3270,7 @@ static int pmcraid_copy_sglist(
 	int direction
 )
 {
-	struct scatterlist *scatterlist;
+	struct scatterlist *sg;
 	void *kaddr;
 	int bsize_elem;
 	int i;
@@ -3279,10 +3279,10 @@ static int pmcraid_copy_sglist(
 	/* Determine the actual number of bytes per element */
 	bsize_elem = PAGE_SIZE * (1 << sglist->order);
 
-	scatterlist = sglist->scatterlist;
+	sg = sglist->scatterlist;
 
-	for (i = 0; i < (len / bsize_elem); i++, buffer += bsize_elem) {
-		struct page *page = sg_page(&scatterlist[i]);
+	for (i = 0; i < (len / bsize_elem); i++, sg = sg_next(sg), buffer += bsize_elem) {
+		struct page *page = sg_page(sg);
 
 		kaddr = kmap(page);
 		if (direction == DMA_TO_DEVICE)
@@ -3297,11 +3297,11 @@ static int pmcraid_copy_sglist(
 			return -EFAULT;
 		}
 
-		scatterlist[i].length = bsize_elem;
+		sg->length = bsize_elem;
 	}
 
 	if (len % bsize_elem) {
-		struct page *page = sg_page(&scatterlist[i]);
+		struct page *page = sg_page(sg);
 
 		kaddr = kmap(page);
 
@@ -3312,7 +3312,7 @@ static int pmcraid_copy_sglist(
 
 		kunmap(page);
 
-		scatterlist[i].length = len % bsize_elem;
+		sg->length = len % bsize_elem;
 	}
 
 	if (rc) {
-- 
2.20.1
