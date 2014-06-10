From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCHv4 0/6]  Support 64-bit LUNs
Date: Tue, 10 Jun 2014 19:58:17 +0200
Message-ID: <53974739.8070303@acm.org>
References: <1401785937-43581-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from albert.telenet-ops.be ([195.130.137.90]:38331 "EHLO
	albert.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751888AbaFJR6T (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Jun 2014 13:58:19 -0400
In-Reply-To: <1401785937-43581-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@infradead.org>, Ewan Milne <emilne@redhat.com>, linux-scsi@vger.kernel.org

On 06/03/14 10:58, Hannes Reinecke wrote:
> this patchset updates the SCSI stack to support full 64-bit LUNs.
> The first patch is a simple fix; the next patch updates
> the sequential scan logic to be compliant with SPC.
> The third patch addresses a firmware issue with earlier
> qla2xxx HBAs.
> The next two patches update the SCSI stack and all drivers
> to use 64-bit LUNs where appropriate.
> And finally we need to update the conversion routines
> scsilun_to_int to cope with 64bit LUNs.
> 
> Two drivers have issues with 64bit LUNs:
> - The qla2xxx driver uses a 32-bit LUN value for TMFs.
>   But as the driver uses a max_lun value from 0xFFFF
>   we should be safe for the time being.
> - The zfcp driver uses a 32-bit LUN for debug records; the
>   record format would need to be updated to cope with
>   64-bit LUNs. But again, this driver uses 0xFFFFFFFF
>   for max_lun, so it doesn't do any harm.
> 
> The other changes have been pretty straightforward.

Hello Hannes,

Many SCSI LLD's use int_to_scsilun() in the hot path (queuecommand()).
This patch series makes the int_to_scsilun() function slightly more
expensive. Has it been considered to cache the result of int_to_scsilun()
such that LLD's can copy the cached int_to_scsilun() result instead of
having to call int_to_scsilun() in the queuecommand() function ?
Something like the (untested) patch below might be sufficient:

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index e02b3aa..9e50d78 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -244,6 +244,7 @@ static struct scsi_device *scsi_alloc_sdev(struct scsi_target *starget,
 	sdev->queue_ramp_up_period = SCSI_DEFAULT_RAMP_UP_PERIOD;
 	sdev->id = starget->id;
 	sdev->lun = lun;
+	int_to_scsilun(lun, &sdev->scsi_lun);
 	sdev->channel = starget->channel;
 	sdev->sdev_state = SDEV_CREATED;
 	INIT_LIST_HEAD(&sdev->siblings);
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 5853c91..48ea68e 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -100,6 +100,8 @@ struct scsi_device {
 
 	unsigned int id, lun, channel;
 
+	struct scsi_lun scsi_lun;	/* int_to_scsilun(lun) */
+
 	unsigned int manufacturer;	/* Manufacturer of device, for using 
 					 * vendor-specific cmd's */
 	unsigned sector_size;	/* size in bytes */

Thanks,

Bart.
