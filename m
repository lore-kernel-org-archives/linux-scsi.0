From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH ver4 1/5] scsi_error: code cleanup before refactoring
	of scsi_send_eh_cmnd()
Date: Wed, 03 Oct 2007 10:55:57 -0500
Message-ID: <1191426957.3340.8.camel@localhost.localdomain>
References: <46E59760.9020705@panasas.com> <46E59C3E.1020703@panasas.com>
	 <46E6D2ED.1060201@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:60208 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751282AbXJCRCA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Oct 2007 13:02:00 -0400
In-Reply-To: <46E6D2ED.1060201@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi <linux-scsi@vger.kernel.org>, Alan Stern <stern@rowland.harvard.edu>, Greg Kroah-Hartman <gregkh@suse.de>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, Russell King <rmk@arm.linux.org.uk>, Christoph Hellwig <hch@infradead.org>, Randy Dunlap <rdunlap@xenotime.net>

On Tue, 2007-09-11 at 20:39 +0300, Boaz Harrosh wrote:
> - regrouped variables for easier reviewing of next patch
>   - Support of cmnd==NULL in call to scsi_send_eh_cmnd()
>   - In the copy_sense case set transfer size to the minimum
>     size of sense_buffer and passed @sense_bytes. cmnd[4] is
>     set accordingly.
>   - REQUEST_SENSE is set into cmnd[0] so if @sense_bytes is
>     not Zero passed cmnd can/should be NULL.
>   - Also save/restore resid of faild command.
> 
> Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
> ---
>  drivers/scsi/scsi_error.c |   69 ++++++++++++++++++++++++--------------------
>  1 files changed, 38 insertions(+), 31 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> index c8e351f..11c928d 100644
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -607,21 +607,24 @@ static void scsi_abort_eh_cmnd(struct scsi_cmnd *scmd)
>   *    SUCCESS or FAILED or NEEDS_RETRY
>   **/
>  static int scsi_send_eh_cmnd(struct scsi_cmnd *scmd, unsigned char *cmnd,
> -			     int cmnd_size, int timeout, int copy_sense)
> +			     int cmnd_size, int timeout, unsigned sense_bytes)

You've altered the signature and function of the routine here, this
needs to be documented by updating the docbook description above the
function.  (I know you do it later, but each changeset should really be
logically complete).

>  {
>  	struct scsi_device *sdev = scmd->device;
>  	struct Scsi_Host *shost = sdev->host;
> -	int old_result = scmd->result;
>  	DECLARE_COMPLETION_ONSTACK(done);
>  	unsigned long timeleft;
>  	unsigned long flags;
> -	struct scatterlist sgl;
> +
> +	unsigned char old_cmd_len;
>  	unsigned char old_cmnd[MAX_COMMAND_SIZE];
>  	enum dma_data_direction old_data_direction;
> -	unsigned short old_use_sg;
> -	unsigned char old_cmd_len;
>  	unsigned old_bufflen;
>  	void *old_buffer;
> +	unsigned short old_use_sg;
> +	int old_resid;
> +	int old_result;
> +
> +	struct scatterlist sgl;
>  	int rtn;
>  
>  	/*
> @@ -631,24 +634,37 @@ static int scsi_send_eh_cmnd(struct scsi_cmnd *scmd, unsigned char *cmnd,
>  	 * we will need to restore these values prior to running the actual
>  	 * command.
>  	 */
> -	old_buffer = scmd->request_buffer;
> -	old_bufflen = scmd->request_bufflen;
> +	old_cmd_len = scmd->cmd_len;
>  	memcpy(old_cmnd, scmd->cmnd, sizeof(scmd->cmnd));
>  	old_data_direction = scmd->sc_data_direction;
> -	old_cmd_len = scmd->cmd_len;
> +	old_bufflen = scmd->request_bufflen;
> +	old_buffer = scmd->request_buffer;
>  	old_use_sg = scmd->use_sg;
> +	old_resid = scmd->resid;
> +	old_result = scmd->result;
>  
> -	memset(scmd->cmnd, 0, sizeof(scmd->cmnd));
> -	memcpy(scmd->cmnd, cmnd, cmnd_size);
> -
> -	if (copy_sense) {
> -		sg_init_one(&sgl, scmd->sense_buffer,
> -			    sizeof(scmd->sense_buffer));
> +	if (cmnd) {
> +		memset(scmd->cmnd, 0, sizeof(scmd->cmnd));
> +		memcpy(scmd->cmnd, cmnd, cmnd_size);
> +		scmd->cmd_len = COMMAND_SIZE(scmd->cmnd[0]);
> +	}
>  
> -		scmd->sc_data_direction = DMA_FROM_DEVICE;
> -		scmd->request_bufflen = sgl.length;
> +	if (sense_bytes) {
> +		scmd->request_bufflen = min_t(unsigned,
> +		                       sizeof(scmd->sense_buffer), sense_bytes);
> +		sg_init_one(&sgl, scmd->sense_buffer, scmd->request_bufflen);
>  		scmd->request_buffer = &sgl;
> +		scmd->sc_data_direction = DMA_FROM_DEVICE;
>  		scmd->use_sg = 1;
> +		memset(scmd->cmnd, 0, 6);

This will lead to subtle bugs: some devices (notably ATAPI) have a fixed
command slot they will copy this into.  You have potentially trailing
bytes of junk that this could pick up ... we have ATAPI devices known to
fall over if they see trailing junk in the command.  Just consolidate
the scmd->cmnd memsets to

memset(scmd->cmnd, 0, sizeof(scmd->cmnd);

outside of the ifs

> +		scmd->cmnd[0] = REQUEST_SENSE;
> +		scmd->cmnd[4] = scmd->request_bufflen;
> +		scmd->cmd_len = COMMAND_SIZE(scmd->cmnd[0]);
> +		/*
> +		 * Zero the sense buffer.  The scsi spec mandates that any
> +		 * untransferred sense data should be interpreted as being zero.
> +		 */
> +		memset(scmd->sense_buffer, 0, sizeof(scmd->sense_buffer));
>  	} else {
>  		scmd->request_buffer = NULL;
>  		scmd->request_bufflen = 0;
> @@ -657,18 +673,11 @@ static int scsi_send_eh_cmnd(struct scsi_cmnd *scmd, unsigned char *cmnd,
>  	}
>  
>  	scmd->underflow = 0;
> -	scmd->cmd_len = COMMAND_SIZE(scmd->cmnd[0]);
>  
> -	if (sdev->scsi_level <= SCSI_2)
> +	if (sdev->scsi_level <= SCSI_2 && sdev->scsi_level != SCSI_UNKNOWN)
>  		scmd->cmnd[1] = (scmd->cmnd[1] & 0x1f) |
>  			(sdev->lun << 5 & 0xe0);
>  
> -	/*
> -	 * Zero the sense buffer.  The scsi spec mandates that any
> -	 * untransferred sense data should be interpreted as being zero.
> -	 */
> -	memset(scmd->sense_buffer, 0, sizeof(scmd->sense_buffer));

Moving this to the sense_bytes specific piece of the if also introduces
a subtle bug:  If the driver doesn't do auto request sense and the
command completes with CHECK CONDITION, the sense checking routine will
potentially pick up stale sense data here

> -
>  	shost->eh_action = &done;
>  
>  	spin_lock_irqsave(shost->host_lock, flags);
> @@ -716,12 +725,13 @@ static int scsi_send_eh_cmnd(struct scsi_cmnd *scmd, unsigned char *cmnd,
>  	/*
>  	 * Restore original data
>  	 */
> -	scmd->request_buffer = old_buffer;
> -	scmd->request_bufflen = old_bufflen;
> +	scmd->cmd_len = old_cmd_len;
>  	memcpy(scmd->cmnd, old_cmnd, sizeof(scmd->cmnd));
>  	scmd->sc_data_direction = old_data_direction;
> -	scmd->cmd_len = old_cmd_len;
> +	scmd->request_bufflen = old_bufflen;
> +	scmd->request_buffer = old_buffer;
>  	scmd->use_sg = old_use_sg;
> +	scmd->resid = old_resid;
>  	scmd->result = old_result;
>  	return rtn;
>  }
> @@ -737,10 +747,7 @@ static int scsi_send_eh_cmnd(struct scsi_cmnd *scmd, unsigned char *cmnd,
>   **/
>  static int scsi_request_sense(struct scsi_cmnd *scmd)
>  {
> -	static unsigned char generic_sense[6] =
> -		{REQUEST_SENSE, 0, 0, 0, 252, 0};
> -
> -	return scsi_send_eh_cmnd(scmd, generic_sense, 6, SENSE_TIMEOUT, 1);
> +	return scsi_send_eh_cmnd(scmd, NULL, 0, SENSE_TIMEOUT, ~0);
>  }
>  
>  /**

Other than the three comments, this looks OK.

James


