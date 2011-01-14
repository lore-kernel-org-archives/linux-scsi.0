From: Jonathan McDowell <noodles@earth.li>
Subject: Re: [PATCH v3 1/3] scsi: Detailed I/O errors
Date: Fri, 14 Jan 2011 08:10:48 -0800
Message-ID: <20110114161048.GK5727@earth.li>
References: <1295020736-27699-1-git-send-email-snitzer@redhat.com> <1295020736-27699-2-git-send-email-snitzer@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from the.earth.li ([217.147.81.2]:45575 "EHLO the.earth.li"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751431Ab1ANQlw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 14 Jan 2011 11:41:52 -0500
Content-Disposition: inline
In-Reply-To: <1295020736-27699-2-git-send-email-snitzer@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: James Bottomley <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org, agk@redhat.com, jaxboe@fusionio.com, Hannes Reinecke <hare@suse.de>, michaelc@cs.wisc.edu

On Fri, Jan 14, 2011 at 10:58:54AM -0500, Mike Snitzer wrote:
> From: Hannes Reinecke <hare@suse.de>
> 
> Instead of just passing 'EIO' for any I/O error we should be
> notifying the upper layers with more details about the cause
> of this error.
> 
> Update the possible I/O errors to:
> 
> - ENOLINK: Link failure between host and target
> - EIO: Retryable I/O error
> - EREMOTEIO: Non-retryable I/O error
> 
> 'Retryable' in this context means that an I/O error _might_ be
> restricted to the I_T_L nexus (vulgo: path), so retrying on another
> nexus / path might succeed.
...
> @@ -1486,6 +1495,7 @@ int scsi_decide_disposition(struct scsi_cmnd *scmd)
>  	case RESERVATION_CONFLICT:
>  		sdev_printk(KERN_INFO, scmd->device,
>  			    "reservation conflict\n");
> +		scmd->result |= (DID_TARGET_FAILURE << 16);
>  		return SUCCESS; /* causes immediate i/o error */
>  	default:
>  		return FAILED;
...
> +#define DID_TARGET_FAILURE 0x10 /* Permanent target failure, do not retry on
> +				 * other paths */

I'd have viewed a reservation conflict as being tied to a particular
path, rather than the entire target. I've seen multipath setups where
there are reservation issues on some of the paths but others are fine
and this is expected (eg use of reservations to fence off particular
paths).

J.

-- 
/-\                             |   It's more than good enough so I
|@/  Debian GNU/Linux Developer |           ain't switch'n.
\-                              |
