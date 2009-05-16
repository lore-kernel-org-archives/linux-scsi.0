From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Subject: Re: [PATCH 15/18] z2ram: dequeue in-flight request
Date: Sat, 16 May 2009 16:54:56 +0400
Message-ID: <4A0EB7A0.10107@ru.mvista.com>
References: <1241751256-17435-1-git-send-email-tj@kernel.org> <1241751256-17435-16-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from h155.mvista.com ([63.81.120.155]:63489 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755447AbZEPMzM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 16 May 2009 08:55:12 -0400
In-Reply-To: <1241751256-17435-16-git-send-email-tj@kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, rusty@rustcorp.com.au, James.Bottomley@HansenPartnership.com, mike.miller@hp.com, donari75@gmail.com, paul.clements@steeleye.com, tim@cyberelk.net, Geert.Uytterhoeven@sonycom.com, davem@davemloft.net, Laurent@lvivier.info, jgarzik@pobox.com, jeremy@xensource.com, grant.likely@secretlab.ca, adrian@mcmen.demon.co.uk, sfr@canb.auug.org.au, bzolnier@gmail.com, petkovbb@googlemail.com, oakad@yahoo.com, drzeus@drzeus.cx, dwmw2@infradead.org, Markus.Lidel@shadowconnect.com, wein@de.ibm.com, schwidefsky@de.ibm.com, zaitcev@redhat.com, fujita.tomonori@lab.ntt.co.jp, axboe@kernel.dk

Hello.

Tejun Heo wrote:

> z2ram processes requests one-by-one synchronously and can be easily
> converted to dequeueing model.  Convert it.
>
> [ Impact: dequeue in-flight request ]
>
> Signed-off-by: Tejun Heo <tj@kernel.org>
> ---
>  drivers/block/z2ram.c |   19 +++++++++++++++----
>  1 files changed, 15 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/block/z2ram.c b/drivers/block/z2ram.c
> index 6a13838..c909c1a 100644
> --- a/drivers/block/z2ram.c
> +++ b/drivers/block/z2ram.c
> @@ -70,15 +70,21 @@ static struct gendisk *z2ram_gendisk;
>  static void do_z2_request(struct request_queue *q)
>  {
>  	struct request *req;
> -	while ((req = elv_next_request(q)) != NULL) {
> +
> +	req = elv_next_request(q);
> +	if (req)
> +		blkdev_dequeue_request(req);
> +
> +	while (req) {
>  		unsigned long start = blk_rq_pos(req) << 9;
>  		unsigned long len  = blk_rq_cur_bytes(req);
> +		int err = 0;
>  
>  		if (start + len > z2ram_size) {
>  			printk( KERN_ERR DEVICE_NAME ": bad access: block=%lu, count=%u\n",
>  				blk_rq_pos(req), blk_rq_cur_sectors(req));
> -			__blk_end_request_cur(req, -EIO);
> -			continue;
> +			err = -EIO;
> +			goto done;
>  		}
>  		while (len) {
>  			unsigned long addr = start & Z2RAM_CHUNKMASK;
> @@ -93,7 +99,12 @@ static void do_z2_request(struct request_queue *q)
>  			start += size;
>  			len -= size;
>  		}
> -		__blk_end_request_cur(req, 0);
> +	done:
> +		if (!__blk_end_request_cur(req, err)) {
> +			req = elv_next_request(q);
> +			if (req)
> +				blkdev_dequeue_request(req);
> +		}
>  	}
>  }
>   

   I'm sure this can be made more compact and without duplication (in 
many other cases as well):

@@ -70,15 +70,21 @@ static struct gendisk *z2ram_gendisk;

 static void do_z2_request(struct request_queue *q)
 {
 	struct request *req;
+
 	while ((req = elv_next_request(q)) != NULL) {
 		unsigned long start = blk_rq_pos(req) << 9;
 		unsigned long len  = blk_rq_cur_bytes(req);
 
+		blkdev_dequeue_request(req);
+
 		if (start + len > z2ram_size) {
 			printk( KERN_ERR DEVICE_NAME ": bad access: block=%lu, count=%u\n",
 				blk_rq_pos(req), blk_rq_cur_sectors(req));
-			__blk_end_request_cur(req, -EIO);
-			continue;
+			err = -EIO;
+			goto done;
 		}
 		while (len) {
 			unsigned long addr = start & Z2RAM_CHUNKMASK;
@@ -93,7 +99,12 @@ static void do_z2_request(struct request_queue *q)
 			start += size;
 			len -= size;
 		}
-		__blk_end_request_cur(req, 0);
+	done:
+		if (__blk_end_request_cur(req, err));
+			break;
 	}
 }


MBR, Sergei


