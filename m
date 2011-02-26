From: James Smart <james.smart@emulex.com>
Subject: Re: [PATCH 1/2] lpfc: force retry in queuecommand when port is transitioning
Date: Fri, 25 Feb 2011 19:07:49 -0500
Message-ID: <4D684455.4060104@emulex.com>
References: <1298664268-12967-1-git-send-email-michaelc@cs.wisc.edu> <1298664268-12967-2-git-send-email-michaelc@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:21104 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755065Ab1BZAIL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Feb 2011 19:08:11 -0500
In-Reply-To: <1298664268-12967-2-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "michaelc@cs.wisc.edu" <michaelc@cs.wisc.edu>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Acked-by: James Smart  <james.smart@emulex.com>

-- james s


On 2/25/2011 3:04 PM, michaelc@cs.wisc.edu wrote:
> From: Mike Christie<michaelc@cs.wisc.edu>
>
> If the port takes a while to transition we could exhaust
> the retries when using DID_TRANSPORT_DISRUPTED. For this
> case we do not want to use any of the cmd's
> retries, because if the command was running then when
> it got failed the retry counter was already incremented.
> And if this is the first time we are seeing the command,
> (it got queued because it slipped through during the race)
> then it should not have its retries incremented. The
> fc class will decide the correct handling later.
>
> Signed-off-by: Mike Christie<michaelc@cs.wisc.edu>
> ---
>   drivers/scsi/lpfc/lpfc_scsi.c |    2 +-
>   1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
> index c97751c..af5aaaa 100644
> --- a/drivers/scsi/lpfc/lpfc_scsi.c
> +++ b/drivers/scsi/lpfc/lpfc_scsi.c
> @@ -3004,7 +3004,7 @@ lpfc_queuecommand_lck(struct scsi_cmnd *cmnd, void (*done) (struct scsi_cmnd *))
>   	 * transport is still transitioning.
>   	 */
>   	if (!ndlp || !NLP_CHK_NODE_ACT(ndlp)) {
> -		cmnd->result = ScsiResult(DID_TRANSPORT_DISRUPTED, 0);
> +		cmnd->result = ScsiResult(DID_IMM_RETRY, 0);
>   		goto out_fail_command;
>   	}
>   	if (atomic_read(&ndlp->cmd_pending)>= ndlp->cmd_qdepth)
