From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: [PATCH] (was Re: [Q] scsi_adjust_queue_depth(SDp, 0, SDp->host->cmd_per_lun);
 needed?)
Date: Wed, 13 Oct 2004 22:04:25 +0200 (CEST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.60.0410132200090.3426@poirot.grange>
References: <Pine.LNX.4.60.0407252205240.5555@poirot.grange>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pop.gmx.de ([213.165.64.20]:12270 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S269811AbUJMUG3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 Oct 2004 16:06:29 -0400
In-Reply-To: <Pine.LNX.4.60.0407252205240.5555@poirot.grange>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-scsi@vger.kernel.org, linux@advansys.com

On Sun, 25 Jul 2004, Guennadi Liakhovetski wrote:

> A question: are calls like the one in
> 
> 53c700.c::
> 	NCR_700_slave_configure()
> 		scsi_adjust_queue_depth(SDp, 0, SDp->host->cmd_per_lun);
> 
> really needed? Isn't the call in

Ok, I'll (try to) assume they aren't:

diff -u -r1.1.1.3 advansys.c
--- a/drivers/scsi/advansys.c	17 Aug 2004 20:34:48
+++ b/drivers/scsi/advansys.c	13 Oct 2004 19:44:32
@@ -6131,8 +6131,6 @@
 	    scsi_adjust_queue_depth(device, MSG_ORDERED_TAG,
                 boardp->dvc_var.adv_dvc_var.max_dvc_qng);
         }
-    } else {
-	scsi_adjust_queue_depth(device, 0, device->host->cmd_per_lun);
     }
     ASC_DBG4(1, "advansys_slave_configure: device 0x%lx, boardp 0x%lx, id %d, depth %d\n",
             (ulong) device, (ulong) boardp, device->id, device->queue_depth);
diff -u -r1.1.1.4 53c700.c
--- a/drivers/scsi/53c700.c	17 Aug 2004 20:34:46
+++ b/drivers/scsi/53c700.c	13 Oct 2004 19:48:19
@@ -2052,9 +2052,6 @@
 	/* to do here: allocate memory; build a queue_full list */
 	if(SDp->tagged_supported) {
 		/* do TCQ stuff here */
-	} else {
-		/* initialise to default depth */
-		scsi_adjust_queue_depth(SDp, 0, SDp->host->cmd_per_lun);
 	}
 	if(hostdata->fast) {
 		/* Find the correct offset and period via domain validation */
diff -u -r1.1.1.4 aic7xxx_old.c
--- a/drivers/scsi/aic7xxx_old.c	17 Aug 2004 20:34:41
+++ b/drivers/scsi/aic7xxx_old.c	13 Oct 2004 19:56:07
@@ -6722,7 +6722,6 @@
             p->host_no, device->channel, device->id,
             device->lun, device->host->cmd_per_lun);
     }
-    scsi_adjust_queue_depth(device, 0, device->host->cmd_per_lun);
   }
   return;
 }

Thanks
Guennadi
---
Guennadi Liakhovetski

