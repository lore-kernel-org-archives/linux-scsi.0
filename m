From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [BUG] 2.6.24-git usb reset problems
Date: Tue, 29 Jan 2008 20:45:43 +0100
Message-ID: <20080129194543.GR15220@kernel.dk>
References: <20080128204935.GI15220@kernel.dk> <479F32E9.10609@panasas.com> <20080129141108.GV15220@kernel.dk> <200801291531.39825.oliver@neukum.org> <20080129143109.GW15220@kernel.dk> <20080129183910.GI15220@kernel.dk> <20080129191024.GO14375@one-eyed-alien.net> <1201635195.3069.36.camel@localhost.localdomain> <20080129193520.GQ15220@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([87.55.233.238]:25810 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753313AbYA2Tpt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 Jan 2008 14:45:49 -0500
Content-Disposition: inline
In-Reply-To: <20080129193520.GQ15220@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Matthew Dharm <mdharm-kernel@one-eyed-alien.net>, Oliver Neukum <oliver@neukum.org>, Boaz Harrosh <bharrosh@panasas.com>, Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org

On Tue, Jan 29 2008, Jens Axboe wrote:
> On Tue, Jan 29 2008, James Bottomley wrote:
> > On Tue, 2008-01-29 at 11:10 -0800, Matthew Dharm wrote:
> > > On Tue, Jan 29, 2008 at 07:39:11PM +0100, Jens Axboe wrote:
> > > > On Tue, Jan 29 2008, Jens Axboe wrote:
> > > > > On Tue, Jan 29 2008, Oliver Neukum wrote:
> > > > > > Am Dienstag, 29. Januar 2008 15:11:08 schrieb Jens Axboe:
> > > > > > > On Tue, Jan 29 2008, Boaz Harrosh wrote:
> > > > > > > > On Tue, Jan 29 2008 at 15:54 +0200, Jens Axboe <jens.axboe@oracle.com> wrote:
> > > > > > > > > On Tue, Jan 29 2008, Boaz Harrosh wrote:
> > > > > > > > >> Greg KH wrote:
> > > > > >  
> > > > > > > > > No difference, still just a lot of resets.
> > > > > > > > > 
> > > > > > > > Where you able to figure out which usb storage transport is used?
> > > > > > > > 
> > > > > > > > in drivers/usb/storage/usb.c you have get_protocol() and get_transport()
> > > > > > > > functions. I'm not sure if these get stored in sysfs perhaps. This will
> > > > > > > > pinpoint better where to look. Let me research a bit. 
> > > > > > > 
> > > > > > > Did the quick'n easy and dumped it. Protocol is 'Transparent SCSI' and
> > > > > > > transport is 'Bulk'
> > > > > > 
> > > > > > You can recompile your kernel with CONFIG_USB_DEBUG and CONFIG_STORAGE_DEBUG
> > > > > > That should tell the reason for the resets.
> > > > > 
> > > > > Sure, I'll do that. Will post the results tonight.
> > > > 
> > > > OK, fresh boot with CONFIG_USB_DEBUG and CONFIG_STORAGE_DEBUG. Plugged
> > > > in the device, waited 10 seconds or so and pulled it out. These are the
> > > > messages.
> > > > 
> > > > It all looks good until the MODE_SENSE command, where it only transfers
> > > > 4 of 192 bytes.
> > > 
> > > No, that's not the problem.  This is the problem:
> > >  
> > > > usb-storage: *** thread awakened.
> > > > usb-storage: Command TEST_UNIT_READY (6 bytes)
> > > > usb-storage:  00 00 00 00 00 00
> > > > usb-storage: Bulk Command S 0x43425355 T 0xd L 0 F 0 Trg 0 LUN 1 CL 6
> > > > usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
> > > > usb-storage: Status code 0; transferred 31/31
> > > > usb-storage: -- transfer complete
> > > > usb-storage: Bulk command transfer result=0
> > > > usb-storage: Attempting to get CSW...
> > > > usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
> > > > usb-storage: Status code 0; transferred 13/13
> > > > usb-storage: -- transfer complete
> > > > usb-storage: Bulk status result = 0
> > > > usb-storage: Bulk Status S 0x53425355 T 0xd R 0 Stat 0x1
> > > > usb-storage: -- transport indicates command failure
> > > > usb-storage: Issuing auto-REQUEST_SENSE
> > > > usb-storage: Bulk Command S 0x43425355 T 0xe L 18 F 128 Trg 0 LUN 1 CL 6
> > > > usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
> > > > usb-storage: Status code 0; transferred 31/31
> > > > usb-storage: -- transfer complete
> > > > usb-storage: Bulk command transfer result=0
> > > > usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
> > > > usb-storage: usb_sg_init returned -22
> > > > usb-storage: Bulk data transfer result 0x4
> > > > usb-storage: -- auto-sense failure
> > > > usb-storage: storage_pre_reset
> > > > ehci_hcd 0000:00:1d.7: port 1 high speed
> > > > ehci_hcd 0000:00:1d.7: GetStatus port 1 status 001005 POWER sig=se0 PE CONNECT
> > > > usb 5-1: reset high speed USB device using ehci_hcd and address 2
> > > > ehci_hcd 0000:00:1d.7: port 1 high speed
> > > > ehci_hcd 0000:00:1d.7: GetStatus port 1 status 001005 POWER sig=se0 PE CONNECT
> > > > usb-storage: storage_post_reset
> > > > usb-storage: usb_reset_composite_device returns 0
> > > > usb-storage: scsi cmd done, result=0x70000
> > > > usb-storage: *** thread sleeping.
> > > 
> > > For some reason, usb_sg_init is boned during auto-sense.
> > 
> > OK, that's implicating the scsi_eh_prep_cmnd() in the auto sense
> > code ... that was also an update in 2.6.24
> 
> yeah, already found the bug - it's assuming ->request_buffer holds the
> sglist, oops. Preparing a fix.

ok here goes, this saves and restores the sg table correctly. it also
fixes the usb bug for me.

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 547e85a..12770ef 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -622,13 +622,15 @@ void scsi_eh_prep_cmnd(struct scsi_cmnd *scmd, struct scsi_eh_save *ses,
 	ses->use_sg = scmd->use_sg;
 	ses->resid = scmd->resid;
 	ses->result = scmd->result;
+	memcpy(&ses->sense_sgl, &scmd->sg_table, sizeof(ses->sense_sgl));
 
 	if (sense_bytes) {
 		scmd->request_bufflen = min_t(unsigned,
 		                       SCSI_SENSE_BUFFERSIZE, sense_bytes);
 		sg_init_one(&ses->sense_sgl, scmd->sense_buffer,
 		                                       scmd->request_bufflen);
-		scmd->request_buffer = &ses->sense_sgl;
+		scmd->sg_table.sgl = &ses->sense_sgl;
+		scmd->sg_table.nents = scmd->sg_table.orig_nents = 1;
 		scmd->sc_data_direction = DMA_FROM_DEVICE;
 		scmd->use_sg = 1;
 		memset(scmd->cmnd, 0, sizeof(scmd->cmnd));
@@ -679,6 +681,7 @@ void scsi_eh_restore_cmnd(struct scsi_cmnd* scmd, struct scsi_eh_save *ses)
 	scmd->request_bufflen = ses->bufflen;
 	scmd->request_buffer = ses->buffer;
 	scmd->use_sg = ses->use_sg;
+	memcpy(&scmd->sg_table, &ses->sg_table, sizeof(scmd->sg_table));
 	scmd->resid = ses->resid;
 	scmd->result = ses->result;
 }
diff --git a/include/scsi/scsi_eh.h b/include/scsi/scsi_eh.h
index d21b891..d43dc83 100644
--- a/include/scsi/scsi_eh.h
+++ b/include/scsi/scsi_eh.h
@@ -75,6 +75,7 @@ struct scsi_eh_save {
 
 	void *buffer;
 	unsigned bufflen;
+	struct sg_table sg_table;
 	unsigned short use_sg;
 	int resid;
 

-- 
Jens Axboe

