From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH RFC 0/4] use scatter lists for all block pc requests	and
 simplify hw handlers
Date: Mon, 06 Jun 2005 15:43:17 +1000
Message-ID: <42A3E275.6030106@torque.net>
References: <1117847972.23638.62.camel@mina>	 <1117901234.5005.9.camel@mulgrave>  <1117955727.4961.8.camel@mina>	 <1117982408.4990.12.camel@mulgrave> <1117998665.4990.17.camel@mulgrave>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zorg.st.net.au ([203.16.233.9]:50911 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S261181AbVFFFm5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Jun 2005 01:42:57 -0400
In-Reply-To: <1117998665.4990.17.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, device-mapper development <dm-devel@redhat.com>, linux-scsi <linux-scsi@vger.kernel.org>, Jens Axboe <axboe@suse.de>

James Bottomley wrote:
> On Sun, 2005-06-05 at 09:40 -0500, James Bottomley wrote:
> 
>>Finally, there's coming up with a replacement API for scsi_do_req that
>>returns via the end_io callback ... since that doesn't do a wait/wake,
>>perhaps this should be the core API upon which the others are built?
> 
> 
> OK, well, the API is easy ... it's attached.  Converting sg and st to
> use it is quite another matter.  sg in particular is a nasty tangle when
> it comes to doing its own sg mapping, which the block layer will now do
> for it.
> 
> James
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -177,6 +177,23 @@ int scsi_queue_insert(struct scsi_cmnd *
>  	return 0;
>  }
>  
> +struct scsi_do_req_cb {
> +	void (*done)(void *, int);
> +	void *data;
> +};
> +
> +static void scsi_do_req_end_io(struct request *req)
> +{
> +	int result = req->errors;
> +	struct scsi_do_req_cb *cb = req->end_io_data;
> +	
> +	BUG_ON(cb == NULL);
> +	if (result)
> +		result |= DRIVER_ERROR << 24;
> +	blk_put_request(req);
> +	cb->done(cb->data, result);
> +	kfree(cb);
> +}
>  /*
>   * Function:    scsi_do_req
>   *
> @@ -203,38 +220,49 @@ int scsi_queue_insert(struct scsi_cmnd *
>   *		now inject requests on the *head* of the device queue
>   *		rather than the tail.
>   */
> -void scsi_do_req(struct scsi_request *sreq, const void *cmnd,
> -		 void *buffer, unsigned bufflen,
> -		 void (*done)(struct scsi_cmnd *),
> -		 int timeout, int retries)
> +void scsi_do_command(struct scsi_device *sdev, const void *cmnd, int cmd_len,
> +		     void *buffer, unsigned bufflen, void *data,
> +		     void (*done)(void *, int),
> +		     char *sense_buffer, int timeout, int retries,
> +		     enum dma_data_direction dir)

James,
There is no max_length on sense_buffer. How does one
know how much, if any, sense data was written (returned).
resid is a very useful return parameter.
Perhaps the *done() callback should have
two more arguments (and scsi_do_command()
one more argument). And 'buffer' and 'bufflen' have
not changed in name but I assume they have in nature.

Additionally perhaps it is time to start thinking about
a clean pass through. Something that can pass a packet
command (like sg can at the moment) but to a scsi_host
(or a transport host). An additional argument would be
needed to pass addressing information to the LLD. I'm
thinking about the SAS Serial Management Protocol (SMP)
that has nothing to do with the block layer or the
SCSI mid level. We want to bind to a SAS host (initiator
port) and supply a SAS address (of the SMP target
which is most likely an expander).

Doug Gilbert
