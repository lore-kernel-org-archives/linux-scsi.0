From: Boaz Harrosh <openosd@gmail.com>
Subject: Re: [PATCH 2/2] block: support > 16 byte CDBs for SG_IO
Date: Sun, 20 Jul 2014 14:47:49 +0300
Message-ID: <53CBAC65.2040208@gmail.com>
References: <1405851804-29096-1-git-send-email-hch@lst.de> <1405851804-29096-3-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1405851804-29096-3-git-send-email-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 07/20/2014 01:23 PM, Christoph Hellwig wrote:
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Hi Christoph I've quickly reviewed your code and have a few questions

> ---
>  block/scsi_ioctl.c | 24 +++++++++++++++++-------
>  1 file changed, 17 insertions(+), 7 deletions(-)
> 
> diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
> index c4e6633..a804f3e 100644
> --- a/block/scsi_ioctl.c
> +++ b/block/scsi_ioctl.c
> @@ -288,8 +288,6 @@ static int sg_io(struct request_queue *q, struct gendisk *bd_disk,
>  
>  	if (hdr->interface_id != 'S')
>  		return -EINVAL;
> -	if (hdr->cmd_len > BLK_MAX_CDB)
> -		return -EINVAL;
>  
>  	if (hdr->dxfer_len > (queue_max_hw_sectors(q) << 9))
>  		return -EIO;
> @@ -306,14 +304,21 @@ static int sg_io(struct request_queue *q, struct gendisk *bd_disk,
>  			break;
>  		}
>  
> +	ret = -ENOMEM;
>  	rq = blk_get_request(q, writing ? WRITE : READ, GFP_KERNEL);
>  	if (!rq)
> -		return -ENOMEM;
> +		goto out;
>  	blk_rq_set_block_pc(rq);
>  
> +	if (hdr->cmd_len > BLK_MAX_CDB) {
> +		rq->cmd = kzalloc(hdr->cmd_len, GFP_KERNEL);

So two things here:
- hdr->cmd_len is char so can be MAX of 255. I understand that 4 bytes alignment is a SCSI
  thing so you found no point of checking any max size?

- Why the zero alloc, if you are going to paste over it the exact same length. Now if like in scsi
  you need 4 bytes alignment and zero padding yes, but here you do not do this (and probably shouldn't).
  Hence why zero-alloc?

- Looking at sg.h where hdr->cmd_len is defined it stills has a comment of <= 16 you might want to
  remove the comment by now.

> +		if (!rq->cmd)
> +			goto out_put_request;
> +	}
> +
>  	ret = -EFAULT;
>  	if (blk_fill_sghdr_rq(q, rq, hdr, mode))

Inside here: blk_fill_sghdr_rq() calls blk_verify_command() which does:
(Below cmd[] is the buffer copied from user)

	/* Anybody who can open the device can do a read-safe command */
	if (test_bit(cmd[0], filter->read_ok))
		return 0;

	/* Write-safe commands require a writable open */
	if (test_bit(cmd[0], filter->write_ok) && has_write_perm)
		return 0;

Now I am not sure what type "Commands" you guys intend for these large commands
but if they are say SCSI-VARLEN this test will not work. Also a user might fool
the system with pretending to be "read" a device modifying command.

I would pass len to this test function and only permit these above if command is
<= 16. Any "special" large command is root only.

Thanks
Boaz

> -		goto out;
> +		goto out_free_cdb;
>  
>  	if (hdr->iovec_count) {
>  		size_t iov_data_len;
> @@ -323,7 +328,7 @@ static int sg_io(struct request_queue *q, struct gendisk *bd_disk,
>  					    0, NULL, &iov);
>  		if (ret < 0) {
>  			kfree(iov);
> -			goto out;
> +			goto out_free_cdb;
>  		}
>  
>  		iov_data_len = ret;
> @@ -346,7 +351,7 @@ static int sg_io(struct request_queue *q, struct gendisk *bd_disk,
>  				      GFP_KERNEL);
>  
>  	if (ret)
> -		goto out;
> +		goto out_free_cdb;
>  
>  	bio = rq->bio;
>  	memset(sense, 0, sizeof(sense));
> @@ -365,8 +370,13 @@ static int sg_io(struct request_queue *q, struct gendisk *bd_disk,
>  	hdr->duration = jiffies_to_msecs(jiffies - start_time);
>  
>  	ret = blk_complete_sghdr_rq(rq, hdr, bio);
> -out:
> +
> +out_free_cdb:
> +	if (rq->cmd != rq->__cmd)
> +		kfree(rq->cmd);
> +out_put_request:
>  	blk_put_request(rq);
> +out:
>  	return ret;
>  }
>  
> 
