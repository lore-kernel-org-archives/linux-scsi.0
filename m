From: Heiko Carstens <Heiko.Carstens@de.ibm.com>
Subject: Re: Stack overflow when lldd returns SCSI_MLQUEUE_DEVICE_BUSY
Date: Wed, 19 May 2004 17:09:21 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <OF22748B6C.BE9F273F-ONC1256E99.005228D8-C1256E99.00535E43@de.ibm.com>
References: <1084916831.2101.56.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate2.de.ibm.com ([195.212.29.151]:63616 "EHLO
	mtagate2.de.ibm.com") by vger.kernel.org with ESMTP id S264231AbUESPJ2
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 May 2004 11:09:28 -0400
In-Reply-To: <1084916831.2101.56.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

> > I just experienced a stack overflow (see below for part of the call 
trace)
> > when an lldd returns SCSI_MLQUEUE_DEVICE_BUSY. Problem seems to be 
that
> > scsi_dispatch_cmd calls scsi_queue_insert if the LLDD queuecommand 
function
> > failed.
>
> Could you do some more debugging...there's something wierd going on
> here.  a SCSI_MLQUEUE_DEVICE_BUSY return sets device_blocked.  As long
> as sdev->max_device_blocked is two or more, this should cause an exit
> from the next scsi_request_fn() (at the if(!req ||
> !scsi_dev_queue_ready(q, sdev))

This happened when sending out the inquiry command and the LLDD was in
recovery for the specific LUN and returned SCSI_MLQUEUE_DEVICE_BUSY.
Problem is that max_device_blocked gets set _after_ the inquiry command
finished. In this specific case max_device_blocked was 0 and thus the
device was never blocked resulting in the observed stack overflow.
I moved the initializazion of max_device_blocked from scsi_add_lun to
sdev_alloc_sdev and the problem is gone. See patch below.
Thanks for pointing out where to look at!

diff -u -r1.44 scsi_scan.c
--- scsi_scan.c 10 May 2004 09:21:32 -0000      1.44
+++ scsi_scan.c 19 May 2004 14:54:19 -0000
@@ -212,6 +212,10 @@
        INIT_LIST_HEAD(&sdev->starved_entry);
        spin_lock_init(&sdev->list_lock);
 
+       /* if the device needs this changing, it may do so in the detect
+        * function */
+       sdev->max_device_blocked = SCSI_DEFAULT_DEVICE_BLOCKED;
+
        /*
         * Some low level driver could use device->type
         */
@@ -626,10 +630,6 @@
                sdev->sdev_target = starget;
                spin_unlock_irqrestore(sdev->host->host_lock, flags);
        }
-
-       /* if the device needs this changing, it may do so in the detect
-        * function */
-       sdev->max_device_blocked = SCSI_DEFAULT_DEVICE_BLOCKED;
 
        sdev->use_10_for_rw = 1;
 
