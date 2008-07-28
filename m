From: =?ISO-8859-1?Q?C=E9dric_Godin?= <cedric@belbone.be>
Subject: Re: [SCSI] can't plug Nokia 5300 anymore (bisected)
Date: Mon, 28 Jul 2008 10:29:49 +0200
Message-ID: <488D837D.1070001@belbone.be>
References: <Pine.LNX.4.44L0.0807261826390.28592-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------030001020705060501040203"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailrelay006.isp.belgacom.be ([195.238.6.172]:23343 "EHLO
	mailrelay006.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752050AbYG1I3z (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 Jul 2008 04:29:55 -0400
In-Reply-To: <Pine.LNX.4.44L0.0807261826390.28592-100000@netrider.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Linux Kernel <linux-kernel@vger.kernel.org>, SCSI Kernel <linux-scsi@vger.kernel.org>

This is a multi-part message in MIME format.
--------------030001020705060501040203
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit

Alan Stern wrote:
> On Sat, 26 Jul 2008, Cédric Godin wrote:
>
>   
>> Alan Stern wrote:
>>     
>>> On Fri, 25 Jul 2008, Cédric Godin wrote:
>>>
>>>   
>>>       
>>>> resending because wrong address of lkml and cc scsi list
>>>>
>>>> Hello,
>>>>
>>>> since 2 or 3 -git kernels (Linus tree)  I have a problem with my laptop 
>>>> and its connection through USB to a nokia 5300 gsm.
>>>>
>>>> The logs show me a endless loop (until i unplug my USB cable) of 
>>>> following messages :
>>>>
>>>> Jul 25 15:19:14 enea sd 2:0:0:0: [sdb] ASC=0x0 ASCQ=0x0
>>>> Jul 25 15:19:14 enea sd 2:0:0:0: [sdb] Sense Key : 0x0 [current]
>>>> Jul 25 15:19:14 enea sd 2:0:0:0: [sdb] ASC=0x0 ASCQ=0x0
>>>> Jul 25 15:19:14 enea sd 2:0:0:0: [sdb] Sense Key : 0x0 [current]
>>>> Jul 25 15:19:14 enea sd 2:0:0:0: [sdb] ASC=0x0 ASCQ=0x0
>>>> Jul 25 15:19:14 enea sd 2:0:0:0: [sdb] Sense Key : 0x0 [current]
>>>> Jul 25 15:19:14 enea sd 2:0:0:0: [sdb] ASC=0x0 ASCQ=0x0
>>>> Jul 25 15:19:14 enea sd 2:0:0:0: [sdb] Sense Key : 0x0 [current]
>>>> Jul 25 15:19:14 enea sd 2:0:0:0: [sdb] ASC=0x0 ASCQ=0x0
>>>> Jul 25 15:19:14 enea sd 2:0:0:0: [sdb] Sense Key : 0x0 [current]
>>>>
>>>> I bisected the kernel and found the following commit as result :
>>>>
>>>> 427e59f09fdba387547106de7bab980b7fff77be is first bad commit
>>>> commit 427e59f09fdba387547106de7bab980b7fff77be
>>>> Author: James Bottomley <James.Bottomley@HansenPartnership.com>
>>>> Date:   Sat Mar 8 18:24:17 2008 -0600
>>>>
>>>>    [SCSI] make use of the residue value
>>>>
>>>>    USB sometimes doesn't return an error but instead returns a residue
>>>>    value indicating part (or all) of the command wasn't completed.  So if
>>>>    the driver _done() error processing indicates the command was fully
>>>>    processed, subtract off the residue so that this USB error gets
>>>>    propagated.
>>>>
>>>>    Cc: Alan Stern <stern@rowland.harvard.edu>
>>>>    Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
>>>>
>>>> :040000 040000 d3bad84ebe1bc231e8e7d6267907ca62fd4d0dcd 
>>>> c85f8cb8bd4910724f0101e41054555980727e16 M      drivers
>>>>
>>>>
>>>> When reverting it with 2.6.26-06077-gc010b2f , everything is back to normal.
>>>>     
>>>>         
>>> Can you post the corresponding dmesg log from a system built with 
>>> CONFIG_USB_STORAGE_DEBUG enabled?
>>>
>>> Alan Stern
>>>
>>>   
>>>       
>> Sure,
>> i attached it
>>     
>
> This log doesn't contain an endless loop of error messages.  In fact I 
>   
That's me sending the wrong dmesg, sorry :-$

Attached is the "good" one.

> see only one error, and the commit you found wouldn't have affected 
> that error.  More accurately, if the commit magnified the error into an 
> endless loop, then without the commit the error would still have been 
> present and would have caused data corruption.
>
> Anyway, it would be interesting to see what happens with the commit in 
> place and the following patch applied.  (The first part of the patch 
> has already been accepted by James.)
>   
Same problem.

> Alan Stern
>
>
>
>
> Index: usb-2.6/drivers/scsi/scsi_error.c
> ===================================================================
> --- usb-2.6.orig/drivers/scsi/scsi_error.c
> +++ usb-2.6/drivers/scsi/scsi_error.c
> @@ -653,6 +653,7 @@ void scsi_eh_prep_cmnd(struct scsi_cmnd 
>  	ses->sdb = scmd->sdb;
>  	ses->next_rq = scmd->request->next_rq;
>  	ses->result = scmd->result;
> +	ses->underflow = scmd->underflow;
>  
>  	scmd->cmnd = ses->eh_cmnd;
>  	memset(scmd->cmnd, 0, BLK_MAX_CDB);
> @@ -711,6 +712,7 @@ void scsi_eh_restore_cmnd(struct scsi_cm
>  	scmd->sdb = ses->sdb;
>  	scmd->request->next_rq = ses->next_rq;
>  	scmd->result = ses->result;
> +	scmd->underflow = ses->underflow;
>  }
>  EXPORT_SYMBOL(scsi_eh_restore_cmnd);
>  
> Index: usb-2.6/include/scsi/scsi_eh.h
> ===================================================================
> --- usb-2.6.orig/include/scsi/scsi_eh.h
> +++ usb-2.6/include/scsi/scsi_eh.h
> @@ -73,6 +73,7 @@ extern int scsi_reset_provider(struct sc
>  struct scsi_eh_save {
>  	/* saved state */
>  	int result;
> +	unsigned underflow;
>  	enum dma_data_direction data_direction;
>  	unsigned char cmd_len;
>  	unsigned char *cmnd;
> Index: usb-2.6/drivers/usb/storage/transport.c
> ===================================================================
> --- usb-2.6.orig/drivers/usb/storage/transport.c
> +++ usb-2.6/drivers/usb/storage/transport.c
> @@ -663,7 +663,7 @@ void usb_stor_invoke_transport(struct sc
>  	}
>  
>  	/* Did we transfer less than the minimum amount required? */
> -	if (srb->result == SAM_STAT_GOOD &&
> +	if ((srb->result == SAM_STAT_GOOD || srb->sense_buffer[2] == 0) &&
>  			scsi_bufflen(srb) - scsi_get_resid(srb) < srb->underflow)
>  		srb->result = (DID_ERROR << 16) | (SUGGEST_RETRY << 24);
>  
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>   


--------------030001020705060501040203
Content-Type: text/plain;
 name="messages-nok"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="messages-nok"

Jul 28 10:00:12 enea NetworkManager: <debug> [1217232012.595448] nm_hal_device_added(): New device added (hal udi is '/org/freedesktop/Hal/devices/usb_device_421_4b9_359815013364896').
Jul 28 10:00:12 enea Initializing USB Mass Storage driver...
Jul 28 10:00:12 enea usb-storage: USB Mass Storage device detected
Jul 28 10:00:12 enea usb-storage: -- associate_dev
Jul 28 10:00:12 enea usb-storage: Vendor: 0x0421, Product: 0x04b9, Revision: 0x0551
Jul 28 10:00:12 enea usb-storage: Interface Subclass: 0x06, Protocol: 0x50
Jul 28 10:00:12 enea usb-storage: Transport: Bulk
Jul 28 10:00:12 enea usb-storage: Protocol: Transparent SCSI
Jul 28 10:00:12 enea scsi2 : SCSI emulation for USB Mass Storage devices
Jul 28 10:00:12 enea usb-storage: *** thread sleeping.
Jul 28 10:00:12 enea usbcore: registered new interface driver usb-storage
Jul 28 10:00:12 enea USB Mass Storage support registered.
Jul 28 10:00:12 enea usb-storage: device found at 3
Jul 28 10:00:12 enea usb-storage: waiting for device to settle before scanning
Jul 28 10:00:12 enea NetworkManager: <debug> [1217232012.742113] nm_hal_device_added(): New device added (hal udi is '/org/freedesktop/Hal/devices/usb_device_421_4b9_359815013364896_if0').
Jul 28 10:00:12 enea NetworkManager: <debug> [1217232012.763578] nm_hal_device_added(): New device added (hal udi is '/org/freedesktop/Hal/devices/usb_device_421_4b9_359815013364896_usbraw').
Jul 28 10:00:17 enea usb-storage: usb_stor_control_msg: rq=fe rqtype=a1 value=0000 index=00 len=1
Jul 28 10:00:17 enea usb-storage: GetMaxLUN command result is 1, data is 0
Jul 28 10:00:17 enea usb-storage: queuecommand called
Jul 28 10:00:17 enea usb-storage: *** thread awakened.
Jul 28 10:00:17 enea usb-storage: Command INQUIRY (6 bytes)
Jul 28 10:00:17 enea usb-storage:  12 00 00 00 24 00
Jul 28 10:00:17 enea usb-storage: Bulk Command S 0x43425355 T 0x1 L 36 F 128 Trg 0 LUN 0 CL 6
Jul 28 10:00:17 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 28 10:00:17 enea usb-storage: Status code 0; transferred 31/31
Jul 28 10:00:17 enea usb-storage: -- transfer complete
Jul 28 10:00:17 enea usb-storage: Bulk command transfer result=0
Jul 28 10:00:17 enea usb-storage: usb_stor_bulk_transfer_sglist: xfer 36 bytes, 1 entries
Jul 28 10:00:17 enea usb-storage: Status code 0; transferred 36/36
Jul 28 10:00:17 enea usb-storage: -- transfer complete
Jul 28 10:00:17 enea usb-storage: Bulk data transfer result 0x0
Jul 28 10:00:17 enea usb-storage: Attempting to get CSW...
Jul 28 10:00:17 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 28 10:00:17 enea usb-storage: Status code 0; transferred 13/13
Jul 28 10:00:17 enea usb-storage: -- transfer complete
Jul 28 10:00:17 enea usb-storage: Bulk status result = 0
Jul 28 10:00:17 enea usb-storage: Bulk Status S 0x53425355 T 0x1 R 0 Stat 0x0
Jul 28 10:00:17 enea usb-storage: scsi cmd done, result=0x0
Jul 28 10:00:17 enea scsi 2:0:0:0: Direct-Access     Nokia    Nokia 5300       0000 PQ: 0 ANSI: 4
Jul 28 10:00:17 enea usb-storage: *** thread sleeping.
Jul 28 10:00:17 enea usb-storage: queuecommand called
Jul 28 10:00:17 enea usb-storage: *** thread awakened.
Jul 28 10:00:17 enea usb-storage: Command TEST_UNIT_READY (6 bytes)
Jul 28 10:00:17 enea usb-storage:  00 00 00 00 00 00
Jul 28 10:00:17 enea usb-storage: Bulk Command S 0x43425355 T 0x2 L 0 F 0 Trg 0 LUN 0 CL 6
Jul 28 10:00:17 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 28 10:00:17 enea usb-storage: Status code 0; transferred 31/31
Jul 28 10:00:17 enea usb-storage: -- transfer complete
Jul 28 10:00:17 enea usb-storage: Bulk command transfer result=0
Jul 28 10:00:17 enea usb-storage: Attempting to get CSW...
Jul 28 10:00:17 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 28 10:00:17 enea NetworkManager: <debug> [1217232017.771578] nm_hal_device_added(): New device added (hal udi is '/org/freedesktop/Hal/devices/usb_device_421_4b9_359815013364896_if0_scsi_host').
Jul 28 10:00:17 enea NetworkManager: <debug> [1217232017.774478] nm_hal_device_added(): New device added (hal udi is '/org/freedesktop/Hal/devices/usb_device_421_4b9_359815013364896_if0_scsi_host_scsi_device_lun0').
Jul 28 10:00:17 enea usb-storage: Status code 0; transferred 13/13
Jul 28 10:00:17 enea usb-storage: -- transfer complete
Jul 28 10:00:17 enea usb-storage: Bulk status result = 0
Jul 28 10:00:17 enea usb-storage: Bulk Status S 0x53425355 T 0x2 R 0 Stat 0x0
Jul 28 10:00:17 enea usb-storage: scsi cmd done, result=0x0
Jul 28 10:00:17 enea usb-storage: queuecommand called
Jul 28 10:00:17 enea usb-storage: *** thread sleeping.
Jul 28 10:00:17 enea usb-storage: *** thread awakened.
Jul 28 10:00:17 enea usb-storage: Command READ_CAPACITY (10 bytes)
Jul 28 10:00:17 enea usb-storage:  25 00 00 00 00 00 00 00 00 00
Jul 28 10:00:17 enea usb-storage: Bulk Command S 0x43425355 T 0x3 L 8 F 128 Trg 0 LUN 0 CL 10
Jul 28 10:00:17 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 28 10:00:17 enea usb-storage: Status code 0; transferred 31/31
Jul 28 10:00:17 enea usb-storage: -- transfer complete
Jul 28 10:00:17 enea usb-storage: Bulk command transfer result=0
Jul 28 10:00:17 enea usb-storage: usb_stor_bulk_transfer_sglist: xfer 8 bytes, 1 entries
Jul 28 10:00:17 enea usb-storage: Status code 0; transferred 8/8
Jul 28 10:00:17 enea usb-storage: -- transfer complete
Jul 28 10:00:17 enea usb-storage: Bulk data transfer result 0x0
Jul 28 10:00:17 enea usb-storage: Attempting to get CSW...
Jul 28 10:00:17 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 28 10:00:17 enea usb-storage: Status code 0; transferred 13/13
Jul 28 10:00:17 enea usb-storage: -- transfer complete
Jul 28 10:00:17 enea usb-storage: Bulk status result = 0
Jul 28 10:00:17 enea usb-storage: Bulk Status S 0x53425355 T 0x3 R 0 Stat 0x0
Jul 28 10:00:17 enea usb-storage: scsi cmd done, result=0x0
Jul 28 10:00:17 enea usb-storage: *** thread sleeping.
Jul 28 10:00:17 enea sd 2:0:0:0: [sdb] 3970049 512-byte hardware sectors (2033 MB)
Jul 28 10:00:17 enea usb-storage: queuecommand called
Jul 28 10:00:17 enea usb-storage: *** thread awakened.
Jul 28 10:00:17 enea usb-storage: Command MODE_SENSE (6 bytes)
Jul 28 10:00:17 enea usb-storage:  1a 00 3f 00 c0 00
Jul 28 10:00:17 enea usb-storage: Bulk Command S 0x43425355 T 0x4 L 192 F 128 Trg 0 LUN 0 CL 6
Jul 28 10:00:17 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 28 10:00:17 enea usb-storage: Status code 0; transferred 31/31
Jul 28 10:00:17 enea usb-storage: -- transfer complete
Jul 28 10:00:17 enea usb-storage: Bulk command transfer result=0
Jul 28 10:00:17 enea usb-storage: usb_stor_bulk_transfer_sglist: xfer 192 bytes, 1 entries
Jul 28 10:00:17 enea usb-storage: Status code -121; transferred 4/192
Jul 28 10:00:17 enea usb-storage: -- short read transfer
Jul 28 10:00:17 enea usb-storage: Bulk data transfer result 0x1
Jul 28 10:00:17 enea usb-storage: Attempting to get CSW...
Jul 28 10:00:17 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 28 10:00:17 enea usb-storage: Status code 0; transferred 13/13
Jul 28 10:00:17 enea usb-storage: -- transfer complete
Jul 28 10:00:17 enea usb-storage: Bulk status result = 0
Jul 28 10:00:17 enea usb-storage: Bulk Status S 0x53425355 T 0x4 R 188 Stat 0x0
Jul 28 10:00:17 enea usb-storage: scsi cmd done, result=0x0
Jul 28 10:00:17 enea usb-storage: *** thread sleeping.
Jul 28 10:00:17 enea sd 2:0:0:0: [sdb] Write Protect is off
Jul 28 10:00:17 enea sd 2:0:0:0: [sdb] Mode Sense: 03 00 00 00
Jul 28 10:00:17 enea sd 2:0:0:0: [sdb] Assuming drive cache: write through
Jul 28 10:00:17 enea usb-storage: queuecommand called
Jul 28 10:00:17 enea usb-storage: *** thread awakened.
Jul 28 10:00:17 enea usb-storage: Command TEST_UNIT_READY (6 bytes)
Jul 28 10:00:17 enea usb-storage:  00 00 00 00 00 00
Jul 28 10:00:17 enea usb-storage: Bulk Command S 0x43425355 T 0x5 L 0 F 0 Trg 0 LUN 0 CL 6
Jul 28 10:00:17 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 28 10:00:17 enea usb-storage: Status code 0; transferred 31/31
Jul 28 10:00:17 enea usb-storage: -- transfer complete
Jul 28 10:00:17 enea usb-storage: Bulk command transfer result=0
Jul 28 10:00:17 enea usb-storage: Attempting to get CSW...
Jul 28 10:00:17 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 28 10:00:17 enea usb-storage: Status code 0; transferred 13/13
Jul 28 10:00:17 enea usb-storage: -- transfer complete
Jul 28 10:00:17 enea usb-storage: Bulk status result = 0
Jul 28 10:00:17 enea usb-storage: Bulk Status S 0x53425355 T 0x5 R 0 Stat 0x0
Jul 28 10:00:17 enea usb-storage: scsi cmd done, result=0x0
Jul 28 10:00:17 enea usb-storage: queuecommand called
Jul 28 10:00:17 enea usb-storage: *** thread sleeping.
Jul 28 10:00:17 enea usb-storage: *** thread awakened.
Jul 28 10:00:17 enea usb-storage: Command ALLOW_MEDIUM_REMOVAL (6 bytes)
Jul 28 10:00:17 enea usb-storage:  1e 00 00 00 01 00
Jul 28 10:00:17 enea usb-storage: Bulk Command S 0x43425355 T 0x6 L 0 F 0 Trg 0 LUN 0 CL 6
Jul 28 10:00:17 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 28 10:00:17 enea usb-storage: Status code 0; transferred 31/31
Jul 28 10:00:17 enea usb-storage: -- transfer complete
Jul 28 10:00:17 enea usb-storage: Bulk command transfer result=0
Jul 28 10:00:17 enea usb-storage: Attempting to get CSW...
Jul 28 10:00:17 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 28 10:00:17 enea usb-storage: Status code 0; transferred 13/13
Jul 28 10:00:17 enea usb-storage: -- transfer complete
Jul 28 10:00:17 enea usb-storage: Bulk status result = 0
Jul 28 10:00:17 enea usb-storage: Bulk Status S 0x53425355 T 0x6 R 0 Stat 0x1
Jul 28 10:00:17 enea usb-storage: -- transport indicates command failure
Jul 28 10:00:17 enea usb-storage: Issuing auto-REQUEST_SENSE
Jul 28 10:00:17 enea usb-storage: Bulk Command S 0x43425355 T 0x7 L 18 F 128 Trg 0 LUN 0 CL 6
Jul 28 10:00:17 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 28 10:00:17 enea usb-storage: Status code 0; transferred 31/31
Jul 28 10:00:17 enea usb-storage: -- transfer complete
Jul 28 10:00:17 enea usb-storage: Bulk command transfer result=0
Jul 28 10:00:17 enea usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
Jul 28 10:00:17 enea usb-storage: Status code 0; transferred 18/18
Jul 28 10:00:17 enea usb-storage: -- transfer complete
Jul 28 10:00:17 enea usb-storage: Bulk data transfer result 0x0
Jul 28 10:00:17 enea usb-storage: Attempting to get CSW...
Jul 28 10:00:17 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 28 10:00:17 enea usb-storage: Status code 0; transferred 13/13
Jul 28 10:00:17 enea usb-storage: -- transfer complete
Jul 28 10:00:17 enea usb-storage: Bulk status result = 0
Jul 28 10:00:17 enea usb-storage: Bulk Status S 0x53425355 T 0x7 R 0 Stat 0x0
Jul 28 10:00:17 enea usb-storage: -- Result from auto-sense is 0
Jul 28 10:00:17 enea usb-storage: -- code: 0x70, key: 0x5, ASC: 0x24, ASCQ: 0x0
Jul 28 10:00:17 enea usb-storage: (Unknown Key): (unknown ASC/ASCQ)
Jul 28 10:00:17 enea usb-storage: scsi cmd done, result=0x2
Jul 28 10:00:17 enea usb-storage: queuecommand called
Jul 28 10:00:17 enea usb-storage: *** thread sleeping.
Jul 28 10:00:17 enea usb-storage: *** thread awakened.
Jul 28 10:00:17 enea usb-storage: Command TEST_UNIT_READY (6 bytes)
Jul 28 10:00:17 enea usb-storage:  00 00 00 00 00 00
Jul 28 10:00:17 enea usb-storage: Bulk Command S 0x43425355 T 0x8 L 0 F 0 Trg 0 LUN 0 CL 6
Jul 28 10:00:17 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 28 10:00:17 enea usb-storage: Status code 0; transferred 31/31
Jul 28 10:00:17 enea usb-storage: -- transfer complete
Jul 28 10:00:17 enea usb-storage: Bulk command transfer result=0
Jul 28 10:00:17 enea usb-storage: Attempting to get CSW...
Jul 28 10:00:17 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 28 10:00:17 enea usb-storage: Status code 0; transferred 13/13
Jul 28 10:00:17 enea usb-storage: -- transfer complete
Jul 28 10:00:17 enea usb-storage: Bulk status result = 0
Jul 28 10:00:17 enea usb-storage: Bulk Status S 0x53425355 T 0x8 R 0 Stat 0x0
Jul 28 10:00:17 enea usb-storage: scsi cmd done, result=0x0
Jul 28 10:00:17 enea usb-storage: *** thread sleeping.
Jul 28 10:00:17 enea usb-storage: queuecommand called
Jul 28 10:00:17 enea usb-storage: *** thread awakened.
Jul 28 10:00:17 enea usb-storage: Command READ_CAPACITY (10 bytes)
Jul 28 10:00:17 enea usb-storage:  25 00 00 00 00 00 00 00 00 00
Jul 28 10:00:17 enea usb-storage: Bulk Command S 0x43425355 T 0x9 L 8 F 128 Trg 0 LUN 0 CL 10
Jul 28 10:00:17 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 28 10:00:17 enea usb-storage: Status code 0; transferred 31/31
Jul 28 10:00:17 enea usb-storage: -- transfer complete
Jul 28 10:00:17 enea usb-storage: Bulk command transfer result=0
Jul 28 10:00:17 enea usb-storage: usb_stor_bulk_transfer_sglist: xfer 8 bytes, 1 entries
Jul 28 10:00:17 enea usb-storage: Status code 0; transferred 8/8
Jul 28 10:00:17 enea usb-storage: -- transfer complete
Jul 28 10:00:17 enea usb-storage: Bulk data transfer result 0x0
Jul 28 10:00:17 enea usb-storage: Attempting to get CSW...
Jul 28 10:00:17 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 28 10:00:17 enea usb-storage: Status code 0; transferred 13/13
Jul 28 10:00:17 enea usb-storage: -- transfer complete
Jul 28 10:00:17 enea usb-storage: Bulk status result = 0
Jul 28 10:00:17 enea usb-storage: Bulk Status S 0x53425355 T 0x9 R 0 Stat 0x0
Jul 28 10:00:17 enea usb-storage: scsi cmd done, result=0x0
Jul 28 10:00:17 enea usb-storage: *** thread sleeping.
Jul 28 10:00:17 enea sd 2:0:0:0: [sdb] 3970049 512-byte hardware sectors (2033 MB)
Jul 28 10:00:17 enea usb-storage: queuecommand called
Jul 28 10:00:17 enea usb-storage: *** thread awakened.
Jul 28 10:00:17 enea usb-storage: Command MODE_SENSE (6 bytes)
Jul 28 10:00:17 enea usb-storage:  1a 00 3f 00 c0 00
Jul 28 10:00:17 enea usb-storage: Bulk Command S 0x43425355 T 0xa L 192 F 128 Trg 0 LUN 0 CL 6
Jul 28 10:00:17 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 28 10:00:17 enea usb-storage: Status code 0; transferred 31/31
Jul 28 10:00:17 enea usb-storage: -- transfer complete
Jul 28 10:00:17 enea usb-storage: Bulk command transfer result=0
Jul 28 10:00:17 enea usb-storage: usb_stor_bulk_transfer_sglist: xfer 192 bytes, 1 entries
Jul 28 10:00:17 enea usb-storage: Status code -121; transferred 4/192
Jul 28 10:00:17 enea usb-storage: -- short read transfer
Jul 28 10:00:17 enea usb-storage: Bulk data transfer result 0x1
Jul 28 10:00:17 enea usb-storage: Attempting to get CSW...
Jul 28 10:00:17 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 28 10:00:17 enea usb-storage: Status code 0; transferred 13/13
Jul 28 10:00:17 enea usb-storage: -- transfer complete
Jul 28 10:00:17 enea usb-storage: Bulk status result = 0
Jul 28 10:00:17 enea usb-storage: Bulk Status S 0x53425355 T 0xa R 188 Stat 0x0
Jul 28 10:00:17 enea usb-storage: scsi cmd done, result=0x0
Jul 28 10:00:17 enea usb-storage: *** thread sleeping.
Jul 28 10:00:17 enea sd 2:0:0:0: [sdb] Write Protect is off
Jul 28 10:00:17 enea sd 2:0:0:0: [sdb] Mode Sense: 03 00 00 00
Jul 28 10:00:17 enea sd 2:0:0:0: [sdb] Assuming drive cache: write through
Jul 28 10:00:17 enea sdb:<7>usb-storage: queuecommand called
Jul 28 10:00:17 enea usb-storage: *** thread awakened.
Jul 28 10:00:17 enea usb-storage: Command READ_10 (10 bytes)
Jul 28 10:00:17 enea usb-storage:  28 00 00 00 00 00 00 00 08 00
Jul 28 10:00:17 enea usb-storage: Bulk Command S 0x43425355 T 0xb L 4096 F 128 Trg 0 LUN 0 CL 10
Jul 28 10:00:17 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 28 10:00:17 enea usb-storage: Status code 0; transferred 31/31
Jul 28 10:00:17 enea usb-storage: -- transfer complete
Jul 28 10:00:17 enea usb-storage: Bulk command transfer result=0
Jul 28 10:00:17 enea usb-storage: usb_stor_bulk_transfer_sglist: xfer 4096 bytes, 1 entries
Jul 28 10:00:17 enea usb-storage: Status code 0; transferred 4096/4096
Jul 28 10:00:17 enea usb-storage: -- transfer complete
Jul 28 10:00:17 enea usb-storage: Bulk data transfer result 0x0
Jul 28 10:00:17 enea usb-storage: Attempting to get CSW...
Jul 28 10:00:17 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 28 10:00:17 enea usb-storage: Status code 0; transferred 13/13
Jul 28 10:00:17 enea usb-storage: -- transfer complete
Jul 28 10:00:17 enea usb-storage: Bulk status result = 0
Jul 28 10:00:17 enea usb-storage: Bulk Status S 0x53425355 T 0xb R 0 Stat 0x0
Jul 28 10:00:17 enea usb-storage: scsi cmd done, result=0x0
Jul 28 10:00:17 enea usb-storage: *** thread sleeping.
Jul 28 10:00:17 enea sdb1
Jul 28 10:00:17 enea sd 2:0:0:0: [sdb] Attached SCSI removable disk
Jul 28 10:00:17 enea usb-storage: queuecommand called
Jul 28 10:00:17 enea usb-storage: *** thread awakened.
Jul 28 10:00:17 enea usb-storage: Bad target number (1:0)
Jul 28 10:00:17 enea usb-storage: scsi cmd done, result=0x40000
Jul 28 10:00:17 enea usb-storage: *** thread sleeping.
Jul 28 10:00:17 enea usb-storage: queuecommand called
Jul 28 10:00:17 enea usb-storage: *** thread awakened.
Jul 28 10:00:17 enea usb-storage: Bad target number (2:0)
Jul 28 10:00:17 enea usb-storage: scsi cmd done, result=0x40000
Jul 28 10:00:17 enea usb-storage: *** thread sleeping.
Jul 28 10:00:17 enea usb-storage: queuecommand called
Jul 28 10:00:17 enea usb-storage: *** thread awakened.
Jul 28 10:00:17 enea usb-storage: Bad target number (3:0)
Jul 28 10:00:17 enea usb-storage: scsi cmd done, result=0x40000
Jul 28 10:00:17 enea usb-storage: *** thread sleeping.
Jul 28 10:00:17 enea usb-storage: queuecommand called
Jul 28 10:00:17 enea usb-storage: *** thread awakened.
Jul 28 10:00:17 enea usb-storage: Bad target number (4:0)
Jul 28 10:00:17 enea usb-storage: scsi cmd done, result=0x40000
Jul 28 10:00:17 enea usb-storage: *** thread sleeping.
Jul 28 10:00:17 enea usb-storage: queuecommand called
Jul 28 10:00:17 enea usb-storage: *** thread awakened.
Jul 28 10:00:17 enea usb-storage: Bad target number (5:0)
Jul 28 10:00:17 enea usb-storage: scsi cmd done, result=0x40000
Jul 28 10:00:17 enea usb-storage: *** thread sleeping.
Jul 28 10:00:17 enea usb-storage: queuecommand called
Jul 28 10:00:17 enea usb-storage: *** thread awakened.
Jul 28 10:00:17 enea usb-storage: Bad target number (6:0)
Jul 28 10:00:17 enea usb-storage: scsi cmd done, result=0x40000
Jul 28 10:00:17 enea usb-storage: *** thread sleeping.
Jul 28 10:00:17 enea usb-storage: queuecommand called
Jul 28 10:00:17 enea usb-storage: *** thread awakened.
Jul 28 10:00:17 enea usb-storage: Bad target number (7:0)
Jul 28 10:00:17 enea usb-storage: scsi cmd done, result=0x40000
Jul 28 10:00:17 enea usb-storage: *** thread sleeping.
Jul 28 10:00:17 enea usb-storage: device scan complete
Jul 28 10:00:17 enea usb-storage: queuecommand called
Jul 28 10:00:17 enea usb-storage: *** thread awakened.
Jul 28 10:00:17 enea usb-storage: Command TEST_UNIT_READY (6 bytes)
Jul 28 10:00:17 enea usb-storage:  00 00 00 00 00 00
Jul 28 10:00:17 enea usb-storage: Bulk Command S 0x43425355 T 0xc L 0 F 0 Trg 0 LUN 0 CL 6
Jul 28 10:00:17 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 28 10:00:17 enea usb-storage: Status code 0; transferred 31/31
Jul 28 10:00:17 enea usb-storage: -- transfer complete
Jul 28 10:00:17 enea usb-storage: Bulk command transfer result=0
Jul 28 10:00:17 enea usb-storage: Attempting to get CSW...
Jul 28 10:00:17 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 28 10:00:17 enea usb-storage: Status code 0; transferred 13/13
Jul 28 10:00:17 enea usb-storage: -- transfer complete
Jul 28 10:00:17 enea usb-storage: Bulk status result = 0
Jul 28 10:00:17 enea usb-storage: Bulk Status S 0x53425355 T 0xc R 0 Stat 0x0
Jul 28 10:00:17 enea usb-storage: scsi cmd done, result=0x0
Jul 28 10:00:17 enea usb-storage: queuecommand called
Jul 28 10:00:17 enea usb-storage: *** thread sleeping.
Jul 28 10:00:17 enea usb-storage: *** thread awakened.
Jul 28 10:00:17 enea usb-storage: Command READ_10 (10 bytes)
Jul 28 10:00:17 enea usb-storage:  28 00 00 00 00 00 00 00 20 00
Jul 28 10:00:17 enea usb-storage: Bulk Command S 0x43425355 T 0xd L 16384 F 128 Trg 0 LUN 0 CL 10
Jul 28 10:00:17 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 28 10:00:17 enea usb-storage: Status code 0; transferred 31/31
Jul 28 10:00:17 enea usb-storage: -- transfer complete
Jul 28 10:00:17 enea usb-storage: Bulk command transfer result=0
Jul 28 10:00:17 enea usb-storage: usb_stor_bulk_transfer_sglist: xfer 16384 bytes, 4 entries
Jul 28 10:00:17 enea usb-storage: Status code 0; transferred 16384/16384
Jul 28 10:00:17 enea usb-storage: -- transfer complete
Jul 28 10:00:17 enea usb-storage: Bulk data transfer result 0x0
Jul 28 10:00:17 enea usb-storage: Attempting to get CSW...
Jul 28 10:00:17 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 28 10:00:17 enea usb-storage: Status code 0; transferred 13/13
Jul 28 10:00:17 enea usb-storage: -- transfer complete
Jul 28 10:00:17 enea usb-storage: Bulk status result = 0
Jul 28 10:00:17 enea usb-storage: Bulk Status S 0x53425355 T 0xd R 0 Stat 0x0
Jul 28 10:00:17 enea usb-storage: scsi cmd done, result=0x0
Jul 28 10:00:17 enea usb-storage: queuecommand called
Jul 28 10:00:17 enea usb-storage: *** thread sleeping.
Jul 28 10:00:17 enea usb-storage: *** thread awakened.
Jul 28 10:00:17 enea usb-storage: Command READ_10 (10 bytes)
Jul 28 10:00:17 enea usb-storage:  28 00 00 3c 93 80 00 00 01 00
Jul 28 10:00:17 enea usb-storage: Bulk Command S 0x43425355 T 0xe L 512 F 128 Trg 0 LUN 0 CL 10
Jul 28 10:00:17 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 28 10:00:17 enea usb-storage: Status code 0; transferred 31/31
Jul 28 10:00:17 enea usb-storage: -- transfer complete
Jul 28 10:00:17 enea usb-storage: Bulk command transfer result=0
Jul 28 10:00:17 enea usb-storage: usb_stor_bulk_transfer_sglist: xfer 512 bytes, 1 entries
Jul 28 10:00:17 enea usb-storage: Status code 0; transferred 512/512
Jul 28 10:00:17 enea usb-storage: -- transfer complete
Jul 28 10:00:17 enea usb-storage: Bulk data transfer result 0x0
Jul 28 10:00:17 enea usb-storage: Attempting to get CSW...
Jul 28 10:00:17 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 28 10:00:17 enea usb-storage: Status code 0; transferred 13/13
Jul 28 10:00:17 enea usb-storage: -- transfer complete
Jul 28 10:00:17 enea usb-storage: Bulk status result = 0
Jul 28 10:00:17 enea usb-storage: Bulk Status S 0x53425355 T 0xe R 0 Stat 0x0
Jul 28 10:00:17 enea usb-storage: scsi cmd done, result=0x0
Jul 28 10:00:17 enea usb-storage: queuecommand called
Jul 28 10:00:17 enea usb-storage: *** thread sleeping.
Jul 28 10:00:17 enea usb-storage: *** thread awakened.
Jul 28 10:00:17 enea usb-storage: Command READ_10 (10 bytes)
Jul 28 10:00:17 enea usb-storage:  28 00 00 3c 93 81 00 00 07 00
Jul 28 10:00:17 enea usb-storage: Bulk Command S 0x43425355 T 0xf L 3584 F 128 Trg 0 LUN 0 CL 10
Jul 28 10:00:17 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 28 10:00:17 enea usb-storage: Status code 0; transferred 31/31
Jul 28 10:00:17 enea usb-storage: -- transfer complete
Jul 28 10:00:17 enea usb-storage: Bulk command transfer result=0
Jul 28 10:00:17 enea usb-storage: usb_stor_bulk_transfer_sglist: xfer 3584 bytes, 1 entries
Jul 28 10:00:17 enea usb-storage: Status code 0; transferred 3584/3584
Jul 28 10:00:17 enea usb-storage: -- transfer complete
Jul 28 10:00:17 enea usb-storage: Bulk data transfer result 0x0
Jul 28 10:00:17 enea usb-storage: Attempting to get CSW...
Jul 28 10:00:17 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 28 10:00:17 enea usb-storage: Status code 0; transferred 13/13
Jul 28 10:00:17 enea usb-storage: -- transfer complete
Jul 28 10:00:17 enea usb-storage: Bulk status result = 0
Jul 28 10:00:17 enea usb-storage: Bulk Status S 0x53425355 T 0xf R 0 Stat 0x0
Jul 28 10:00:17 enea usb-storage: scsi cmd done, result=0x0
Jul 28 10:00:17 enea usb-storage: queuecommand called
Jul 28 10:00:17 enea usb-storage: *** thread sleeping.
Jul 28 10:00:17 enea usb-storage: *** thread awakened.
Jul 28 10:00:17 enea usb-storage: Command READ_10 (10 bytes)
Jul 28 10:00:17 enea usb-storage:  28 00 00 3c 93 f0 00 00 01 00
Jul 28 10:00:17 enea usb-storage: Bulk Command S 0x43425355 T 0x10 L 512 F 128 Trg 0 LUN 0 CL 10
Jul 28 10:00:17 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 28 10:00:17 enea usb-storage: Status code 0; transferred 31/31
Jul 28 10:00:17 enea usb-storage: -- transfer complete
Jul 28 10:00:17 enea usb-storage: Bulk command transfer result=0
Jul 28 10:00:17 enea usb-storage: usb_stor_bulk_transfer_sglist: xfer 512 bytes, 1 entries
Jul 28 10:00:17 enea usb-storage: Status code 0; transferred 512/512
Jul 28 10:00:17 enea usb-storage: -- transfer complete
Jul 28 10:00:17 enea usb-storage: Bulk data transfer result 0x0
Jul 28 10:00:17 enea usb-storage: Attempting to get CSW...
Jul 28 10:00:17 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 28 10:00:17 enea usb-storage: Status code 0; transferred 13/13
Jul 28 10:00:17 enea usb-storage: -- transfer complete
Jul 28 10:00:17 enea usb-storage: Bulk status result = 0
Jul 28 10:00:17 enea usb-storage: Bulk Status S 0x53425355 T 0x10 R 0 Stat 0x0
Jul 28 10:00:17 enea usb-storage: scsi cmd done, result=0x0
Jul 28 10:00:17 enea usb-storage: queuecommand called
Jul 28 10:00:17 enea usb-storage: *** thread sleeping.
Jul 28 10:00:17 enea usb-storage: *** thread awakened.
Jul 28 10:00:17 enea usb-storage: Command READ_10 (10 bytes)
Jul 28 10:00:18 enea usb-storage:  28 00 00 3c 93 f1 00 00 07 00
Jul 28 10:00:18 enea usb-storage: Bulk Command S 0x43425355 T 0x11 L 3584 F 128 Trg 0 LUN 0 CL 10
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 31/31
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk command transfer result=0
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_sglist: xfer 3584 bytes, 1 entries
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 3584/3584
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk data transfer result 0x0
Jul 28 10:00:18 enea usb-storage: Attempting to get CSW...
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 13/13
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk status result = 0
Jul 28 10:00:18 enea usb-storage: Bulk Status S 0x53425355 T 0x11 R 0 Stat 0x0
Jul 28 10:00:18 enea usb-storage: scsi cmd done, result=0x0
Jul 28 10:00:18 enea usb-storage: *** thread sleeping.
Jul 28 10:00:18 enea usb-storage: queuecommand called
Jul 28 10:00:18 enea usb-storage: *** thread awakened.
Jul 28 10:00:18 enea usb-storage: Command READ_10 (10 bytes)
Jul 28 10:00:18 enea usb-storage:  28 00 00 00 00 20 00 00 01 00
Jul 28 10:00:18 enea usb-storage: Bulk Command S 0x43425355 T 0x12 L 512 F 128 Trg 0 LUN 0 CL 10
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 31/31
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk command transfer result=0
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_sglist: xfer 512 bytes, 1 entries
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 512/512
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk data transfer result 0x0
Jul 28 10:00:18 enea usb-storage: Attempting to get CSW...
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 13/13
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk status result = 0
Jul 28 10:00:18 enea usb-storage: Bulk Status S 0x53425355 T 0x12 R 0 Stat 0x0
Jul 28 10:00:18 enea usb-storage: scsi cmd done, result=0x0
Jul 28 10:00:18 enea usb-storage: *** thread sleeping.
Jul 28 10:00:18 enea usb-storage: queuecommand called
Jul 28 10:00:18 enea usb-storage: *** thread awakened.
Jul 28 10:00:18 enea usb-storage: Command READ_10 (10 bytes)
Jul 28 10:00:18 enea usb-storage:  28 00 00 00 00 21 00 00 3f 00
Jul 28 10:00:18 enea usb-storage: Bulk Command S 0x43425355 T 0x13 L 32256 F 128 Trg 0 LUN 0 CL 10
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 31/31
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk command transfer result=0
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_sglist: xfer 32256 bytes, 8 entries
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 32256/32256
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk data transfer result 0x0
Jul 28 10:00:18 enea usb-storage: Attempting to get CSW...
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 13/13
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk status result = 0
Jul 28 10:00:18 enea usb-storage: Bulk Status S 0x53425355 T 0x13 R 0 Stat 0x0
Jul 28 10:00:18 enea usb-storage: scsi cmd done, result=0x0
Jul 28 10:00:18 enea usb-storage: *** thread sleeping.
Jul 28 10:00:18 enea usb-storage: queuecommand called
Jul 28 10:00:18 enea usb-storage: *** thread awakened.
Jul 28 10:00:18 enea usb-storage: Command READ_10 (10 bytes)
Jul 28 10:00:18 enea usb-storage:  28 00 00 3c 94 00 00 00 01 00
Jul 28 10:00:18 enea usb-storage: Bulk Command S 0x43425355 T 0x14 L 512 F 128 Trg 0 LUN 0 CL 10
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 31/31
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk command transfer result=0
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_sglist: xfer 512 bytes, 1 entries
Jul 28 10:00:18 enea usb-storage: Status code -32; transferred 0/512
Jul 28 10:00:18 enea usb-storage: clearing endpoint halt for pipe 0xc0008380
Jul 28 10:00:18 enea usb-storage: usb_stor_control_msg: rq=01 rqtype=02 value=0000 index=81 len=0
Jul 28 10:00:18 enea usb-storage: usb_stor_clear_halt: result = 0
Jul 28 10:00:18 enea usb-storage: Bulk data transfer result 0x2
Jul 28 10:00:18 enea usb-storage: Attempting to get CSW...
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 13/13
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk status result = 0
Jul 28 10:00:18 enea usb-storage: Bulk Status S 0x53425355 T 0x14 R 512 Stat 0x1
Jul 28 10:00:18 enea usb-storage: -- transport indicates command failure
Jul 28 10:00:18 enea usb-storage: -- unexpectedly short transfer
Jul 28 10:00:18 enea usb-storage: Issuing auto-REQUEST_SENSE
Jul 28 10:00:18 enea usb-storage: Bulk Command S 0x43425355 T 0x15 L 18 F 128 Trg 0 LUN 0 CL 6
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 31/31
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk command transfer result=0
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 18/18
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk data transfer result 0x0
Jul 28 10:00:18 enea usb-storage: Attempting to get CSW...
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 13/13
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk status result = 0
Jul 28 10:00:18 enea usb-storage: Bulk Status S 0x53425355 T 0x15 R 0 Stat 0x0
Jul 28 10:00:18 enea usb-storage: -- Result from auto-sense is 0
Jul 28 10:00:18 enea usb-storage: -- code: 0x70, key: 0x0, ASC: 0x0, ASCQ: 0x0
Jul 28 10:00:18 enea usb-storage: (Unknown Key): (unknown ASC/ASCQ)
Jul 28 10:00:18 enea usb-storage: scsi cmd done, result=0x2
Jul 28 10:00:18 enea usb-storage: *** thread sleeping.
Jul 28 10:00:18 enea sd 2:0:0:0: [sdb] Sense Key : 0x0 [current] 
Jul 28 10:00:18 enea sd 2:0:0:0: [sdb] ASC=0x0 ASCQ=0x0
Jul 28 10:00:18 enea usb-storage: queuecommand called
Jul 28 10:00:18 enea usb-storage: *** thread awakened.
Jul 28 10:00:18 enea usb-storage: Command READ_10 (10 bytes)
Jul 28 10:00:18 enea usb-storage:  28 00 00 3c 94 00 00 00 01 00
Jul 28 10:00:18 enea usb-storage: Bulk Command S 0x43425355 T 0x16 L 512 F 128 Trg 0 LUN 0 CL 10
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 31/31
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk command transfer result=0
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_sglist: xfer 512 bytes, 1 entries
Jul 28 10:00:18 enea usb-storage: Status code -32; transferred 0/512
Jul 28 10:00:18 enea usb-storage: clearing endpoint halt for pipe 0xc0008380
Jul 28 10:00:18 enea usb-storage: usb_stor_control_msg: rq=01 rqtype=02 value=0000 index=81 len=0
Jul 28 10:00:18 enea usb-storage: usb_stor_clear_halt: result = 0
Jul 28 10:00:18 enea usb-storage: Bulk data transfer result 0x2
Jul 28 10:00:18 enea usb-storage: Attempting to get CSW...
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 13/13
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk status result = 0
Jul 28 10:00:18 enea usb-storage: Bulk Status S 0x53425355 T 0x16 R 512 Stat 0x1
Jul 28 10:00:18 enea usb-storage: -- transport indicates command failure
Jul 28 10:00:18 enea usb-storage: -- unexpectedly short transfer
Jul 28 10:00:18 enea usb-storage: Issuing auto-REQUEST_SENSE
Jul 28 10:00:18 enea usb-storage: Bulk Command S 0x43425355 T 0x17 L 18 F 128 Trg 0 LUN 0 CL 6
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 31/31
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk command transfer result=0
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 18/18
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk data transfer result 0x0
Jul 28 10:00:18 enea usb-storage: Attempting to get CSW...
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 13/13
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk status result = 0
Jul 28 10:00:18 enea usb-storage: Bulk Status S 0x53425355 T 0x17 R 0 Stat 0x0
Jul 28 10:00:18 enea usb-storage: -- Result from auto-sense is 0
Jul 28 10:00:18 enea usb-storage: -- code: 0x70, key: 0x0, ASC: 0x0, ASCQ: 0x0
Jul 28 10:00:18 enea usb-storage: (Unknown Key): (unknown ASC/ASCQ)
Jul 28 10:00:18 enea usb-storage: scsi cmd done, result=0x2
Jul 28 10:00:18 enea usb-storage: *** thread sleeping.
Jul 28 10:00:18 enea sd 2:0:0:0: [sdb] Sense Key : 0x0 [current] 
Jul 28 10:00:18 enea sd 2:0:0:0: [sdb] ASC=0x0 ASCQ=0x0
Jul 28 10:00:18 enea usb-storage: queuecommand called
Jul 28 10:00:18 enea usb-storage: *** thread awakened.
Jul 28 10:00:18 enea usb-storage: Command READ_10 (10 bytes)
Jul 28 10:00:18 enea usb-storage:  28 00 00 3c 94 00 00 00 01 00
Jul 28 10:00:18 enea usb-storage: Bulk Command S 0x43425355 T 0x18 L 512 F 128 Trg 0 LUN 0 CL 10
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 31/31
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk command transfer result=0
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_sglist: xfer 512 bytes, 1 entries
Jul 28 10:00:18 enea usb-storage: Status code -32; transferred 0/512
Jul 28 10:00:18 enea usb-storage: clearing endpoint halt for pipe 0xc0008380
Jul 28 10:00:18 enea usb-storage: usb_stor_control_msg: rq=01 rqtype=02 value=0000 index=81 len=0
Jul 28 10:00:18 enea usb-storage: usb_stor_clear_halt: result = 0
Jul 28 10:00:18 enea usb-storage: Bulk data transfer result 0x2
Jul 28 10:00:18 enea usb-storage: Attempting to get CSW...
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 13/13
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk status result = 0
Jul 28 10:00:18 enea usb-storage: Bulk Status S 0x53425355 T 0x18 R 512 Stat 0x1
Jul 28 10:00:18 enea usb-storage: -- transport indicates command failure
Jul 28 10:00:18 enea usb-storage: -- unexpectedly short transfer
Jul 28 10:00:18 enea usb-storage: Issuing auto-REQUEST_SENSE
Jul 28 10:00:18 enea usb-storage: Bulk Command S 0x43425355 T 0x19 L 18 F 128 Trg 0 LUN 0 CL 6
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 31/31
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk command transfer result=0
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 18/18
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk data transfer result 0x0
Jul 28 10:00:18 enea usb-storage: Attempting to get CSW...
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 13/13
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk status result = 0
Jul 28 10:00:18 enea usb-storage: Bulk Status S 0x53425355 T 0x19 R 0 Stat 0x0
Jul 28 10:00:18 enea usb-storage: -- Result from auto-sense is 0
Jul 28 10:00:18 enea usb-storage: -- code: 0x70, key: 0x0, ASC: 0x0, ASCQ: 0x0
Jul 28 10:00:18 enea usb-storage: (Unknown Key): (unknown ASC/ASCQ)
Jul 28 10:00:18 enea usb-storage: scsi cmd done, result=0x2
Jul 28 10:00:18 enea sd 2:0:0:0: [sdb] Sense Key : 0x0 [current] 
Jul 28 10:00:18 enea sd 2:0:0:0: [sdb] ASC=0x0 ASCQ=0x0
Jul 28 10:00:18 enea usb-storage: queuecommand called
Jul 28 10:00:18 enea usb-storage: *** thread sleeping.
Jul 28 10:00:18 enea usb-storage: *** thread awakened.
Jul 28 10:00:18 enea usb-storage: Command READ_10 (10 bytes)
Jul 28 10:00:18 enea usb-storage:  28 00 00 3c 94 00 00 00 01 00
Jul 28 10:00:18 enea usb-storage: Bulk Command S 0x43425355 T 0x1a L 512 F 128 Trg 0 LUN 0 CL 10
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 31/31
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk command transfer result=0
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_sglist: xfer 512 bytes, 1 entries
Jul 28 10:00:18 enea usb-storage: Status code -32; transferred 0/512
Jul 28 10:00:18 enea usb-storage: clearing endpoint halt for pipe 0xc0008380
Jul 28 10:00:18 enea usb-storage: usb_stor_control_msg: rq=01 rqtype=02 value=0000 index=81 len=0
Jul 28 10:00:18 enea usb-storage: usb_stor_clear_halt: result = 0
Jul 28 10:00:18 enea usb-storage: Bulk data transfer result 0x2
Jul 28 10:00:18 enea usb-storage: Attempting to get CSW...
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 13/13
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk status result = 0
Jul 28 10:00:18 enea usb-storage: Bulk Status S 0x53425355 T 0x1a R 512 Stat 0x1
Jul 28 10:00:18 enea usb-storage: -- transport indicates command failure
Jul 28 10:00:18 enea usb-storage: -- unexpectedly short transfer
Jul 28 10:00:18 enea usb-storage: Issuing auto-REQUEST_SENSE
Jul 28 10:00:18 enea usb-storage: Bulk Command S 0x43425355 T 0x1b L 18 F 128 Trg 0 LUN 0 CL 6
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 31/31
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk command transfer result=0
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 18/18
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk data transfer result 0x0
Jul 28 10:00:18 enea usb-storage: Attempting to get CSW...
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 13/13
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk status result = 0
Jul 28 10:00:18 enea usb-storage: Bulk Status S 0x53425355 T 0x1b R 0 Stat 0x0
Jul 28 10:00:18 enea usb-storage: -- Result from auto-sense is 0
Jul 28 10:00:18 enea usb-storage: -- code: 0x70, key: 0x0, ASC: 0x0, ASCQ: 0x0
Jul 28 10:00:18 enea usb-storage: (Unknown Key): (unknown ASC/ASCQ)
Jul 28 10:00:18 enea usb-storage: scsi cmd done, result=0x2
Jul 28 10:00:18 enea sd 2:0:0:0: [sdb] Sense Key : 0x0 [current] 
Jul 28 10:00:18 enea sd 2:0:0:0: [sdb] ASC=0x0 ASCQ=0x0
Jul 28 10:00:18 enea usb-storage: queuecommand called
Jul 28 10:00:18 enea usb-storage: *** thread sleeping.
Jul 28 10:00:18 enea usb-storage: *** thread awakened.
Jul 28 10:00:18 enea usb-storage: Command READ_10 (10 bytes)
Jul 28 10:00:18 enea usb-storage:  28 00 00 3c 94 00 00 00 01 00
Jul 28 10:00:18 enea usb-storage: Bulk Command S 0x43425355 T 0x1c L 512 F 128 Trg 0 LUN 0 CL 10
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 31/31
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk command transfer result=0
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_sglist: xfer 512 bytes, 1 entries
Jul 28 10:00:18 enea usb-storage: Status code -32; transferred 0/512
Jul 28 10:00:18 enea usb-storage: clearing endpoint halt for pipe 0xc0008380
Jul 28 10:00:18 enea usb-storage: usb_stor_control_msg: rq=01 rqtype=02 value=0000 index=81 len=0
Jul 28 10:00:18 enea usb-storage: usb_stor_clear_halt: result = 0
Jul 28 10:00:18 enea usb-storage: Bulk data transfer result 0x2
Jul 28 10:00:18 enea usb-storage: Attempting to get CSW...
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 13/13
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk status result = 0
Jul 28 10:00:18 enea usb-storage: Bulk Status S 0x53425355 T 0x1c R 512 Stat 0x1
Jul 28 10:00:18 enea usb-storage: -- transport indicates command failure
Jul 28 10:00:18 enea usb-storage: -- unexpectedly short transfer
Jul 28 10:00:18 enea usb-storage: Issuing auto-REQUEST_SENSE
Jul 28 10:00:18 enea usb-storage: Bulk Command S 0x43425355 T 0x1d L 18 F 128 Trg 0 LUN 0 CL 6
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 31/31
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk command transfer result=0
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 18/18
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk data transfer result 0x0
Jul 28 10:00:18 enea usb-storage: Attempting to get CSW...
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 13/13
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk status result = 0
Jul 28 10:00:18 enea usb-storage: Bulk Status S 0x53425355 T 0x1d R 0 Stat 0x0
Jul 28 10:00:18 enea usb-storage: -- Result from auto-sense is 0
Jul 28 10:00:18 enea usb-storage: -- code: 0x70, key: 0x0, ASC: 0x0, ASCQ: 0x0
Jul 28 10:00:18 enea usb-storage: (Unknown Key): (unknown ASC/ASCQ)
Jul 28 10:00:18 enea usb-storage: scsi cmd done, result=0x2
Jul 28 10:00:18 enea sd 2:0:0:0: [sdb] Sense Key : 0x0 [current] 
Jul 28 10:00:18 enea sd 2:0:0:0: [sdb] ASC=0x0 ASCQ=0x0
Jul 28 10:00:18 enea usb-storage: queuecommand called
Jul 28 10:00:18 enea usb-storage: *** thread sleeping.
Jul 28 10:00:18 enea usb-storage: *** thread awakened.
Jul 28 10:00:18 enea usb-storage: Command READ_10 (10 bytes)
Jul 28 10:00:18 enea usb-storage:  28 00 00 3c 94 00 00 00 01 00
Jul 28 10:00:18 enea usb-storage: Bulk Command S 0x43425355 T 0x1e L 512 F 128 Trg 0 LUN 0 CL 10
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 31/31
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk command transfer result=0
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_sglist: xfer 512 bytes, 1 entries
Jul 28 10:00:18 enea usb-storage: Status code -32; transferred 0/512
Jul 28 10:00:18 enea usb-storage: clearing endpoint halt for pipe 0xc0008380
Jul 28 10:00:18 enea usb-storage: usb_stor_control_msg: rq=01 rqtype=02 value=0000 index=81 len=0
Jul 28 10:00:18 enea usb-storage: usb_stor_clear_halt: result = 0
Jul 28 10:00:18 enea usb-storage: Bulk data transfer result 0x2
Jul 28 10:00:18 enea usb-storage: Attempting to get CSW...
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 13/13
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk status result = 0
Jul 28 10:00:18 enea usb-storage: Bulk Status S 0x53425355 T 0x1e R 512 Stat 0x1
Jul 28 10:00:18 enea usb-storage: -- transport indicates command failure
Jul 28 10:00:18 enea usb-storage: -- unexpectedly short transfer
Jul 28 10:00:18 enea usb-storage: Issuing auto-REQUEST_SENSE
Jul 28 10:00:18 enea usb-storage: Bulk Command S 0x43425355 T 0x1f L 18 F 128 Trg 0 LUN 0 CL 6
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 31/31
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk command transfer result=0
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 18/18
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk data transfer result 0x0
Jul 28 10:00:18 enea usb-storage: Attempting to get CSW...
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 13/13
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk status result = 0
Jul 28 10:00:18 enea usb-storage: Bulk Status S 0x53425355 T 0x1f R 0 Stat 0x0
Jul 28 10:00:18 enea usb-storage: -- Result from auto-sense is 0
Jul 28 10:00:18 enea usb-storage: -- code: 0x70, key: 0x0, ASC: 0x0, ASCQ: 0x0
Jul 28 10:00:18 enea usb-storage: (Unknown Key): (unknown ASC/ASCQ)
Jul 28 10:00:18 enea usb-storage: scsi cmd done, result=0x2
Jul 28 10:00:18 enea sd 2:0:0:0: [sdb] Sense Key : 0x0 [current] 
Jul 28 10:00:18 enea sd 2:0:0:0: [sdb] ASC=0x0 ASCQ=0x0
Jul 28 10:00:18 enea usb-storage: queuecommand called
Jul 28 10:00:18 enea usb-storage: *** thread sleeping.
Jul 28 10:00:18 enea usb-storage: *** thread awakened.
Jul 28 10:00:18 enea usb-storage: Command READ_10 (10 bytes)
Jul 28 10:00:18 enea usb-storage:  28 00 00 3c 94 00 00 00 01 00
Jul 28 10:00:18 enea usb-storage: Bulk Command S 0x43425355 T 0x20 L 512 F 128 Trg 0 LUN 0 CL 10
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 31/31
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk command transfer result=0
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_sglist: xfer 512 bytes, 1 entries
Jul 28 10:00:18 enea usb-storage: Status code -32; transferred 0/512
Jul 28 10:00:18 enea usb-storage: clearing endpoint halt for pipe 0xc0008380
Jul 28 10:00:18 enea usb-storage: usb_stor_control_msg: rq=01 rqtype=02 value=0000 index=81 len=0
Jul 28 10:00:18 enea usb-storage: usb_stor_clear_halt: result = 0
Jul 28 10:00:18 enea usb-storage: Bulk data transfer result 0x2
Jul 28 10:00:18 enea usb-storage: Attempting to get CSW...
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 13/13
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk status result = 0
Jul 28 10:00:18 enea usb-storage: Bulk Status S 0x53425355 T 0x20 R 512 Stat 0x1
Jul 28 10:00:18 enea usb-storage: -- transport indicates command failure
Jul 28 10:00:18 enea usb-storage: -- unexpectedly short transfer
Jul 28 10:00:18 enea usb-storage: Issuing auto-REQUEST_SENSE
Jul 28 10:00:18 enea usb-storage: Bulk Command S 0x43425355 T 0x21 L 18 F 128 Trg 0 LUN 0 CL 6
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 31/31
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk command transfer result=0
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 18/18
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk data transfer result 0x0
Jul 28 10:00:18 enea usb-storage: Attempting to get CSW...
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 13/13
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk status result = 0
Jul 28 10:00:18 enea usb-storage: Bulk Status S 0x53425355 T 0x21 R 0 Stat 0x0
Jul 28 10:00:18 enea usb-storage: -- Result from auto-sense is 0
Jul 28 10:00:18 enea usb-storage: -- code: 0x70, key: 0x0, ASC: 0x0, ASCQ: 0x0
Jul 28 10:00:18 enea usb-storage: (Unknown Key): (unknown ASC/ASCQ)
Jul 28 10:00:18 enea usb-storage: scsi cmd done, result=0x2
Jul 28 10:00:18 enea sd 2:0:0:0: [sdb] Sense Key : 0x0 [current] 
Jul 28 10:00:18 enea sd 2:0:0:0: [sdb] ASC=0x0 ASCQ=0x0
Jul 28 10:00:18 enea usb-storage: queuecommand called
Jul 28 10:00:18 enea usb-storage: *** thread sleeping.
Jul 28 10:00:18 enea usb-storage: *** thread awakened.
Jul 28 10:00:18 enea usb-storage: Command READ_10 (10 bytes)
Jul 28 10:00:18 enea usb-storage:  28 00 00 3c 94 00 00 00 01 00
Jul 28 10:00:18 enea usb-storage: Bulk Command S 0x43425355 T 0x22 L 512 F 128 Trg 0 LUN 0 CL 10
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 31/31
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk command transfer result=0
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_sglist: xfer 512 bytes, 1 entries
Jul 28 10:00:18 enea usb-storage: Status code -32; transferred 0/512
Jul 28 10:00:18 enea usb-storage: clearing endpoint halt for pipe 0xc0008380
Jul 28 10:00:18 enea usb-storage: usb_stor_control_msg: rq=01 rqtype=02 value=0000 index=81 len=0
Jul 28 10:00:18 enea usb-storage: usb_stor_clear_halt: result = 0
Jul 28 10:00:18 enea usb-storage: Bulk data transfer result 0x2
Jul 28 10:00:18 enea usb-storage: Attempting to get CSW...
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 13/13
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk status result = 0
Jul 28 10:00:18 enea usb-storage: Bulk Status S 0x53425355 T 0x22 R 512 Stat 0x1
Jul 28 10:00:18 enea usb-storage: -- transport indicates command failure
Jul 28 10:00:18 enea usb-storage: -- unexpectedly short transfer
Jul 28 10:00:18 enea usb-storage: Issuing auto-REQUEST_SENSE
Jul 28 10:00:18 enea usb-storage: Bulk Command S 0x43425355 T 0x23 L 18 F 128 Trg 0 LUN 0 CL 6
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 31/31
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk command transfer result=0
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 18/18
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk data transfer result 0x0
Jul 28 10:00:18 enea usb-storage: Attempting to get CSW...
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 13/13
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk status result = 0
Jul 28 10:00:18 enea usb-storage: Bulk Status S 0x53425355 T 0x23 R 0 Stat 0x0
Jul 28 10:00:18 enea usb-storage: -- Result from auto-sense is 0
Jul 28 10:00:18 enea usb-storage: -- code: 0x70, key: 0x0, ASC: 0x0, ASCQ: 0x0
Jul 28 10:00:18 enea usb-storage: (Unknown Key): (unknown ASC/ASCQ)
Jul 28 10:00:18 enea usb-storage: scsi cmd done, result=0x2
Jul 28 10:00:18 enea sd 2:0:0:0: [sdb] Sense Key : 0x0 [current] 
Jul 28 10:00:18 enea sd 2:0:0:0: [sdb] ASC=0x0 ASCQ=0x0
Jul 28 10:00:18 enea usb-storage: queuecommand called
Jul 28 10:00:18 enea usb-storage: *** thread sleeping.
Jul 28 10:00:18 enea usb-storage: *** thread awakened.
Jul 28 10:00:18 enea usb-storage: Command READ_10 (10 bytes)
Jul 28 10:00:18 enea usb-storage:  28 00 00 3c 94 00 00 00 01 00
Jul 28 10:00:18 enea usb-storage: Bulk Command S 0x43425355 T 0x24 L 512 F 128 Trg 0 LUN 0 CL 10
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 31/31
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk command transfer result=0
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_sglist: xfer 512 bytes, 1 entries
Jul 28 10:00:18 enea usb-storage: Status code -32; transferred 0/512
Jul 28 10:00:18 enea usb-storage: clearing endpoint halt for pipe 0xc0008380
Jul 28 10:00:18 enea usb-storage: usb_stor_control_msg: rq=01 rqtype=02 value=0000 index=81 len=0
Jul 28 10:00:18 enea usb-storage: usb_stor_clear_halt: result = 0
Jul 28 10:00:18 enea usb-storage: Bulk data transfer result 0x2
Jul 28 10:00:18 enea usb-storage: Attempting to get CSW...
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 13/13
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk status result = 0
Jul 28 10:00:18 enea usb-storage: Bulk Status S 0x53425355 T 0x24 R 512 Stat 0x1
Jul 28 10:00:18 enea usb-storage: -- transport indicates command failure
Jul 28 10:00:18 enea usb-storage: -- unexpectedly short transfer
Jul 28 10:00:18 enea usb-storage: Issuing auto-REQUEST_SENSE
Jul 28 10:00:18 enea usb-storage: Bulk Command S 0x43425355 T 0x25 L 18 F 128 Trg 0 LUN 0 CL 6
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 31/31
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk command transfer result=0
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 18/18
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk data transfer result 0x0
Jul 28 10:00:18 enea usb-storage: Attempting to get CSW...
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 13/13
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk status result = 0
Jul 28 10:00:18 enea usb-storage: Bulk Status S 0x53425355 T 0x25 R 0 Stat 0x0
Jul 28 10:00:18 enea usb-storage: -- Result from auto-sense is 0
Jul 28 10:00:18 enea usb-storage: -- code: 0x70, key: 0x0, ASC: 0x0, ASCQ: 0x0
Jul 28 10:00:18 enea usb-storage: (Unknown Key): (unknown ASC/ASCQ)
Jul 28 10:00:18 enea usb-storage: scsi cmd done, result=0x2
Jul 28 10:00:18 enea sd 2:0:0:0: [sdb] Sense Key : 0x0 [current] 
Jul 28 10:00:18 enea sd 2:0:0:0: [sdb] ASC=0x0 ASCQ=0x0
Jul 28 10:00:18 enea usb-storage: queuecommand called
Jul 28 10:00:18 enea usb-storage: *** thread sleeping.
Jul 28 10:00:18 enea usb-storage: *** thread awakened.
Jul 28 10:00:18 enea usb-storage: Command READ_10 (10 bytes)
Jul 28 10:00:18 enea usb-storage:  28 00 00 3c 94 00 00 00 01 00
Jul 28 10:00:18 enea usb-storage: Bulk Command S 0x43425355 T 0x26 L 512 F 128 Trg 0 LUN 0 CL 10
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 31/31
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk command transfer result=0
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_sglist: xfer 512 bytes, 1 entries
Jul 28 10:00:18 enea usb-storage: Status code -32; transferred 0/512
Jul 28 10:00:18 enea usb-storage: clearing endpoint halt for pipe 0xc0008380
Jul 28 10:00:18 enea usb-storage: usb_stor_control_msg: rq=01 rqtype=02 value=0000 index=81 len=0
Jul 28 10:00:18 enea usb-storage: usb_stor_clear_halt: result = 0
Jul 28 10:00:18 enea usb-storage: Bulk data transfer result 0x2
Jul 28 10:00:18 enea usb-storage: Attempting to get CSW...
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 13/13
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk status result = 0
Jul 28 10:00:18 enea usb-storage: Bulk Status S 0x53425355 T 0x26 R 512 Stat 0x1
Jul 28 10:00:18 enea usb-storage: -- transport indicates command failure
Jul 28 10:00:18 enea usb-storage: -- unexpectedly short transfer
Jul 28 10:00:18 enea usb-storage: Issuing auto-REQUEST_SENSE
Jul 28 10:00:18 enea usb-storage: Bulk Command S 0x43425355 T 0x27 L 18 F 128 Trg 0 LUN 0 CL 6
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 31/31
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk command transfer result=0
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 18/18
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk data transfer result 0x0
Jul 28 10:00:18 enea usb-storage: Attempting to get CSW...
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 13/13
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk status result = 0
Jul 28 10:00:18 enea usb-storage: Bulk Status S 0x53425355 T 0x27 R 0 Stat 0x0
Jul 28 10:00:18 enea usb-storage: -- Result from auto-sense is 0
Jul 28 10:00:18 enea usb-storage: -- code: 0x70, key: 0x0, ASC: 0x0, ASCQ: 0x0
Jul 28 10:00:18 enea usb-storage: (Unknown Key): (unknown ASC/ASCQ)
Jul 28 10:00:18 enea usb-storage: scsi cmd done, result=0x2
Jul 28 10:00:18 enea sd 2:0:0:0: [sdb] Sense Key : 0x0 [current] 
Jul 28 10:00:18 enea sd 2:0:0:0: [sdb] ASC=0x0 ASCQ=0x0
Jul 28 10:00:18 enea usb-storage: queuecommand called
Jul 28 10:00:18 enea usb-storage: *** thread sleeping.
Jul 28 10:00:18 enea usb-storage: *** thread awakened.
Jul 28 10:00:18 enea usb-storage: Command READ_10 (10 bytes)
Jul 28 10:00:18 enea usb-storage:  28 00 00 3c 94 00 00 00 01 00
Jul 28 10:00:18 enea usb-storage: Bulk Command S 0x43425355 T 0x28 L 512 F 128 Trg 0 LUN 0 CL 10
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 31/31
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk command transfer result=0
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_sglist: xfer 512 bytes, 1 entries
Jul 28 10:00:18 enea usb-storage: Status code -32; transferred 0/512
Jul 28 10:00:18 enea usb-storage: clearing endpoint halt for pipe 0xc0008380
Jul 28 10:00:18 enea usb-storage: usb_stor_control_msg: rq=01 rqtype=02 value=0000 index=81 len=0
Jul 28 10:00:18 enea usb-storage: usb_stor_clear_halt: result = 0
Jul 28 10:00:18 enea usb-storage: Bulk data transfer result 0x2
Jul 28 10:00:18 enea usb-storage: Attempting to get CSW...
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 13/13
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk status result = 0
Jul 28 10:00:18 enea usb-storage: Bulk Status S 0x53425355 T 0x28 R 512 Stat 0x1
Jul 28 10:00:18 enea usb-storage: -- transport indicates command failure
Jul 28 10:00:18 enea usb-storage: -- unexpectedly short transfer
Jul 28 10:00:18 enea usb-storage: Issuing auto-REQUEST_SENSE
Jul 28 10:00:18 enea usb-storage: Bulk Command S 0x43425355 T 0x29 L 18 F 128 Trg 0 LUN 0 CL 6
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 31/31
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk command transfer result=0
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 18/18
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk data transfer result 0x0
Jul 28 10:00:18 enea usb-storage: Attempting to get CSW...
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 13/13
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk status result = 0
Jul 28 10:00:18 enea usb-storage: Bulk Status S 0x53425355 T 0x29 R 0 Stat 0x0
Jul 28 10:00:18 enea usb-storage: -- Result from auto-sense is 0
Jul 28 10:00:18 enea usb-storage: -- code: 0x70, key: 0x0, ASC: 0x0, ASCQ: 0x0
Jul 28 10:00:18 enea usb-storage: (Unknown Key): (unknown ASC/ASCQ)
Jul 28 10:00:18 enea usb-storage: scsi cmd done, result=0x2
Jul 28 10:00:18 enea sd 2:0:0:0: [sdb] Sense Key : 0x0 [current] 
Jul 28 10:00:18 enea sd 2:0:0:0: [sdb] ASC=0x0 ASCQ=0x0
Jul 28 10:00:18 enea usb-storage: queuecommand called
Jul 28 10:00:18 enea usb-storage: *** thread sleeping.
Jul 28 10:00:18 enea usb-storage: *** thread awakened.
Jul 28 10:00:18 enea usb-storage: Command READ_10 (10 bytes)
Jul 28 10:00:18 enea usb-storage:  28 00 00 3c 94 00 00 00 01 00
Jul 28 10:00:18 enea usb-storage: Bulk Command S 0x43425355 T 0x2a L 512 F 128 Trg 0 LUN 0 CL 10
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 31/31
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk command transfer result=0
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_sglist: xfer 512 bytes, 1 entries
Jul 28 10:00:18 enea usb-storage: Status code -32; transferred 0/512
Jul 28 10:00:18 enea usb-storage: clearing endpoint halt for pipe 0xc0008380
Jul 28 10:00:18 enea usb-storage: usb_stor_control_msg: rq=01 rqtype=02 value=0000 index=81 len=0
Jul 28 10:00:18 enea usb-storage: usb_stor_clear_halt: result = 0
Jul 28 10:00:18 enea usb-storage: Bulk data transfer result 0x2
Jul 28 10:00:18 enea usb-storage: Attempting to get CSW...
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 13/13
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk status result = 0
Jul 28 10:00:18 enea usb-storage: Bulk Status S 0x53425355 T 0x2a R 512 Stat 0x1
Jul 28 10:00:18 enea usb-storage: -- transport indicates command failure
Jul 28 10:00:18 enea usb-storage: -- unexpectedly short transfer
Jul 28 10:00:18 enea usb-storage: Issuing auto-REQUEST_SENSE
Jul 28 10:00:18 enea usb-storage: Bulk Command S 0x43425355 T 0x2b L 18 F 128 Trg 0 LUN 0 CL 6
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 31/31
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk command transfer result=0
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 18/18
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk data transfer result 0x0
Jul 28 10:00:18 enea usb-storage: Attempting to get CSW...
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 13/13
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk status result = 0
Jul 28 10:00:18 enea usb-storage: Bulk Status S 0x53425355 T 0x2b R 0 Stat 0x0
Jul 28 10:00:18 enea usb-storage: -- Result from auto-sense is 0
Jul 28 10:00:18 enea usb-storage: -- code: 0x70, key: 0x0, ASC: 0x0, ASCQ: 0x0
Jul 28 10:00:18 enea usb-storage: (Unknown Key): (unknown ASC/ASCQ)
Jul 28 10:00:18 enea usb-storage: scsi cmd done, result=0x2
Jul 28 10:00:18 enea sd 2:0:0:0: [sdb] Sense Key : 0x0 [current] 
Jul 28 10:00:18 enea sd 2:0:0:0: [sdb] ASC=0x0 ASCQ=0x0
Jul 28 10:00:18 enea usb-storage: queuecommand called
Jul 28 10:00:18 enea usb-storage: *** thread sleeping.
Jul 28 10:00:18 enea usb-storage: *** thread awakened.
Jul 28 10:00:18 enea usb-storage: Command READ_10 (10 bytes)
Jul 28 10:00:18 enea usb-storage:  28 00 00 3c 94 00 00 00 01 00
Jul 28 10:00:18 enea usb-storage: Bulk Command S 0x43425355 T 0x2c L 512 F 128 Trg 0 LUN 0 CL 10
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 31/31
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk command transfer result=0
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_sglist: xfer 512 bytes, 1 entries
Jul 28 10:00:18 enea usb-storage: Status code -32; transferred 0/512
Jul 28 10:00:18 enea usb-storage: clearing endpoint halt for pipe 0xc0008380
Jul 28 10:00:18 enea usb-storage: usb_stor_control_msg: rq=01 rqtype=02 value=0000 index=81 len=0
Jul 28 10:00:18 enea usb-storage: usb_stor_clear_halt: result = 0
Jul 28 10:00:18 enea usb-storage: Bulk data transfer result 0x2
Jul 28 10:00:18 enea usb-storage: Attempting to get CSW...
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 13/13
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk status result = 0
Jul 28 10:00:18 enea usb-storage: Bulk Status S 0x53425355 T 0x2c R 512 Stat 0x1
Jul 28 10:00:18 enea usb-storage: -- transport indicates command failure
Jul 28 10:00:18 enea usb-storage: -- unexpectedly short transfer
Jul 28 10:00:18 enea usb-storage: Issuing auto-REQUEST_SENSE
Jul 28 10:00:18 enea usb-storage: Bulk Command S 0x43425355 T 0x2d L 18 F 128 Trg 0 LUN 0 CL 6
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 31/31
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk command transfer result=0
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 18/18
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk data transfer result 0x0
Jul 28 10:00:18 enea usb-storage: Attempting to get CSW...
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 13/13
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk status result = 0
Jul 28 10:00:18 enea usb-storage: Bulk Status S 0x53425355 T 0x2d R 0 Stat 0x0
Jul 28 10:00:18 enea usb-storage: -- Result from auto-sense is 0
Jul 28 10:00:18 enea usb-storage: -- code: 0x70, key: 0x0, ASC: 0x0, ASCQ: 0x0
Jul 28 10:00:18 enea usb-storage: (Unknown Key): (unknown ASC/ASCQ)
Jul 28 10:00:18 enea usb-storage: scsi cmd done, result=0x2
Jul 28 10:00:18 enea sd 2:0:0:0: [sdb] Sense Key : 0x0 [current] 
Jul 28 10:00:18 enea sd 2:0:0:0: [sdb] ASC=0x0 ASCQ=0x0
Jul 28 10:00:18 enea usb-storage: queuecommand called
Jul 28 10:00:18 enea usb-storage: *** thread sleeping.
Jul 28 10:00:18 enea usb-storage: *** thread awakened.
Jul 28 10:00:18 enea usb-storage: Command READ_10 (10 bytes)
Jul 28 10:00:18 enea usb-storage:  28 00 00 3c 94 00 00 00 01 00
Jul 28 10:00:18 enea usb-storage: Bulk Command S 0x43425355 T 0x2e L 512 F 128 Trg 0 LUN 0 CL 10
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 31/31
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk command transfer result=0
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_sglist: xfer 512 bytes, 1 entries
Jul 28 10:00:18 enea usb-storage: Status code -32; transferred 0/512
Jul 28 10:00:18 enea usb-storage: clearing endpoint halt for pipe 0xc0008380
Jul 28 10:00:18 enea usb-storage: usb_stor_control_msg: rq=01 rqtype=02 value=0000 index=81 len=0
Jul 28 10:00:18 enea usb-storage: usb_stor_clear_halt: result = 0
Jul 28 10:00:18 enea usb-storage: Bulk data transfer result 0x2
Jul 28 10:00:18 enea usb-storage: Attempting to get CSW...
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 13/13
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk status result = 0
Jul 28 10:00:18 enea usb-storage: Bulk Status S 0x53425355 T 0x2e R 512 Stat 0x1
Jul 28 10:00:18 enea usb-storage: -- transport indicates command failure
Jul 28 10:00:18 enea usb-storage: -- unexpectedly short transfer
Jul 28 10:00:18 enea usb-storage: Issuing auto-REQUEST_SENSE
Jul 28 10:00:18 enea usb-storage: Bulk Command S 0x43425355 T 0x2f L 18 F 128 Trg 0 LUN 0 CL 6
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 31/31
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk command transfer result=0
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 18/18
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk data transfer result 0x0
Jul 28 10:00:18 enea usb-storage: Attempting to get CSW...
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 13/13
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk status result = 0
Jul 28 10:00:18 enea usb-storage: Bulk Status S 0x53425355 T 0x2f R 0 Stat 0x0
Jul 28 10:00:18 enea usb-storage: -- Result from auto-sense is 0
Jul 28 10:00:18 enea usb-storage: -- code: 0x70, key: 0x0, ASC: 0x0, ASCQ: 0x0
Jul 28 10:00:18 enea usb-storage: (Unknown Key): (unknown ASC/ASCQ)
Jul 28 10:00:18 enea usb-storage: scsi cmd done, result=0x2
Jul 28 10:00:18 enea sd 2:0:0:0: [sdb] Sense Key : 0x0 [current] 
Jul 28 10:00:18 enea sd 2:0:0:0: [sdb] ASC=0x0 ASCQ=0x0
Jul 28 10:00:18 enea usb-storage: queuecommand called
Jul 28 10:00:18 enea usb-storage: *** thread sleeping.
Jul 28 10:00:18 enea usb-storage: *** thread awakened.
Jul 28 10:00:18 enea usb-storage: Command READ_10 (10 bytes)
Jul 28 10:00:18 enea usb-storage:  28 00 00 3c 94 00 00 00 01 00
Jul 28 10:00:18 enea usb-storage: Bulk Command S 0x43425355 T 0x30 L 512 F 128 Trg 0 LUN 0 CL 10
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 31/31
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk command transfer result=0
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_sglist: xfer 512 bytes, 1 entries
Jul 28 10:00:18 enea usb-storage: Status code -32; transferred 0/512
Jul 28 10:00:18 enea usb-storage: clearing endpoint halt for pipe 0xc0008380
Jul 28 10:00:18 enea usb-storage: usb_stor_control_msg: rq=01 rqtype=02 value=0000 index=81 len=0
Jul 28 10:00:18 enea usb-storage: usb_stor_clear_halt: result = 0
Jul 28 10:00:18 enea usb-storage: Bulk data transfer result 0x2
Jul 28 10:00:18 enea usb-storage: Attempting to get CSW...
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 13/13
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk status result = 0
Jul 28 10:00:18 enea usb-storage: Bulk Status S 0x53425355 T 0x30 R 512 Stat 0x1
Jul 28 10:00:18 enea usb-storage: -- transport indicates command failure
Jul 28 10:00:18 enea usb-storage: -- unexpectedly short transfer
Jul 28 10:00:18 enea usb-storage: Issuing auto-REQUEST_SENSE
Jul 28 10:00:18 enea usb-storage: Bulk Command S 0x43425355 T 0x31 L 18 F 128 Trg 0 LUN 0 CL 6
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 31/31
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk command transfer result=0
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 18/18
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk data transfer result 0x0
Jul 28 10:00:18 enea usb-storage: Attempting to get CSW...
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 13/13
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk status result = 0
Jul 28 10:00:18 enea usb-storage: Bulk Status S 0x53425355 T 0x31 R 0 Stat 0x0
Jul 28 10:00:18 enea usb-storage: -- Result from auto-sense is 0
Jul 28 10:00:18 enea usb-storage: -- code: 0x70, key: 0x0, ASC: 0x0, ASCQ: 0x0
Jul 28 10:00:18 enea usb-storage: (Unknown Key): (unknown ASC/ASCQ)
Jul 28 10:00:18 enea usb-storage: scsi cmd done, result=0x2
Jul 28 10:00:18 enea sd 2:0:0:0: [sdb] Sense Key : 0x0 [current] 
Jul 28 10:00:18 enea sd 2:0:0:0: [sdb] ASC=0x0 ASCQ=0x0
Jul 28 10:00:18 enea usb-storage: queuecommand called
Jul 28 10:00:18 enea usb-storage: *** thread sleeping.
Jul 28 10:00:18 enea usb-storage: *** thread awakened.
Jul 28 10:00:18 enea usb-storage: Command READ_10 (10 bytes)
Jul 28 10:00:18 enea usb-storage:  28 00 00 3c 94 00 00 00 01 00
Jul 28 10:00:18 enea usb-storage: Bulk Command S 0x43425355 T 0x32 L 512 F 128 Trg 0 LUN 0 CL 10
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 31/31
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk command transfer result=0
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_sglist: xfer 512 bytes, 1 entries
Jul 28 10:00:18 enea usb-storage: Status code -32; transferred 0/512
Jul 28 10:00:18 enea usb-storage: clearing endpoint halt for pipe 0xc0008380
Jul 28 10:00:18 enea usb-storage: usb_stor_control_msg: rq=01 rqtype=02 value=0000 index=81 len=0
Jul 28 10:00:18 enea usb-storage: usb_stor_clear_halt: result = 0
Jul 28 10:00:18 enea usb-storage: Bulk data transfer result 0x2
Jul 28 10:00:18 enea usb-storage: Attempting to get CSW...
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 13/13
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk status result = 0
Jul 28 10:00:18 enea usb-storage: Bulk Status S 0x53425355 T 0x32 R 512 Stat 0x1
Jul 28 10:00:18 enea usb-storage: -- transport indicates command failure
Jul 28 10:00:18 enea usb-storage: -- unexpectedly short transfer
Jul 28 10:00:18 enea usb-storage: Issuing auto-REQUEST_SENSE
Jul 28 10:00:18 enea usb-storage: Bulk Command S 0x43425355 T 0x33 L 18 F 128 Trg 0 LUN 0 CL 6
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 31/31
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk command transfer result=0
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 18/18
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk data transfer result 0x0
Jul 28 10:00:18 enea usb-storage: Attempting to get CSW...
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 13/13
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk status result = 0
Jul 28 10:00:18 enea usb-storage: Bulk Status S 0x53425355 T 0x33 R 0 Stat 0x0
Jul 28 10:00:18 enea usb-storage: -- Result from auto-sense is 0
Jul 28 10:00:18 enea usb-storage: -- code: 0x70, key: 0x0, ASC: 0x0, ASCQ: 0x0
Jul 28 10:00:18 enea usb-storage: (Unknown Key): (unknown ASC/ASCQ)
Jul 28 10:00:18 enea usb-storage: scsi cmd done, result=0x2
Jul 28 10:00:18 enea sd 2:0:0:0: [sdb] Sense Key : 0x0 [current] 
Jul 28 10:00:18 enea sd 2:0:0:0: [sdb] ASC=0x0 ASCQ=0x0
Jul 28 10:00:18 enea usb-storage: queuecommand called
Jul 28 10:00:18 enea usb-storage: *** thread sleeping.
Jul 28 10:00:18 enea usb-storage: *** thread awakened.
Jul 28 10:00:18 enea usb-storage: Command READ_10 (10 bytes)
Jul 28 10:00:18 enea usb-storage:  28 00 00 3c 94 00 00 00 01 00
Jul 28 10:00:18 enea usb-storage: Bulk Command S 0x43425355 T 0x34 L 512 F 128 Trg 0 LUN 0 CL 10
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 31/31
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk command transfer result=0
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_sglist: xfer 512 bytes, 1 entries
Jul 28 10:00:18 enea usb-storage: Status code -32; transferred 0/512
Jul 28 10:00:18 enea usb-storage: clearing endpoint halt for pipe 0xc0008380
Jul 28 10:00:18 enea usb-storage: usb_stor_control_msg: rq=01 rqtype=02 value=0000 index=81 len=0
Jul 28 10:00:18 enea usb-storage: usb_stor_clear_halt: result = 0
Jul 28 10:00:18 enea usb-storage: Bulk data transfer result 0x2
Jul 28 10:00:18 enea usb-storage: Attempting to get CSW...
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 13/13
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk status result = 0
Jul 28 10:00:18 enea usb-storage: Bulk Status S 0x53425355 T 0x34 R 512 Stat 0x1
Jul 28 10:00:18 enea usb-storage: -- transport indicates command failure
Jul 28 10:00:18 enea usb-storage: -- unexpectedly short transfer
Jul 28 10:00:18 enea usb-storage: Issuing auto-REQUEST_SENSE
Jul 28 10:00:18 enea usb-storage: Bulk Command S 0x43425355 T 0x35 L 18 F 128 Trg 0 LUN 0 CL 6
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 31/31
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk command transfer result=0
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 18/18
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk data transfer result 0x0
Jul 28 10:00:18 enea usb-storage: Attempting to get CSW...
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 13/13
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk status result = 0
Jul 28 10:00:18 enea usb-storage: Bulk Status S 0x53425355 T 0x35 R 0 Stat 0x0
Jul 28 10:00:18 enea usb-storage: -- Result from auto-sense is 0
Jul 28 10:00:18 enea usb-storage: -- code: 0x70, key: 0x0, ASC: 0x0, ASCQ: 0x0
Jul 28 10:00:18 enea usb-storage: (Unknown Key): (unknown ASC/ASCQ)
Jul 28 10:00:18 enea usb-storage: scsi cmd done, result=0x2
Jul 28 10:00:18 enea sd 2:0:0:0: [sdb] Sense Key : 0x0 [current] 
Jul 28 10:00:18 enea sd 2:0:0:0: [sdb] ASC=0x0 ASCQ=0x0
Jul 28 10:00:18 enea usb-storage: queuecommand called
Jul 28 10:00:18 enea usb-storage: *** thread sleeping.
Jul 28 10:00:18 enea usb-storage: *** thread awakened.
Jul 28 10:00:18 enea usb-storage: Command READ_10 (10 bytes)
Jul 28 10:00:18 enea usb-storage:  28 00 00 3c 94 00 00 00 01 00
Jul 28 10:00:18 enea usb-storage: Bulk Command S 0x43425355 T 0x36 L 512 F 128 Trg 0 LUN 0 CL 10
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 31/31
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk command transfer result=0
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_sglist: xfer 512 bytes, 1 entries
Jul 28 10:00:18 enea usb-storage: Status code -32; transferred 0/512
Jul 28 10:00:18 enea usb-storage: clearing endpoint halt for pipe 0xc0008380
Jul 28 10:00:18 enea usb-storage: usb_stor_control_msg: rq=01 rqtype=02 value=0000 index=81 len=0
Jul 28 10:00:18 enea usb-storage: usb_stor_clear_halt: result = 0
Jul 28 10:00:18 enea usb-storage: Bulk data transfer result 0x2
Jul 28 10:00:18 enea usb-storage: Attempting to get CSW...
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 13/13
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk status result = 0
Jul 28 10:00:18 enea usb-storage: Bulk Status S 0x53425355 T 0x36 R 512 Stat 0x1
Jul 28 10:00:18 enea usb-storage: -- transport indicates command failure
Jul 28 10:00:18 enea usb-storage: -- unexpectedly short transfer
Jul 28 10:00:18 enea usb-storage: Issuing auto-REQUEST_SENSE
Jul 28 10:00:18 enea usb-storage: Bulk Command S 0x43425355 T 0x37 L 18 F 128 Trg 0 LUN 0 CL 6
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 31/31
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk command transfer result=0
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 18/18
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk data transfer result 0x0
Jul 28 10:00:18 enea usb-storage: Attempting to get CSW...
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 13/13
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk status result = 0
Jul 28 10:00:18 enea usb-storage: Bulk Status S 0x53425355 T 0x37 R 0 Stat 0x0
Jul 28 10:00:18 enea usb-storage: -- Result from auto-sense is 0
Jul 28 10:00:18 enea usb-storage: -- code: 0x70, key: 0x0, ASC: 0x0, ASCQ: 0x0
Jul 28 10:00:18 enea usb-storage: (Unknown Key): (unknown ASC/ASCQ)
Jul 28 10:00:18 enea usb-storage: scsi cmd done, result=0x2
Jul 28 10:00:18 enea sd 2:0:0:0: [sdb] Sense Key : 0x0 [current] 
Jul 28 10:00:18 enea sd 2:0:0:0: [sdb] ASC=0x0 ASCQ=0x0
Jul 28 10:00:18 enea usb-storage: queuecommand called
Jul 28 10:00:18 enea usb-storage: *** thread sleeping.
Jul 28 10:00:18 enea usb-storage: *** thread awakened.
Jul 28 10:00:18 enea usb-storage: Command READ_10 (10 bytes)
Jul 28 10:00:18 enea usb-storage:  28 00 00 3c 94 00 00 00 01 00
Jul 28 10:00:18 enea usb-storage: Bulk Command S 0x43425355 T 0x38 L 512 F 128 Trg 0 LUN 0 CL 10
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 31/31
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk command transfer result=0
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_sglist: xfer 512 bytes, 1 entries
Jul 28 10:00:18 enea usb-storage: Status code -32; transferred 0/512
Jul 28 10:00:18 enea usb-storage: clearing endpoint halt for pipe 0xc0008380
Jul 28 10:00:18 enea usb-storage: usb_stor_control_msg: rq=01 rqtype=02 value=0000 index=81 len=0
Jul 28 10:00:18 enea usb-storage: usb_stor_clear_halt: result = 0
Jul 28 10:00:18 enea usb-storage: Bulk data transfer result 0x2
Jul 28 10:00:18 enea usb-storage: Attempting to get CSW...
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 13/13
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk status result = 0
Jul 28 10:00:18 enea usb-storage: Bulk Status S 0x53425355 T 0x38 R 512 Stat 0x1
Jul 28 10:00:18 enea usb-storage: -- transport indicates command failure
Jul 28 10:00:18 enea usb-storage: -- unexpectedly short transfer
Jul 28 10:00:18 enea usb-storage: Issuing auto-REQUEST_SENSE
Jul 28 10:00:18 enea usb-storage: Bulk Command S 0x43425355 T 0x39 L 18 F 128 Trg 0 LUN 0 CL 6
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 31/31
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk command transfer result=0
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 18/18
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk data transfer result 0x0
Jul 28 10:00:18 enea usb-storage: Attempting to get CSW...
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 13/13
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk status result = 0
Jul 28 10:00:18 enea usb-storage: Bulk Status S 0x53425355 T 0x39 R 0 Stat 0x0
Jul 28 10:00:18 enea usb-storage: -- Result from auto-sense is 0
Jul 28 10:00:18 enea usb-storage: -- code: 0x70, key: 0x0, ASC: 0x0, ASCQ: 0x0
Jul 28 10:00:18 enea usb-storage: (Unknown Key): (unknown ASC/ASCQ)
Jul 28 10:00:18 enea usb-storage: scsi cmd done, result=0x2
Jul 28 10:00:18 enea sd 2:0:0:0: [sdb] Sense Key : 0x0 [current] 
Jul 28 10:00:18 enea sd 2:0:0:0: [sdb] ASC=0x0 ASCQ=0x0
Jul 28 10:00:18 enea usb-storage: queuecommand called
Jul 28 10:00:18 enea usb-storage: *** thread sleeping.
Jul 28 10:00:18 enea usb-storage: *** thread awakened.
Jul 28 10:00:18 enea usb-storage: Command READ_10 (10 bytes)
Jul 28 10:00:18 enea usb-storage:  28 00 00 3c 94 00 00 00 01 00
Jul 28 10:00:18 enea usb-storage: Bulk Command S 0x43425355 T 0x3a L 512 F 128 Trg 0 LUN 0 CL 10
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 31/31
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk command transfer result=0
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_sglist: xfer 512 bytes, 1 entries
Jul 28 10:00:18 enea usb-storage: Status code -32; transferred 0/512
Jul 28 10:00:18 enea usb-storage: clearing endpoint halt for pipe 0xc0008380
Jul 28 10:00:18 enea usb-storage: usb_stor_control_msg: rq=01 rqtype=02 value=0000 index=81 len=0
Jul 28 10:00:18 enea usb-storage: usb_stor_clear_halt: result = 0
Jul 28 10:00:18 enea usb-storage: Bulk data transfer result 0x2
Jul 28 10:00:18 enea usb-storage: Attempting to get CSW...
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 13/13
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk status result = 0
Jul 28 10:00:18 enea usb-storage: Bulk Status S 0x53425355 T 0x3a R 512 Stat 0x1
Jul 28 10:00:18 enea usb-storage: -- transport indicates command failure
Jul 28 10:00:18 enea usb-storage: -- unexpectedly short transfer
Jul 28 10:00:18 enea usb-storage: Issuing auto-REQUEST_SENSE
Jul 28 10:00:18 enea usb-storage: Bulk Command S 0x43425355 T 0x3b L 18 F 128 Trg 0 LUN 0 CL 6
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 31/31
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk command transfer result=0
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 18/18
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk data transfer result 0x0
Jul 28 10:00:18 enea usb-storage: Attempting to get CSW...
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 13/13
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk status result = 0
Jul 28 10:00:18 enea usb-storage: Bulk Status S 0x53425355 T 0x3b R 0 Stat 0x0
Jul 28 10:00:18 enea usb-storage: -- Result from auto-sense is 0
Jul 28 10:00:18 enea usb-storage: -- code: 0x70, key: 0x0, ASC: 0x0, ASCQ: 0x0
Jul 28 10:00:18 enea usb-storage: (Unknown Key): (unknown ASC/ASCQ)
Jul 28 10:00:18 enea usb-storage: scsi cmd done, result=0x2
Jul 28 10:00:18 enea sd 2:0:0:0: [sdb] Sense Key : 0x0 [current] 
Jul 28 10:00:18 enea sd 2:0:0:0: [sdb] ASC=0x0 ASCQ=0x0
Jul 28 10:00:18 enea usb-storage: queuecommand called
Jul 28 10:00:18 enea usb-storage: *** thread sleeping.
Jul 28 10:00:18 enea usb-storage: *** thread awakened.
Jul 28 10:00:18 enea usb-storage: Command READ_10 (10 bytes)
Jul 28 10:00:18 enea usb-storage:  28 00 00 3c 94 00 00 00 01 00
Jul 28 10:00:18 enea usb-storage: Bulk Command S 0x43425355 T 0x3c L 512 F 128 Trg 0 LUN 0 CL 10
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 31/31
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk command transfer result=0
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_sglist: xfer 512 bytes, 1 entries
Jul 28 10:00:18 enea usb-storage: Status code -32; transferred 0/512
Jul 28 10:00:18 enea usb-storage: clearing endpoint halt for pipe 0xc0008380
Jul 28 10:00:18 enea usb-storage: usb_stor_control_msg: rq=01 rqtype=02 value=0000 index=81 len=0
Jul 28 10:00:18 enea usb-storage: usb_stor_clear_halt: result = 0
Jul 28 10:00:18 enea usb-storage: Bulk data transfer result 0x2
Jul 28 10:00:18 enea usb-storage: Attempting to get CSW...
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 13/13
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk status result = 0
Jul 28 10:00:18 enea usb-storage: Bulk Status S 0x53425355 T 0x3c R 512 Stat 0x1
Jul 28 10:00:18 enea usb-storage: -- transport indicates command failure
Jul 28 10:00:18 enea usb-storage: -- unexpectedly short transfer
Jul 28 10:00:18 enea usb-storage: Issuing auto-REQUEST_SENSE
Jul 28 10:00:18 enea usb-storage: Bulk Command S 0x43425355 T 0x3d L 18 F 128 Trg 0 LUN 0 CL 6
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 31/31
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk command transfer result=0
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 18/18
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk data transfer result 0x0
Jul 28 10:00:18 enea usb-storage: Attempting to get CSW...
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 13/13
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk status result = 0
Jul 28 10:00:18 enea usb-storage: Bulk Status S 0x53425355 T 0x3d R 0 Stat 0x0
Jul 28 10:00:18 enea usb-storage: -- Result from auto-sense is 0
Jul 28 10:00:18 enea usb-storage: -- code: 0x70, key: 0x0, ASC: 0x0, ASCQ: 0x0
Jul 28 10:00:18 enea usb-storage: (Unknown Key): (unknown ASC/ASCQ)
Jul 28 10:00:18 enea usb-storage: scsi cmd done, result=0x2
Jul 28 10:00:18 enea sd 2:0:0:0: [sdb] Sense Key : 0x0 [current] 
Jul 28 10:00:18 enea sd 2:0:0:0: [sdb] ASC=0x0 ASCQ=0x0
Jul 28 10:00:18 enea usb-storage: queuecommand called
Jul 28 10:00:18 enea usb-storage: *** thread sleeping.
Jul 28 10:00:18 enea usb-storage: *** thread awakened.
Jul 28 10:00:18 enea usb-storage: Command READ_10 (10 bytes)
Jul 28 10:00:18 enea usb-storage:  28 00 00 3c 94 00 00 00 01 00
Jul 28 10:00:18 enea usb-storage: Bulk Command S 0x43425355 T 0x3e L 512 F 128 Trg 0 LUN 0 CL 10
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 31/31
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk command transfer result=0
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_sglist: xfer 512 bytes, 1 entries
Jul 28 10:00:18 enea usb-storage: Status code -32; transferred 0/512
Jul 28 10:00:18 enea usb-storage: clearing endpoint halt for pipe 0xc0008380
Jul 28 10:00:18 enea usb-storage: usb_stor_control_msg: rq=01 rqtype=02 value=0000 index=81 len=0
Jul 28 10:00:18 enea usb-storage: usb_stor_clear_halt: result = 0
Jul 28 10:00:18 enea usb-storage: Bulk data transfer result 0x2
Jul 28 10:00:18 enea usb-storage: Attempting to get CSW...
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 13/13
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk status result = 0
Jul 28 10:00:18 enea usb-storage: Bulk Status S 0x53425355 T 0x3e R 512 Stat 0x1
Jul 28 10:00:18 enea usb-storage: -- transport indicates command failure
Jul 28 10:00:18 enea usb-storage: -- unexpectedly short transfer
Jul 28 10:00:18 enea usb-storage: Issuing auto-REQUEST_SENSE
Jul 28 10:00:18 enea usb-storage: Bulk Command S 0x43425355 T 0x3f L 18 F 128 Trg 0 LUN 0 CL 6
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 31/31
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk command transfer result=0
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 18/18
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk data transfer result 0x0
Jul 28 10:00:18 enea usb-storage: Attempting to get CSW...
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 13/13
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk status result = 0
Jul 28 10:00:18 enea usb-storage: Bulk Status S 0x53425355 T 0x3f R 0 Stat 0x0
Jul 28 10:00:18 enea usb-storage: -- Result from auto-sense is 0
Jul 28 10:00:18 enea usb-storage: -- code: 0x70, key: 0x0, ASC: 0x0, ASCQ: 0x0
Jul 28 10:00:18 enea usb-storage: (Unknown Key): (unknown ASC/ASCQ)
Jul 28 10:00:18 enea usb-storage: scsi cmd done, result=0x2
Jul 28 10:00:18 enea sd 2:0:0:0: [sdb] Sense Key : 0x0 [current] 
Jul 28 10:00:18 enea sd 2:0:0:0: [sdb] ASC=0x0 ASCQ=0x0
Jul 28 10:00:18 enea usb-storage: queuecommand called
Jul 28 10:00:18 enea usb-storage: *** thread sleeping.
Jul 28 10:00:18 enea usb-storage: *** thread awakened.
Jul 28 10:00:18 enea usb-storage: Command READ_10 (10 bytes)
Jul 28 10:00:18 enea usb-storage:  28 00 00 3c 94 00 00 00 01 00
Jul 28 10:00:18 enea usb-storage: Bulk Command S 0x43425355 T 0x40 L 512 F 128 Trg 0 LUN 0 CL 10
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 31/31
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk command transfer result=0
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_sglist: xfer 512 bytes, 1 entries
Jul 28 10:00:18 enea usb-storage: Status code -32; transferred 0/512
Jul 28 10:00:18 enea usb-storage: clearing endpoint halt for pipe 0xc0008380
Jul 28 10:00:18 enea usb-storage: usb_stor_control_msg: rq=01 rqtype=02 value=0000 index=81 len=0
Jul 28 10:00:18 enea usb-storage: usb_stor_clear_halt: result = 0
Jul 28 10:00:18 enea usb-storage: Bulk data transfer result 0x2
Jul 28 10:00:18 enea usb-storage: Attempting to get CSW...
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 13/13
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk status result = 0
Jul 28 10:00:18 enea usb-storage: Bulk Status S 0x53425355 T 0x40 R 512 Stat 0x1
Jul 28 10:00:18 enea usb-storage: -- transport indicates command failure
Jul 28 10:00:18 enea usb-storage: -- unexpectedly short transfer
Jul 28 10:00:18 enea usb-storage: Issuing auto-REQUEST_SENSE
Jul 28 10:00:18 enea usb-storage: Bulk Command S 0x43425355 T 0x41 L 18 F 128 Trg 0 LUN 0 CL 6
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 31/31
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk command transfer result=0
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 18/18
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk data transfer result 0x0
Jul 28 10:00:18 enea usb-storage: Attempting to get CSW...
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 13/13
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk status result = 0
Jul 28 10:00:18 enea usb-storage: Bulk Status S 0x53425355 T 0x41 R 0 Stat 0x0
Jul 28 10:00:18 enea usb-storage: -- Result from auto-sense is 0
Jul 28 10:00:18 enea usb-storage: -- code: 0x70, key: 0x0, ASC: 0x0, ASCQ: 0x0
Jul 28 10:00:18 enea usb-storage: (Unknown Key): (unknown ASC/ASCQ)
Jul 28 10:00:18 enea usb-storage: scsi cmd done, result=0x2
Jul 28 10:00:18 enea sd 2:0:0:0: [sdb] Sense Key : 0x0 [current] 
Jul 28 10:00:18 enea sd 2:0:0:0: [sdb] ASC=0x0 ASCQ=0x0
Jul 28 10:00:18 enea usb-storage: queuecommand called
Jul 28 10:00:18 enea usb-storage: *** thread sleeping.
Jul 28 10:00:18 enea usb-storage: *** thread awakened.
Jul 28 10:00:18 enea usb-storage: Command READ_10 (10 bytes)
Jul 28 10:00:18 enea usb-storage:  28 00 00 3c 94 00 00 00 01 00
Jul 28 10:00:18 enea usb-storage: Bulk Command S 0x43425355 T 0x42 L 512 F 128 Trg 0 LUN 0 CL 10
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 31/31
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk command transfer result=0
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_sglist: xfer 512 bytes, 1 entries
Jul 28 10:00:18 enea usb-storage: Status code -32; transferred 0/512
Jul 28 10:00:18 enea usb-storage: clearing endpoint halt for pipe 0xc0008380
Jul 28 10:00:18 enea usb-storage: usb_stor_control_msg: rq=01 rqtype=02 value=0000 index=81 len=0
Jul 28 10:00:18 enea usb-storage: usb_stor_clear_halt: result = 0
Jul 28 10:00:18 enea usb-storage: Bulk data transfer result 0x2
Jul 28 10:00:18 enea usb-storage: Attempting to get CSW...
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 13/13
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk status result = 0
Jul 28 10:00:18 enea usb-storage: Bulk Status S 0x53425355 T 0x42 R 512 Stat 0x1
Jul 28 10:00:18 enea usb-storage: -- transport indicates command failure
Jul 28 10:00:18 enea usb-storage: -- unexpectedly short transfer
Jul 28 10:00:18 enea usb-storage: Issuing auto-REQUEST_SENSE
Jul 28 10:00:18 enea usb-storage: Bulk Command S 0x43425355 T 0x43 L 18 F 128 Trg 0 LUN 0 CL 6
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 31/31
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk command transfer result=0
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 18/18
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk data transfer result 0x0
Jul 28 10:00:18 enea usb-storage: Attempting to get CSW...
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 13/13
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk status result = 0
Jul 28 10:00:18 enea usb-storage: Bulk Status S 0x53425355 T 0x43 R 0 Stat 0x0
Jul 28 10:00:18 enea usb-storage: -- Result from auto-sense is 0
Jul 28 10:00:18 enea usb-storage: -- code: 0x70, key: 0x0, ASC: 0x0, ASCQ: 0x0
Jul 28 10:00:18 enea usb-storage: (Unknown Key): (unknown ASC/ASCQ)
Jul 28 10:00:18 enea usb-storage: scsi cmd done, result=0x2
Jul 28 10:00:18 enea sd 2:0:0:0: [sdb] Sense Key : 0x0 [current] 
Jul 28 10:00:18 enea sd 2:0:0:0: [sdb] ASC=0x0 ASCQ=0x0
Jul 28 10:00:18 enea usb-storage: queuecommand called
Jul 28 10:00:18 enea usb-storage: *** thread sleeping.
Jul 28 10:00:18 enea usb-storage: *** thread awakened.
Jul 28 10:00:18 enea usb-storage: Command READ_10 (10 bytes)
Jul 28 10:00:18 enea usb-storage:  28 00 00 3c 94 00 00 00 01 00
Jul 28 10:00:18 enea usb-storage: Bulk Command S 0x43425355 T 0x44 L 512 F 128 Trg 0 LUN 0 CL 10
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 31/31
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk command transfer result=0
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_sglist: xfer 512 bytes, 1 entries
Jul 28 10:00:18 enea usb-storage: Status code -32; transferred 0/512
Jul 28 10:00:18 enea usb-storage: clearing endpoint halt for pipe 0xc0008380
Jul 28 10:00:18 enea usb-storage: usb_stor_control_msg: rq=01 rqtype=02 value=0000 index=81 len=0
Jul 28 10:00:18 enea usb-storage: usb_stor_clear_halt: result = 0
Jul 28 10:00:18 enea usb-storage: Bulk data transfer result 0x2
Jul 28 10:00:18 enea usb-storage: Attempting to get CSW...
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 13/13
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk status result = 0
Jul 28 10:00:18 enea usb-storage: Bulk Status S 0x53425355 T 0x44 R 512 Stat 0x1
Jul 28 10:00:18 enea usb-storage: -- transport indicates command failure
Jul 28 10:00:18 enea usb-storage: -- unexpectedly short transfer
Jul 28 10:00:18 enea usb-storage: Issuing auto-REQUEST_SENSE
Jul 28 10:00:18 enea usb-storage: Bulk Command S 0x43425355 T 0x45 L 18 F 128 Trg 0 LUN 0 CL 6
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 31/31
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk command transfer result=0
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 18/18
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk data transfer result 0x0
Jul 28 10:00:18 enea usb-storage: Attempting to get CSW...
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 13/13
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk status result = 0
Jul 28 10:00:18 enea usb-storage: Bulk Status S 0x53425355 T 0x45 R 0 Stat 0x0
Jul 28 10:00:18 enea usb-storage: -- Result from auto-sense is 0
Jul 28 10:00:18 enea usb-storage: -- code: 0x70, key: 0x0, ASC: 0x0, ASCQ: 0x0
Jul 28 10:00:18 enea usb-storage: (Unknown Key): (unknown ASC/ASCQ)
Jul 28 10:00:18 enea usb-storage: scsi cmd done, result=0x2
Jul 28 10:00:18 enea sd 2:0:0:0: [sdb] Sense Key : 0x0 [current] 
Jul 28 10:00:18 enea sd 2:0:0:0: [sdb] ASC=0x0 ASCQ=0x0
Jul 28 10:00:18 enea usb-storage: queuecommand called
Jul 28 10:00:18 enea usb-storage: *** thread sleeping.
Jul 28 10:00:18 enea usb-storage: *** thread awakened.
Jul 28 10:00:18 enea usb-storage: Command READ_10 (10 bytes)
Jul 28 10:00:18 enea usb-storage:  28 00 00 3c 94 00 00 00 01 00
Jul 28 10:00:18 enea usb-storage: Bulk Command S 0x43425355 T 0x46 L 512 F 128 Trg 0 LUN 0 CL 10
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 31/31
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk command transfer result=0
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_sglist: xfer 512 bytes, 1 entries
Jul 28 10:00:18 enea usb-storage: Status code -32; transferred 0/512
Jul 28 10:00:18 enea usb-storage: clearing endpoint halt for pipe 0xc0008380
Jul 28 10:00:18 enea usb-storage: usb_stor_control_msg: rq=01 rqtype=02 value=0000 index=81 len=0
Jul 28 10:00:18 enea usb-storage: usb_stor_clear_halt: result = 0
Jul 28 10:00:18 enea usb-storage: Bulk data transfer result 0x2
Jul 28 10:00:18 enea usb-storage: Attempting to get CSW...
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 13/13
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk status result = 0
Jul 28 10:00:18 enea usb-storage: Bulk Status S 0x53425355 T 0x46 R 512 Stat 0x1
Jul 28 10:00:18 enea usb-storage: -- transport indicates command failure
Jul 28 10:00:18 enea usb-storage: -- unexpectedly short transfer
Jul 28 10:00:18 enea usb-storage: Issuing auto-REQUEST_SENSE
Jul 28 10:00:18 enea usb-storage: Bulk Command S 0x43425355 T 0x47 L 18 F 128 Trg 0 LUN 0 CL 6
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 31/31
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk command transfer result=0
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 18/18
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk data transfer result 0x0
Jul 28 10:00:18 enea usb-storage: Attempting to get CSW...
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 13/13
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk status result = 0
Jul 28 10:00:18 enea usb-storage: Bulk Status S 0x53425355 T 0x47 R 0 Stat 0x0
Jul 28 10:00:18 enea usb-storage: -- Result from auto-sense is 0
Jul 28 10:00:18 enea usb-storage: -- code: 0x70, key: 0x0, ASC: 0x0, ASCQ: 0x0
Jul 28 10:00:18 enea usb-storage: (Unknown Key): (unknown ASC/ASCQ)
Jul 28 10:00:18 enea usb-storage: scsi cmd done, result=0x2
Jul 28 10:00:18 enea sd 2:0:0:0: [sdb] Sense Key : 0x0 [current] 
Jul 28 10:00:18 enea sd 2:0:0:0: [sdb] ASC=0x0 ASCQ=0x0
Jul 28 10:00:18 enea usb-storage: queuecommand called
Jul 28 10:00:18 enea usb-storage: *** thread sleeping.
Jul 28 10:00:18 enea usb-storage: *** thread awakened.
Jul 28 10:00:18 enea usb-storage: Command READ_10 (10 bytes)
Jul 28 10:00:18 enea usb-storage:  28 00 00 3c 94 00 00 00 01 00
Jul 28 10:00:18 enea usb-storage: Bulk Command S 0x43425355 T 0x48 L 512 F 128 Trg 0 LUN 0 CL 10
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 31/31
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk command transfer result=0
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_sglist: xfer 512 bytes, 1 entries
Jul 28 10:00:18 enea usb-storage: Status code -32; transferred 0/512
Jul 28 10:00:18 enea usb-storage: clearing endpoint halt for pipe 0xc0008380
Jul 28 10:00:18 enea usb-storage: usb_stor_control_msg: rq=01 rqtype=02 value=0000 index=81 len=0
Jul 28 10:00:18 enea usb-storage: usb_stor_clear_halt: result = 0
Jul 28 10:00:18 enea usb-storage: Bulk data transfer result 0x2
Jul 28 10:00:18 enea usb-storage: Attempting to get CSW...
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 13/13
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk status result = 0
Jul 28 10:00:18 enea usb-storage: Bulk Status S 0x53425355 T 0x48 R 512 Stat 0x1
Jul 28 10:00:18 enea usb-storage: -- transport indicates command failure
Jul 28 10:00:18 enea usb-storage: -- unexpectedly short transfer
Jul 28 10:00:18 enea usb-storage: Issuing auto-REQUEST_SENSE
Jul 28 10:00:18 enea usb-storage: Bulk Command S 0x43425355 T 0x49 L 18 F 128 Trg 0 LUN 0 CL 6
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 31/31
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk command transfer result=0
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 18/18
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk data transfer result 0x0
Jul 28 10:00:18 enea usb-storage: Attempting to get CSW...
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 13/13
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk status result = 0
Jul 28 10:00:18 enea usb-storage: Bulk Status S 0x53425355 T 0x49 R 0 Stat 0x0
Jul 28 10:00:18 enea usb-storage: -- Result from auto-sense is 0
Jul 28 10:00:18 enea usb-storage: -- code: 0x70, key: 0x0, ASC: 0x0, ASCQ: 0x0
Jul 28 10:00:18 enea usb-storage: (Unknown Key): (unknown ASC/ASCQ)
Jul 28 10:00:18 enea usb-storage: scsi cmd done, result=0x2
Jul 28 10:00:18 enea sd 2:0:0:0: [sdb] Sense Key : 0x0 [current] 
Jul 28 10:00:18 enea sd 2:0:0:0: [sdb] ASC=0x0 ASCQ=0x0
Jul 28 10:00:18 enea usb-storage: queuecommand called
Jul 28 10:00:18 enea usb-storage: *** thread sleeping.
Jul 28 10:00:18 enea usb-storage: *** thread awakened.
Jul 28 10:00:18 enea usb-storage: Command READ_10 (10 bytes)
Jul 28 10:00:18 enea usb-storage:  28 00 00 3c 94 00 00 00 01 00
Jul 28 10:00:18 enea usb-storage: Bulk Command S 0x43425355 T 0x4a L 512 F 128 Trg 0 LUN 0 CL 10
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 31/31
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk command transfer result=0
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_sglist: xfer 512 bytes, 1 entries
Jul 28 10:00:18 enea usb-storage: Status code -32; transferred 0/512
Jul 28 10:00:18 enea usb-storage: clearing endpoint halt for pipe 0xc0008380
Jul 28 10:00:18 enea usb-storage: usb_stor_control_msg: rq=01 rqtype=02 value=0000 index=81 len=0
Jul 28 10:00:18 enea usb-storage: usb_stor_clear_halt: result = 0
Jul 28 10:00:18 enea usb-storage: Bulk data transfer result 0x2
Jul 28 10:00:18 enea usb-storage: Attempting to get CSW...
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 13/13
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk status result = 0
Jul 28 10:00:18 enea usb-storage: Bulk Status S 0x53425355 T 0x4a R 512 Stat 0x1
Jul 28 10:00:18 enea usb-storage: -- transport indicates command failure
Jul 28 10:00:18 enea usb-storage: -- unexpectedly short transfer
Jul 28 10:00:18 enea usb-storage: Issuing auto-REQUEST_SENSE
Jul 28 10:00:18 enea usb-storage: Bulk Command S 0x43425355 T 0x4b L 18 F 128 Trg 0 LUN 0 CL 6
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 31/31
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk command transfer result=0
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 18/18
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk data transfer result 0x0
Jul 28 10:00:18 enea usb-storage: Attempting to get CSW...
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 13/13
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk status result = 0
Jul 28 10:00:18 enea usb-storage: Bulk Status S 0x53425355 T 0x4b R 0 Stat 0x0
Jul 28 10:00:18 enea usb-storage: -- Result from auto-sense is 0
Jul 28 10:00:18 enea usb-storage: -- code: 0x70, key: 0x0, ASC: 0x0, ASCQ: 0x0
Jul 28 10:00:18 enea usb-storage: (Unknown Key): (unknown ASC/ASCQ)
Jul 28 10:00:18 enea usb-storage: scsi cmd done, result=0x2
Jul 28 10:00:18 enea sd 2:0:0:0: [sdb] Sense Key : 0x0 [current] 
Jul 28 10:00:18 enea sd 2:0:0:0: [sdb] ASC=0x0 ASCQ=0x0
Jul 28 10:00:18 enea usb-storage: queuecommand called
Jul 28 10:00:18 enea usb-storage: *** thread sleeping.
Jul 28 10:00:18 enea usb-storage: *** thread awakened.
Jul 28 10:00:18 enea usb-storage: Command READ_10 (10 bytes)
Jul 28 10:00:18 enea usb-storage:  28 00 00 3c 94 00 00 00 01 00
Jul 28 10:00:18 enea usb-storage: Bulk Command S 0x43425355 T 0x4c L 512 F 128 Trg 0 LUN 0 CL 10
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 31/31
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk command transfer result=0
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_sglist: xfer 512 bytes, 1 entries
Jul 28 10:00:18 enea usb-storage: Status code -32; transferred 0/512
Jul 28 10:00:18 enea usb-storage: clearing endpoint halt for pipe 0xc0008380
Jul 28 10:00:18 enea usb-storage: usb_stor_control_msg: rq=01 rqtype=02 value=0000 index=81 len=0
Jul 28 10:00:18 enea usb-storage: usb_stor_clear_halt: result = 0
Jul 28 10:00:18 enea usb-storage: Bulk data transfer result 0x2
Jul 28 10:00:18 enea usb-storage: Attempting to get CSW...
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 13/13
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk status result = 0
Jul 28 10:00:18 enea usb-storage: Bulk Status S 0x53425355 T 0x4c R 512 Stat 0x1
Jul 28 10:00:18 enea usb-storage: -- transport indicates command failure
Jul 28 10:00:18 enea usb-storage: -- unexpectedly short transfer
Jul 28 10:00:18 enea usb-storage: Issuing auto-REQUEST_SENSE
Jul 28 10:00:18 enea usb-storage: Bulk Command S 0x43425355 T 0x4d L 18 F 128 Trg 0 LUN 0 CL 6
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 31/31
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk command transfer result=0
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 18/18
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk data transfer result 0x0
Jul 28 10:00:18 enea usb-storage: Attempting to get CSW...
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 13/13
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk status result = 0
Jul 28 10:00:18 enea usb-storage: Bulk Status S 0x53425355 T 0x4d R 0 Stat 0x0
Jul 28 10:00:18 enea usb-storage: -- Result from auto-sense is 0
Jul 28 10:00:18 enea usb-storage: -- code: 0x70, key: 0x0, ASC: 0x0, ASCQ: 0x0
Jul 28 10:00:18 enea usb-storage: (Unknown Key): (unknown ASC/ASCQ)
Jul 28 10:00:18 enea usb-storage: scsi cmd done, result=0x2
Jul 28 10:00:18 enea sd 2:0:0:0: [sdb] Sense Key : 0x0 [current] 
Jul 28 10:00:18 enea sd 2:0:0:0: [sdb] ASC=0x0 ASCQ=0x0
Jul 28 10:00:18 enea usb-storage: queuecommand called
Jul 28 10:00:18 enea usb-storage: *** thread sleeping.
Jul 28 10:00:18 enea usb-storage: *** thread awakened.
Jul 28 10:00:18 enea usb-storage: Command READ_10 (10 bytes)
Jul 28 10:00:18 enea usb-storage:  28 00 00 3c 94 00 00 00 01 00
Jul 28 10:00:18 enea usb-storage: Bulk Command S 0x43425355 T 0x4e L 512 F 128 Trg 0 LUN 0 CL 10
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 31/31
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk command transfer result=0
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_sglist: xfer 512 bytes, 1 entries
Jul 28 10:00:18 enea usb-storage: Status code -32; transferred 0/512
Jul 28 10:00:18 enea usb-storage: clearing endpoint halt for pipe 0xc0008380
Jul 28 10:00:18 enea usb-storage: usb_stor_control_msg: rq=01 rqtype=02 value=0000 index=81 len=0
Jul 28 10:00:18 enea usb-storage: usb_stor_clear_halt: result = 0
Jul 28 10:00:18 enea usb-storage: Bulk data transfer result 0x2
Jul 28 10:00:18 enea usb-storage: Attempting to get CSW...
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 13/13
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk status result = 0
Jul 28 10:00:18 enea usb-storage: Bulk Status S 0x53425355 T 0x4e R 512 Stat 0x1
Jul 28 10:00:18 enea usb-storage: -- transport indicates command failure
Jul 28 10:00:18 enea usb-storage: -- unexpectedly short transfer
Jul 28 10:00:18 enea usb-storage: Issuing auto-REQUEST_SENSE
Jul 28 10:00:18 enea usb-storage: Bulk Command S 0x43425355 T 0x4f L 18 F 128 Trg 0 LUN 0 CL 6
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 31/31
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk command transfer result=0
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 18/18
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk data transfer result 0x0
Jul 28 10:00:18 enea usb-storage: Attempting to get CSW...
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 13/13
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk status result = 0
Jul 28 10:00:18 enea usb-storage: Bulk Status S 0x53425355 T 0x4f R 0 Stat 0x0
Jul 28 10:00:18 enea usb-storage: -- Result from auto-sense is 0
Jul 28 10:00:18 enea usb-storage: -- code: 0x70, key: 0x0, ASC: 0x0, ASCQ: 0x0
Jul 28 10:00:18 enea usb-storage: (Unknown Key): (unknown ASC/ASCQ)
Jul 28 10:00:18 enea usb-storage: scsi cmd done, result=0x2
Jul 28 10:00:18 enea sd 2:0:0:0: [sdb] Sense Key : 0x0 [current] 
Jul 28 10:00:18 enea sd 2:0:0:0: [sdb] ASC=0x0 ASCQ=0x0
Jul 28 10:00:18 enea usb-storage: queuecommand called
Jul 28 10:00:18 enea usb-storage: *** thread sleeping.
Jul 28 10:00:18 enea usb-storage: *** thread awakened.
Jul 28 10:00:18 enea usb-storage: Command READ_10 (10 bytes)
Jul 28 10:00:18 enea usb-storage:  28 00 00 3c 94 00 00 00 01 00
Jul 28 10:00:18 enea usb-storage: Bulk Command S 0x43425355 T 0x50 L 512 F 128 Trg 0 LUN 0 CL 10
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 31/31
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk command transfer result=0
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_sglist: xfer 512 bytes, 1 entries
Jul 28 10:00:18 enea usb-storage: Status code -32; transferred 0/512
Jul 28 10:00:18 enea usb-storage: clearing endpoint halt for pipe 0xc0008380
Jul 28 10:00:18 enea usb-storage: usb_stor_control_msg: rq=01 rqtype=02 value=0000 index=81 len=0
Jul 28 10:00:18 enea usb-storage: usb_stor_clear_halt: result = 0
Jul 28 10:00:18 enea usb-storage: Bulk data transfer result 0x2
Jul 28 10:00:18 enea usb-storage: Attempting to get CSW...
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 13/13
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk status result = 0
Jul 28 10:00:18 enea usb-storage: Bulk Status S 0x53425355 T 0x50 R 512 Stat 0x1
Jul 28 10:00:18 enea usb-storage: -- transport indicates command failure
Jul 28 10:00:18 enea usb-storage: -- unexpectedly short transfer
Jul 28 10:00:18 enea usb-storage: Issuing auto-REQUEST_SENSE
Jul 28 10:00:18 enea usb-storage: Bulk Command S 0x43425355 T 0x51 L 18 F 128 Trg 0 LUN 0 CL 6
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 31/31
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk command transfer result=0
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 18/18
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk data transfer result 0x0
Jul 28 10:00:18 enea usb-storage: Attempting to get CSW...
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 13/13
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk status result = 0
Jul 28 10:00:18 enea usb-storage: Bulk Status S 0x53425355 T 0x51 R 0 Stat 0x0
Jul 28 10:00:18 enea usb-storage: -- Result from auto-sense is 0
Jul 28 10:00:18 enea usb-storage: -- code: 0x70, key: 0x0, ASC: 0x0, ASCQ: 0x0
Jul 28 10:00:18 enea usb-storage: (Unknown Key): (unknown ASC/ASCQ)
Jul 28 10:00:18 enea usb-storage: scsi cmd done, result=0x2
Jul 28 10:00:18 enea sd 2:0:0:0: [sdb] Sense Key : 0x0 [current] 
Jul 28 10:00:18 enea sd 2:0:0:0: [sdb] ASC=0x0 ASCQ=0x0
Jul 28 10:00:18 enea usb-storage: queuecommand called
Jul 28 10:00:18 enea usb-storage: *** thread sleeping.
Jul 28 10:00:18 enea usb-storage: *** thread awakened.
Jul 28 10:00:18 enea usb-storage: Command READ_10 (10 bytes)
Jul 28 10:00:18 enea usb-storage:  28 00 00 3c 94 00 00 00 01 00
Jul 28 10:00:18 enea usb-storage: Bulk Command S 0x43425355 T 0x52 L 512 F 128 Trg 0 LUN 0 CL 10
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 31/31
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk command transfer result=0
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_sglist: xfer 512 bytes, 1 entries
Jul 28 10:00:18 enea usb-storage: Status code -32; transferred 0/512
Jul 28 10:00:18 enea usb-storage: clearing endpoint halt for pipe 0xc0008380
Jul 28 10:00:18 enea usb-storage: usb_stor_control_msg: rq=01 rqtype=02 value=0000 index=81 len=0
Jul 28 10:00:18 enea usb-storage: usb_stor_clear_halt: result = 0
Jul 28 10:00:18 enea usb-storage: Bulk data transfer result 0x2
Jul 28 10:00:18 enea usb-storage: Attempting to get CSW...
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 13/13
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk status result = 0
Jul 28 10:00:18 enea usb-storage: Bulk Status S 0x53425355 T 0x52 R 512 Stat 0x1
Jul 28 10:00:18 enea usb-storage: -- transport indicates command failure
Jul 28 10:00:18 enea usb-storage: -- unexpectedly short transfer
Jul 28 10:00:18 enea usb-storage: Issuing auto-REQUEST_SENSE
Jul 28 10:00:18 enea usb-storage: Bulk Command S 0x43425355 T 0x53 L 18 F 128 Trg 0 LUN 0 CL 6
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 31/31
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk command transfer result=0
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 18/18
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk data transfer result 0x0
Jul 28 10:00:18 enea usb-storage: Attempting to get CSW...
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 13/13
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk status result = 0
Jul 28 10:00:18 enea usb-storage: Bulk Status S 0x53425355 T 0x53 R 0 Stat 0x0
Jul 28 10:00:18 enea usb-storage: -- Result from auto-sense is 0
Jul 28 10:00:18 enea usb-storage: -- code: 0x70, key: 0x0, ASC: 0x0, ASCQ: 0x0
Jul 28 10:00:18 enea usb-storage: (Unknown Key): (unknown ASC/ASCQ)
Jul 28 10:00:18 enea usb-storage: scsi cmd done, result=0x2
Jul 28 10:00:18 enea sd 2:0:0:0: [sdb] Sense Key : 0x0 [current] 
Jul 28 10:00:18 enea sd 2:0:0:0: [sdb] ASC=0x0 ASCQ=0x0
Jul 28 10:00:18 enea usb-storage: queuecommand called
Jul 28 10:00:18 enea usb-storage: *** thread sleeping.
Jul 28 10:00:18 enea usb-storage: *** thread awakened.
Jul 28 10:00:18 enea usb-storage: Command READ_10 (10 bytes)
Jul 28 10:00:18 enea usb-storage:  28 00 00 3c 94 00 00 00 01 00
Jul 28 10:00:18 enea usb-storage: Bulk Command S 0x43425355 T 0x54 L 512 F 128 Trg 0 LUN 0 CL 10
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 31/31
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk command transfer result=0
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_sglist: xfer 512 bytes, 1 entries
Jul 28 10:00:18 enea usb-storage: Status code -32; transferred 0/512
Jul 28 10:00:18 enea usb-storage: clearing endpoint halt for pipe 0xc0008380
Jul 28 10:00:18 enea usb-storage: usb_stor_control_msg: rq=01 rqtype=02 value=0000 index=81 len=0
Jul 28 10:00:18 enea usb-storage: usb_stor_clear_halt: result = 0
Jul 28 10:00:18 enea usb-storage: Bulk data transfer result 0x2
Jul 28 10:00:18 enea usb-storage: Attempting to get CSW...
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 13/13
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk status result = 0
Jul 28 10:00:18 enea usb-storage: Bulk Status S 0x53425355 T 0x54 R 512 Stat 0x1
Jul 28 10:00:18 enea usb-storage: -- transport indicates command failure
Jul 28 10:00:18 enea usb-storage: -- unexpectedly short transfer
Jul 28 10:00:18 enea usb-storage: Issuing auto-REQUEST_SENSE
Jul 28 10:00:18 enea usb-storage: Bulk Command S 0x43425355 T 0x55 L 18 F 128 Trg 0 LUN 0 CL 6
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 31/31
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk command transfer result=0
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 18/18
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk data transfer result 0x0
Jul 28 10:00:18 enea usb-storage: Attempting to get CSW...
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 13/13
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk status result = 0
Jul 28 10:00:18 enea usb-storage: Bulk Status S 0x53425355 T 0x55 R 0 Stat 0x0
Jul 28 10:00:18 enea usb-storage: -- Result from auto-sense is 0
Jul 28 10:00:18 enea usb-storage: -- code: 0x70, key: 0x0, ASC: 0x0, ASCQ: 0x0
Jul 28 10:00:18 enea usb-storage: (Unknown Key): (unknown ASC/ASCQ)
Jul 28 10:00:18 enea usb-storage: scsi cmd done, result=0x2
Jul 28 10:00:18 enea sd 2:0:0:0: [sdb] Sense Key : 0x0 [current] 
Jul 28 10:00:18 enea sd 2:0:0:0: [sdb] ASC=0x0 ASCQ=0x0
Jul 28 10:00:18 enea usb-storage: queuecommand called
Jul 28 10:00:18 enea usb-storage: *** thread sleeping.
Jul 28 10:00:18 enea usb-storage: *** thread awakened.
Jul 28 10:00:18 enea usb-storage: Command READ_10 (10 bytes)
Jul 28 10:00:18 enea usb-storage:  28 00 00 3c 94 00 00 00 01 00
Jul 28 10:00:18 enea usb-storage: Bulk Command S 0x43425355 T 0x56 L 512 F 128 Trg 0 LUN 0 CL 10
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 31/31
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk command transfer result=0
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_sglist: xfer 512 bytes, 1 entries
Jul 28 10:00:18 enea usb-storage: Status code -32; transferred 0/512
Jul 28 10:00:18 enea usb-storage: clearing endpoint halt for pipe 0xc0008380
Jul 28 10:00:18 enea usb-storage: usb_stor_control_msg: rq=01 rqtype=02 value=0000 index=81 len=0
Jul 28 10:00:18 enea usb-storage: usb_stor_clear_halt: result = 0
Jul 28 10:00:18 enea usb-storage: Bulk data transfer result 0x2
Jul 28 10:00:18 enea usb-storage: Attempting to get CSW...
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 13/13
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk status result = 0
Jul 28 10:00:18 enea usb-storage: Bulk Status S 0x53425355 T 0x56 R 512 Stat 0x1
Jul 28 10:00:18 enea usb-storage: -- transport indicates command failure
Jul 28 10:00:18 enea usb-storage: -- unexpectedly short transfer
Jul 28 10:00:18 enea usb-storage: Issuing auto-REQUEST_SENSE
Jul 28 10:00:18 enea usb-storage: Bulk Command S 0x43425355 T 0x57 L 18 F 128 Trg 0 LUN 0 CL 6
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 31/31
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk command transfer result=0
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 18/18
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk data transfer result 0x0
Jul 28 10:00:18 enea usb-storage: Attempting to get CSW...
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 13/13
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk status result = 0
Jul 28 10:00:18 enea usb-storage: Bulk Status S 0x53425355 T 0x57 R 0 Stat 0x0
Jul 28 10:00:18 enea usb-storage: -- Result from auto-sense is 0
Jul 28 10:00:18 enea usb-storage: -- code: 0x70, key: 0x0, ASC: 0x0, ASCQ: 0x0
Jul 28 10:00:18 enea usb-storage: (Unknown Key): (unknown ASC/ASCQ)
Jul 28 10:00:18 enea usb-storage: scsi cmd done, result=0x2
Jul 28 10:00:18 enea sd 2:0:0:0: [sdb] Sense Key : 0x0 [current] 
Jul 28 10:00:18 enea sd 2:0:0:0: [sdb] ASC=0x0 ASCQ=0x0
Jul 28 10:00:18 enea usb-storage: queuecommand called
Jul 28 10:00:18 enea usb-storage: *** thread sleeping.
Jul 28 10:00:18 enea usb-storage: *** thread awakened.
Jul 28 10:00:18 enea usb-storage: Command READ_10 (10 bytes)
Jul 28 10:00:18 enea usb-storage:  28 00 00 3c 94 00 00 00 01 00
Jul 28 10:00:18 enea usb-storage: Bulk Command S 0x43425355 T 0x58 L 512 F 128 Trg 0 LUN 0 CL 10
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 31/31
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk command transfer result=0
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_sglist: xfer 512 bytes, 1 entries
Jul 28 10:00:18 enea usb-storage: Status code -32; transferred 0/512
Jul 28 10:00:18 enea usb-storage: clearing endpoint halt for pipe 0xc0008380
Jul 28 10:00:18 enea usb-storage: usb_stor_control_msg: rq=01 rqtype=02 value=0000 index=81 len=0
Jul 28 10:00:18 enea usb-storage: usb_stor_clear_halt: result = 0
Jul 28 10:00:18 enea usb-storage: Bulk data transfer result 0x2
Jul 28 10:00:18 enea usb-storage: Attempting to get CSW...
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 13/13
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk status result = 0
Jul 28 10:00:18 enea usb-storage: Bulk Status S 0x53425355 T 0x58 R 512 Stat 0x1
Jul 28 10:00:18 enea usb-storage: -- transport indicates command failure
Jul 28 10:00:18 enea usb-storage: -- unexpectedly short transfer
Jul 28 10:00:18 enea usb-storage: Issuing auto-REQUEST_SENSE
Jul 28 10:00:18 enea usb-storage: Bulk Command S 0x43425355 T 0x59 L 18 F 128 Trg 0 LUN 0 CL 6
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 31/31
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk command transfer result=0
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 18/18
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk data transfer result 0x0
Jul 28 10:00:18 enea usb-storage: Attempting to get CSW...
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 13/13
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk status result = 0
Jul 28 10:00:18 enea usb-storage: Bulk Status S 0x53425355 T 0x59 R 0 Stat 0x0
Jul 28 10:00:18 enea usb-storage: -- Result from auto-sense is 0
Jul 28 10:00:18 enea usb-storage: -- code: 0x70, key: 0x0, ASC: 0x0, ASCQ: 0x0
Jul 28 10:00:18 enea usb-storage: (Unknown Key): (unknown ASC/ASCQ)
Jul 28 10:00:18 enea usb-storage: scsi cmd done, result=0x2
Jul 28 10:00:18 enea sd 2:0:0:0: [sdb] Sense Key : 0x0 [current] 
Jul 28 10:00:18 enea sd 2:0:0:0: [sdb] ASC=0x0 ASCQ=0x0
Jul 28 10:00:18 enea usb-storage: queuecommand called
Jul 28 10:00:18 enea usb-storage: *** thread sleeping.
Jul 28 10:00:18 enea usb-storage: *** thread awakened.
Jul 28 10:00:18 enea usb-storage: Command READ_10 (10 bytes)
Jul 28 10:00:18 enea usb-storage:  28 00 00 3c 94 00 00 00 01 00
Jul 28 10:00:18 enea usb-storage: Bulk Command S 0x43425355 T 0x5a L 512 F 128 Trg 0 LUN 0 CL 10
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 31/31
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk command transfer result=0
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_sglist: xfer 512 bytes, 1 entries
Jul 28 10:00:18 enea usb-storage: Status code -32; transferred 0/512
Jul 28 10:00:18 enea usb-storage: clearing endpoint halt for pipe 0xc0008380
Jul 28 10:00:18 enea usb-storage: usb_stor_control_msg: rq=01 rqtype=02 value=0000 index=81 len=0
Jul 28 10:00:18 enea usb-storage: usb_stor_clear_halt: result = 0
Jul 28 10:00:18 enea usb-storage: Bulk data transfer result 0x2
Jul 28 10:00:18 enea usb-storage: Attempting to get CSW...
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 13/13
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk status result = 0
Jul 28 10:00:18 enea usb-storage: Bulk Status S 0x53425355 T 0x5a R 512 Stat 0x1
Jul 28 10:00:18 enea usb-storage: -- transport indicates command failure
Jul 28 10:00:18 enea usb-storage: -- unexpectedly short transfer
Jul 28 10:00:18 enea usb-storage: Issuing auto-REQUEST_SENSE
Jul 28 10:00:18 enea usb-storage: Bulk Command S 0x43425355 T 0x5b L 18 F 128 Trg 0 LUN 0 CL 6
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 31/31
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk command transfer result=0
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 18/18
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk data transfer result 0x0
Jul 28 10:00:18 enea usb-storage: Attempting to get CSW...
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 13/13
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk status result = 0
Jul 28 10:00:18 enea usb-storage: Bulk Status S 0x53425355 T 0x5b R 0 Stat 0x0
Jul 28 10:00:18 enea usb-storage: -- Result from auto-sense is 0
Jul 28 10:00:18 enea usb-storage: -- code: 0x70, key: 0x0, ASC: 0x0, ASCQ: 0x0
Jul 28 10:00:18 enea usb-storage: (Unknown Key): (unknown ASC/ASCQ)
Jul 28 10:00:18 enea usb-storage: scsi cmd done, result=0x2
Jul 28 10:00:18 enea sd 2:0:0:0: [sdb] Sense Key : 0x0 [current] 
Jul 28 10:00:18 enea sd 2:0:0:0: [sdb] ASC=0x0 ASCQ=0x0
Jul 28 10:00:18 enea usb-storage: queuecommand called
Jul 28 10:00:18 enea usb-storage: *** thread sleeping.
Jul 28 10:00:18 enea usb-storage: *** thread awakened.
Jul 28 10:00:18 enea usb-storage: Command READ_10 (10 bytes)
Jul 28 10:00:18 enea usb-storage:  28 00 00 3c 94 00 00 00 01 00
Jul 28 10:00:18 enea usb-storage: Bulk Command S 0x43425355 T 0x5c L 512 F 128 Trg 0 LUN 0 CL 10
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 31/31
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk command transfer result=0
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_sglist: xfer 512 bytes, 1 entries
Jul 28 10:00:18 enea usb-storage: Status code -32; transferred 0/512
Jul 28 10:00:18 enea usb-storage: clearing endpoint halt for pipe 0xc0008380
Jul 28 10:00:18 enea usb-storage: usb_stor_control_msg: rq=01 rqtype=02 value=0000 index=81 len=0
Jul 28 10:00:18 enea usb-storage: usb_stor_clear_halt: result = 0
Jul 28 10:00:18 enea usb-storage: Bulk data transfer result 0x2
Jul 28 10:00:18 enea usb-storage: Attempting to get CSW...
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 13/13
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk status result = 0
Jul 28 10:00:18 enea usb-storage: Bulk Status S 0x53425355 T 0x5c R 512 Stat 0x1
Jul 28 10:00:18 enea usb-storage: -- transport indicates command failure
Jul 28 10:00:18 enea usb-storage: -- unexpectedly short transfer
Jul 28 10:00:18 enea usb-storage: Issuing auto-REQUEST_SENSE
Jul 28 10:00:18 enea usb-storage: Bulk Command S 0x43425355 T 0x5d L 18 F 128 Trg 0 LUN 0 CL 6
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 31/31
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk command transfer result=0
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 18/18
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk data transfer result 0x0
Jul 28 10:00:18 enea usb-storage: Attempting to get CSW...
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 13/13
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk status result = 0
Jul 28 10:00:18 enea usb-storage: Bulk Status S 0x53425355 T 0x5d R 0 Stat 0x0
Jul 28 10:00:18 enea usb-storage: -- Result from auto-sense is 0
Jul 28 10:00:18 enea usb-storage: -- code: 0x70, key: 0x0, ASC: 0x0, ASCQ: 0x0
Jul 28 10:00:18 enea usb-storage: (Unknown Key): (unknown ASC/ASCQ)
Jul 28 10:00:18 enea usb-storage: scsi cmd done, result=0x2
Jul 28 10:00:18 enea sd 2:0:0:0: [sdb] Sense Key : 0x0 [current] 
Jul 28 10:00:18 enea sd 2:0:0:0: [sdb] ASC=0x0 ASCQ=0x0
Jul 28 10:00:18 enea usb-storage: queuecommand called
Jul 28 10:00:18 enea usb-storage: *** thread sleeping.
Jul 28 10:00:18 enea usb-storage: *** thread awakened.
Jul 28 10:00:18 enea usb-storage: Command READ_10 (10 bytes)
Jul 28 10:00:18 enea usb-storage:  28 00 00 3c 94 00 00 00 01 00
Jul 28 10:00:18 enea usb-storage: Bulk Command S 0x43425355 T 0x5e L 512 F 128 Trg 0 LUN 0 CL 10
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 31/31
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk command transfer result=0
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_sglist: xfer 512 bytes, 1 entries
Jul 28 10:00:18 enea usb-storage: Status code -32; transferred 0/512
Jul 28 10:00:18 enea usb-storage: clearing endpoint halt for pipe 0xc0008380
Jul 28 10:00:18 enea usb-storage: usb_stor_control_msg: rq=01 rqtype=02 value=0000 index=81 len=0
Jul 28 10:00:18 enea usb-storage: usb_stor_clear_halt: result = 0
Jul 28 10:00:18 enea usb-storage: Bulk data transfer result 0x2
Jul 28 10:00:18 enea usb-storage: Attempting to get CSW...
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 13/13
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk status result = 0
Jul 28 10:00:18 enea usb-storage: Bulk Status S 0x53425355 T 0x5e R 512 Stat 0x1
Jul 28 10:00:18 enea usb-storage: -- transport indicates command failure
Jul 28 10:00:18 enea usb-storage: -- unexpectedly short transfer
Jul 28 10:00:18 enea usb-storage: Issuing auto-REQUEST_SENSE
Jul 28 10:00:18 enea usb-storage: Bulk Command S 0x43425355 T 0x5f L 18 F 128 Trg 0 LUN 0 CL 6
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 31/31
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk command transfer result=0
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 18/18
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk data transfer result 0x0
Jul 28 10:00:18 enea usb-storage: Attempting to get CSW...
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 13/13
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk status result = 0
Jul 28 10:00:18 enea usb-storage: Bulk Status S 0x53425355 T 0x5f R 0 Stat 0x0
Jul 28 10:00:18 enea usb-storage: -- Result from auto-sense is 0
Jul 28 10:00:18 enea usb-storage: -- code: 0x70, key: 0x0, ASC: 0x0, ASCQ: 0x0
Jul 28 10:00:18 enea usb-storage: (Unknown Key): (unknown ASC/ASCQ)
Jul 28 10:00:18 enea usb-storage: scsi cmd done, result=0x2
Jul 28 10:00:18 enea sd 2:0:0:0: [sdb] Sense Key : 0x0 [current] 
Jul 28 10:00:18 enea sd 2:0:0:0: [sdb] ASC=0x0 ASCQ=0x0
Jul 28 10:00:18 enea usb-storage: queuecommand called
Jul 28 10:00:18 enea usb-storage: *** thread sleeping.
Jul 28 10:00:18 enea usb-storage: *** thread awakened.
Jul 28 10:00:18 enea usb-storage: Command READ_10 (10 bytes)
Jul 28 10:00:18 enea usb-storage:  28 00 00 3c 94 00 00 00 01 00
Jul 28 10:00:18 enea usb-storage: Bulk Command S 0x43425355 T 0x60 L 512 F 128 Trg 0 LUN 0 CL 10
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 31/31
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk command transfer result=0
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_sglist: xfer 512 bytes, 1 entries
Jul 28 10:00:18 enea usb-storage: Status code -32; transferred 0/512
Jul 28 10:00:18 enea usb-storage: clearing endpoint halt for pipe 0xc0008380
Jul 28 10:00:18 enea usb-storage: usb_stor_control_msg: rq=01 rqtype=02 value=0000 index=81 len=0
Jul 28 10:00:18 enea usb-storage: usb_stor_clear_halt: result = 0
Jul 28 10:00:18 enea usb-storage: Bulk data transfer result 0x2
Jul 28 10:00:18 enea usb-storage: Attempting to get CSW...
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 13/13
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk status result = 0
Jul 28 10:00:18 enea usb-storage: Bulk Status S 0x53425355 T 0x60 R 512 Stat 0x1
Jul 28 10:00:18 enea usb-storage: -- transport indicates command failure
Jul 28 10:00:18 enea usb-storage: -- unexpectedly short transfer
Jul 28 10:00:18 enea usb-storage: Issuing auto-REQUEST_SENSE
Jul 28 10:00:18 enea usb-storage: Bulk Command S 0x43425355 T 0x61 L 18 F 128 Trg 0 LUN 0 CL 6
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 31/31
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk command transfer result=0
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 18/18
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk data transfer result 0x0
Jul 28 10:00:18 enea usb-storage: Attempting to get CSW...
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 13/13
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk status result = 0
Jul 28 10:00:18 enea usb-storage: Bulk Status S 0x53425355 T 0x61 R 0 Stat 0x0
Jul 28 10:00:18 enea usb-storage: -- Result from auto-sense is 0
Jul 28 10:00:18 enea usb-storage: -- code: 0x70, key: 0x0, ASC: 0x0, ASCQ: 0x0
Jul 28 10:00:18 enea usb-storage: (Unknown Key): (unknown ASC/ASCQ)
Jul 28 10:00:18 enea usb-storage: scsi cmd done, result=0x2
Jul 28 10:00:18 enea sd 2:0:0:0: [sdb] Sense Key : 0x0 [current] 
Jul 28 10:00:18 enea sd 2:0:0:0: [sdb] ASC=0x0 ASCQ=0x0
Jul 28 10:00:18 enea usb-storage: queuecommand called
Jul 28 10:00:18 enea usb-storage: *** thread sleeping.
Jul 28 10:00:18 enea usb-storage: *** thread awakened.
Jul 28 10:00:18 enea usb-storage: Command READ_10 (10 bytes)
Jul 28 10:00:18 enea usb-storage:  28 00 00 3c 94 00 00 00 01 00
Jul 28 10:00:18 enea usb-storage: Bulk Command S 0x43425355 T 0x62 L 512 F 128 Trg 0 LUN 0 CL 10
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 31/31
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk command transfer result=0
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_sglist: xfer 512 bytes, 1 entries
Jul 28 10:00:18 enea usb-storage: Status code -32; transferred 0/512
Jul 28 10:00:18 enea usb-storage: clearing endpoint halt for pipe 0xc0008380
Jul 28 10:00:18 enea usb-storage: usb_stor_control_msg: rq=01 rqtype=02 value=0000 index=81 len=0
Jul 28 10:00:18 enea usb-storage: usb_stor_clear_halt: result = 0
Jul 28 10:00:18 enea usb-storage: Bulk data transfer result 0x2
Jul 28 10:00:18 enea usb-storage: Attempting to get CSW...
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 13/13
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk status result = 0
Jul 28 10:00:18 enea usb-storage: Bulk Status S 0x53425355 T 0x62 R 512 Stat 0x1
Jul 28 10:00:18 enea usb-storage: -- transport indicates command failure
Jul 28 10:00:18 enea usb-storage: -- unexpectedly short transfer
Jul 28 10:00:18 enea usb-storage: Issuing auto-REQUEST_SENSE
Jul 28 10:00:18 enea usb-storage: Bulk Command S 0x43425355 T 0x63 L 18 F 128 Trg 0 LUN 0 CL 6
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 31/31
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk command transfer result=0
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 18/18
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk data transfer result 0x0
Jul 28 10:00:18 enea usb-storage: Attempting to get CSW...
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 13/13
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk status result = 0
Jul 28 10:00:18 enea usb-storage: Bulk Status S 0x53425355 T 0x63 R 0 Stat 0x0
Jul 28 10:00:18 enea usb-storage: -- Result from auto-sense is 0
Jul 28 10:00:18 enea usb-storage: -- code: 0x70, key: 0x0, ASC: 0x0, ASCQ: 0x0
Jul 28 10:00:18 enea usb-storage: (Unknown Key): (unknown ASC/ASCQ)
Jul 28 10:00:18 enea usb-storage: scsi cmd done, result=0x2
Jul 28 10:00:18 enea sd 2:0:0:0: [sdb] Sense Key : 0x0 [current] 
Jul 28 10:00:18 enea sd 2:0:0:0: [sdb] ASC=0x0 ASCQ=0x0
Jul 28 10:00:18 enea usb-storage: queuecommand called
Jul 28 10:00:18 enea usb-storage: *** thread sleeping.
Jul 28 10:00:18 enea usb-storage: *** thread awakened.
Jul 28 10:00:18 enea usb-storage: Command READ_10 (10 bytes)
Jul 28 10:00:18 enea usb-storage:  28 00 00 3c 94 00 00 00 01 00
Jul 28 10:00:18 enea usb-storage: Bulk Command S 0x43425355 T 0x64 L 512 F 128 Trg 0 LUN 0 CL 10
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 31/31
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk command transfer result=0
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_sglist: xfer 512 bytes, 1 entries
Jul 28 10:00:18 enea usb-storage: Status code -32; transferred 0/512
Jul 28 10:00:18 enea usb-storage: clearing endpoint halt for pipe 0xc0008380
Jul 28 10:00:18 enea usb-storage: usb_stor_control_msg: rq=01 rqtype=02 value=0000 index=81 len=0
Jul 28 10:00:18 enea usb-storage: usb_stor_clear_halt: result = 0
Jul 28 10:00:18 enea usb-storage: Bulk data transfer result 0x2
Jul 28 10:00:18 enea usb-storage: Attempting to get CSW...
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 13/13
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk status result = 0
Jul 28 10:00:18 enea usb-storage: Bulk Status S 0x53425355 T 0x64 R 512 Stat 0x1
Jul 28 10:00:18 enea usb-storage: -- transport indicates command failure
Jul 28 10:00:18 enea usb-storage: -- unexpectedly short transfer
Jul 28 10:00:18 enea usb-storage: Issuing auto-REQUEST_SENSE
Jul 28 10:00:18 enea usb-storage: Bulk Command S 0x43425355 T 0x65 L 18 F 128 Trg 0 LUN 0 CL 6
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 31/31
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk command transfer result=0
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 18/18
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk data transfer result 0x0
Jul 28 10:00:18 enea usb-storage: Attempting to get CSW...
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 13/13
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk status result = 0
Jul 28 10:00:18 enea usb-storage: Bulk Status S 0x53425355 T 0x65 R 0 Stat 0x0
Jul 28 10:00:18 enea usb-storage: -- Result from auto-sense is 0
Jul 28 10:00:18 enea usb-storage: -- code: 0x70, key: 0x0, ASC: 0x0, ASCQ: 0x0
Jul 28 10:00:18 enea usb-storage: (Unknown Key): (unknown ASC/ASCQ)
Jul 28 10:00:18 enea usb-storage: scsi cmd done, result=0x2
Jul 28 10:00:18 enea sd 2:0:0:0: [sdb] Sense Key : 0x0 [current] 
Jul 28 10:00:18 enea sd 2:0:0:0: [sdb] ASC=0x0 ASCQ=0x0
Jul 28 10:00:18 enea usb-storage: queuecommand called
Jul 28 10:00:18 enea usb-storage: *** thread sleeping.
Jul 28 10:00:18 enea usb-storage: *** thread awakened.
Jul 28 10:00:18 enea usb-storage: Command READ_10 (10 bytes)
Jul 28 10:00:18 enea usb-storage:  28 00 00 3c 94 00 00 00 01 00
Jul 28 10:00:18 enea usb-storage: Bulk Command S 0x43425355 T 0x66 L 512 F 128 Trg 0 LUN 0 CL 10
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 31/31
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk command transfer result=0
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_sglist: xfer 512 bytes, 1 entries
Jul 28 10:00:18 enea usb-storage: Status code -32; transferred 0/512
Jul 28 10:00:18 enea usb-storage: clearing endpoint halt for pipe 0xc0008380
Jul 28 10:00:18 enea usb-storage: usb_stor_control_msg: rq=01 rqtype=02 value=0000 index=81 len=0
Jul 28 10:00:18 enea usb-storage: usb_stor_clear_halt: result = 0
Jul 28 10:00:18 enea usb-storage: Bulk data transfer result 0x2
Jul 28 10:00:18 enea usb-storage: Attempting to get CSW...
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 13/13
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk status result = 0
Jul 28 10:00:18 enea usb-storage: Bulk Status S 0x53425355 T 0x66 R 512 Stat 0x1
Jul 28 10:00:18 enea usb-storage: -- transport indicates command failure
Jul 28 10:00:18 enea usb-storage: -- unexpectedly short transfer
Jul 28 10:00:18 enea usb-storage: Issuing auto-REQUEST_SENSE
Jul 28 10:00:18 enea usb-storage: Bulk Command S 0x43425355 T 0x67 L 18 F 128 Trg 0 LUN 0 CL 6
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 31/31
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk command transfer result=0
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 18/18
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk data transfer result 0x0
Jul 28 10:00:18 enea usb-storage: Attempting to get CSW...
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 13/13
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk status result = 0
Jul 28 10:00:18 enea usb-storage: Bulk Status S 0x53425355 T 0x67 R 0 Stat 0x0
Jul 28 10:00:18 enea usb-storage: -- Result from auto-sense is 0
Jul 28 10:00:18 enea usb-storage: -- code: 0x70, key: 0x0, ASC: 0x0, ASCQ: 0x0
Jul 28 10:00:18 enea usb-storage: (Unknown Key): (unknown ASC/ASCQ)
Jul 28 10:00:18 enea usb-storage: scsi cmd done, result=0x2
Jul 28 10:00:18 enea sd 2:0:0:0: [sdb] Sense Key : 0x0 [current] 
Jul 28 10:00:18 enea sd 2:0:0:0: [sdb] ASC=0x0 ASCQ=0x0
Jul 28 10:00:18 enea usb-storage: queuecommand called
Jul 28 10:00:18 enea usb-storage: *** thread sleeping.
Jul 28 10:00:18 enea usb-storage: *** thread awakened.
Jul 28 10:00:18 enea usb-storage: Command READ_10 (10 bytes)
Jul 28 10:00:18 enea usb-storage:  28 00 00 3c 94 00 00 00 01 00
Jul 28 10:00:18 enea usb-storage: Bulk Command S 0x43425355 T 0x68 L 512 F 128 Trg 0 LUN 0 CL 10
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 31/31
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk command transfer result=0
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_sglist: xfer 512 bytes, 1 entries
Jul 28 10:00:18 enea usb-storage: Status code -32; transferred 0/512
Jul 28 10:00:18 enea usb-storage: clearing endpoint halt for pipe 0xc0008380
Jul 28 10:00:18 enea usb-storage: usb_stor_control_msg: rq=01 rqtype=02 value=0000 index=81 len=0
Jul 28 10:00:18 enea usb-storage: usb_stor_clear_halt: result = 0
Jul 28 10:00:18 enea usb-storage: Bulk data transfer result 0x2
Jul 28 10:00:18 enea usb-storage: Attempting to get CSW...
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 13/13
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk status result = 0
Jul 28 10:00:18 enea usb-storage: Bulk Status S 0x53425355 T 0x68 R 512 Stat 0x1
Jul 28 10:00:18 enea usb-storage: -- transport indicates command failure
Jul 28 10:00:18 enea usb-storage: -- unexpectedly short transfer
Jul 28 10:00:18 enea usb-storage: Issuing auto-REQUEST_SENSE
Jul 28 10:00:18 enea usb-storage: Bulk Command S 0x43425355 T 0x69 L 18 F 128 Trg 0 LUN 0 CL 6
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 31/31
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk command transfer result=0
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 18/18
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk data transfer result 0x0
Jul 28 10:00:18 enea usb-storage: Attempting to get CSW...
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 13/13
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk status result = 0
Jul 28 10:00:18 enea usb-storage: Bulk Status S 0x53425355 T 0x69 R 0 Stat 0x0
Jul 28 10:00:18 enea usb-storage: -- Result from auto-sense is 0
Jul 28 10:00:18 enea usb-storage: -- code: 0x70, key: 0x0, ASC: 0x0, ASCQ: 0x0
Jul 28 10:00:18 enea usb-storage: (Unknown Key): (unknown ASC/ASCQ)
Jul 28 10:00:18 enea usb-storage: scsi cmd done, result=0x2
Jul 28 10:00:18 enea sd 2:0:0:0: [sdb] Sense Key : 0x0 [current] 
Jul 28 10:00:18 enea sd 2:0:0:0: [sdb] ASC=0x0 ASCQ=0x0
Jul 28 10:00:18 enea usb-storage: queuecommand called
Jul 28 10:00:18 enea usb-storage: *** thread sleeping.
Jul 28 10:00:18 enea usb-storage: *** thread awakened.
Jul 28 10:00:18 enea usb-storage: Command READ_10 (10 bytes)
Jul 28 10:00:18 enea usb-storage:  28 00 00 3c 94 00 00 00 01 00
Jul 28 10:00:18 enea usb-storage: Bulk Command S 0x43425355 T 0x6a L 512 F 128 Trg 0 LUN 0 CL 10
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 31/31
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk command transfer result=0
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_sglist: xfer 512 bytes, 1 entries
Jul 28 10:00:18 enea usb-storage: Status code -32; transferred 0/512
Jul 28 10:00:18 enea usb-storage: clearing endpoint halt for pipe 0xc0008380
Jul 28 10:00:18 enea usb-storage: usb_stor_control_msg: rq=01 rqtype=02 value=0000 index=81 len=0
Jul 28 10:00:18 enea usb-storage: usb_stor_clear_halt: result = 0
Jul 28 10:00:18 enea usb-storage: Bulk data transfer result 0x2
Jul 28 10:00:18 enea usb-storage: Attempting to get CSW...
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 13/13
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk status result = 0
Jul 28 10:00:18 enea usb-storage: Bulk Status S 0x53425355 T 0x6a R 512 Stat 0x1
Jul 28 10:00:18 enea usb-storage: -- transport indicates command failure
Jul 28 10:00:18 enea usb-storage: -- unexpectedly short transfer
Jul 28 10:00:18 enea usb-storage: Issuing auto-REQUEST_SENSE
Jul 28 10:00:18 enea usb-storage: Bulk Command S 0x43425355 T 0x6b L 18 F 128 Trg 0 LUN 0 CL 6
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 31/31
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk command transfer result=0
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 18/18
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk data transfer result 0x0
Jul 28 10:00:18 enea usb-storage: Attempting to get CSW...
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 13/13
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk status result = 0
Jul 28 10:00:18 enea usb-storage: Bulk Status S 0x53425355 T 0x6b R 0 Stat 0x0
Jul 28 10:00:18 enea usb-storage: -- Result from auto-sense is 0
Jul 28 10:00:18 enea usb-storage: -- code: 0x70, key: 0x0, ASC: 0x0, ASCQ: 0x0
Jul 28 10:00:18 enea usb-storage: (Unknown Key): (unknown ASC/ASCQ)
Jul 28 10:00:18 enea usb-storage: scsi cmd done, result=0x2
Jul 28 10:00:18 enea sd 2:0:0:0: [sdb] Sense Key : 0x0 [current] 
Jul 28 10:00:18 enea sd 2:0:0:0: [sdb] ASC=0x0 ASCQ=0x0
Jul 28 10:00:18 enea usb-storage: queuecommand called
Jul 28 10:00:18 enea usb-storage: *** thread sleeping.
Jul 28 10:00:18 enea usb-storage: *** thread awakened.
Jul 28 10:00:18 enea usb-storage: Command READ_10 (10 bytes)
Jul 28 10:00:18 enea usb-storage:  28 00 00 3c 94 00 00 00 01 00
Jul 28 10:00:18 enea usb-storage: Bulk Command S 0x43425355 T 0x6c L 512 F 128 Trg 0 LUN 0 CL 10
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 31/31
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk command transfer result=0
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_sglist: xfer 512 bytes, 1 entries
Jul 28 10:00:18 enea usb-storage: Status code -32; transferred 0/512
Jul 28 10:00:18 enea usb-storage: clearing endpoint halt for pipe 0xc0008380
Jul 28 10:00:18 enea usb-storage: usb_stor_control_msg: rq=01 rqtype=02 value=0000 index=81 len=0
Jul 28 10:00:18 enea usb-storage: usb_stor_clear_halt: result = 0
Jul 28 10:00:18 enea usb-storage: Bulk data transfer result 0x2
Jul 28 10:00:18 enea usb-storage: Attempting to get CSW...
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 13/13
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk status result = 0
Jul 28 10:00:18 enea usb-storage: Bulk Status S 0x53425355 T 0x6c R 512 Stat 0x1
Jul 28 10:00:18 enea usb-storage: -- transport indicates command failure
Jul 28 10:00:18 enea usb-storage: -- unexpectedly short transfer
Jul 28 10:00:18 enea usb-storage: Issuing auto-REQUEST_SENSE
Jul 28 10:00:18 enea usb-storage: Bulk Command S 0x43425355 T 0x6d L 18 F 128 Trg 0 LUN 0 CL 6
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 31/31
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk command transfer result=0
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 18/18
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk data transfer result 0x0
Jul 28 10:00:18 enea usb-storage: Attempting to get CSW...
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 13/13
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk status result = 0
Jul 28 10:00:18 enea usb-storage: Bulk Status S 0x53425355 T 0x6d R 0 Stat 0x0
Jul 28 10:00:18 enea usb-storage: -- Result from auto-sense is 0
Jul 28 10:00:18 enea usb-storage: -- code: 0x70, key: 0x0, ASC: 0x0, ASCQ: 0x0
Jul 28 10:00:18 enea usb-storage: (Unknown Key): (unknown ASC/ASCQ)
Jul 28 10:00:18 enea usb-storage: scsi cmd done, result=0x2
Jul 28 10:00:18 enea sd 2:0:0:0: [sdb] Sense Key : 0x0 [current] 
Jul 28 10:00:18 enea sd 2:0:0:0: [sdb] ASC=0x0 ASCQ=0x0
Jul 28 10:00:18 enea usb-storage: queuecommand called
Jul 28 10:00:18 enea usb-storage: *** thread sleeping.
Jul 28 10:00:18 enea usb-storage: *** thread awakened.
Jul 28 10:00:18 enea usb-storage: Command READ_10 (10 bytes)
Jul 28 10:00:18 enea usb-storage:  28 00 00 3c 94 00 00 00 01 00
Jul 28 10:00:18 enea usb-storage: Bulk Command S 0x43425355 T 0x6e L 512 F 128 Trg 0 LUN 0 CL 10
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 31/31
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk command transfer result=0
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_sglist: xfer 512 bytes, 1 entries
Jul 28 10:00:18 enea usb-storage: Status code -32; transferred 0/512
Jul 28 10:00:18 enea usb-storage: clearing endpoint halt for pipe 0xc0008380
Jul 28 10:00:18 enea usb-storage: usb_stor_control_msg: rq=01 rqtype=02 value=0000 index=81 len=0
Jul 28 10:00:18 enea usb-storage: usb_stor_clear_halt: result = 0
Jul 28 10:00:18 enea usb-storage: Bulk data transfer result 0x2
Jul 28 10:00:18 enea usb-storage: Attempting to get CSW...
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 13/13
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk status result = 0
Jul 28 10:00:18 enea usb-storage: Bulk Status S 0x53425355 T 0x6e R 512 Stat 0x1
Jul 28 10:00:18 enea usb-storage: -- transport indicates command failure
Jul 28 10:00:18 enea usb-storage: -- unexpectedly short transfer
Jul 28 10:00:18 enea usb-storage: Issuing auto-REQUEST_SENSE
Jul 28 10:00:18 enea usb-storage: Bulk Command S 0x43425355 T 0x6f L 18 F 128 Trg 0 LUN 0 CL 6
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 31/31
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk command transfer result=0
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 18/18
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk data transfer result 0x0
Jul 28 10:00:18 enea usb-storage: Attempting to get CSW...
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 13/13
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk status result = 0
Jul 28 10:00:18 enea usb-storage: Bulk Status S 0x53425355 T 0x6f R 0 Stat 0x0
Jul 28 10:00:18 enea usb-storage: -- Result from auto-sense is 0
Jul 28 10:00:18 enea usb-storage: -- code: 0x70, key: 0x0, ASC: 0x0, ASCQ: 0x0
Jul 28 10:00:18 enea usb-storage: (Unknown Key): (unknown ASC/ASCQ)
Jul 28 10:00:18 enea usb-storage: scsi cmd done, result=0x2
Jul 28 10:00:18 enea sd 2:0:0:0: [sdb] Sense Key : 0x0 [current] 
Jul 28 10:00:18 enea sd 2:0:0:0: [sdb] ASC=0x0 ASCQ=0x0
Jul 28 10:00:18 enea usb-storage: queuecommand called
Jul 28 10:00:18 enea usb-storage: *** thread sleeping.
Jul 28 10:00:18 enea usb-storage: *** thread awakened.
Jul 28 10:00:18 enea usb-storage: Command READ_10 (10 bytes)
Jul 28 10:00:18 enea usb-storage:  28 00 00 3c 94 00 00 00 01 00
Jul 28 10:00:18 enea usb-storage: Bulk Command S 0x43425355 T 0x70 L 512 F 128 Trg 0 LUN 0 CL 10
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 31/31
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk command transfer result=0
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_sglist: xfer 512 bytes, 1 entries
Jul 28 10:00:18 enea usb-storage: Status code -32; transferred 0/512
Jul 28 10:00:18 enea usb-storage: clearing endpoint halt for pipe 0xc0008380
Jul 28 10:00:18 enea usb-storage: usb_stor_control_msg: rq=01 rqtype=02 value=0000 index=81 len=0
Jul 28 10:00:18 enea usb-storage: usb_stor_clear_halt: result = 0
Jul 28 10:00:18 enea usb-storage: Bulk data transfer result 0x2
Jul 28 10:00:18 enea usb-storage: Attempting to get CSW...
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 13/13
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk status result = 0
Jul 28 10:00:18 enea usb-storage: Bulk Status S 0x53425355 T 0x70 R 512 Stat 0x1
Jul 28 10:00:18 enea usb-storage: -- transport indicates command failure
Jul 28 10:00:18 enea usb-storage: -- unexpectedly short transfer
Jul 28 10:00:18 enea usb-storage: Issuing auto-REQUEST_SENSE
Jul 28 10:00:18 enea usb-storage: Bulk Command S 0x43425355 T 0x71 L 18 F 128 Trg 0 LUN 0 CL 6
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 31/31
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk command transfer result=0
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 18/18
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk data transfer result 0x0
Jul 28 10:00:18 enea usb-storage: Attempting to get CSW...
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 13/13
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk status result = 0
Jul 28 10:00:18 enea usb-storage: Bulk Status S 0x53425355 T 0x71 R 0 Stat 0x0
Jul 28 10:00:18 enea usb-storage: -- Result from auto-sense is 0
Jul 28 10:00:18 enea usb-storage: -- code: 0x70, key: 0x0, ASC: 0x0, ASCQ: 0x0
Jul 28 10:00:18 enea usb-storage: (Unknown Key): (unknown ASC/ASCQ)
Jul 28 10:00:18 enea usb-storage: scsi cmd done, result=0x2
Jul 28 10:00:18 enea sd 2:0:0:0: [sdb] Sense Key : 0x0 [current] 
Jul 28 10:00:18 enea sd 2:0:0:0: [sdb] ASC=0x0 ASCQ=0x0
Jul 28 10:00:18 enea usb-storage: queuecommand called
Jul 28 10:00:18 enea usb-storage: *** thread sleeping.
Jul 28 10:00:18 enea usb-storage: *** thread awakened.
Jul 28 10:00:18 enea usb-storage: Command READ_10 (10 bytes)
Jul 28 10:00:18 enea usb-storage:  28 00 00 3c 94 00 00 00 01 00
Jul 28 10:00:18 enea usb-storage: Bulk Command S 0x43425355 T 0x72 L 512 F 128 Trg 0 LUN 0 CL 10
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 31/31
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk command transfer result=0
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_sglist: xfer 512 bytes, 1 entries
Jul 28 10:00:18 enea usb-storage: Status code -32; transferred 0/512
Jul 28 10:00:18 enea usb-storage: clearing endpoint halt for pipe 0xc0008380
Jul 28 10:00:18 enea usb-storage: usb_stor_control_msg: rq=01 rqtype=02 value=0000 index=81 len=0
Jul 28 10:00:18 enea usb-storage: usb_stor_clear_halt: result = 0
Jul 28 10:00:18 enea usb-storage: Bulk data transfer result 0x2
Jul 28 10:00:18 enea usb-storage: Attempting to get CSW...
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 13/13
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk status result = 0
Jul 28 10:00:18 enea usb-storage: Bulk Status S 0x53425355 T 0x72 R 512 Stat 0x1
Jul 28 10:00:18 enea usb-storage: -- transport indicates command failure
Jul 28 10:00:18 enea usb-storage: -- unexpectedly short transfer
Jul 28 10:00:18 enea usb-storage: Issuing auto-REQUEST_SENSE
Jul 28 10:00:18 enea usb-storage: Bulk Command S 0x43425355 T 0x73 L 18 F 128 Trg 0 LUN 0 CL 6
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 31/31
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk command transfer result=0
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 18/18
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk data transfer result 0x0
Jul 28 10:00:18 enea usb-storage: Attempting to get CSW...
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 13/13
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk status result = 0
Jul 28 10:00:18 enea usb-storage: Bulk Status S 0x53425355 T 0x73 R 0 Stat 0x0
Jul 28 10:00:18 enea usb-storage: -- Result from auto-sense is 0
Jul 28 10:00:18 enea usb-storage: -- code: 0x70, key: 0x0, ASC: 0x0, ASCQ: 0x0
Jul 28 10:00:18 enea usb-storage: (Unknown Key): (unknown ASC/ASCQ)
Jul 28 10:00:18 enea usb-storage: scsi cmd done, result=0x2
Jul 28 10:00:18 enea sd 2:0:0:0: [sdb] Sense Key : 0x0 [current] 
Jul 28 10:00:18 enea sd 2:0:0:0: [sdb] ASC=0x0 ASCQ=0x0
Jul 28 10:00:18 enea usb-storage: queuecommand called
Jul 28 10:00:18 enea usb-storage: *** thread sleeping.
Jul 28 10:00:18 enea usb-storage: *** thread awakened.
Jul 28 10:00:18 enea usb-storage: Command READ_10 (10 bytes)
Jul 28 10:00:18 enea usb-storage:  28 00 00 3c 94 00 00 00 01 00
Jul 28 10:00:18 enea usb-storage: Bulk Command S 0x43425355 T 0x74 L 512 F 128 Trg 0 LUN 0 CL 10
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 31/31
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk command transfer result=0
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_sglist: xfer 512 bytes, 1 entries
Jul 28 10:00:18 enea usb-storage: Status code -32; transferred 0/512
Jul 28 10:00:18 enea usb-storage: clearing endpoint halt for pipe 0xc0008380
Jul 28 10:00:18 enea usb-storage: usb_stor_control_msg: rq=01 rqtype=02 value=0000 index=81 len=0
Jul 28 10:00:18 enea usb-storage: usb_stor_clear_halt: result = 0
Jul 28 10:00:18 enea usb-storage: Bulk data transfer result 0x2
Jul 28 10:00:18 enea usb-storage: Attempting to get CSW...
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 13/13
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk status result = 0
Jul 28 10:00:18 enea usb-storage: Bulk Status S 0x53425355 T 0x74 R 512 Stat 0x1
Jul 28 10:00:18 enea usb-storage: -- transport indicates command failure
Jul 28 10:00:18 enea usb-storage: -- unexpectedly short transfer
Jul 28 10:00:18 enea usb-storage: Issuing auto-REQUEST_SENSE
Jul 28 10:00:18 enea usb-storage: Bulk Command S 0x43425355 T 0x75 L 18 F 128 Trg 0 LUN 0 CL 6
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 31/31
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk command transfer result=0
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 18/18
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk data transfer result 0x0
Jul 28 10:00:18 enea usb-storage: Attempting to get CSW...
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 13/13
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk status result = 0
Jul 28 10:00:18 enea usb-storage: Bulk Status S 0x53425355 T 0x75 R 0 Stat 0x0
Jul 28 10:00:18 enea usb-storage: -- Result from auto-sense is 0
Jul 28 10:00:18 enea usb-storage: -- code: 0x70, key: 0x0, ASC: 0x0, ASCQ: 0x0
Jul 28 10:00:18 enea usb-storage: (Unknown Key): (unknown ASC/ASCQ)
Jul 28 10:00:18 enea usb-storage: scsi cmd done, result=0x2
Jul 28 10:00:18 enea sd 2:0:0:0: [sdb] Sense Key : 0x0 [current] 
Jul 28 10:00:18 enea sd 2:0:0:0: [sdb] ASC=0x0 ASCQ=0x0
Jul 28 10:00:18 enea usb-storage: queuecommand called
Jul 28 10:00:18 enea usb-storage: *** thread sleeping.
Jul 28 10:00:18 enea usb-storage: *** thread awakened.
Jul 28 10:00:18 enea usb-storage: Command READ_10 (10 bytes)
Jul 28 10:00:18 enea usb-storage:  28 00 00 3c 94 00 00 00 01 00
Jul 28 10:00:18 enea usb-storage: Bulk Command S 0x43425355 T 0x76 L 512 F 128 Trg 0 LUN 0 CL 10
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 31/31
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk command transfer result=0
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_sglist: xfer 512 bytes, 1 entries
Jul 28 10:00:18 enea usb-storage: Status code -32; transferred 0/512
Jul 28 10:00:18 enea usb-storage: clearing endpoint halt for pipe 0xc0008380
Jul 28 10:00:18 enea usb-storage: usb_stor_control_msg: rq=01 rqtype=02 value=0000 index=81 len=0
Jul 28 10:00:18 enea usb-storage: usb_stor_clear_halt: result = 0
Jul 28 10:00:18 enea usb-storage: Bulk data transfer result 0x2
Jul 28 10:00:18 enea usb-storage: Attempting to get CSW...
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 13/13
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk status result = 0
Jul 28 10:00:18 enea usb-storage: Bulk Status S 0x53425355 T 0x76 R 512 Stat 0x1
Jul 28 10:00:18 enea usb-storage: -- transport indicates command failure
Jul 28 10:00:18 enea usb-storage: -- unexpectedly short transfer
Jul 28 10:00:18 enea usb-storage: Issuing auto-REQUEST_SENSE
Jul 28 10:00:18 enea usb-storage: Bulk Command S 0x43425355 T 0x77 L 18 F 128 Trg 0 LUN 0 CL 6
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 31/31
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk command transfer result=0
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 18/18
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk data transfer result 0x0
Jul 28 10:00:18 enea usb-storage: Attempting to get CSW...
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 13/13
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk status result = 0
Jul 28 10:00:18 enea usb-storage: Bulk Status S 0x53425355 T 0x77 R 0 Stat 0x0
Jul 28 10:00:18 enea usb-storage: -- Result from auto-sense is 0
Jul 28 10:00:18 enea usb-storage: -- code: 0x70, key: 0x0, ASC: 0x0, ASCQ: 0x0
Jul 28 10:00:18 enea usb-storage: (Unknown Key): (unknown ASC/ASCQ)
Jul 28 10:00:18 enea usb-storage: scsi cmd done, result=0x2
Jul 28 10:00:18 enea sd 2:0:0:0: [sdb] Sense Key : 0x0 [current] 
Jul 28 10:00:18 enea sd 2:0:0:0: [sdb] ASC=0x0 ASCQ=0x0
Jul 28 10:00:18 enea usb-storage: queuecommand called
Jul 28 10:00:18 enea usb-storage: *** thread sleeping.
Jul 28 10:00:18 enea usb-storage: *** thread awakened.
Jul 28 10:00:18 enea usb-storage: Command READ_10 (10 bytes)
Jul 28 10:00:18 enea usb-storage:  28 00 00 3c 94 00 00 00 01 00
Jul 28 10:00:18 enea usb-storage: Bulk Command S 0x43425355 T 0x78 L 512 F 128 Trg 0 LUN 0 CL 10
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 31/31
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk command transfer result=0
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_sglist: xfer 512 bytes, 1 entries
Jul 28 10:00:18 enea usb-storage: Status code -32; transferred 0/512
Jul 28 10:00:18 enea usb-storage: clearing endpoint halt for pipe 0xc0008380
Jul 28 10:00:18 enea usb-storage: usb_stor_control_msg: rq=01 rqtype=02 value=0000 index=81 len=0
Jul 28 10:00:18 enea usb-storage: usb_stor_clear_halt: result = 0
Jul 28 10:00:18 enea usb-storage: Bulk data transfer result 0x2
Jul 28 10:00:18 enea usb-storage: Attempting to get CSW...
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 13/13
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk status result = 0
Jul 28 10:00:18 enea usb-storage: Bulk Status S 0x53425355 T 0x78 R 512 Stat 0x1
Jul 28 10:00:18 enea usb-storage: -- transport indicates command failure
Jul 28 10:00:18 enea usb-storage: -- unexpectedly short transfer
Jul 28 10:00:18 enea usb-storage: Issuing auto-REQUEST_SENSE
Jul 28 10:00:18 enea usb-storage: Bulk Command S 0x43425355 T 0x79 L 18 F 128 Trg 0 LUN 0 CL 6
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 31/31
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk command transfer result=0
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 18/18
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk data transfer result 0x0
Jul 28 10:00:18 enea usb-storage: Attempting to get CSW...
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 13/13
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk status result = 0
Jul 28 10:00:18 enea usb-storage: Bulk Status S 0x53425355 T 0x79 R 0 Stat 0x0
Jul 28 10:00:18 enea usb-storage: -- Result from auto-sense is 0
Jul 28 10:00:18 enea usb-storage: -- code: 0x70, key: 0x0, ASC: 0x0, ASCQ: 0x0
Jul 28 10:00:18 enea usb-storage: (Unknown Key): (unknown ASC/ASCQ)
Jul 28 10:00:18 enea usb-storage: scsi cmd done, result=0x2
Jul 28 10:00:18 enea sd 2:0:0:0: [sdb] Sense Key : 0x0 [current] 
Jul 28 10:00:18 enea sd 2:0:0:0: [sdb] ASC=0x0 ASCQ=0x0
Jul 28 10:00:18 enea usb-storage: queuecommand called
Jul 28 10:00:18 enea usb-storage: *** thread sleeping.
Jul 28 10:00:18 enea usb-storage: *** thread awakened.
Jul 28 10:00:18 enea usb-storage: Command READ_10 (10 bytes)
Jul 28 10:00:18 enea usb-storage:  28 00 00 3c 94 00 00 00 01 00
Jul 28 10:00:18 enea usb-storage: Bulk Command S 0x43425355 T 0x7a L 512 F 128 Trg 0 LUN 0 CL 10
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 31/31
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk command transfer result=0
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_sglist: xfer 512 bytes, 1 entries
Jul 28 10:00:18 enea usb-storage: Status code -32; transferred 0/512
Jul 28 10:00:18 enea usb-storage: clearing endpoint halt for pipe 0xc0008380
Jul 28 10:00:18 enea usb-storage: usb_stor_control_msg: rq=01 rqtype=02 value=0000 index=81 len=0
Jul 28 10:00:18 enea usb-storage: usb_stor_clear_halt: result = 0
Jul 28 10:00:18 enea usb-storage: Bulk data transfer result 0x2
Jul 28 10:00:18 enea usb-storage: Attempting to get CSW...
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 13/13
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk status result = 0
Jul 28 10:00:18 enea usb-storage: Bulk Status S 0x53425355 T 0x7a R 512 Stat 0x1
Jul 28 10:00:18 enea usb-storage: -- transport indicates command failure
Jul 28 10:00:18 enea usb-storage: -- unexpectedly short transfer
Jul 28 10:00:18 enea usb-storage: Issuing auto-REQUEST_SENSE
Jul 28 10:00:18 enea usb-storage: Bulk Command S 0x43425355 T 0x7b L 18 F 128 Trg 0 LUN 0 CL 6
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 31/31
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk command transfer result=0
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 18/18
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk data transfer result 0x0
Jul 28 10:00:18 enea usb-storage: Attempting to get CSW...
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 13/13
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk status result = 0
Jul 28 10:00:18 enea usb-storage: Bulk Status S 0x53425355 T 0x7b R 0 Stat 0x0
Jul 28 10:00:18 enea usb-storage: -- Result from auto-sense is 0
Jul 28 10:00:18 enea usb-storage: -- code: 0x70, key: 0x0, ASC: 0x0, ASCQ: 0x0
Jul 28 10:00:18 enea usb-storage: (Unknown Key): (unknown ASC/ASCQ)
Jul 28 10:00:18 enea usb-storage: scsi cmd done, result=0x2
Jul 28 10:00:18 enea sd 2:0:0:0: [sdb] Sense Key : 0x0 [current] 
Jul 28 10:00:18 enea sd 2:0:0:0: [sdb] ASC=0x0 ASCQ=0x0
Jul 28 10:00:18 enea usb-storage: queuecommand called
Jul 28 10:00:18 enea usb-storage: *** thread sleeping.
Jul 28 10:00:18 enea usb-storage: *** thread awakened.
Jul 28 10:00:18 enea usb-storage: Command READ_10 (10 bytes)
Jul 28 10:00:18 enea usb-storage:  28 00 00 3c 94 00 00 00 01 00
Jul 28 10:00:18 enea usb-storage: Bulk Command S 0x43425355 T 0x7c L 512 F 128 Trg 0 LUN 0 CL 10
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 31/31
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk command transfer result=0
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_sglist: xfer 512 bytes, 1 entries
Jul 28 10:00:18 enea usb-storage: Status code -32; transferred 0/512
Jul 28 10:00:18 enea usb-storage: clearing endpoint halt for pipe 0xc0008380
Jul 28 10:00:18 enea usb-storage: usb_stor_control_msg: rq=01 rqtype=02 value=0000 index=81 len=0
Jul 28 10:00:18 enea usb-storage: usb_stor_clear_halt: result = 0
Jul 28 10:00:18 enea usb-storage: Bulk data transfer result 0x2
Jul 28 10:00:18 enea usb-storage: Attempting to get CSW...
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 13/13
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk status result = 0
Jul 28 10:00:18 enea usb-storage: Bulk Status S 0x53425355 T 0x7c R 512 Stat 0x1
Jul 28 10:00:18 enea usb-storage: -- transport indicates command failure
Jul 28 10:00:18 enea usb-storage: -- unexpectedly short transfer
Jul 28 10:00:18 enea usb-storage: Issuing auto-REQUEST_SENSE
Jul 28 10:00:18 enea usb-storage: Bulk Command S 0x43425355 T 0x7d L 18 F 128 Trg 0 LUN 0 CL 6
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 31/31
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk command transfer result=0
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 18/18
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk data transfer result 0x0
Jul 28 10:00:18 enea usb-storage: Attempting to get CSW...
Jul 28 10:00:18 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
Jul 28 10:00:18 enea usb-storage: Status code 0; transferred 13/13
Jul 28 10:00:18 enea usb-storage: -- transfer complete
Jul 28 10:00:18 enea usb-storage: Bulk status result = 0
Jul 28 10:00:18 enea usb-storage: Bulk Status S 0x53425355 T 0x7d R 0 Stat 0x0
Jul 28 10:00:18 enea usb-storage: -- Result from auto-sense is 0
Jul 28 10:00:18 enea usb-storage: -- code: 0x70, key: 0x0, ASC: 0x0, ASCQ: 0x0
Jul 28 10:00:18 enea usb-storage: (Unknown Key): (unknown ASC/ASCQ)
Jul 28 10:00:18 enea usb-storage: scsi cmd done, result=0x2
Jul 28 10:00:18 enea sd 2:0:0:0: [sdb] Sense Key : 0x0 [current] 
Jul 28 10:00:18 enea sd 2:0:0:0: [sdb] ASC=0x0 ASCQ=0x0

...

Jul 28 10:00:27 enea sd 2:0:0:0: [sdb] Sense Key : 0x0 [current] 
Jul 28 10:00:27 enea sd 2:0:0:0: [sdb] ASC=0x0 ASCQ=0x0
Jul 28 10:00:27 enea usb-storage: queuecommand called
Jul 28 10:00:27 enea usb-storage: *** thread sleeping.
Jul 28 10:00:27 enea usb-storage: *** thread awakened.
Jul 28 10:00:27 enea usb-storage: Command READ_10 (10 bytes)
Jul 28 10:00:27 enea usb-storage:  28 00 00 3c 94 00 00 00 01 00
Jul 28 10:00:27 enea usb-storage: Bulk Command S 0x43425355 T 0xae2 L 512 F 128 Trg 0 LUN 0 CL 10
Jul 28 10:00:27 enea usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
Jul 28 10:00:27 enea usb-storage: Status code 0; transferred 31/31
Jul 28 10:00:27 enea usb-storage: -- transfer complete
Jul 28 10:00:27 enea usb-storage: Bulk command transfer result=0
Jul 28 10:00:27 enea usb-storage: usb_stor_bulk_transfer_sglist: xfer 512 bytes, 1 entries
Jul 28 10:00:27 enea usb-storage: Status code -32; transferred 0/512
Jul 28 10:00:27 enea usb-storage: clearing endpoint halt for pipe 0xc0008380
Jul 28 10:00:27 enea usb-storage: usb_stor_control_msg: rq=01 rqtype=02 value=0000 index=81 len=0
Jul 28 10:00:27 enea usb-storage: usb_stor_clear_halt: result = -71
Jul 28 10:00:27 enea usb-storage: Bulk data transfer result 0x4
Jul 28 10:00:27 enea usb-storage: -- transport indicates error, resetting
Jul 28 10:00:27 enea usb-storage: storage_pre_reset
Jul 28 10:00:27 enea usb 1-1: USB disconnect, address 3
Jul 28 10:00:27 enea usb-storage: storage_post_reset
Jul 28 10:00:27 enea usb-storage: usb_reset_device returns -19
Jul 28 10:00:27 enea usb-storage: storage_disconnect() called
Jul 28 10:00:27 enea usb-storage: -- usb_stor_release_resources
Jul 28 10:00:27 enea usb-storage: -- sending exit command to thread
Jul 28 10:00:27 enea usb-storage: usb_stor_Bulk_reset called
Jul 28 10:00:27 enea usb-storage: No reset during disconnect
Jul 28 10:00:27 enea usb-storage: scsi cmd done, result=0x70000
Jul 28 10:00:27 enea scsi 2:0:0:0: [sdb] Result: hostbyte=0x01 driverbyte=0x00
Jul 28 10:00:27 enea end_request: I/O error, dev sdb, sector 3970048
Jul 28 10:00:27 enea Buffer I/O error on device sdb, logical block 3970048
Jul 28 10:00:27 enea Buffer I/O error on device sdb, logical block 3970048
Jul 28 10:00:27 enea Buffer I/O error on device sdb, logical block 3970040
Jul 28 10:00:27 enea Buffer I/O error on device sdb, logical block 3970041
Jul 28 10:00:27 enea Buffer I/O error on device sdb, logical block 3970042
Jul 28 10:00:27 enea Buffer I/O error on device sdb, logical block 3970043
Jul 28 10:00:27 enea Buffer I/O error on device sdb, logical block 3970044
Jul 28 10:00:27 enea Buffer I/O error on device sdb, logical block 3970045
Jul 28 10:00:27 enea Buffer I/O error on device sdb, logical block 3970046
Jul 28 10:00:27 enea Buffer I/O error on device sdb, logical block 3970047
Jul 28 10:00:27 enea usb-storage: *** thread sleeping.
Jul 28 10:00:27 enea usb-storage: *** thread awakened.
Jul 28 10:00:27 enea usb-storage: -- exiting
Jul 28 10:00:27 enea usb-storage: -- dissociate_dev
Jul 28 10:00:27 enea NetworkManager: <debug> [1217232027.907186] nm_hal_device_removed(): Device removed (hal udi is '/org/freedesktop/Hal/devices/usb_device_421_4b9_359815013364896_if0_scsi_host_scsi_device_lun0').
Jul 28 10:00:27 enea NetworkManager: <debug> [1217232027.908046] nm_hal_device_removed(): Device removed (hal udi is '/org/freedesktop/Hal/devices/usb_device_421_4b9_359815013364896_if0_scsi_host').
Jul 28 10:00:27 enea NetworkManager: <debug> [1217232027.933966] nm_hal_device_removed(): Device removed (hal udi is '/org/freedesktop/Hal/devices/usb_device_421_4b9_359815013364896_if0').
Jul 28 10:00:27 enea NetworkManager: <debug> [1217232027.970705] nm_hal_device_removed(): Device removed (hal udi is '/org/freedesktop/Hal/devices/usb_device_421_4b9_359815013364896_usbraw').
Jul 28 10:00:27 enea NetworkManager: <debug> [1217232027.981298] nm_hal_device_removed(): Device removed (hal udi is '/org/freedesktop/Hal/devices/usb_device_421_4b9_359815013364896').
Jul 28 10:00:32 enea acpid: received event "thermal_zone TZ1 00000081 00000000"
Jul 28 10:00:32 enea acpid: notifying client 2217[102:408]
Jul 28 10:00:32 enea acpid: notifying client 2305[0:0]
Jul 28 10:00:32 enea acpid: executing action "/etc/acpi/default.sh thermal_zone TZ1 00000081 00000000"
Jul 28 10:00:32 enea logger: ACPI event unhandled: thermal_zone TZ1 00000081 00000000
Jul 28 10:00:32 enea acpid: action exited with status 0
Jul 28 10:00:32 enea acpid: completed event "thermal_zone TZ1 00000081 00000000"


--------------030001020705060501040203--
