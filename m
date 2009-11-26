From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 1/1] be2iscsi: Adding support for various Async messages
 from chip
Date: Wed, 25 Nov 2009 19:00:49 -0600
Message-ID: <4B0DD341.1020600@cs.wisc.edu>
References: <20091124201120.GA24578@serverengines.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:37255 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759283AbZKZBAu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 Nov 2009 20:00:50 -0500
In-Reply-To: <20091124201120.GA24578@serverengines.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jayamohan Kalickal <jayamohank@serverengines.com>
Cc: linux-scsi@vger.kernel.org

Jayamohan Kallickal wrote:
>    This patch allows for future addition of various async messages
> from the chip. This ensures that the driver won't hit a BUG_ON if
> the Firmware used is newer than inbox driver and so is using
> latest async messages.
> 
> The patch was built on the latest tree at
> git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6.git
> 
> Signed-off-by: Jayamohan Kallickal <jayamohank@serverengines.com>
> ---
>  drivers/scsi/be2iscsi/be_cmds.c |   14 +++++++++-----
>  1 files changed, 9 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/scsi/be2iscsi/be_cmds.c b/drivers/scsi/be2iscsi/be_cmds.c
> index 698a527..bbd3632 100644
> --- a/drivers/scsi/be2iscsi/be_cmds.c
> +++ b/drivers/scsi/be2iscsi/be_cmds.c
> @@ -135,11 +135,15 @@ int beiscsi_process_mcc(struct beiscsi_hba *phba)
>  	while ((compl = be_mcc_compl_get(phba))) {
>  		if (compl->flags & CQE_FLAGS_ASYNC_MASK) {
>  			/* Interpret flags as an async trailer */
> -			BUG_ON(!is_link_state_evt(compl->flags));
> -
> -			/* Interpret compl as a async link evt */
> -			beiscsi_async_link_state_process(phba,
> -				(struct be_async_event_link_state *) compl);
> +			if(is_link_state_evt(compl->flags))
> +				/* Interpret compl as a async link evt */
> +				beiscsi_async_link_state_process(phba,
> +				   (struct be_async_event_link_state *) compl);
> +			else
> +				SE_DEBUG(DBG_LVL_1,
> +					 " Unsupported Async Event, flags"
> +					 " = 0x%08x \n", compl->flags);
> +				
>  		} else if (compl->flags & CQE_FLAGS_COMPLETED_MASK) {
>  				status = be_mcc_compl_process(ctrl, compl);
>  				atomic_dec(&phba->ctrl.mcc_obj.q.used);

Patch looks fine. It just adds some whitespace on a line. When you send 
your patches you might want to run it through git-am --whitespace=fix 
before sending to make sure they are all fixed.

Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>
