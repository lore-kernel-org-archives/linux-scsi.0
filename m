From: Douglas Gilbert <dougg@torque.net>
Subject: Re: Prototype SATA -> SCSI error mapper
Date: Tue, 17 Aug 2004 19:33:18 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <4121D0DE.5070307@torque.net>
References: <20040816141243.GA3898@devserv.devel.redhat.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailhub2.uq.edu.au ([130.102.149.128]:33035 "EHLO
	mailhub2.uq.edu.au") by vger.kernel.org with ESMTP id S264660AbUHQJe0
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Aug 2004 05:34:26 -0400
In-Reply-To: <20040816141243.GA3898@devserv.devel.redhat.com>
List-Id: linux-scsi@vger.kernel.org
To: Alan Cox <alan@redhat.com>
Cc: jgarzik@pobox.com, linux-scsi@vger.kernel.org

Alan,
With a MEDIUM or HARDWARE ERROR if you know the LBA of
the failure, then that value can be placed in the
(fixed format) sense buffer.

if (LBA_of_failure_known) {
     sb[0] |= 0x80;       /* set VALID bit */
     sb[3] = msb_of_LBA;  /* put LBA in INFORMATION field */
     sb[4] = umb_of_LBA;
     sb[5] = lmb_of_LBA;
     sb[6] = lsb_of_LBA;
}


The fixed format sense buffer cannot handle LBAs greater than
32 bits. This is one reason why "descriptor" format was
introduced. I'll send some patches soon to this list so
the mid-level can handle both descriptor formats.

Doug Gilbert


Alan Cox wrote:
> Would appreciate comment from any of the scsi gurus
> 
> 
> --- ../linux.vanilla-2.6.8-rc3/drivers/scsi/libata-scsi.c	2004-08-09 15:51:01.000000000 +0100
> +++ drivers/scsi/libata-scsi.c	2004-08-16 12:34:57.000000000 +0100
> @@ -120,34 +120,158 @@
>   *	ata_to_sense_error - convert ATA error to SCSI error
>   *	@qc: Command that we are erroring out
>   *
> - *	Converts an ATA error into a SCSI error.
> - *
> - *	Right now, this routine is laughably primitive.  We
> - *	don't even examine what ATA told us, we just look at
> - *	the command data direction, and return a fatal SCSI
> - *	sense error based on that.
> + *	Converts an ATA error into a SCSI error. While we are at it
> + *	we decode and dump the ATA error for the user so that they
> + *	have some idea what really happened at the non make-believe
> + *	layer.
>   *
>   *	LOCKING:
>   *	spin_lock_irqsave(host_set lock)
>   */
>  
> -void ata_to_sense_error(struct ata_queued_cmd *qc)
> +void ata_to_sense_error(struct ata_queued_cmd *qc, u8 drv_stat)
>  {
>  	struct scsi_cmnd *cmd = qc->scsicmd;
> +	u8 err = 0;
> +	unsigned char *sb = cmd->sense_buffer;
> +	/* Based on the 3ware driver translation table */
> +	static unsigned char sense_table[][4] = {
> +		/* BBD|ECC|ID|MAR */
> +		{0xd1, 		ABORTED_COMMAND, 0x00, 0x00}, 	// Device busy                  Aborted command
> +		/* BBD|ECC|ID */
> +		{0xd0,  	ABORTED_COMMAND, 0x00, 0x00}, 	// Device busy                  Aborted command
> +		/* ECC|MC|MARK */
> +		{0x61, 		HARDWARE_ERROR, 0x00, 0x00}, 	// Device fault                 Hardware error
> +		/* ICRC|ABRT */		/* NB: ICRC & !ABRT is BBD */
> +		{0x84, 		ABORTED_COMMAND, 0x47, 0x00}, 	// Data CRC error               SCSI parity error
> +		/* MC|ID|ABRT|TRK0|MARK */
> +		{0x37, 		NOT_READY, 0x04, 0x00}, 	// Unit offline                 Not ready
> +		/* MCR|MARK */
> +		{0x09, 		NOT_READY, 0x04, 0x00}, 	// Unrecovered disk error       Not ready
> +		/*  Bad address mark */
> +		{0x01, 		MEDIUM_ERROR, 0x13, 0x00}, 	// Address mark not found       Address mark not found for data field
> +		/* TRK0 */
> +		{0x02, 		HARDWARE_ERROR, 0x00, 0x00}, 	// Track 0 not found		  Hardware error
> +		/* Abort & !ICRC */
> +		{0x04, 		ABORTED_COMMAND, 0x00, 0x00}, 	// Aborted command              Aborted command
> +		/* Media change request */
> +		{0x08, 		NOT_READY, 0x04, 0x00}, 	// Media change request	  FIXME: faking offline
> +		/* SRV */
> +		{0x10, 		ABORTED_COMMAND, 0x14, 0x00}, 	// ID not found                 Recorded entity not found
> +		/* Media change */
> +		{0x08,  	NOT_READY, 0x04, 0x00}, 	// Media change		  FIXME: faking offline
> +		/* ECC */
> +		{0x40, 		MEDIUM_ERROR, 0x11, 0x04}, 	// Uncorrectable ECC error      Unrecovered read error
> +		/* BBD - block marked bad */
> +		{0x80, 		MEDIUM_ERROR, 0x11, 0x04}, 	// Block marked bad		  Medium error, unrecovered read error
> +		{0xFF, 0xFF, 0xFF, 0xFF}, // END mark 
> +	};
> +	static unsigned char stat_table[][4] = {
> +		/* Must be first because BUSY means no other bits valid */
> +		{0x80, 		ABORTED_COMMAND, 0x47, 0x00},	// Busy, fake parity for now
> +		{0x20, 		HARDWARE_ERROR,  0x00, 0x00}, 	// Device fault
> +		{0x08, 		ABORTED_COMMAND, 0x47, 0x00},	// Timed out in xfer, fake parity for now
> +		{0x04, 		RECOVERED_ERROR, 0x11, 0x00},	// Recovered ECC error	  Medium error, recovered
> +		{0xFF, 0xFF, 0xFF, 0xFF}, // END mark 
> +	};
> +	int i = 0;
>  
>  	cmd->result = SAM_STAT_CHECK_CONDITION;
> -
> -	cmd->sense_buffer[0] = 0x70;
> -	cmd->sense_buffer[2] = MEDIUM_ERROR;
> -	cmd->sense_buffer[7] = 14 - 8;	/* addnl. sense len. FIXME: correct? */
> -
> +	
> +	/*
> +	 *	Is this an error we can process/parse
> +	 */
> +	 
> +	if(drv_stat & ATA_ERR)
> +		/* Read the err bits */
> +		err = ata_chk_err(qc->ap);
> +
> +	/* Display the ATA level error info */
> +	
> +	printk(KERN_WARNING "ata%u: status=0x%02x { ", qc->ap->id, drv_stat);
> +	if(drv_stat & 0x80)
> +	{
> +		printk("Busy ");
> +		err = 0;	/* Data is not valid in this case */
> +	}
> +	else {
> +		if(drv_stat & 0x40)	printk("DriveReady ");
> +		if(drv_stat & 0x20)	printk("DeviceFault ");
> +		if(drv_stat & 0x10)	printk("SeekComplete ");
> +		if(drv_stat & 0x08)	printk("DataRequest ");
> +		if(drv_stat & 0x04)	printk("CorrectedError ");
> +		if(drv_stat & 0x02)	printk("Index ");
> +		if(drv_stat & 0x01)	printk("Error ");
> +	}
> +	printk("}\n");
> +	
> +	if(err)
> +	{
> +		printk(KERN_WARNING "ata%u: error=0x%02x { ", qc->ap->id, err);
> +		if(err & 0x04)		printk("DriveStatusError ");
> +		if(err & 0x80)
> +		{
> +			if(err & 0x04)
> +				printk("BadCRC ");
> +			else
> +				printk("Sector ");
> +		}
> +		if(err & 0x40)		printk("UncorrectableError ");
> +		if(err & 0x10)		printk("SectorIdNotFound ");
> +		if(err & 0x02)		printk("TrackZeroNotFound ");
> +		if(err & 0x01)		printk("AddrMarkNotFound ");
> +		printk("}\n");
> +		
> +		/* Should we dump sector info here too ?? */
> +	}
> +		
> +	
> +	/* Look for err */
> +	while(sense_table[i][0] != 0xFF)
> +	{
> +		/* Look for best matches first */
> +		if((sense_table[i][0] & err) == sense_table[i][0])
> +		{
> +			sb[0] = 0x70;
> +			sb[2] = sense_table[i][1];
> +			sb[7] = 0x0a;
> +			sb[12] = sense_table[i][2];
> +			sb[13] = sense_table[i][3];
> +			return;
> +		}
> +		i++;
> +	}
> +	/* No immediate match */
> +	if(err)
> +		printk(KERN_DEBUG "ata%u: no sense translation for 0x%02x\n", qc->ap->id, err);
> +	
> +	/* Fall back to interpreting status bits */
> +	while(stat_table[i][0] != 0xFF)
> +	{
> +		if(stat_table[i][0] & drv_stat)
> +		{
> +			sb[0] = 0x70;
> +			sb[2] = stat_table[i][1];
> +			sb[7] = 0x0a;
> +			sb[12] = stat_table[i][2];
> +			sb[13] = stat_table[i][3];
> +			return;
> +		}
> +		i++;
> +	}
> +	/* No error ?? */
> +	printk(KERN_ERR "ata%u: called with no error (%02X)!\n", qc->ap->id, drv_stat);
>  	/* additional-sense-code[-qualifier] */
> +	
> +	sb[0] = 0x70;
> +	sb[2] = MEDIUM_ERROR;
> +	sb[7] = 0x0A;
>  	if (cmd->sc_data_direction == SCSI_DATA_READ) {
> -		cmd->sense_buffer[12] = 0x11; /* "unrecovered read error" */
> -		cmd->sense_buffer[13] = 0x04;
> +		sb[12] = 0x11; /* "unrecovered read error" */
> +		sb[13] = 0x04;
>  	} else {
> -		cmd->sense_buffer[12] = 0x0C; /* "write error -             */
> -		cmd->sense_buffer[13] = 0x02; /*  auto-reallocation failed" */
> +		sb[12] = 0x0C; /* "write error -             */
> +		sb[13] = 0x02; /*  auto-reallocation failed" */
>  	}
>  }
>  
> @@ -343,7 +467,7 @@
>  		if (is_atapi_taskfile(&qc->tf))
>  			cmd->result = SAM_STAT_CHECK_CONDITION;
>  		else
> -			ata_to_sense_error(qc);
> +			ata_to_sense_error(qc, drv_stat);
>  	} else {
>  		cmd->result = SAM_STAT_GOOD;
>  	}
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

