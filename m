From: David.Egolf@Bull.com
Subject: Re: Should sd REALLY allocate a device for an offline device
Date: Fri, 14 Mar 2003 11:17:00 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <OFEEEF4A4F.394B27B7-ON07256CE9.005E71D9-07256CE9.00646ECB@az05.bull.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Steve Brueggeman <xioborg@yahoo.com>
Cc: linux-scsi@vger.kernel.org, linux-scsi-owner@vger.kernel.org

Larger systems and servers work with intelligent disk arrays that provide 
various schemes for dynamic hardware mirroring.  For example, EMC 
Symmetrix Cached Disk Arrays have a feature called TimeFinder.  It allows 
the disk array to copy disk contents to other volumes in the disk array. 
When the mirrors are split apart, the copies are brought online to some 
system where they can be used for saves or data warehouse type access. 
While the mirrors are being copied, they are "offline" on their channels. 
A similar situation exists for mirrors which are maintained for disaster 
recovery purposes.  I know that EMC, Hitachi Data Systems, and others 
provide such features.

The "offline" devices can be in any particular state during a system boot. 
 They can go online and offline multiple times a day.





Steve Brueggeman <xioborg@yahoo.com>
Sent by: linux-scsi-owner@vger.kernel.org
03/14/2003 09:50 AM

 
        To:     linux-scsi@vger.kernel.org
        cc: 
        Subject:        Should sd REALLY allocate a device for an offline device



>There's a managed storage device that reports 0x20 in byte 0 of the
>Inquiry data, which means it's a SCSI_DISK, but the LUN is detached.
>
>scan_scsis_single() acknowledgs this, and marks the device as not
>online, and lets the upper level device drivers decide what to do.
>
>It is my belief that if a device is not online, the scsi disk driver
>should not allocate a device slot for it.  See the following simple
>patch.  Any thoughts?  It seems obvious to me, but maybe I'm missing
>something.
>
>diff -ruN -X dontdiff linux-2.4.20.orig/drivers/scsi/sd.c
>linux-2.4.20.new/drivers/scsi/sd.c
>--- linux-2.4.20.orig/drivers/scsi/sd.c                 Fri Aug  2 
19:39:44 2002
>+++ linux-2.4.20.new/drivers/scsi/sd.c          Fri Mar 14 10:26:32 2003
>@@ -1264,6 +1264,8 @@
> {
>                if (SDp->type != TYPE_DISK && SDp->type != TYPE_MOD)
>                                return 0;
>+               if (!SDp->online)
>+                               return 0;
>                sd_template.dev_noticed++;
>                return 1;
> }
>@@ -1276,6 +1278,8 @@
>                char nbuff[6];
> 
>                if (SDp->type != TYPE_DISK && SDp->type != TYPE_MOD)
>+                               return 0;
>+               if (!SDp->online)
>                                return 0;
> 
>                if (sd_template.nr_dev >= sd_template.dev_max || 
rscsi_disks
>== NULL) {
>
>
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html



