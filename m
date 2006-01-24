From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH 1/1] scsi: Prevent scsi_execute_async from guessing cdb
 length
Date: Tue, 24 Jan 2006 11:29:15 +1000
Message-ID: <43D582EB.4020606@torque.net>
References: <200601232103.k0NL3PlN012140@d01av04.pok.ibm.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zorg.st.net.au ([203.16.233.9]:47012 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S1030287AbWAXB2v (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 23 Jan 2006 20:28:51 -0500
In-Reply-To: <200601232103.k0NL3PlN012140@d01av04.pok.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: brking@us.ibm.com, James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org

brking@us.ibm.com wrote:
> When the scsi_execute_async interface was added it ended up reducing
> the flexibility of userspace to send arbitrary scsi commands through
> sg using SG_IO. The SG_IO interface allows userspace to specify the
> CDB length. This is now ignored in scsi_execute_async and it is
> guessed using the COMMAND_SIZE macro, which is not always correct,
> particularly for vendor specific commands. This patch adds a cmd_len
> parameter to the scsi_execute_async interface to allow the caller
> to specify the length of the CDB.
> 
> James - I'd really like to get this one into the rc fixes since without it,
> all of the raid configuration tools for ipr are broken.
> 
> 
> Signed-off-by: Brian King <brking@us.ibm.com>

James,
IMO this fix is very important.

Signed-off-by: Douglas Gilbert <dougg@torque.net>

> ---
> 
>  linux-2.6-bjking1/drivers/scsi/scsi_error.c  |    2 +-
>  linux-2.6-bjking1/drivers/scsi/scsi_lib.c    |    5 +++--
>  linux-2.6-bjking1/drivers/scsi/sg.c          |    2 +-
>  linux-2.6-bjking1/drivers/scsi/st.c          |    2 +-
>  linux-2.6-bjking1/include/scsi/scsi_device.h |    2 +-
>  5 files changed, 7 insertions(+), 6 deletions(-)
> 
> diff -puN drivers/scsi/scsi_lib.c~scsi_exec_async_vendor_fix drivers/scsi/scsi_lib.c
> --- linux-2.6/drivers/scsi/scsi_lib.c~scsi_exec_async_vendor_fix	2006-01-23 14:24:15.000000000 -0600
> +++ linux-2.6-bjking1/drivers/scsi/scsi_lib.c	2006-01-23 14:33:12.000000000 -0600
> @@ -436,6 +436,7 @@ free_bios:
>   * scsi_execute_async - insert request
>   * @sdev:	scsi device
>   * @cmd:	scsi command
> + * @cmd_len:	length of scsi cdb
>   * @data_direction: data direction
>   * @buffer:	data buffer (this can be a kernel buffer or scatterlist)
>   * @bufflen:	len of buffer
> @@ -445,7 +446,7 @@ free_bios:
>   * @flags:	or into request flags
>   **/
>  int scsi_execute_async(struct scsi_device *sdev, const unsigned char *cmd,
> -		       int data_direction, void *buffer, unsigned bufflen,
> +		       int cmd_len, int data_direction, void *buffer, unsigned bufflen,
>  		       int use_sg, int timeout, int retries, void *privdata,
>  		       void (*done)(void *, char *, int, int), gfp_t gfp)
>  {
> @@ -472,7 +473,7 @@ int scsi_execute_async(struct scsi_devic
>  	if (err)
>  		goto free_req;
>  
> -	req->cmd_len = COMMAND_SIZE(cmd[0]);
> +	req->cmd_len = cmd_len;
>  	memcpy(req->cmd, cmd, req->cmd_len);
>  	req->sense = sioc->sense;
>  	req->sense_len = 0;
> diff -puN include/scsi/scsi_device.h~scsi_exec_async_vendor_fix include/scsi/scsi_device.h
> --- linux-2.6/include/scsi/scsi_device.h~scsi_exec_async_vendor_fix	2006-01-23 14:25:35.000000000 -0600
> +++ linux-2.6-bjking1/include/scsi/scsi_device.h	2006-01-23 14:26:47.000000000 -0600
> @@ -275,7 +275,7 @@ extern int scsi_execute_req(struct scsi_
>  			    int data_direction, void *buffer, unsigned bufflen,
>  			    struct scsi_sense_hdr *, int timeout, int retries);
>  extern int scsi_execute_async(struct scsi_device *sdev,
> -			      const unsigned char *cmd, int data_direction,
> +			      const unsigned char *cmd, int cmd_len, int data_direction,
>  			      void *buffer, unsigned bufflen, int use_sg,
>  			      int timeout, int retries, void *privdata,
>  			      void (*done)(void *, char *, int, int),
> diff -puN drivers/scsi/scsi_error.c~scsi_exec_async_vendor_fix drivers/scsi/scsi_error.c
> --- linux-2.6/drivers/scsi/scsi_error.c~scsi_exec_async_vendor_fix	2006-01-23 14:28:09.000000000 -0600
> +++ linux-2.6-bjking1/drivers/scsi/scsi_error.c	2006-01-23 14:28:20.000000000 -0600
> @@ -1350,7 +1350,7 @@ static void scsi_eh_lock_door(struct scs
>  	cmnd[4] = SCSI_REMOVAL_PREVENT;
>  	cmnd[5] = 0;
>  
> -	scsi_execute_async(sdev, cmnd, DMA_NONE, NULL, 0, 0, 10 * HZ,
> +	scsi_execute_async(sdev, cmnd, 6, DMA_NONE, NULL, 0, 0, 10 * HZ,
>  			   5, NULL, NULL, GFP_KERNEL);
>  }
>  
> diff -puN drivers/scsi/sg.c~scsi_exec_async_vendor_fix drivers/scsi/sg.c
> --- linux-2.6/drivers/scsi/sg.c~scsi_exec_async_vendor_fix	2006-01-23 14:28:12.000000000 -0600
> +++ linux-2.6-bjking1/drivers/scsi/sg.c	2006-01-23 14:30:49.000000000 -0600
> @@ -741,7 +741,7 @@ sg_common_write(Sg_fd * sfp, Sg_request 
>  	hp->duration = jiffies_to_msecs(jiffies);
>  /* Now send everything of to mid-level. The next time we hear about this
>     packet is when sg_cmd_done() is called (i.e. a callback). */
> -	if (scsi_execute_async(sdp->device, cmnd, data_dir, srp->data.buffer,
> +	if (scsi_execute_async(sdp->device, cmnd, hp->cmd_len, data_dir, srp->data.buffer,
>  				hp->dxfer_len, srp->data.k_use_sg, timeout,
>  				SG_DEFAULT_RETRIES, srp, sg_cmd_done,
>  				GFP_ATOMIC)) {
> diff -puN drivers/scsi/st.c~scsi_exec_async_vendor_fix drivers/scsi/st.c
> --- linux-2.6/drivers/scsi/st.c~scsi_exec_async_vendor_fix	2006-01-23 14:28:15.000000000 -0600
> +++ linux-2.6-bjking1/drivers/scsi/st.c	2006-01-23 14:32:18.000000000 -0600
> @@ -508,7 +508,7 @@ st_do_scsi(struct st_request * SRpnt, st
>  	STp->buffer->cmdstat.have_sense = 0;
>  	STp->buffer->syscall_result = 0;
>  
> -	if (scsi_execute_async(STp->device, cmd, direction,
> +	if (scsi_execute_async(STp->device, cmd, COMMAND_SIZE(cmd[0]), direction,
>  			&((STp->buffer)->sg[0]), bytes, (STp->buffer)->sg_segs,
>  			       timeout, retries, SRpnt, st_sleep_done, GFP_KERNEL)) {
>  		/* could not allocate the buffer or request was too large */
> _
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

