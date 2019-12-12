Return-Path: <SRS0=+Znx=2C=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B6DCC43603
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Dec 2019 16:25:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 609E9214AF
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Dec 2019 16:25:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="PfLS7ZDa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729910AbfLLQZ0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 12 Dec 2019 11:25:26 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:50234 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729900AbfLLQZZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Dec 2019 11:25:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=5ym7vw3z3DT5dHcMe5oQGJ3WMFY3uciLjfIk0+QK1sA=; b=PfLS7ZDabCsQBe10ZYCmy7Osh
        eqmh4JYgXMuOmtCehw5ozo+E64CVbOv6Icbl5HqfKCskSuk04WkMVA3T44CQ31gdWT27SMCl+Ibxa
        Hg0i+j3HiOK2geKcqFUSpLeYmygBNqnPb9dPU5UG3SkPATsGN1yDxr8VNAmBlpj+5Hrzy/d4qzuDl
        PkJPDAQf+YnepNxOGLhslNixbuae+XIHu6twlPE0II4IcdMSFvShejsazWRhxkRs+chcRU94DJbLx
        RyjtpaHan8fEJK10suehHhxSO+KSahCInE6RnI3+B49Pt4GBbxS0f8/yvHFGEyS6ZtbhkeKeAPps0
        OUqGvLygA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1ifRH0-0003e6-OW; Thu, 12 Dec 2019 16:25:06 +0000
Date:   Thu, 12 Dec 2019 08:25:06 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Jens Axboe <axboe@kernel.dk>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Douglas Gilbert <dgilbert@interlog.com>,
        linux-kernel@vger.kernel.org, y2038@lists.linaro.org,
        Steffen Maier <maier@linux.ibm.com>,
        linux-scsi@vger.kernel.org,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-block@vger.kernel.org
Subject: Re: [PATCH 02/24] compat: scsi: sg: fix v3 compat read/write
 interface
Message-ID: <20191212162506.GA27991@infradead.org>
References: <20191211204306.1207817-1-arnd@arndb.de>
 <20191211204306.1207817-3-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191211204306.1207817-3-arnd@arndb.de>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Dec 11, 2019 at 09:42:36PM +0100, Arnd Bergmann wrote:
> In the v5.4 merge window, a cleanup patch from Al Viro conflicted
> with my rework of the compat handling for sg.c read(). Linus Torvalds
> did a correct merge but pointed out that the resulting code is still
> unsatisfactory.
> 
> I later noticed that the sg_new_read() function still gets the compat
> mode wrong, when the 'count' argument is large enough to pass a
> compat_sg_io_hdr object, but not a nativ sg_io_hdr.
> 
> To address both of these, move the definition of compat_sg_io_hdr
> into a scsi/sg.h to make it visible to sg.c and rewrite the logic
> for reading req_pack_id as well as the size check to a simpler
> version that gets the expected results.
> 
> Fixes: c35a5cfb4150 ("scsi: sg: sg_read(): simplify reading ->pack_id of userland sg_io_hdr_t")
> Fixes: 98aaaec4a150 ("compat_ioctl: reimplement SG_IO handling")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  block/scsi_ioctl.c |  29 +----------
>  drivers/scsi/sg.c  | 125 +++++++++++++++++++++------------------------
>  include/scsi/sg.h  |  30 +++++++++++
>  3 files changed, 89 insertions(+), 95 deletions(-)
> 
> diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
> index 650bade5ea5a..b61dbf4d8443 100644
> --- a/block/scsi_ioctl.c
> +++ b/block/scsi_ioctl.c
> @@ -20,6 +20,7 @@
>  #include <scsi/scsi.h>
>  #include <scsi/scsi_ioctl.h>
>  #include <scsi/scsi_cmnd.h>
> +#include <scsi/sg.h>
>  
>  struct blk_cmd_filter {
>  	unsigned long read_ok[BLK_SCSI_CMD_PER_LONG];
> @@ -550,34 +551,6 @@ static inline int blk_send_start_stop(struct request_queue *q,
>  	return __blk_send_generic(q, bd_disk, GPCMD_START_STOP_UNIT, data);
>  }
>  
> -#ifdef CONFIG_COMPAT
> -struct compat_sg_io_hdr {
> -	compat_int_t interface_id;	/* [i] 'S' for SCSI generic (required) */
> -	compat_int_t dxfer_direction;	/* [i] data transfer direction  */
> -	unsigned char cmd_len;		/* [i] SCSI command length ( <= 16 bytes) */
> -	unsigned char mx_sb_len;	/* [i] max length to write to sbp */
> -	unsigned short iovec_count;	/* [i] 0 implies no scatter gather */
> -	compat_uint_t dxfer_len;	/* [i] byte count of data transfer */
> -	compat_uint_t dxferp;		/* [i], [*io] points to data transfer memory
> -						or scatter gather list */
> -	compat_uptr_t cmdp;		/* [i], [*i] points to command to perform */
> -	compat_uptr_t sbp;		/* [i], [*o] points to sense_buffer memory */
> -	compat_uint_t timeout;		/* [i] MAX_UINT->no timeout (unit: millisec) */
> -	compat_uint_t flags;		/* [i] 0 -> default, see SG_FLAG... */
> -	compat_int_t pack_id;		/* [i->o] unused internally (normally) */
> -	compat_uptr_t usr_ptr;		/* [i->o] unused internally */
> -	unsigned char status;		/* [o] scsi status */
> -	unsigned char masked_status;	/* [o] shifted, masked scsi status */
> -	unsigned char msg_status;	/* [o] messaging level data (optional) */
> -	unsigned char sb_len_wr;	/* [o] byte count actually written to sbp */
> -	unsigned short host_status;	/* [o] errors from host adapter */
> -	unsigned short driver_status;	/* [o] errors from software driver */
> -	compat_int_t resid;		/* [o] dxfer_len - actual_transferred */
> -	compat_uint_t duration;		/* [o] time taken by cmd (unit: millisec) */
> -	compat_uint_t info;		/* [o] auxiliary information */
> -};
> -#endif
> -
>  int put_sg_io_hdr(const struct sg_io_hdr *hdr, void __user *argp)
>  {
>  #ifdef CONFIG_COMPAT
> diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
> index 160748ad9c0f..985546aac236 100644
> --- a/drivers/scsi/sg.c
> +++ b/drivers/scsi/sg.c
> @@ -198,6 +198,7 @@ static void sg_device_destroy(struct kref *kref);
>  
>  #define SZ_SG_HEADER sizeof(struct sg_header)
>  #define SZ_SG_IO_HDR sizeof(sg_io_hdr_t)
> +#define SZ_COMPAT_SG_IO_HDR sizeof(struct compat_sg_io_hdr)

I'd rather not add more defines like this.  The raw sizeof is
much more readable and obvious.

>  
> +	if (count < SZ_SG_HEADER)
> +		goto unknown_id;
> +
> +	/* negative reply_len means v3 format, otherwise v1/v2 */
> +	if (get_user(reply_len, &old_hdr->reply_len))
> +		return -EFAULT;
> +	if (reply_len >= 0)
> +		return get_user(*pack_id, &old_hdr->pack_id);
> +
> +	if (in_compat_syscall() && count >= SZ_COMPAT_SG_IO_HDR) {
> +		struct compat_sg_io_hdr __user *hp = buf;
> +		return get_user(*pack_id, &hp->pack_id);
> +	}
> +
> +	if (count >= SZ_SG_IO_HDR) {
> +		struct sg_io_hdr __user *hp = buf;
> +		return get_user(*pack_id, &hp->pack_id);
> +	}
> +
> +unknown_id:
> +	/* no valid header was passed, so ignore the pack_id */
> +	*pack_id = -1;
> +	return 0;
> +}

I find the structure here a little confusing, as it doesn't follow
the normal flow.  What do you think of:

	if (count >= SZ_SG_HEADER) {
		if (get_user(reply_len, &old_hdr->reply_len))
			return -EFAULT;

		/* negative reply_len means v3 format, otherwise v1/v2 */
		if (reply_len >= 0)
			return get_user(*pack_id, &old_hdr->pack_id);

		if (in_compat_syscall() {
			if (count >= SZ_COMPAT_SG_IO_HDR) {
				struct compat_sg_io_hdr __user *hp = buf;

				return get_user(*pack_id, &hp->pack_id);
			}
		} else {
			if (count >= SZ_SG_IO_HDR) {
				struct sg_io_hdr __user *hp = buf;

				return get_user(*pack_id, &hp->pack_id);
			}
		}
	}

	/* no valid header was passed, so ignore the pack_id */
	*pack_id = -1;
	return 0;
}
