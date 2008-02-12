From: Pete Wyckoff <pw@osc.edu>
Subject: Re: [PATCH 0/3] iscsi bidi & varlen support
Date: Tue, 12 Feb 2008 15:17:53 -0500
Message-ID: <20080212201753.GC12532@osc.edu>
References: <47A20E85.6040906@panasas.com> <20080212201239.GB12532@osc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from marge.padd.com ([66.127.62.138]:58415 "EHLO marge.padd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754074AbYBLUR6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 12 Feb 2008 15:17:58 -0500
Content-Disposition: inline
In-Reply-To: <20080212201239.GB12532@osc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, linux-scsi <linux-scsi@vger.kernel.org>, open-iscsi@googlegroups.com, Benny Halevy <bhalevy@panasas.com>, Daniel.E.Messinger@seagate.com, Erez Zilber <erezz@voltaire.com>, Roland Dreier <rolandd@cisco.com>

pw@osc.edu wrote on Tue, 12 Feb 2008 15:12 -0500:
> bharrosh@panasas.com wrote on Thu, 31 Jan 2008 20:08 +0200:
> > Cheers after 1.3 years these can go in.
> > 
> > [PATCH 1/3] iscsi: extended cdb support
> >    The varlen support is not yet in mainline for
> >   block and scsi-ml. But the API for drivers will
> >   not change. All LLD need to do is max_command to
> >   the it's maximum and be ready for bigger commands.
> >   This is what's done here. Once these commands start
> >   coming iscsi will be ready for them.
> > 
> > [PATCH 2/3] iscsi: bidi support - libiscsi
> > [PATCH 3/3] iscsi: bidi support - iscsi_tcp
> >   bidirectional commands support in iscsi.
> >   iSER is not yet ready, but it will not break.
> >   There is already a mechanism in libiscsi that will
> >   return error if bidi commands are sent iSER way.
> > 
> > Pete please send me the iSER bits so we can port them
> > to this latest version.
> > 
> > Mike these patches are ontop of iscs branch of the iscsi
> > git tree, they will apply but for compilation you will need
> > to sync with Linus mainline. The patches are for the in-tree
> > iscsi code. I own you the compat patch for the out-off-tree
> > code, but this I will only be Sunday.
> 
> Here's the patch to add bidi support to iSER too.  It works
> with my setup, but could use more testing.  Note that this does
> rely on the 3 patches quoted above.

Similar, for varlen support to iSER.  Probably apply this one before
the bidi one I just sent.

		-- Pete


From: Pete Wyckoff <pw@osc.edu>
Subject: [PATCH] iscsi iser: varlen

Handle variable-length CDBs in iSER.

Signed-off-by: Pete Wyckoff <pw@osc.edu>
---
 drivers/infiniband/ulp/iser/iscsi_iser.c     |    5 +++--
 drivers/infiniband/ulp/iser/iscsi_iser.h     |    2 +-
 drivers/infiniband/ulp/iser/iser_initiator.c |   16 ++++++++++------
 3 files changed, 14 insertions(+), 9 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.c b/drivers/infiniband/ulp/iser/iscsi_iser.c
index 5f2284d..9dfc310 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.c
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.c
@@ -401,7 +401,8 @@ iscsi_iser_session_create(struct iscsi_transport *iscsit,
 		ctask      = session->cmds[i];
 		iser_ctask = ctask->dd_data;
 		ctask->hdr = (struct iscsi_cmd *)&iser_ctask->desc.iscsi_header;
-		ctask->hdr_max = sizeof(iser_ctask->desc.iscsi_header);
+		ctask->hdr_max = sizeof(iser_ctask->desc.iscsi_header) +
+				 sizeof(iser_ctask->desc.hdrextbuf);
 	}
 
 	for (i = 0; i < session->mgmtpool_max; i++) {
@@ -604,7 +605,7 @@ static struct iscsi_transport iscsi_iser_transport = {
 	.host_template          = &iscsi_iser_sht,
 	.conndata_size		= sizeof(struct iscsi_conn),
 	.max_lun                = ISCSI_ISER_MAX_LUN,
-	.max_cmd_len            = ISCSI_ISER_MAX_CMD_LEN,
+	.max_cmd_len            = 260,
 	/* session management */
 	.create_session         = iscsi_iser_session_create,
 	.destroy_session        = iscsi_session_teardown,
diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.h b/drivers/infiniband/ulp/iser/iscsi_iser.h
index db8f81a..66905df 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.h
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.h
@@ -90,7 +90,6 @@
 /* FMR space for 1 MB of 4k-page transfers, plus 1 if not page aligned */
 #define ISCSI_ISER_SG_TABLESIZE         (((1<<20) >> SHIFT_4K) + 1)
 #define ISCSI_ISER_MAX_LUN		256
-#define ISCSI_ISER_MAX_CMD_LEN		16
 
 /* QP settings */
 /* Maximal bounds on received asynchronous PDUs */
@@ -217,6 +216,7 @@ enum iser_desc_type {
 struct iser_desc {
 	struct iser_hdr              iser_header;
 	struct iscsi_hdr             iscsi_header;
+	char			     hdrextbuf[ISCSI_MAX_AHS_SIZE];
 	struct iser_regd_buf         hdr_regd_buf;
 	void                         *data;         /* used by RX & TX_CONTROL */
 	struct iser_regd_buf         data_regd_buf; /* used by RX & TX_CONTROL */
diff --git a/drivers/infiniband/ulp/iser/iser_initiator.c b/drivers/infiniband/ulp/iser/iser_initiator.c
index 83247f1..ea3f5dc 100644
--- a/drivers/infiniband/ulp/iser/iser_initiator.c
+++ b/drivers/infiniband/ulp/iser/iser_initiator.c
@@ -246,9 +246,13 @@ post_rx_kmalloc_failure:
 	return err;
 }
 
-/* creates a new tx descriptor and adds header regd buffer */
+/**
+ * iser_create_send_desc - creates a new tx descriptor and adds header regd buffer
+ * @iscsi_hdr_len: length of &struct iscsi_hdr and any AHSes in hdrextbuf
+ */
 static void iser_create_send_desc(struct iscsi_iser_conn *iser_conn,
-				  struct iser_desc       *tx_desc)
+				  struct iser_desc       *tx_desc,
+				  int iscsi_hdr_len)
 {
 	struct iser_regd_buf *regd_hdr = &tx_desc->hdr_regd_buf;
 	struct iser_dto      *send_dto = &tx_desc->dto;
@@ -256,7 +260,7 @@ static void iser_create_send_desc(struct iscsi_iser_conn *iser_conn,
 	memset(regd_hdr, 0, sizeof(struct iser_regd_buf));
 	regd_hdr->device  = iser_conn->ib_conn->device;
 	regd_hdr->virt_addr  = tx_desc; /* == &tx_desc->iser_header */
-	regd_hdr->data_size  = ISER_TOTAL_HEADERS_LEN;
+	regd_hdr->data_size  = sizeof(struct iser_hdr) + iscsi_hdr_len;
 
 	send_dto->ib_conn         = iser_conn->ib_conn;
 	send_dto->notify_enable   = 1;
@@ -342,7 +346,7 @@ int iser_send_command(struct iscsi_conn     *conn,
 	iser_ctask->desc.type = ISCSI_TX_SCSI_COMMAND;
 	send_dto = &iser_ctask->desc.dto;
 	send_dto->ctask = iser_ctask;
-	iser_create_send_desc(iser_conn, &iser_ctask->desc);
+	iser_create_send_desc(iser_conn, &iser_ctask->desc, ctask->hdr_len);
 
 	if (hdr->flags & ISCSI_FLAG_CMD_READ)
 		data_buf = &iser_ctask->data[ISER_DIR_IN];
@@ -435,7 +439,7 @@ int iser_send_data_out(struct iscsi_conn     *conn,
 	/* build the tx desc regd header and add it to the tx desc dto */
 	send_dto = &tx_desc->dto;
 	send_dto->ctask = iser_ctask;
-	iser_create_send_desc(iser_conn, tx_desc);
+	iser_create_send_desc(iser_conn, tx_desc, ctask->hdr_len);
 
 	iser_reg_single(iser_conn->ib_conn->device,
 			send_dto->regd[0], DMA_TO_DEVICE);
@@ -492,7 +496,7 @@ int iser_send_control(struct iscsi_conn *conn,
 	mdesc->type = ISCSI_TX_CONTROL;
 	send_dto = &mdesc->dto;
 	send_dto->ctask = NULL;
-	iser_create_send_desc(iser_conn, mdesc);
+	iser_create_send_desc(iser_conn, mdesc, sizeof(struct iscsi_hdr));
 
 	device = iser_conn->ib_conn->device;
 
-- 
1.5.3.8

