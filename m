From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 2/4] block layer varlen-cdb
Date: Thu, 1 Nov 2007 12:40:00 -0600
Message-ID: <20071101184000.GM15111@parisc-linux.org>
References: <472A12D6.805@panasas.com> <472A1552.6030700@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:44453 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755455AbXKASkD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Nov 2007 14:40:03 -0400
Content-Disposition: inline
In-Reply-To: <472A1552.6030700@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Jens Axboe <jens.axboe@oracle.com>, Mike Christie <michaelc@cs.wisc.edu>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi <linux-scsi@vger.kernel.org>, open-iscsi@googlegroups.com, Pete Wyckoff <pw@osc.edu>, Benny Halevy <bhalevy@panasas.com>

On Thu, Nov 01, 2007 at 08:05:06PM +0200, Boaz Harrosh wrote:
> @@ -287,8 +287,13 @@ struct request {
>  	/*
>  	 * when request is used as a packet command carrier
>  	 */
> -	unsigned int cmd_len;
> +	unsigned short cmd_len;
> +	unsigned short varlen_cdb_len;  /* length of varlen_cdb buffer */
>  	unsigned char cmd[BLK_MAX_CDB];
> +	unsigned char *varlen_cdb;      /* an optional variable-length cdb.
> +	                                 * points to a user buffer that must be
> +	                                 * valid until end of request
> +	                                 */
>  

Try this instead:

 	unsigned int cmd_len;
-	unsigned char cmd[BLK_MAX_CDB];
+	unsigned char _cmd[BLK_MAX_CDB];
+	unsigned char *cmd;

Then initialise cmd to the address of _cmd.  If you need to override it
later (ie patch 3), you can.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
