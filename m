From: Benny Halevy <bhalevy@panasas.com>
Subject: Re: [PATCH 27/32] scsi_data_buffer
Date: Thu, 18 Oct 2007 08:59:58 +0200
Message-ID: <4717046E.9040101@panasas.com>
References: <47164306.6090702@panasas.com> <4716529B.7020107@panasas.com> <20071018004722.GA14883@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:10352 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758278AbXJRHA6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 18 Oct 2007 03:00:58 -0400
In-Reply-To: <20071018004722.GA14883@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Boaz Harrosh <bharrosh@panasas.com>, James Bottomley <James.Bottomley@SteelEye.com>, Jens Axboe <jens.axboe@oracle.com>, FUJITA Tomonori <tomof@acm.org>, Matthew Dharm <mdharm-scsi@one-eyed-alien.net>, Russell King <rmk@arm.linux.org.uk>, Alan Stern <stern@rowland.harvard.edu>, "David S. Miller" <davem@davemloft.net>, Christoph Hellwig <hch@infradead.org>, linux-scsi <linux-scsi@vger.kernel.org>, Pete Wyckoff <pw@osc.edu>

On Oct. 18, 2007, 2:47 +0200, Matthew Wilcox <matthew@wil.cx> wrote:
> On Wed, Oct 17, 2007 at 08:21:15PM +0200, Boaz Harrosh wrote:
>>   - Group all IO members of scsi_cmnd into a scsi_data_buffer
>>     structure.
> 
>> +struct scsi_data_buffer {
>> +	unsigned length;
>> +	int resid;
>> +	unsigned short sg_count;
>> +	unsigned short alloc_sg_count;
>> +	struct scatterlist* sglist;
>> +};
> 
> This has exactly the problems I thought it would have.  Due to alignment
> rules, it grows the scsi_cmnd from 368 to 376 bytes on x86-64.
> It remains at 272 bytes on i386 though, which is some consolation.
> By porting the patch I had for shrinking the scsi_cmnd, I can get it
> down to 352 bytes, but not as far as the 344 bytes I had it at before.
> 
> The problem is the padding at the *end* of scsi_data_buffer (er, after I
> rearrange it in the patch below).  There's nothing we can realistically
> put in it, given that we don't want to expand scsi_data_buffer's size on
> 32-bit machines.  I have a fix ... but I don't think you'll like it.
> I certainly don't.  But it does get us back down to 344 bytes.
> 
> Updated patch below.  I'm fully expecting the 'result' shenanigan to get
> it NACKed, but I'd like to see if it inspires anyone else to a more
> creative way of saving this space.


yeah. The sglist pointer shuffle makes sense and so are the field type
changes and coalescing, but the union holding the deprecated fields
of scsi_data_buff is going away.

#pragma pack(4) before struct scsi_cmnd
(followed by #pragma pack()) should do the trick 
by saving member padding bytes. As a general rule I don't like pragma's
but this one works, is easy to understand, and is pretty standard.

> 
> ---
> 
> Thanks to acme's pahole utility, I found some places where we can save
> a lot of bytes in scsi_cmnd, just by rearranging struct elements and
> reducing the size of some elements.  We go from 272 to 260 bytes on x86
> and from 368 to 344 bytes on x86-64.
> 
>  - eh_eflags had a 4-byte hole after it on 64-bit.  In fact, this has
>    value 0 or 1, so reduce it to an unsigned char, and put it with the
>    other chars in scsi_cmnd.  Saves 8 bytes on 64-bit.
>  - sc_data_direction has a value from 0-3, so make it an unsigned char
>    rather than an enum.  Saves at least 4 bytes.
>  - Putting 'tag' with the other char elements saves another 4 bytes
>  - Moving 'result' into the union with the deprecated members saves 8
>    bytes on 64-bit.
> 
> diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
> index 047ffe6..2b10779 100644
> --- a/include/scsi/scsi_cmnd.h
> +++ b/include/scsi/scsi_cmnd.h
> @@ -13,22 +13,21 @@ struct Scsi_Host;
>  struct scsi_device;
>  
>  struct scsi_data_buffer {
> +	struct scatterlist* sglist;
>  	unsigned length;
>  	int resid;
>  	unsigned short sg_count;
>  	unsigned short alloc_sg_count;
> -	struct scatterlist* sglist;
>  };
>  
>  /* embedded in scsi_cmnd */
>  struct scsi_pointer {
>  	char *ptr;		/* data pointer */
> -	int this_residual;	/* left in this buffer */
>  	struct scatterlist *buffer;	/* which buffer */
> +	dma_addr_t dma_handle;
> +	int this_residual;	/* left in this buffer */
>  	int buffers_residual;	/* how many buffers left */
>  
> -        dma_addr_t dma_handle;
> -
>  	volatile int Status;
>  	volatile int Message;
>  	volatile int have_data_in;
> @@ -40,7 +39,6 @@ struct scsi_cmnd {
>  	struct scsi_device *device;
>  	struct list_head list;  /* scsi_cmnd participates in queue lists */
>  	struct list_head eh_entry; /* entry for the host eh_cmd_q */
> -	int eh_eflags;		/* Used by error handlr */
>  
>  	/*
>  	 * A SCSI Command is assigned a nonzero serial_number before passed
> @@ -64,7 +62,9 @@ struct scsi_cmnd {
>  	int timeout_per_command;
>  
>  	unsigned char cmd_len;
> -	enum dma_data_direction sc_data_direction;
> +	unsigned char eh_eflags;		/* Used by error handler */
> +	unsigned char sc_data_direction;	/* enum dma_data_direction */
> +	unsigned char tag;	/* SCSI-II queued command tag */
>  
>  	/* These elements define the operation we are about to perform */
>  #define MAX_COMMAND_SIZE	16
> @@ -109,10 +109,6 @@ struct scsi_cmnd {
>  					 * obtained by scsi_malloc is guaranteed
>  					 * to be at an address < 16Mb). */
>  
> -	int result;		/* Status code from lower level driver */
> -
> -	unsigned char tag;	/* SCSI-II queued command tag */
> -
>  	union {
>  		struct scsi_data_buffer sdb;
>  		/*
> @@ -121,11 +117,12 @@ struct scsi_cmnd {
>  		 *        of struct scsi_data_buffer members.
>  		 */
>  		struct {
> +			void __deprecated *request_buffer;
>  			unsigned __deprecated request_bufflen;
>  			int __deprecated resid;
>  			unsigned short __deprecated use_sg;
>  			unsigned short __deprecated place_holder_sg_alloc;
> -			void __deprecated *request_buffer;
> +			int result; /* Status code from lower level driver */
>  		};
>  	};
>  };
> 

