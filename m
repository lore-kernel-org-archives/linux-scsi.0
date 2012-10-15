From: Kent Overstreet <koverstreet@google.com>
Subject: [PATCH v4 08/24] block: Remove some unnecessary bi_vcnt
	usage
Date: Mon, 15 Oct 2012 13:08:42 -0700
Message-ID: <1350331769-14856-9-git-send-email-koverstreet@google.com>
References: <1350331769-14856-1-git-send-email-koverstreet@google.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1350331769-14856-1-git-send-email-koverstreet@google.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org, dm-devel@redhat.com
Cc: axboe@kernel.dk, linux-scsi@vger.kernel.org, Kent Overstreet <koverstreet@google.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, tj@kernel.org, Eric Moore <Eric.Moore@lsi.com>, vgoyal@redhat.com
List-Id: linux-scsi@vger.kernel.org

More prep work for immutable bvecs/effecient bio splitting - usage of
bi_vcnt has to be auditing, so getting rid of all the unnecessary usage
makes that easier.

Plus, bio_segments() is really what this code wanted, as it respects the
current value of bi_idx.

Signed-off-by: Kent Overstreet <koverstreet@google.com>
CC: Jens Axboe <axboe@kernel.dk>
CC: Eric Moore <Eric.Moore@lsi.com>
CC: "James E.J. Bottomley" <JBottomley@parallels.com>
CC: linux-scsi@vger.kernel.org
---
 drivers/message/fusion/mptsas.c          |  6 +++---
 drivers/scsi/libsas/sas_expander.c       |  6 +++---
 drivers/scsi/mpt2sas/mpt2sas_transport.c | 10 +++++-----
 3 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/message/fusion/mptsas.c b/drivers/message/fusion/mptsas.c
index 551262e..5406a9f 100644
--- a/drivers/message/fusion/mptsas.c
+++ b/drivers/message/fusion/mptsas.c
@@ -2235,10 +2235,10 @@ static int mptsas_smp_handler(struct Scsi_Host *shost, struct sas_rphy *rphy,
 	}
 
 	/* do we need to support multiple segments? */
-	if (req->bio->bi_vcnt > 1 || rsp->bio->bi_vcnt > 1) {
+	if (bio_segments(req->bio) > 1 || bio_segments(rsp->bio) > 1) {
 		printk(MYIOC_s_ERR_FMT "%s: multiple segments req %u %u, rsp %u %u\n",
-		    ioc->name, __func__, req->bio->bi_vcnt, blk_rq_bytes(req),
-		    rsp->bio->bi_vcnt, blk_rq_bytes(rsp));
+		    ioc->name, __func__, bio_segments(req->bio), blk_rq_bytes(req),
+		    bio_segments(rsp->bio), blk_rq_bytes(rsp));
 		return -EINVAL;
 	}
 
diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
index efc6e72..ee331a7 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -2151,10 +2151,10 @@ int sas_smp_handler(struct Scsi_Host *shost, struct sas_rphy *rphy,
 	}
 
 	/* do we need to support multiple segments? */
-	if (req->bio->bi_vcnt > 1 || rsp->bio->bi_vcnt > 1) {
+	if (bio_segments(req->bio) > 1 || bio_segments(rsp->bio) > 1) {
 		printk("%s: multiple segments req %u %u, rsp %u %u\n",
-		       __func__, req->bio->bi_vcnt, blk_rq_bytes(req),
-		       rsp->bio->bi_vcnt, blk_rq_bytes(rsp));
+		       __func__, bio_segments(req->bio), blk_rq_bytes(req),
+		       bio_segments(rsp->bio), blk_rq_bytes(rsp));
 		return -EINVAL;
 	}
 
diff --git a/drivers/scsi/mpt2sas/mpt2sas_transport.c b/drivers/scsi/mpt2sas/mpt2sas_transport.c
index c6cf20f..403a57b 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_transport.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_transport.c
@@ -1939,7 +1939,7 @@ _transport_smp_handler(struct Scsi_Host *shost, struct sas_rphy *rphy,
 	ioc->transport_cmds.status = MPT2_CMD_PENDING;
 
 	/* Check if the request is split across multiple segments */
-	if (req->bio->bi_vcnt > 1) {
+	if (bio_segments(req->bio) > 1) {
 		u32 offset = 0;
 
 		/* Allocate memory and copy the request */
@@ -1971,7 +1971,7 @@ _transport_smp_handler(struct Scsi_Host *shost, struct sas_rphy *rphy,
 
 	/* Check if the response needs to be populated across
 	 * multiple segments */
-	if (rsp->bio->bi_vcnt > 1) {
+	if (bio_segments(rsp->bio) > 1) {
 		pci_addr_in = pci_alloc_consistent(ioc->pdev, blk_rq_bytes(rsp),
 		    &pci_dma_in);
 		if (!pci_addr_in) {
@@ -2038,7 +2038,7 @@ _transport_smp_handler(struct Scsi_Host *shost, struct sas_rphy *rphy,
 	sgl_flags = (MPI2_SGE_FLAGS_SIMPLE_ELEMENT |
 	    MPI2_SGE_FLAGS_END_OF_BUFFER | MPI2_SGE_FLAGS_HOST_TO_IOC);
 	sgl_flags = sgl_flags << MPI2_SGE_FLAGS_SHIFT;
-	if (req->bio->bi_vcnt > 1) {
+	if (bio_segments(req->bio) > 1) {
 		ioc->base_add_sg_single(psge, sgl_flags |
 		    (blk_rq_bytes(req) - 4), pci_dma_out);
 	} else {
@@ -2054,7 +2054,7 @@ _transport_smp_handler(struct Scsi_Host *shost, struct sas_rphy *rphy,
 	    MPI2_SGE_FLAGS_LAST_ELEMENT | MPI2_SGE_FLAGS_END_OF_BUFFER |
 	    MPI2_SGE_FLAGS_END_OF_LIST);
 	sgl_flags = sgl_flags << MPI2_SGE_FLAGS_SHIFT;
-	if (rsp->bio->bi_vcnt > 1) {
+	if (bio_segments(rsp->bio) > 1) {
 		ioc->base_add_sg_single(psge, sgl_flags |
 		    (blk_rq_bytes(rsp) + 4), pci_dma_in);
 	} else {
@@ -2099,7 +2099,7 @@ _transport_smp_handler(struct Scsi_Host *shost, struct sas_rphy *rphy,
 		    le16_to_cpu(mpi_reply->ResponseDataLength);
 		/* check if the resp needs to be copied from the allocated
 		 * pci mem */
-		if (rsp->bio->bi_vcnt > 1) {
+		if (bio_segments(rsp->bio) > 1) {
 			u32 offset = 0;
 			u32 bytes_to_copy =
 			    le16_to_cpu(mpi_reply->ResponseDataLength);
-- 
1.7.12
