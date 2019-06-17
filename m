From: Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V4 04/16] scsi: mvumi: use sg helper to operate scatterlist
Date: Mon, 17 Jun 2019 11:03:37 +0800
Message-ID: <20190617030349.26415-5-ming.lei@redhat.com>
References: <20190617030349.26415-1-ming.lei@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <20190617030349.26415-1-ming.lei@redhat.com>
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

Reviewed-by: Ewan D. Milne <emilne@redhat.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 drivers/scsi/mvumi.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/mvumi.c b/drivers/scsi/mvumi.c
index a5410615edac..0022cd31500a 100644
--- a/drivers/scsi/mvumi.c
+++ b/drivers/scsi/mvumi.c
@@ -211,8 +211,7 @@ static int mvumi_make_sgl(struct mvumi_hba *mhba, struct scsi_cmnd *scmd,
 	unsigned int sgnum = scsi_sg_count(scmd);
 	dma_addr_t busaddr;
 
-	sg = scsi_sglist(scmd);
-	*sg_count = dma_map_sg(&mhba->pdev->dev, sg, sgnum,
+	*sg_count = dma_map_sg(&mhba->pdev->dev, scsi_sglist(scmd), sgnum,
 			       scmd->sc_data_direction);
 	if (*sg_count > mhba->max_sge) {
 		dev_err(&mhba->pdev->dev,
@@ -222,12 +221,12 @@ static int mvumi_make_sgl(struct mvumi_hba *mhba, struct scsi_cmnd *scmd,
 			     scmd->sc_data_direction);
 		return -1;
 	}
-	for (i = 0; i < *sg_count; i++) {
-		busaddr = sg_dma_address(&sg[i]);
+	scsi_for_each_sg(scmd, sg, *sg_count, i) {
+		busaddr = sg_dma_address(sg);
 		m_sg->baseaddr_l = cpu_to_le32(lower_32_bits(busaddr));
 		m_sg->baseaddr_h = cpu_to_le32(upper_32_bits(busaddr));
 		m_sg->flags = 0;
-		sgd_setsz(mhba, m_sg, cpu_to_le32(sg_dma_len(&sg[i])));
+		sgd_setsz(mhba, m_sg, cpu_to_le32(sg_dma_len(sg)));
 		if ((i + 1) == *sg_count)
 			m_sg->flags |= 1U << mhba->eot_flag;
 
-- 
2.20.1
