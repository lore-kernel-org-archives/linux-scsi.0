From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: T10 WCE interpretation in Linux & device level access
Date: Wed, 24 Apr 2013 14:57:38 +0200
Message-ID: <5177D6C2.6080705@redhat.com>
References: <5176E3E8.3000809@redhat.com> <1366747622.1939.6.camel@dabdike> <5177BF53.3040305@redhat.com> <5177CAF5.6060506@suse.de> <5177CB23.5090802@redhat.com> <5177CFB6.9070105@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51138 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753254Ab3DXM6D (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Apr 2013 08:58:03 -0400
In-Reply-To: <5177CFB6.9070105@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ric Wheeler <rwheeler@redhat.com>
Cc: Hannes Reinecke <hare@suse.de>, James Bottomley <James.Bottomley@HansenPartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Martin K. Petersen" <mkp@mkp.net>, Jeff Moyer <jmoyer@redhat.com>, Tejun Heo <tj@kernel.org>, Mike Snitzer <snitzer@redhat.com>, "Black, David" <david.black@emc.com>, "Elliott, Robert (Server Storage)" <Elliott@hp.com>, "Knight, Frederick" <Frederick.Knight@netapp.com>

Il 24/04/2013 14:27, Ric Wheeler ha scritto:
>> The point is to _avoid_ hitting the disk. :)
> 
> The point is to have a crash-proof version of the data acknowledged by
> the target device while letting data sit in volatile state as long as
> possible. To be even clearer, we would love to do this for a sub-range
> of the device but currently use a "big hammer" to flush the entire cache
> (possibly for multiple file systems on one target storage device).
> 
> Once we use the SYNCHRONIZE_CACHE (or CACHE_FLUSH_EXT) command, we want
> the data on that target device to be there if someone loses power.
> 
> If the device can promise this, we don't care (and don't know) how it
> manages that promise. It can leave the data on battery backed DRAM, can
> archive it to flash or any other scheme that works.

That's exactly the point of SYNC_NV=1.

> Just as importantly, we don't want to "destage" data to the back end
> drives if that is not required since it is really, really slow.
> 
> The confusion here is that various storage devices have used the
> standard bits in arbitrary ways which makes it very hard to have one
> clear set of rules.

Also that we have ignored the problem for long, and it's worked
surprisingly well. :)

> Even harder to explain to end users when to use a work around (like
> mount -o nobarrier) or the proposed "ignore flushes" block level call :)

Hoping Thunderbird doesn't mangle the patch too badly, code might be
worth a thousand words... see after the sig, compile-tested only.  I have
no access to these controllers, neither the good ones nor the bad ones. :)

Paolo

--------------------- 8< -------------------------
From: Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH] scsi: only make REQ_FLUSH flush to non-volatile cache

The point of REQ_FLUSH is to have a crash-proof version of the data
acknowledged by the target device.  We want the data on that target
device to be there if someone loses power, but we don't care (and don't
want to know) how it manages that promise.  It can leave the data on
battery backed DRAM, can archive it to flash or any other scheme that
works.

This is exactly what SYNC_NV=1 does.  Instead, SYNC_NV=0 should flush
the data to the medium, which is not desirable when we have a non-volatile
cache (except perhaps if the medium is removable).

NOT-Tested-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 7992635..97ecfd9 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -800,9 +800,17 @@ static int sd_setup_write_same_cmnd(struct scsi_device *sdp, struct request *rq)
 
 static int scsi_setup_flush_cmnd(struct scsi_device *sdp, struct request *rq)
 {
+	struct scsi_disk *sdkp = scsi_disk(rq->rq_disk);
+
 	rq->timeout = SD_FLUSH_TIMEOUT;
 	rq->retries = SD_MAX_RETRIES;
 	rq->cmd[0] = SYNCHRONIZE_CACHE;
+
+	/* No need to synchronize to medium if we have a non-volatile cache,
+	 * but be safe if the medium could just go away.
+	 */
+	if (sdkp->nv_sup && !sdp->removable)
+		rq->cmd[1] |= 4; /* SYNC_NV */
 	rq->cmd_len = 10;
 
 	return scsi_setup_blk_pc_cmnd(sdp, rq);
@@ -2511,6 +2519,26 @@ static void sd_read_app_tag_own(struct scsi_disk *sdkp, unsigned char *buffer)
 }
 
 /**
+ * sd_read_extended_inquiry - Query disk device for non-volatile cache.
+ * @disk: disk to query
+ */
+static void sd_read_extended_inquiry(struct scsi_disk *sdkp)
+{
+	const int vpd_len = 64;
+	unsigned char *buffer = kmalloc(vpd_len, GFP_KERNEL);
+
+	if (!buffer ||
+	    /* Block Limits VPD */
+	    scsi_get_vpd_page(sdkp->device, 0x86, buffer, vpd_len))
+		goto out;
+
+	sdkp->nv_sup = (buffer[6] & 0x02) != 0;
+
+ out:
+	kfree(buffer);
+}
+
+/**
  * sd_read_block_limits - Query disk device for preferred I/O sizes.
  * @disk: disk to query
  */
@@ -2684,6 +2712,7 @@ static int sd_revalidate_disk(struct gendisk *disk)
 		sd_read_capacity(sdkp, buffer);
 
 		if (sd_try_extended_inquiry(sdp)) {
+			sd_read_extended_inquiry(sdkp);
 			sd_read_block_provisioning(sdkp);
 			sd_read_block_limits(sdkp);
 			sd_read_block_characteristics(sdkp);
diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
index 74a1e4c..6334dfe 100644
--- a/drivers/scsi/sd.h
+++ b/drivers/scsi/sd.h
@@ -84,6 +84,7 @@ struct scsi_disk {
 	unsigned	lbpws10 : 1;
 	unsigned	lbpvpd : 1;
 	unsigned	ws16 : 1;
+	unsigned	nv_sup : 1;
 };
 #define to_scsi_disk(obj) container_of(obj,struct scsi_disk,dev)
 

> Regards,
> 
> Ric
> 

