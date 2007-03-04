From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 7/7] mv user buffer copy access_ok test to block helper
Date: Sun, 04 Mar 2007 16:56:46 -0600
Message-ID: <45EB4EAE.6000909@cs.wisc.edu>
References: <1173033084706-git-send-email-michaelc@cs.wisc.edu> <11730330852430-git-send-email-michaelc@cs.wisc.edu> <11730330851234-git-send-email-michaelc@cs.wisc.edu> <11730330861995-git-send-email-michaelc@cs.wisc.edu> <11730330872229-git-send-email-michaelc@cs.wisc.edu> <11730330881574-git-send-email-michaelc@cs.wisc.edu> <11730330893660-git-send-email-michaelc@cs.wisc.edu> <11730330902393-git-send-email-michaelc@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:47233 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752515AbXCDW4z (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 4 Mar 2007 17:56:55 -0500
In-Reply-To: <11730330902393-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: jens.axboe@oracle.com, dougg@torque.net

michaelc@cs.wisc.edu wrote:
> +				if (!access_ok(read ?
> +					       VERIFY_WRITE : VERIFY_READ,
> +					       p, iov_len))
> +					return -EFAULT;
>  			}
>  
>  			copy_bytes = min(iov_len, bvec->bv_len - bvec_offset);
> -			if (bio_data_dir(head) == READ)
> +			if (read)
>  				ret = copy_to_user(p, addr, copy_bytes);
>  			else
>  				ret = copy_from_user(addr, p, copy_bytes);

Tomo notified me that copy_from/to_user does the access_ok test so this
patch is not needed.
