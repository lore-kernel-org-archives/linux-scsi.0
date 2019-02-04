From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 7/8] block: remove req->special
Date: Mon, 4 Feb 2019 09:01:36 +0100
Message-ID: <20190204080136.GA5582@lst.de>
References: <20190201075557.9249-1-hch@lst.de> <20190201075557.9249-8-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190201075557.9249-8-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: axboe@kernel.dk, martin.petersen@oracle.com, ooo@electrozaur.com
Cc: Johannes Thumshirn <jthumshirn@suse.de>, Benjamin Block <bblock@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

FYI, this needs the following fold, as Bart added another reference
to ->special past the branch point for my tree:

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 4fbb8310e268..a1e43e77ceef 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1171,8 +1171,6 @@ static blk_status_t sd_setup_read_write_cmnd(struct scsi_cmnd *cmd)
 	if (ret != BLK_STS_OK)
 		return ret;
 
-	WARN_ON_ONCE(cmd != rq->special);
-
 	if (!scsi_device_online(sdp) || sdp->changed) {
 		scmd_printk(KERN_ERR, cmd, "device offline or changed\n");
 		return BLK_STS_IOERR;
