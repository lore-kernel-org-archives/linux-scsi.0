From: "Mukker, Atul" <Atulm@lsil.com>
Subject: RE: [PATCH] megaraid2 bad queuecommand return
Date: Fri, 19 Nov 2004 09:40:07 -0500
Message-ID: <0E3FA95632D6D047BA649F95DAB60E570562CAF1@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:60589 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S261430AbUKSOk0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 19 Nov 2004 09:40:26 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Jens Axboe' <axboe@suse.de>, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, 'James Bottomley' <James.Bottomley@steeleye.com>

Linux/Documentation/scsi/scsi_mid_low_api.txt

"
...
/**
 *      queuecommand - queue scsi command, invoke 'done' on completion
 *      @scp: pointer to scsi command object
 *      @done: function pointer to be invoked on completion
...
 *
 *      Returns 0 on success.
 *
 *      If there's a failure, return either:
 *
 *      SCSI_MLQUEUE_DEVICE_BUSY if the device queue is full, or
 *      SCSI_MLQUEUE_HOST_BUSY if the entire host queue is full
 *
 *      On both of these returns, the mid-layer will requeue the I/O
...
"

So the driver should set the if_busy flag to SCSI_MLQUEUE_DEVICE_BUSY or
SCSI_MLQUEUE_HOST_BUSY (this is appropriate in this case) instead of setting
it to 1, isn't it?

So, the following seems more appropriate

--- megaraid_mbox.c     2004-09-27 22:14:43.000000000 -0400
+++ megaraid_mbox.c.mod 2004-11-19 12:15:21.776345776 -0500
@@ -1675,7 +1675,7 @@

                        if (!(scb = megaraid_alloc_scb(adapter, scp))) {
                                scp->result = (DID_ERROR << 16);
-                               *busy = 1;
+                               *busy = SCSI_MLQUEUE_HOST_BUSY;
                                return NULL;
                        }

@@ -1757,7 +1757,7 @@
                        /* Allocate a SCB and initialize passthru */
                        if (!(scb = megaraid_alloc_scb(adapter, scp))) {
                                scp->result = (DID_ERROR << 16);
-                               *busy = 1;
+                               *busy = SCSI_MLQUEUE_HOST_BUSY;
                                return NULL;
                        }

@@ -1802,7 +1802,7 @@
                         */
                        if (!(scb = megaraid_alloc_scb(adapter, scp))) {
                                scp->result = (DID_ERROR << 16);
-                               *busy = 1;
+                               *busy = SCSI_MLQUEUE_HOST_BUSY;
                                return NULL;
                        }
                        ccb                     = (mbox_ccb_t *)scb->ccb;
@@ -1898,7 +1898,7 @@
                         */
                        if (!(scb = megaraid_alloc_scb(adapter, scp))) {
                                scp->result = (DID_ERROR << 16);
-                               *busy = 1;
+                               *busy = SCSI_MLQUEUE_HOST_BUSY;
                                return NULL;
                        }

@@ -1966,7 +1966,7 @@
                // Allocate a SCB and initialize passthru
                if (!(scb = megaraid_alloc_scb(adapter, scp))) {
                        scp->result = (DID_ERROR << 16);
-                       *busy = 1;
+                       *busy = SCSI_MLQUEUE_HOST_BUSY;
                        return NULL;
                }

Thanks
-Atul Mukker
Architect, Drivers and BIOS
LSI Logic Corporation 




> -----Original Message-----
> From: Jens Axboe [mailto:axboe@suse.de] 
> Sent: Friday, November 19, 2004 4:01 AM
> To: linux-scsi@vger.kernel.org; James Bottomley
> Subject: [PATCH] megaraid2 bad queuecommand return
> 
> Hi,
> 
> If the command is already completed, megaraid_queue_command() 
> must return 0.
> 
> Signed-off-by: Jens Axboe <axboe@suse.de>
> 
> ===== drivers/scsi/megaraid/megaraid_mbox.c 1.9 vs edited =====
> --- 1.9/drivers/scsi/megaraid/megaraid_mbox.c	2004-10-08 
> 17:12:09 +02:00
> +++ edited/drivers/scsi/megaraid/megaraid_mbox.c	
> 2004-11-18 23:12:10 +01:00
> @@ -1623,6 +1623,7 @@ megaraid_queue_command(struct scsi_cmnd 
>  
>  	if (!scb) {	// command already completed
>  		done(scp);
> +		return 0;
>  	}
>  
>  	return if_busy;
> 
> --
> Jens Axboe
> 
> -
> To unsubscribe from this list: send the line "unsubscribe 
> linux-scsi" in the body of a message to 
> majordomo@vger.kernel.org More majordomo info at  
> http://vger.kernel.org/majordomo-info.html
> 
