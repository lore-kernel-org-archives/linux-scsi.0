From: Aleksey Nogin <aleksey@nogin.org>
Subject: Re: [linux-usb-devel] Numerous problems, partial success getting
 FujiFilm Finepix 3800 to work under 2.6.
Date: Tue, 20 Apr 2004 22:00:51 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <40860003.1070406@nogin.org>
References: <Pine.LNX.4.44L0.0404201527310.1247-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from charter-242-037.caltech.edu ([131.215.242.37]:46720 "EHLO
	dell.nogin.org") by vger.kernel.org with ESMTP id S264877AbUDUFBH
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Apr 2004 01:01:07 -0400
In-Reply-To: <Pine.LNX.4.44L0.0404201527310.1247-100000@ida.rowland.org>
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: USB development list <linux-usb-devel@lists.sourceforge.net>, SCSI development list <linux-scsi@vger.kernel.org>

Thanks a lot for your feedback. Unfortunately, your patch does not seem 
to affect anything.

To find out what exactly happens around the code you suggested patching, 
I added couple more SCSI_LOG_SCAN_BUS statements (marked "an1" and "an2" 
below) and turned on the SCSI_LOG_SCAN_BUS reporting.

The relevant part of scsi_scan.c now looks as follows:

...
        SCSI_LOG_SCAN_BUS(3, printk(KERN_INFO "scsi scan: 1st INQUIRY %s 
with"
          " code 0x%x\n", sreq->sr_result ?
          "failed" : "successful", sreq->sr_result));

    SCSI_LOG_SCAN_BUS(3, printk(KERN_INFO "scsi scan (an1): 0x%x 0x%x 
0x%x 0x%x\n", driver_byte(sreq->sr_result), sreq->sr_sense_buffer[2], 
sreq->sr_sense_buffer[12], sreq->sr_sense_buffer[13]));

    if (sreq->sr_result) {
       if ((driver_byte(sreq->sr_result) & DRIVER_SENSE) != 0 &&
           (sreq->sr_sense_buffer[2] & 0xf) == UNIT_ATTENTION &&
           (sreq->sr_sense_buffer[12] == 0x28 ||
                      sreq->sr_sense_buffer[12] == 0x29) &&
           sreq->sr_sense_buffer[13] == 0) {
          /* not-ready to ready transition or power-on - good */
          /* dpg: bogus? INQUIRY never returns UNIT_ATTENTION */
          /* Supposedly, but many buggy devices do so anyway  */
       } else
          /*
           * assume no peripheral if any other sort of error
           */
          return;
    }

    /*
     * Get any flags for this device.
     *
     * XXX add a bflags to Scsi_Device, and replace the corresponding
     * bit fields in Scsi_Device, so bflags need not be passed as an
     * argument.
     */
    *bflags |= scsi_get_device_flags(sdev, &inq_result[8], &inq_result[16]);

    possible_inq_resp_len = (unsigned char) inq_result[4] + 5;

    SCSI_LOG_SCAN_BUS(3, printk(KERN_INFO "scsi scan (an2): %i 0x%x\n", 
possible_inq_resp_len, *bflags));;

    if (BLIST_INQUIRY_36 & *bflags)
...

In the logs I now se

Initializing USB Mass Storage driver...
usb-storage: USB Mass Storage device detected
usb-storage: altsetting is 0, id_index is 112
usb-storage: -- associate_dev
usb-storage: Transport: Control/Bulk/Interrupt
usb-storage: Protocol: 8070i
usb-storage: Endpoints: In: 0x1c39d2f8 Out: 0x1c39d30c Int: 0x1c39d320 
(Period 1)
usb-storage: *** thread sleeping.
Wake up parent of scsi_eh_0
Error handler scsi_eh_0 sleeping
scsi0 : SCSI emulation for USB Mass Storage devices
scsi_scan_host_selected: <0:4294967295:4294967295:4294967295>
scsi scan: INQUIRY to host 0 channel 0 id 0 lun 0
scsi_add_timer: scmd: 0372bc24, time: 6000, (22a9e255)
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Command INQUIRY (6 bytes)
usb-storage:  12 00 00 00 24 00
usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 
len=12
usb-storage: Status code 0; transferred 12/12
usb-storage: -- transfer complete
usb-storage: Call to usb_stor_ctrl_transfer() returned 0
usb-storage: usb_stor_bulk_transfer_buf: xfer 36 bytes
usb-storage: Status code 0; transferred 36/36
usb-storage: -- transfer complete
usb-storage: CBI data stage result is 0x0
usb-storage: usb_stor_intr_transfer: xfer 2 bytes
usb-storage: Status code 0; transferred 2/2
usb-storage: -- transfer complete
usb-storage: Got interrupt data (0x29, 0x0)
usb-storage: CBI IRQ data showed reserved bType 0x29
usb-storage: usb_stor_control_msg: rq=01 rqtype=02 value=0000 index=81 len=0
usb-storage: usb_stor_clear_halt: result = 0
usb-storage: -- transport indicates command failure
usb-storage: Issuing auto-REQUEST_SENSE
usb-storage: usb_stor_ctrl_transfer: rq=00 rqtype=21 value=0000 index=00 
len=12
usb-storage: Status code 0; transferred 12/12
usb-storage: -- transfer complete
usb-storage: Call to usb_stor_ctrl_transfer() returned 0
usb-storage: usb_stor_bulk_transfer_buf: xfer 18 bytes
usb-storage: Status code 0; transferred 18/18
usb-storage: -- transfer complete
usb-storage: CBI data stage result is 0x0
usb-storage: usb_stor_intr_transfer: xfer 2 bytes
usb-storage: Status code 0; transferred 2/2
usb-storage: -- transfer complete
usb-storage: Got interrupt data (0x0, 0x0)
usb-storage: -- Result from auto-sense is 0
usb-storage: -- code: 0x70, key: 0x6, ASC: 0x29, ASCQ: 0x0
usb-storage: Unit Attention: Power on, reset, or bus device reset occurred
usb-storage: scsi cmd done, result=0x2
scsi_delete_timer: scmd: 0372bc24, rtn: 1
usb-storage: *** thread sleeping.
scsi scan: 1st INQUIRY failed with code 0x8000002
scsi scan (an1): 0x8 0x6 0x29 0x0
scsi scan (an2): 36 0xe000
scsi scan: INQUIRY to host 0 channel 0 id 1 lun 0
scsi_add_timer: scmd: 0372bc24, time: 6000, (22a9e255)
usb-storage: queuecommand called
usb-storage: *** thread awakened.
usb-storage: Bad target number (1:0)
...


On 20.04.2004 12:41, Alan Stern wrote:

> That much is fairly normal.  Your camera should not have replied with Unit 
> Attention status to the INQUIRY command, but it's a fairly common mistake.  
> The SCSI core wasn't expecting it, though, and as a result believed your 
> camera was an invalid device.  That's why you couldn't use it.
> 
> 
>>usb-storage: queuecommand called
>>usb-storage: *** thread awakened.
>>usb-storage: Bad target number (1:0)
>>usb-storage: scsi cmd done, result=0x40000
>>usb-storage: *** thread sleeping.
> 
> 
> As you can see, instead of repeating the INQUIRY command the SCSI driver 
> moved on to the next target.
> 
> This patch may improve things.  Try it, with nothing added to
> unusual_devs.h, and see if it works even with an external hub.
> 
> Alan Stern
> 
> 
> 
> ===== scsi_scan.c 1.57 vs edited =====
> --- 1.57/drivers/scsi/scsi_scan.c	Wed Mar 17 14:05:26 2004
> +++ edited/drivers/scsi/scsi_scan.c	Tue Apr 20 15:35:52 2004
> @@ -355,10 +355,12 @@
>  	if (sreq->sr_result) {
>  		if ((driver_byte(sreq->sr_result) & DRIVER_SENSE) != 0 &&
>  		    (sreq->sr_sense_buffer[2] & 0xf) == UNIT_ATTENTION &&
> -		    sreq->sr_sense_buffer[12] == 0x28 &&
> +		    (sreq->sr_sense_buffer[12] == 0x28 ||
> +		     sreq->sr_sense_buffer[12] == 0x29) &&
>  		    sreq->sr_sense_buffer[13] == 0) {
> -			/* not-ready to ready transition - good */
> +			/* not-ready to ready transition or power-on - good */
>  			/* dpg: bogus? INQUIRY never returns UNIT_ATTENTION */
> +			/* Supposedly, but many buggy devices do so anyway */
>  		} else
>  			/*
>  			 * assume no peripheral if any other sort of error
> 

-- 
Aleksey Nogin

Home Page: http://nogin.org/
E-Mail: nogin@cs.caltech.edu (office), aleksey@nogin.org (personal)
Office: Jorgensen 70, tel: (626) 395-2907

