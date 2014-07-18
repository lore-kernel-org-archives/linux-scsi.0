From: "hch@infradead.org" <hch@infradead.org>
Subject: Re: [PATCH 1/1] [SCSI] Fix a bug in deriving the FLUSH_TIMEOUT from
 the basic I/O timeout
Date: Fri, 18 Jul 2014 10:15:19 -0700
Message-ID: <20140718171519.GA5984@infradead.org>
References: <5391F801.4010107@cs.wisc.edu>
 <1402077167.2207.89.camel@dabdike.int.hansenpartnership.com>
 <539206FA.1020001@kernel.dk>
 <5b926a0a9f264edda91c7c2ab0acb7d1@BY2PR03MB299.namprd03.prod.outlook.com>
 <13807d2cc8744ae1bc374f20d8f9caec@BY2PR0301MB0711.namprd03.prod.outlook.com>
 <20140718151039.GA7425@infradead.org>
 <2d43adebbc47441084d8e1284507a427@BY2PR0301MB0711.namprd03.prod.outlook.com>
 <1405702633.30262.3.camel@dabdike.int.hansenpartnership.com>
 <7c46a791325a40fd82572fd3a09726d9@BY2PR0301MB0711.namprd03.prod.outlook.com>
 <20140718171238.GA3159@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
Content-Disposition: inline
In-Reply-To: <20140718171238.GA3159@infradead.org>
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
Cc: "axboe@kernel.dk" <axboe@kernel.dk>, "michaelc@cs.wisc.edu" <michaelc@cs.wisc.edu>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "jasowang@redhat.com" <jasowang@redhat.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, James Bottomley <jbottomley@parallels.com>, "ohering@suse.com" <ohering@suse.com>, "hch@infradead.org" <hch@infradead.org>, "apw@canonical.com" <apw@canonical.com>, "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, Jul 18, 2014 at 10:12:38AM -0700, hch@infradead.org wrote:
> This is what I plan to put in after it passes basic testing:

And that one was on top of my previous version.  One that applies
against core-for-3.17 below:

---
>From 8a79783e5f72ec034a724e16c1f46604bd97bf68 Mon Sep 17 00:00:00 2001
From: "K. Y. Srinivasan" <kys@microsoft.com>
Date: Fri, 18 Jul 2014 17:11:27 +0200
Subject: sd: fix a bug in deriving the FLUSH_TIMEOUT from the basic I/O
 timeout

Commit ID: 7e660100d85af860e7ad763202fff717adcdaacd added code to derive the
FLUSH_TIMEOUT from the basic I/O timeout. However, this patch did not use the
basic I/O timeout of the device. Fix this bug.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Reviewed-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/sd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 377a520..9ffb393 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -880,7 +880,7 @@ static int sd_setup_flush_cmnd(struct scsi_cmnd *cmd)
 	cmd->transfersize = 0;
 	cmd->allowed = SD_MAX_RETRIES;
 
-	rq->timeout *= SD_FLUSH_TIMEOUT_MULTIPLIER;
+	rq->timeout = rq->q->rq_timeout * SD_FLUSH_TIMEOUT_MULTIPLIER;
 	return BLKPREP_OK;
 }
 
-- 
1.9.1
