From: Kashyap Desai <kashyap.desai@avagotech.com>
Subject: RE: [PATCH 3/7] megaraid_sas : Do not process IOCTLs and SCSI
 commands during driver removal
Date: Wed, 12 Nov 2014 16:38:44 +0530
Message-ID: <4e1d4dfe448d9ed6c275bfea6b9203ac@mail.gmail.com>
References: <201411101224.sAACOmvj018047@palmhbs0.lsi.com> <5462124E.4070500@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og123.obsmtp.com ([64.18.2.24]:40525 "EHLO
	exprod7og123.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752410AbaKLLIu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Nov 2014 06:08:50 -0500
Received: by mail-lb0-f170.google.com with SMTP id w7so455238lbi.1
        for <linux-scsi@vger.kernel.org>; Wed, 12 Nov 2014 03:08:47 -0800 (PST)
In-Reply-To: <5462124E.4070500@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tomas Henzl <thenzl@redhat.com>, Sumit Saxena <sumit.saxena@avagotech.com>, linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, hch@infradead.org, jbottomley@parallels.com, aradford@gmail.com

> -----Original Message-----
> From: Tomas Henzl [mailto:thenzl@redhat.com]
> Sent: Tuesday, November 11, 2014 7:13 PM
> To: Sumit.Saxena@avagotech.com; linux-scsi@vger.kernel.org
> Cc: martin.petersen@oracle.com; hch@infradead.org;
> jbottomley@parallels.com; kashyap.desai@avagotech.com;
> aradford@gmail.com
> Subject: Re: [PATCH 3/7] megaraid_sas : Do not process IOCTLs and SCSI
> commands during driver removal
>
> On 11/10/2014 01:21 PM, Sumit.Saxena@avagotech.com wrote:
> > Do not process any SCSI and IOCTL command further(return them with
> > appropriate return values to callers), while driver removal is in
progress/PCI
> shutdown is invoked.
> >
> > Signed-off-by: Sumit Saxena <sumit.saxena@avagotech.com>
> > Signed-off-by: Kashyap Desai <kashyap.desai@avagotech.com>
> > ---
> >  drivers/scsi/megaraid/megaraid_sas_base.c |   20 ++++++++++++++++----
> >  1 files changed, 16 insertions(+), 4 deletions(-)
> >
> > diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c
> > b/drivers/scsi/megaraid/megaraid_sas_base.c
> > index f6a69a3..7754eeb 100644
> > --- a/drivers/scsi/megaraid/megaraid_sas_base.c
> > +++ b/drivers/scsi/megaraid/megaraid_sas_base.c
> > @@ -1572,6 +1572,12 @@ megasas_queue_command(struct Scsi_Host
> *shost, struct scsi_cmnd *scmd)
> >  	instance = (struct megasas_instance *)
> >  	    scmd->device->host->hostdata;
> >
> > +	if (instance->unload == 1) {
> > +		scmd->result = DID_NO_CONNECT << 16;
> > +		scmd->scsi_done(scmd);
> > +		return 0;
> > +	}
> > +
> >  	if (instance->issuepend_done == 0)
> >  		return SCSI_MLQUEUE_HOST_BUSY;
> >
> > @@ -4957,10 +4963,6 @@ static int megasas_io_attach(struct
> megasas_instance *instance)
> >  		return -ENODEV;
> >  	}
> >
> > -	/*
> > -	 * Trigger SCSI to scan our drives
> > -	 */
> > -	scsi_scan_host(host);
> >  	return 0;
> >  }
> >
> > @@ -5288,6 +5290,10 @@ retry_irq_register:
> >  		goto fail_io_attach;
> >
> >  	instance->unload = 0;
> > +	/*
> > +	 * Trigger SCSI to scan our drives
> > +	 */
> > +	scsi_scan_host(host);
> >
> >  	/*
> >  	 * Initiate AEN (Asynchronous Event Notification) @@ -6051,6
> > +6057,12 @@ megasas_mgmt_fw_ioctl(struct megasas_instance
> *instance,
> >  	megasas_issue_blocked_cmd(instance, cmd, 0);
> >  	cmd->sync_cmd = 0;
>
> I've expected that you'll not send the command to the card, you first
issue
> blocked command and after that test unload state.
> Shouldn't it be reversed?
Actually, there was a two part of this Patch for IOCTL path. One will not
allow to send IOCTL while driver removal.
Another will not use already return IOCTL from FW to avoid illegal memory
access on MFI frame.
Driver wakeup all blocked command in unload path and MFI/MPT frames are
freed as well, so this check is good to have.

As you suggested, we missed to have another check in IOCTL path, before
driver takes semaphore. It was planned, but somehow we missed while
submitting this patch set.
We will send incremental patch for that part.

>
> >
> > +	if (instance->unload == 1) {
> > +		dev_info(&instance->pdev->dev, "we are doing unload so no
> need"
> > +			"to submit data to application. This may be force
exit"
> > +			"from driver\n");
>
> I'm not a native speaker, so I'll not comment on the wording, but you
should
> add a space at the line breaks.

Agree. will address this part.

> +		dev_info(&instance->pdev->dev, "we are doing unload so no
> need "
> +			"to submit data to application. This may be force
exit
> "
> +			"from driver\n");
>
> > +		goto out;
> > +	}
> >  	/*
> >  	 * copy out the kernel buffers to user buffers
> >  	 */
>
> Aren't there other ioctl paths too - for example megasas_mgmt_ioctl_aen
-
> isn't a block needed there too?
This path will be cleanup from megasas_shutdown_controller() call.   AEN
and MAP SYNC command will be aborted explicitly.

>
