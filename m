From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] osst: don't use obsolete SCSI APIs
Date: Thu, 20 Jan 2005 11:49:50 +0000
Message-ID: <20050120114950.GA619@infradead.org>
References: <20050103155305.GA24521@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:52650 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S262122AbVATLtz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Jan 2005 06:49:55 -0500
Content-Disposition: inline
In-Reply-To: <20050103155305.GA24521@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: jejb@steeleye.com, osst@riede.org, linux-scsi@vger.kernel.org

On Mon, Jan 03, 2005 at 04:53:05PM +0100, Christoph Hellwig wrote:
> this patch gets rid of the need for scsi.h, similar to the recent patch
> to the st driver.  (applies ontop of Willem's patches)

ping?

> 
> 
> 
> ===== drivers/scsi/osst.c 1.65 vs edited =====
> --- 1.65/drivers/scsi/osst.c	2005-01-02 04:04:08 +01:00
> +++ edited/drivers/scsi/osst.c	2005-01-02 21:49:05 +01:00
> @@ -63,10 +63,14 @@
>     in the drivers are more widely classified, this may be changed to KERN_DEBUG. */
>  #define OSST_DEB_MSG  KERN_NOTICE
>  
> -#include "scsi.h"
> -#include <scsi/scsi_host.h>
> +#include <scsi/scsi.h>
> +#include <scsi/scsi_dbg.h>
> +#include <scsi/scsi_device.h>
>  #include <scsi/scsi_driver.h>
> +#include <scsi/scsi_eh.h>
> +#include <scsi/scsi_host.h>
>  #include <scsi/scsi_ioctl.h>
> +#include <scsi/scsi_request.h>
>  
>  #define ST_KILOBYTE 1024
>  
> @@ -152,7 +156,7 @@
>  static struct osst_tape **os_scsi_tapes = NULL;
>  static rwlock_t os_scsi_tapes_lock = RW_LOCK_UNLOCKED;
>  
> -static int modes_defined = FALSE;
> +static int modes_defined = 0;
>  
>  static struct osst_buffer *new_tape_buffer(int, int, int);
>  static int enlarge_buffer(struct osst_buffer *, int);
> @@ -223,7 +227,7 @@
>  		if (scode) printk(OSST_DEB_MSG "%s:D: Sense: %02x, ASC: %02x, ASCQ: %02x\n",
>  			       	name, scode, sense[12], sense[13]);
>  		if (driver_byte(result) & DRIVER_SENSE)
> -			print_req_sense("osst ", SRpnt);
> +			scsi_print_req_sense("osst ", SRpnt);
>  	}
>  	else
>  #endif
> @@ -238,7 +242,7 @@
>  		 SRpnt->sr_cmnd[0] != TEST_UNIT_READY)) { /* Abnormal conditions for tape */
>  		if (driver_byte(result) & DRIVER_SENSE) {
>  			printk(KERN_WARNING "%s:W: Command with sense data:\n", name);
> -			print_req_sense("osst:", SRpnt);
> +			scsi_print_req_sense("osst:", SRpnt);
>  		}
>  		else {
>  			static	int	notyetprinted = 1;
> @@ -282,7 +286,7 @@
>  
>  
>  /* Wakeup from interrupt */
> -static void osst_sleep_done (Scsi_Cmnd * SCpnt)
> +static void osst_sleep_done (struct scsi_cmnd * SCpnt)
>  {
>  	struct osst_tape * STp = container_of(SCpnt->request->rq_disk->private_data, struct osst_tape, driver);
>  
> @@ -624,7 +628,7 @@
>  	memset(cmd, 0, MAX_COMMAND_SIZE);
>  	cmd[0] = TEST_UNIT_READY;
>  
> -	SRpnt = osst_do_scsi(*aSRpnt, STp, cmd, 0, SCSI_DATA_NONE, STp->timeout, MAX_RETRIES, TRUE);
> +	SRpnt = osst_do_scsi(*aSRpnt, STp, cmd, 0, DMA_NONE, STp->timeout, MAX_RETRIES, 1);
>  	*aSRpnt = SRpnt;
>  	if (!SRpnt) return (-EBUSY);
>  
> @@ -645,7 +649,7 @@
>  	    memset(cmd, 0, MAX_COMMAND_SIZE);
>  	    cmd[0] = TEST_UNIT_READY;
>  
> -	    SRpnt = osst_do_scsi(SRpnt, STp, cmd, 0, SCSI_DATA_NONE, STp->timeout, MAX_RETRIES, TRUE);
> +	    SRpnt = osst_do_scsi(SRpnt, STp, cmd, 0, DMA_NONE, STp->timeout, MAX_RETRIES, 1);
>  	}
>  	*aSRpnt = SRpnt;
>  #if DEBUG
> @@ -685,7 +689,7 @@
>  	memset(cmd, 0, MAX_COMMAND_SIZE);
>  	cmd[0] = TEST_UNIT_READY;
>  
> -	SRpnt = osst_do_scsi(*aSRpnt, STp, cmd, 0, SCSI_DATA_NONE, STp->timeout, MAX_RETRIES, TRUE);
> +	SRpnt = osst_do_scsi(*aSRpnt, STp, cmd, 0, DMA_NONE, STp->timeout, MAX_RETRIES, 1);
>  	*aSRpnt = SRpnt;
>  	if (!SRpnt) return (-EBUSY);
>  
> @@ -704,7 +708,7 @@
>  	    memset(cmd, 0, MAX_COMMAND_SIZE);
>  	    cmd[0] = TEST_UNIT_READY;
>  
> -	    SRpnt = osst_do_scsi(SRpnt, STp, cmd, 0, SCSI_DATA_NONE, STp->timeout, MAX_RETRIES, TRUE);
> +	    SRpnt = osst_do_scsi(SRpnt, STp, cmd, 0, DMA_NONE, STp->timeout, MAX_RETRIES, 1);
>  	}
>  	*aSRpnt = SRpnt;
>  #if DEBUG
> @@ -756,7 +760,7 @@
>  	cmd[0] = WRITE_FILEMARKS;
>  	cmd[1] = 1;
>  
> -	SRpnt = osst_do_scsi(*aSRpnt, STp, cmd, 0, SCSI_DATA_NONE, STp->timeout, MAX_RETRIES, TRUE);
> +	SRpnt = osst_do_scsi(*aSRpnt, STp, cmd, 0, DMA_NONE, STp->timeout, MAX_RETRIES, 1);
>  	*aSRpnt = SRpnt;
>  	if (!SRpnt) return (-EBUSY);
>  	if (STp->buffer->syscall_result) {
> @@ -847,8 +851,8 @@
>  		memset(cmd, 0, MAX_COMMAND_SIZE);
>  		cmd[0] = WRITE_FILEMARKS;
>  		cmd[1] = 1;
> -		SRpnt = osst_do_scsi(*aSRpnt, STp, cmd, 0, SCSI_DATA_NONE, STp->timeout,
> -								MAX_RETRIES, TRUE);
> +		SRpnt = osst_do_scsi(*aSRpnt, STp, cmd, 0, DMA_NONE, STp->timeout,
> +								MAX_RETRIES, 1);
>  
>  		while (retval && time_before (jiffies, startwait + 5*60*HZ)) {
>  
> @@ -865,8 +869,8 @@
>  			memset(cmd, 0, MAX_COMMAND_SIZE);
>  			cmd[0] = READ_POSITION;
>  
> -			SRpnt = osst_do_scsi(SRpnt, STp, cmd, 20, SCSI_DATA_READ, STp->timeout,
> -										MAX_RETRIES, TRUE);
> +			SRpnt = osst_do_scsi(SRpnt, STp, cmd, 20, DMA_FROM_DEVICE, STp->timeout,
> +										MAX_RETRIES, 1);
>  
>  			retval = ( STp->buffer->syscall_result || (STp->buffer)->b_data[15] > 25 );
>  			STp->buffer->b_data = olddata; STp->buffer->buffer_size = oldsize;
> @@ -911,8 +915,8 @@
>  	if (debugging)
>  		printk(OSST_DEB_MSG "%s:D: Reading frame from OnStream tape\n", name);
>  #endif
> -	SRpnt = osst_do_scsi(*aSRpnt, STp, cmd, OS_FRAME_SIZE, SCSI_DATA_READ,
> -				      STp->timeout, MAX_RETRIES, TRUE);
> +	SRpnt = osst_do_scsi(*aSRpnt, STp, cmd, OS_FRAME_SIZE, DMA_FROM_DEVICE,
> +				      STp->timeout, MAX_RETRIES, 1);
>  	*aSRpnt = SRpnt;
>  	if (!SRpnt)
>  		return (-EBUSY);
> @@ -987,7 +991,7 @@
>  #if DEBUG
>  		printk(OSST_DEB_MSG "%s:D: Start Read Ahead on OnStream tape\n", name);
>  #endif
> -		SRpnt   = osst_do_scsi(*aSRpnt, STp, cmd, 0, SCSI_DATA_NONE, STp->timeout, MAX_RETRIES, TRUE);
> +		SRpnt   = osst_do_scsi(*aSRpnt, STp, cmd, 0, DMA_NONE, STp->timeout, MAX_RETRIES, 1);
>  		*aSRpnt = SRpnt;
>  		if ((retval = STp->buffer->syscall_result))
>  			printk(KERN_WARNING "%s:W: Error starting read ahead\n", name);
> @@ -1120,7 +1124,7 @@
>  			"%s:D: Exit get logical frame (%d=>%d) from OnStream tape with code %d\n",
>  			name, frame_seq_number, STp->frame_seq_number, STps->eof);
>  #endif
> -	STp->fast_open = FALSE;
> +	STp->fast_open = 0;
>  	STp->read_error_frame = 0;
>  	return (STps->eof);
>  }
> @@ -1368,8 +1372,8 @@
>  		cmd[7] = 32768 >> 8;
>  		cmd[8] = 32768 & 0xff;
>  
> -		SRpnt = osst_do_scsi(SRpnt, STp, cmd, OS_FRAME_SIZE, SCSI_DATA_READ,
> -					    STp->timeout, MAX_RETRIES, TRUE);
> +		SRpnt = osst_do_scsi(SRpnt, STp, cmd, OS_FRAME_SIZE, DMA_FROM_DEVICE,
> +					    STp->timeout, MAX_RETRIES, 1);
>  	
>  		if ((STp->buffer)->syscall_result || !SRpnt) {
>  			printk(KERN_ERR "%s:E: Failed to read frame back from OnStream buffer\n", name);
> @@ -1440,8 +1444,8 @@
>  				name, new_frame+i, frame_seq_number+i, logical_blk_num + i*blks_per_frame,
>  				p[0], p[1], p[2], p[3]);
>  #endif
> -		SRpnt = osst_do_scsi(SRpnt, STp, cmd, OS_FRAME_SIZE, SCSI_DATA_WRITE,
> -					    STp->timeout, MAX_RETRIES, TRUE);
> +		SRpnt = osst_do_scsi(SRpnt, STp, cmd, OS_FRAME_SIZE, DMA_TO_DEVICE,
> +					    STp->timeout, MAX_RETRIES, 1);
>  
>  		if (STp->buffer->syscall_result)
>  			flag = 1;
> @@ -1456,8 +1460,8 @@
>  				memset(cmd, 0, MAX_COMMAND_SIZE);
>  				cmd[0] = WRITE_FILEMARKS;
>  				cmd[1] = 1;
> -				SRpnt = osst_do_scsi(SRpnt, STp, cmd, 0, SCSI_DATA_NONE,
> -							    STp->timeout, MAX_RETRIES, TRUE);
> +				SRpnt = osst_do_scsi(SRpnt, STp, cmd, 0, DMA_NONE,
> +							    STp->timeout, MAX_RETRIES, 1);
>  #if DEBUG
>  				if (debugging) {
>  					printk(OSST_DEB_MSG "%s:D: Sleeping in re-write wait ready\n", name);
> @@ -1471,8 +1475,8 @@
>  					memset(cmd, 0, MAX_COMMAND_SIZE);
>  					cmd[0] = TEST_UNIT_READY;
>  
> -					SRpnt = osst_do_scsi(SRpnt, STp, cmd, 0, SCSI_DATA_NONE, STp->timeout,
> -												MAX_RETRIES, TRUE);
> +					SRpnt = osst_do_scsi(SRpnt, STp, cmd, 0, DMA_NONE, STp->timeout,
> +												MAX_RETRIES, 1);
>  
>  					if (SRpnt->sr_sense_buffer[2] == 2 && SRpnt->sr_sense_buffer[12] == 4 &&
>  					    (SRpnt->sr_sense_buffer[13] == 1 || SRpnt->sr_sense_buffer[13] == 8)) {
> @@ -1577,8 +1581,8 @@
>  			printk(OSST_DEB_MSG "%s:D: About to write pending fseq %d at fppos %d\n",
>  					  name, STp->frame_seq_number-1, STp->first_frame_position);
>  #endif
> -			SRpnt = osst_do_scsi(*aSRpnt, STp, cmd, OS_FRAME_SIZE, SCSI_DATA_WRITE,
> -						      STp->timeout, MAX_RETRIES, TRUE);
> +			SRpnt = osst_do_scsi(*aSRpnt, STp, cmd, OS_FRAME_SIZE, DMA_TO_DEVICE,
> +						      STp->timeout, MAX_RETRIES, 1);
>  			*aSRpnt = SRpnt;
>  
>  			if (STp->buffer->syscall_result) {		/* additional write error */
> @@ -2036,7 +2040,7 @@
>  	if (debugging)
>  	    printk(OSST_DEB_MSG "%s:D: Setting number of retries on OnStream tape to %d\n", name, retries);
>  
> -	SRpnt = osst_do_scsi(SRpnt, STp, cmd, cmd[4], SCSI_DATA_WRITE, STp->timeout, 0, TRUE);
> +	SRpnt = osst_do_scsi(SRpnt, STp, cmd, cmd[4], DMA_TO_DEVICE, STp->timeout, 0, 1);
>  	*aSRpnt = SRpnt;
>  
>  	if ((STp->buffer)->syscall_result)
> @@ -2576,7 +2580,7 @@
>  	cmd[2] = BLOCK_SIZE_PAGE;
>  	cmd[4] = BLOCK_SIZE_PAGE_LENGTH + MODE_HEADER_LENGTH;
>  
> -	SRpnt = osst_do_scsi(SRpnt, STp, cmd, cmd[4], SCSI_DATA_READ, STp->timeout, 0, TRUE);
> +	SRpnt = osst_do_scsi(SRpnt, STp, cmd, cmd[4], DMA_FROM_DEVICE, STp->timeout, 0, 1);
>  	if (SRpnt == NULL) {
>  #if DEBUG
>   	    printk(OSST_DEB_MSG "osst :D: Busy\n");
> @@ -2613,7 +2617,7 @@
>  	cmd[1] = 0x10;
>  	cmd[4] = BLOCK_SIZE_PAGE_LENGTH + MODE_HEADER_LENGTH;
>  
> -	SRpnt = osst_do_scsi(SRpnt, STp, cmd, cmd[4], SCSI_DATA_WRITE, STp->timeout, 0, TRUE);
> +	SRpnt = osst_do_scsi(SRpnt, STp, cmd, cmd[4], DMA_TO_DEVICE, STp->timeout, 0, 1);
>  	*aSRpnt = SRpnt;
>  	if ((STp->buffer)->syscall_result != 0) {
>  	    printk (KERN_ERR "%s:E: Couldn't set tape block size mode page\n", name);
> @@ -2653,7 +2657,7 @@
>  	(STp->buffer)->b_data[MODE_HEADER_LENGTH + 6] = 0;
>  	(STp->buffer)->b_data[MODE_HEADER_LENGTH + 7] = 0;
>  
> -	SRpnt = osst_do_scsi(SRpnt, STp, cmd, cmd[4], SCSI_DATA_WRITE, STp->timeout, 0, TRUE);
> +	SRpnt = osst_do_scsi(SRpnt, STp, cmd, cmd[4], DMA_TO_DEVICE, STp->timeout, 0, 1);
>  	*aSRpnt = SRpnt;
>  
>  	if ((STp->buffer)->syscall_result != 0) {
> @@ -2668,7 +2672,7 @@
>  	cmd[2] = CAPABILITIES_PAGE;
>  	cmd[4] = CAPABILITIES_PAGE_LENGTH + MODE_HEADER_LENGTH;
>  
> -	SRpnt = osst_do_scsi(SRpnt, STp, cmd, cmd[4], SCSI_DATA_READ, STp->timeout, 0, TRUE);
> +	SRpnt = osst_do_scsi(SRpnt, STp, cmd, cmd[4], DMA_FROM_DEVICE, STp->timeout, 0, 1);
>  	*aSRpnt = SRpnt;
>  
>  	if ((STp->buffer)->syscall_result != 0) {
> @@ -2688,7 +2692,7 @@
>  	cmd[2] = TAPE_PARAMTR_PAGE;
>  	cmd[4] = TAPE_PARAMTR_PAGE_LENGTH + MODE_HEADER_LENGTH;
>  
> -	SRpnt = osst_do_scsi(SRpnt, STp, cmd, cmd[4], SCSI_DATA_READ, STp->timeout, 0, TRUE);
> +	SRpnt = osst_do_scsi(SRpnt, STp, cmd, cmd[4], DMA_FROM_DEVICE, STp->timeout, 0, 1);
>  	*aSRpnt = SRpnt;
>  
>  	if ((STp->buffer)->syscall_result != 0) {
> @@ -2762,8 +2766,8 @@
>  	scmd[0] = READ_POSITION;
>  
>  	STp->buffer->b_data = mybuf; STp->buffer->buffer_size = 24;
> -	SRpnt = osst_do_scsi(*aSRpnt, STp, scmd, 20, SCSI_DATA_READ,
> -				      STp->timeout, MAX_RETRIES, TRUE);
> +	SRpnt = osst_do_scsi(*aSRpnt, STp, scmd, 20, DMA_FROM_DEVICE,
> +				      STp->timeout, MAX_RETRIES, 1);
>  	if (!SRpnt) {
>  		STp->buffer->b_data = olddata; STp->buffer->buffer_size = oldsize;
>  		return (-EBUSY);
> @@ -2782,8 +2786,8 @@
>  			memset (scmd, 0, MAX_COMMAND_SIZE);
>  			scmd[0] = READ_POSITION;
>  			STp->buffer->b_data = mybuf; STp->buffer->buffer_size = 24;
> -			SRpnt = osst_do_scsi(SRpnt, STp, scmd, 20, SCSI_DATA_READ,
> -						    STp->timeout, MAX_RETRIES, TRUE);
> +			SRpnt = osst_do_scsi(SRpnt, STp, scmd, 20, DMA_FROM_DEVICE,
> +						    STp->timeout, MAX_RETRIES, 1);
>  #if DEBUG
>  			printk(OSST_DEB_MSG "%s:D: Reread position, reason=[%02x:%02x:%02x], result=[%s%02x:%02x:%02x]\n",
>  					name, mysense[2], mysense[12], mysense[13], STp->buffer->syscall_result?"":"ok:",
> @@ -2861,8 +2865,8 @@
>  		if (skip)
>  			scmd[9] = 0x80;
>  
> -		SRpnt = osst_do_scsi(*aSRpnt, STp, scmd, 0, SCSI_DATA_NONE, STp->long_timeout,
> -								MAX_RETRIES, TRUE);
> +		SRpnt = osst_do_scsi(*aSRpnt, STp, scmd, 0, DMA_NONE, STp->long_timeout,
> +								MAX_RETRIES, 1);
>  		if (!SRpnt)
>  			return (-EBUSY);
>  		*aSRpnt  = SRpnt;
> @@ -2999,8 +3003,8 @@
>  			  			 name, offset, transfer, blks);
>  #endif
>  
> -		SRpnt = osst_do_scsi(*aSRpnt, STp, cmd, transfer, SCSI_DATA_WRITE,
> -					      STp->timeout, MAX_RETRIES, TRUE);
> +		SRpnt = osst_do_scsi(*aSRpnt, STp, cmd, transfer, DMA_TO_DEVICE,
> +					      STp->timeout, MAX_RETRIES, 1);
>  		*aSRpnt = SRpnt;
>  		if (!SRpnt)
>  			return (-EBUSY);
> @@ -3082,7 +3086,7 @@
>  
>  	if (!seek_next) {
>  		if (STps->eof == ST_FM_HIT) {
> -			result = cross_eof(STp, aSRpnt, FALSE); /* Back over the EOF hit */
> +			result = cross_eof(STp, aSRpnt, 0); /* Back over the EOF hit */
>  			if (!result)
>  				STps->eof = ST_NOEOF;
>  			else {
> @@ -3156,7 +3160,7 @@
>  	if (!synchronous)
>  		STp->write_pending = 1;
>  #endif
> -	SRpnt = osst_do_scsi(*aSRpnt, STp, cmd, OS_FRAME_SIZE, SCSI_DATA_WRITE, STp->timeout,
> +	SRpnt = osst_do_scsi(*aSRpnt, STp, cmd, OS_FRAME_SIZE, DMA_TO_DEVICE, STp->timeout,
>  									MAX_RETRIES, synchronous);
>  	if (!SRpnt)
>  		return (-EBUSY);
> @@ -3218,7 +3222,7 @@
>  		STps->rw = ST_IDLE;
>  		STps->eof = ST_NOEOF;
>  		STps->at_sm = 0;
> -		STps->last_block_valid = FALSE;
> +		STps->last_block_valid = 0;
>  		STps->drv_block = -1;
>  		STps->drv_file = -1;
>  	}
> @@ -3372,7 +3376,7 @@
>  #endif
>  			}
>  		}
> -		STp->fast_open = FALSE;
> +		STp->fast_open = 0;
>  	}
>  	if (!STp->header_ok) {
>  #if DEBUG
> @@ -3447,7 +3451,7 @@
>  		blks = do_count / STp->block_size;
>  		STp->logical_blk_num += blks;  /* logical_blk_num is incremented as data is moved from user */
>    
> -		i = osst_write_frame(STp, &SRpnt, TRUE);
> +		i = osst_write_frame(STp, &SRpnt, 1);
>  
>  		if (i == (-ENOSPC)) {
>  			transfer = STp->buffer->writing;	/* FIXME -- check this logic */
> @@ -3528,7 +3532,7 @@
>  		STp->dirty = !((STp->buffer)->writing ==
>  				          (STp->buffer)->buffer_bytes);
>  
> -		i = osst_write_frame(STp, &SRpnt, FALSE);
> +		i = osst_write_frame(STp, &SRpnt, 0);
>  		if (i < 0) {
>  			retval = (-EIO);
>  			goto out;
> @@ -3769,7 +3773,7 @@
>  	STm = &(STp->modes[STp->current_mode]);
>  	if (!STm->defined) {
>  		memcpy(STm, &(STp->modes[0]), sizeof(*STm));
> -		modes_defined = TRUE;
> +		modes_defined = 1;
>  #if DEBUG
>  		if (debugging)
>  			printk(OSST_DEB_MSG "%s:D: Initialized mode %d definition from mode 0\n",
> @@ -3921,12 +3925,12 @@
>  	int			timeout;
>  	long			ltmp;
>  	int			i, ioctl_result;
> -	int			chg_eof = TRUE;
> +	int			chg_eof = 1;
>  	unsigned char		cmd[MAX_COMMAND_SIZE];
>  	struct scsi_request   * SRpnt = * aSRpnt;
>  	struct st_partstat    * STps;
>  	int			fileno, blkno, at_sm, frame_seq_numbr, logical_blk_num;
> -	int			datalen = 0, direction = SCSI_DATA_NONE;
> +	int			datalen = 0, direction = DMA_NONE;
>  	char		      * name = tape_name(STp);
>  
>  	if (STp->ready != ST_READY && cmd_in != MTLOAD) {
> @@ -3946,7 +3950,7 @@
>  	memset(cmd, 0, MAX_COMMAND_SIZE);
>  	switch (cmd_in) {
>  	 case MTFSFM:
> -		chg_eof = FALSE; /* Changed from the FSF after this */
> +		chg_eof = 0; /* Changed from the FSF after this */
>  	 case MTFSF:
>  		if (STp->raw)
>  		   return (-EIO);
> @@ -3961,7 +3965,7 @@
>  		goto os_bypass;
>  
>  	 case MTBSF:
> -		chg_eof = FALSE; /* Changed from the FSF after this */
> +		chg_eof = 0; /* Changed from the FSF after this */
>  	 case MTBSFM:
>  		if (STp->raw)
>  		   return (-EIO);
> @@ -4176,7 +4180,7 @@
>  	 case MTSETDENSITY:       /* Set tape density */
>  	 case MTSETDRVBUFFER:     /* Set drive buffering */
>  	 case SET_DENS_AND_BLK:   /* Set density and block size */
> -		 chg_eof = FALSE;
> +		 chg_eof = 0;
>  		 if (STp->dirty || (STp->buffer)->buffer_bytes != 0)
>  			 return (-EIO);       /* Not allowed if data in buffer */
>  		 if ((cmd_in == MTSETBLK || cmd_in == SET_DENS_AND_BLK) &&
> @@ -4193,7 +4197,7 @@
>  		return (-ENOSYS);
>  	}
>  
> -	SRpnt = osst_do_scsi(SRpnt, STp, cmd, datalen, direction, timeout, MAX_RETRIES, TRUE);
> +	SRpnt = osst_do_scsi(SRpnt, STp, cmd, datalen, direction, timeout, MAX_RETRIES, 1);
>  
>  	ioctl_result = (STp->buffer)->syscall_result;
>  
> @@ -4249,7 +4253,7 @@
>  		else if (cmd_in == MTLOAD) {
>  			for (i=0; i < ST_NBR_PARTITIONS; i++) {
>  			    STp->ps[i].rw = ST_IDLE;
> -			    STp->ps[i].last_block_valid = FALSE;/* FIXME - where else is this field maintained? */
> +			    STp->ps[i].last_block_valid = 0;/* FIXME - where else is this field maintained? */
>  			}
>  			STp->partition = 0;
>  		}
> @@ -4304,7 +4308,7 @@
>  static int os_scsi_tape_open(struct inode * inode, struct file * filp)
>  {
>  	unsigned short	      flags;
> -	int		      i, b_size, new_session = FALSE, retval = 0;
> +	int		      i, b_size, new_session = 0, retval = 0;
>  	unsigned char	      cmd[MAX_COMMAND_SIZE];
>  	struct scsi_request * SRpnt = NULL;
>  	struct osst_tape    * STp;
> @@ -4353,7 +4357,7 @@
>  			printk(OSST_DEB_MSG "%s:D: Mode change from %d to %d.\n",
>  					       name, STp->current_mode, mode);
>  #endif
> -		new_session = TRUE;
> +		new_session = 1;
>  		STp->current_mode = mode;
>  	}
>  	STm = &(STp->modes[STp->current_mode]);
> @@ -4403,7 +4407,7 @@
>  	memset (cmd, 0, MAX_COMMAND_SIZE);
>  	cmd[0] = TEST_UNIT_READY;
>  
> -	SRpnt = osst_do_scsi(NULL, STp, cmd, 0, SCSI_DATA_NONE, STp->timeout, MAX_RETRIES, TRUE);
> +	SRpnt = osst_do_scsi(NULL, STp, cmd, 0, DMA_NONE, STp->timeout, MAX_RETRIES, 1);
>  	if (!SRpnt) {
>  		retval = (STp->buffer)->syscall_result;		/* FIXME - valid? */
>  		goto err_out;
> @@ -4423,8 +4427,8 @@
>          		cmd[0] = START_STOP;
>  			cmd[1] = 1;
>  			cmd[4] = 1;
> -			SRpnt = osst_do_scsi(SRpnt, STp, cmd, 0, SCSI_DATA_NONE,
> -					     STp->timeout, MAX_RETRIES, TRUE);
> +			SRpnt = osst_do_scsi(SRpnt, STp, cmd, 0, DMA_NONE,
> +					     STp->timeout, MAX_RETRIES, 1);
>  		}
>  		osst_wait_ready(STp, &SRpnt, (SRpnt->sr_sense_buffer[13]==1?15:3) * 60, 0);
>  	}
> @@ -4440,8 +4444,8 @@
>  			memset (cmd, 0, MAX_COMMAND_SIZE);
>  			cmd[0] = TEST_UNIT_READY;
>  
> -			SRpnt = osst_do_scsi(SRpnt, STp, cmd, 0, SCSI_DATA_NONE,
> -					     STp->timeout, MAX_RETRIES, TRUE);
> +			SRpnt = osst_do_scsi(SRpnt, STp, cmd, 0, DMA_NONE,
> +					     STp->timeout, MAX_RETRIES, 1);
>  			if ((SRpnt->sr_sense_buffer[0] & 0x70) != 0x70 ||
>  			    (SRpnt->sr_sense_buffer[2] & 0x0f) != UNIT_ATTENTION)
>  				break;
> @@ -4456,11 +4460,11 @@
>  			STps->rw = ST_IDLE;		/* FIXME - seems to be redundant... */
>  			STps->eof = ST_NOEOF;
>  			STps->at_sm = 0;
> -			STps->last_block_valid = FALSE;
> +			STps->last_block_valid = 0;
>  			STps->drv_block = 0;
>  			STps->drv_file = 0 ;
>  		}
> -		new_session = TRUE;
> +		new_session = 1;
>  		STp->recover_count = 0;
>  		STp->abort_count = 0;
>  	}
> @@ -4477,7 +4481,7 @@
>  		cmd[2] = VENDOR_IDENT_PAGE;
>  		cmd[4] = VENDOR_IDENT_PAGE_LENGTH + MODE_HEADER_LENGTH;
>  
> -		SRpnt = osst_do_scsi(SRpnt, STp, cmd, cmd[4], SCSI_DATA_READ, STp->timeout, 0, TRUE);
> +		SRpnt = osst_do_scsi(SRpnt, STp, cmd, cmd[4], DMA_FROM_DEVICE, STp->timeout, 0, 1);
>  
>  		if (STp->buffer->syscall_result                     ||
>  		    STp->buffer->b_data[MODE_HEADER_LENGTH + 2] != 'L' ||
> @@ -4507,7 +4511,7 @@
>  				STp->buffer->buffer_bytes = STp->buffer->read_pointer = 0;
>  			}
>  			STp->buffer->buffer_blocks = OS_DATA_SIZE / STp->block_size;
> -			STp->fast_open = TRUE;
> +			STp->fast_open = 1;
>  			scsi_release_request(SRpnt);
>  			return 0;
>  		}
> @@ -4518,7 +4522,7 @@
>  #endif
>  		STp->header_ok = 0;
>  	}
> -	STp->fast_open = FALSE;
> +	STp->fast_open = 0;
>  
>  	if ((STp->buffer)->syscall_result != 0 &&   /* in all error conditions except no medium */ 
>  	    (SRpnt->sr_sense_buffer[2] != 2 || SRpnt->sr_sense_buffer[12] != 0x3A) ) {
> @@ -4540,7 +4544,7 @@
>  #if DEBUG
>  		printk(OSST_DEB_MSG "%s:D: Applying soft reset\n", name);
>  #endif
> -		SRpnt = osst_do_scsi(SRpnt, STp, cmd, cmd[4], SCSI_DATA_WRITE, STp->timeout, 0, TRUE);
> +		SRpnt = osst_do_scsi(SRpnt, STp, cmd, cmd[4], DMA_TO_DEVICE, STp->timeout, 0, 1);
>  
>  		STp->header_ok = 0;
>  
> @@ -4549,8 +4553,8 @@
>  			memset (cmd, 0, MAX_COMMAND_SIZE);
>  			cmd[0] = TEST_UNIT_READY;
>  
> -			SRpnt = osst_do_scsi(SRpnt, STp, cmd, 0, SCSI_DATA_NONE,
> -						    STp->timeout, MAX_RETRIES, TRUE);
> +			SRpnt = osst_do_scsi(SRpnt, STp, cmd, 0, DMA_NONE,
> +						    STp->timeout, MAX_RETRIES, 1);
>  			if ((SRpnt->sr_sense_buffer[0] & 0x70) != 0x70 ||
>  			    (SRpnt->sr_sense_buffer[2] & 0x0f) == NOT_READY)
>  			break;
> @@ -4565,11 +4569,11 @@
>  					STps->rw = ST_IDLE;
>  					STps->eof = ST_NOEOF;
>  					STps->at_sm = 0;
> -					STps->last_block_valid = FALSE;
> +					STps->last_block_valid = 0;
>  					STps->drv_block = 0;
>  					STps->drv_file = 0 ;
>  				}
> -				new_session = TRUE;
> +				new_session = 1;
>  			}
>  		}
>  	}
> @@ -4629,8 +4633,8 @@
>  		if (debugging)
>  	printk(OSST_DEB_MSG "%s:D: New Session\n", name);
>  #endif
> -		STp->density_changed = STp->blksize_changed = FALSE;
> -		STp->compression_changed = FALSE;
> +		STp->density_changed = STp->blksize_changed = 0;
> +		STp->compression_changed = 0;
>  	}
>  
>  	/*
> @@ -4704,7 +4708,7 @@
>  			if (STp->can_bsr)
>  				result = osst_flush_buffer(STp, &SRpnt, 0); /* this is the default path */
>  			else if (STps->eof == ST_FM_HIT) {
> -				result = cross_eof(STp, &SRpnt, FALSE);
> +				result = cross_eof(STp, &SRpnt, 0);
>  					if (result) {
>  						if (STps->drv_file >= 0)
>  							STps->drv_file++;
> @@ -4716,7 +4720,7 @@
>  			}
>  		}
>  		else if ((STps->eof == ST_NOEOF &&
> -			  !(result = cross_eof(STp, &SRpnt, TRUE))) ||
> +			  !(result = cross_eof(STp, &SRpnt, 1))) ||
>  			 STps->eof == ST_FM_HIT) {
>  			if (STps->drv_file >= 0)
>  				STps->drv_file++;
> @@ -4971,7 +4975,7 @@
>  			for (i=0; i < ST_NBR_PARTITIONS; i++) {
>  				STp->ps[i].rw = ST_IDLE;
>  				STp->ps[i].at_sm = 0;
> -				STp->ps[i].last_block_valid = FALSE;
> +				STp->ps[i].last_block_valid = 0;
>  			}
>  			STp->partition = STp->new_partition = 0;
>  			STp->nbr_partitions = 1;  /* Bad guess ?-) */
> @@ -4997,7 +5001,7 @@
>  		}
>  
>  		if (auto_weof)
> -			cross_eof(STp, &SRpnt, FALSE);
> +			cross_eof(STp, &SRpnt, 0);
>  
>  		if (mtc.mt_op == MTCOMPRESSION)
>  			retval = -EINVAL;       /* OnStream drives don't have compression hardware */
> @@ -5013,7 +5017,7 @@
>  		goto out;
>  	}
>  
> -	if ((i = osst_flush_buffer(STp, &SRpnt, FALSE)) < 0) {
> +	if ((i = osst_flush_buffer(STp, &SRpnt, 0)) < 0) {
>  		retval = i;
>  		goto out;
>  	}
> @@ -5140,7 +5144,7 @@
>  	memset(tb, 0, i);
>  	tb->sg_segs = tb->orig_sg_segs = 0;
>  	tb->use_sg = max_sg;
> -	tb->in_use = TRUE;
> +	tb->in_use = 1;
>  	tb->dma = need_dma;
>  	tb->buffer_size = 0;
>  #if DEBUG
> @@ -5158,7 +5162,7 @@
>  	int segs, nbr, max_segs, b_size, priority, order, got;
>  
>  	if (STbuffer->buffer_size >= OS_FRAME_SIZE)
> -		return TRUE;
> +		return 1;
>  
>  	if (STbuffer->sg_segs) {
>  		printk(KERN_WARNING "osst :A: Buffer not previously normalized.\n");
> @@ -5167,7 +5171,7 @@
>  	/* See how many segments we can use -- need at least two */
>  	nbr = max_segs = STbuffer->use_sg;
>  	if (nbr <= 2)
> -		return FALSE;
> +		return 0;
>  
>  	priority = GFP_KERNEL /* | __GFP_NOWARN */;
>  	if (need_dma)
> @@ -5186,7 +5190,7 @@
>  	}
>  	if (STbuffer->sg[0].page == NULL) {
>  		printk(KERN_NOTICE "osst :I: Can't allocate tape buffer main segment.\n");
> -		return FALSE;
> +		return 0;
>  	}
>  	/* Got initial segment of 'bsize,order', continue with same size if possible, except for AUX */
>  	for (segs=STbuffer->sg_segs=1, got=b_size;
> @@ -5206,7 +5210,7 @@
>  			STbuffer->buffer_size = got;
>  #endif
>  			normalize_buffer(STbuffer);
> -			return FALSE;
> +			return 0;
>  		}
>  		STbuffer->sg[segs].length = (OS_FRAME_SIZE - got <= PAGE_SIZE / 2) ? (OS_FRAME_SIZE - got) : b_size;
>  		got += STbuffer->sg[segs].length;
> @@ -5225,7 +5229,7 @@
>  	}
>  #endif
>  
> -	return TRUE;
> +	return 1;
>  }
>  
>  
> @@ -5457,7 +5461,7 @@
>  	.release =      os_scsi_tape_close,
>  };
>  
> -static int osst_supports(Scsi_Device * SDp)
> +static int osst_supports(struct scsi_device * SDp)
>  {
>  	struct	osst_support_data {
>  		char *vendor;
> @@ -5592,7 +5596,7 @@
>  	if ( IS_ERR(osst_sysfs_class) )
>  		printk(KERN_WARNING "osst :W: Unable to register sysfs class\n");
>  	else
> -		osst_sysfs_valid = TRUE;
> +		osst_sysfs_valid = 1;
>  }
>  
>  static void osst_sysfs_add(dev_t dev, struct device *device, struct osst_tape * STp, char * name)
> @@ -5636,7 +5640,7 @@
>  
>  static int osst_probe(struct device *dev)
>  {
> -	Scsi_Device	   * SDp = to_scsi_device(dev);
> +	struct scsi_device * SDp = to_scsi_device(dev);
>  	struct osst_tape   * tpnt;
>  	struct st_modedef  * STm;
>  	struct st_partstat * STps;
> @@ -5691,7 +5695,7 @@
>  	i = SDp->host->sg_tablesize;
>  	if (osst_max_sg_segs < i)
>  		i = osst_max_sg_segs;
> -	buffer = new_tape_buffer(TRUE, SDp->host->unchecked_isa_dma, i);
> +	buffer = new_tape_buffer(1, SDp->host->unchecked_isa_dma, i);
>  	if (buffer == NULL) {
>  		write_unlock(&os_scsi_tapes_lock);
>  		printk(KERN_ERR "osst :E: Unable to allocate a tape buffer, device not attached.\n");
> @@ -5741,7 +5745,7 @@
>  
>  	for (i=0; i < ST_NBR_MODES; i++) {
>  		STm = &(tpnt->modes[i]);
> -		STm->defined = FALSE;
> +		STm->defined = 0;
>  		STm->sysv = OSST_SYSV;
>  		STm->defaults_for_writes = 0;
>  		STm->do_async_writes = OSST_ASYNC_WRITES;
> @@ -5757,15 +5761,15 @@
>  		STps->rw = ST_IDLE;
>  		STps->eof = ST_NOEOF;
>  		STps->at_sm = 0;
> -		STps->last_block_valid = FALSE;
> +		STps->last_block_valid = 0;
>  		STps->drv_block = (-1);
>  		STps->drv_file = (-1);
>  	}
>  
>  	tpnt->current_mode = 0;
> -	tpnt->modes[0].defined = TRUE;
> -	tpnt->modes[2].defined = TRUE;
> -	tpnt->density_changed = tpnt->compression_changed = tpnt->blksize_changed = FALSE;
> +	tpnt->modes[0].defined = 1;
> +	tpnt->modes[2].defined = 1;
> +	tpnt->density_changed = tpnt->compression_changed = tpnt->blksize_changed = 0;
>  
>  	init_MUTEX(&tpnt->lock);
>  	osst_nr_dev++;
> @@ -5804,7 +5808,7 @@
>  
>  static int osst_remove(struct device *dev)
>  {
> -	Scsi_Device	 * SDp = to_scsi_device(dev);
> +	struct scsi_device * SDp = to_scsi_device(dev);
>  	struct osst_tape * tpnt;
>  	int i, mode;
>  
> ===== drivers/scsi/osst.h 1.14 vs edited =====
> --- 1.14/drivers/scsi/osst.h	2005-01-02 03:49:34 +01:00
> +++ edited/drivers/scsi/osst.h	2005-01-02 21:44:29 +01:00
> @@ -518,7 +518,7 @@
>    int writing;
>    int midlevel_result;
>    int syscall_result;
> -  Scsi_Request *last_SRpnt;
> +  struct scsi_request *last_SRpnt;
>    unsigned char *b_data;
>    os_aux_t *aux;               /* onstream AUX structure at end of each block     */
>    unsigned short use_sg;       /* zero or number of s/g segments for this adapter */
> @@ -531,7 +531,7 @@
>  struct osst_tape {
>    struct scsi_driver *driver;
>    unsigned capacity;
> -  Scsi_Device* device;
> +  struct scsi_device *device;
>    struct semaphore lock;       /* for serialization */
>    struct completion wait;      /* for SCSI commands */
>    struct osst_buffer * buffer;
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
---end quoted text---
