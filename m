From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] sg.c to set direction more reliably  (was Re: [PATCH] fusion update to current APIs)
Date: Tue, 15 Jun 2004 09:17:04 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040615081704.GA15795@infradead.org>
References: <20040531115229.GA16143@lst.de> <20040612003608.GA152454@sgi.com> <20040612034518.GN24864@parcelfarce.linux.theplanet.co.uk> <20040612051353.GA152829@sgi.com> <20040612052003.GR24864@parcelfarce.linux.theplanet.co.uk> <20040615060811.GA178857@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [213.146.154.40] ([213.146.154.40]:18663 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S265360AbUFOIRR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Jun 2004 04:17:17 -0400
Content-Disposition: inline
In-Reply-To: <20040615060811.GA178857@sgi.com>
List-Id: linux-scsi@vger.kernel.org
To: Jeremy Higdon <jeremy@sgi.com>
Cc: Matthew Wilcox <willy@debian.org>, Christoph Hellwig <hch@lst.de>, Emoore@lsil.com, linux-scsi@vger.kernel.org

Not too happy about working around broken apps in the kernel.  At least
remove vendor-specific commands here and add a big printk about the app
writer beeing stupid when it detects a mismatch, or even better return
EINVAL for that case.

On Mon, Jun 14, 2004 at 11:08:11PM -0700, Jeremy Higdon wrote:
> ===== drivers/scsi/sg.c 1.90 vs edited =====
> --- 1.90/drivers/scsi/sg.c	Sat May 29 10:57:23 2004
> +++ edited/drivers/scsi/sg.c	Mon Jun 14 22:36:55 2004
> @@ -480,6 +480,61 @@
>  	return (0 == err) ? count : err;
>  }
>  
> +
> +static int
> +sg_direction(char *cmnd)
> +{
> +	switch (cmnd[0]) {
> +	/*  _DATA_OUT commands	*/
> +	case WRITE_6:		case WRITE_10:		case WRITE_12:
> +	case WRITE_16:
> +	case WRITE_LONG:	case WRITE_SAME:	case WRITE_BUFFER:
> +	case WRITE_VERIFY:	case WRITE_VERIFY_12:
> +	case COMPARE:		case COPY:		case COPY_VERIFY:
> +	case SEARCH_EQUAL:	case SEARCH_HIGH:	case SEARCH_LOW:
> +	case SEARCH_EQUAL_12:	case SEARCH_HIGH_12:	case SEARCH_LOW_12:
> +	case MODE_SELECT:	case MODE_SELECT_10:	case LOG_SELECT:
> +	case SEND_DIAGNOSTIC:	case CHANGE_DEFINITION: case UPDATE_BLOCK:
> +	case SET_WINDOW:	case MEDIUM_SCAN:	case SEND_VOLUME_TAG:
> +	case REASSIGN_BLOCKS:
> +	case PERSISTENT_RESERVE_OUT:
> +	case 0xea:
> +	case 0xa3:
> +		return SG_DXFER_TO_DEV;
> +
> +	/*  No data transfer commands  */
> +	case SEEK_6:		case SEEK_10:
> +	case RESERVE:		case RELEASE:
> +	case TEST_UNIT_READY:
> +	case START_STOP:
> +	case ALLOW_MEDIUM_REMOVAL:
> +		return SG_DXFER_NONE;
> +
> +	/*  Conditional data transfer commands	*/
> +	case FORMAT_UNIT:
> +		if (cmnd[1] & 0x10)	/* FmtData (data out phase)? */
> +			return SG_DXFER_TO_DEV;
> +		else
> +			return SG_DXFER_NONE;
> +
> +	case VERIFY:
> +		if (cmnd[1] & 0x02)	/* VERIFY:BYTCHK (data out phase)? */
> +			return SG_DXFER_TO_DEV;
> +		else
> +			return SG_DXFER_NONE;
> +
> +	case RESERVE_10:
> +		if (cmnd[1] & 0x03)  /* RESERVE:{LongID|Extent} (data out phase)? */
> +			return SG_DXFER_TO_DEV;
> +		else
> +			return SG_DXFER_NONE;
> +
> +	/*  Must be data _IN!  */
> +	default:
> +		return SG_DXFER_FROM_DEV;
> +	}
> +}
> +
>  static ssize_t
>  sg_write(struct file *filp, const char __user *buf, size_t count, loff_t * ppos)
>  {
> @@ -552,11 +607,6 @@
>  	hp->cmd_len = (unsigned char) cmd_size;
>  	hp->iovec_count = 0;
>  	hp->mx_sb_len = 0;
> -	if (input_size > 0)
> -		hp->dxfer_direction = (old_hdr.reply_len > SZ_SG_HEADER) ?
> -		    SG_DXFER_TO_FROM_DEV : SG_DXFER_TO_DEV;
> -	else
> -		hp->dxfer_direction = (mxsize > 0) ? SG_DXFER_FROM_DEV : SG_DXFER_NONE;
>  	hp->dxfer_len = mxsize;
>  	hp->dxferp = (char __user *)buf + cmd_size;
>  	hp->sbp = NULL;
> @@ -566,6 +616,18 @@
>  	hp->usr_ptr = NULL;
>  	if (__copy_from_user(cmnd, buf, cmd_size))
>  		return -EFAULT;
> +	/*
> +	 * If data direction is indeterminate because both input and output size
> +	 * are greater than 0, use command bytes to determine direction.
> +	 */
> +	if (input_size == 0 && mxsize > 0)
> +		hp->dxfer_direction = SG_DXFER_FROM_DEV;
> +	else if (input_size > 0 && mxsize == 0)
> +		hp->dxfer_direction = SG_DXFER_TO_DEV;
> +	else if (input_size == 0 && mxsize == 0)
> +		hp->dxfer_direction = SG_DXFER_NONE;
> +	else
> +		hp->dxfer_direction = sg_direction(cmnd);
>  	k = sg_common_write(sfp, srp, cmnd, sfp->timeout, blocking);
>  	return (k < 0) ? k : count;
>  }
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
---end quoted text---
