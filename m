From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 1/3] lpfc 8.2.8 v2 : Revert target busy in favor of	transport
 disrupted
Date: Mon, 08 Sep 2008 14:09:23 -0500
Message-ID: <48C57863.9050705@cs.wisc.edu>
References: <1220802716.6747.11.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:53422 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753815AbYIHTJh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 8 Sep 2008 15:09:37 -0400
In-Reply-To: <1220802716.6747.11.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: linux-scsi@vger.kernel.org

James Smart wrote:
> Revert the target busy response in favor of the transport disrupted
> response for node state transitions.

Do we hit this code path if some other process has set the lpfc ndlp 
state and is calling fc_remote_port_delete? Or can we end up hitting 
this when the fc rport is FC_PORTSTATE_ONLINE (and not going to get 
deleted)? If the former, I had thought target busy was best because I 
thought it was just when we race with the fc_remote_port_delete and the 
ndlp change, and so I thought in this case we just wanted to fail with 
target busy to reflect that it was due to the race and not the transport 
problem that caused the rport deletion. That may not be logical or right 
though :) I do not care either way. I am mostly asking because if we go 
your route then I will send a patch to change the other fc drivers so 
they all do the same thing for this type of case.

> 
>  Signed-off-by: James Smart <james.smart@emulex.com>
> 
>  ---
> 
>  lpfc_scsi.c |    8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> 
> diff -upNr a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
> --- a/drivers/scsi/lpfc/lpfc_scsi.c	2008-09-06 11:54:50.000000000 -0400
> +++ b/drivers/scsi/lpfc/lpfc_scsi.c	2008-09-07 10:28:20.000000000 -0400
> @@ -1071,8 +1071,10 @@ lpfc_queuecommand(struct scsi_cmnd *cmnd
>  	 * Catch race where our node has transitioned, but the
>  	 * transport is still transitioning.
>  	 */
> -	if (!ndlp || !NLP_CHK_NODE_ACT(ndlp))
> -		goto out_target_busy;
> +	if (!ndlp || !NLP_CHK_NODE_ACT(ndlp)) {
> +		cmnd->result = ScsiResult(DID_TRANSPORT_DISRUPTED, 0);
> +		goto out_fail_command;
> +	}
>  
>  	lpfc_cmd = lpfc_get_scsi_buf(phba);
>  	if (lpfc_cmd == NULL) {
> @@ -1118,8 +1120,6 @@ lpfc_queuecommand(struct scsi_cmnd *cmnd
>  	lpfc_release_scsi_buf(phba, lpfc_cmd);
>   out_host_busy:
>  	return SCSI_MLQUEUE_HOST_BUSY;
> - out_target_busy:
> -	return SCSI_MLQUEUE_TARGET_BUSY;
>  
>   out_fail_command:
>  	done(cmnd);
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

