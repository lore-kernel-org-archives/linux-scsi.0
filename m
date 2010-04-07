From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 09/12] qla4xxx: added srb reference counter
Date: Tue, 06 Apr 2010 23:47:28 -0500
Message-ID: <4BBC0E60.3020209@cs.wisc.edu>
References: <20100406101432.GP22922@linux-qf4p>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:53007 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751432Ab0DGEnP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 7 Apr 2010 00:43:15 -0400
In-Reply-To: <20100406101432.GP22922@linux-qf4p>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ravi Anand <ravi.anand@qlogic.com>
Cc: James Bottomley <james.bottomley@suse.de>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>, Vikas Chaudhary <vikas.chaudhary@qlogic.com>, Karen Higgins <karen.higgins@qlogic.com>

On 04/06/2010 05:14 AM, Ravi Anand wrote:
> @@ -888,7 +890,7 @@ static void qla4xxx_flush_active_srbs(struct scsi_qla_host *ha)
>   		srb = qla4xxx_del_from_active_array(ha, i);
>   		if (srb != NULL) {
>   			srb->cmd->result = DID_RESET<<  16;
> -			qla4xxx_srb_compl(ha, srb);
> +			kref_put(&srb->srb_ref, qla4xxx_srb_compl);
>   		}


>    *
>    * This routine waits for the command to be returned by the Firmware
> @@ -1507,17 +1509,14 @@ static int qla4xxx_eh_wait_on_command(struct scsi_qla_host *ha,
>   				      struct scsi_cmnd *cmd)
>   {
>   	int done = 0;
> -	struct srb *rp;
>   	uint32_t max_wait_time = EH_WAIT_CMD_TOV;
>
>   	do {
>   		/* Checking to see if its returned to OS */
> -		rp = (struct srb *) cmd->SCp.ptr;
> -		if (rp == NULL) {
> +		if (cmd->host_scribble == NULL) {
>   			done++;
>   			break;
>   		}

Is this racey? It seems like qla4xxx_flush_active_srbs will call 
qla4xxx_del_from_active_array and that will clear host_scribble, and 
here we will see it is NULL and proceed to complete the eh abort 
process. When we get back to qla4xxx_eh_abort we could call 
kref_put(&srb->srb_ref, qla4xxx_srb_compl) and then return SUCCESS to 
the scsi eh. The scsi eh will then begin to reuse the scsi cmd to send a 
TUR. But I think the problem could be that if happens before 
qla4xxx_flush_active_srbs has called its kref_put, then when 
qla4xxx_flush_active_srbs now calls it it is going to call 
qla4xxx_srb_compl and the driver will be completing a completely 
different command (it would now be the TUR).

I thought I had said this before, but it looks like I did not get a 
reply. I think you want to drop the kref coming into 
qla4xxx_eh_wait_on_command because nothing is touching the srb now. And 
then you want to add some locking in around the host_scribble checking 
maybe.
