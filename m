From: Christoph Hellwig <hch@lst.de>
Subject: Re: SCSI regression in 4.11
Date: Thu, 2 Mar 2017 01:01:35 +0100
Message-ID: <20170302000135.GA22886@lst.de>
References: <20170228140812.GC20197@lst.de> <c1949de0-8b95-e254-1bec-bcdae762890f@kernel.dk> <1488301573.3046.9.camel@linux.vnet.ibm.com> <20170228105741.6253bb8a@xeon-e3> <1488325732.11610.9.camel@linux.vnet.ibm.com> <20170228172532.280811ed@xeon-e3> <1488349258.20321.11.camel@linux.vnet.ibm.com> <20170228224845.1da358ee@xeon-e3> <20170301155057.GA13167@lst.de> <20170301075412.2e5f1e98@xeon-e3>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:53730 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752979AbdCBABm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 1 Mar 2017 19:01:42 -0500
Content-Disposition: inline
In-Reply-To: <20170301075412.2e5f1e98@xeon-e3>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stephen Hemminger <stephen@networkplumber.org>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <jejb@linux.vnet.ibm.com>, Jens Axboe <axboe@kernel.dk>, Linus Torvalds <torvalds@linux-foundation.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, "K. Y. Srinivasan" <kys@microsoft.com>, Dexuan Cui <decui@microsoft.com>, Long Li <longli@microsoft.com>, Josh Poulson <jopoulso@microsoft.com>, v-adsuho@microsoft.com, linux-scsi@vger.kernel.org, Haiyang Zhang <haiyangz@microsoft.com>

On Wed, Mar 01, 2017 at 07:54:12AM -0800, Stephen Hemminger wrote:
> > 	http://git.infradead.org/users/hch/block.git/commitdiff/148cff67b401e2229c076c0ea418712654be77e4
> 
> It appears that is already in the code I am testing in linux-next...

It's in -next now, but it wasn't at the time you reported the bug.

And it would sortof explain the bug if the INQUIRY data is correct
in the scatterlist, but we ignore it, given that scsi_probe_lun
ignores the result based on sense data.

Can you check what happens with the horrible hack below:

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 6f7128f49c30..2f384ddb001a 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -603,7 +603,7 @@ static int scsi_probe_lun(struct scsi_device *sdev, unsigned char *inq_result,
 		SCSI_LOG_SCAN_BUS(3, sdev_printk(KERN_INFO, sdev,
 				"scsi scan: INQUIRY %s with code 0x%x\n",
 				result ? "failed" : "successful", result));
-
+#if 0
 		if (result) {
 			/*
 			 * not-ready to ready transition [asc/ascq=0x28/0x0]
@@ -628,6 +628,12 @@ static int scsi_probe_lun(struct scsi_device *sdev, unsigned char *inq_result,
 			if (resid == try_inquiry_len)
 				continue;
 		}
+#else
+		if (result) {
+			printk_ratelimited("got result %d:\n", result);
+			result = 0;
+		}
+#endif
 		break;
 	}
 
