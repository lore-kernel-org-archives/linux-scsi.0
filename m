From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH] [PATCH] libata: take scmd->cmd_len into account when
 translating SCSI commands
Date: Sat, 16 Dec 2006 10:40:28 -0500
Message-ID: <4584136C.5070009@pobox.com>
References: <20061216104331.GA5400@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:34621 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161121AbWLPQIP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 16 Dec 2006 11:08:15 -0500
In-Reply-To: <20061216104331.GA5400@htj.dyndns.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, dougg@torque.net, jens.axboe@oracle.com

Tejun Heo wrote:
> libata depended on SCSI command to have the correct length when
> tranlating it into an ATA command.  This generally worked for commands
> issued by SCSI HLD but user could issue arbitrary broken command using
> sg interface.
> 
> Also, when building ATAPI command, full command size was always
> copied.  Because some ATAPI devices needs bytes after CDB cleared, if
> upper layer doesn't clear bytes after CDB, such devices will
> malfunction.  This necessiated recent clear-garbage-after-CDB fix in
> sg interfaces.  However, scsi_execute() isn't fixed yet and HL-DT-ST
> DVD-RAM GSA-H30N malfunctions on initialization commands issued from
> SCSI.
> 
> This patch updates libata xlat functions.
> 
> * SCSI cmd_len is always considered.  Each translation function checks
>   for proper cmd_len and ATAPI translaation clears bytes after CDB.
> 
> * Don't pass CDB as argument to xlat functions.  xlat functions need
>   to access more than just CDB and they have already been accessing scmd
>   via qc->scsicmd.  Just pass in qc.
> 
> * Variable names are normalized.  scsi_cmnd is scmd and CDB, cdb.
> 
> Signed-off-by: Tejun Heo <htejun@gmail.com>
> Cc: Jens Axboe <jens.axboe@oracle.com>
> Cc: Douglas Gilbert <dougg@torque.net>
> ---
>  drivers/ata/libata-scsi.c |  187 ++++++++++++++++++++++++---------------------
>  1 files changed, 100 insertions(+), 87 deletions(-)
> 
> diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
> index a4790be..f82871c 100644
> --- a/drivers/ata/libata-scsi.c
> +++ b/drivers/ata/libata-scsi.c
> @@ -51,7 +51,7 @@
>  
>  #define SECTOR_SIZE	512
>  
> -typedef unsigned int (*ata_xlat_func_t)(struct ata_queued_cmd *qc, const u8 *scsicmd);
> +typedef unsigned int (*ata_xlat_func_t)(struct ata_queued_cmd *qc);
>  
>  static struct ata_device * __ata_scsi_find_dev(struct ata_port *ap,
>  					const struct scsi_device *scsidev);
> @@ -935,7 +935,6 @@ int ata_scsi_change_queue_depth(struct scsi_device *sdev, int queue_depth)
>  /**
>   *	ata_scsi_start_stop_xlat - Translate SCSI START STOP UNIT command
>   *	@qc: Storage for translated ATA taskfile
> - *	@scsicmd: SCSI command to translate
>   *
>   *	Sets up an ATA taskfile to issue STANDBY (to stop) or READ VERIFY
>   *	(to start). Perhaps these commands should be preceded by
> @@ -948,22 +947,25 @@ int ata_scsi_change_queue_depth(struct scsi_device *sdev, int queue_depth)
>   *	RETURNS:
>   *	Zero on success, non-zero on error.
>   */
> -
> -static unsigned int ata_scsi_start_stop_xlat(struct ata_queued_cmd *qc,
> -					     const u8 *scsicmd)
> +static unsigned int ata_scsi_start_stop_xlat(struct ata_queued_cmd *qc)
>  {
> +	struct scsi_cmnd *scmd = qc->scsicmd;
> +	const u8 *cdb = scmd->cmnd;
>  	struct ata_taskfile *tf = &qc->tf;
>  
> +	if (scmd->cmd_len < 5)
> +		goto invalid_fld;
> +
>  	tf->flags |= ATA_TFLAG_DEVICE | ATA_TFLAG_ISADDR;
>  	tf->protocol = ATA_PROT_NODATA;
> -	if (scsicmd[1] & 0x1) {
> +	if (cdb[1] & 0x1) {
>  		;	/* ignore IMMED bit, violates sat-r05 */
>  	}
> -	if (scsicmd[4] & 0x2)
> -		goto invalid_fld;       /* LOEJ bit set not supported */
> -	if (((scsicmd[4] >> 4) & 0xf) != 0)
> -		goto invalid_fld;       /* power conditions not supported */
> -	if (scsicmd[4] & 0x1) {
> +	if (cdb[4] & 0x2)
> +		goto invalid_fld;	/* LOEJ bit set not supported */
> +	if (((cdb[4] >> 4) & 0xf) != 0)
> +		goto invalid_fld;	/* power conditions not supported */
> +	if (cdb[4] & 0x1) {

ACK change for #upstream-fixes, but please revise so that the 
"s/scsicmd/cdb/" rename is moved to a separate patch.  You should be 
able to name the local variables such that this patch becomes much smaller.

	Jeff



