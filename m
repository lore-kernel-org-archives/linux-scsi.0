From: Benjamin Block <bblock@linux.vnet.ibm.com>
Subject: Re: [PATCH 8/9] block: pass full fmode_t to blk_verify_command
Date: Mon, 16 Oct 2017 18:50:56 +0200
Message-ID: <20171016165056.GD26185@bblock-ThinkPad-W530>
References: <20171003104845.10417-1-hch@lst.de>
 <20171003104845.10417-9-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:43588 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1754694AbdJPQvA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 16 Oct 2017 12:51:00 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id v9GGmk0b036955
        for <linux-scsi@vger.kernel.org>; Mon, 16 Oct 2017 12:51:00 -0400
Received: from e06smtp10.uk.ibm.com (e06smtp10.uk.ibm.com [195.75.94.106])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2dmxyu5d29-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Mon, 16 Oct 2017 12:51:00 -0400
Received: from localhost
        by e06smtp10.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <bblock@linux.vnet.ibm.com>;
        Mon, 16 Oct 2017 17:50:58 +0100
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id v9GGou1I26280078
        for <linux-scsi@vger.kernel.org>; Mon, 16 Oct 2017 16:50:56 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DEFF342047
        for <linux-scsi@vger.kernel.org>; Mon, 16 Oct 2017 17:46:31 +0100 (BST)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C4E0542041
        for <linux-scsi@vger.kernel.org>; Mon, 16 Oct 2017 17:46:31 +0100 (BST)
Received: from bblock-ThinkPad-W530 (unknown [9.152.212.38])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP
        for <linux-scsi@vger.kernel.org>; Mon, 16 Oct 2017 17:46:31 +0100 (BST)
Content-Disposition: inline
In-Reply-To: <20171003104845.10417-9-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, Johannes Thumshirn <jthumshirn@suse.de>

On Tue, Oct 03, 2017 at 12:48:44PM +0200, Christoph Hellwig wrote:
> Use the obvious calling convention.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  block/bsg.c            | 18 ++++++++----------
>  block/scsi_ioctl.c     |  8 ++++----
>  drivers/scsi/sg.c      |  2 +-
>  include/linux/blkdev.h |  2 +-
>  4 files changed, 14 insertions(+), 16 deletions(-)
> 
> diff --git a/block/bsg.c b/block/bsg.c
> index ee1335c68de7..452f94f1c5d4 100644
> --- a/block/bsg.c
> +++ b/block/bsg.c
> @@ -137,7 +137,7 @@ static inline struct hlist_head *bsg_dev_idx_hash(int index)
> 
>  static int blk_fill_sgv4_hdr_rq(struct request_queue *q, struct request *rq,
>  				struct sg_io_v4 *hdr, struct bsg_device *bd,
> -				fmode_t has_write_perm)
> +				fmode_t mode)
>  {
>  	struct scsi_request *req = scsi_req(rq);
> 
> @@ -152,7 +152,7 @@ static int blk_fill_sgv4_hdr_rq(struct request_queue *q, struct request *rq,
>  		return -EFAULT;
> 
>  	if (hdr->subprotocol == BSG_SUB_PROTOCOL_SCSI_CMD) {
> -		if (blk_verify_command(req->cmd, has_write_perm))
> +		if (blk_verify_command(req->cmd, mode))
>  			return -EPERM;
>  	} else if (!capable(CAP_SYS_RAWIO))
>  		return -EPERM;
> @@ -206,7 +206,7 @@ bsg_validate_sgv4_hdr(struct sg_io_v4 *hdr, int *op)
>   * map sg_io_v4 to a request.
>   */
>  static struct request *
> -bsg_map_hdr(struct bsg_device *bd, struct sg_io_v4 *hdr, fmode_t has_write_perm)
> +bsg_map_hdr(struct bsg_device *bd, struct sg_io_v4 *hdr, fmode_t mode)
>  {
>  	struct request_queue *q = bd->queue;
>  	struct request *rq, *next_rq = NULL;
> @@ -237,7 +237,7 @@ bsg_map_hdr(struct bsg_device *bd, struct sg_io_v4 *hdr, fmode_t has_write_perm)
>  	if (IS_ERR(rq))
>  		return rq;
> 
> -	ret = blk_fill_sgv4_hdr_rq(q, rq, hdr, bd, has_write_perm);
> +	ret = blk_fill_sgv4_hdr_rq(q, rq, hdr, bd, mode);
>  	if (ret)
>  		goto out;
> 
> @@ -587,8 +587,7 @@ bsg_read(struct file *file, char __user *buf, size_t count, loff_t *ppos)
>  }
> 
>  static int __bsg_write(struct bsg_device *bd, const char __user *buf,
> -		       size_t count, ssize_t *bytes_written,
> -		       fmode_t has_write_perm)
> +		       size_t count, ssize_t *bytes_written, fmode_t mode)
>  {
>  	struct bsg_command *bc;
>  	struct request *rq;
> @@ -619,7 +618,7 @@ static int __bsg_write(struct bsg_device *bd, const char __user *buf,
>  		/*
>  		 * get a request, fill in the blanks, and add to request queue
>  		 */
> -		rq = bsg_map_hdr(bd, &bc->hdr, has_write_perm);
> +		rq = bsg_map_hdr(bd, &bc->hdr, mode);
>  		if (IS_ERR(rq)) {
>  			ret = PTR_ERR(rq);
>  			rq = NULL;
> @@ -655,8 +654,7 @@ bsg_write(struct file *file, const char __user *buf, size_t count, loff_t *ppos)
>  	bsg_set_block(bd, file);
> 
>  	bytes_written = 0;
> -	ret = __bsg_write(bd, buf, count, &bytes_written,
> -			  file->f_mode & FMODE_WRITE);
> +	ret = __bsg_write(bd, buf, count, &bytes_written, file->f_mode);
> 
>  	*ppos = bytes_written;
> 
> @@ -915,7 +913,7 @@ static long bsg_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
>  		if (copy_from_user(&hdr, uarg, sizeof(hdr)))
>  			return -EFAULT;
> 
> -		rq = bsg_map_hdr(bd, &hdr, file->f_mode & FMODE_WRITE);
> +		rq = bsg_map_hdr(bd, &hdr, file->f_mode);
>  		if (IS_ERR(rq))
>  			return PTR_ERR(rq);
> 
> diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
> index 7440de44dd85..edcfff974527 100644
> --- a/block/scsi_ioctl.c
> +++ b/block/scsi_ioctl.c
> @@ -207,7 +207,7 @@ static void blk_set_cmd_filter_defaults(struct blk_cmd_filter *filter)
>  	__set_bit(GPCMD_SET_READ_AHEAD, filter->write_ok);
>  }
> 
> -int blk_verify_command(unsigned char *cmd, fmode_t has_write_perm)
> +int blk_verify_command(unsigned char *cmd, fmode_t mode)
>  {
>  	struct blk_cmd_filter *filter = &blk_default_cmd_filter;
> 
> @@ -220,7 +220,7 @@ int blk_verify_command(unsigned char *cmd, fmode_t has_write_perm)
>  		return 0;
> 
>  	/* Write-safe commands require a writable open */
> -	if (test_bit(cmd[0], filter->write_ok) && has_write_perm)
> +	if (test_bit(cmd[0], filter->write_ok) && (mode & FMODE_WRITE))
>  		return 0;
> 
>  	return -EPERM;
> @@ -234,7 +234,7 @@ static int blk_fill_sghdr_rq(struct request_queue *q, struct request *rq,
> 
>  	if (copy_from_user(req->cmd, hdr->cmdp, hdr->cmd_len))
>  		return -EFAULT;
> -	if (blk_verify_command(req->cmd, mode & FMODE_WRITE))
> +	if (blk_verify_command(req->cmd, mode))
>  		return -EPERM;
> 
>  	/*
> @@ -469,7 +469,7 @@ int sg_scsi_ioctl(struct request_queue *q, struct gendisk *disk, fmode_t mode,
>  	if (in_len && copy_from_user(buffer, sic->data + cmdlen, in_len))
>  		goto error;
> 
> -	err = blk_verify_command(req->cmd, mode & FMODE_WRITE);
> +	err = blk_verify_command(req->cmd, mode);
>  	if (err)
>  		goto error;
> 
> diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
> index 0419c2298eab..92fd870e1315 100644
> --- a/drivers/scsi/sg.c
> +++ b/drivers/scsi/sg.c
> @@ -217,7 +217,7 @@ static int sg_allow_access(struct file *filp, unsigned char *cmd)
>  	if (sfp->parentdp->device->type == TYPE_SCANNER)
>  		return 0;
> 
> -	return blk_verify_command(cmd, filp->f_mode & FMODE_WRITE);
> +	return blk_verify_command(cmd, filp->f_mode);
>  }
> 
>  static int
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index 02fa42d24b52..75fe9d45ead1 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -1371,7 +1371,7 @@ static inline int sb_issue_zeroout(struct super_block *sb, sector_t block,
>  				    gfp_mask, 0);
>  }
> 
> -extern int blk_verify_command(unsigned char *cmd, fmode_t has_write_perm);
> +extern int blk_verify_command(unsigned char *cmd, fmode_t mode);
> 
>  enum blk_default_limits {
>  	BLK_MAX_SEGMENTS	= 128,
> -- 
> 2.14.1
> 

Reviewed-by: Benjamin Block <bblock@linux.vnet.ibm.com>


                                                    Beste Grüße / Best regards,
                                                      - Benjamin Block
-- 
Linux on z Systems Development         /         IBM Systems & Technology Group
		  IBM Deutschland Research & Development GmbH 
Vorsitz. AufsR.: Martina Koederitz     /        Geschäftsführung: Dirk Wittkopp
Sitz der Gesellschaft: Böblingen / Registergericht: AmtsG Stuttgart, HRB 243294
