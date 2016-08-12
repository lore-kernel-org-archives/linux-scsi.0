From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2 2/2] sd: check BLK_DEF_MAX_SECTORS against max_dev_sectors
Date: Fri, 12 Aug 2016 17:37:36 -0400
Message-ID: <yq11t1tmzxb.fsf@sermon.lab.mkp.net>
References: <60518e90d462d4cbb1c528914eac64e2fe124717.1471011949.git.tom.ty89@gmail.com>
	<974f3a0aa9e82caf067353fd7d7119c07d7e98c1.1471011949.git.tom.ty89@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <974f3a0aa9e82caf067353fd7d7119c07d7e98c1.1471011949.git.tom.ty89@gmail.com>
	(tom's message of "Fri, 12 Aug 2016 22:27:04 +0800")
Sender: linux-ide-owner@vger.kernel.org
To: tom.ty89@gmail.com
Cc: tj@kernel.org, martin.petersen@oracle.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "Tom" == tom ty89 <tom.ty89@gmail.com> writes:

Tom,

Tom> The SCSI disk driver sets max_sectors to BLK_DEF_MAX_SECTORS when
Tom> the device does not report Optimal Transfer Length. However, it
Tom> checks only whether it is smaller than max_hw_sectors, but not
Tom> max_dev_sectors.

It would be pretty unusual for a device that is smart enough to report a
transfer length limit to be constrained to 1 MB and change.

@@ -2875,8 +2875,11 @@ static int sd_revalidate_disk(struct gendisk *disk)
 	    logical_to_bytes(sdp, sdkp->opt_xfer_blocks) >= PAGE_SIZE) {
 		q->limits.io_opt = logical_to_bytes(sdp, sdkp->opt_xfer_blocks);
 		rw_max = logical_to_sectors(sdp, sdkp->opt_xfer_blocks);
-	} else
+	} else {
 		rw_max = BLK_DEF_MAX_SECTORS;
+		/* Combine with device limits */
+		rw_max = min(rw_max, q->limits.max_dev_sectors);
+	}
 
 	/* Combine with controller limits */
 	q->limits.max_sectors = min(rw_max, queue_max_hw_sectors(q));

If you want to fix this please drop the braces and do:

		rw_max = min(BLK_DEF_MAX_SECTORS, q->limits.max_dev_sectors);

-- 
Martin K. Petersen	Oracle Linux Engineering
