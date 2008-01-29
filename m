From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [BUG] 2.6.24-git usb reset problems
Date: Tue, 29 Jan 2008 14:15:15 +0200
Message-ID: <479F18D3.9030709@panasas.com>
References: <20080128204935.GI15220@kernel.dk> <20080128212114.GA15586@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bzq-219-195-70.pop.bezeqint.net ([62.219.195.70]:58800 "EHLO
	bh-buildlin2.bhalevy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752467AbYA2MQ6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Jan 2008 07:16:58 -0500
In-Reply-To: <20080128212114.GA15586@kroah.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Greg KH <greg@kroah.com>, Jens Axboe <jens.axboe@oracle.com>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org

Greg KH wrote:
> On Mon, Jan 28, 2008 at 09:49:35PM +0100, Jens Axboe wrote:
>> Hi,
>>
>> Running latest -git (head 91525300baf162e83e923b09ca286f9205e21522) and
>> connecting my cf usb storage device yields and endless stream of:
>>
>> Initializing USB Mass Storage driver...
>> scsi6 : SCSI emulation for USB Mass Storage devices
>> usb-storage: device found at 2
>> usb-storage: waiting for device to settle before scanning
>> usbcore: registered new interface driver usb-storage
>> USB Mass Storage support registered.
>> scsi 6:0:0:0: Direct-Access     Generic  STORAGE DEVICE   0125 PQ: 0
>> ANSI: 0
>> sd 6:0:0:0: [sdb] 4001760 512-byte hardware sectors (2049 MB)
>> sd 6:0:0:0: [sdb] Write Protect is off
>> sd 6:0:0:0: [sdb] Mode Sense: 02 00 00 00
>> sd 6:0:0:0: [sdb] Assuming drive cache: write through
>> sd 6:0:0:0: [sdb] 4001760 512-byte hardware sectors (2049 MB)
>> sd 6:0:0:0: [sdb] Write Protect is off
>> sd 6:0:0:0: [sdb] Mode Sense: 02 00 00 00
>> sd 6:0:0:0: [sdb] Assuming drive cache: write through
>>  sdb: sdb1
>> sd 6:0:0:0: [sdb] Attached SCSI removable disk
>> sd 6:0:0:0: Attached scsi generic sg1 type 0
>> scsi 6:0:0:1: Direct-Access     Generic  STORAGE DEVICE   0125 PQ: 0
>> ANSI: 0
>> usb 5-1: reset high speed USB device using ehci_hcd and address 2
>> usb 5-1: reset high speed USB device using ehci_hcd and address 2
>> usb 5-1: reset high speed USB device using ehci_hcd and address 2
>> usb 5-1: reset high speed USB device using ehci_hcd and address 2
>> usb 5-1: reset high speed USB device using ehci_hcd and address 2
>> usb 5-1: reset high speed USB device using ehci_hcd and address 2
>> usb 5-1: reset high speed USB device using ehci_hcd and address 2
>> [...]
>>
>> until I disconnect it. The device doesn't work. Worked fine in 2.6.24.
>> I'm attaching boot messages and my .config.
> 
> That's a bit wierd, as we haven't added any USB patches to the -git tree
> yet after 2.6.24 :)
> 
> Could this be caused by some scsi changes perhaps?
> 
> thanks,
> 
> greg k-h
> -
Yes it is ;)

Jens could you test the patch below? if it works I'll submit a proper
patch. Please forgive me for the bug.

Matthew, Greg, Is there a way to extract from messages the usb storage transport
used? I'm guessing it is freecom do to the fact that I find a bug there.

Thanks
Boaz

---
 drivers/usb/storage/freecom.c   |    4 ++--
 drivers/usb/storage/transport.c |   12 +++++++++---
 drivers/usb/storage/transport.h |    3 ++-
 3 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/usb/storage/freecom.c b/drivers/usb/storage/freecom.c
index f5a4e8d..8d77603 100644
--- a/drivers/usb/storage/freecom.c
+++ b/drivers/usb/storage/freecom.c
@@ -132,7 +132,7 @@ freecom_readdata (struct scsi_cmnd *srb, struct us_data *us,
 
 	/* Now transfer all of our blocks. */
 	US_DEBUGP("Start of read\n");
-	result = usb_stor_bulk_srb(us, ipipe, srb);
+	result = usb_stor_bulk_srb_length(us, ipipe, srb, count);
 	US_DEBUGP("freecom_readdata done!\n");
 
 	if (result > USB_STOR_XFER_SHORT)
@@ -165,7 +165,7 @@ freecom_writedata (struct scsi_cmnd *srb, struct us_data *us,
 
 	/* Now transfer all of our blocks. */
 	US_DEBUGP("Start of write\n");
-	result = usb_stor_bulk_srb(us, opipe, srb);
+	result = usb_stor_bulk_srb_length(us, opipe, srb, count);
 
 	US_DEBUGP("freecom_writedata done!\n");
 	if (result > USB_STOR_XFER_SHORT)
diff --git a/drivers/usb/storage/transport.c b/drivers/usb/storage/transport.c
index d9f4912..5072235 100644
--- a/drivers/usb/storage/transport.c
+++ b/drivers/usb/storage/transport.c
@@ -462,18 +462,24 @@ static int usb_stor_bulk_transfer_sglist(struct us_data *us, unsigned int pipe,
  * Common used function. Transfer a complete command
  * via usb_stor_bulk_transfer_sglist() above. Set cmnd resid
  */
-int usb_stor_bulk_srb(struct us_data* us, unsigned int pipe,
-		      struct scsi_cmnd* srb)
+int usb_stor_bulk_srb_length(struct us_data* us, unsigned int pipe,
+		      struct scsi_cmnd* srb, unsigned length)
 {
 	unsigned int partial;
 	int result = usb_stor_bulk_transfer_sglist(us, pipe, scsi_sglist(srb),
-				      scsi_sg_count(srb), scsi_bufflen(srb),
+				      scsi_sg_count(srb), length,
 				      &partial);
 
 	scsi_set_resid(srb, scsi_bufflen(srb) - partial);
 	return result;
 }
 
+int usb_stor_bulk_srb(struct us_data* us, unsigned int pipe,
+		struct scsi_cmnd* srb)
+{
+	return usb_stor_bulk_srb_length(us, pipe, srb, scsi_bufflen(srb));
+}
+
 /*
  * Transfer an entire SCSI command's worth of data payload over the bulk
  * pipe.
diff --git a/drivers/usb/storage/transport.h b/drivers/usb/storage/transport.h
index ada7c2f..03e395d 100644
--- a/drivers/usb/storage/transport.h
+++ b/drivers/usb/storage/transport.h
@@ -139,8 +139,9 @@ extern int usb_stor_bulk_transfer_buf(struct us_data *us, unsigned int pipe,
 		void *buf, unsigned int length, unsigned int *act_len);
 extern int usb_stor_bulk_transfer_sg(struct us_data *us, unsigned int pipe,
 		void *buf, unsigned int length, int use_sg, int *residual);
+extern int usb_stor_bulk_srb_length(struct us_data* us, unsigned int pipe,
+		struct scsi_cmnd* srb, unsigned length);
 extern int usb_stor_bulk_srb(struct us_data* us, unsigned int pipe,
 		struct scsi_cmnd* srb);
-
 extern int usb_stor_port_reset(struct us_data *us);
 #endif

