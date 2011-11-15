From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] mpt2sas: Fix for data corruption issue in the routine
 sd_prep_fn
Date: Tue, 15 Nov 2011 11:03:06 -0600
Message-ID: <1321376586.3021.47.camel@dabdike.int.hansenpartnership.com>
References: <201111151447.pAFElZhR029655@milmhbs0.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:51327 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755169Ab1KORDJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Nov 2011 12:03:09 -0500
In-Reply-To: <201111151447.pAFElZhR029655@milmhbs0.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: nagalakshmi.nandigama@lsi.com
Cc: linux-scsi@vger.kernel.org, kashyap.desai@lsi.com, Eric.Moore@lsi.com

On Tue, 2011-11-15 at 14:11 +0530, nagalakshmi.nandigama@lsi.com wrote:
> Fix for data corruption issue in the routine sd_prep_fn which can
> occur for 4kb sector support.
> 
> The issue is that, the routine sd_prep_fn is sharing the same parameter called
> this_count for setting the LBA count and the underflow. When this routine
> converts this_count so the LBA count is in 4kb units, it is not converted back 
> to 512 bytes units when setting the underflow. Thus underflow is off by a 
> multiple of 8.   
> 
> This patch will set the underflow to the data transfer size in bytes.
> 
> Signed-off-by: Nagalakshmi Nandigama <nagalakshmi.nandigama@lsi.com>
> Cc: stable@kernel.org
> ---
> 
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c 
> index fa3a591..3c4ad14 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -895,7 +895,7 @@ static int sd_prep_fn(struct request_queue *q, struct request *rq)
>  	 * this many bytes between each connect / disconnect.
>  	 */
>  	SCpnt->transfersize = sdp->sector_size;
> -	SCpnt->underflow = this_count << 9;
> +	SCpnt->underflow = blk_rq_bytes(rq);
>  	SCpnt->allowed = SD_MAX_RETRIES;

Actually if we're going to do this, let's get rid of the multiplication
in the fast path too.

James

---

diff --git a/drivers/s390/scsi/zfcp_scsi.c b/drivers/s390/scsi/zfcp_scsi.c
index 11f07f8..4008ec0 100644
--- a/drivers/s390/scsi/zfcp_scsi.c
+++ b/drivers/s390/scsi/zfcp_scsi.c
@@ -55,8 +55,10 @@ static void zfcp_scsi_slave_destroy(struct scsi_device *sdev)
 {
 	struct zfcp_scsi_dev *zfcp_sdev = sdev_to_zfcp(sdev);
 
-	zfcp_erp_lun_shutdown_wait(sdev, "scssd_1");
-	put_device(&zfcp_sdev->port->dev);
+	if (zfcp_sdev->port) {
+		zfcp_erp_lun_shutdown_wait(sdev, "scssd_1");
+		put_device(&zfcp_sdev->port->dev);
+	}
 }
 
 static int zfcp_scsi_slave_configure(struct scsi_device *sdp)
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 72273a0..b3c6d95 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -319,11 +319,7 @@ static struct scsi_device *scsi_alloc_sdev(struct scsi_target *starget,
 	return sdev;
 
 out_device_destroy:
-	scsi_device_set_state(sdev, SDEV_DEL);
-	transport_destroy_device(&sdev->sdev_gendev);
-	put_device(&sdev->sdev_dev);
-	scsi_free_queue(sdev->request_queue);
-	put_device(&sdev->sdev_gendev);
+	__scsi_remove_device(sdev);
 out:
 	if (display_failure_msg)
 		printk(ALLOC_FAILURE_MSG, __func__);
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index fa3a591..ee573f2 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -883,7 +883,7 @@ static int sd_prep_fn(struct request_queue *q, struct request *rq)
 		SCpnt->cmnd[4] = (unsigned char) this_count;
 		SCpnt->cmnd[5] = 0;
 	}
-	SCpnt->sdb.length = this_count * sdp->sector_size;
+	SCpnt->underflow = SCpnt->sdb.length = blk_rq_bytes(rq);
 
 	/* If DIF or DIX is enabled, tell HBA how to handle request */
 	if (host_dif || scsi_prot_sg_count(SCpnt))
@@ -895,7 +895,6 @@ static int sd_prep_fn(struct request_queue *q, struct request *rq)
 	 * this many bytes between each connect / disconnect.
 	 */
 	SCpnt->transfersize = sdp->sector_size;
-	SCpnt->underflow = this_count << 9;
 	SCpnt->allowed = SD_MAX_RETRIES;
 
 	/*


