From: Andrew Morton <akpm@digeo.com>
Subject: Re: scsi in 2.5.48
Date: Mon, 18 Nov 2002 01:45:29 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3DD8B6B9.E9EAD230@digeo.com>
References: <3DD8AF65.BF2EF851@digeo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: lkml <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org

Andrew Morton wrote:
> 
> Appears to be DOA.  Just a simple mke2fs hangs in get_request_wait().

This makes it work again.


--- 25/drivers/scsi/scsi_lib.c~scsi-plug	Mon Nov 18 01:42:40 2002
+++ 25-akpm/drivers/scsi/scsi_lib.c	Mon Nov 18 01:42:44 2002
@@ -1024,7 +1024,6 @@ void scsi_request_fn(request_queue_t * q
 			/* can happen if the prep fails 
 			 * FIXME: elv_next_request() should be plugging the
 			 * queue */
-			blk_plug_device(q);
 			break;
 		}
 

_
