From: "Chauhan, Vijay" <Vijay.Chauhan@lsi.com>
Subject: [PATCH] scsi_dh_rdac: Retry for NOT_READY(02/04/01) in rdac device
 handler
Date: Mon, 20 Apr 2009 18:14:23 +0530
Message-ID: <0D1E8821739E724A86F4D16902CE275C1410F4D4B1@inbmail01.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from chip3og59.obsmtp.com ([64.18.14.183]:49426 "EHLO
	chip3og59.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754613AbZDTMok convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Apr 2009 08:44:40 -0400
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "'sekharan@us.ibm.com'" <sekharan@us.ibm.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Hannes Reinecke <hare@suse.de>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "'dm-devel@redhat.com'" <dm-devel@redhat.com>

This patch resolves the following issue. Please give your comment.

> I am having issue with scsi_io_completion routine. During 
> device discovery, READ CAPACITY is failing with 02/04/01. It 
> has been retried 5 times(with NEED_RETRY) but when retry gets 
> exhausted ,scsi_io_completion simply ends the request without 
> trying with delay retry.  
> 
> Here scsi_io_completion routine checks for deferred sense and if 
> not found, it sets error with -EIO, which eventually ends the 
> request and doesnot allow for any more retries. I am seeing 
> deffered error being checked only for REQ_TYPE_BLOCK_PC 
> command type. Does it meant that command with cmd_type 
> REQ_TYPE_BLOCK_PC having current error sense should not be 
> retried in scsi_io_completion? If yes, then would it be 
> better to retry in rdac device handler in that case. 
> 
> 
> On Tues, 2009-03-10 at 15:47, James Bottomley wrote:
> > > +		if (sense_hdr->asc == 0x04 && sense_hdr->ascq == 0x01)
> > > +			/* LUN Not Ready - Logical Unit Not 
> > Ready and is in
> > > +			 * the process of becoming ready
> > > +			 * Just retry.
> > > +			 */
> > > +			return ADD_TO_MLQUEUE;
> > > +		if (sense_hdr->asc == 0x04 && sense_hdr->ascq == 0x04)
> > > +			/* LUN Not Ready - Format In Progress
> > > +			 *
> > > +			 * Just retry.
> > > +			 */
> > > +			return ADD_TO_MLQUEUE;
> > > +		if (sense_hdr->asc == 0x04  && sense_hdr->ascq == 0x07)
> > > +			/* LUN Not Ready - Storage controller 
> > cannot respond
> > > +			 * immediately to a PRIN or PROUT command.
> > > +			 * Just retry.
> > > +			 */
> > > +			return ADD_TO_MLQUEUE;
> > 
> > For all of these ... along with a few other not ready types, 
> > we already
> > do a delayed retry at the mid-layer (in 
> scsi_io_completion).  Is there
> > some problem that causes this to need to be handled here as well?

Thanks,
Vijay

---
During device discovery read capacity fails with 0x020401 and sets the device size to 0. As a reason any I/O submitted to this path gets killed at sd_prep_fn with BLKPREP_KILL. This patch is to retry for 0x020401. NEED_RETRY in scsi_decide_disposition does not give sufficient time for the device to become ready. 

Signed-off-by: Vijay Chauhan <vijay.chauhan@lsi.com>
---
--- linux-2.6.30-rc2/drivers/scsi/device_handler/scsi_dh_rdac.c.orig	2009-04-20 23:07:14.000000000 +0530
+++ linux-2.6.30-rc2/drivers/scsi/device_handler/scsi_dh_rdac.c	2009-04-20 23:11:27.000000000 +0530
@@ -561,6 +561,12 @@ static int rdac_check_sense(struct scsi_
 	struct rdac_dh_data *h = get_rdac_data(sdev);
 	switch (sense_hdr->sense_key) {
 	case NOT_READY:
+		if (sense_hdr->asc == 0x04 && sense_hdr->ascq == 0x01)
+			/* LUN Not Ready - Logical Unit Not Ready and is in
+			* the process of becoming ready
+			* Just retry.
+			*/
+			return ADD_TO_MLQUEUE;
 		if (sense_hdr->asc == 0x04 && sense_hdr->ascq == 0x81)
 			/* LUN Not Ready - Storage firmware incompatible
 			 * Manual code synchonisation required.
