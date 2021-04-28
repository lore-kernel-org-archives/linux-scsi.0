Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 247D5C433B4
	for <linux-scsi@archiver.kernel.org>; Wed, 28 Apr 2021 19:55:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CD7A061423
	for <linux-scsi@archiver.kernel.org>; Wed, 28 Apr 2021 19:55:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232936AbhD1Tzr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 28 Apr 2021 15:55:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232291AbhD1Tzq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Apr 2021 15:55:46 -0400
Received: from mail-qk1-x729.google.com (mail-qk1-x729.google.com [IPv6:2607:f8b0:4864:20::729])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18CCFC061573;
        Wed, 28 Apr 2021 12:55:00 -0700 (PDT)
Received: by mail-qk1-x729.google.com with SMTP id i12so33326963qke.3;
        Wed, 28 Apr 2021 12:55:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=XSr7iYt2CxN8YP3k4Jnxm3GNZva+up27MHxXVmezQhI=;
        b=lsFYI7InA5ULwuNtAJbH1UQSTe33OgeKmFQ07vtHX5V92CD79cz0ZHy/tN20muUzBY
         2+FxNdCAB9ivf6nNNXDTQf5qwzliTjyFxe4DdviRgCxUtjeDBYvDHsRc57F7YRbL26J9
         oe3ajoK8IvrYyF/6URX2HQI/SzW7CUDoQkSymW3EiYvxM2ICH2S84/pEQf68cs60BdfG
         FNriwSpd2uKKV4QYZn+35kbWxqFZwXs/VH8o0JJYf9d5qqCzYK72cZ2U9YmQHB9ZFByy
         Bp1XSAoprQSCz4CBokOzNN4RO+M2XBjBa5wDxjH9rRC3ysu2hw/K8SH3mNxKAsT58Mfe
         Ka0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=XSr7iYt2CxN8YP3k4Jnxm3GNZva+up27MHxXVmezQhI=;
        b=F1r1SMY53nXprqz6imJMMJkwLhKFgTp6/NvZk8jDrdL9XsbOvnZUpB9oQzIZ5FQR3o
         AHAHtEKwMrKxD9OIlShkilRtn615F2vbcxZFmSvrzVMXBpkOl+w3eIBbc93GXrXEHp4C
         mR296O6ld5kiRBiXtvd4a+DVh8s+K9ioCZbDrIHEIS1ArZwUw9JB/ZtjOx91la5/O6du
         figyfx+oPoa0sv7xWABXE9kHIJvHYcixjVTZyenBE/sz74ekXL8SwrCpU46cJwDdj1pu
         7oFhQlwzuRbipVLVDYyLNSIvZOQZnv6TXHO4fYPpXSauDMb7is9AWZzTE7o16/CeCwqr
         CUPg==
X-Gm-Message-State: AOAM5324B5f5TUaw3aNc748tFMgup+q42ISH7NKm8+ERDjXovxdUZq4J
        y/y/oLXac0bFB1Cd9IYEZVE=
X-Google-Smtp-Source: ABdhPJyDMyrpnDsH5ij7i8MpojF8d7qQ3pg5hm8axQZairUGJkvYGsh1tW2wV+vVE4r50bx8vIIHzw==
X-Received: by 2002:a05:620a:1233:: with SMTP id v19mr7963646qkj.418.1619639699050;
        Wed, 28 Apr 2021 12:54:59 -0700 (PDT)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net. [68.160.176.52])
        by smtp.gmail.com with ESMTPSA id l4sm662612qtn.96.2021.04.28.12.54.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Apr 2021 12:54:58 -0700 (PDT)
Sender: Mike Snitzer <snitzer@gmail.com>
Date:   Wed, 28 Apr 2021 15:54:57 -0400
From:   Mike Snitzer <snitzer@redhat.com>
To:     mwilck@suse.com
Cc:     Alasdair G Kergon <agk@redhat.com>, dm-devel@redhat.com,
        Hannes Reinecke <hare@suse.de>,
        Daniel Wagner <dwagner@suse.de>, linux-block@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org
Subject: Re: dm: dm_blk_ioctl(): implement failover for SG_IO on dm-multipath
Message-ID: <20210428195457.GA46518@lobo>
References: <20210422202130.30906-1-mwilck@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210422202130.30906-1-mwilck@suse.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Apr 22 2021 at  4:21P -0400,
mwilck@suse.com <mwilck@suse.com> wrote:

> From: Martin Wilck <mwilck@suse.com>
> 
> In virtual deployments, SCSI passthrough over dm-multipath devices is a
> common setup. The qemu "pr-helper" was specifically invented for it. I
> believe that this is the most important real-world scenario for sending
> SG_IO ioctls to device-mapper devices.
> 
> In this configuration, guests send SCSI IO to the hypervisor in the form of
> SG_IO ioctls issued by qemu. But on the device-mapper level, these SCSI
> ioctls aren't treated like regular IO. Until commit 2361ae595352 ("dm mpath:
> switch paths in dm_blk_ioctl() code path"), no path switching was done at
> all. Worse though, if an SG_IO call fails because of a path error,
> dm-multipath doesn't retry the IO on a another path; rather, the failure is
> passed back to the guest, and paths are not marked as faulty.  This is in
> stark contrast with regular block IO of guests on dm-multipath devices, and
> certainly comes as a surprise to users who switch to SCSI passthrough in
> qemu. In general, users of dm-multipath devices would probably expect failover
> to work at least in a basic way.
> 
> This patch fixes this by taking a special code path for SG_IO on request-
> based device mapper targets. Rather then just choosing a single path,
> sending the IO to it, and failing to the caller if the IO on the path
> failed, it retries the same IO on another path for certain error codes,
> using the same logic as blk_path_error() to determine if a retry would make
> sense for the given error code. Moreover, it sends a message to the
> multipath target to mark the path as failed.
> 
> I am aware that this looks sort of hack-ish. I'm submitting it here as an
> RFC, asking for guidance how to reach a clean implementation that would be
> acceptable in mainline. I believe that it fixes an important problem.
> Actually, it fixes the qemu SCSI-passthrough use case on dm-multipath,
> which is non-functional without it.
> 
> One problem remains open: if all paths in a multipath map are failed,
> normal multipath IO may switch to queueing mode (depending on
> configuration). This isn't possible for SG_IO, as SG_IO requests can't
> easily be queued like regular block I/O. Thus in the "no path" case, the
> guest will still see an error. If anybody can conceive of a solution for
> that, I'd be interested.
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> ---
>  block/scsi_ioctl.c     |   5 +-
>  drivers/md/dm.c        | 134 ++++++++++++++++++++++++++++++++++++++++-
>  include/linux/blkdev.h |   2 +
>  3 files changed, 137 insertions(+), 4 deletions(-)
> 
> diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
> index 6599bac0a78c..bcc60552f7b1 100644
> --- a/block/scsi_ioctl.c
> +++ b/block/scsi_ioctl.c
> @@ -279,8 +279,8 @@ static int blk_complete_sghdr_rq(struct request *rq, struct sg_io_hdr *hdr,
>  	return ret;
>  }
>  
> -static int sg_io(struct request_queue *q, struct gendisk *bd_disk,
> -		struct sg_io_hdr *hdr, fmode_t mode)
> +int sg_io(struct request_queue *q, struct gendisk *bd_disk,
> +	  struct sg_io_hdr *hdr, fmode_t mode)
>  {
>  	unsigned long start_time;
>  	ssize_t ret = 0;
> @@ -369,6 +369,7 @@ static int sg_io(struct request_queue *q, struct gendisk *bd_disk,
>  	blk_put_request(rq);
>  	return ret;
>  }
> +EXPORT_SYMBOL_GPL(sg_io);
>  
>  /**
>   * sg_scsi_ioctl  --  handle deprecated SCSI_IOCTL_SEND_COMMAND ioctl
> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> index 50b693d776d6..443ac5e5406c 100644
> --- a/drivers/md/dm.c
> +++ b/drivers/md/dm.c
> @@ -29,6 +29,8 @@
>  #include <linux/part_stat.h>
>  #include <linux/blk-crypto.h>
>  #include <linux/keyslot-manager.h>
> +#include <scsi/sg.h>
> +#include <scsi/scsi.h>
>  
>  #define DM_MSG_PREFIX "core"
>  

Ngh... not loving this at all.  But here is a patch (that I didn't
compile test) that should be folded in, still have to think about how
this could be made cleaner in general though.

Also, dm_sg_io_ioctl should probably be in dm-rq.c (maybe even dm-mpath.c!?)

From: Mike Snitzer <snitzer@redhat.com>
Date: Wed, 28 Apr 2021 15:03:20 -0400
Subject: [PATCH] dm: use scsi_result_to_blk_status rather than open-coding it

Other small cleanups/nits.

BUT the fact that dm.c now #includes <scsi/scsi.h> and <scsi/sg.h>
leaves a very bitter taste.

Also, hardcoding the issuing of a "fail_path" message (assumes tgt is
dm-mpath) but still having checks like !tgt->type->message.. its all
very contrived and awkward!

Not-Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm.c          | 50 ++++++++++++++++--------------------------------
 drivers/scsi/scsi_lib.c  | 21 ++++++++++++--------
 include/scsi/scsi_cmnd.h |  2 ++
 3 files changed, 32 insertions(+), 41 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index b79adf021ef1..51e187309ebd 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -524,9 +524,9 @@ static int dm_blk_report_zones(struct gendisk *disk, sector_t sector,
 #define dm_blk_report_zones		NULL
 #endif /* CONFIG_BLK_DEV_ZONED */
 
-static int _dm_prepare_ioctl(struct mapped_device *md, int *srcu_idx,
-			     struct block_device **bdev,
-			     struct dm_target **target)
+static int __dm_prepare_ioctl(struct mapped_device *md, int *srcu_idx,
+			      struct block_device **bdev,
+			      struct dm_target **target)
 {
 	struct dm_target *tgt;
 	struct dm_table *map;
@@ -565,7 +565,7 @@ static int _dm_prepare_ioctl(struct mapped_device *md, int *srcu_idx,
 static int dm_prepare_ioctl(struct mapped_device *md, int *srcu_idx,
 			    struct block_device **bdev)
 {
-	return _dm_prepare_ioctl(md, srcu_idx, bdev, NULL);
+	return __dm_prepare_ioctl(md, srcu_idx, bdev, NULL);
 }
 
 static void dm_unprepare_ioctl(struct mapped_device *md, int srcu_idx)
@@ -594,9 +594,9 @@ static int dm_sg_io_ioctl(struct block_device *bdev, fmode_t mode,
 		struct dm_target *tgt;
 		struct sg_io_hdr rhdr;
 
-		rc = _dm_prepare_ioctl(md, &srcu_idx, &bdev, &tgt);
+		rc = __dm_prepare_ioctl(md, &srcu_idx, &bdev, &tgt);
 		if (rc < 0) {
-			DMERR("%s: failed to get path: %d\n",
+			DMERR("%s: failed to get path: %d",
 			      __func__, rc);
 			goto out;
 		}
@@ -605,7 +605,7 @@ static int dm_sg_io_ioctl(struct block_device *bdev, fmode_t mode,
 
 		rc = sg_io(bdev->bd_disk->queue, bdev->bd_disk, &rhdr, mode);
 
-		DMDEBUG("SG_IO via %s: rc = %d D%02xH%02xM%02xS%02x\n",
+		DMDEBUG("SG_IO via %s: rc = %d D%02xH%02xM%02xS%02x",
 			bdevname(bdev, path_name), rc,
 			rhdr.driver_status, rhdr.host_status,
 			rhdr.msg_status, rhdr.status);
@@ -626,32 +626,16 @@ static int dm_sg_io_ioctl(struct block_device *bdev, fmode_t mode,
 		}
 
 		if (rhdr.info & SG_INFO_CHECK) {
-			/*
-			 * See if this is a target or path error.
-			 * Compare blk_path_error(), scsi_result_to_blk_status(),
-			 * blk_errors[].
-			 */
-			switch (rhdr.host_status) {
-			case DID_OK:
-				if (scsi_status_is_good(rhdr.status))
-					rc = 0;
-				break;
-			case DID_TARGET_FAILURE:
-				rc = -EREMOTEIO;
-				goto out;
-			case DID_NEXUS_FAILURE:
-				rc = -EBADE;
-				goto out;
-			case DID_ALLOC_FAILURE:
-				rc = -ENOSPC;
-				goto out;
-			case DID_MEDIUM_ERROR:
-				rc = -ENODATA;
-				goto out;
-			default:
-				/* Everything else is a path error */
+			blk_status_t sts = scsi_result_to_blk_status(rhdr.host_status, NULL);
+
+			/* See if this is a target or path error. */
+			if (sts == BLK_STS_OK)
+				rc = 0;
+			else if (blk_path_error(sts))
 				rc = -EIO;
-				break;
+			else {
+				rc = blk_status_to_errno(sts);
+				goto out;
 			}
 		}
 
@@ -674,7 +658,7 @@ static int dm_sg_io_ioctl(struct block_device *bdev, fmode_t mode,
 			scnprintf(bdbuf, sizeof(bdbuf), "%u:%u",
 				  MAJOR(bdev->bd_dev), MINOR(bdev->bd_dev));
 
-			DMDEBUG("sending \"%s %s\" to target\n", argv[0], argv[1]);
+			DMDEBUG("sending \"%s %s\" to target", argv[0], argv[1]);
 			rc = tgt->type->message(tgt, 2, argv, NULL, 0);
 			if (rc < 0)
 				goto out;
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 7d52a11e1b61..ecaaba66983c 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -617,7 +617,7 @@ static bool scsi_end_request(struct request *req, blk_status_t error,
  * Translate a SCSI result code into a blk_status_t value. May reset the host
  * byte of @cmd->result.
  */
-static blk_status_t scsi_result_to_blk_status(struct scsi_cmnd *cmd, int result)
+blk_status_t scsi_result_to_blk_status(int result, struct scsi_cmnd *cmd)
 {
 	switch (host_byte(result)) {
 	case DID_OK:
@@ -633,21 +633,26 @@ static blk_status_t scsi_result_to_blk_status(struct scsi_cmnd *cmd, int result)
 	case DID_TRANSPORT_MARGINAL:
 		return BLK_STS_TRANSPORT;
 	case DID_TARGET_FAILURE:
-		set_host_byte(cmd, DID_OK);
+		if (cmd)
+			set_host_byte(cmd, DID_OK);
 		return BLK_STS_TARGET;
 	case DID_NEXUS_FAILURE:
-		set_host_byte(cmd, DID_OK);
+		if (cmd)
+			set_host_byte(cmd, DID_OK);
 		return BLK_STS_NEXUS;
 	case DID_ALLOC_FAILURE:
-		set_host_byte(cmd, DID_OK);
+		if (cmd)
+			set_host_byte(cmd, DID_OK);
 		return BLK_STS_NOSPC;
 	case DID_MEDIUM_ERROR:
-		set_host_byte(cmd, DID_OK);
+		if (cmd)
+			set_host_byte(cmd, DID_OK);
 		return BLK_STS_MEDIUM;
 	default:
 		return BLK_STS_IOERR;
 	}
 }
+EXPORT_SYMBOL(scsi_result_to_blk_status);
 
 /* Helper for scsi_io_completion() when "reprep" action required. */
 static void scsi_io_completion_reprep(struct scsi_cmnd *cmd,
@@ -691,7 +696,7 @@ static void scsi_io_completion_action(struct scsi_cmnd *cmd, int result)
 	if (sense_valid)
 		sense_current = !scsi_sense_is_deferred(&sshdr);
 
-	blk_stat = scsi_result_to_blk_status(cmd, result);
+	blk_stat = scsi_result_to_blk_status(result, cmd);
 
 	if (host_byte(result) == DID_RESET) {
 		/* Third party bus reset or reset for error recovery
@@ -869,14 +874,14 @@ static int scsi_io_completion_nz_result(struct scsi_cmnd *cmd, int result,
 				    SCSI_SENSE_BUFFERSIZE);
 		}
 		if (sense_current)
-			*blk_statp = scsi_result_to_blk_status(cmd, result);
+			*blk_statp = scsi_result_to_blk_status(result, cmd);
 	} else if (blk_rq_bytes(req) == 0 && sense_current) {
 		/*
 		 * Flush commands do not transfers any data, and thus cannot use
 		 * good_bytes != blk_rq_bytes(req) as the signal for an error.
 		 * This sets *blk_statp explicitly for the problem case.
 		 */
-		*blk_statp = scsi_result_to_blk_status(cmd, result);
+		*blk_statp = scsi_result_to_blk_status(result, cmd);
 	}
 	/*
 	 * Recovered errors need reporting, but they're always treated as
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index ace15b5dc956..19e76f8db1ea 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -161,6 +161,8 @@ static inline struct scsi_driver *scsi_cmd_to_driver(struct scsi_cmnd *cmd)
 
 extern void scsi_finish_command(struct scsi_cmnd *cmd);
 
+extern blk_status_t scsi_result_to_blk_status(int result, struct scsi_cmnd *cmd);
+
 extern void *scsi_kmap_atomic_sg(struct scatterlist *sg, int sg_count,
 				 size_t *offset, size_t *len);
 extern void scsi_kunmap_atomic_sg(void *virt);
-- 
2.15.0

