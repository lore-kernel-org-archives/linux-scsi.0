From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: Infinite retries reading the partition table
Date: Wed, 06 Dec 2006 09:59:47 -0600
Message-ID: <1165420788.2810.13.camel@mulgrave.il.steeleye.com>
References: <4575D951.3010705@sgi.com>
	 <794609.32071.qm@web31811.mail.mud.yahoo.com>
	 <20061205210853.e2661207.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:35012 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S936202AbWLFP76 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Dec 2006 10:59:58 -0500
In-Reply-To: <20061205210853.e2661207.akpm@osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: ltuikov@yahoo.com, mdr@sgi.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue, 2006-12-05 at 21:08 -0800, Andrew Morton wrote:
>  	case MEDIUM_ERROR:
> +		if (sshdr.asc == 0x11 || /* UNRECOVERED READ ERR */
> +		    sshdr.asc == 0x13 || /* AMNF DATA FIELD */
> +		    sshdr.asc == 0x14) { /* RECORD NOT FOUND */
> +			return SUCCESS;
> +		}
>  		return NEEDS_RETRY;

If the complaint is true; i.e. infinite retries, this is just a bandaid
not a fix.  What it's doing is marking the unrecoverable medium errors
for no retry.  However, what we really need to know is why NEEDS_RETRY
isn't terminating after its allotted number of retries.  Can we please
have a trace of this?
 
> -	if (scsi_end_request(cmd, 1, good_bytes, result == 0) == NULL)
> +	if (good_bytes &&
> +	    scsi_end_request(cmd, 1, good_bytes, result == 0) == NULL)
>  		return;

What exactly is this supposed to be doing?  its result is identical to
the code it's replacing (because of the way scsi_end_request() processes
its second argument), so it can't have any effect on the stated problem.

James


