From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH v2] scsi_lib: rate-limit the error message from failing
 commands
Date: Thu, 08 Mar 2012 11:59:52 +0100
Message-ID: <4F589128.9020506@redhat.com>
References: <20120307235632.10375.55053.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:16666 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756376Ab2CHLAV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 8 Mar 2012 06:00:21 -0500
In-Reply-To: <20120307235632.10375.55053.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Yi Zou <yi.zou@intel.com>
Cc: linux-scsi@vger.kernel.org, devel@open-fcoe.org

On 03/08/2012 12:56 AM, Yi Zou wrote:
> When performing a cable pull test w/ active stress I/O using fio over
> a dual port Intel 82599 FCoE CNA, w/ 256LUNs on one port and about 32LUNs
> on the other, it is observed that the system becomes not usable due to
> scsi-ml being busy printing the error messages for all the failing commands.
> I don't believe this problem is specific to FCoE and these commands are
> anyway failing due to link being down (DID_NO_CONNECT), just rate-limit
> the messages here to solve this issue.
>
> v2->v1: use __ratelimit() as Tomas Henzl mentioned as the proper way for
> rate-limit per function. However, in this case, the failed i/o gets to
> blk_end_request_err() and then blk_update_request(), which also has to
> be rate-limited, as added in the v2 of this patch.
>
> Signed-off-by: Yi Zou <yi.zou@intel.com>
> Cc: www.Open-FCoE.org <devel@open-fcoe.org>
> Cc: Tomas Henzl <thenzl@redhat.com>
I thinks the rate limit is fine, thanks.

Acked-by: Tomas Henzl <thenzl@redhat.com>

> ---
>
>  block/blk-core.c        |    8 +++++---
>  drivers/scsi/scsi_lib.c |    5 ++++-
>  2 files changed, 9 insertions(+), 4 deletions(-)
>
> diff --git a/block/blk-core.c b/block/blk-core.c
> index 3a78b00..4415c86 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -29,6 +29,7 @@
>  #include <linux/fault-inject.h>
>  #include <linux/list_sort.h>
>  #include <linux/delay.h>
> +#include <linux/ratelimit.h>
>  
>  #define CREATE_TRACE_POINTS
>  #include <trace/events/block.h>
> @@ -2132,9 +2133,10 @@ bool blk_update_request(struct request *req, int error, unsigned int nr_bytes)
>  			error_type = "I/O";
>  			break;
>  		}
> -		printk(KERN_ERR "end_request: %s error, dev %s, sector %llu\n",
> -		       error_type, req->rq_disk ? req->rq_disk->disk_name : "?",
> -		       (unsigned long long)blk_rq_pos(req));
> +		printk_ratelimited(KERN_ERR "end_request: %s error, dev %s, "
> +				   "sector %llu\n", error_type, req->rq_disk ?
> +				   req->rq_disk->disk_name : "?",
> +				   (unsigned long long)blk_rq_pos(req));
>  	}
>  
>  	blk_account_io_completion(req, nr_bytes);
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index b2c95db..06cf08a 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -20,6 +20,7 @@
>  #include <linux/delay.h>
>  #include <linux/hardirq.h>
>  #include <linux/scatterlist.h>
> +#include <linux/ratelimit.h>
>  
>  #include <scsi/scsi.h>
>  #include <scsi/scsi_cmnd.h>
> @@ -745,6 +746,8 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
>  	enum {ACTION_FAIL, ACTION_REPREP, ACTION_RETRY,
>  	      ACTION_DELAYED_RETRY} action;
>  	char *description = NULL;
> +	static DEFINE_RATELIMIT_STATE(rs,  DEFAULT_RATELIMIT_INTERVAL,
> +				      DEFAULT_RATELIMIT_BURST);
>  
>  	if (result) {
>  		sense_valid = scsi_command_normalize_sense(cmd, &sshdr);
> @@ -934,7 +937,7 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
>  	case ACTION_FAIL:
>  		/* Give up and fail the remainder of the request */
>  		scsi_release_buffers(cmd);
> -		if (!(req->cmd_flags & REQ_QUIET)) {
> +		if (!(req->cmd_flags & REQ_QUIET) && __ratelimit(&rs)) {
>  			if (description)
>  				scmd_printk(KERN_INFO, cmd, "%s\n",
>  					    description);
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

