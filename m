From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v4 6/7] sd: Implement support for ZBC devices
Date: Thu, 29 Sep 2016 22:37:37 -0400
Message-ID: <yq1wphut8ni.fsf@sermon.lab.mkp.net>
References: <1475052339-10202-1-git-send-email-damien.lemoal@hgst.com>
        <1475052339-10202-7-git-send-email-damien.lemoal@hgst.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <1475052339-10202-7-git-send-email-damien.lemoal@hgst.com>
        (Damien Le Moal's message of "Wed, 28 Sep 2016 17:45:38 +0900")
Sender: linux-block-owner@vger.kernel.org
To: Damien Le Moal <damien.lemoal@hgst.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, "Martin K . Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.de>, Shaun Tancheff <shaun@tancheff.com>
List-Id: linux-scsi@vger.kernel.org

>>>>> "Damien" == Damien Le Moal <damien.lemoal@hgst.com> writes:

Damien,

Almost there! And A-OK on the read capacity changes.

However:

@@ -844,6 +850,13 @@ static int sd_setup_write_same_cmnd(struct scsi_cmnd *cmd)
 
 	BUG_ON(bio_offset(bio) || bio_iovec(bio).bv_len != sdp->sector_size);
 
+	if (sd_is_zoned(sdkp)) {
+		/* sd_zbc_setup_read_write uses block layer sector units */

That comment really says: "I am doing confusing stuff that doesn't
follow the normal calling convention in the driver". Plus it's another
case of using block layer sectors where they shouldn't be.

Please just pass the scsi_cmnd to sd_zbc_set_read_write() like it's done
for sd_zbc_setup_reset_cmnd() and the regular sd_setup_* calls. And then
no commentary is necessary...

+		ret = sd_zbc_setup_read_write(sdkp, rq, sector, nr_sectors);
+		if (ret != BLKPREP_OK)
+			return ret;
+	}
+

@@ -963,6 +976,13 @@ static int sd_setup_read_write_cmnd(struct scsi_cmnd *SCpnt)
 	SCSI_LOG_HLQUEUE(2, scmd_printk(KERN_INFO, SCpnt, "block=%llu\n",
 					(unsigned long long)block));
 
+	if (sd_is_zoned(sdkp)) {
+		/* sd_zbc_setup_read_write uses block layer sector units */
+		ret = sd_zbc_setup_read_write(sdkp, rq, block, this_count);
+		if (ret != BLKPREP_OK)
+			goto out;
+	}
+

Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
