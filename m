From: "hch@infradead.org" <hch@infradead.org>
Subject: Re: [PATCH 1/1] [SCSI] Fix a bug in deriving the FLUSH_TIMEOUT from
 the basic I/O timeout
Date: Fri, 18 Jul 2014 10:12:38 -0700
Message-ID: <20140718171238.GA3159@infradead.org>
References: <d9854e6ff97f4b0087dbe835a2a57c8f@BY2PR03MB299.namprd03.prod.outlook.com>
 <5391F801.4010107@cs.wisc.edu>
 <1402077167.2207.89.camel@dabdike.int.hansenpartnership.com>
 <539206FA.1020001@kernel.dk>
 <5b926a0a9f264edda91c7c2ab0acb7d1@BY2PR03MB299.namprd03.prod.outlook.com>
 <13807d2cc8744ae1bc374f20d8f9caec@BY2PR0301MB0711.namprd03.prod.outlook.com>
 <20140718151039.GA7425@infradead.org>
 <2d43adebbc47441084d8e1284507a427@BY2PR0301MB0711.namprd03.prod.outlook.com>
 <1405702633.30262.3.camel@dabdike.int.hansenpartnership.com>
 <7c46a791325a40fd82572fd3a09726d9@BY2PR0301MB0711.namprd03.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <7c46a791325a40fd82572fd3a09726d9@BY2PR0301MB0711.namprd03.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: KY Srinivasan <kys@microsoft.com>
Cc: James Bottomley <jbottomley@parallels.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>, "apw@canonical.com" <apw@canonical.com>, "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>, "michaelc@cs.wisc.edu" <michaelc@cs.wisc.edu>, "axboe@kernel.dk" <axboe@kernel.dk>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "ohering@suse.com" <ohering@suse.com>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "jasowang@redhat.com" <jasowang@redhat.com>
List-Id: linux-scsi@vger.kernel.org

This is what I plan to put in after it passes basic testing:

---
>From bb617c9465b839d70ecbbc69002a20ccf5f935bd Mon Sep 17 00:00:00 2001
From: "K. Y. Srinivasan" <kys@microsoft.com>
Date: Fri, 18 Jul 2014 19:12:58 +0200
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
index bef4e78..9ffb393 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -880,7 +880,7 @@ static int sd_setup_flush_cmnd(struct scsi_cmnd *cmd)
 	cmd->transfersize = 0;
 	cmd->allowed = SD_MAX_RETRIES;
 
-	rq->timeout = SD_TIMEOUT * SD_FLUSH_TIMEOUT_MULTIPLIER;
+	rq->timeout = rq->q->rq_timeout * SD_FLUSH_TIMEOUT_MULTIPLIER;
 	return BLKPREP_OK;
 }
 
-- 
1.9.1
