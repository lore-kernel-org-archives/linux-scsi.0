From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 14/14] fnic: reject device resets without assigned tags for the blk-mq case
Date: Fri, 18 Jul 2014 12:13:13 +0200
Message-ID: <1405678393-11497-15-git-send-email-hch@lst.de>
References: <1405678393-11497-1-git-send-email-hch@lst.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1405678393-11497-1-git-send-email-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, Bart Van Assche <bvanassche@fusionio.com>, Mike Christie <michaelc@cs.wisc.edu>, "Martin K. Petersen" <martin.petersen@oracle.com>, Robert Elliott <Elliott@hp.com>, Webb Scales <webbnh@hp.com>, linux-kernel@vger.kernel.org, Hiral Patel <hiralpat@cisco.com>, Suma Ramars <sramars@cisco.com>, Brian Uchino <buchino@cisco.com>
List-Id: linux-scsi@vger.kernel.org

Current the midlayer fakes up a struct request for the explicit reset
ioctls, and those don't have a tag allocated to them.  The fnic driver pokes
into midlayer structures to paper over this design issue, but that won't
work for the blk-mq case.

Either someone who can actually test the hardware will have to come up with
a similar hack for the blk-mq case, or we'll have to bite the bullet and fix
the way the EH ioctls work for real, but until that happens we fail these
explicit requests here.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Webb Scales <webbnh@hp.com>
Acked-by: Jens Axboe <axboe@kernel.dk>
Tested-by: Bart Van Assche <bvanassche@acm.org>
Tested-by: Robert Elliott <elliott@hp.com>
Cc: Hiral Patel <hiralpat@cisco.com>
Cc: Suma Ramars <sramars@cisco.com>
Cc: Brian Uchino <buchino@cisco.com>
---
 drivers/scsi/fnic/fnic_scsi.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/scsi/fnic/fnic_scsi.c b/drivers/scsi/fnic/fnic_scsi.c
index 3f88f56..961bdf5 100644
--- a/drivers/scsi/fnic/fnic_scsi.c
+++ b/drivers/scsi/fnic/fnic_scsi.c
@@ -2224,6 +2224,22 @@ int fnic_device_reset(struct scsi_cmnd *sc)
 
 	tag = sc->request->tag;
 	if (unlikely(tag < 0)) {
+		/*
+		 * XXX(hch): current the midlayer fakes up a struct
+		 * request for the explicit reset ioctls, and those
+		 * don't have a tag allocated to them.  The below
+		 * code pokes into midlayer structures to paper over
+		 * this design issue, but that won't work for blk-mq.
+		 *
+		 * Either someone who can actually test the hardware
+		 * will have to come up with a similar hack for the
+		 * blk-mq case, or we'll have to bite the bullet and
+		 * fix the way the EH ioctls work for real, but until
+		 * that happens we fail these explicit requests here.
+		 */
+		if (shost_use_blk_mq(sc->device->host))
+			goto fnic_device_reset_end;
+
 		tag = fnic_scsi_host_start_tag(fnic, sc);
 		if (unlikely(tag == SCSI_NO_TAG))
 			goto fnic_device_reset_end;
-- 
1.9.1
