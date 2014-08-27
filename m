From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH RESEND] libiscsi: Don't retry if xmit_task return a non-transient
 error code
Date: Wed, 27 Aug 2014 13:44:59 -0500
Message-ID: <53FE272B.4000803@cs.wisc.edu>
References: <1408289020-31847-1-git-send-email-sagig@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:60535 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964884AbaH0SyL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 27 Aug 2014 14:54:11 -0400
In-Reply-To: <1408289020-31847-1-git-send-email-sagig@mellanox.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sagi Grimberg <sagig@mellanox.com>, jbottomley@parallels.com, hch@infradead.org
Cc: linux-scsi@vger.kernel.org, ogerlitz@mellanox.com

On 08/17/2014 10:23 AM, Sagi Grimberg wrote:
> Allow transport callback xmit_task to return a non-transient
> error code -EINVAL to inform us not to retry the task. For any
> other error code keep the current retry behavior.
> 
> Signed-off-by: Sagi Grimberg <sagig@mellanox.com>
> ---
>  drivers/scsi/libiscsi.c |   13 ++++++++++---
>  1 files changed, 10 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
> index 3d1bc67..03768a9 100644
> --- a/drivers/scsi/libiscsi.c
> +++ b/drivers/scsi/libiscsi.c
> @@ -1722,10 +1722,17 @@ int iscsi_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *sc)
>  				goto prepd_fault;
>  			}
>  		}
> -		if (session->tt->xmit_task(task)) {
> +
> +		reason = session->tt->xmit_task(task);
> +		if (reason) {
>  			session->cmdsn--;
> -			reason = FAILURE_SESSION_NOT_READY;
> -			goto prepd_reject;
> +			if (reason == -EINVAL) {
> +				sc->result = DID_ABORT << 16;
> +				goto prepd_fault;
> +			} else {
> +				reason = FAILURE_SESSION_NOT_READY;
> +				goto prepd_reject;
> +			}
>  		}
>  	} else {
>  		list_add_tail(&task->running, &conn->cmdqueue);
> 

Looks ok to me.

Acked-by: Mike Christie <michaelc@cs.wisc.edu>
