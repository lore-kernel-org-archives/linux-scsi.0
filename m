From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH] scsi: sd: don't crash the host on invalid commands
Date: Thu, 20 Sep 2018 11:18:19 -0700
Message-ID: <1537467499.224533.21.camel@acm.org>
References: <20180920071907.10102-1-jthumshirn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-7"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180920071907.10102-1-jthumshirn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>, "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

On Thu, 2018-09-20 at 09:19 +-0200, Johannes Thumshirn wrote:
+AD4 When sd+AF8-init+AF8-command() get's a with a unknown req+AF8-op() it crashes the
+AD4 system via BUG().
+AD4 
+AD4 This makes debugging the actual reason for the broken request
+AD4 cmd+AF8-flags pretty hard as the system is down before it's able to write
+AD4 out debugging data on the serial console or the trace buffer.
+AD4 
+AD4 Change the BUG() to a WARN+AF8-ON() and return BLKPREP+AF8-KILL to fail
+AD4 gracefully and return an I/O error to the producer of the request.
+AD4 
+AD4 Signed-off-by: Johannes Thumshirn +ADw-jthumshirn+AEA-suse.de+AD4
+AD4 Cc: Hannes Reinecke +ADw-hare+AEA-suse.de+AD4
+AD4 Cc: Bart Van Assche +ADw-bvanassche+AEA-acm.org+AD4
+AD4 Cc: Christoph Hellwig +ADw-hch+AEA-lst.de+AD4
+AD4 ---
+AD4 Fixed Typo in Bart's mail, sorry for this.
+AD4 
+AD4  drivers/scsi/sd.c +AHw 3 +-+--
+AD4  1 file changed, 2 insertions(+-), 1 deletion(-)
+AD4 
+AD4 diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
+AD4 index b79b366a94f7..19f28962d65b 100644
+AD4 --- a/drivers/scsi/sd.c
+AD4 +-+-+- b/drivers/scsi/sd.c
+AD4 +AEAAQA -1276,7 +-1276,8 +AEAAQA static int sd+AF8-init+AF8-command(struct scsi+AF8-cmnd +ACo-cmd)
+AD4  	case REQ+AF8-OP+AF8-ZONE+AF8-RESET:
+AD4  		return sd+AF8-zbc+AF8-setup+AF8-reset+AF8-cmnd(cmd)+ADs
+AD4  	default:
+AD4 -		BUG()+ADs
+AD4 +-		WARN+AF8-ON(1)+ADs
+AD4 +-		return BLKPREP+AF8-KILL+ADs
+AD4  	+AH0
+AD4  +AH0

Have you considered to use WARN+AF8-ON+AF8-ONCE() instead of WARN+AF8-ON(1)? Otherwise
this patch looks good to me.

Thanks,

Bart.
