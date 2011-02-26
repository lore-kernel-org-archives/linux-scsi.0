From: James Smart <james.smart@emulex.com>
Subject: Re: [PATCH 2/2] lpfc: block target when port queueing limit is hit
Date: Fri, 25 Feb 2011 19:07:54 -0500
Message-ID: <4D68445A.1080707@emulex.com>
References: <1298664268-12967-1-git-send-email-michaelc@cs.wisc.edu> <1298664268-12967-3-git-send-email-michaelc@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:21104 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756236Ab1BZAIL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Feb 2011 19:08:11 -0500
In-Reply-To: <1298664268-12967-3-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "michaelc@cs.wisc.edu" <michaelc@cs.wisc.edu>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Acked-by: James Smart  <james.smart@emulex.com>

-- james s



On 2/25/2011 3:04 PM, michaelc@cs.wisc.edu wrote:
> From: Mike Christie<michaelc@cs.wisc.edu>
>
> Instead of blocking the entire host when the port's
> queueing limit is hit, we should only block the port's
> target. This will allow IO to other ports to execute.
>
> Signed-off-by: Mike Christie<michaelc@cs.wisc.edu>
> ---
>   drivers/scsi/lpfc/lpfc_scsi.c |    5 ++++-
>   1 files changed, 4 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
> index af5aaaa..63a81a4 100644
> --- a/drivers/scsi/lpfc/lpfc_scsi.c
> +++ b/drivers/scsi/lpfc/lpfc_scsi.c
> @@ -3008,7 +3008,7 @@ lpfc_queuecommand_lck(struct scsi_cmnd *cmnd, void (*done) (struct scsi_cmnd *))
>   		goto out_fail_command;
>   	}
>   	if (atomic_read(&ndlp->cmd_pending)>= ndlp->cmd_qdepth)
> -		goto out_host_busy;
> +		goto out_tgt_busy;
>
>   	lpfc_cmd = lpfc_get_scsi_buf(phba, ndlp);
>   	if (lpfc_cmd == NULL) {
> @@ -3125,6 +3125,9 @@ lpfc_queuecommand_lck(struct scsi_cmnd *cmnd, void (*done) (struct scsi_cmnd *))
>    out_host_busy:
>   	return SCSI_MLQUEUE_HOST_BUSY;
>
> + out_tgt_busy:
> +	return SCSI_MLQUEUE_TARGET_BUSY;
> +
>    out_fail_command:
>   	done(cmnd);
>   	return 0;
