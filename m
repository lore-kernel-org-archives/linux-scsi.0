From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 1/2] [SCSI] Print only a single message "rejecting I/O  to device being removed"
Date: Tue, 7 Nov 2006 08:45:08 +0100
Message-ID: <20061107074508.GP19471@kernel.dk>
References: <20061105113628.GU13555@kernel.dk> <267953.40180.qm@web31808.mail.mud.yahoo.com> <20061106210023.GJ19471@kernel.dk> <1162851375.4551.6.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([62.242.22.158]:8815 "EHLO kernel.dk")
	by vger.kernel.org with ESMTP id S1754090AbWKGHm7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Nov 2006 02:42:59 -0500
Content-Disposition: inline
In-Reply-To: <1162851375.4551.6.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Luben Tuikov <ltuikov@yahoo.com>, linux-scsi <linux-scsi@vger.kernel.org>

On Tue, Nov 07 2006, James Bottomley wrote:
> On Mon, 2006-11-06 at 22:00 +0100, Jens Axboe wrote:
> > So, again, I'll ask James' (this time cc'ed) opinion on what he thinks.
> > Perhaps he agrees that we should go the ratelimit route, or perhaps he
> > likes your version.  If the former, I'll be happy to code that up
> > (should be a 1 minute job).
> 
> I agree we should be using the standard tools rather than inventing our
> own, so printk_ratelimit() would be the correct way to do this.

Alright, then it turns into something like this:

-----

[SCSI] Rate limit IO reject messages

Otherwise we can flood the system with messages when a device is
removed.

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index d2c02df..a935b9d 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1149,7 +1149,8 @@ static int scsi_prep_fn(struct request_q
 			    specials_only == SDEV_BLOCK)
 				goto defer;
 			
-			sdev_printk(KERN_ERR, sdev,
+			if (printk_ratelimit())
+				sdev_printk(KERN_ERR, sdev,
 				    "rejecting I/O to device being removed\n");
 			goto kill;
 		}


-- 
Jens Axboe

