From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH] Save some bytes in scsi_cmnd by rearranging members
Date: Tue, 09 Oct 2007 11:42:43 +0200
Message-ID: <470B4D13.8000705@panasas.com>
References: <20071008235010.GZ12049@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:17811 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752542AbXJIJmq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Oct 2007 05:42:46 -0400
In-Reply-To: <20071008235010.GZ12049@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org

On Tue, Oct 09 2007 at 1:50 +0200, Matthew Wilcox <matthew@wil.cx> wrote:
> Thanks to acme's pahole utility, I found some places where we can save
> a lot of bytes in scsi_cmnd, just by rearranging struct elements and
> reducing the size of some elements.  We go from 272 to 260 bytes on x86
> and from 368 to 344 bytes on x86-64.
> 
>  - eh_eflags had a 4-byte hole after it on 64-bit.  In fact, this has
>    value 0 or 1, so reduce it to an unsigned char, and put it with the
>    other chars in scsi_cmnd.
>  - sc_data_direction has a value from 0-3, so make it an unsigned char
>    rather than an enum.  Saves at least 4 bytes.
>  - Putting 'tag' with the other char elements saves another 4 bytes
>  - Moving 'result' up from the end saves another 4 bytes on 64-bit
> 
> Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
> 
> diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
> index 65ab514..4a8c15f 100644
> --- a/include/scsi/scsi_cmnd.h
> +++ b/include/scsi/scsi_cmnd.h
> @@ -15,12 +15,10 @@ struct scsi_device;
>  /* embedded in scsi_cmnd */
>  struct scsi_pointer {
>  	char *ptr;		/* data pointer */
> -	int this_residual;	/* left in this buffer */
>  	struct scatterlist *buffer;	/* which buffer */
> +	dma_addr_t dma_handle;
> +	int this_residual;	/* left in this buffer */
>  	int buffers_residual;	/* how many buffers left */
> -
> -        dma_addr_t dma_handle;
> -
>  	volatile int Status;
>  	volatile int Message;
>  	volatile int have_data_in;
> @@ -32,7 +30,6 @@ struct scsi_cmnd {
>  	struct scsi_device *device;
>  	struct list_head list;  /* scsi_cmnd participates in queue lists */
>  	struct list_head eh_entry; /* entry for the host eh_cmd_q */
> -	int eh_eflags;		/* Used by error handlr */
>  
>  	/*
>  	 * A SCSI Command is assigned a nonzero serial_number before passed
> @@ -54,9 +51,12 @@ struct scsi_cmnd {
>  	int retries;
>  	int allowed;
>  	int timeout_per_command;
> +	int result;		/* Status code from lower level driver */
>  
>  	unsigned char cmd_len;
> -	enum dma_data_direction sc_data_direction;
> +	unsigned char eh_eflags;		/* Used by error handler */
> +	unsigned char sc_data_direction;
> +	unsigned char tag;			/* SCSI-II queued command tag */
>  
>  	/* These elements define the operation we are about to perform */
>  #define MAX_COMMAND_SIZE	16
> @@ -109,10 +109,6 @@ struct scsi_cmnd {
>  					 * to release this memory.  (The memory
>  					 * obtained by scsi_malloc is guaranteed
>  					 * to be at an address < 16Mb). */
> -
> -	int result;		/* Status code from lower level driver */
> -
> -	unsigned char tag;	/* SCSI-II queued command tag */
>  };
>  
>  extern struct scsi_cmnd *scsi_get_command(struct scsi_device *, gfp_t);
> 
Please don't do this patch for now. This is because of the 
soon to come scsi_data_buffer patch that rearages most of the members above
and puts them in a substructure. Maybe after the scsi_data_buffer patch you can
try to do this again.

Thanks
Boaz

