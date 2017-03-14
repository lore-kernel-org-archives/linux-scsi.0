From: Benjamin Block <bblock@linux.vnet.ibm.com>
Subject: Re: [PATCHv3 4/6] scsi_error: do not escalate failed EH command
Date: Tue, 14 Mar 2017 18:56:11 +0100
Message-ID: <20170314175611.GC19037@bblock-ThinkPad-W530>
References: <1488359720-130871-1-git-send-email-hare@suse.de>
 <1488359720-130871-5-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:56180 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750996AbdCNR4T (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 14 Mar 2017 13:56:19 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v2EHrVOr091648
        for <linux-scsi@vger.kernel.org>; Tue, 14 Mar 2017 13:56:17 -0400
Received: from e06smtp10.uk.ibm.com (e06smtp10.uk.ibm.com [195.75.94.106])
        by mx0b-001b2d01.pphosted.com with ESMTP id 296f3w53s9-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Tue, 14 Mar 2017 13:56:17 -0400
Received: from localhost
        by e06smtp10.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <bblock@linux.vnet.ibm.com>;
        Tue, 14 Mar 2017 17:56:15 -0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id v2EHuCfo30343420
        for <linux-scsi@vger.kernel.org>; Tue, 14 Mar 2017 17:56:12 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 24059A4051
        for <linux-scsi@vger.kernel.org>; Tue, 14 Mar 2017 17:56:01 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0A53EA4040
        for <linux-scsi@vger.kernel.org>; Tue, 14 Mar 2017 17:56:01 +0000 (GMT)
Received: from bblock-ThinkPad-W530 (unknown [9.152.212.152])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP
        for <linux-scsi@vger.kernel.org>; Tue, 14 Mar 2017 17:56:00 +0000 (GMT)
Content-Disposition: inline
In-Reply-To: <1488359720-130871-5-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Bart van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org

Hello Hannes,

On Wed, Mar 01, 2017 at 10:15:18AM +0100, Hannes Reinecke wrote:
> When a command is sent as part of the error handling there
> is not point whatsoever to start EH escalation when that
> command fails; we are _already_ in the error handler,
> and the escalation is about to commence anyway.
> So just call 'scsi_try_to_abort_cmd()' to abort outstanding
> commands and let the main EH routine handle the rest.
>
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
> Reviewed-by: Bart Van Assche <bart.vanassche@sandisk.com>
> ---
>  drivers/scsi/scsi_error.c | 11 +----------
>  1 file changed, 1 insertion(+), 10 deletions(-)
>
> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> index e1ca3b8..4613aa1 100644
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -889,15 +889,6 @@ static int scsi_try_to_abort_cmd(struct scsi_host_template *hostt,
>  	return hostt->eh_abort_handler(scmd);
>  }
>
> -static void scsi_abort_eh_cmnd(struct scsi_cmnd *scmd)
> -{
> -	if (scsi_try_to_abort_cmd(scmd->device->host->hostt, scmd) != SUCCESS)
> -		if (scsi_try_bus_device_reset(scmd) != SUCCESS)
> -			if (scsi_try_target_reset(scmd) != SUCCESS)
> -				if (scsi_try_bus_reset(scmd) != SUCCESS)
> -					scsi_try_host_reset(scmd);
> -}
> -
>  /**
>   * scsi_eh_prep_cmnd  - Save a scsi command info as part of error recovery
>   * @scmd:       SCSI command structure to hijack
> @@ -1082,7 +1073,7 @@ static int scsi_send_eh_cmnd(struct scsi_cmnd *scmd, unsigned char *cmnd,
>  			break;
>  		}
>  	} else if (rtn != FAILED) {
> -		scsi_abort_eh_cmnd(scmd);
> +		scsi_try_to_abort_cmd(shost->hostt, scmd);
>  		rtn = FAILED;
>  	}

The idea is sound, but this implementation would cause "use-after-free"s.

I only know our own LLD well enough to judge, but with zFCP there will
always be a chance that an abort fails - be it memory pressure,
hardware/firmware behavior or internal EH in zFCP.

Calling queuecommand() will mean for us in the LLD, that we allocate a
unique internal request struct for the scsi_cmnd (struct
zfcp_fsf_request) and add that to our internal hash-table with
outstanding commands. We assume this scsi_cmnd-pointer is ours till we
complete it via scsi_done are yield it via successful EH-actions.

In case the abort fails, you fail to take back the ownership over the
scsi command. Which in turn means possible "use-after-free"s when we
still thinks the scsi command is ours, but EH has already overwritten
the scsi-command with the original one. When we still get an answer or
otherwise use the scsi_cmnd-pointer we would access an invalid one.

I guess this might as well be true for other LLDs.


                                                    Beste Grüße / Best regards,
                                                      - Benjamin Block

>
> --
> 1.8.5.6
>

--
Linux on z Systems Development         /         IBM Systems & Technology Group
		  IBM Deutschland Research & Development GmbH
Vorsitz. AufsR.: Martina Koederitz     /        Geschäftsführung: Dirk Wittkopp
Sitz der Gesellschaft: Böblingen / Registergericht: AmtsG Stuttgart, HRB 243294
