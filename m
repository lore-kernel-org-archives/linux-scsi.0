From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [PATCH] sg.c to set direction more reliably  (was Re: [PATCH] fusion update to current APIs)
Date: Tue, 15 Jun 2004 10:42:35 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040615104235.A21082@beaverton.ibm.com>
References: <20040531115229.GA16143@lst.de> <20040612003608.GA152454@sgi.com> <20040612034518.GN24864@parcelfarce.linux.theplanet.co.uk> <20040612051353.GA152829@sgi.com> <20040612052003.GR24864@parcelfarce.linux.theplanet.co.uk> <20040615060811.GA178857@sgi.com> <20040615081704.GA15795@infradead.org> <20040615084807.GB177665@sgi.com> <20040615091042.GA168267@sgi.com> <20040615093148.GA179519@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.105]:32147 "EHLO e5.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S265787AbUFORnG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Jun 2004 13:43:06 -0400
Content-Disposition: inline
In-Reply-To: <20040615093148.GA179519@sgi.com>; from jeremy@sgi.com on Tue, Jun 15, 2004 at 02:31:48AM -0700
List-Id: linux-scsi@vger.kernel.org
To: Jeremy Higdon <jeremy@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, Matthew Wilcox <willy@debian.org>, Christoph Hellwig <hch@lst.de>, Emoore@lsil.com, linux-scsi@vger.kernel.org

On Tue, Jun 15, 2004 at 02:31:48AM -0700, Jeremy Higdon wrote:
> On Tue, Jun 15, 2004 at 02:10:43AM -0700, Jeremy Higdon wrote:
> > One more comment from hch via IRC.  When we have to guess direction,
> > print a suggestion to use SG v3 interface.

But print only once, so borked applications that continually poll devices
won't generate lots of these messages.

> +	/*
> +	 * If data direction is indeterminate because both input and output size
> +	 * are greater than 0, use command bytes to determine direction.
> +	 */
> +	if (input_size == 0 && mxsize > 0)
> +		hp->dxfer_direction = SG_DXFER_FROM_DEV;
> +	else if (input_size > 0 && old_hdr.reply_len <= SZ_SG_HEADER)
> +		hp->dxfer_direction = SG_DXFER_TO_DEV;
> +	else if (input_size == 0 && mxsize == 0)
> +		hp->dxfer_direction = SG_DXFER_NONE;
> +	else {
> +		hp->dxfer_direction = sg_direction(cmnd);
> +		printk("sg_write: cannot infer direction from count %ld "
> +		       "and reply_len %d; inferring from command 0x%x.  Please "
> +		       "fix the application to use the sg version 3 interface\n",
> +		       count, old_hdr.reply_len, (unsigned int) cmnd[0]);
> +	}
>  	k = sg_common_write(sfp, srp, cmnd, sfp->timeout, blocking);
>  	return (k < 0) ? k : count;
>  }
