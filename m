From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] blk request timeout minor fixes...
Date: Sun, 2 Dec 2007 19:49:45 -0700
Message-ID: <20071203024945.GO2584@parisc-linux.org>
References: <20071106065439.GA30397@us.ibm.com> <47301DA7.8000202@panasas.com> <20071106223453.GA5668@us.ibm.com> <20071107132256.GG5525@kernel.dk> <20071114023929.GB29136@us.ibm.com> <20071203015330.GA3485@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:40419 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751914AbXLCCtp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 2 Dec 2007 21:49:45 -0500
Content-Disposition: inline
In-Reply-To: <20071203015330.GA3485@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>, linux-scsi@vger.kernel.org, andmike@us.ibm.com

On Sun, Dec 02, 2007 at 05:53:30PM -0800, malahal@us.ibm.com wrote:
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index 917fe86..e495d61 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -295,7 +295,8 @@ struct request {
>  	void *data;
>  	void *sense;
>  
> -	unsigned long timeout;
> +	unsigned long deadline;
> +	unsigned int timeout;
>  	struct list_head timeout_list;
>  	int retries;

Can I suggest running 'pahole' over this when compiled on 64-bit?
You've just introduced a 4-byte hole.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
