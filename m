From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH] Fix sense handling in __scsi_execute()
Date: Wed, 23 Jan 2019 16:03:48 -0800
Message-ID: <1548288228.9266.74.camel@acm.org>
References: <20190123224217.198935-1-bvanassche@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-7"
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20190123224217.198935-1-bvanassche@acm.org>
Sender: stable-owner@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Douglas Gilbert <dgilbert@interlog.com>, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, 2019-01-23 at 14:42 -0800, Bart Van Assche wrote:
+AD4 Since blk+AF8-execute+AF8-rq() no longer allocates a sense buffer and no longer
+AD4 initializes the sense pointer the callers of blk+AF8-execute+AF8-rq() have to do
+AD4 initialize the sense pointer. Hence this patch that initializes rq-+AD4-sense
+AD4 and that removes a superfluous memcpy() statement.
+AD4 
+AD4 Cc: Christoph Hellwig +ADw-hch+AEA-lst.de+AD4
+AD4 Cc: Douglas Gilbert +ADw-dgilbert+AEA-interlog.com+AD4
+AD4 Cc: +ADw-stable+AEA-vger.kernel.org+AD4 +ACM v4.11+-
+AD4 Fixes: 82ed4db499b8 (+ACI-block: split scsi+AF8-request out of struct request+ACI)
+AD4 Signed-off-by: Bart Van Assche +ADw-bvanassche+AEA-acm.org+AD4
+AD4 ---
+AD4  drivers/scsi/scsi+AF8-lib.c +AHw 3 +---
+AD4  1 file changed, 1 insertion(+-), 2 deletions(-)
+AD4 
+AD4 diff --git a/drivers/scsi/scsi+AF8-lib.c b/drivers/scsi/scsi+AF8-lib.c
+AD4 index 4feba3b5aff1..8b9f4b1bca35 100644
+AD4 --- a/drivers/scsi/scsi+AF8-lib.c
+AD4 +-+-+- b/drivers/scsi/scsi+AF8-lib.c
+AD4 +AEAAQA -271,6 +-271,7 +AEAAQA int +AF8AXw-scsi+AF8-execute(struct scsi+AF8-device +ACo-sdev, const unsigned char +ACo-cmd,
+AD4  	rq-+AD4-cmd+AF8-len +AD0 COMMAND+AF8-SIZE(cmd+AFs-0+AF0)+ADs
+AD4  	memcpy(rq-+AD4-cmd, cmd, rq-+AD4-cmd+AF8-len)+ADs
+AD4  	rq-+AD4-retries +AD0 retries+ADs
+AD4 +-	rq-+AD4-sense +AD0 sense+ADs
+AD4  	req-+AD4-timeout +AD0 timeout+ADs
+AD4  	req-+AD4-cmd+AF8-flags +AHwAPQ flags+ADs
+AD4  	req-+AD4-rq+AF8-flags +AHwAPQ rq+AF8-flags +AHw RQF+AF8-QUIET+ADs
+AD4 +AEAAQA -291,8 +-292,6 +AEAAQA int +AF8AXw-scsi+AF8-execute(struct scsi+AF8-device +ACo-sdev, const unsigned char +ACo-cmd,
+AD4  
+AD4  	if (resid)
+AD4  		+ACo-resid +AD0 rq-+AD4-resid+AF8-len+ADs
+AD4 -	if (sense +ACYAJg rq-+AD4-sense+AF8-len)
+AD4 -		memcpy(sense, rq-+AD4-sense, SCSI+AF8-SENSE+AF8-BUFFERSIZE)+ADs
+AD4  	if (sshdr)
+AD4  		scsi+AF8-normalize+AF8-sense(rq-+AD4-sense, rq-+AD4-sense+AF8-len, sshdr)+ADs
+AD4  	ret +AD0 rq-+AD4-result+ADs

Please ignore this patch - I just realized that this is not the right way to
fix the issue I ran into.

Bart.
