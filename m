From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH scsi-misc-2.6 04/13] scsi: remove meaningless volatile qualifiers from structure definitions
Date: Thu, 31 Mar 2005 11:11:45 +0100
Message-ID: <20050331101145.GA13842@infradead.org>
References: <20050331090647.FEDC3964@htj.dyndns.org> <20050331090647.57213FBA@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:3043 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S261234AbVCaKLt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 31 Mar 2005 05:11:49 -0500
Content-Disposition: inline
In-Reply-To: <20050331090647.57213FBA@htj.dyndns.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: James.Bottomley@steeleye.com, axboe@suse.de, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Thu, Mar 31, 2005 at 06:08:10PM +0900, Tejun Heo wrote:
>  	struct list_head    siblings;   /* list of all devices on this host */
>  	struct list_head    same_target_siblings; /* just the devices sharing same target id */
>  
> -	volatile unsigned short device_busy;	/* commands actually active on low-level */
> +	unsigned short device_busy;	/* commands actually active on
> +					 * low-level. protected by sdev_lock. */

You should probably switch it to just unsigned.  The other 16bit are wasted
due to alignment anyway, and some architectures produce better code for 32bit
accesses.

> -	volatile unsigned short host_busy;   /* commands actually active on low-level */
> -	volatile unsigned short host_failed; /* commands that failed. */
> +
> +	/*
> +	 * The following two fields are protected with host_lock;
> +	 * however, eh routines can safely access during eh processing
> +	 * without acquiring the lock.
> +	 */
> +	unsigned short host_busy;	   /* commands actually active on low-level */
> +	unsigned short host_failed;	   /* commands that failed. */

Here it would actually increase the struct size but might make sense anyway.

