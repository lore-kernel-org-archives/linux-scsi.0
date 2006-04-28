From: Brian King <brking@us.ibm.com>
Subject: Re: [PATCH 1/2] scsi: Add scsi_device max_cmd_len (resend)
Date: Fri, 28 Apr 2006 09:28:02 -0500
Message-ID: <44522672.5010607@us.ibm.com>
References: <200604172240.k3HMes2V010154@d01av01.pok.ibm.com>
Reply-To: brking@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:6275 "EHLO e1.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S965206AbWD1O2H (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 Apr 2006 10:28:07 -0400
In-Reply-To: <200604172240.k3HMes2V010154@d01av01.pok.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@us.ibm.com>
Cc: James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org, jgarzik@pobox.com, linux-ide@vger.kernel.org

James,

Any comments on the patch below?

Thanks

Brian

Brian King wrote:
> Add a max_cmd_len field to the scsi_device struct
> to allow for per device limits of allowable command
> lengths. This patch was submitted earlier and resulted
> in a bit of discussion regarding whether or not
> CDB length is a limitation of the host or the device.
> For ATA, both the host and the device can limit the
> CDB length. Currently libata reads the IDENTIFY
> PACKET DEVICE data for an ATAPI device and sets
> the max_cmd_len in the scsi host for the maximum
> supported CDB length of all ATA/ATAPI devices attached
> to the same scsi host. This patch allows libata to
> set the max CDB length on a per device basis and
> allows the SAS/SATA HBA to set its own max command
> length in the scsi host template.
> 
> Signed-off-by: Brian King <brking@us.ibm.com>
> ---
> 
>  libata-dev-bjking1/drivers/scsi/scsi.c        |    3 ++-
>  libata-dev-bjking1/drivers/scsi/scsi_scan.c   |    1 +
>  libata-dev-bjking1/include/scsi/scsi_device.h |    1 +
>  3 files changed, 4 insertions(+), 1 deletion(-)
> 
> diff -puN include/scsi/scsi_device.h~scsi_device_cdb_len include/scsi/scsi_device.h
> --- libata-dev/include/scsi/scsi_device.h~scsi_device_cdb_len	2006-04-17 17:17:50.000000000 -0500
> +++ libata-dev-bjking1/include/scsi/scsi_device.h	2006-04-17 17:17:50.000000000 -0500
> @@ -72,6 +72,7 @@ struct scsi_device {
>  	unsigned int manufacturer;	/* Manufacturer of device, for using 
>  					 * vendor-specific cmd's */
>  	unsigned sector_size;	/* size in bytes */
> +	unsigned char max_cmd_len;
>  
>  	void *hostdata;		/* available to low-level driver */
>  	char type;
> diff -puN drivers/scsi/scsi_scan.c~scsi_device_cdb_len drivers/scsi/scsi_scan.c
> --- libata-dev/drivers/scsi/scsi_scan.c~scsi_device_cdb_len	2006-04-17 17:17:50.000000000 -0500
> +++ libata-dev-bjking1/drivers/scsi/scsi_scan.c	2006-04-17 17:17:50.000000000 -0500
> @@ -218,6 +218,7 @@ static struct scsi_device *scsi_alloc_sd
>  	sdev->lun = lun;
>  	sdev->channel = starget->channel;
>  	sdev->sdev_state = SDEV_CREATED;
> +	sdev->max_cmd_len = MAX_COMMAND_SIZE;
>  	INIT_LIST_HEAD(&sdev->siblings);
>  	INIT_LIST_HEAD(&sdev->same_target_siblings);
>  	INIT_LIST_HEAD(&sdev->cmd_list);
> diff -puN drivers/scsi/scsi.c~scsi_device_cdb_len drivers/scsi/scsi.c
> --- libata-dev/drivers/scsi/scsi.c~scsi_device_cdb_len	2006-04-17 17:17:50.000000000 -0500
> +++ libata-dev-bjking1/drivers/scsi/scsi.c	2006-04-17 17:17:50.000000000 -0500
> @@ -610,7 +610,8 @@ int scsi_dispatch_cmd(struct scsi_cmnd *
>  	 * Before we queue this command, check if the command
>  	 * length exceeds what the host adapter can handle.
>  	 */
> -	if (CDB_SIZE(cmd) > cmd->device->host->max_cmd_len) {
> +	if (CDB_SIZE(cmd) > cmd->device->host->max_cmd_len ||
> +	    CDB_SIZE(cmd) > cmd->device->max_cmd_len) {
>  		SCSI_LOG_MLQUEUE(3,
>  				printk("queuecommand : command too long.\n"));
>  		cmd->result = (DID_ABORT << 16);
> _


-- 
Brian King
eServer Storage I/O
IBM Linux Technology Center
