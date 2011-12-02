From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 3/9] qla4xxx: fix call trace on rmmod with ql4xdontresethba=1
Date: Fri, 02 Dec 2011 15:56:46 -0600
Message-ID: <4ED9499E.5070707@cs.wisc.edu>
References: <1322808134-21665-1-git-send-email-vikas.chaudhary@qlogic.com> <1322808134-21665-4-git-send-email-vikas.chaudhary@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:36545 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755577Ab1LBV44 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 2 Dec 2011 16:56:56 -0500
In-Reply-To: <1322808134-21665-4-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: vikas.chaudhary@qlogic.com
Cc: jbottomley@parallels.com, linux-scsi@vger.kernel.org, lalit.chandivade@qlogic.com, ravi.anand@qlogic.com, poornima.vonti@qlogic.com, Sarang Radke <sarang.radke@qlogic.com>

On 12/02/2011 12:42 AM, vikas.chaudhary@qlogic.com wrote:
>  
>  /**
> + * qla4xxx_is_eh_active:

You need a description of the function above after the colon. And
actually qla4xxx is doing a dash in other places. So you should do:

/**
 * qla4xxx_is_eh_active - check if eh is rinning

And just to make sure, if the host state is in SHOST_CANCEL_RECOVERY the
drivers shutdown code will have cleaned up the command right? It looks
like it, but I was not 100% sure.



> + * @shost: Pointer to SCSI Host struct
> + *
> + * This routine finds that if reset host is called in EH
> + * scenario or from some application like sg_reset
> + **/
> +static int qla4xxx_is_eh_active(struct Scsi_Host *shost)
> +{
> +	if (shost->shost_state == SHOST_RECOVERY)
> +		return 1;
> +	return 0;
> +}
> +
> +/**
>   * qla4xxx_eh_host_reset - kernel callback
>   * @cmd: Pointer to Linux's SCSI command structure
>   *
> @@ -4832,6 +4846,11 @@ static int qla4xxx_eh_host_reset(struct scsi_cmnd *cmd)
>  	if (ql4xdontresethba) {
>  		DEBUG2(printk("scsi%ld: %s: Don't Reset HBA\n",
>  		     ha->host_no, __func__));
> +
> +		/* Clear outstanding srb in queues */
> +		if (qla4xxx_is_eh_active(cmd->device->host))
> +			qla4xxx_abort_active_cmds(ha, DID_ABORT << 16);
> +
>  		return FAILED;
>  	}
>  

