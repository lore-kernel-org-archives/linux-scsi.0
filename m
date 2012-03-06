From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH] scsi_lib: rate-limit the error message from failing commands
Date: Tue, 06 Mar 2012 16:40:08 +0100
Message-ID: <4F562FD8.6040504@redhat.com>
References: <20120305204242.6245.69668.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:20659 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750795Ab2CFPkP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 6 Mar 2012 10:40:15 -0500
In-Reply-To: <20120305204242.6245.69668.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Yi Zou <yi.zou@intel.com>
Cc: linux-scsi@vger.kernel.org, devel@open-fcoe.org

On 03/05/2012 09:42 PM, Yi Zou wrote:
> When performing a cable pull test w/ active stress I/O using fio over
> a dual port Intel 82599 FCoE CNA, w/ 256LUNs on one port and about 32LUNs
> on the other, it is observed that the system becomes not usable due to
> scsi-ml being busy printing the error messages for all the failing commands.
> I don't believe this problem is specific to FCoE and these commands are
> anyway failing due to link being down (DID_NO_CONNECT), just rate-limit
> the messages here to solve this issue.
>
> Signed-off-by: Yi Zou <yi.zou@intel.com>
> Cc: www.Open-FCoE.org <devel@open-fcoe.org>
Hi Zou,
you shouldn't use printk_ratelimit .
checkpatch says:  WARNING: Prefer printk_ratelimited or pr_<level>_ratelimited to printk_ratelimit
Tomas

> ---
>
>  drivers/scsi/scsi_lib.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index b2c95db..e2128d9 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -934,7 +934,8 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
>  	case ACTION_FAIL:
>  		/* Give up and fail the remainder of the request */
>  		scsi_release_buffers(cmd);
> -		if (!(req->cmd_flags & REQ_QUIET)) {
> +		if (!(req->cmd_flags & REQ_QUIET) &&
> +		    printk_ratelimit()) {
>  			if (description)
>  				scmd_printk(KERN_INFO, cmd, "%s\n",
>  					    description);
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

