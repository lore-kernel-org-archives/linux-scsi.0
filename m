From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: rq-based mpath failed path on SCSI target failure (malformed
 discard)
Date: Mon, 26 Jul 2010 11:23:25 -0500
Message-ID: <4C4DB67D.1070903@cs.wisc.edu>
References: <20100726133008.GA26771@redhat.com> <20100726150000.GA31293@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:45102 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753594Ab0GZQTx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 26 Jul 2010 12:19:53 -0400
In-Reply-To: <20100726150000.GA31293@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: linux-scsi@vger.kernel.org, dm-devel@redhat.com

On 07/26/2010 10:00 AM, Mike Snitzer wrote:
>
> diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
> index ec2b43e..125c80f 100644
> --- a/drivers/md/dm-mpath.c
> +++ b/drivers/md/dm-mpath.c
> @@ -1272,6 +1272,9 @@ static int do_end_io(struct multipath *m, struct request *clone,
>   	if (error == -EOPNOTSUPP)
>   		return error;
>
> +	if (clone->cmd_flags&  REQ_DISCARD)
> +		return error;   /* pass all discard request failures up */
> +


If a discard where failed due to a transport problem then you are going 
to fail the IO instead of just retrying on another path.

You need something like Hannes's work to pass up the sense, or something 
like generic block error codes like I started to work on, so you know 
why the IO failed.
