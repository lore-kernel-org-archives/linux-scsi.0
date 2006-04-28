From: Luben Tuikov <ltuikov@yahoo.com>
Subject: Re: [PATCH 1/2] scsi: Add scsi_device max_cmd_len (resend)
Date: Fri, 28 Apr 2006 10:28:42 -0700 (PDT)
Message-ID: <20060428172842.44191.qmail@web31809.mail.mud.yahoo.com>
References: <44522672.5010607@us.ibm.com>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web31809.mail.mud.yahoo.com ([68.142.207.72]:59570 "HELO
	web31809.mail.mud.yahoo.com") by vger.kernel.org with SMTP
	id S1030465AbWD1R2n (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 Apr 2006 13:28:43 -0400
In-Reply-To: <44522672.5010607@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: brking@us.ibm.com
Cc: James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org, jgarzik@pobox.com, linux-ide@vger.kernel.org

--- Brian King <brking@us.ibm.com> wrote:

> James,
> 
> Any comments on the patch below?

Hi Brian,  I know I'm not "James" and you didn't direct you email
to me, but I've a question for you:

Why do you want this to live in SCSI Core?  I mean, do you find
it objectionable for a proper SATL (no, not libata), to return
proper SK/ASC/ASCQ when a CDB not supported by the device is sent
to the device?

    Luben

> 
> Thanks
> 
> Brian
> 
> Brian King wrote:
> > Add a max_cmd_len field to the scsi_device struct
> > to allow for per device limits of allowable command
> > lengths. This patch was submitted earlier and resulted
> > in a bit of discussion regarding whether or not
> > CDB length is a limitation of the host or the device.
> > For ATA, both the host and the device can limit the
> > CDB length. Currently libata reads the IDENTIFY
> > PACKET DEVICE data for an ATAPI device and sets
> > the max_cmd_len in the scsi host for the maximum
> > supported CDB length of all ATA/ATAPI devices attached
> > to the same scsi host. This patch allows libata to
> > set the max CDB length on a per device basis and
> > allows the SAS/SATA HBA to set its own max command
> > length in the scsi host template.
> > 
> > Signed-off-by: Brian King <brking@us.ibm.com>
> > ---
> > 
> >  libata-dev-bjking1/drivers/scsi/scsi.c        |    3 ++-
> >  libata-dev-bjking1/drivers/scsi/scsi_scan.c   |    1 +
> >  libata-dev-bjking1/include/scsi/scsi_device.h |    1 +
> >  3 files changed, 4 insertions(+), 1 deletion(-)
> > 
> > diff -puN include/scsi/scsi_device.h~scsi_device_cdb_len include/scsi/scsi_device.h
> > --- libata-dev/include/scsi/scsi_device.h~scsi_device_cdb_len	2006-04-17 17:17:50.000000000
> -0500
> > +++ libata-dev-bjking1/include/scsi/scsi_device.h	2006-04-17 17:17:50.000000000 -0500
> > @@ -72,6 +72,7 @@ struct scsi_device {
> >  	unsigned int manufacturer;	/* Manufacturer of device, for using 
> >  					 * vendor-specific cmd's */
> >  	unsigned sector_size;	/* size in bytes */
> > +	unsigned char max_cmd_len;
> >  
> >  	void *hostdata;		/* available to low-level driver */
> >  	char type;
> > diff -puN drivers/scsi/scsi_scan.c~scsi_device_cdb_len drivers/scsi/scsi_scan.c
> > --- libata-dev/drivers/scsi/scsi_scan.c~scsi_device_cdb_len	2006-04-17 17:17:50.000000000
> -0500
> > +++ libata-dev-bjking1/drivers/scsi/scsi_scan.c	2006-04-17 17:17:50.000000000 -0500
> > @@ -218,6 +218,7 @@ static struct scsi_device *scsi_alloc_sd
> >  	sdev->lun = lun;
> >  	sdev->channel = starget->channel;
> >  	sdev->sdev_state = SDEV_CREATED;
> > +	sdev->max_cmd_len = MAX_COMMAND_SIZE;
> >  	INIT_LIST_HEAD(&sdev->siblings);
> >  	INIT_LIST_HEAD(&sdev->same_target_siblings);
> >  	INIT_LIST_HEAD(&sdev->cmd_list);
> > diff -puN drivers/scsi/scsi.c~scsi_device_cdb_len drivers/scsi/scsi.c
> > --- libata-dev/drivers/scsi/scsi.c~scsi_device_cdb_len	2006-04-17 17:17:50.000000000 -0500
> > +++ libata-dev-bjking1/drivers/scsi/scsi.c	2006-04-17 17:17:50.000000000 -0500
> > @@ -610,7 +610,8 @@ int scsi_dispatch_cmd(struct scsi_cmnd *
> >  	 * Before we queue this command, check if the command
> >  	 * length exceeds what the host adapter can handle.
> >  	 */
> > -	if (CDB_SIZE(cmd) > cmd->device->host->max_cmd_len) {
> > +	if (CDB_SIZE(cmd) > cmd->device->host->max_cmd_len ||
> > +	    CDB_SIZE(cmd) > cmd->device->max_cmd_len) {
> >  		SCSI_LOG_MLQUEUE(3,
> >  				printk("queuecommand : command too long.\n"));
> >  		cmd->result = (DID_ABORT << 16);
> > _
> 
> 
> -- 
> Brian King
> eServer Storage I/O
> IBM Linux Technology Center
> -
> To unsubscribe from this list: send the line "unsubscribe linux-ide" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

