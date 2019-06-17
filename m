From: Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V4 07/16] usb: image: microtek: use sg helper to operate
 scatterlist
Date: Mon, 17 Jun 2019 11:03:40 +0800
Message-ID: <20190617030349.26415-8-ming.lei@redhat.com>
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
Cc: Michael Schmitz <schmitzmic@gmail.com>, devel@driverdev.osuosl.org, Hannes Reinecke <hare@suse.com>, Benjamin Block <bblock@linux.ibm.com>, Bart Van Assche <bvanassche@acm.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org, James Smart <james.smart@broadcom.com>, "Ewan D . Milne" <emilne@redhat.com>, Jim Gill <jgill@vmware.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Oliver Neukum <oliver@neukum.org>, Brian King <brking@us.ibm.com>, Finn Thain <fthain@telegraphics.com.au>, "Juergen E . Fischer" <fischer@norbit.de>, Ming Lei <ming.lei@redhat.com>, Christoph Hellwig <hch@lst.de>, Dan Carpenter <dan.carpenter@oracle.com>
List-Id: linux-scsi@vger.kernel.org

Use the scatterlist iterators and remove direct indexing of the
scatterlist array.

This way allows us to pre-allocate one small scatterlist, which can be
chained with one runtime allocated scatterlist if the pre-allocated one
isn't enough for the whole request.

Cc: Oliver Neukum <oliver@neukum.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 drivers/usb/image/microtek.c | 20 ++++++++------------
 drivers/usb/image/microtek.h |  2 +-
 2 files changed, 9 insertions(+), 13 deletions(-)

diff --git a/drivers/usb/image/microtek.c b/drivers/usb/image/microtek.c
index 607be1f4fe27..0a57c2cc8e5a 100644
--- a/drivers/usb/image/microtek.c
+++ b/drivers/usb/image/microtek.c
@@ -488,7 +488,6 @@ static void mts_command_done( struct urb *transfer )
 
 static void mts_do_sg (struct urb* transfer)
 {
-	struct scatterlist * sg;
 	int status = transfer->status;
 	MTS_INT_INIT();
 
@@ -500,13 +499,12 @@ static void mts_do_sg (struct urb* transfer)
 		mts_transfer_cleanup(transfer);
         }
 
-	sg = scsi_sglist(context->srb);
-	context->fragment++;
+	context->curr_sg = sg_next(context->curr_sg);
 	mts_int_submit_urb(transfer,
 			   context->data_pipe,
-			   sg_virt(&sg[context->fragment]),
-			   sg[context->fragment].length,
-			   context->fragment + 1 == scsi_sg_count(context->srb) ?
+			   sg_virt(context->curr_sg),
+			   context->curr_sg->length,
+			   sg_is_last(context->curr_sg) ?
 			   mts_data_done : mts_do_sg);
 }
 
@@ -526,22 +524,20 @@ static void
 mts_build_transfer_context(struct scsi_cmnd *srb, struct mts_desc* desc)
 {
 	int pipe;
-	struct scatterlist * sg;
-	
+
 	MTS_DEBUG_GOT_HERE();
 
 	desc->context.instance = desc;
 	desc->context.srb = srb;
-	desc->context.fragment = 0;
 
 	if (!scsi_bufflen(srb)) {
 		desc->context.data = NULL;
 		desc->context.data_length = 0;
 		return;
 	} else {
-		sg = scsi_sglist(srb);
-		desc->context.data = sg_virt(&sg[0]);
-		desc->context.data_length = sg[0].length;
+		desc->context.curr_sg = scsi_sglist(srb);
+		desc->context.data = sg_virt(desc->context.curr_sg);
+		desc->context.data_length = desc->context.curr_sg->length;
 	}
 
 
diff --git a/drivers/usb/image/microtek.h b/drivers/usb/image/microtek.h
index 66685e59241a..7bd5f4639c4a 100644
--- a/drivers/usb/image/microtek.h
+++ b/drivers/usb/image/microtek.h
@@ -21,7 +21,7 @@ struct mts_transfer_context
 	void *data;
 	unsigned data_length;
 	int data_pipe;
-	int fragment;
+	struct scatterlist *curr_sg;
 
 	u8 *scsi_status; /* status returned from ep_response after command completion */
 };
-- 
2.20.1
