From: <Stuart_Hayes@Dell.com>
Subject: RE: [PATCH 2.6.11] ide-scsi: map sg buffers in idescsi_input/output_buffers() to kernel virtual address
Date: Wed, 16 Mar 2005 09:51:15 -0600
Message-ID: <7A8F92187EF7A249BF847F1BF4903C04010EEA11@ausx2kmpc103.aus.amer.dell.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Received: from ausc60pc101.us.dell.com ([143.166.85.206]:45659 "EHLO
	ausc60pc101.us.dell.com") by vger.kernel.org with ESMTP
	id S262630AbVCPPvw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Mar 2005 10:51:52 -0500
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Joshua_Giles@Dell.com, Stuart_Hayes@Dell.com, axboe@suse.de

Hayes, Stuart wrote:
> This patch will map the sg buffers to kernel virtual memory space in
> the functions idescsi_input_buffers() and idescsi_output_buffers(). 
> Without this patch, idescsi passes a null pointer to
> atapi_input_bytes() and atapi_output_bytes() when sg pages are in
> high memory (i686 architecture).   
> 
> I'm attaching as a file, too, as the text will certainly be wrapped.
> 
> (Sorry for the subject rename--I'm trying to use the correct format
> for patch emails.) 
> 
> Thanks
> Stuart

And, while there's another high memory/kmap patch question on this 
list...

Is there some reason nobody seems interested in this patch (except 
Jens--thanks for the help!)?  I'm kind of new to sending in patches, 
and I'm not sure if I'm just not waiting long enough, or if there is 
a problem with this patch... 

But really, we're getting a null pointer dereference oops when using 
ATAPI tape drives (with ide-scsi) without this patch...

Thanks!
Stuart

> 
> 
> Signed-off-by: Stuart Hayes <stuart_hayes@dell.com>
> 
> 
> --- linux-2.6.11.orig/drivers/scsi/ide-scsi.c	2005-03-09
> 14:13:48.000000000 -0500
> +++ linux-2.6.11.new/drivers/scsi/ide-scsi.c	2005-03-09
> 13:56:38.000000000 -0500
> @@ -143,6 +143,7 @@ static void idescsi_input_buffers (ide_d  {
>  	int count;
>  	char *buf;
> +	unsigned long flags;
> 
>  	while (bcount) {
>  		if (pc->sg - (struct scatterlist *)
> pc->scsi_cmd->request_buffer > pc->scsi_cmd->use_sg) {
> @@ -151,8 +152,11 @@ static void idescsi_input_buffers (ide_d
>  			return;
>  		}
>  		count = min(pc->sg->length - pc->b_count, bcount);
> -		buf = page_address(pc->sg->page) + pc->sg->offset;
> +		local_irq_save(flags);
> +		buf = kmap_atomic(pc->sg->page, KM_USER0) +
> pc->sg->offset;
>  		drive->hwif->atapi_input_bytes(drive, buf + pc->b_count,
count);
> +		kunmap_atomic(buf - pc->sg->offset, KM_USER0);
> +		local_irq_restore(flags);
>  		bcount -= count; pc->b_count += count;
>  		if (pc->b_count == pc->sg->length) {
>  			pc->sg++;
> @@ -165,6 +169,7 @@ static void idescsi_output_buffers (ide_  {
>  	int count;
>  	char *buf;
> +	unsigned long flags;
> 
>  	while (bcount) {
>  		if (pc->sg - (struct scatterlist *)
> pc->scsi_cmd->request_buffer > pc->scsi_cmd->use_sg) {
> @@ -173,8 +178,11 @@ static void idescsi_output_buffers (ide_
>  			return;
>  		}
>  		count = min(pc->sg->length - pc->b_count, bcount);
> -		buf = page_address(pc->sg->page) + pc->sg->offset;
> +		local_irq_save(flags);
> +		buf = kmap_atomic(pc->sg->page, KM_USER0) +
> pc->sg->offset;
>  		drive->hwif->atapi_output_bytes(drive, buf +
> pc->b_count, count);
> +		kunmap_atomic(buf - pc->sg->offset, KM_USER0);
> +		local_irq_restore(flags);
>  		bcount -= count; pc->b_count += count;
>  		if (pc->b_count == pc->sg->length) {
>  			pc->sg++;

