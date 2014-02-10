From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 13/17] scsi: push host_lock down into
 scsi_{host,target}_queue_ready
Date: Mon, 10 Feb 2014 11:53:47 -0800
Message-ID: <1392062027.17867.14.camel@haakon3.risingtidesystems.com>
References: <20140205123930.150608699@bombadil.infradead.org>
	 <20140205124021.286457268@bombadil.infradead.org>
	 <1391705819.22335.8.camel@dabdike> <52F3C21F.70409@acm.org>
	 <1391723900.14985.3.camel@haakon3.risingtidesystems.com>
	 <52F4B622.1070900@acm.org>
	 <1391801455.1155.26.camel@haakon3.risingtidesystems.com>
	 <52F60E61.5040609@acm.org>
	 <1391934408.25121.3.camel@haakon3.risingtidesystems.com>
	 <20140210120906.GA24795@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:54646 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753704AbaBJTu6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 10 Feb 2014 14:50:58 -0500
In-Reply-To: <20140210120906.GA24795@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Bart Van Assche <bvanassche@acm.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org, Douglas Gilbert <dgilbert@interlog.com>

On Mon, 2014-02-10 at 04:09 -0800, Christoph Hellwig wrote:
> On Sun, Feb 09, 2014 at 12:26:48AM -0800, Nicholas A. Bellinger wrote:
> > Again, try NOP'ing all REQ_TYPE_FS type commands immediately in
> > ->queuecommand() in order to determine a baseline without any other LLD
> > overhead involved.
> 
> Seems like this duplicates the fake_rw parameter.  Removing the needless
> host_lock in queuecommand and maybe a few more optimizations would
> certainly be more useful than duplicating the fake_rw parameter.
> 

Fine by me.

--nab

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 80b8b10..631f5d2 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -3603,7 +3603,7 @@ static void sdebug_remove_adapter(void)
 }
 
 static
-int scsi_debug_queuecommand_lck(struct scsi_cmnd *SCpnt, done_funct_t done)
+int __scsi_debug_queuecommand_lck(struct scsi_cmnd *SCpnt, done_funct_t done)
 {
 	unsigned char *cmd = (unsigned char *) SCpnt->cmnd;
 	int len, k;
@@ -3775,8 +3775,6 @@ read:
 		errsts = check_readiness(SCpnt, 0, devip);
 		if (errsts)
 			break;
-		if (scsi_debug_fake_rw)
-			break;
 		get_data_transfer_info(cmd, &lba, &num, &ei_lba);
 		errsts = resp_read(SCpnt, lba, num, devip, ei_lba);
 		if (inj_recovered && (0 == errsts)) {
@@ -3825,8 +3823,6 @@ write:
 		errsts = check_readiness(SCpnt, 0, devip);
 		if (errsts)
 			break;
-		if (scsi_debug_fake_rw)
-			break;
 		get_data_transfer_info(cmd, &lba, &num, &ei_lba);
 		errsts = resp_write(SCpnt, lba, num, devip, ei_lba);
 		if (inj_recovered && (0 == errsts)) {
@@ -3903,8 +3899,6 @@ write:
 		errsts = check_readiness(SCpnt, 0, devip);
 		if (errsts)
 			break;
-		if (scsi_debug_fake_rw)
-			break;
 		get_data_transfer_info(cmd, &lba, &num, &ei_lba);
 		errsts = resp_read(SCpnt, lba, num, devip, ei_lba);
 		if (errsts)
@@ -3952,7 +3946,21 @@ write:
 			     (delay_override ? 0 : scsi_debug_delay));
 }
 
-static DEF_SCSI_QCMD(scsi_debug_queuecommand)
+static DEF_SCSI_QCMD(__scsi_debug_queuecommand)
+
+static int scsi_debug_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *sc)
+{
+	struct request *rq = sc->request;
+
+	if (scsi_debug_fake_rw && rq->cmd_type == REQ_TYPE_FS) {
+		set_host_byte(sc, DID_OK);
+		sc->result |= SAM_STAT_GOOD;
+		sc->scsi_done(sc);
+		return 0;
+	}
+
+	return __scsi_debug_queuecommand(host, sc);
+}
 
 static struct scsi_host_template sdebug_driver_template = {
 	.show_info =		scsi_debug_show_info,
@@ -3973,7 +3981,7 @@ static struct scsi_host_template sdebug_driver_template = {
 	.can_queue =		SCSI_DEBUG_CANQUEUE,
 	.this_id =		7,
 	.sg_tablesize =		256,
-	.cmd_per_lun =		16,
+	.cmd_per_lun =		64,
 	.max_sectors =		0xffff,
 	.use_clustering = 	DISABLE_CLUSTERING,
 	.module =		THIS_MODULE,
-- 
1.7.10.4

