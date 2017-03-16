From: Benjamin Block <bblock@linux.vnet.ibm.com>
Subject: Re: [PATCHv3 4/6] scsi_error: do not escalate failed EH command
Date: Thu, 16 Mar 2017 12:01:42 +0100
Message-ID: <20170316110142.GB11833@bblock-ThinkPad-W530>
References: <1488359720-130871-1-git-send-email-hare@suse.de>
 <1488359720-130871-5-git-send-email-hare@suse.de>
 <20170314175611.GC19037@bblock-ThinkPad-W530>
 <aa4c4285-782f-bd41-2fe8-98f54c2c2d9d@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:46047 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751475AbdCPLS3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 16 Mar 2017 07:18:29 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v2GBDTwf049214
        for <linux-scsi@vger.kernel.org>; Thu, 16 Mar 2017 07:18:18 -0400
Received: from e06smtp11.uk.ibm.com (e06smtp11.uk.ibm.com [195.75.94.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 297mmx7b2n-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Thu, 16 Mar 2017 07:18:18 -0400
Received: from localhost
        by e06smtp11.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <bblock@linux.vnet.ibm.com>;
        Thu, 16 Mar 2017 11:18:14 -0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id v2GBI7PW33357846
        for <linux-scsi@vger.kernel.org>; Thu, 16 Mar 2017 11:18:09 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2E97642785
        for <linux-scsi@vger.kernel.org>; Thu, 16 Mar 2017 11:01:24 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1EA1842789
        for <linux-scsi@vger.kernel.org>; Thu, 16 Mar 2017 11:01:24 +0000 (GMT)
Received: from bblock-ThinkPad-W530 (unknown [9.152.212.102])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP
        for <linux-scsi@vger.kernel.org>; Thu, 16 Mar 2017 11:01:24 +0000 (GMT)
Content-Disposition: inline
In-Reply-To: <aa4c4285-782f-bd41-2fe8-98f54c2c2d9d@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <jejb@linux.vnet.ibm.com>
Cc: Christoph Hellwig <hch@lst.de>, Bart van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org

On Wed, Mar 15, 2017 at 02:54:16PM +0100, Hannes Reinecke wrote:
> On 03/14/2017 06:56 PM, Benjamin Block wrote:
> > Hello Hannes,
> >
> > On Wed, Mar 01, 2017 at 10:15:18AM +0100, Hannes Reinecke wrote:
> >> When a command is sent as part of the error handling there
> >> is not point whatsoever to start EH escalation when that
> >> command fails; we are _already_ in the error handler,
> >> and the escalation is about to commence anyway.
> >> So just call 'scsi_try_to_abort_cmd()' to abort outstanding
> >> commands and let the main EH routine handle the rest.
> >>
> >> Signed-off-by: Hannes Reinecke <hare@suse.de>
> >> Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
> >> Reviewed-by: Bart Van Assche <bart.vanassche@sandisk.com>
> >> ---
> >>  drivers/scsi/scsi_error.c | 11 +----------
> >>  1 file changed, 1 insertion(+), 10 deletions(-)
> >>
> >> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> >> index e1ca3b8..4613aa1 100644
> >> --- a/drivers/scsi/scsi_error.c
> >> +++ b/drivers/scsi/scsi_error.c
> >> @@ -889,15 +889,6 @@ static int scsi_try_to_abort_cmd(struct scsi_host_template *hostt,
> >>  	return hostt->eh_abort_handler(scmd);
> >>  }
> >>
> >> -static void scsi_abort_eh_cmnd(struct scsi_cmnd *scmd)
> >> -{
> >> -	if (scsi_try_to_abort_cmd(scmd->device->host->hostt, scmd) != SUCCESS)
> >> -		if (scsi_try_bus_device_reset(scmd) != SUCCESS)
> >> -			if (scsi_try_target_reset(scmd) != SUCCESS)
> >> -				if (scsi_try_bus_reset(scmd) != SUCCESS)
> >> -					scsi_try_host_reset(scmd);
> >> -}
> >> -
> >>  /**
> >>   * scsi_eh_prep_cmnd  - Save a scsi command info as part of error recovery
> >>   * @scmd:       SCSI command structure to hijack
> >> @@ -1082,7 +1073,7 @@ static int scsi_send_eh_cmnd(struct scsi_cmnd *scmd, unsigned char *cmnd,
> >>  			break;
> >>  		}
> >>  	} else if (rtn != FAILED) {
> >> -		scsi_abort_eh_cmnd(scmd);
> >> +		scsi_try_to_abort_cmd(shost->hostt, scmd);
> >>  		rtn = FAILED;
> >>  	}
> >
> > The idea is sound, but this implementation would cause "use-after-free"s.
> >
> > I only know our own LLD well enough to judge, but with zFCP there will
> > always be a chance that an abort fails - be it memory pressure,
> > hardware/firmware behavior or internal EH in zFCP.
> >
> > Calling queuecommand() will mean for us in the LLD, that we allocate a
> > unique internal request struct for the scsi_cmnd (struct
> > zfcp_fsf_request) and add that to our internal hash-table with
> > outstanding commands. We assume this scsi_cmnd-pointer is ours till we
> > complete it via scsi_done are yield it via successful EH-actions.
> >
> > In case the abort fails, you fail to take back the ownership over the
> > scsi command. Which in turn means possible "use-after-free"s when we
> > still thinks the scsi command is ours, but EH has already overwritten
> > the scsi-command with the original one. When we still get an answer or
> > otherwise use the scsi_cmnd-pointer we would access an invalid one.
> >
> That is actually not try.
> As soon as we're calling 'scsi_try_to_abort_command()' ownership is
> assumed to reside in the SCSI midlayer;

That can not be true. First of all, look at the function itself (v4.10):

	static int scsi_try_to_abort_cmd...
	{
		if (!hostt->eh_abort_handler)
			return FAILED;

		return hostt->eh_abort_handler(scmd);
	}

If what you say is true, then this whole API of LLDs providing or
choosing not to provide implementations for these function would be
fundamentally broken.
The function itself returns FAILED when there is no such function.. how
is a LLD that does not implement it ever to know that you took ownership
by calling scsi_try_to_abort_cmd()?

Then look at the function-comment:

	/**
	 * scsi_try_to_abort_cmd - ...
	 * ...
	 * Notes:
	 *    SUCCESS does not necessarily indicate that the command
	 *    has been aborted; it only indicates that the LLDDs
	 *    has cleared all references to that command.
	 *    LLDDs should return FAILED only if an abort was required
	 *    but could not be executed. LLDDs should return FAST_IO_FAIL
	 *    if the device is temporarily unavailable (eg due to a
	 *    link down on FibreChannel)
	 */

While not written directly, it says that SUCCESS means the references are
cleared, ownership transferred.

Then look at the scsi_eh.txt:

	3. If !list_empty(&eh_work_q), invoke scsi_eh_abort_cmds().

	<<scsi_eh_abort_cmds>>

	    This action is taken for each timed out command when
	    no_async_abort is enabled in the host template.
	    hostt->eh_abort_handler() is invoked for each scmd.  The
	    handler returns SUCCESS if it has succeeded to make LLDD and
	    all related hardware forget about the scmd.

	    If a timedout scmd is successfully aborted and the sdev is
	    either offline or ready, scsi_eh_finish_cmd() is invoked for
	    the scmd.  Otherwise, the scmd is left in eh_work_q for
	    higher-severity actions.

Same as the function-comment, SUCCESS signals ownership transfer.

> also, the command used for
> recovery here is actually using the same structure than the failed
> command, so if the command abort failed the command is already in the
> list of failed commands, and will be recovered after SCSI EH returned.
>

That doesn't change the fact that LLDs may or may not allocate separate
internal buffers for it. We have to, to send the new FCP command, you
asking us to send. So should for some reason a reply arrive for the
eh-scsi-command that you are asking us to work on and fail to abort, we
will remember the SCSI-command pointer and use it. 
And 'reply arrive' is in case of zFCP not even hard, because the same
code-path is used when we at some point trigger an internal
adapter-recovery (independent of SCSI EH). That would cancel all
outstanding commands and would, as we think we still own the SCSI
command, set a appropriate state and finish the command with
scsi_done().


                                                    Beste Grüße / Best regards,
                                                      - Benjamin Block

>
> So no use-after-free here.
>

--
Linux on z Systems Development         /         IBM Systems & Technology Group
		  IBM Deutschland Research & Development GmbH
Vorsitz. AufsR.: Martina Koederitz     /        Geschäftsführung: Dirk Wittkopp
Sitz der Gesellschaft: Böblingen / Registergericht: AmtsG Stuttgart, HRB 243294
