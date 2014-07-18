From: "Christoph Hellwig (hch@infradead.org)" <hch@infradead.org>
Subject: Re: [PATCH 1/1] [SCSI] Fix a bug in deriving the FLUSH_TIMEOUT from
 the basic I/O timeout
Date: Fri, 18 Jul 2014 08:10:39 -0700
Message-ID: <20140718151039.GA7425@infradead.org>
References: <1401899623-24194-1-git-send-email-kys@microsoft.com>
 <1401901323.17510.23.camel@dabdike>
 <d61f4b87a72544e4b0c1e1872a76f97b@BY2PR03MB299.namprd03.prod.outlook.com>
 <53911A35.7010805@cs.wisc.edu>
 <d9854e6ff97f4b0087dbe835a2a57c8f@BY2PR03MB299.namprd03.prod.outlook.com>
 <5391F801.4010107@cs.wisc.edu>
 <1402077167.2207.89.camel@dabdike.int.hansenpartnership.com>
 <539206FA.1020001@kernel.dk>
 <5b926a0a9f264edda91c7c2ab0acb7d1@BY2PR03MB299.namprd03.prod.outlook.com>
 <13807d2cc8744ae1bc374f20d8f9caec@BY2PR0301MB0711.namprd03.prod.outlook.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="vkogqOf2sHV7VnPd"
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
Content-Disposition: inline
In-Reply-To: <13807d2cc8744ae1bc374f20d8f9caec@BY2PR0301MB0711.namprd03.prod.outlook.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: driverdev-devel-bounces@linuxdriverproject.org
To: KY Srinivasan <kys@microsoft.com>
Cc: Jens Axboe <axboe@kernel.dk>, "michaelc@cs.wisc.edu" <michaelc@cs.wisc.edu>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "jasowang@redhat.com" <jasowang@redhat.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, James Bottomley <jbottomley@parallels.com>, "ohering@suse.com" <ohering@suse.com>, "Christoph Hellwig (hch@infradead.org)" <hch@infradead.org>, "apw@canonical.com" <apw@canonical.com>, "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
List-Id: linux-scsi@vger.kernel.org


--vkogqOf2sHV7VnPd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jul 17, 2014 at 11:53:33PM +0000, KY Srinivasan wrote:
> I still see this problem. There was talk of fixing it elsewhere.

Well, what we have right not is entirely broken, given that the
block layer doesn't initialize ->timeout on TYPE_FS requeuests.

We either need to revert that initial commit or apply something like
the attached patch as a quick fix.


--vkogqOf2sHV7VnPd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="0001-sd-set-a-non-zero-timeout-for-flush-requests.patch"

>From ecbf154d15f4022676219b9ff90e542d1db64392 Mon Sep 17 00:00:00 2001
From: Christoph Hellwig <hch@lst.de>
Date: Fri, 18 Jul 2014 17:11:27 +0200
Subject: sd: set a non-zero timeout for flush requests

rq->timeout for TYPE_FS commands needs to be initialized by the driver,
so we can't simply multiply it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/sd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 377a520..bef4e78 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -880,7 +880,7 @@ static int sd_setup_flush_cmnd(struct scsi_cmnd *cmd)
 	cmd->transfersize = 0;
 	cmd->allowed = SD_MAX_RETRIES;
 
-	rq->timeout *= SD_FLUSH_TIMEOUT_MULTIPLIER;
+	rq->timeout = SD_TIMEOUT * SD_FLUSH_TIMEOUT_MULTIPLIER;
 	return BLKPREP_OK;
 }
 
-- 
1.9.1


--vkogqOf2sHV7VnPd
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
devel mailing list
devel@linuxdriverproject.org
http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel

--vkogqOf2sHV7VnPd--
