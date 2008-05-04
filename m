From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: On patch "Let scsi_cmnd->cmnd use request->cmd buffer"
Date: Sun, 04 May 2008 15:15:43 +0300
Message-ID: <481DA8EF.3010405@panasas.com>
References: <tkrat.5db1d90bfe8d480e@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:22998 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751806AbYEDMQa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 4 May 2008 08:16:30 -0400
In-Reply-To: <tkrat.5db1d90bfe8d480e@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux-scsi@vger.kernel.org

Stefan Richter wrote:
> Commit 64a87b244b9297667ca80264aab849a36f494884 contains:
> -------------------------- drivers/firewire/fw-sbp2.c --------------------------
> index 2a99937..dda82f3 100644
> @@ -1487,7 +1487,7 @@ static int sbp2_scsi_queuecommand(struct scsi_cmnd *cmd, scsi_done_fn_t done)
>  	if (scsi_sg_count(cmd) && sbp2_map_scatterlist(orb, device, lu) < 0)
>  		goto out;
>  
> -	memcpy(orb->request.command_block, cmd->cmnd, COMMAND_SIZE(*cmd->cmnd));
> +	memcpy(orb->request.command_block, cmd->cmnd, cmd->cmd_len);
>  
>  	orb->base.callback = complete_command_orb;
>  	orb->base.request_bus =
>
>
> Should drivers/ieee1394/sbp2.c::sbp2_create_command_orb() be changed in
> the same way?
>   
Sorry to have missed it. Yes it is best if it is changed. cmd->cmd_len 
is now guarantied to be set
properly at all cases. And some commands you want to support will not be 
set correctly by
COMMAND_SIZE(). do you want me to do it?

Boaz

