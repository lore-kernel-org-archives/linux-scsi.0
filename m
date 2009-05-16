From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Subject: Re: [PATCH 11/18] swim: dequeue in-flight request
Date: Sat, 16 May 2009 17:42:05 +0400
Message-ID: <4A0EC2AD.20704@ru.mvista.com>
References: <1241751256-17435-1-git-send-email-tj@kernel.org> <1241751256-17435-12-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1241751256-17435-12-git-send-email-tj@kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, rusty@rustcorp.com.au, James.Bottomley@HansenPartnership.com, mike.miller@hp.com, donari75@gmail.com, paul.clements@steeleye.com, tim@cyberelk.net, Geert.Uytterhoeven@sonycom.com, davem@davemloft.net, Laurent@lvivier.info, jgarzik@pobox.com, jeremy@xensource.com, grant.likely@secretlab.ca, adrian@mcmen.demon.co.uk, sfr@canb.auug.org.au, bzolnier@gmail.com, petkovbb@googlemail.com, oakad@yahoo.com, drzeus@drzeus.cx, dwmw2@infradead.org, Markus.Lidel@shadowconnect.com, wein@de.ibm.com, schwidefsky@de.ibm.com, zaitcev@redhat.com, fujita.tomonori@lab.ntt.co.jp, axboe@kernel.dk
List-Id: linux-scsi@vger.kernel.org

Hello.

Tejun Heo wrote:

> swim processes requests one-by-one synchronously and can easily be
> converted to dequeuing model.  Convert it.
>
> [ Impact: dequeue in-flight request ]
>
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Laurent Vivier <Laurent@lvivier.info>
> ---
>  drivers/block/swim.c |   47 +++++++++++++++++++++++------------------------
>  1 files changed, 23 insertions(+), 24 deletions(-)
>
> diff --git a/drivers/block/swim.c b/drivers/block/swim.c
> index fc6a1c3..dedd489 100644
> --- a/drivers/block/swim.c
> +++ b/drivers/block/swim.c
> @@ -514,7 +514,7 @@ static int floppy_read_sectors(struct floppy_state *fs,
>  			ret = swim_read_sector(fs, side, track, sector,
>  						buffer);
>  			if (try-- == 0)
> -				return -1;
> +				return -EIO;
>  		} while (ret != 512);
>  
>  		buffer += ret;
> @@ -528,38 +528,37 @@ static void redo_fd_request(struct request_queue *q)
>  	struct request *req;
>  	struct floppy_state *fs;
>  
> -	while ((req = elv_next_request(q))) {
> +	req = elv_next_request(q);
> +	if (req)
> +		blkdev_dequeue_request(req);
> +
> +	while (req) {
> +		int err = -EIO;
>  
>  		fs = req->rq_disk->private_data;
> -		if (blk_rq_pos(req) >= fs->total_secs) {
> -			__blk_end_request_cur(req, -EIO);
> -			continue;
> -		}
> -		if (!fs->disk_in) {
> -			__blk_end_request_cur(req, -EIO);
> -			continue;
> -		}
> -		if (rq_data_dir(req) == WRITE) {
> -			if (fs->write_protected) {
> -				__blk_end_request_cur(req, -EIO);
> -				continue;
> -			}
> -		}
> +		if (blk_rq_pos(req) >= fs->total_secs)
> +			goto done;
> +		if (!fs->disk_in)
> +			goto done;
> +		if (rq_data_dir(req) == WRITE && fs->write_protected)
> +			goto done;
> +
>  		switch (rq_data_dir(req)) {
>  		case WRITE:
>  			/* NOT IMPLEMENTED */
> -			__blk_end_request_cur(req, -EIO);
>  			break;
>  		case READ:
> -			if (floppy_read_sectors(fs, blk_rq_pos(req),
> -						blk_rq_cur_sectors(req),
> -						req->buffer)) {
> -				__blk_end_request_cur(req, -EIO);
> -				continue;
> -			}
> -			__blk_end_request_cur(req, 0);
> +			err = floppy_read_sectors(fs, blk_rq_pos(req),
> +						  blk_rq_cur_sectors(req),
> +						  req->buffer);
>  			break;
>  		}
> +	done:
> +		if (!__blk_end_request_cur(req, err)) {
> +			req = elv_next_request(q);
> +			if (req)
> +				blkdev_dequeue_request(req);
> +		}
>  	}
>  }

   And without duplication:

@@ -528,38 +528,37 @@
 static void redo_fd_request(struct request_queue *q)
 {
- 	struct request *req;
 	struct floppy_state *fs;
 
-	while ((req = elv_next_request(q))) {
+	while (1) {
+	 	struct request *req = elv_next_request(q);
+		int err;
+ 
+		if (req == NULL)
+			break;
+		blkdev_dequeue_request(req);
 
+again:
+		err = -EIO;
 		fs = req->rq_disk->private_data;
-		if (blk_rq_pos(req) >= fs->total_secs) {
-			__blk_end_request_cur(req, -EIO);
-			continue;
-		}
-		if (!fs->disk_in) {
-			__blk_end_request_cur(req, -EIO);
-			continue;
-		}
-		if (rq_data_dir(req) == WRITE) {
-			if (fs->write_protected) {
-				__blk_end_request_cur(req, -EIO);
-				continue;
-			}
-		}
+		if (blk_rq_pos(req) >= fs->total_secs)
+			goto done;
+		if (!fs->disk_in)
+			goto done;
+		if (rq_data_dir(req) == WRITE && fs->write_protected)
+			goto done;
+
 		switch (rq_data_dir(req)) {
 		case WRITE:
 			/* NOT IMPLEMENTED */
-			__blk_end_request_cur(req, -EIO);
 			break;
 		case READ:
-			if (floppy_read_sectors(fs, blk_rq_pos(req),
-						blk_rq_cur_sectors(req),
-						req->buffer)) {
-				__blk_end_request_cur(req, -EIO);
-				continue;
-			}
-			__blk_end_request_cur(req, 0);
+			err = floppy_read_sectors(fs, blk_rq_pos(req),
+						  blk_rq_cur_sectors(req),
+						  req->buffer);
 			break;
 		}
+	done:
+		if (__blk_end_request_cur(req, err))
+			goto again;
 	}
 }


MBR, Sergei


